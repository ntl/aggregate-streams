module AggregateStreams
  module Controls
    module Position
      def self.example
        11
      end

      def self.alternate
        22
      end

      module Previous
        def self.example
          Position.example - 1
        end
      end

      module Initial
        def self.example
          0
        end
      end

      module Global
        def self.example
          111
        end

        def self.alternate
          222
        end

        module Previous
          def self.example
            Position.example - 1
          end
        end
      end
    end
  end
end
