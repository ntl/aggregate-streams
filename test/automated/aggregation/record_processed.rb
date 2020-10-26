require_relative '../automated_init'

context "Aggregation" do
  context "Record Processed" do
    message_1 = Controls::MessageData::Output.example
    message_2 = Controls::MessageData::Output.alternate

    aggregation = AggregateStreams::Aggregation.new

    aggregation.record_processed(message_1)
    aggregation.record_processed(message_2)

    context "First Message" do
      causation_message_category = Controls::StreamName::Input.category
      causation_message_global_position = Controls::Position::Global.example

      position = aggregation.positions[causation_message_category]

      test "Is the causation message global position" do
        assert(position == causation_message_global_position)
      end
    end

    context "Second Message" do
      causation_message_category = Controls::StreamName::Input::Alternate.category
      causation_message_global_position = Controls::Position::Global.alternate

      position = aggregation.positions[causation_message_category]

      test "Is the other causation message global position" do
        assert(position == causation_message_global_position)
      end
    end
  end
end
