OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/COMPRADORES.dat'
BADFILE './CTLs_DATs/bad/COMPRADORES.bad'
DISCARDFILE './CTLs_DATs/rejects/COMPRADORES.bad'
INTO TABLE REM01.MIG2_COM_COMPRADORES
TRUNCATE
TRAILING NULLCOLS
(
	COM_COD_COMPRADOR           	POSITION(1:20)                     CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_COMPRADOR),';',' '), '\"',''),'''','')",
	COM_COD_TIPO_PERSONA           	POSITION(21:40)                    CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_TIPO_PERSONA),';',' '), '\"',''),'''','')",
	COM_NOMBRE           			POSITION(41:296)                   CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_NOMBRE),';',' '), '\"',''),'''','')",
	COM_APELLIDOS           		POSITION(297:552)                  CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_APELLIDOS),';',' '), '\"',''),'''','')",
	COM_COD_TIPO_DOCUMENTO          POSITION(553:572)                  CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_TIPO_DOCUMENTO),';',' '), '\"',''),'''','')",
	COM_DOCUMENTO           		POSITION(573:622)                  CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_DOCUMENTO),';',' '), '\"',''),'''','')",
	COM_COD_TIPO_DOC_REPRESENT      POSITION(623:642)                  CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_TIPO_DOC_REPRESENT),';',' '), '\"',''),'''','')",
	CEX_DOCUMENTO_RTE           	POSITION(643:692)                  CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:CEX_DOCUMENTO_RTE),';',' '), '\"',''),'''','')",
	COM_TELEFONO1           		POSITION(693:742)                  CHAR  NULLIF(COM_TELEFONO1=BLANKS)               "REPLACE(REPLACE(REPLACE(TRIM(:COM_TELEFONO1),';',' '), '\"',''),'''','')",
	COM_TELEFONO2           		POSITION(743:792)                  CHAR  NULLIF(COM_TELEFONO2=BLANKS)               "REPLACE(REPLACE(REPLACE(TRIM(:COM_TELEFONO2),';',' '), '\"',''),'''','')",
	COM_EMAIL           			POSITION(793:842)                  CHAR  NULLIF(COM_EMAIL=BLANKS)                   "REPLACE(REPLACE(REPLACE(TRIM(:COM_EMAIL),';',' '), '\"',''),'''','')",
	COM_COD_TIPO_VIA           		POSITION(843:862)                  CHAR  NULLIF(COM_COD_TIPO_VIA=BLANKS)            "REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_TIPO_VIA),';',' '), '\"',''),'''','')",
	COM_DIRECCION           		POSITION(863:1118)                 CHAR  NULLIF(COM_DIRECCION=BLANKS)               "REPLACE(REPLACE(REPLACE(TRIM(:COM_DIRECCION),';',' '), '\"',''),'''','')",
	COM_NUMEROCALLE           		POSITION(1119:1218)                CHAR  NULLIF(COM_NUMEROCALLE=BLANKS)             "REPLACE(REPLACE(REPLACE(TRIM(:COM_NUMEROCALLE),';',' '), '\"',''),'''','')",
	COM_ESCALERA           			POSITION(1219:1228)                CHAR  NULLIF(COM_ESCALERA=BLANKS)                "REPLACE(REPLACE(REPLACE(TRIM(:COM_ESCALERA),';',' '), '\"',''),'''','')",
	COM_PLANTA           			POSITION(1229:1238)                CHAR  NULLIF(COM_PLANTA=BLANKS)                  "REPLACE(REPLACE(REPLACE(TRIM(:COM_PLANTA),';',' '), '\"',''),'''','')",
	COM_PUERTA           			POSITION(1239:1248)                CHAR  NULLIF(COM_PUERTA=BLANKS)                  "REPLACE(REPLACE(REPLACE(TRIM(:COM_PUERTA),';',' '), '\"',''),'''','')",
	COM_COD_LOCALIDAD           	POSITION(1249:1268)                CHAR                   							"LPAD(NVL(REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_LOCALIDAD),';',' '), '\"',''),'''',''),'00000'),5,'0')",
	COM_CODIGO_POSTAL           	POSITION(1269:1273)                CHAR  NULLIF(COM_CODIGO_POSTAL=BLANKS)           "REPLACE(REPLACE(REPLACE(TRIM(:COM_CODIGO_POSTAL),';',' '), '\"',''),'''','')",
	COM_COD_UNIDADPOBLACIONAL       POSITION(1274:1293)                CHAR  NULLIF(COM_COD_UNIDADPOBLACIONAL=BLANKS)   "REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_UNIDADPOBLACIONAL),';',' '), '\"',''),'''','')",
	COM_COD_PROVINCIA           	POSITION(1294:1313)                CHAR                   							"REPLACE(REPLACE(REPLACE(TRIM(:COM_COD_PROVINCIA),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0")
