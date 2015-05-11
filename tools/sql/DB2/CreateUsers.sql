/*CREATE BUFFERPOOL PFS SIZE 1000 PAGESIZE 8K*/


CREATE SCHEMA pfsmaster AUTHORIZATION pfsmaster;
CREATE SCHEMA pfs01 AUTHORIZATION pfs01;
CREATE SCHEMA pfs02 AUTHORIZATION pfs02;
CREATE SCHEMA pfs03 AUTHORIZATION pfs03;
CREATE SCHEMA pfs04 AUTHORIZATION pfs04;

CREATE REGULAR TABLESPACE "PFSMASTER"
	PAGESIZE 32K
	MANAGED BY SYSTEM
	USING( 'C:\Data\DB2\DB2\NODE0000\PFS\T0000000\PFSMASTER' )
	BUFFERPOOL PFS32
	DROPPED TABLE RECOVERY ON
	
	
GRANT CONNECT, CREATETAB ON DATABASE TO USER PFSMASTER
GO
GRANT USE OF TABLESPACE "PFSMASTER" TO USER PFSMASTER



CREATE SCHEMA pfs01 AUTHORIZATION pfs01


CREATE REGULAR TABLESPACE "PFS01"
	MANAGED BY SYSTEM
	USING( 'C:\Data\DB2\DB2\NODE0000\PFS\T0000000\PFS01' )
	EXTENTSIZE 200
	PREFETCHSIZE 16
	BUFFERPOOL IBMDEFAULTBP
	DROPPED TABLE RECOVERY ON
	
go

GRANT CONNECT, CREATETAB ON DATABASE TO USER PFS01
GO
GRANT USE OF TABLESPACE "PFS01" TO USER PFS01
go