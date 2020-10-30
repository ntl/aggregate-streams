require_relative '../automated_init'

context "Handler" do
  context "Message Copied" do
    output_stream = Controls::StreamName.example

    handler = AggregateStreams::Handler.new(output_stream)
    handler.configure

    message = Controls::MessageData::Input.example
    handler.(message)

    copied_message = MessageStore::Postgres::Get::Stream::Last.(output_stream)

    test "Copies message to output stream" do
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
