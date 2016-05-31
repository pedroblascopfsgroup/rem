-- export ORACLE_SID=orcl
-- sqlplus / as sysdba

shutdown immediate;

startup exclusive mount orcl; 

drop restore point before_test;

alter database flashback off;

alter database open;

exit;
