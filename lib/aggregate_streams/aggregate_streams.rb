module AggregateStreams
  def self.start(input_categories, output_category, writer_session: nil, snapshot_interval: nil, **consumer_args, &transform_action)
    handler_block ||= proc { }

    input_categories.each do |input_category|
      handler_cls = Class.new do
        include Handle

        category output_category

        unless writer_session.nil?
          writer_session_macro do
            writer_session
          end
        end

        unless snapshot_interval.nil?
          snapshot_interval_macro snapshot_interval
        end

        unless transform_action.nil?
          transform(&transform_action)
        end
      end

      consumer_cls = Class.new do
        include Consumer

        handler handler_cls
      end

      consumer_cls.start(input_category, output_category: output_category, **consumer_args)
    end
  end
end
