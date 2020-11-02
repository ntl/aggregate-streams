require_relative '../automated_init'

context "Handler" do
  context "Already Copied" do
    output_stream = Controls::StreamName.example

    handler = AggregateStreams::Handler.new(output_stream)
    handler.configure

    message = Controls::MessageData::Input.example
    handler.(message)

    copied_message = MessageStore::Postgres::Get::Stream::Last.(output_stream)

    handler.(message)

    last_message = MessageStore::Postgres::Get::Stream::Last.(output_stream)

    test "Message is not copied again" do
      detail "Copied Message: #{copied_message.global_position}"
      detail "Last Message: #{last_message.global_position}"

      assert(last_message.id == copied_message.id)
    end
  end
end
