#!/bin/bash
export PROJECT_BASE=$(pwd)/$(dirname $0)

cd $PROJECT_BASE/../common

./run.sh $@
