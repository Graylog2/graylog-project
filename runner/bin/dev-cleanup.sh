#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

SEARCH_BACKEND="${SEARCH_BACKEND:-elasticsearch}"

# Runs docker-compose down to remove all containers
exec docker compose \
	-f "${docker_root}/docker-compose.yml" \
	--profile "$SEARCH_BACKEND" \
	down --remove-orphans $compose_down_opts
