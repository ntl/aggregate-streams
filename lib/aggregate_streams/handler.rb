module AggregateStreams
  module Handler
    def self.included(cls)
      cls.class_exec do
        include Messaging::Handle
        include Messaging::StreamName

        prepend Configure

        extend StoreClass
        extend CategoryMacro
        extend HandleMacro
        extend SnapshotIntervalMacro

        const_set :Store, store_class

        dependency :store, self::Store
        dependency :write, MessageStore::Postgres::Write

        virtual :handle_action do |write_message_data|
          write_message_data
        end
      end
    end

    def handle(message_data)
      stream_id = Messaging::StreamName.get_id(message_data.stream_name)

      aggregation, version = store.fetch(stream_id, include: :version)

      return if aggregation.processed?(message_data)

      input_metadata = Messaging::Message::Metadata.build(message_data.metadata)
      output_metadata = Messaging::Message::Metadata.build

      output_metadata.follow(input_metadata)

      output_metadata = output_metadata.to_h
      output_metadata.delete_if { |_, v| v.nil? }

      write_message_data = MessageStore::MessageData::Write.new

      SetAttributes.(write_message_data, message_data, copy: [:type, :data])

      write_message_data.metadata = output_metadata

      write_message_data = handle_action(write_message_data)

      if write_message_data.nil?
        return
      end

      Try.(MessageStore::ExpectedVersion::Error) do
        stream_name = stream_name(stream_id)
        write.(write_message_data, stream_name, expected_version: version)
      end
    end

    def transform(write_message_data)
      write_message = false

      transform_action(write_message_data)

      write_message = true
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

    module HandleMacro
      def handle_macro(&handle_action)
        define_method(:handle_action, &handle_action)
      end
      alias_method :handle, :handle_macro
    end

    module SnapshotIntervalMacro
      def snapshot_interval_macro(interval)
        store_class.snapshot(EntitySnapshot::Postgres, interval: interval)
      end
      alias_method :snapshot_interval, :snapshot_interval_macro
    end
  end
end
