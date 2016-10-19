OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/CLIENTES_COMERCIALES.dat'
BADFILE './CTLs_DATs/bad/CLIENTES_COMERCIALES.bad'
DISCARDFILE './CTLs_DATs/rejects/CLIENTES_COMERCIALES.bad'
INTO TABLE REM01.MIG2_CLC_CLIENTE_COMERCIAL
TRUNCATE
TRAILING NULLCOLS
(
	CLC_COD_CLIENTE_WEBCOM	   		POSITION(1:17)			INTEGER EXTERNAL 										"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_CLIENTE_WEBCOM),';',' '), '\"',''),'''',''),2,16))",
	CLC_COD_CLIENTE_HAYA			POSITION(18:34)			INTEGER EXTERNAL NULLIF(CLC_COD_CLIENTE_HAYA=BLANKS)	"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_CLIENTE_HAYA),';',' '), '\"',''),'''',''),2,16))",
	CLC_COD_CLIENTE_UVEM			POSITION(35:51)			INTEGER EXTERNAL NULLIF(CLC_COD_CLIENTE_UVEM=BLANKS) 	"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_CLIENTE_UVEM),';',' '),'\"',''),'''',''),2,16))",
	CLC_RAZON_SOCIAL				POSITION(52:307)		CHAR NULLIF(CLC_RAZON_SOCIAL=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_RAZON_SOCIAL),';',' '),'\"',''),'''','')",
	CLC_NOMBRE						POSITION(308:563)		CHAR NULLIF(CLC_NOMBRE=BLANKS) 							"REPLACE(REPLACE(REPLACE(TRIM(:CLC_NOMBRE),';',' '),'\"',''),'''','')",
	CLC_APELLIDOS					POSITION(564:819)		CHAR NULLIF(CLC_APELLIDOS=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:CLC_APELLIDOS),';',' '),'\"',''),'''','')",
	CLC_FECHA_ALTA					POSITION(820:827)		DATE 'YYYYMMDD' NULLIF(CLC_FECHA_ALTA=BLANKS) 			"REPLACE(:CLC_FECHA_ALTA, '00000000', '')",
	CLC_COD_USUARIO_LDAP_ACCION		POSITION(828:877)		CHAR NULLIF(CLC_COD_USUARIO_LDAP_ACCION=BLANKS) 		"REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_USUARIO_LDAP_ACCION),';',' '), '\"',''),'''','')",
	CLC_COD_TIPO_DOCUMENTO			POSITION(878:897)		CHAR NULLIF(CLC_COD_TIPO_DOCUMENTO=BLANKS) 				"REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_TIPO_DOCUMENTO),';',' '), '\"',''),'''','')",
	CLC_DOCUMENTO					POSITION(898:947)		CHAR NULLIF(CLC_DOCUMENTO=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:CLC_DOCUMENTO),';',' '), '\"',''),'''','')",
	CLC_COD_TIPO_DOC_RTE			POSITION(948:967)		CHAR NULLIF(CLC_COD_TIPO_DOC_RTE=BLANKS) 				"REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_TIPO_DOC_RTE),';',' '), '\"',''),'''','')",
	CLC_DOCUMENTO_RTE				POSITION(968:1017)		CHAR NULLIF(CLC_DOCUMENTO_RTE=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_DOCUMENTO_RTE),';',' '), '\"',''),'''','')",
	CLC_TELEFONO1					POSITION(1018:1067)		CHAR NULLIF(CLC_TELEFONO1=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:CLC_TELEFONO1),';',' '), '\"',''),'''','')",
	CLC_TELEFONO2					POSITION(1068:1117)		CHAR NULLIF(CLC_TELEFONO2=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:CLC_TELEFONO2),';',' '), '\"',''),'''','')",
	CLC_EMAIL						POSITION(1118:1167)		CHAR NULLIF(CLC_EMAIL=BLANKS) 							"REPLACE(REPLACE(REPLACE(TRIM(:CLC_EMAIL),';',' '), '\"',''),'''','')",
	CLC_COD_TIPO_VIA				POSITION(1168:1187)		CHAR NULLIF(CLC_COD_TIPO_VIA=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_TIPO_VIA),';',' '), '\"',''),'''','')",
	CLC_CLC_DIRECCION				POSITION(1188:1287)		CHAR NULLIF(CLC_CLC_DIRECCION=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_CLC_DIRECCION),';',' '), '\"',''),'''','')",
	CLC_NUMEROCALLE					POSITION(1288:1387)		CHAR NULLIF(CLC_NUMEROCALLE=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_NUMEROCALLE),';',' '), '\"',''),'''','')",
	CLC_ESCALERA					POSITION(1388:1397)		CHAR NULLIF(CLC_ESCALERA=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:CLC_ESCALERA),';',' '), '\"',''),'''','')",
	CLC_PLANTA						POSITION(1398:1407)		CHAR NULLIF(CLC_PLANTA=BLANKS) 							"REPLACE(REPLACE(REPLACE(TRIM(:CLC_PLANTA),';',' '), '\"',''),'''','')",
	CLC_PUERTA						POSITION(1408:1417)		CHAR NULLIF(CLC_PUERTA=BLANKS) 							"REPLACE(REPLACE(REPLACE(TRIM(:CLC_PUERTA),';',' '), '\"',''),'''','')",
	CLC_COD_LOCALIDAD				POSITION(1418:1437)		CHAR NULLIF(CLC_COD_LOCALIDAD=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_LOCALIDAD),';',' '), '\"',''),'''','')",
	CLC_CODIGO_POSTAL				POSITION(1438:1442)		CHAR NULLIF(CLC_CODIGO_POSTAL=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_CODIGO_POSTAL),';',' '), '\"',''),'''','')",
	CLC_COD_UNIDADPOBLACIONAL		POSITION(1443:1462)		CHAR NULLIF(CLC_COD_UNIDADPOBLACIONAL=BLANKS) 			"REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_UNIDADPOBLACIONAL),';',' '), '\"',''),'''','')",
	CLC_COD_PROVINCIA				POSITION(1463:1482)		CHAR NULLIF(CLC_COD_PROVINCIA=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_COD_PROVINCIA),';',' '), '\"',''),'''','')",
	CLC_OBSERVACIONES				POSITION(1483:1738)		CHAR NULLIF(CLC_OBSERVACIONES=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:CLC_OBSERVACIONES),';',' '), '\"',''),'''','')"
)
