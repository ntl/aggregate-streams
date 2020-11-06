require_relative './interactive_init'

stream_1 = Controls::StreamName::Input.example
stream_2 = Controls::StreamName::Input::Alternate.example

period = ENV.fetch('PERIOD', 500)
period_seconds = Rational(period, 1000)

limit = ENV['LIMIT']
limit = limit.to_i unless limit.nil?

streams = [stream_1, stream_2].cycle

write = MessageStore::Postgres::Write.build
logger = Log.build(__FILE__)

count = 0

loop do
  message = Controls::MessageData::Write.example

  stream = streams.next

  written_position = write.(message, stream)
  logger.info { "Wrote message (Stream: #{stream}, Position: #{written_position}, Count: #{count})" }

  sleep period_seconds

  count += 1

  if !limit.nil? && count >= limit
    break
  end
end
