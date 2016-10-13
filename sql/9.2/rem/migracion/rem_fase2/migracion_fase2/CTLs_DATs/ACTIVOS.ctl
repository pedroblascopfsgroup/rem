OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/ACTIVOS.dat'
BADFILE './CTLs_DATs/bad/ACTIVOS.bad'
DISCARDFILE './CTLs_DATs/rejects/ACTIVOS.bad'
INTO TABLE REM01.MIG2_ACT_ACTIVO
TRUNCATE
TRAILING NULLCOLS
(
	ACT_NUMERO_ACTIVO					POSITION(1:17)			INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	ACT_COD_CARTERA						POSITION(18:37)			CHAR																"REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_CARTERA),';',' '), '\"',''),'''','')",
	ACT_COD_SUBCARTERA					POSITION(38:57)			CHAR																"REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_SUBCARTERA),';',' '), '\"',''),'''','')",
	ACT_COD_SUBCARTERA_ANTERIOR			POSITION(58:77)			CHAR NULLIF(ACT_COD_SUBCARTERA_ANTERIOR=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_SUBCARTERA_ANTERIOR),';',' '), '\"',''),'''','')",
	ACT_COD_TIPO_COMERCIALIZACION		POSITION(78:97)			CHAR NULLIF(ACT_COD_TIPO_COMERCIALIZACION=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_TIPO_COMERCIALIZACION),';',' '), '\"',''),'''','')",
	ACT_COD_TIPO_ALQUILER				POSITION(98:117)		CHAR NULLIF(ACT_COD_TIPO_ALQUILER=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_TIPO_ALQUILER),';',' '), '\"',''),'''','')",
	ACT_FECHA_VENTA						POSITION(118:125)		DATE 'YYYYMMDD' NULLIF(ACT_FECHA_VENTA=BLANKS)						"REPLACE(:ACT_FECHA_VENTA, '00000000', '')",
	ACT_IMPORTE_VENTA					POSITION(126:142)		INTEGER EXTERNAL NULLIF(ACT_IMPORTE_VENTA=BLANKS)					"CASE WHEN (:ACT_IMPORTE_VENTA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACT_IMPORTE_VENTA,1,15)||','||SUBSTR(:ACT_IMPORTE_VENTA,16,2)),';',' '), '\"',''),'''','')) END",
	ACT_COD_PROPIETARIO_UVEM_ANT		POSITION(143:159)		INTEGER EXTERNAL NULLIF(ACT_COD_PROPIETARIO_UVEM_ANT=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_PROPIETARIO_UVEM_ANT),';',' '), '\"',''),'''',''),2,16))",
	ACT_BLOQUEO_PRECIO_FECHA_INI		POSITION(160:167)		DATE 'YYYYMMDD' NULLIF(ACT_BLOQUEO_PRECIO_FECHA_INI=BLANKS)			"REPLACE(:ACT_BLOQUEO_PRECIO_FECHA_INI, '00000000', '')",
	ACT_BLOQUEO_PRECIO_USU_ID			POSITION(168:217)		CHAR NULLIF(ACT_BLOQUEO_PRECIO_USU_ID=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:ACT_BLOQUEO_PRECIO_USU_ID),';',' '), '\"',''),'''','')",
	ACT_COD_TIPO_PUBLICACION			POSITION(218:237)		CHAR NULLIF(ACT_COD_TIPO_PUBLICACION=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_TIPO_PUBLICACION),';',' '), '\"',''),'''','')",
	ACT_COD_ESTADO_PUBLICACION			POSITION(238:257)		CHAR NULLIF(ACT_COD_ESTADO_PUBLICACION=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:ACT_COD_ESTADO_PUBLICACION),';',' '), '\"',''),'''','')",
	ACT_FECHA_IND_PRECIAR				POSITION(258:265)		DATE 'YYYYMMDD' NULLIF(ACT_FECHA_IND_PRECIAR=BLANKS)				"REPLACE(:ACT_FECHA_IND_PRECIAR, '00000000', '')",
	ACT_FECHA_IND_REPRECIAR				POSITION(266:273)		DATE 'YYYYMMDD' NULLIF(ACT_FECHA_IND_REPRECIAR=BLANKS)				"REPLACE(:ACT_FECHA_IND_REPRECIAR, '00000000', '')",
	ACT_FECHA_IND_DESCUENTO				POSITION(274:281)		DATE 'YYYYMMDD' NULLIF(ACT_FECHA_IND_DESCUENTO=BLANKS)				"REPLACE(:ACT_FECHA_IND_DESCUENTO, '00000000', '')"		
)
