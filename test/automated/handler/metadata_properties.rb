require_relative '../automated_init'

context "Handler" do
  context "Metadata Properties" do
    context "Properties" do
      metadata = Controls::MessageData::Metadata.example
      properties = metadata[:properties] or fail
      local_properties = metadata[:local_properties] or fail

      message = Controls::MessageData::Input.example(metadata: metadata)
      stream_id = Messaging::StreamName.get_id(message.stream_name)

      handler = Controls::Handler.example

      handler.(message)

      aggregate_stream = handler.stream_name(stream_id)
      copied_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)
      refute(copied_message.nil?)

      last_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)

      context "Properties" do
        copied_properties = last_message.metadata[:properties]

        test "Copied" do
          detail "Copied Properties: #{copied_properties.inspect}"
          detail "Source Properties: #{properties.inspect}"

          assert(copied_properties == properties)
        end
      end

      context "Local Properties" do
        copied_local_properties = last_message.metadata[:local_properties]

        test "Not copied" do
          detail "Copied Local Properties: #{copied_local_properties.inspect}"

          assert(copied_local_properties.nil?)
        end
      end
    end

    context "No Properties" do
      metadata = Controls::MessageData::Metadata.example(properties: :none, local_properties: :none)

      message = Controls::MessageData::Input.example(metadata: metadata)
      stream_id = Messaging::StreamName.get_id(message.stream_name)

      handler = Controls::Handler.example

      handler.(message)

      aggregate_stream = handler.stream_name(stream_id)
      copied_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)
      refute(copied_message.nil?)

      last_message = MessageStore::Postgres::Get::Stream::Last.(aggregate_stream)

      context "Properties" do
        copied_properties = last_message.metadata[:properties]

        test "Not copied" do
          detail "Copied Properties: #{copied_properties.inspect}"

          assert(copied_properties.nil?)
        end
      end

      context "Local Properties" do
        copied_local_properties = last_message.metadata[:local_properties]

        test "Not copied" do
          detail "Copied Local Properties: #{copied_local_properties.inspect}"

          assert(copied_local_properties.nil?)
        end
      end
    end
  end
end
