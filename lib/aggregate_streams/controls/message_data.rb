module AggregateStreams
  module Controls
    MessageData = MessageStore::Controls::MessageData

    module MessageData
      module Input
        def self.example(type: nil, data: nil, metadata: nil, **metadata_args)
          metadata ||= Metadata::Input.example(**metadata_args)

          message_data = Read.example(type: type, data: data, metadata: metadata)
          message_data.stream_name = metadata[:stream_name]
          message_data.position = metadata[:position]
          message_data.global_position = metadata[:global_position]
          message_data
        end

        def self.alternate(type: nil, data: nil)
          metadata = Metadata::Input.alternate

          Read.example(type: type, data: data, metadata: metadata)
        end
      end

      module Output
        def self.example(type: nil, data: nil, metadata: nil, **metadata_args)
          metadata ||= Metadata::Output.example(**metadata_args)

          MessageData::Read.example(type: type, data: data, metadata: metadata)
        end

        def self.alternate(type: nil, data: nil)
          metadata ||= Metadata::Output.alternate

          MessageData::Read.example(type: type, data: data, metadata: metadata)
        end
      end
    end
  end
end
