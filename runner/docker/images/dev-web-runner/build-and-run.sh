#!/bin/bash

set -eo pipefail

server_root="/graylog/graylog-project-repos/graylog2-server/graylog2-server"

# The API definition generator doesn't exist pre-5.0
if [ -f "$server_root/src/main/java/org/graylog/api/GenerateApiDefinition.java" ]; then
	api_json_file="$server_root/target/swagger/api.json"

	while [ ! -f "$api_json_file" ]; do
		echo "WARNING: Please run \"run dev\" or \"mvn compile\" to generate the required TypeScript files. Waiting..."
		sleep 5
	done
fi

echo "===> Running yarn install"
graylog-project yarn install


cd /graylog/graylog-project-repos/graylog2-server/graylog2-web-interface

echo "===> Running yarn generate:apidefs"
yarn run generate:apidefs

echo "===> Running yarn build"
yarn build

echo "===> Running web dev server"
export GRAYLOG_API_URL="http://graylog:9000"
exec yarn start --host=0.0.0.0 --port=8080
