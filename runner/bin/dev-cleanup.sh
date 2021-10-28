#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

# Runs docker-compose down to remove all containers
exec docker-compose \
	-f "${docker_root}/docker-compose.yml" \
	down $compose_down_opts
