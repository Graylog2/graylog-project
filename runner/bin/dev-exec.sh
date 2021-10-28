#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

# Starts the server + all services
exec docker-compose \
	-f "${docker_root}/docker-compose.yml" \
	exec "$@"
