# macOS doesn't have realpath... - Just ask users to install it
if ! type realpath >/dev/null 2>/dev/null; then
	echo "ERROR: \"realpath\" is not available"
	echo ""
	echo "On macOS please install coreutils (brew install coreutils)"
	exit 1
fi

project_root=$(realpath "$(dirname $(realpath $0))/../..")
default_project_repos_root=$(realpath "${project_root}/../graylog-project-repos")
project_repos_root="${GPC_REPOSITORY_ROOT:-$default_project_repos_root}"
runner_root="${project_root}/runner"
docker_root="${runner_root}/docker"
data_root="${runner_root}/data"
project_name_file="${data_root}/.docker-compose-project-name"

export PROJECT_ROOT="$project_root"
export PROJECT_REPOS_ROOT="$project_repos_root"
export PROJECT_DATA_ROOT="$data_root"
export DEBUG="${DEBUG:-}"

if [ -n "$DEBUG" ]; then
	echo "==> PROJECT_ROOT=$PROJECT_ROOT"
	ls -l "$PROJECT_ROOT"
	echo "==> PROJECT_REPOS_ROOT=$PROJECT_REPOS_ROOT"
	ls -l "$PROJECT_REPOS_ROOT"
	echo "==> PROJECT_DATA_ROOT=$PROJECT_DATA_ROOT"
	ls -l "$PROJECT_DATA_ROOT"
fi

mkdir -p "$data_root"
mkdir -p "$HOME/.m2/repository" # Make sure the maven cache exists locally

cd "$docker_root"

if [ ! -f "$project_name_file" ]; then
	# Use the first 10 characters of the shasum for the full project
	# root directory as part of the compose project name.
	# This ensures that multiple graylog-project checkouts don't use
	# the same name.
	project_id=$(echo $runner_root | shasum -a 256 | fold -w 10 | head -1)
	echo "graylog_project_$project_id" > "$project_name_file"
fi

# We cannot use the default compose project name because if the user has
# multiple graylog-project checkouts, the name would be the same.
export COMPOSE_PROJECT_NAME=$(cat "$project_name_file")

if [ -z "$COMPOSE_PROJECT_NAME" ]; then
	echo "ERROR: COMPOSE_PROJECT_NAME cannot be empty"
	exit 1
fi

compose_up_opts=""
if [ -n "$DOCKER_COMPOSE_BUILD_IMAGES" ]; then
	compose_up_opts="--build"
fi

compose_down_opts=""
if [ -n "$DOCKER_COMPOSE_CLEANUP_VOLUMES" ]; then
	compose_down_opts="-v"
fi
