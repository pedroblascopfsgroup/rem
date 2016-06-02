-- export ORACLE_SID=orcl
-- sqlplus / as sysdba

shutdown immediate;

startup exclusive mount orcl;

alter database archivelog;

alter database flashback on;

create restore point before_test guarantee flashback database;

alter database open;

exit;
