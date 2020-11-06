module AggregateStreams
  class PositionStore
    include ::Consumer::PositionStore
    include Initializer

    dependency :session, MessageStore::Postgres::Session

    initializer :input_category, :output_category

    def self.build(input_category, output_category, session: nil)
      instance = new(input_category, output_category)
      MessageStore::Postgres::Session.configure(instance, session: session)
      instance
    end

    def get
      logger.trace { "Get position (Output Category: #{output_category.inspect}, Input Category: #{input_category.inspect})" }

      sql_command = self.class.get_sql_command

      parameter_values = [output_category, input_category]

      result = session.execute(sql_command, parameter_values)

      if result.ntuples.zero?
        position = nil
      else
        record = result[0]

        position = record['position'].to_i
      end

      logger.info { "Get position done (Position: #{position || '(none)'}, Output Category: #{output_category.inspect}, Input Category: #{input_category.inspect})" }

      position
    end

    def self.get_sql_command
      %{
        SELECT
          metadata->>'causationMessageGlobalPosition' AS position
        FROM messages
        WHERE
          category(stream_name) = $1 AND
          category(metadata->>'causationMessageStreamName') = $2
        ORDER BY global_position DESC LIMIT 1
      }
    end
  end
end
