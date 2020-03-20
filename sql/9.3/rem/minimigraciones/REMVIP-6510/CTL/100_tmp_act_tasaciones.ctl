OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999, SKIP=1)
LOAD DATA
CHARACTERSET WE8ISO8859P15
INFILE './CTL/IN/Tasaciones OK carga punto de partida Rem.csv'
BADFILE './CTL/BAD/Tasaciones OK carga punto de partida Rem.bad'
DISCARDFILE './CTL/REJECTS/Tasaciones OK carga punto de partida Rem.bad'
INTO TABLE REM01.TMP_ACT_TASACIONES_REMVIP_6510
TRUNCATE
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO		"TRIM(:ACT_NUM_ACTIVO)",
	IMPORTE_TAS_VIGENTE	"TRIM(:IMPORTE_TAS_VIGENTE)",
	FECHA_TAS_VIGENTE	"TRIM(:FECHA_TAS_VIGENTE)"
)
