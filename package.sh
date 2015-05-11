#!/bin/bash
mvn -Dmaven.test.skip=true package -Dversion.recobro=2.4.0 -Dsufijo=_sencha_rc2
mv target/rec-common-2.4.0_sencha_rc2.jar target/rec-common-2.4.0_sencha_rc2-SNAPSHOT.jar
