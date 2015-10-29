#!/bin/sh

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -----------------------------------------------------------------------------
# Start Script for the CATALINA Server
#
# $Id: startup.sh 562770 2007-08-04 22:13:58Z markt $
# -----------------------------------------------------------------------------

export CATALINA_BASE=$CATALINA_HOME
export CATALINA_PID=${CATALINA_BASE}/bin/catalina.pid
export CATALINA_OPTS="-Dcom.sun.management.jmxremote \
-Djava.awt.headless=true \
-Djava.rmi.server.hostname=localhost \
-Dcom.sun.management.jmxremote.port=TOMCAT_JMX_PORT \
-Dcom.sun.management.jmxremote.ssl=false \
-Dcom.sun.management.jmxremote.authenticate=false \
-XX:+HeapDumpOnOutOfMemoryError \
TOMCAT_MEM_PARAMS \
-Xdebug 
-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044"


# Better OS/400 detection: see Bugzilla 31132
os400=false
darwin=false
case "`uname`" in
CYGWIN*) cygwin=true;;
OS400*) os400=true;;
Darwin*) darwin=true;;
esac

# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
 
PRGDIR=`dirname "$PRG"`
EXECUTABLE=catalina.sh
EXECUTABLE_PATH="$CATALINA_BASE"/bin/"$EXECUTABLE"

# Check that target executable exists
if $os400; then
  # -x will Only work on the os400 if the files are: 
  # 1. owned by the user
  # 2. owned by the PRIMARY group of the user
  # this will not work if the user belongs in secondary groups
  eval
else
  if [ ! -x "$EXECUTABLE_PATH" ]; then
    echo "Cannot find $PRGDIR/$EXECUTABLE"
    echo "This file is needed to run this program"
    exit 1
  fi
fi 

exec "$EXECUTABLE_PATH" start "$@"
