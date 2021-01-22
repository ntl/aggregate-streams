require_relative '../../automated_init'

context "Handler" do
  context "Transform" do
    context "Return Value Assurance" do
      message = Controls::MessageData::Input.example(type: 'SomeMessage')
      stream_id = Messaging::StreamName.get_id(message.stream_name)

      context "Correct" do
        context "Block Provides a Message" do
          handler = Controls::Handler.example do |msg|
            msg
          end

          test "Is not an error" do
            refute_raises(AggregateStreams::Handle::TransformError) do
              handler.(message)
            end
          end
        end

        context "Block Provides Nothing" do
          handler = Controls::Handler.example do |msg|
            nil
          end

          test "Is not an error" do
            refute_raises(AggregateStreams::Handle::TransformError) do
              handler.(message)
            end
          end
        end

        context "Block Provides False" do
          handler = Controls::Handler.example do |msg|
            false
          end

          test "Is not an error" do
            refute_raises(AggregateStreams::Handle::TransformError) do
              handler.(message)
            end
          end
        end
      end

      context "Incorrect" do
        handler = Controls::Handler.example do |msg|
          'some-string'
        end

        test "Is an error" do
          assert_raises(AggregateStreams::Handle::TransformError) do
            handler.(message)
          end
        end
      end
    end
  end
end
