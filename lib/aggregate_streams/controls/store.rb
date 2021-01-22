module AggregateStreams
  module Controls
    module Store
      def self.example(category: nil, snapshot_interval: nil)
        if category == :none
          category = nil
        else
          category ||= self.category
        end

        snapshot_interval ||= self.snapshot_interval

        AggregateStreams::Store.build(category: category, snapshot_interval: snapshot_interval)
      end

      def self.category
        StreamName::Output::Category.internal
      end

      def self.snapshot_interval
        11
      end
    end
  end
end
