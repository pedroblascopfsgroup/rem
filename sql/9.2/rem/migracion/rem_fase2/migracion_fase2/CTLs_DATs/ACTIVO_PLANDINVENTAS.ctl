OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/ACTIVO_PLANDINVENTAS.dat'
BADFILE './CTLs_DATs/bad/ACTIVO_PLANDINVENTAS.bad'
DISCARDFILE './CTLs_DATs/rejects/ACTIVO_PLANDINVENTAS.bad'
INTO TABLE REM01.MIG2_APD_ACTIVO_PLANDINVENTAS
TRUNCATE
TRAILING NULLCOLS
(
	APD_ACT_NUMERO_ACTIVO				POSITION(1:17)			INTEGER EXTERNAL										"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:APD_ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	APD_NOMBRE_ACREEDOR_ANTERIOR		POSITION(18:117)		CHAR NULLIF(APD_NOMBRE_ACREEDOR_ANTERIOR=BLANKS)		"REPLACE(REPLACE(REPLACE(TRIM(:APD_NOMBRE_ACREEDOR_ANTERIOR),';',' '), '\"',''),'''','')"
)
