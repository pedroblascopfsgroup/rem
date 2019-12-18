OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_6016
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO			NULLIF(ACT_NUM_ACTIVO=BLANKS)			"TRIM(:ACT_NUM_ACTIVO)",
	TPA_ID				NULLIF(TPA_ID=BLANKS)				"TRIM(:TPA_ID)",
	SAC_ID				NULLIF(SAC_ID=BLANKS)				"TRIM(:SAC_ID)"
)
