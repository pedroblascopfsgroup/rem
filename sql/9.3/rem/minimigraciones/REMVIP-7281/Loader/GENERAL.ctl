OPTIONS (DIRECT=TRUE, BINDSIZE=1024000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_7281
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	TBJ_NUM_TRABAJO				NULLIF(TBJ_NUM_TRABAJO=BLANKS)				"TRIM(:TBJ_NUM_TRABAJO)",
	TBJ_IMPORTE_PENAL_DIARIO	NULLIF(TBJ_IMPORTE_PENAL_DIARIO=BLANKS)		"TRIM(:TBJ_IMPORTE_PENAL_DIARIO)",
	TBJ_IMPORTE_TOTAL			NULLIF(TBJ_IMPORTE_TOTAL=BLANKS)			"TRIM(:TBJ_IMPORTE_TOTAL)"
)
