CREATE TABLESPACE "DRECOVERYONL8M" DATAFILE
	 '/oradata/drecoveryonl8m-01.dbf' SIZE 4G AUTOEXTEND ON NEXT 1024M MAXSIZE  UNLIMITED
	,'/oradata/drecoveryonl8m-02.dbf' SIZE 4G AUTOEXTEND ON NEXT 1024M MAXSIZE  UNLIMITED
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE "IRECOVERYONL8M" DATAFILE
	 '/oradata/irecoveryonl8m-01.dbf' SIZE 2G AUTOEXTEND ON NEXT 1024M MAXSIZE  UNLIMITED 
	,'/oradata/irecoveryonl8m-02.dbf' SIZE 2G AUTOEXTEND ON NEXT 1024M MAXSIZE  UNLIMITED 
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE "TEMPORAL" DATAFILE 
	'/oradata/temporal-01.dbf' SIZE 1G AUTOEXTEND ON NEXT 5012M MAXSIZE 8192M 
	LOGGING;

CREATE TABLESPACE "BANK_IDX" DATAFILE 
	'/oradata/bank_idx-01.dbf' SIZE 1G AUTOEXTEND ON NEXT 256M MAXSIZE 8192M
	,'/oradata/bank_idx-02.dbf' SIZE 1G AUTOEXTEND ON NEXT 256M MAXSIZE 8192M 
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
CREATE DIRECTORY scripts AS '/DUMP';
CREATE DIRECTORY systmp AS '/tmp';

exit;
