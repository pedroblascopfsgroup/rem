OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_10327
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	NUM_OFERTA				NULLIF(NUM_OFERTA=BLANKS)			"TRIM(:NUM_OFERTA)",
	NUEVA				NULLIF(NUEVA=BLANKS)			"TRIM(:NUEVA)",
	NUM_EXPEDIENTE				NULLIF(NUM_EXPEDIENTE=BLANKS)			"TRIM(:NUM_EXPEDIENTE)",
	RESPONSE				NULLIF(RESPONSE=BLANKS)			"TRIM(:RESPONSE)",
	REQUEST				NULLIF(REQUEST=BLANKS)			"TRIM(:REQUEST)",
	VIAJADO				NULLIF(VIAJADO=BLANKS)			"TRIM(:VIAJADO)"
	
	
)

