require_relative '../../automated_init'

context "Handler" do
  context "Transform" do
    context "Rename Message Type" do
      message = Controls::MessageData::Input.example(type: 'SomeMessage')
      stream_id = Messaging::StreamName.get_id(message.stream_name)

      handler = Controls::Handler.example do |_|
        transform do |msg|
          msg.type = 'OtherMessage'
          msg
        end
      end

      handler.(message)

      aggregate_stream = handler.stream_name(stream_id)
      copied_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)

      refute(copied_message.nil?)

      message_type_transformed = copied_message.type == 'OtherMessage'

      test "Message type is transformed" do
        assert(message_type_transformed)
      end
    end
  end
end
