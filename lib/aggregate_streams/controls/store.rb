module AggregateStreams
  module Controls
    module Store
      def self.example(category: nil, snapshot: nil, snapshot_interval: nil)
        if category.nil? && snapshot.nil?
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
          category ||= self.category
        end

        snapshot ||= false

        if snapshot
          snapshot_interval ||= self.snapshot_interval
        end

        Class.new do
          include AggregateStreams::Store

          unless category.nil?
            category category
          end

          unless snapshot_interval.nil?
            snapshot EntitySnapshot::Postgres, interval: snapshot_interval
          end
        end
      end

      def self.category
        StreamName::Output::Category.internal
      end

      def self.snapshot_interval
        11
      end

      Example = self.example_class
    end
  end
end
