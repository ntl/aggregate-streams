module AggregateStreams
  class Consumer
    include ::Consumer::Postgres

    handler Handle

    def configure(output_category:, output_session: nil, **args)
      super(**args)

      input_category = self.category

      PositionStore.configure(
        self,
        input_category,
        output_category,
        session: output_session
      )
    end
  end
end
