module AggregateStreams
  class Handler
    include Messaging::Handle
    include Initializer

    dependency :write, MessageStore::Postgres::Write

    initializer :output_stream

    def configure(session: nil)
      MessageStore::Postgres::Write.configure(self)
    end

    def handle(message_data)
      input_metadata = Messaging::Message::Metadata.build(message_data.metadata)
      output_metadata = Messaging::Message::Metadata.build

      output_metadata.follow(input_metadata)

      output_metadata = output_metadata.to_h
      output_metadata.delete_if { |_, v| v.nil? }

      output_message_data = MessageStore::MessageData::Write.new

      SetAttributes.(output_message_data, message_data, copy: [:type, :data])

      output_message_data.metadata = output_metadata

      write.(output_message_data, output_stream)
    end
  end
end
