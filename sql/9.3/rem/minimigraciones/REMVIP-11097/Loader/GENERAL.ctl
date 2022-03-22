OPTIONS (DIRECT=TRUE, BINDSIZE=1024000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_11097
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	DOCUMENTO				NULLIF(DOCUMENTO=BLANKS)			"TRIM(:DOCUMENTO)",
	NOMBRE					NULLIF(NOMBRE=BLANKS)				"TRIM(:NOMBRE)",
	APELLIDO_1				NULLIF(APELLIDO_1=BLANKS)			"TRIM(:APELLIDO_1)",
	APELLIDO_2				NULLIF(APELLIDO_2=BLANKS)			"TRIM(:APELLIDO_2)",
	TIPO_PERSONA				NULLIF(TIPO_PERSONA=BLANKS)			"TRIM(:TIPO_PERSONA)",
	TIPO_DOCUMENTO				NULLIF(TIPO_DOCUMENTO=BLANKS)			"TRIM(:TIPO_DOCUMENTO)",
	ID_PERSONA_HAYA_CAIXA			NULLIF(ID_PERSONA_HAYA_CAIXA=BLANKS)		"TRIM(:ID_PERSONA_HAYA_CAIXA)",
	ID_PERSONA_HAYA			NULLIF(ID_PERSONA_HAYA=BLANKS)		"TRIM(:ID_PERSONA_HAYA)",
	DOMICILIO				NULLIF(DOMICILIO=BLANKS)			"TRIM(:DOMICILIO)",
	COD_POSTAL				NULLIF(COD_POSTAL=BLANKS)			"TRIM(:COD_POSTAL)",
	TEL_1					NULLIF(TEL_1=BLANKS)				"TRIM(:TEL_1)",
	TEL_2					NULLIF(TEL_2=BLANKS)				"TRIM(:TEL_2)",
	TEL_3					NULLIF(TEL_3=BLANKS)				"TRIM(:TEL_3)",
	EMAIL					NULLIF(EMAIL=BLANKS)				"TRIM(:EMAIL)"
)

