OPTIONS (DIRECT=TRUE, BINDSIZE=1024000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_9049
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	NUM_TRABAJO				NULLIF(NUM_TRABAJO=BLANKS)			"TRIM(:NUM_TRABAJO)",
	CODIGO_TARIFA_CAMBIAR			NULLIF(CODIGO_TARIFA_CAMBIAR=BLANKS)		"TRIM(:CODIGO_TARIFA_CAMBIAR)",
	DD_TCT_ID				NULLIF(DD_TCT_ID=BLANKS)			"TRIM(:DD_TCT_ID)"
)
