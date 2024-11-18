# Build layer
FROM debian:buster-slim AS build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends --assume-yes 'gosu=1.10-*' uuid-runtime pwgen curl ca-certificates
RUN curl -sL -o /usr/bin/graylog-project https://github.com/Graylog2/graylog-project-cli/releases/latest/download/graylog-project.linux && \
      chmod +x /usr/bin/graylog-project


# Final layer
FROM maven:3.9-eclipse-temurin-17

ENV DEBIAN_FRONTEND noninteractive

COPY --from=build /usr/sbin/gosu /usr/sbin/gosu
COPY --from=build /usr/bin/uuidgen /usr/bin/uuidgen
COPY --from=build /usr/bin/pwgen /usr/bin/pwgen
COPY --from=build /usr/bin/graylog-project /usr/bin/graylog-project
COPY docker-entrypoint.sh /
COPY build-and-run.sh /
COPY clean.sh /
COPY maven-settings.xml /graylog/

# We need JDK 17 and 8 in the image to allow the compilation of pre-5.0 Graylog versions
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      openjdk-8-jdk-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME ["/graylog/graylog-project", "/graylog/graylog-project-repos", "/data"]

WORKDIR /graylog/graylog-project

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["build-and-run"]
