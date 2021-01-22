module AggregateStreams
  def self.start(input_categories, output_category, writer_session: nil, snapshot_interval: nil, **consumer_args, &transform_action)
    settings = {
      :category => output_category,
      :writer_session => writer_session,
      :snapshot_interval => snapshot_interval,
      :transform_action => transform_action
    }

    input_categories.each do |input_category|
      Consumer.start(input_category, output_category: output_category, supplemental_settings: settings, **consumer_args)
    end
  end
end
