OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_HREOS_5932
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ID_HAYA						NULLIF(ID_HAYA=BLANKS)						"TRIM(:ID_HAYA)",
	DESTINO_COMERCIAL			NULLIF(DESTINO_COMERCIAL=BLANKS)			"(:DESTINO_COMERCIAL)",
	ALQUILADO					NULLIF(ALQUILADO=BLANKS)					"(:ALQUILADO)",
	TIPO_CONTRATO_ALQUILER		NULLIF(TIPO_CONTRATO_ALQUILER=BLANKS)		"(:TIPO_CONTRATO_ALQUILER)",
	SUBROGADO					NULLIF(SUBROGADO=BLANKS)					"(:SUBROGADO)",
	INQUILINO_ANT_PROP			NULLIF(INQUILINO_ANT_PROP=BLANKS)			"(:INQUILINO_ANT_PROP)",
	ESTADO_ADECUACION			NULLIF(ESTADO_ADECUACION=BLANKS)			"(:ESTADO_ADECUACION)",
	RENTA_ANTIGUA				NULLIF(RENTA_ANTIGUA=BLANKS)				"(:RENTA_ANTIGUA)"
)
