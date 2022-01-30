#!/bin/bash
# Inspired from https://github.com/hhcordero/docker-jmeter-client
# Basically runs jmeter, assuming the PATH is set to point to JMeter bin-dir (see Dockerfile)
#
# This script expects the standdard JMeter command parameters.
#

# Execute JMeter command
set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
# export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"
export JAVA_HOME=/usr/lib/jvm/default-jvm
export JMETER_HOME=/opt/apache-jmeter-5.4.3
export JRE_HOME=/usr/lib/jvm/default-jvm/jre
echo "START Running Jmeter on `date`"
# echo "JVM_ARGS=${JVM_ARGS}"
echo "JAVA_HOME=/usr/lib/jvm/default-jvm"
echo "JMETER_HOME=/opt/apache-jmeter-5.4.3"
echo "JRE_HOME=/usr/lib/jvm/default-jvm/jre"

echo "jmeter args=$@"

# Keep entrypoint simple: we must pass the standard JMeter arguments
EXTRA_ARGS="-Dlog4j2.formatMsgNoLookups=true -Dserver.rmi.ssl.disable=true"
COMMAND=jmeter
if [[ $# -gt 1 && "$1" == "server" ]]
then
    COMMAND=jmeter-server
    shift
fi

echo "${COMMAND} ALL ARGS=${EXTRA_ARGS} $@"
${COMMAND} ${EXTRA_ARGS} $@

echo "END Running ${COMMAND} on `date`"

#     -n \
#    -t "/tests/${TEST_DIR}/${TEST_PLAN}.jmx" \
#    -l "/tests/${TEST_DIR}/${TEST_PLAN}.jtl"
# exec tail -f jmeter.log
#    -D "java.rmi.server.hostname=${IP}" \
#    -D "client.rmi.localport=${RMI_PORT}" \
#  -R $REMOTE_HOSTS