module AggregateStreams
  class Store
    include EntityStore

    entity Aggregation
    projection Projection
    reader MessageStore::Postgres::Read
    snapshot EntitySnapshot::Postgres, interval: 1000
  end
end
