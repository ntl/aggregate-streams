require_relative '../automated_init'

context "Handler" do
  context "Expected Version Error" do
    message = Controls::MessageData::Input.example
    stream_id = Messaging::StreamName.get_id(message.stream_name)

    handler = Controls::Handler.example

    aggregate_stream = handler.stream_name(stream_id)

    MessageStore::Postgres::Write.(Controls::MessageData::Output.alternate, aggregate_stream)

    Dependency::Substitute.(:store, handler)

    test "Not rescued" do
      assert_raises(MessageStore::ExpectedVersion::Error) do
        handler.(message)
      end
    end

    context "Message Copy" do
      copied_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)

      test "Not copied" do
        refute(copied_message.data == message.data)
      end
    end
  end
end
