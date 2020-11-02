require_relative '../automated_init'

context "Handler" do
  context "Already Copied" do
    message = Controls::MessageData::Input.example
    stream_id = Messaging::StreamName.get_id(message.stream_name)

    handler = Controls::Handler.example

    handler.(message)

    aggregate_stream = handler.stream_name(stream_id)
    copied_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)
    refute(copied_message.nil?)

    handler.(message)

    last_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)

    test "Message is not copied again" do
      detail "Copied Message: #{copied_message.global_position}"
      detail "Last Message: #{last_message.global_position}"

      assert(last_message.id == copied_message.id)
    end
  end
end
