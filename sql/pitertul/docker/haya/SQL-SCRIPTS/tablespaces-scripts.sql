ALTER TABLESPACE SYSAUX ADD DATAFILE '/oradata/SYSAUX-01.dbf' SIZE 512M AUTOEXTEND ON NEXT 128M MAXSIZE  UNLIMITED;

ALTER TABLESPACE SYSTEM ADD DATAFILE '/oradata/SYSTEM-01.dbf' SIZE 512M AUTOEXTEND ON NEXT 128M MAXSIZE  UNLIMITED;

ALTER TABLESPACE UNDOTBS1 ADD DATAFILE '/oradata/UNDOTBS1-01.dbf' SIZE 512M AUTOEXTEND ON NEXT 128M MAXSIZE  UNLIMITED;


CREATE TABLESPACE "HAYA01" DATAFILE
	 '/oradata/HAYA01-01.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
	,'/oradata/HAYA01-02.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
	,'/oradata/HAYA01-03.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE "HAYA02" DATAFILE
	 '/oradata/HAYA02-01.dbf' SIZE 512M AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
	,'/oradata/HAYA02-02.dbf' SIZE 512M AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
--	,'/oradata/HAYA02-03.dbf' SIZE 512M AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE "HAYAMASTER" DATAFILE
	 '/oradata/HAYAMASTER-01.dbf' SIZE 512M AUTOEXTEND ON NEXT 128M MAXSIZE  UNLIMITED 
	,'/oradata/HAYAMASTER-02.dbf' SIZE 512M AUTOEXTEND ON NEXT 128M MAXSIZE  UNLIMITED 
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

CREATE TABLESPACE "MINIREC" DATAFILE
	 '/oradata/MINIREC-01.dbf' SIZE 512M AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED 
	 ,'/oradata/MINIREC-02.dbf' SIZE 512M AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED 
	 ,'/oradata/MINIREC-03.dbf' SIZE 512M AUTOEXTEND ON NEXT 512M MAXSIZE  UNLIMITED 
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;



CREATE TABLESPACE "HAYA_IDX" DATAFILE 
	'/oradata/HAYA_IDX-01.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE 8192M
	,'/oradata/HAYA_IDX-02.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE 8192M
	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;


--CREATE TABLESPACE "HAYA01_IDX" DATAFILE 
--	'/oradata/HAYA01_IDX-01.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE 8192M
--	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;
--
--CREATE TABLESPACE "HAYA02_IDX" DATAFILE 
--	'/oradata/HAYA02_IDX-01.dbf' SIZE 1G AUTOEXTEND ON NEXT 512M MAXSIZE 8192M
--	LOGGING EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

exit;
