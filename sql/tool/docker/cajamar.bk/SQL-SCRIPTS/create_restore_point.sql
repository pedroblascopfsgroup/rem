-- export ORACLE_SID=orcl
-- sqlplus / as sysdba

shutdown immediate;

startup mount exclusive;


alter database flashback on;

create restore point before_test guarantee flashback database;

alter database open;

exit;

/*
select name,scn,time,database_incarnation#,guarantee_flashback_database,storage_size
from v$restore_point
where guarantee_flashback_database = 'YES';
*/