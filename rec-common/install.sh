#!/bin/bash
mvn -Dmaven.test.skip=true install -Dversion.recobro=2.9.1 -Dsufijo=_sencha_rc1
mv target/rec-common-2.9.1_sencha_rc1.jar target/rec-common-2.9.1_sencha_rc1-SNAPSHOT.jar
