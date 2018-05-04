OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/GASTOS_IMPUGNACIONES.dat'
BADFILE './CTLs_DATs/bad/GASTOS_IMPUGNACIONES.bad'
DISCARDFILE './CTLs_DATs/rejects/GASTOS_IMPUGNACIONES.bad'
INTO TABLE REM01.MIG2_GIM_GASTOS_IMPUGNACION
TRUNCATE
TRAILING NULLCOLS
(
	GIM_COD_GASTO_PROVEEDOR					POSITION(1:17)		INTEGER EXTERNAL NULLIF(GIM_COD_GASTO_PROVEEDOR=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GIM_COD_GASTO_PROVEEDOR),';',' '), '\"',''),'''',''),2,16))",
	GIM_FECHA_TOPE_IMPUGNACION				POSITION(18:25)		DATE 'YYYYMMDD' NULLIF(GIM_FECHA_TOPE_IMPUGNACION=BLANKS)			"REPLACE(:GIM_FECHA_TOPE_IMPUGNACION, '00000000', '')",
	GIM_FECHA_PRESEN_IMPUG					POSITION(26:33)		DATE 'YYYYMMDD' NULLIF(GIM_FECHA_PRESEN_IMPUG=BLANKS)				"REPLACE(:GIM_FECHA_PRESEN_IMPUG, '00000000', '')",
	GIM_FECHA_RESOLUCION					POSITION(34:41)		DATE 'YYYYMMDD' NULLIF(GIM_FECHA_RESOLUCION=BLANKS)					"REPLACE(:GIM_FECHA_RESOLUCION, '00000000', '')",
	GIM_COD_RESULTADO_IMPUGNACION			POSITION(42:61)		CHAR NULLIF(GIM_COD_RESULTADO_IMPUGNACION=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:GIM_COD_RESULTADO_IMPUGNACION),';',' '), '\"',''),'''','')",
	GIM_OBSERVACIONES						POSITION(62:573)	CHAR NULLIF(GIM_OBSERVACIONES=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:GIM_OBSERVACIONES),';',' '), '\"',''),'''','')",
	GIM_GPV_ID								POSITION(574:590)	INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GIM_GPV_ID),';',' '), '\"',''),'''',''),2,16))",
VALIDACION CONSTANT "0")
