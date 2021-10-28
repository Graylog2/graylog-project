#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

# Executes docker-compose
exec docker-compose \
	-f "${docker_root}/docker-compose.yml" \
	"$@"
