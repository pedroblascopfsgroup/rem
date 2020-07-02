OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_7676_FASE_1
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	NUM_ACTIVO		NULLIF(NUM_ACTIVO=BLANKS)	"TRIM(:NUM_ACTIVO)",
	USUARIO			NULLIF(USUARIO=BLANKS)		"TRIM(:USUARIO)",
	NOMBRE_GESTORIA		NULLIF(NOMBRE_GESTORIA=BLANKS)	"TRIM(:NOMBRE_GESTORIA)"
)

