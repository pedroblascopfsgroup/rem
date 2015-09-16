#!/bin/bash
# port:3301
#devon:type=BPMfwkBatchManager
#port 3301
DISPLAY=localhost:10.0
export DISPLAY
java -jar cmdline-jmxclient-0.10.3.jar jmx_admin:pfs_admin localhost:2198 devon:type=BatchRecuperaciones ejecutarProcesoRevisionExpedientes=2038
