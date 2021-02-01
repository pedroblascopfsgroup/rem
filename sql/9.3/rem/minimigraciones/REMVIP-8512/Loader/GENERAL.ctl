OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_8512
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	SOCIEDAD		NULLIF(SOCIEDAD=BLANKS)		"TRIM(:SOCIEDAD)",
	NUM_GASTO_REM		NULLIF(NUM_GASTO_REM=BLANKS)		"TRIM(:NUM_GASTO_REM)",
	NUM_AGRUP_REM		NULLIF(NUM_AGRUP_REM=BLANKS)		"TRIM(:NUM_AGRUP_REM)",
	CIF			NULLIF(CIF=BLANKS)			"TRIM(:CIF)",
	PROVEEDOR		NULLIF(PROVEEDOR=BLANKS)		"TRIM(:PROVEEDOR)",
	NUM_FACTURA		NULLIF(NUM_FACTURA=BLANKS)		"TRIM(:NUM_FACTURA)",
	FECHA_CONTABILIZADO	NULLIF(FECHA_CONTABILIZADO=BLANKS)	"TRIM(:FECHA_CONTABILIZADO)",
	FECHA_PAGADO		NULLIF(FECHA_PAGADO=BLANKS)		"TRIM(:FECHA_PAGADO)"
)
