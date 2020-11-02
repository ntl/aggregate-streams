require_relative '../automated_init'

context "Store" do
  context "Snapshots" do
    aggregate_stream = Controls::StreamName::Output.example
    category = Messaging::StreamName.get_category(aggregate_stream)

    message_1 = Controls::MessageData::Output.example
    message_2 = Controls::MessageData::Output.alternate

    MessageStore::Postgres::Write.([message_1, message_2], aggregate_stream)

    store = Controls::Store.example(category: category, snapshot_interval: 1)

    stream_id = Messaging::StreamName.get_id(aggregate_stream)

    context "Retrieve Entity After Snapshot Interval Exceeded" do
      read_entity = store.fetch(stream_id)

      context "Snapshot Entity" do
        snapshot_entity, * = store.cache.external_store.get(stream_id)

        test "Is the retrieved entity" do
          assert(snapshot_entity == read_entity)
        end
      end
    end
  end
end
