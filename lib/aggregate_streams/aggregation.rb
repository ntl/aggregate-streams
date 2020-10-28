module AggregateStreams
  class Aggregation
    include Schema::DataStructure

    attribute :sequences, Hash, default: ->{ Hash.new }

    def set_sequence(category, sequence)
      sequences[category] = sequence
    end

    def sequence(category)
      sequences[category]
    end

    def record_processed(message)
      causation_stream_name = message.metadata.fetch(:causation_message_stream_name)
      causation_global_position = message.metadata.fetch(:causation_message_global_position)

      causation_category = Messaging::StreamName.get_category(causation_stream_name)

      set_sequence(causation_category, causation_global_position)
    end

    def processed?(message)
      message_category = Messaging::StreamName.get_category(message.stream_name)

      sequence = sequence(message_category)
      return false if sequence.nil?

      sequence >= message.global_position
    end
  end
end
