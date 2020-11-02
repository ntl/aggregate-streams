require_relative '../automated_init'

context "Store" do
  context "Category Declaration" do
    context "Category is Declared" do
      category = Controls::Category.example

      store = Controls::Store.example(category: category)

      test "Category is assigned to the store" do
        assert(store.category == category)
      end
    end

    context "Category is Not Declared" do
      context "Build" do
        test "Is an error" do
          assert_raises(EntityStore::Error) do
            Controls::Store.example(category: :none)
          end
        end
      end
    end
  end
end
