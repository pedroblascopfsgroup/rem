#!/bin/bash

mvn -Dmaven.test.failure.ignore=true package -Dversion.recobro=1.1.0 -Dsufijo=_rc8
mv target/recovery-recobroWeb-plugin-1.1.0_rc8.jar target/recovery-recobroWeb-plugin-1.1.0_rc8-SNAPSHOT.jar
