#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

SEARCH_BACKEND="${SEARCH_BACKEND:-elasticsearch}"

# Starts only the web interface
exec docker compose \
	-f "${docker_root}/docker-compose.yml" \
	--profile "$SEARCH_BACKEND" \
	up --abort-on-container-exit $compose_up_opts \
	web
