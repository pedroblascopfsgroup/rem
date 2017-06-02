OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/PRESUPUESTO_TRABAJO.dat'
BADFILE './CTLs_DATs/bad/PRESUPUESTO_TRABAJO.bad'
DISCARDFILE './CTLs_DATs/rejects/PRESUPUESTO_TRABAJO.bad'
INTO TABLE REM01.MIG_APT_PRESUPUESTO_TRABAJ
TRUNCATE
TRAILING NULLCOLS
(	
	PVE_DOCIDENTIF						POSITION(1:20)					CHAR 							 									"REPLACE(REPLACE(REPLACE(TRIM(:PVE_DOCIDENTIF),';',' '), '\"',''),'''','')",
	TBJ_NUM_TRABAJO						POSITION(21:37)					INTEGER EXTERNAL NULLIF(TBJ_NUM_TRABAJO=BLANKS) 					"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:TBJ_NUM_TRABAJO),';',' '), '\"',''),'''',''),2,16))",
	PRT_IMPORTE							POSITION(38:54)					INTEGER EXTERNAL NULLIF(PRT_IMPORTE=BLANKS) 						"CASE WHEN (:PRT_IMPORTE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:PRT_IMPORTE,1,15)||','||SUBSTR(:PRT_IMPORTE,16,2)),';',' '), '\"',''),'''','')) END",
	PRT_FECHA							POSITION(55:62)					DATE 'YYYYMMDD' NULLIF(PRT_FECHA=BLANKS) 							"REPLACE(:PRT_FECHA, '00000000', '')",
	ESTADO_PRESUPUESTO					POSITION(63:82)					CHAR NULLIF(ESTADO_PRESUPUESTO=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:ESTADO_PRESUPUESTO),';',' '), '\"',''),'''','')",
	PRT_REPARTIR_PROPORCIONAL			POSITION(83:84)					INTEGER EXTERNAL NULLIF(PRT_REPARTIR_PROPORCIONAL=BLANKS) 			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:PRT_REPARTIR_PROPORCIONAL),';',' '), '\"',''),'''',''),2,1))",
	PRT_COMENTARIOS						POSITION(85:596)				CHAR NULLIF(PRT_COMENTARIOS=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:PRT_COMENTARIOS),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0")
