module AggregateStreams
  module Handle
    TransformError = Class.new(RuntimeError)

    def self.included(cls)
      cls.class_exec do
        include Messaging::Handle
        include Messaging::StreamName

        include Log::Dependency

        prepend Configure

        extend StoreClass
        extend CategoryMacro
        extend TransformMacro
        extend SnapshotIntervalMacro

        const_set :Store, store_class

        dependency :store, self::Store
        dependency :write, MessageStore::Postgres::Write

        virtual :transform do |write_message_data|
          write_message_data
        end
      end
    end

    def handle(message_data)
      logger.trace { "Handling message (Stream: #{message_data.stream_name}, Global Position: #{message_data.global_position})" }

      stream_id = Messaging::StreamName.get_id(message_data.stream_name)

      aggregation, version = store.fetch(stream_id, include: :version)

      if aggregation.processed?(message_data)
        logger.info(tag: :ignored) { "Message already handled (Stream: #{message_data.stream_name}, Global Position: #{message_data.global_position})" }
        return
      end

      input_metadata = Messaging::Message::Metadata.build(message_data.metadata)
      output_metadata = Messaging::Message::Metadata.build

      output_metadata.follow(input_metadata)

      output_metadata = output_metadata.to_h
      output_metadata.delete_if { |_, v| v.nil? }

      write_message_data = MessageStore::MessageData::Write.new

      SetAttributes.(write_message_data, message_data, copy: [:type, :data])

      write_message_data.metadata = output_metadata

      write_message_data = transform(write_message_data)

      if write_message_data
        assure_message_data(write_message_data)
      else
        logger.info(tag: :ignored) { "Message ignored (Stream: #{message_data.stream_name}, Global Position: #{message_data.global_position})" }
        return
      end

      logger.info do
        message_type = message_data.type
        unless write_message_data.type == message_type
          message_type = "#{write_message_data.type} ← #{message_type}"
        end

        "Message copied (Message Type: #{message_type}, Stream: #{message_data.stream_name}, Global Position: #{message_data.global_position})"
      end

      Try.(MessageStore::ExpectedVersion::Error) do
        stream_name = stream_name(stream_id)
        write.(write_message_data, stream_name, expected_version: version)
      end
    end

    def assure_message_data(message_data)
      unless message_data.instance_of?(MessageStore::MessageData::Write)
        raise TransformError, "Not an instance of MessageData::Write"
      end
    end

    module Configure
      def configure(session: nil)
        self.class::Store.configure(self, session: session)
        MessageStore::Postgres::Write.configure(self, session: session)
      end
    end

    module StoreClass
      def store_class
        @store_class ||= Class.new do
          include Store
        end
      end
      alias_method :store_cls, :store_class
    end

    module CategoryMacro
      def category_macro(category)
        super(category)

        store_class.category_macro(category)
      end
      alias_method :category, :category_macro
    end

    module TransformMacro
      def transform_macro(&transform_action)
        define_method(:transform, &transform_action)
      end
      alias_method :transform, :transform_macro
    end

    module SnapshotIntervalMacro
      def snapshot_interval_macro(interval)
        store_class.snapshot(EntitySnapshot::Postgres, interval: interval)
      end
      alias_method :snapshot_interval, :snapshot_interval_macro
    end
  end
end
