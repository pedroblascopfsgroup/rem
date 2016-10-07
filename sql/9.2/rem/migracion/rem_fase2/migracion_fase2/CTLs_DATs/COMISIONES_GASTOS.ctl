OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/COMISIONES_GASTOS.dat'
BADFILE './CTLs_DATs/bad/COMISIONES_GASTOS.bad'
DISCARDFILE './CTLs_DATs/rejects/COMISIONES_GASTOS.bad'
INTO TABLE REM01.MIG2_GEX_GASTOS_EXPEDIENTE
TRUNCATE
TRAILING NULLCOLS
(	
	GEX_COD_OFERTA				POSITION(1:17)			INTEGER EXTERNAL											"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GEX_COD_OFERTA),';',' '), '\"',''),'''',''),2,16))",
	GEX_COD_CONCEPTO_GASTO		POSITION(18:37)			CHAR NULLIF(GEX_COD_CONCEPTO_GASTO=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:GEX_COD_CONCEPTO_GASTO),';',' '), '\"',''),'''','')",
	GEX_CODIGO					POSITION(38:87)			CHAR NULLIF(GEX_CODIGO=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:GEX_CODIGO),';',' '), '\"',''),'''','')",
	GEX_NOMBRE					POSITION(88:137)		CHAR NULLIF(GEX_NOMBRE=BLANKS)								"REPLACE(REPLACE(REPLACE(TRIM(:GEX_NOMBRE),';',' '), '\"',''),'''','')",
	GEX_COD_TIPO_CALCULO		POSITION(138:157)		CHAR NULLIF(GEX_COD_TIPO_CALCULO=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:GEX_COD_TIPO_CALCULO),';',' '), '\"',''),'''','')",
	GEX_IMPORTE_CALCULO			POSITION(158:174)		INTEGER EXTERNAL NULLIF(GEX_IMPORTE_CALCULO=BLANKS) 		"CASE WHEN (:GEX_IMPORTE_CALCULO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:GEX_IMPORTE_CALCULO,1,15)||','||SUBSTR(:GEX_IMPORTE_CALCULO,16,2)),';',' '), '\"',''),'''','')) END",
	GEX_IMPORTE_FINAL			POSITION(175:191)		INTEGER EXTERNAL NULLIF(GEX_IMPORTE_FINAL=BLANKS) 			"CASE WHEN (:GEX_IMPORTE_FINAL) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:GEX_IMPORTE_FINAL,1,15)||','||SUBSTR(:GEX_IMPORTE_FINAL,16,2)),';',' '), '\"',''),'''','')) END",
	GEX_IND_PAGADOR				POSITION(192:193)		INTEGER EXTERNAL NULLIF(GEX_IND_PAGADOR=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GEX_IND_PAGADOR),';',' '), '\"',''),'''',''),2,1))",
	GEX_IND_APROBADO			POSITION(194:195)		INTEGER EXTERNAL NULLIF(GEX_IND_APROBADO=BLANKS)			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GEX_IND_APROBADO),';',' '), '\"',''),'''',''),2,1))",
	GEX_WEBCOM_ID				POSITION(196:212)		INTEGER EXTERNAL NULLIF(GEX_WEBCOM_ID=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GEX_WEBCOM_ID),';',' '), '\"',''),'''',''),2,16))",
	GEX_COD_PROVEEDOR			POSITION(213:262)		CHAR NULLIF(GEX_COD_PROVEEDOR=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:GEX_COD_PROVEEDOR),';',' '), '\"',''),'''','')",
	GEX_COD_DESTINATARIO		POSITION(263:282)		CHAR NULLIF(GEX_COD_DESTINATARIO=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:GEX_COD_DESTINATARIO),';',' '), '\"',''),'''','')"
)
