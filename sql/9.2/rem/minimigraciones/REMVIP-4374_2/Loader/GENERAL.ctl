OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_4374_LOC
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO				NULLIF(ACT_NUM_ACTIVO=BLANKS)				"TRIM(:ACT_NUM_ACTIVO)",
	LOC_LONGITUD				NULLIF(LOC_LONGITUD=BLANKS)				"TRIM(:LOC_LONGITUD)",
	LOC_LATITUD				NULLIF(LOC_LATITUD=BLANKS)				"TRIM(:LOC_LATITUD)",
	BIE_LOC_NOMBRE_VIA			NULLIF(BIE_LOC_NOMBRE_VIA=BLANKS)			"TRIM(:BIE_LOC_NOMBRE_VIA)",
	DD_TVI_ID				NULLIF(DD_TVI_ID=BLANKS)				"TRIM(:DD_TVI_ID)",
	BIE_LOC_NUMERO_DOMICILIO		NULLIF(BIE_LOC_NUMERO_DOMICILIO=BLANKS)			"TRIM(:BIE_LOC_NUMERO_DOMICILIO)",
	BIE_LOC_PORTAL				NULLIF(BIE_LOC_PORTAL=BLANKS)				"TRIM(:BIE_LOC_PORTAL)",
	BIE_LOC_PISO				NULLIF(BIE_LOC_PISO=BLANKS)				"TRIM(:BIE_LOC_PISO)",
	BIE_LOC_PUERTA				NULLIF(BIE_LOC_PUERTA=BLANKS)				"TRIM(:BIE_LOC_PUERTA)"

)
