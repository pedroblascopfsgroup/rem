OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_10387
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO				NULLIF(ACT_NUM_ACTIVO=BLANKS)			"TRIM(:ACT_NUM_ACTIVO)",
	num_agrupacion				NULLIF(num_agrupacion=BLANKS)			"TRIM(:num_agrupacion)",
	estado_publi				NULLIF(estado_publi=BLANKS)			"TRIM(:estado_publi)",
	sit_comercial				NULLIF(sit_comercial=BLANKS)			"TRIM(:sit_comercial)",
	publicar_sin_precio				NULLIF(publicar_sin_precio=BLANKS)			"TRIM(:publicar_sin_precio)",
	estado_publi_anterior				NULLIF(estado_publi_anterior=BLANKS)			"TRIM(:estado_publi_anterior)",
	estado_publi_actual				NULLIF(estado_publi_actual=BLANKS)			"TRIM(:estado_publi_actual)",
	estado_pep				NULLIF(estado_pep=BLANKS)			"TRIM(:estado_pep)"
)

