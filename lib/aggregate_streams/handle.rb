module AggregateStreams
  class Handle
    include Messaging::Handle
    include Messaging::StreamName

    include Log::Dependency

    TransformError = Class.new(RuntimeError)

    setting :category
    setting :snapshot_interval
    setting :writer_session
    setting :transform_action

    dependency :store, Store
    dependency :write, MessageStore::Postgres::Write

    def configure(session: nil)
      writer_session = self.writer_session
      writer_session ||= session

      Store.configure(self, category: category, session: writer_session, snapshot_interval: snapshot_interval)

      MessageStore::Postgres::Write.configure(self, session: writer_session)
    end

    def handle(message_data)
      logger.trace { "Handling message (Stream: #{message_data.stream_name}, Global Position: #{message_data.global_position})" }

      stream_id = Messaging::StreamName.get_id(message_data.stream_name)

      aggregation, version = store.fetch(stream_id, include: :version)

      if aggregation.processed?(message_data)
        logger.info(tag: :ignored) { "Message already handled (Stream: #{message_data.stream_name}, Global Position: #{message_data.global_position})" }
        return
      end

      raw_input_data = Messaging::Message::Transform::MessageData.read(message_data)
      input_metadata = Messaging::Message::Metadata.build(raw_input_data[:metadata])

      output_metadata = raw_metadata(input_metadata)

      write_message_data = MessageStore::MessageData::Write.new

      SetAttributes.(write_message_data, message_data, copy: [:type, :data])

      write_message_data.metadata = output_metadata

      input_category = Messaging::StreamName.get_category(message_data.stream_name)
      write_message_data = transform(write_message_data, input_category)

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

    def raw_metadata(metadata)
      output_metadata = Messaging::Message::Metadata.build

      output_metadata.follow(metadata)

      output_metadata = output_metadata.to_h

      output_metadata.delete(:local_properties)

      if output_metadata[:properties].empty?
        output_metadata.delete(:properties)
      end

      output_metadata.delete_if { |_, v| v.nil? }

      output_metadata
    end

    def transform(write_message_data, stream_name)
      if transform_action.nil?
        write_message_data
      else
        transform_action.(write_message_data, stream_name)
      end
    end

    def assure_message_data(message_data)
      unless message_data.instance_of?(MessageStore::MessageData::Write)
        raise TransformError, "Not an instance of MessageData::Write"
      end
    end
  end
end
