#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

# Starts only the server
exec docker-compose \
	-f "${docker_root}/docker-compose.yml" \
	up --abort-on-container-exit $compose_up_opts \
	graylog
