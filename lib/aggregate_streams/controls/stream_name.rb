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
        def self.example(**args)
          StreamName.example(category: category, **args)
        end

        def self.category
          'someInput'
        end

        module Category
          def self.example
            StreamName.stream_name(Input.category)
          end
        end

        module Alternate
          def self.example(**args)
            StreamName.example(category: category, **args)
          end

          def self.category
            'otherInput'
          end

          module Category
            def self.example
              StreamName.stream_name(Alternate.category)
            end
          end
        end
      end

      module Output
        def self.example(**args)
          StreamName.example(category: category, **args)
        end

        def self.category
          'someAggregate'
        end

        module Category
          def self.example
            StreamName.stream_name(Output.category)
          end
        end
      end
    end
  end
end
