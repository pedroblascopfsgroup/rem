OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_12169_OFR
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	   OFR_ID			NULLIF(OFR_ID=BLANKS)						"TRIM(:OFR_ID)"	
	  ,EOF_ID			NULLIF(EOF_ID=BLANKS)						"TRIM(:EOF_ID)"
	
)

