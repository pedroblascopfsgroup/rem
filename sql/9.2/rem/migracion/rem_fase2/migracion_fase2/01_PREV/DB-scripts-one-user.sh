#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Este script sólo se debe utilizar para ejecutar los scripts con un único usuario que tiene acceso a todos los demás."
    echo "Parametro: usuario/pass@host:port/sid"
    exit
fi

function run_scripts {
	export NLS_LANG=.AL32UTF8
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01.sql
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql" "REM01" "JOSEVI JIMENEZ" "online"  "9.2" "20160928" "0" "NO"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l $1 @./scripts/DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS-REM01-reg3.1.sql > DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	echo " -- : DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.sql"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_009_REM01_VI_BUSQUEDA_ACTIVOS_PRECIOS.log
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.sql" "REM01" "DANIEL GUTIÉRREZ" "online"  "9.2" "20160628" "0" "NO"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	exit | sqlplus -s -l $1 @./scripts/DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD-REM01-reg3.1.sql > DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	echo " -- : DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.sql"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_010_REM01_VI_CONDICIONANTES_DISPONIBILIDAD.log
	exit | sqlplus -s -l $1 @./scripts/DDL_000_ENTITY01_reg3.sql "DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.sql" "REM01" "Luis Caballero" "online"  "9.1" "20160921" "0" "NO"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_PREV_objects_REM01_DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
	exit | sqlplus -s -l $1 @./scripts/DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR-REM01-reg3.1.sql > DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
	echo " -- : DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.sql"
	exit | sqlplus -s -l $1 @./scripts/DDL_000_REM01_metadata_objects.sql > DB_SNAPSHOT_POST_objects_REM01_DDL_023_REM01_VI_BUSQUEDA_GASTOS_PROVEEDOR.log
}

run_scripts "$@" | tee output.log
