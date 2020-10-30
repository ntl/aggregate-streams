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
      causation_message_global_position = Controls::Position::Global::Causation.example

      sequence = aggregation.sequence(causation_message_category)

      test "Sequence set to the causation message global position" do
        assert(sequence == causation_message_global_position)
      end
    end

    context "Second Message" do
      causation_message_category = Controls::StreamName::Input::Alternate.category
      causation_message_global_position = Controls::Position::Global::Causation.alternate

      sequence = aggregation.sequence(causation_message_category)

      test "Sequence set to the other causation message global position" do
        assert(sequence == causation_message_global_position)
      end
    end
  end
end
