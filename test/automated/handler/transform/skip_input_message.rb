require_relative '../../automated_init'

context "Handler" do
  context "Transform" do
    context "Skip Input Message" do
      message = Controls::MessageData::Input.example
      stream_id = Messaging::StreamName.get_id(message.stream_name)

      handler = Controls::Handler.example do |_|
        transform do |msg|
          #
        end
      end

      handler.(message)

      aggregate_stream = handler.stream_name(stream_id)
      copied_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)

      test "Does not copy message to aggregate stream" do
        assert(copied_message.nil?)
      end
    end
  end
end
