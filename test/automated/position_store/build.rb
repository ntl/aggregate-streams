require_relative '../automated_init'

context "Position Store" do
  context "Build" do
    input_category = Controls::StreamName::Input::Category.example
    output_category = Controls::Category.example

    session = MessageStore::Postgres::Session.build

    position_store = AggregateStreams::PositionStore.build(input_category, output_category, session: session)

    test "Input category" do
      assert(position_store.input_category == input_category)
    end

    test "Output category" do
      assert(position_store.output_category == output_category)
    end

    test "Session dependency" do
      assert(position_store.session.eql?(session))
    end
  end
end
