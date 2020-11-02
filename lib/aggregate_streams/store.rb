module AggregateStreams
  module Store
    def self.included(cls)
      cls.class_exec do
        include EntityStore

        entity Aggregation
        projection Projection
        reader MessageStore::Postgres::Read, batch_size: Defaults.batch_size
      end
    end

    module Defaults
      def self.batch_size
        MessageStore::Postgres::Read::Defaults.batch_size
      end
    end
  end
end
