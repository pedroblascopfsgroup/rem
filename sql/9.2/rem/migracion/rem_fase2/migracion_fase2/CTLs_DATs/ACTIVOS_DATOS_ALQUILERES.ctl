OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/ACTIVOS_DATOS_ALQUILERES.dat'
BADFILE './CTLs_DATs/bad/ACTIVOS_DATOS_ALQUILERES.bad'
DISCARDFILE './CTLs_DATs/rejects/ACTIVOS_DATOS_ALQUILERES.bad'
INTO TABLE REM01.MIG2_ACQ_ACTIVO_ALQUILER
TRUNCATE
TRAILING NULLCOLS
(	
	ACQ_NUMERO_ACTIVO					POSITION(1:17)			INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACQ_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	ACQ_NUMERO_CONTRATO_ALQUILER		POSITION(18:34)			INTEGER EXTERNAL NULLIF(ACQ_NUMERO_CONTRATO_ALQUILER=BLANKS)		"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACQ_NUMERO_CONTRATO_ALQUILER),';',' '), '\"',''),'''',''),2,16))",
	ACQ_COD_ESTADO_CNT_ALQUILER			POSITION(35:54)			CHAR NULLIF(ACQ_COD_ESTADO_CNT_ALQUILER=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:ACQ_COD_ESTADO_CNT_ALQUILER),';',' '), '\"',''),'''','')",
	ACQ_FECHA_INICIO_CONTRATO			POSITION(55:62)			DATE 'YYYYMMDD' NULLIF(ACQ_FECHA_INICIO_CONTRATO=BLANKS)			"REPLACE(:ACQ_FECHA_INICIO_CONTRATO, '00000000', '')",
	ACQ_FECHA_FIN_CONTRATO				POSITION(63:70)			DATE 'YYYYMMDD' NULLIF(ACQ_FECHA_FIN_CONTRATO=BLANKS)				"REPLACE(:ACQ_FECHA_FIN_CONTRATO, '00000000', '')",
	ACQ_FECHA_RESOLUCION_CONTRATO		POSITION(71:78)			DATE 'YYYYMMDD' NULLIF(ACQ_FECHA_RESOLUCION_CONTRATO=BLANKS)		"REPLACE(:ACQ_FECHA_RESOLUCION_CONTRATO, '00000000', '')",
	ACQ_IMPORTE_RENTA_CONTRATO			POSITION(79:95)			INTEGER EXTERNAL NULLIF(ACQ_IMPORTE_RENTA_CONTRATO=BLANKS)			"CASE WHEN (:ACQ_IMPORTE_RENTA_CONTRATO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACQ_IMPORTE_RENTA_CONTRATO,1,15)||','||SUBSTR(:ACQ_IMPORTE_RENTA_CONTRATO,16,2)),';',' '), '\"',''),'''','')) END",
	ACQ_PLAZO_OPCION_COMPRA				POSITION(96:103)		DATE 'YYYYMMDD' NULLIF(ACQ_PLAZO_OPCION_COMPRA=BLANKS)				"REPLACE(:ACQ_PLAZO_OPCION_COMPRA, '00000000', '')",
	ACQ_PRIMA_OPCION_COMPRA				POSITION(104:120)		INTEGER EXTERNAL NULLIF(ACQ_PRIMA_OPCION_COMPRA=BLANKS)				"CASE WHEN (:ACQ_PRIMA_OPCION_COMPRA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACQ_PRIMA_OPCION_COMPRA,1,15)||','||SUBSTR(:ACQ_PRIMA_OPCION_COMPRA,16,2)),';',' '), '\"',''),'''','')) END",
	ACQ_PRECIO_OPCION_COMPRA			POSITION(121:137)		INTEGER EXTERNAL NULLIF(ACQ_PRECIO_OPCION_COMPRA=BLANKS)			"CASE WHEN (:ACQ_PRECIO_OPCION_COMPRA) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACQ_PRECIO_OPCION_COMPRA,1,15)||','||SUBSTR(:ACQ_PRECIO_OPCION_COMPRA,16,2)),';',' '), '\"',''),'''','')) END",
	ACQ_CONDICIONES_OPCION_COMPRA		POSITION(138:393)		CHAR NULLIF(ACQ_CONDICIONES_OPCION_COMPRA=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:ACQ_CONDICIONES_OPCION_COMPRA),';',' '), '\"',''),'''','')",
	ACQ_IND_CONFLICTO_INTERESES			POSITION(394:395)		INTEGER EXTERNAL NULLIF(ACQ_IND_CONFLICTO_INTERESES=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACQ_IND_CONFLICTO_INTERESES),';',' '), '\"',''),'''',''),2,1))",
	ACQ_IND_RIESGO_REPUTACIONAL			POSITION(396:397)		INTEGER EXTERNAL NULLIF(ACQ_IND_RIESGO_REPUTACIONAL=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACQ_IND_RIESGO_REPUTACIONAL),';',' '), '\"',''),'''',''),2,1))",
	ACQ_GASTOS_IBI						POSITION(398:414)		INTEGER EXTERNAL NULLIF(ACQ_GASTOS_IBI=BLANKS)						"CASE WHEN (:ACQ_GASTOS_IBI) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACQ_GASTOS_IBI,1,15)||','||SUBSTR(:ACQ_GASTOS_IBI,16,2)),';',' '), '\"',''),'''','')) END",
	ACQ_COD_TIPO_PORCTA_IBI				POSITION(415:434)		CHAR NULLIF(ACQ_COD_TIPO_PORCTA_IBI=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:ACQ_COD_TIPO_PORCTA_IBI),';',' '), '\"',''),'''','')",
	ACQ_GASTOS_COMUNIDAD				POSITION(435:451)		INTEGER EXTERNAL NULLIF(ACQ_GASTOS_COMUNIDAD=BLANKS)				"CASE WHEN (:ACQ_GASTOS_COMUNIDAD) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACQ_GASTOS_COMUNIDAD,1,15)||','||SUBSTR(:ACQ_GASTOS_COMUNIDAD,16,2)),';',' '), '\"',''),'''','')) END",
	ACQ_COD_TIPO_PORCTA_COMUNIDAD		POSITION(452:471)		CHAR NULLIF(ACQ_COD_TIPO_PORCTA_COMUNIDAD=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:ACQ_COD_TIPO_PORCTA_COMUNIDAD),';',' '), '\"',''),'''','')",
	ACQ_COD_TIPO_PORCTA_SUMINIS			POSITION(472:491)		CHAR NULLIF(ACQ_COD_TIPO_PORCTA_SUMINIS=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:ACQ_COD_TIPO_PORCTA_SUMINIS),';',' '), '\"',''),'''','')"
)
