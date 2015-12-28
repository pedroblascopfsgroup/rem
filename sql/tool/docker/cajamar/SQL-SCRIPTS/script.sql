CREATE TABLESPACE "DRECOVERYONL8M" DATAFILE
	 '/oradata/drecoveryonl8m-01.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
	,'/oradata/drecoveryonl8m-02.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE "IRECOVERYONL8M" DATAFILE
	 '/oradata/irecoveryonl8m-01.dbf' SIZE 512M AUTOEXTEND ON NEXT 256M MAXSIZE  UNLIMITED 
	,'/oradata/irecoveryonl8m-02.dbf' SIZE 512M AUTOEXTEND ON NEXT 256M MAXSIZE  UNLIMITED 
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE "TEMPORAL" DATAFILE 
	'/oradata/temporal-01.dbf' SIZE 256M AUTOEXTEND ON NEXT 256M MAXSIZE 8192M 
	LOGGING;

CREATE TABLESPACE "BANK_IDX" DATAFILE 
	'/oradata/bank_idx-01.dbf' SIZE 256M AUTOEXTEND ON NEXT 256M MAXSIZE 8192M
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
CREATE DIRECTORY scripts AS '/DUMP';
CREATE DIRECTORY systmp AS '/tmp';


GRANT ANALYZE ANY to system;

exit;
