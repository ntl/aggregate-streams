module AggregateStreams
  class Aggregation
    include Schema::DataStructure

    attribute :positions, Hash, default: ->{ Hash.new }

    def record_processed(message)
      causation_stream_name = message.metadata.fetch(:causation_message_stream_name)
      causation_global_position = message.metadata.fetch(:causation_message_global_position)

      causation_category = Messaging::StreamName.get_category(causation_stream_name)

      positions[causation_category] = causation_global_position
    end
  end
end
