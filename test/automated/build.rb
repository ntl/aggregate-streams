require_relative './automated_init'

context "Build" do
  category = Controls::Category.example
  output_category = Controls::Category.example(randomize_category: true)

  writer_session = MessageStore::Postgres::Session.build

  consumer = AggregateStreams::Consumer.build(category, output_category: output_category, output_session: writer_session)

  context "Position Store's Session" do
    position_store_session = consumer.position_store.session

    test "Is the writer's session" do
      assert(position_store_session.equal?(writer_session))
    end

    test "Isn't the consumer's session" do
      refute(position_store_session.equal?(consumer.session))
    end
  end
end
