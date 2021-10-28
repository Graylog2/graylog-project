#!/bin/bash

set -eo pipefail

echo "===> Running yarn install"
graylog-project yarn install


cd /graylog/graylog-project-repos/graylog2-server/graylog2-web-interface

echo "===> Running yarn build"
yarn build

echo "===> Running web dev server"
exec yarn start --host=0.0.0.0 --port=8080 --api-url=http://graylog:9000/api/
