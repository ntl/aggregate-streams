# Aggregate Streams

Combine messages from multiple [Eventide](https://eventide-project.org) streams into an aggregate stream

## Usage

Start an aggregation of the events from three categories, `productCatalog`, `productInventory`, and `productPricing` into `productAggregate`:

``` ruby
AggregateStreams.start(['productCatalog', 'productInventory', 'productPricing'], 'productAggregate')
```

The aggregation will run in a background thread; to keep the ruby process running while the thread remains active, start the aggregation from `component-host`:

``` ruby
module SomeAggregator
  module Start
    def self.call
      AggregateStreams.start(['productCatalog', 'productInventory', 'productPricing'], 'productAggregate')
    end
  end
end
```
<!-- -->
``` ruby
ComponentHost.start('aggregate-streams-example') do |host|
  host.register(SomeAggregator::Start)
end
```

### Transformation

`AggregateStreams.start(…)` accepts an optional block argument which can transform the events as they are copied to the aggregate stream.

#### Rename Message Type

Sometimes multiple input streams may have message types that coincide with one another. To disambiguate, set a different `message_type` property on the message data passed to the block:

``` ruby
AggregateStreams.start(['someStream', 'otherStream'], 'someAggregate') do |message_data, input_category|
  if message_data.type == 'Initiated'
    if input_category == 'productCatalog'
      message_data.type = 'CatalogInitiated'
    elsif input_category == 'productPricing'
      message_data.type = 'PricingInitiated'
    end
  end

  message_data
end
```

##### Skip Some Messages

To avoid copying some messages from the input streams to the output, have the `#transform` block return nil or false:

``` ruby
AggregateStreams.start(['someCategory', 'otherCategory'], 'someAggregation') do |message_data|
  return nil if message_data.type == 'SomeUnimportantEvent'

  message_data
end
```

#### Write to a Different Message Store

Sometimes it is desirable to aggregate events into a different message store. Use `#writer_session` to specify a different session:

``` ruby
settings = MessageStore::Postgres::Settings.build

writer_session = MessageStore::Postgres::Session.build(settings: settings)

AggregateStreams.start(['someCategory', 'otherCategory'], 'someAggregation', writer_session: writer_session)
```

#### Snapshot Interval

Periodically, the aggregation needs to record snapshot data. This interval can be varied via the `snapshot_interval` argument:

``` ruby
snapshot_interval = 1000

AggregateStreams.start(['someCategory', 'otherCategory'], 'someAggregation', snapshot_interval: snapshot_interval)
```

## License

The `aggregate_streams` library is released under the [MIT License](https://github.com/ntl/aggregate-streams/blob/master/MIT-License.txt).
