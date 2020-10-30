#!/bin/sh

ruby \
  --disable-gems \
  test/automated.rb \
  $@
