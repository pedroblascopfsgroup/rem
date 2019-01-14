OPTIONS ( BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
INTO TABLE REM01.TMP_ASIGNACION_GESTORES_ACTIVO
TRUNCATE 
FIELDS TERMINATED BY ";"
OPTIONALLY ENCLOSED BY "'"
TRAILING NULLCOLS
(
	cartera "TRIM(:cartera)", 
	subcartera "TRIM(:subcartera)",
	perfil_gestor "TRIM(:perfil_gestor)", 
	tipo_gestor "TRIM(:tipo_gestor)", 
	singular_retail "TRIM(:singular_retail)", 
	codGestor "TRIM(:codGestor)", 
	gestor "TRIM(:gestor)", 
	codSupervisor "TRIM(:codSupervisor)", 
	supervisor "TRIM(:supervisor)",
	codigoComAutonoma "TRIM(:codigoComAutonoma)",
	comunidadAutonoma "TRIM(:comunidadAutonoma)", 
	codProvincia "TRIM(:codProvincia)", 
	codMunicipio "TRIM(:codMunicipio)", 
	municipio "TRIM(:municipio)", 
	cp "TRIM(:cp)"
)


