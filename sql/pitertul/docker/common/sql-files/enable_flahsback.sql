-- export ORACLE_SID=orcl
-- sqlplus / as sysdba

alter system set db_recovery_file_dest="/oradata/flash" scope=both sid='*';

alter system set db_recovery_file_dest_size=17592186044416 scope=both sid='*';

ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 5 ( '/oradata/redo/log_1_5_A.rdo') SIZE 256M;

ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 6 ( '/oradata/redo/log_1_6.rdo') SIZE 256M;

ALTER DATABASE ADD LOGFILE THREAD 1 GROUP 7 ( '/oradata/redo/log_1_7.rdo') SIZE 256M;

ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 8 ( '/oradata/redo/log_2_8.rdo') SIZE 256M;

ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 9 ( '/oradata/redo/log_2_9.rdo') SIZE 256M;

ALTER DATABASE ADD LOGFILE THREAD 2 GROUP 10 ( '/oradata/redo/log_2_10.rdo') SIZE 256M;

alter system set log_archive_format='%t_%s_%r.dbf' scope=spfile  sid='*';

alter system set processes=1024 scope=spfile sid='*';

shutdown immediate;

startup mount exclusive;

alter database archivelog;

alter database open;


exit