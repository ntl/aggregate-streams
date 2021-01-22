require_relative '../automated_init'

context "Handler" do
  context "Category" do
    context "Given" do
      category = Controls::Category.example

      handler = Controls::Handler.example(category: category)

      test "Category is assigned to the handler" do
        assert(handler.category == category)
      end

      test "Category is assigned to the handler's store" do
        assert(handler.store.category == category)
      end
    end

    context "Omitted" do
      context "Build" do
        test "Is an error" do
          assert_raises(EntityStore::Error) do
            Controls::Handler.example(category: :none)
          end
        end
      end
    end
  end
end
