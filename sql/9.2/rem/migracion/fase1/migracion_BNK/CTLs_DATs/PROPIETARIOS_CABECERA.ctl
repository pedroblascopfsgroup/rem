OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/PROPIETARIOS_CABECERA.dat'
BADFILE './CTLs_DATs/bad/PROPIETARIOS_CABECERA.bad'
DISCARDFILE './CTLs_DATs/rejects/PROPIETARIOS_CABECERA.bad'
INTO TABLE REM01.MIG_APC_PROP_CABECERA_BNK
TRUNCATE
TRAILING NULLCOLS
(
	PRO_CODIGO_UVEM					POSITION(1:17)		INTEGER EXTERNAL 										"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PRO_CODIGO_UVEM),';',' '), '\"',''),'''',''),2,16))",
	LOCALIDAD_PROPIETARIO			POSITION(18:37)		CHAR NULLIF(LOCALIDAD_PROPIETARIO=BLANKS) 				"REPLACE(REPLACE(REPLACE(TRIM(:LOCALIDAD_PROPIETARIO),';',' '), '\"',''),'''','')",
	PROVINCIA_PROPIETARIO			POSITION(38:57)		CHAR NULLIF(PROVINCIA_PROPIETARIO=BLANKS) 				"DECODE(TRIM(:PROVINCIA_PROPIETARIO),'0',NULL,REPLACE(REPLACE(REPLACE(TRIM(:PROVINCIA_PROPIETARIO	),';',' '), '\"',''),'''',''))",
	TIPO_PERSONA					POSITION(58:77)		CHAR NULLIF(TIPO_PERSONA=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:TIPO_PERSONA),';',' '), '\"',''),'''','')",
	PRO_NOMBRE						POSITION(78:177)	CHAR 							 						"REPLACE(REPLACE(REPLACE(TRIM(:PRO_NOMBRE),';',' '), '\"',''),'''','')",
	PRO_APELLIDO1					POSITION(178:277)	CHAR NULLIF(PRO_APELLIDO1=BLANKS)  						"REPLACE(REPLACE(REPLACE(TRIM(:PRO_APELLIDO1),';',' '), '\"',''),'''','')",
	PRO_APELLIDO2					POSITION(278:377)	CHAR NULLIF(PRO_APELLIDO2=BLANKS)  						"REPLACE(REPLACE(REPLACE(TRIM(:PRO_APELLIDO2),';',' '), '\"',''),'''','')",
	TIPO_DOCUMENTO					POSITION(378:397)	CHAR NULLIF(TIPO_DOCUMENTO=BLANKS) 						"REPLACE(REPLACE(REPLACE(TRIM(:TIPO_DOCUMENTO),';',' '), '\"',''),'''','')",
	PRO_NIF							POSITION(398:417)	CHAR NULLIF(PRO_NIF=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:PRO_NIF),';',' '), '\"',''),'''','')",
	PRO_DIR							POSITION(418:667)	CHAR NULLIF(PRO_DIR=BLANKS) 							"REPLACE(REPLACE(REPLACE(TRIM(:PRO_DIR),';',' '), '\"',''),'''','')",
	PRO_TELF						POSITION(668:687)	CHAR NULLIF(PRO_TELF=BLANKS) 							"REPLACE(REPLACE(REPLACE(TRIM(:PRO_TELF),';',' '), '\"',''),'''','')",
	PRO_EMAIL						POSITION(688:737)	CHAR NULLIF(PRO_EMAIL=BLANKS) 							"REPLACE(REPLACE(REPLACE(TRIM(:PRO_EMAIL),';',' '), '\"',''),'''','')",
	PRO_CP							POSITION(738:746)	INTEGER EXTERNAL NULLIF(PRO_CP=BLANKS) 					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PRO_CP),';',' '),'\"',''),'''',''),2,8))",
	LOCALIDAD_CONTACTO				POSITION(747:766)	CHAR NULLIF(LOCALIDAD_CONTACTO=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:LOCALIDAD_CONTACTO),';',' '), '\"',''),'''','')",
	PROVINCIA_CONTACTO				POSITION(767:786)	CHAR NULLIF(PROVINCIA_CONTACTO=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:PROVINCIA_CONTACTO),';',' '), '\"',''),'''','')",
	PRO_CONTACTO_NOM				POSITION(787:886)	CHAR NULLIF(PRO_CONTACTO_NOM=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:PRO_CONTACTO_NOM),';',' '), '\"',''),'''','')",
	PRO_CONTACTO_TELF1				POSITION(887:906)	CHAR NULLIF(PRO_CONTACTO_TELF1=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:PRO_CONTACTO_TELF1),';',' '), '\"',''),'''','')",
	PRO_CONTACTO_TELF2				POSITION(907:926)	CHAR NULLIF(PRO_CONTACTO_TELF2=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:PRO_CONTACTO_TELF2),';',' '), '\"',''),'''','')",
	PRO_CONTACTO_EMAIL				POSITION(927:976)	CHAR NULLIF(PRO_CONTACTO_EMAIL=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:PRO_CONTACTO_EMAIL),';',' '), '\"',''),'''','')",
	PRO_CONTACTO_DIR				POSITION(977:1226)	CHAR NULLIF(PRO_CONTACTO_DIR=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:PRO_CONTACTO_DIR),';',' '), '\"',''),'''','')",
	PRO_CONTACTO_CP					POSITION(1227:1235)	INTEGER EXTERNAL NULLIF(PRO_CONTACTO_CP=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PRO_CONTACTO_CP),';',' '),'\"',''),'''',''),2,8))",
	PRO_OBSERVACIONES				POSITION(1236:2235)	CHAR NULLIF(PRO_OBSERVACIONES=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:PRO_OBSERVACIONES),';',' '), '\"',''),'''','')",
	PRO_PAGA_EJECUTANTE				POSITION(2236:2237)	INTEGER EXTERNAL NULLIF(PRO_PAGA_EJECUTANTE=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PRO_PAGA_EJECUTANTE),';',' '),'\"',''),'''',''),2,1))",
	PRO_COD_CARTERA					POSITION(2238:2257)	CHAR NULLIF(PRO_COD_CARTERA=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:PRO_COD_CARTERA),';',' '), '\"',''),'''','')"
)
