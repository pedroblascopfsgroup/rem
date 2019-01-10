#!/bin/bash

BASE=/home/bruno/cajamar-bbdd-container
./run.sh -remove -statistics -dmpdir=/home/bruno/DUMPS -oradata=$BASE/oradata -workspace=$BASE/workspace -errorlog=$BASE/cajamar-bbdd.log -piterdebug
