module AggregateStreams
  def self.start(input_categories, output_category, **consumer_args, &handler_block)
    handler_block ||= proc { }

    input_categories.each do |input_category|
      handler_cls = Class.new do
        include Handle

        category output_category

        unless handler_block.nil?
          class_exec(&handler_block)
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
