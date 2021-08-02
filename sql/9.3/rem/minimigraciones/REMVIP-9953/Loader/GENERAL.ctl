OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_9953
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	DataID				NULLIF(DataID=BLANKS)			"TRIM(:DataID)",
	tipo_expediente		NULLIF(tipo_expediente=BLANKS) 	"TRIM(:tipo_expediente)",
	clase_expediente		NULLIF(clase_expediente=BLANKS) 	"TRIM(:clase_expediente)",
	id_activo			NULLIF(id_activo=BLANKS) 		"TRIM(:id_activo)",
	id_externo			NULLIF(id_externo=BLANKS) 		"TRIM(:id_externo)",
	id_sistema_origen		NULLIF(id_sistema_origen=BLANKS) 	"TRIM(:id_sistema_origen)",
	cliente			NULLIF(cliente=BLANKS) 		"TRIM(:cliente)",
	Creado_por			NULLIF(Creado_por=BLANKS) 		"TRIM(:Creado_por)"
)

