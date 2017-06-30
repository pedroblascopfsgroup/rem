OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/COMPRADOR_EXPEDIENTE.dat'
BADFILE './CTLs_DATs/bad/COMPRADOR_EXPEDIENTE.bad'
DISCARDFILE './CTLs_DATs/rejects/COMPRADOR_EXPEDIENTE.bad'
INTO TABLE REM01.MIG2_CEX_COMPRADOR_EXPEDIENTE
TRUNCATE
TRAILING NULLCOLS
(
	CEX_COD_OFERTA						POSITION(1:17)			INTEGER EXTERNAL												"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_OFERTA),';',' '), '\"',''),'''',''),2,16))",
	CEX_COD_COMPRADOR					POSITION(18:34)			INTEGER EXTERNAL												"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_COMPRADOR),';',' '), '\"',''),'''',''),2,16))",
	CEX_COD_ESTADO_CIVIL				POSITION(35:54)			CHAR NULLIF(CEX_COD_ESTADO_CIVIL=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_ESTADO_CIVIL),';',' '), '\"',''),'''','')",
	CEX_COD_REGIMEN_MATRIMONIAL			POSITION(55:74)			CHAR NULLIF(CEX_COD_REGIMEN_MATRIMONIAL=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_REGIMEN_MATRIMONIAL),';',' '), '\"',''),'''','')",
	CEX_DOCUMENTO_CONYUGE				POSITION(75:124)		CHAR NULLIF(CEX_DOCUMENTO_CONYUGE=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:CEX_DOCUMENTO_CONYUGE),';',' '), '\"',''),'''','')",
	CEX_IND_ANTIGUO_DEUDOR				POSITION(125:126)		INTEGER EXTERNAL NULLIF(CEX_IND_ANTIGUO_DEUDOR=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CEX_IND_ANTIGUO_DEUDOR),';',' '), '\"',''),'''',''),2,1))",
	CEX_COD_USO_ACTIVO					POSITION(127:146)		CHAR NULLIF(CEX_COD_USO_ACTIVO=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_USO_ACTIVO),';',' '), '\"',''),'''','')",
	CEX_IMPORTE_PROPORCIONAL_OFR		POSITION(147:163)		INTEGER EXTERNAL NULLIF(CEX_IMPORTE_PROPORCIONAL_OFR=BLANKS)	"CASE WHEN (:CEX_IMPORTE_PROPORCIONAL_OFR) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CEX_IMPORTE_PROPORCIONAL_OFR,1,15)||','||SUBSTR(:CEX_IMPORTE_PROPORCIONAL_OFR,16,2)),';',' '), '\"',''),'''','')) END",
	CEX_IMPORTE_FINANCIADO				POSITION(164:180)		INTEGER EXTERNAL NULLIF(CEX_IMPORTE_FINANCIADO=BLANKS)			"CASE WHEN (:CEX_IMPORTE_FINANCIADO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CEX_IMPORTE_FINANCIADO,1,15)||','||SUBSTR(:CEX_IMPORTE_FINANCIADO,16,2)),';',' '), '\"',''),'''','')) END",
	CEX_RESPONSABLE_TRAMITACION			POSITION(181:436)		CHAR NULLIF(CEX_RESPONSABLE_TRAMITACION=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:CEX_RESPONSABLE_TRAMITACION),';',' '), '\"',''),'''','')",
	CEX_IND_PBC							POSITION(437:438)		INTEGER EXTERNAL NULLIF(CEX_IND_PBC=BLANKS)						"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CEX_IND_PBC),';',' '), '\"',''),'''',''),2,1))",
	CEX_PORCENTAJE_COMPRA				POSITION(439:455) 		INTEGER EXTERNAL NULLIF(CEX_PORCENTAJE_COMPRA=BLANKS) 			"CASE WHEN (:CEX_PORCENTAJE_COMPRA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:CEX_PORCENTAJE_COMPRA,1,15)||','||SUBSTR(:CEX_PORCENTAJE_COMPRA,16,2)),';',' '), '\"',''),'''','')) END",
	CEX_IND_TITULAR_RESERVA				POSITION(456:457)		INTEGER EXTERNAL NULLIF(CEX_IND_TITULAR_RESERVA=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CEX_IND_TITULAR_RESERVA),';',' '), '\"',''),'''',''),2,1))",
	CEX_IND_TITULAR_CONTRATACION		POSITION(458:459)		INTEGER EXTERNAL NULLIF(CEX_IND_TITULAR_CONTRATACION=BLANKS)	"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CEX_IND_TITULAR_CONTRATACION),';',' '), '\"',''),'''',''),2,1))",
	CEX_NOMBRE_REPRESENTANTE			POSITION(460:715)		CHAR NULLIF(CEX_NOMBRE_REPRESENTANTE=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:CEX_NOMBRE_REPRESENTANTE),';',' '), '\"',''),'''','')",
	CEX_APELLIDOS_REPRESENTANTE			POSITION(716:971)		CHAR NULLIF(CEX_APELLIDOS_REPRESENTANTE=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:CEX_APELLIDOS_REPRESENTANTE),';',' '), '\"',''),'''','')",
	CEX_COD_TIPO_DOC_RTE				POSITION(972:991)		CHAR NULLIF(CEX_COD_TIPO_DOC_RTE=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_TIPO_DOC_RTE),';',' '), '\"',''),'''','')",
	CEX_DOCUMENTO_RTE					POSITION(992:1041)		CHAR NULLIF(CEX_DOCUMENTO_RTE=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:CEX_DOCUMENTO_RTE),';',' '), '\"',''),'''','')",
	CEX_TELEFONO1_RTE					POSITION(1042:1091)		CHAR NULLIF(CEX_TELEFONO1_RTE=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:CEX_TELEFONO1_RTE),';',' '), '\"',''),'''','')",
	CEX_TELEFONO2_RTE					POSITION(1092:1141)		CHAR NULLIF(CEX_TELEFONO2_RTE=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:CEX_TELEFONO2_RTE),';',' '), '\"',''),'''','')",
	CEX_EMAIL_RTE						POSITION(1142:1191)		CHAR NULLIF(CEX_EMAIL_RTE=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:CEX_EMAIL_RTE),';',' '), '\"',''),'''','')",
	CEX_COD_TIPO_VIA_RTE				POSITION(1192:1211)		CHAR NULLIF(CEX_COD_TIPO_VIA_RTE=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_TIPO_VIA_RTE),';',' '), '\"',''),'''','')",
	CEX_DIRECCION_RTE					POSITION(1212:1467)		CHAR NULLIF(CEX_DIRECCION_RTE=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:CEX_DIRECCION_RTE),';',' '), '\"',''),'''','')",
	CEX_COD_LOCALIDAD_RTE				POSITION(1468:1487)		CHAR NULLIF(CEX_COD_LOCALIDAD_RTE=BLANKS)						"LPAD(NVL(REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_LOCALIDAD_RTE),';',' '), '\"',''),'''',''),'00000'),5,'0')",
	CEX_CODIGO_POSTAL_RTE				POSITION(1488:1492)		CHAR NULLIF(CEX_CODIGO_POSTAL_RTE=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:CEX_CODIGO_POSTAL_RTE),';',' '), '\"',''),'''','')",
	CEX_COD_UNIDADPOBLACIONAL_RTE		POSITION(1493:1512)		CHAR NULLIF(CEX_COD_UNIDADPOBLACIONAL_RTE=BLANKS)				"REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_UNIDADPOBLACIONAL_RTE),';',' '), '\"',''),'''','')",
	CEX_COD_PROVINCIA_RTE				POSITION(1513:1532)		CHAR NULLIF(CEX_COD_PROVINCIA_RTE=BLANKS)						"TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(:CEX_COD_PROVINCIA_RTE),';',' '), '\"',''),'''',''))",
	CEX_FECHA_PETICION					POSITION(1533:1540)		DATE 'YYYYMMDD' NULLIF(CEX_FECHA_PETICION=BLANKS)				"REPLACE(:CEX_FECHA_PETICION, '00000000', '')",
	CEX_FECHA_RESOLUCION				POSITION(1541:1548)		DATE 'YYYYMMDD' NULLIF(CEX_FECHA_RESOLUCION=BLANKS)				"REPLACE(:CEX_FECHA_RESOLUCION, '00000000', '')",
VALIDACION CONSTANT "0")
