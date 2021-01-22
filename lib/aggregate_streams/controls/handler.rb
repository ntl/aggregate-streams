module AggregateStreams
  module Controls
    module Handler
      def self.example(category: nil, snapshot: nil, snapshot_interval: nil, session: nil, writer_session: nil, &transform_action)
        if category == :none
          category = nil
        else
          category ||= Category.example
        end

        settings_data = {}

        settings_data[:category] = category unless category.nil?
        settings_data[:snapshot_interval] = snapshot_interval unless snapshot_interval.nil?
        settings_data[:writer_session] = writer_session unless writer_session.nil?
        settings_data[:transform_action] = transform_action unless transform_action.nil?

        settings = Settings.build(settings_data)

        Handle.build(session: session, settings: settings)
      end
    end
  end
end
