require_relative '../automated_init'

context "Handler" do
  context "Writer Session" do
    consumer_session = MessageStore::Postgres::Session.new

    context "Declared" do
      session = MessageStore::Postgres::Session.new

      handler_class = Controls::Handler.example_class do
        writer_session do
          session
        end
      end

      handler = handler_class.build(session: consumer_session)

      context "Writer Dependency" do
        writer = handler.write

        test "Writer session is assigned, not the consumer session" do
          assert(writer.put.session.equal?(session))
        end
      end

      context "Store Dependency" do
        store = handler.store

        test "Writer session is assigned, not the consumer session" do
          assert(store.session.equal?(session))
        end
      end
    end

    context "Not Declared" do
      handler_class = Controls::Handler.example_class

      handler = handler_class.build(session: consumer_session)

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
