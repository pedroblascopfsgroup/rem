#!/bin/bash
#
# Ejecución de scripts de los esquemas de operacional con los usuarios propietarios: master y entidad.
#

if [ "$#" -lt 2 ]; then
    echo "Es necesario indicar las contraseñas de cada uno de los usuarios seguidas de @host:port/sid, es decir:"
    echo "Parametros: master_pass@host:port/sid  entity01_pass@host:port/sid"
    exit
fi

function run_scripts {
	export NLS_LANG=.AL32UTF8
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01.sql
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql" "REM01" "JOSEVI JIMENEZ" "online"  "9.2" "20160928" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS-REM01-reg3.1.sql > DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	echo " -- : DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.sql" "REM01" "DANIEL GUTIÉRREZ" "online"  "9.2" "20160628" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD-REM01-reg3.1.sql > DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	echo " -- : DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.sql" "REM01" "Luis Caballero" "online"  "9.1" "20160921" "0" "NO" > /dev/null
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR-REM01-reg3.1.sql > DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
	echo " -- : DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.sql"
	exit | sqlplus -s -l REM01/$2 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
}

run_scripts "$@" | tee output.log
