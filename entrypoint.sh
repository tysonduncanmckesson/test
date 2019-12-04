#!/usr/bin/env bash
set -euo pipefail

## Set up defaults
: "${MONITORING_ENABLED:=false}"
: "${SERVICE_NAME:=sample-k8s}"

echo "Starting"
echo "-------------------"

## Set up java opts
JAVA_OPTS="-Xdebug -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.local.only=false"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.port=1099"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.rmi.port=1099"
JAVA_OPTS="${JAVA_OPTS} -Djava.rmi.server.hostname=127.0.0.1"

JAVA_OPTS="${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom"

#Headless
unset DISPLAY

if [[ "true" == "${MONITORING_ENABLED}" ]]
then
	# Datadog
	JAVA_OPTS="${JAVA_OPTS} -javaagent:/datadog/dd-java-agent.jar"
	JAVA_OPTS="${JAVA_OPTS} -Ddd.service.name=${SERVICE_NAME}"
	JAVA_OPTS="${JAVA_OPTS} -Ddd.agent.host=${DD_AGENT_SERVICE_HOST}"
	JAVA_OPTS="${JAVA_OPTS} -Ddd.agent.port=${DD_AGENT_SERVICE_PORT}"
fi

JAVA_OPTS="${JAVA_OPTS} -XshowSettings:all "

## Start
exec java ${JAVA_OPTS} -jar app.jar
