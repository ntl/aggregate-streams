require_relative '../automated_init'

context "Aggregation" do
  context "Transformation" do
    aggregation = Controls::Aggregation.example

    raw_data = nil

    context "Write Raw Data" do
      raw_data = Transform::Write.raw_data(aggregation)

      test "Is a hash" do
        assert(raw_data.instance_of?(Hash))
      end
    end

    context "Read Raw Data" do
      read_aggregation = Transform::Read.instance(raw_data, AggregateStreams::Aggregation)

      test "Is the original instance that was written" do
        assert(read_aggregation == aggregation)
      end
    end
  end
end
