#!/bin/bash

set -eo pipefail

echo "===> Running clean"
graylog-project npm-clean
