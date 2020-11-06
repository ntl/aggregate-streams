require_relative '../automated_init'

context "Position Store" do
  context "Get" do
    output_category = Controls::Category.example

    context "Output Category is Empty" do
      input_category = Controls::StreamName::Input::Category.example

      position_store = AggregateStreams::PositionStore.build(input_category, output_category)

      position = position_store.get

      test "Returns nothing" do
        assert(position.nil?)
      end
    end

    context "Output Category Contains Messages Caused by Given Category" do
      input_category = Controls::StreamName::Input::Category.example

      message_1 = Controls::MessageData::Output.example(causation_message_category: input_category)
      message_2 = Controls::MessageData::Output.example(causation_message_category: input_category)
      message_3 = Controls::MessageData::Output.example(causation_message_category: Controls::StreamName::Input::Alternate::Category.example)

      MessageStore::Postgres::Write.([message_1, message_2, message_3], output_category)

      position_store = AggregateStreams::PositionStore.build(input_category, output_category)

      position = position_store.get

      causation_message_global_position = message_2.metadata[:causation_message_global_position] or fail
      control_position = causation_message_global_position + 1

      test "Next position after the causation message global position" do
        detail "Position: #{position}"
        comment "Control Position: #{position}"

        assert(position == control_position)
      end
    end
  end
end
