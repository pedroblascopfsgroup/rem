OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999, SKIP=1)
LOAD DATA
CHARACTERSET WE8ISO8859P15
INFILE './CTL/IN/cierre_oficinas_bankia.csv'
BADFILE './CTL/BAD/cierre_oficinas_bankia.bad'
DISCARDFILE './CTL/REJECTS/cierre_oficinas_bankia.bad'
INTO TABLE REM01.APR_AUX_CIE_OFI_BNK_MUL
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	CIEOFI_ID "TO_NUMBER(:CIEOFI_ID)",
	OFI_SALIENTE "TRIM(:OFI_SALIENTE)",
	OFI_ENTRANTE "TRIM(:OFI_ENTRANTE)"
)
