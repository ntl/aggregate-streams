require_relative '../automated_init'

context "Handler" do
  context "Message Copied" do
    message = Controls::MessageData::Input.example
    stream_id = Messaging::StreamName.get_id(message.stream_name)

    handler = Controls::Handler.example

    handler.(message)

    aggregate_stream = handler.stream_name(stream_id)
    copied_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)

    test "Copies message to aggregate stream" do
      refute(copied_message.nil?)
    end or break

    context "Copied Message" do
      test "Type" do
        assert(copied_message.type == message.type)
      end

      test "Data" do
        assert(copied_message.data == message.data)
      end

      context "Metadata" do
        input_metadata = Messaging::Message::Metadata.build(message.metadata)
        copied_metadata = Messaging::Message::Metadata.build(copied_message.metadata)

        test "Copied message follows input message" do
          assert(copied_metadata.follows?(input_metadata))
        end
      end
    end
  end
end
