#!/usr/bin/env bash

set -e

flutter pub global run dart_coveralls report \
  --debug \
  --retry 2 \
  --throw-on-connectivity-error \
  --throw-on-error \
  --exclude-test-files \
  test/redux_prism_test.dart
