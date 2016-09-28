OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/GASTOS_PROVEEDORES_TRABAJOS.dat'
BADFILE './CTLs_DATs/bad/GASTOS_PROVEEDORES_TRABAJOS.bad'
DISCARDFILE './CTLs_DATs/rejects/GASTOS_PROVEEDORES_TRABAJOS.bad'
INTO TABLE REM01.MIG2_GPT_GASTOS_PROVEE_TRABAJO
TRUNCATE
TRAILING NULLCOLS
(
	GPT_COD_GASTO_PROVEEDOR			POSITION(1:17)			INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GPT_COD_GASTO_PROVEEDOR),';',' '), '\"',''),'''',''),2,16))",
	GPT_TBJ_NUM_TRABAJO				POSITION(91:110)		INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:GPT_TBJ_NUM_TRABAJO),';',' '), '\"',''),'''',''),2,16))",
	GPT_FECHA_EMISION_FACTURA		POSITION(1:17)			DATE 'YYYYMMDD' NULLIF(GPT_FECHA_EMISION_FACTURA=BLANKS)			"REPLACE(:GPT_FECHA_EMISION_FACTURA, '00000000', '')"
)
