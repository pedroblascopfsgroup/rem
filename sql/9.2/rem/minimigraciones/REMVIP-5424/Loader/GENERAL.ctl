OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_5424
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	NUM_ACTIVO		NULLIF(NUM_ACTIVO=BLANKS)	"TRIM(:NUM_ACTIVO)",
	GPV_ID			NULLIF(GPV_ID=BLANKS)			"TRIM(:GPV_ID)"
	
)

