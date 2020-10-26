module AggregateStreams
  module Controls
    module StreamName
      def self.example(**args)
        MessageStore::Controls::StreamName.example(**args)
      end

      def self.stream_name(category, id=nil, **args)
        MessageStore::Controls::StreamName.stream_name(category, id, **args)
      end

      module Input
        module Category
          def self.example
            StreamName.stream_name('someInput')
          end
        end

        module Alternate
          module Category
            def self.example
              StreamName.stream_name('otherInput')
            end
          end
        end
      end

      module Aggregate
        module Category
          def self.example
            StreamName.stream_name('someAggregate')
          end
        end
      end
    end
  end
end
