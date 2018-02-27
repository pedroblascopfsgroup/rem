-- BANKIA
CREATE SMALLFILE TABLESPACE "BANK01" DATAFILE
'/oradata/bank01-01.dbf' SIZE 6G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M ,
'/oradata/bank01-02.dbf' SIZE 6G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M ,
'/oradata/bank01-03.dbf' SIZE 6G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M ,
'/oradata/bank01-04.dbf' SIZE 6G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M ,
'/oradata/bank01-05.dbf' SIZE 6G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M ,
'/oradata/bank01-06.dbf' SIZE 6G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M ,
'/oradata/bank01-07.dbf' SIZE 6G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M 
LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE SMALLFILE TABLESPACE "BANKMASTER" DATAFILE
'/oradata/bankmaster.dbf' SIZE 1024M REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M
LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE SMALLFILE TABLESPACE "MINIREC" DATAFILE
'/oradata/minirec-01.dbf' SIZE 1G REUSE AUTOEXTEND ON NEXT 128M MAXSIZE 8192M 
LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

exit;