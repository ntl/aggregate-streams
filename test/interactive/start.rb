require_relative './interactive_init'

require 'component_host'

module Start
  def self.call
    input_1 = Controls::StreamName::Input::Category.example
    input_2 = Controls::StreamName::Input::Alternate::Category.example

    output = Controls::StreamName::Output::Category.example

    AggregateStreams.start([input_1, input_2], output)
  end
end

ComponentHost.start('aggregate-streams-interactive-test') do |host|
  host.register(Start)
end
