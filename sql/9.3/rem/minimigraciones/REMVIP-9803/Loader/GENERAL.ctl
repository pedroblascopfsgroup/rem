OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_9803
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO				NULLIF(ACT_NUM_ACTIVO=BLANKS)			"TRIM(:ACT_NUM_ACTIVO)",
	FECHA_POSESION				NULLIF(FECHA_POSESION=BLANKS) 	"TRIM(:FECHA_POSESION)"
)

