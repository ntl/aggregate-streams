require_relative '../automated_init'

context "Store" do
  context "Snapshot Declaration" do
    context "Snapshot are Enabled" do
      store = Controls::Store.example(snapshot: true)

      test "Snapshot class is set" do
        assert(store.snapshot_class == EntitySnapshot::Postgres)
      end
    end

    context "Snapshots are not Enabled" do
      store = Controls::Store.example(snapshot: false)

      test "Snapshot class is not set" do
        assert(store.snapshot_class.nil?)
      end
    end
  end
end
