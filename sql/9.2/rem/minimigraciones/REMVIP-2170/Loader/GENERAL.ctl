OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_2170
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	NUM_OFERTA				NULLIF(NUM_OFERTA=BLANKS)						"TRIM(:NUM_OFERTA)",
	NUM_ACTIVO				NULLIF(NUM_ACTIVO=BLANKS)						"TRIM(:NUM_ACTIVO)"

	
)
