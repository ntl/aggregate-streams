require_relative '../../automated_init'

context "Handler" do
  context "Transform" do
    context "Block Arguments" do
      message = Controls::MessageData::Input.example(type: 'SomeMessage')

      input_category = Messaging::StreamName.get_category(message.stream_name)

      block_args = []

      handler = Controls::Handler.example do |_|
        transform do |msg, input_category|
          block_args << msg
          block_args << input_category

          msg
        end
      end

      handler.(message)

      test "First argument: message" do
        assert(block_args[0].data == message.data)
      end

      test "Second argument: input stream category" do
        assert(block_args[1] == input_category)
      end
    end
  end
end
