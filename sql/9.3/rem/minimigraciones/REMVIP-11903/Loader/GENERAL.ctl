OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_11903
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	   NUM_GASTO			NULLIF(NUM_GASTO=BLANKS)				"TRIM(:NUM_GASTO)"
	
)

