#!/bin/bash

java -jar ../shells/cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2099 devon:type=Jobs getJobsRunningNamesList 2> /dev/null

exit $?
