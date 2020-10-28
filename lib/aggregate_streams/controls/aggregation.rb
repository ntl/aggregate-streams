module AggregateStreams
  module Controls
    module Aggregation
      def self.example(sequence: nil, sequence_category: nil)
        if sequence == :none
          sequence = nil
        else
          sequence ||= self.sequence
        end

        sequence_category ||= StreamName::Input.category

        aggregation = New.example

        unless sequence.nil?
          aggregation.set_sequence(sequence_category, sequence)
        end

        aggregation
      end

      def self.sequence
        Position.example
      end

      module New
        def self.example
          AggregateStreams::Aggregation.new
        end
      end
    end
  end
end
