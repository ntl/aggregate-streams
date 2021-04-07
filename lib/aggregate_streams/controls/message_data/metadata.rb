module AggregateStreams
  module Controls
    module MessageData
      module Metadata
        def self.example(category: nil, stream_id: nil, stream_name: nil, position: nil, global_position: nil, causation_message_stream_name: nil, causation_message_position: nil, causation_message_global_position: nil, correlation_stream_name: nil, reply_stream_name: nil, properties: nil, local_properties: nil, schema_version: nil)
          if stream_name == :none
            stream_name = nil
          else
            stream_name ||= stream_name(id: stream_id, category: category)
          end

          if position == :none
            position = nil
          else
            position ||= self.position
          end

          if global_position == :none
            global_position = nil
          else
            global_position ||= self.global_position
          end

          if causation_message_stream_name == :none
            causation_message_stream_name = nil
          else
            causation_message_stream_name ||= self.causation_message_stream_name
          end

          if causation_message_position == :none
            causation_message_position = nil
          else
            causation_message_position ||= self.causation_message_position
          end

          if causation_message_global_position == :none
            causation_message_global_position = nil
          else
            causation_message_global_position ||= self.causation_message_global_position
          end

          if correlation_stream_name == :none
            correlation_stream_name = nil
          else
            correlation_stream_name ||= Metadata.correlation_stream_name
          end

          if reply_stream_name == :none
            reply_stream_name = nil
          else
            reply_stream_name ||= Metadata.reply_stream_name
          end

          if properties == :none
            properties = nil
          else
            properties ||= self.properties
          end

          if local_properties == :none
            local_properties = nil
          else
            local_properties ||= self.local_properties
          end

          if schema_version == :none
            schema_version = nil
          else
            schema_version ||= Metadata.schema_version
          end

          metadata = {
            :stream_name => stream_name,
            :position => position,
            :global_position => global_position,

            :causation_message_stream_name => causation_message_stream_name,
            :causation_message_position => causation_message_position,
            :causation_message_global_position => causation_message_global_position,

            :correlation_stream_name => correlation_stream_name,
            :reply_stream_name => reply_stream_name,

            :properties => properties,
            :local_properties => local_properties,

            :schema_version => schema_version
          }

          metadata.delete_if { |_, v| v.nil? }

          metadata
        end

        def self.stream_name(**args)
          StreamName.example(**args)
        end

        def self.position
          Position.example
        end

        def self.global_position
          Position::Global.example
        end

        def self.causation_message_stream_name
          Messaging::Controls::Metadata.causation_message_stream_name
        end

        def self.causation_message_position
          Messaging::Controls::Metadata.causation_message_position
        end

        def self.causation_message_global_position
          Messaging::Controls::Metadata.causation_message_global_position
        end

        def self.correlation_stream_name
          Messaging::Controls::Metadata.correlation_stream_name
        end

        def self.reply_stream_name
          Messaging::Controls::Metadata.reply_stream_name
        end

        def self.properties
          Messaging::Controls::Properties.example
        end

        def self.local_properties
          Messaging::Controls::LocalProperties.example
        end

        def self.schema_version
          Messaging::Controls::Metadata.schema_version
        end

        module Input
          def self.example
            Metadata.example(
              stream_name: StreamName::Input.example,
              position: Position::Previous.example,
              global_position: Position::Global::Previous.example
            )
          end

          def self.alternate
            Metadata.example(
              stream_name: StreamName::Input::Alternate.example,
              position: Position::Previous.alternate,
              global_position: Position::Global::Previous.alternate
            )
          end
        end

        module Output
          def self.example(causation_message_category: nil)
            causation_message_category ||= StreamName::Input::Category.example

            Metadata.example(
              causation_message_stream_name: StreamName::Input.example(category: causation_message_category),
              causation_message_position: Position::Previous.example,
              causation_message_global_position: Position::Global::Previous.example
            )
          end

          def self.alternate
            Metadata.example(
              causation_message_stream_name: StreamName::Input::Alternate.example,
              causation_message_position: Position::Previous.alternate,
              causation_message_global_position: Position::Global::Previous.alternate
            )
          end
        end
      end
    end
  end
end
