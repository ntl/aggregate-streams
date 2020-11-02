module AggregateStreams
  module Controls
    module Handler
      def self.example(category: nil, snapshot: nil, snapshot_interval: nil)
        if category.nil? && snapshot.nil? && snapshot_interval.nil?
          cls = Example
        else
          cls = example_class(category: category, snapshot: snapshot, snapshot_interval: snapshot_interval)
        end

        cls.build
      end

      def self.example_class(category: nil, snapshot: nil, snapshot_interval: nil)
        if category == :none
          category = nil
        else
          category ||= Category.example
        end

        snapshot ||= false

        if snapshot
          snapshot_interval ||= Store.snapshot_interval
        end

        Class.new do
          include AggregateStreams::Handler

          unless category.nil?
            category category
          end

          unless snapshot_interval.nil?
            snapshot_interval snapshot_interval
          end
        end
      end

      Example = example_class
    end
  end
end
