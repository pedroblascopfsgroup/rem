-- export ORACLE_SID=orcl
-- sqlplus / as sysdba

shutdown immediate;

startup mount exclusive;

flashback database to restore point before_test;

drop restore point before_test;

alter database flashback off;


alter database open resetlogs;

exit;
