require_relative '../automated_init'

context "Handler" do
  context "Optional Writer Session" do
    consumer_session = MessageStore::Postgres::Session.new

    context "Given" do
      writer_session = MessageStore::Postgres::Session.new

      handler = Controls::Handler.example(session: consumer_session, writer_session: writer_session)

      context "Writer Dependency" do
        writer = handler.write

        test "Writer session is assigned" do
          assert(writer.put.session.equal?(writer_session))
        end
      end

      context "Store Dependency" do
        store = handler.store

        test "Writer session is assigned" do
          assert(store.session.equal?(writer_session))
        end
      end
    end

    context "Omitted" do
      handler = Controls::Handler.example(session: consumer_session)

      context "Writer Dependency" do
        writer = handler.write

        test "Consumer session is assigned" do
          assert(writer.put.session.equal?(consumer_session))
        end
      end

      context "Store Dependency" do
        store = handler.store

        test "Consumer session is assigned" do
          assert(store.session.equal?(consumer_session))
        end
      end
    end
  end
end
