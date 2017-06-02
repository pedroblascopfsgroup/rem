OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/PROPUESTAS_PRECIOS.dat'
BADFILE './CTLs_DATs/bad/PROPUESTAS_PRECIOS.bad'
DISCARDFILE './CTLs_DATs/rejects/PROPUESTAS_PRECIOS.bad'
INTO TABLE REM01.MIG2_PRP_PROPUESTAS_PRECIOS
TRUNCATE
TRAILING NULLCOLS
(
	PRP_NUM_PROPUESTA		POSITION(1:17)			INTEGER EXTERNAL											"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PRP_NUM_PROPUESTA),';',' '), '\"',''),'''',''),2,16))",
	PRP_NOMBRE_PROPUESTA	POSITION(18:273)		CHAR 														"REPLACE(REPLACE(REPLACE(TRIM(:PRP_NOMBRE_PROPUESTA),';',' '), '\"',''),'''','')",
	PRP_COD_ESTADO_PRP		POSITION(274:293)		CHAR														"REPLACE(REPLACE(REPLACE(TRIM(:PRP_COD_ESTADO_PRP),';',' '), '\"',''),'''','')",
	PRP_COD_CARTERA			POSITION(294:313)		CHAR														"REPLACE(REPLACE(REPLACE(TRIM(:PRP_COD_CARTERA),';',' '), '\"',''),'''','')",
	PRP_COD_USUARIO			POSITION(314:333)		CHAR NULLIF(PRP_COD_USUARIO=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:PRP_COD_USUARIO),';',' '), '\"',''),'''','')",
	PRP_COD_TIPO_PRP		POSITION(334:353)		CHAR														"REPLACE(REPLACE(REPLACE(TRIM(:PRP_COD_TIPO_PRP),';',' '), '\"',''),'''','')",
	PRP_IND_PROP_MANUAL		POSITION(354:355)		INTEGER EXTERNAL NULLIF(PRP_IND_PROP_MANUAL=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PRP_IND_PROP_MANUAL),';',' '), '\"',''),'''',''),2,1))",
	PRP_FECHA_EMISION		POSITION(356:363)		DATE 'YYYYMMDD' NULLIF(PRP_FECHA_EMISION=BLANKS)			"REPLACE(:PRP_FECHA_EMISION, '00000000', '')",
	PRP_FECHA_ENVIO			POSITION(364:371)		DATE 'YYYYMMDD' NULLIF(PRP_FECHA_ENVIO=BLANKS)				"REPLACE(:PRP_FECHA_ENVIO, '00000000', '')",
	PRP_FECHA_SANCION		POSITION(372:379)		DATE 'YYYYMMDD' NULLIF(PRP_FECHA_SANCION=BLANKS)			"REPLACE(:PRP_FECHA_SANCION, '00000000', '')",
	PRP_FECHA_CARGA			POSITION(380:387)		DATE 'YYYYMMDD' NULLIF(PRP_FECHA_CARGA=BLANKS)				"REPLACE(:PRP_FECHA_CARGA, '00000000', '')",
	PRP_OBSERVACIONES		POSITION(388:643)		CHAR NULLIF(PRP_OBSERVACIONES=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:PRP_OBSERVACIONES),';',' '), '\"',''),'''','')"	,
	VALIDACION CONSTANT "0"	
)
