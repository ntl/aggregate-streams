require_relative '../automated_init'

context "Handler" do
  context "Optional Snapshot Interval" do
    context "Given" do
      snapshot_interval = 11

      handler = Controls::Handler.example(snapshot_interval: snapshot_interval)

      test "Snapshot interval" do
        assert(handler.store.snapshot_interval == snapshot_interval)
      end
    end

    context "Omitted" do
      handler = Controls::Handler.example

      test "Snapshot interval" do
        refute(handler.store.snapshot_interval.nil?)
      end
    end
  end
end
