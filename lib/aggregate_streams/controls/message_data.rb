module AggregateStreams
  module Controls
    MessageData = MessageStore::Controls::MessageData

    module MessageData
      module Input
        def self.example(stream_name: nil, stream_id: nil, position: nil, global_position: nil, **args)
          stream_name ||= StreamName::Input.example(id: stream_id)

          position ||= Position.example
          global_position ||= Position::Global.example

          message_data = Read.example(**args)
          message_data.stream_name = stream_name
          message_data.position = position
          message_data.global_position = global_position
          message_data
        end

        def self.alternate(stream_id: nil, **args)
          stream_name = StreamName::Input::Alternate(id: stream_id)

          Input.example(stream_name: stream_name, **args)
        end
      end

      module Output
        def self.example(stream_id: nil, metadata: nil)
          stream_name = StreamName::Output.example(id: stream_id)

          metadata ||= Metadata.example

          Input.example(stream_name: stream_name, metadata: metadata)
        end

        def self.alternate(stream_id: nil)
          metadata = Metadata.alternate

          example(stream_id: stream_id, metadata: metadata)
        end

        module Metadata
          def self.example(causation_message_category: nil, causation_message_position: nil, causation_message_global_position: nil)
            causation_message_category ||= StreamName::Input.category
            causation_message_position ||= Position.example
            causation_message_global_position ||= Position::Global.example

            causation_message_stream_name = StreamName.example(category: causation_message_category)

            {
              :causation_message_stream_name => causation_message_stream_name,
              :causation_message_position => causation_message_position,
              :causation_message_global_position => causation_message_global_position
            }
          end

          def self.alternate
            example(
              causation_message_category: StreamName::Input::Alternate.category,
              causation_message_position: Position.alternate,
              causation_message_global_position: Position::Global.alternate
            )
          end
        end
      end
    end
  end
end
