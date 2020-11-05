require_relative './interactive_init'

module Start
  def self.call
    input_1 = Controls::StreamName::Input::Category.example
    input_2 = Controls::StreamName::Input::Category.example

    AggregateStreams.start(
      [input_1, input_2],
      output,
      identifier: 'interactiveTest'
    )
  end
end

ComponentHost.start('aggregate-streams-interactive-test') do |host|
  host.register(Start)
end
