OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999, SKIP=1)
LOAD DATA
CHARACTERSET WE8ISO8859P15
INFILE './CTL/IN/datos.csv'
BADFILE './CTL/BAD/datos.bad'
DISCARDFILE './CTL/REJECTS/datos.bad'
INTO TABLE REM01.TMP_ACT_PLS_PLUSVALIA_REMVIP_6525
TRUNCATE
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
	
	ACT_NUM_ACTIVO				"TRIM(:ACT_NUM_ACTIVO)",
	FECHA_RECEPCION_PLUSVALIA		"TRIM(:FECHA_RECEPCION_PLUSVALIA)",
	FECHA_PRESENTACION_PLUSVALIA		"TRIM(:FECHA_PRESENTACION_PLUSVALIA)",
	FECHA_PRESENTACION_RECURSO		"TRIM(:FECHA_PRESENTACION_RECURSO)",
	FECHA_RESPUESTA_RECURSO			"TRIM(:FECHA_RESPUESTA_RECURSO)",
	APERTURA_SEGUIMIENTO_EXP		"TRIM(:APERTURA_SEGUIMIENTO_EXP)",
	IMPORTE_PAGADO_PLUSVALIA		"TRIM(:IMPORTE_PAGADO_PLUSVALIA)",
	GASTO_ASOCIADO				"TRIM(:GASTO_ASOCIADO)",
	MINUSVALIA				"TRIM(:MINUSVALIA)",
	EXENTO					"TRIM(:EXENTO)",
	AUTOLIQUIDACION				"TRIM(:AUTOLIQUIDACION)"
	
)
