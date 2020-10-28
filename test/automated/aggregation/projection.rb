require_relative '../automated_init'

context "Aggregation" do
  context "Projection" do
    message = Controls::MessageData::Output.example

    aggregation = AggregateStreams::Aggregation.new

    AggregateStreams::Projection.(aggregation, message)

    context "Position" do
      causation_message_category = Controls::StreamName::Input.category
      causation_message_global_position = Controls::Position::Global.example

      position = aggregation.positions[causation_message_category]

      test "Updated" do
        assert(position == causation_message_global_position)
      end
    end
  end
end
