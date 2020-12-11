OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_8390_1
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO		NULLIF(ACT_NUM_ACTIVO=BLANKS)			"TRIM(:ACT_NUM_ACTIVO)",
	FECHA_FIRME		NULLIF(FECHA_FIRME=BLANKS)			"TRIM(:FECHA_FIRME)"
)
