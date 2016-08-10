#!/bin/bash

if [[ -z "$1" ]]; then
	echo "ERROR: Test plan is required."
	exit 1
elif [[ ! -f $1 ]]; then
	echo "ERROR: $1. File not found"
	exit 1
else
	JMETER_TEST_PLAN=$1
fi

if [ "$2" == "gui" ] || [ "$2" == "GUI" ]; then
	GUI=yes
	shift
else
	GUI=no
fi

if [[ ! -z "$JMETER_TEST_PROPERTIES" ]]; then
	JMETER_PROPERTIES_STRING="-p $JMETER_TEST_PROPERTIES"
	DISABLED_OPTS="$(grep -e '^test.*=false$' $JMETER_TEST_PROPERTIES)"
	if [[ $? -ne 0 ]]; then
		echo "ERROR $JMETER_TEST_PROPERTIES: File not found"
		exit 1
	fi
else
	JMETER_PROPERTIES_STRING=""
fi



echo "Test Plan: $JMETER_TEST_PLAN"
echo "Recovery Url: $HTTP_PROTOCOL://$HTTP_HOST:$HTTP_PORT/pfs"
echo "Database Url: $JDBC_URL"
echo "Loop Count: $JMETER_LOOP_COUNT (default: 10)"
echo "Properties File: ${JMETER_TEST_PROPERTIES} (default: none)"

if [[ ! -z "$JMETER_TEST_PROPERTIES" ]]; then
	echo "Disabled options"
	echo "----------------"
	echo "$DISABLED_OPTS"
	
fi

if [[ "$GUI" == "yes" ]]; then
	echo ""
	echo "Launching GUI ....."
else
	echo ""
	echo "Running ...."
fi


time jmeter $([ "$GUI" == "yes" ] || (echo -n '-';echo 'n')) -t ${JMETER_TEST_PLAN} 	\
	-Jhttp.host=${HTTP_HOST} \
	-Jhttp.protocol=${HTTP_PROTOCOL} \
	-Jhttp.port=${HTTP_PORT} \
	-Jjdbc.url=${JDBC_URL} \
	-Jjdbc.username=${JDBC_USERNAME} \
	-Jjdbc.password=${JDBC_PASSWORD} \
	-Jrecovery.user1.username=${RECOVERY_USERNAME} \
	-Jrecovery.user1.password=${RECOVERY_PASSWORD} \
	-JloopCount=${JMETER_LOOP_COUNT} ${JMETER_PROPERTIES_STRING}