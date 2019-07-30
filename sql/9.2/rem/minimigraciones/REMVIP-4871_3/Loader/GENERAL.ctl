OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_4871_3
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO				NULLIF(ACT_NUM_ACTIVO=BLANKS)				"TRIM(:ACT_NUM_ACTIVO)",
	BIE_DREG_TOMO				NULLIF(BIE_DREG_TOMO=BLANKS)				"TRIM(:BIE_DREG_TOMO)",
	BIE_DREG_LIBRO				NULLIF(BIE_DREG_LIBRO=BLANKS)				"TRIM(:BIE_DREG_LIBRO)",
	BIE_DREG_FOLIO				NULLIF(BIE_DREG_FOLIO=BLANKS)				"TRIM(:BIE_DREG_FOLIO)"

)
