Run Graylog Development Server
==============================

This Graylog development setup provides the following services as Docker
containers:

- Graylog server ([http://localhost:9000/](http://localhost:9000/))
  - Builds the server from the checked out sources
  - Pre-configured for email sending to the MailHog service
  - Default "admin" password is `admin`
- MongoDB (default: `127.0.0.1:27017`)
- Elasticsearch (default: [http://localhost:9200/](http://localhost:9200/))
  - OpenSearch when `SEARCH_BACKEND` is set to `opensearch`
- [Kibana](https://www.elastic.co/kibana/) (default: [http://localhost:5601/](http://localhost:5601/))
- [MailHog](https://github.com/mailhog/MailHog) (default: [http://localhost:8025/](http://localhost:8025/))

The `runner/data` directory is mounted as `/data` in the Graylog server container
and can be used to make files available to the server.

The following ports are exposed from the Graylog server container and can be
used to start inputs:

- `2055/udp` - NetFlow
- `4739/udp` - IPFIX
- `5044/tcp` - Beats
- `5140/udp` - Syslog UDP
- `5140/tcp` - Syslog TCP
- `5555/udp` - Raw TCP
- `5555/tcp` - Raw UDP
- `12201/udp` - GELF UDP
- `12201/tcp` - GELF TCP
- `13001/tcp` - Custom 1 TCP
- `13002/tcp` - Custom 2 TCP
- `13003/tcp` - Custom 3 TCP
- `13004/tcp` - Custom 4 TCP
- `13001/udp` - Custom 1 UDP
- `13002/udp` - Custom 2 UDP
- `13003/udp` - Custom 3 UDP
- `13004/udp` - Custom 4 UDP
- `13301/tcp` - Cloud Forwarder messages
- `13302/tcp` - Cloud Forwarder configuration

The "Custom" ports can be used to start any inputs.

## Requirements

Make sure you have the following software installed and ready to use:

- [Docker](https://www.docker.com/get-started)
- [docker-compose](https://docs.docker.com/compose/install/)
- [nodejs](https://nodejs.org/)
- [yarn](https://classic.yarnpkg.com/) (use version 1.x!)
- macOS:
  - `realpath` program from coreutils (`brew install coreutils`)

## Run Development Server + Elasticsearch and MongoDB

```sh
cd /path/to/graylog-project

graylog-project run dev
```

## Run Development Server + OpenSearch and MongoDB

```sh
cd /path/to/graylog-project

export SEARCH_BACKEND=opensearch
graylog-project run dev
```

By default the Graylog API service is listening on port `9000`.

Make sure to checkout more examples and options by running `graylog-project run -h`.

### Run Clean Maven Build

If you want to force a clean maven build, you can use the `--clean` flag.

```sh
cd /path/to/graylog-project

graylog-project run dev --clean
```

### Include Production Web Interface Assets

If you want to also build the production web interface assets, you can
use the `--web` flag.

```sh
cd /path/to/graylog-project

graylog-project run dev --web
```

### Rebuild Development Server Docker Image

The run command automatically builds the Docker image to run the server
container. If you want to force a rebuild of the container, for example
when something in the image has changed, you can use the `--build-images`
(or `-B`) flag.

```sh
cd /path/to/graylog-project

graylog-project run dev --build
```

## Run Development Server and Elasticsearch + MongoDB separately

In one shell run:

```sh
cd /path/to/graylog-project

graylog-project run dev:services
```

In another shell run:

```sh
cd /path/to/graylog-project

graylog-project run dev:server # Also takes --web and --clean flags
```

## Run Web Development Server

If you want to run the web development server in a container as well, you can
use the following command.

```sh
cd /path/to/graylog-project

graylog-project run dev:web
```

## Custom Environment Configuration

It's possible to override or set new environment variables for the Docker Compose
services by creating a `runner/docker/.env` file. That file is automatically
loaded by Docker Compose.

Example:

```
echo "GRAYLOG_API_HTTP_PORT=9009" | tee -a runner/docker/.env
```

## Custom Server Configuration

After the first development server start, there will be a `runner/data/graylog.conf`
file. Feel free to add custom configuration options to that file.

The following settings are overridden in the environment and will have no
effect in the `runner/data/graylog.conf` file:

- `data_dir`
- `elasticsearch_hosts`
- `http_bind_address`
- `http_external_uri`
- `lb_recognition_period_seconds`
- `message_journal_dir`
- `mongodb_uri`
- `node_id_file`
- `report_disable_sandbox`
- `telemetry_enabled`
- `transport_email_enabled`
- `transport_email_hostname`
- `transport_email_port`
- `transport_email_use_auth`
- `transport_email_web_interface_url`
- `versionchecks`

## Cleanup Containers

To remove all containers you can use the cleanup command. This will keep
the volumes so your MongoDB data and Elasticsearch indices still exist.

```sh
cd /path/to/graylog-project

graylog-project run dev:cleanup
```

To also remove the MongoDB and Elasticsearch data, you can use the
`--volumes` (or `-V`) flag. After running this command, all you data is gone.

```sh
cd /path/to/graylog-project

graylog-project run dev:cleanup --volumes
```

## Troubleshooting

### Debug Mode

If something doesn't start correctly, you can use the `--debug` flag to get
some debug output.

```sh
cd /path/to/graylog-project

graylog-project run dev --debug
```
