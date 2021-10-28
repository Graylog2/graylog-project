#!/bin/bash

set -eo pipefail

# Allow execution of different commands
if [ "$1" != "build-and-run" -a "$1" != "clean" ]; then
	exec "$@"
fi

check_env() {
	local key="$1"
	local value="$2"

	if [ -z "$value" ]; then
		echo "ERROR: Missing $key environment variable"
		exit 1
	fi
}

# Make sure we have all require environment variables
check_env "YARN_CACHE_FOLDER" "$YARN_CACHE_FOLDER"

mkdir -p "$YARN_CACHE_FOLDER"

# A file that will always exists and is owned by the user
canary_file="/graylog/graylog-project/.git/config"

if [ ! -f "$canary_file" ]; then
	echo "ERROR: Missing volume mount"
	exit 1
fi

user="node"
group="node"
uid=$(stat -c "%u" "$canary_file")
gid=$(stat -c "%g" "$canary_file")

# Adjust uid and gid of user and group to match the canary permissions
if ! getent group $gid >/dev/null; then
	groupmod -g "$gid" "$group"
fi
if ! getent passwd $uid >/dev/null; then
	usermod -u "$uid" -g "$gid" -d "/graylog" "$user" >/dev/null
fi

chown -R ${uid}:${gid} /cache

if [ "$1" = "clean" ]; then
	exec gosu "$user" /clean.sh
fi

exec gosu "$user" /build-and-run.sh
