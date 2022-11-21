OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_HREOS_18888
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	AUX_CVA_CUENTA_VIRTUAL				NULLIF(AUX_CVA_CUENTA_VIRTUAL=BLANKS)		"TRIM(:AUX_CVA_CUENTA_VIRTUAL)",	
	AUX_DD_SCR_CODIGO				NULLIF(AUX_DD_SCR_CODIGO=BLANKS)		"TRIM(:AUX_DD_SCR_CODIGO)"
)
