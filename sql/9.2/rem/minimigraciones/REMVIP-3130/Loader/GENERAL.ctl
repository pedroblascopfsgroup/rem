OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_ACT_SELLO_CALIDAD
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO					NULLIF(ACT_NUM_ACTIVO=BLANKS)				"TRIM(:ACT_NUM_ACTIVO)",
	ACT_FECHA_SELLO_CALIDAD				NULLIF(ACT_FECHA_SELLO_CALIDAD=BLANKS)				"TRIM( TO_DATE( :ACT_FECHA_SELLO_CALIDAD , 'DD/MM/YYYY' ) )"

	

)
