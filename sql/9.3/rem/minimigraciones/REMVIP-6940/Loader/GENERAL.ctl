OPTIONS (DIRECT=TRUE, BINDSIZE=1024000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_6940
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	OFR_NUM_OFERTA				NULLIF(OFR_NUM_OFERTA=BLANKS)			"TRIM(:OFR_NUM_OFERTA)",
	TAP_CODIGO					NULLIF(TAP_CODIGO=BLANKS)				"TRIM(:TAP_CODIGO)"
)
