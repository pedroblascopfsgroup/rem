OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_GCOM
TRUNCATE
FIELDS TERMINATED BY ','
TRAILING NULLCOLS
(
	ACT			INTEGER EXTERNAL NULLIF(ACT=BLANKS) 	"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT),';',' '), '\"',''),'''',''),1,16))",	
	USU			NULLIF(USU=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:USU),';',' '), '\"',''),'''','')",	
	TGE			NULLIF(TGE=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:TGE),';',' '), '\"',''),'''','')"
)