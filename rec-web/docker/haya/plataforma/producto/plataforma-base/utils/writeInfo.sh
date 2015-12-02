#/bin/bash

MY_DIR=$CONTAINER_INFO_DIR/$PROJECT/$HOSTNAME

if [ ! -d $MY_DIR ]; then
	mkdir -p $MY_DIR
fi

env | grep -ve "^OLD" | sort > $MY_DIR/setEnv_current.sh

chmod o+rx $CONTAINER_INFO_DIR/$PROJECT/$HOSTNAME
chmod o+rx $CONTAINER_INFO_DIR/$PROJECT
chmod o+rx $CONTAINER_INFO_DIR

