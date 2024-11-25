#!/bin/sh

set -e

. "$(dirname $0)/include.sh"

# Disable logging for all services but Graylog
export SERVICE_LOGGER="${SERVICE_LOGGER:-none}"

SEARCH_BACKEND="${SEARCH_BACKEND:-elasticsearch}"

# Starts the server + all services
exec docker compose \
	-f "${docker_root}/docker-compose.yml" \
	--profile "$SEARCH_BACKEND" \
	up --abort-on-container-exit $compose_up_opts \
	mongodb \
	"$SEARCH_BACKEND" \
	"${SEARCH_BACKEND}-monitor" \
	mailserver \
	graylog
