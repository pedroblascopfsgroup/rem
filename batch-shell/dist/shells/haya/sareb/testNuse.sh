#!/bin/bash
sqlplus PFSRECOVERY/admin@testNuse.sql << EOF > nuse.log
SELECT sysdate FROM DUAL;
SELECT sysdate FECHA FROM DUAL;
EOF
