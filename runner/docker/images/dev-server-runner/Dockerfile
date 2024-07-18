# Build layer
FROM debian:buster-slim AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends --assume-yes 'gosu=1.10-*' uuid-runtime pwgen curl ca-certificates
RUN curl -sL -o /usr/bin/graylog-project https://github.com/Graylog2/graylog-project-cli/releases/latest/download/graylog-project.linux && \
      chmod +x /usr/bin/graylog-project


# Final layer
FROM maven:3.6-jdk-8

COPY --from=build /usr/sbin/gosu /usr/sbin/gosu
COPY --from=build /usr/bin/uuidgen /usr/bin/uuidgen
COPY --from=build /usr/bin/pwgen /usr/bin/pwgen
COPY --from=build /usr/bin/graylog-project /usr/bin/graylog-project
COPY docker-entrypoint.sh /
COPY build-and-run.sh /
COPY clean.sh /
COPY maven-settings.xml /graylog/

VOLUME ["/graylog/graylog-project", "/graylog/graylog-project-repos", "/data"]

WORKDIR /graylog/graylog-project

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["build-and-run"]
