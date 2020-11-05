#!/bin/sh

LOG_TAGS=${LOG_TAGS:-ignored,_untagged}

export LOG_TAGS

ruby \
  --disable-gems \
  test/automated.rb \
  $@
