module AggregateStreams
  module Consumer
    def self.included(cls)
      cls.class_exec do
        include ::Consumer::Postgres
        include Configure
      end
    end

    module Configure
      def configure(output_category:, output_session: nil, **args)
        super(**args)

        input_category = self.category

        PositionStore.configure(
          self,
          input_category,
          session: session
        )
      end
    end
  end
end
