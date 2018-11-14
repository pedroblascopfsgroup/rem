OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_2432_2
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ID_ACTIVO_HAYA					NULLIF(ID_ACTIVO_HAYA=BLANKS)						"TRIM(:ID_ACTIVO_HAYA)",
	ID_SAREB_ACTUAL					NULLIF(ID_SAREB_ACTUAL=BLANKS)						"TRIM(:ID_SAREB_ACTUAL)",
	ID_SAREB_CORRECTO				NULLIF(ID_SAREB_CORRECTO=BLANKS)					"TRIM(:ID_SAREB_CORRECTO)"
		
)
