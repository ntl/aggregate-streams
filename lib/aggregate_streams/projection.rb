module AggregateStreams
  class Projection
    include EntityProjection

    entity_name :aggregation

    def apply(message_data)
      aggregation.record_processed(message_data)
    end
  end
end
