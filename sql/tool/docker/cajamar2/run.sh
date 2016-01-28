#!/bin/bash
export PROJECT_BASE=$(pwd)/$(dirname $0)

source $PROJECT_BASE/setDbDockerEnv.sh

cd $PROJECT_BASE/../common

./run.sh $@