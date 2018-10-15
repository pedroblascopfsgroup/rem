OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_2149_LAT_LONG
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	NUM_ACTIVO_HAYA					NULLIF(NUM_ACTIVO_HAYA=BLANKS)						"TRIM(:NUM_ACTIVO_HAYA)",
	LATITUD_CATASTRO				NULLIF(LATITUD_CATASTRO=BLANKS)						"TRIM(:LATITUD_CATASTRO)",
	LONGITUD_CATASTRO				NULLIF(LONGITUD_CATASTRO=BLANKS)			        "TRIM(:LONGITUD_CATASTRO)"
	
)
