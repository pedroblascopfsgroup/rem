#!/bin/bash
export PROJECT_BASE=$(dirname $0)

cd $PROJECT_BASE/../common

./run.sh $@
