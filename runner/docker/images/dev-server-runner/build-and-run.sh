#!/bin/bash

set -eo pipefail

if [ -n "$DEBUG" ]; then
	set -x
	ls -l
	echo "########################"
	ls -l ..
	echo "########################"
	ls -l ../graylog-project-repos
	echo "########################"
	ls -l /graylog/graylog-project-repos
	echo "########################"
	graylog-project status
	echo "########################"
	graylog-project exec "ls -l"
fi

# Detect if we have to use Java 8
if grep -q maven.compiler.source.1.8 /graylog/graylog-project-repos/graylog2-server/pom.xml; then
	echo "===> Using Java 8"
	export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)"
fi

goals=""
if [ "$GRAYLOG_BUILD_CLEAN" = "true" ]; then
	echo "===> Cleaning up"
	goals="clean"
fi

flags=""
if [ "$GRAYLOG_BUILD_SKIP_WEB" = "true" ]; then
	flags="-Dskip.web.build"
else
	# Make sure the server is using the production artifacts
	unset DEVELOPMENT
fi

# Detect if we can use the maven wrapper
if [ -f ./mvnw ]; then
	mvn=./mvnw
else
	mvn=mvn
fi

echo "===> Running build"
# Build and generate classpath file: (we use the test goal even though we skip tests to avoid a test-jar error)
$mvn $flags \
	-s /graylog/maven-settings.xml \
	-Dmaven.javadoc.skip=true \
	-DskipTests \
	-Dforbiddenapis.skip=true \
	-DincludeScope=runtime \
	-Dmdep.outputFile=target/classpath.txt \
	$goals test \
	org.apache.maven.plugins:maven-dependency-plugin:3.2.0:build-classpath


mkdir -p $(dirname "$GRAYLOG_NODE_ID_FILE")

if [ ! -f "$GRAYLOG_NODE_ID_FILE" ]; then
	echo "===> Generating: $GRAYLOG_NODE_ID_FILE"
	uuidgen > "$GRAYLOG_NODE_ID_FILE"
fi

if [ ! -f "/data/graylog.conf" ]; then
	echo "===> Creating /data/graylog.conf"

	cat <<-__CONFIG > /data/graylog.conf
	password_secret = $(pwgen -N 1 -s 96)

	# Default password is "admin"
	root_password_sha2 = 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918

	## Add custom config below
	__CONFIG
fi

if [ ! -f "/data/feature-flags.config" ]; then
	echo "===> Creating /data/feature-flags.config"

	cat <<-__FEATUREFLAGS > /data/feature-flags.config
	# Add custom feature flags in Java properties syntax
	__FEATUREFLAGS
fi

echo "===> Running graylog server"
classpath=$(< runner/target/classpath.txt)
exec java \
	-Dio.netty.leakDetection.level=paranoid \
	-Dlog4j2.formatMsgNoLookups=true \
	-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=0.0.0.0:5005 \
	-Xms1g \
	-Xmx1g \
	-server \
	-XX:-OmitStackTraceInFastThrow \
	-classpath "$classpath" \
	org.graylog2.bootstrap.Main \
	server -f /data/graylog.conf -np --local -ff /data/feature-flags.config
