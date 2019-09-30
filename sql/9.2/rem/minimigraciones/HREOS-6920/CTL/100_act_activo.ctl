OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999, SKIP=1)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTL/IN/ParesServicerInmueble.csv'
BADFILE './CTL/BAD/ParesServicerInmueble.bad'
DISCARDFILE './CTL/REJECTS/ParesServicerInmueble.bad'
INTO TABLE REM01.TMP_ACT_ACTIVO_SANTANDER
TRUNCATE
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
	ID_HAYA "TRIM(:ID_HAYA)", 
	ID_SERVICER "TRIM(:ID_SERVICER)",
	ID_INMUEBLE_BS "TRIM(:ID_INMUEBLE_BS)"
)
