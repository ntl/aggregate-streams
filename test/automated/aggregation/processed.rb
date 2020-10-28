require_relative '../automated_init'

context "Aggregation" do
  context "Processed Predicate" do
    message = Controls::MessageData::Input.example
    message_sequence = message.global_position

    context "Processed" do
      context "Aggregation Sequence is Equal To Message Sequence" do
        aggregation = Controls::Aggregation.example(sequence: message_sequence)

        processed = aggregation.processed?(message)

        test do
          assert(processed)
        end
      end

      context "Aggregation Sequence is Greater Than Message Sequence" do
        aggregation = Controls::Aggregation.example(sequence: message_sequence + 1)

        processed = aggregation.processed?(message)

        test do
          assert(processed)
        end
      end
    end

    context "Not Processed" do
      context "Aggregation Sequence is Not Set" do
        aggregation = Controls::Aggregation.example(sequence: :none)

        processed = aggregation.processed?(message)

        test do
          refute(processed)
        end
      end

      context "Aggregation Sequence is Less Than Message Sequence" do
        aggregation = Controls::Aggregation.example(sequence: message_sequence - 1)

        processed = aggregation.processed?(message)

        test do
          refute(processed)
        end
      end
    end
  end
end
