#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

SEARCH_BACKEND="${SEARCH_BACKEND:-elasticsearch}"

# Starts only the server
exec docker compose \
	-f "${docker_root}/docker-compose.yml" \
	--profile "$SEARCH_BACKEND" \
	up --abort-on-container-exit --no-deps $compose_up_opts \
	graylog
