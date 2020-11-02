require_relative '../automated_init'

context "Handler" do
  context "Snapshot Declaration" do
    context "Snapshot are Enabled" do
      snapshot_interval = 11

      handler = Controls::Handler.example(snapshot_interval: snapshot_interval)

      test "Snapshot class is set on store" do
        assert(handler.store.snapshot_class == EntitySnapshot::Postgres)
      end

      test "Snapshot interval" do
        assert(handler.store.snapshot_interval == snapshot_interval)
      end
    end

    context "Snapshots are not Enabled" do
      handler = Controls::Handler.example(snapshot: false)

      test "Snapshot class is not set on store" do
        assert(handler.store.snapshot_class.nil?)
      end
    end
  end
end
