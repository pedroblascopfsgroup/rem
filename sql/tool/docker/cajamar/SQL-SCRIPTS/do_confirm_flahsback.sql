-- export ORACLE_SID=orcl
-- sqlplus / as sysdba

shutdown immediate;

startup mount exclusive;

drop restore point before_test;

alter database flashback off;

exit;