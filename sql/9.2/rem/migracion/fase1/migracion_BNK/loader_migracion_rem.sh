#!/bin/bash

if [ "$#" -ne 1 ] ; then
    echo "Uso $0 <pass_REM01@IP:PORT/SID> "
    exit 1
fi

if [ "$ORACLE_HOME" == "" ] ; then
        export ORACLE_HOME=/opt/app/oracle11/product/11.2.0/dbhome_1    
        echo "Se ha establecido el valor de ORACLE_HOME=$ORACLE_HOME"
fi

if [ "$ORACLE_SID" == "" ] ; then
        ORACLE_SID=orcl11g; export ORACLE_SID        
        echo "Se ha establecido el valor de ORACLE_SID=$ORACLE_SID"
fi

export NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1

echo "Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1"
echo "Comienzo de la migración."

$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_CABECERA.ctl            log=./CTLs_DATs/logs/ACTIVO_CABECERA.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_TITULO.ctl              log=./CTLs_DATs/logs/ACTIVO_TITULO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_PLANDINVENTAS.ctl       log=./CTLs_DATs/logs/ACTIVO_PLANDINVENTAS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_ADJ_JUDICIAL.ctl        log=./CTLs_DATs/logs/ACTIVO_ADJ_JUDICIAL.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_ADJ_NO_JUDICIAL.ctl     log=./CTLs_DATs/logs/ACTIVO_ADJ_NO_JUDICIAL.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/COM_PROPIETARIOS_CABECERA.ctl  log=./CTLs_DATs/logs/COM_PROPIETARIOS_CABECERA.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_DATOSADICIONALES.ctl    log=./CTLs_DATs/logs/ACTIVO_DATOSADICIONALES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROPIETARIOS.ctl      		 log=./CTLs_DATs/logs/PROPIETARIOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROPIETARIOS_CABECERA.ctl      log=./CTLs_DATs/logs/PROPIETARIOS_CABECERA.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROPIETARIOS_ACTIVO.ctl        log=./CTLs_DATs/logs/PROPIETARIOS_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/CATASTRO_ACTIVO.ctl            log=./CTLs_DATs/logs/CATASTRO_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/CARGAS_ACTIVO.ctl            	 log=./CTLs_DATs/logs/CARGAS_ACTIVO.log
#[FASE II]#12#OCUPANTES_ACTIVO
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/LLAVES_ACTIVO.ctl          	 log=./CTLs_DATs/logs/LLAVES_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/MOVIMIENTOS_LLAVE.ctl      	 log=./CTLs_DATs/logs/MOVIMIENTOS_LLAVE.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/TASACIONES_ACTIVO.ctl       	 log=./CTLs_DATs/logs/TASACIONES_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/INFOCOMERCIAL_ACTIVO.ctl       log=./CTLs_DATs/logs/INFOCOMERCIAL_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/CALIDADES_ACTIVO.ctl      	 log=./CTLs_DATs/logs/CALIDADES_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/INFOCOMERCIAL_DISTRIBUCION.ctl log=./CTLs_DATs/logs/INFOCOMERCIAL_DISTRIBUCION.log
#[FASE II]#19#OBSERVACIONES_ACTIVO
#[FASE II]$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/IMAGENES_CABECERA.ctl          log=./CTLs_DATs/logs/IMAGENES_CABECERA.log
#[FASE II]$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/IMAGENES_ACTIVO.ctl            log=./CTLs_DATs/logs/IMAGENES_ACTIVO.log
#[FASE II]$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/DOCUMENTOS_ACTIVO.ctl          log=./CTLs_DATs/logs/DOCUMENTOS_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/AGRUPACIONES_ACTIVO.ctl        log=./CTLs_DATs/logs/AGRUPACIONES_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/AGRUPACIONES.ctl               log=./CTLs_DATs/logs/AGRUPACIONES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/OBSERVACIONES_AGRUPACION.ctl   log=./CTLs_DATs/logs/OBSERVACIONES_AGRUPACION.log
#[FASE II]#26#IMAGENES_AGRUPACION
#$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/SUBDIVISIONES_AGRUPACION.ctl   log=./CTLs_DATs/logs/SUBDIVISIONES_AGRUPACION.log
#[FASE II]#28#IMAGENES_SUBDIVISION
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROVEEDORES.ctl         		 log=./CTLs_DATs/logs/ACTIVO_PROVEEDORES.log
#[FASE II]$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/COM_PROPIETARIOS_CUOTA.ctl    log=./CTLs_DATs/logs/COM_PROPIETARIOS_CUOTA.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ENTIDAD_PROVEEDOR.ctl   		 log=./CTLs_DATs/logs/ENTIDAD_PROVEEDOR.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/TRABAJO.ctl                    log=./CTLs_DATs/logs/TRABAJO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PRESUPUESTO_TRABAJO.ctl        log=./CTLs_DATs/logs/PRESUPUESTO_TRABAJO.log
#[FASE II]#34#PROVISION_SUPLIDO
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROVEEDORES_DIRECCIONES.ctl	 log=./CTLs_DATs/logs/PROVEEDORES_DIRECCIONES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROVEEDOR_CONTACTO.ctl         log=./CTLs_DATs/logs/PROVEEDOR_CONTACTO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_PRECIO.ctl              log=./CTLs_DATs/logs/ACTIVO_PRECIO.log
$ORACLE_HOME/bin/sqlplus REM01/$1 @aux/Mig_estadisticas.sql > ./CTLs_DATs/logs/$0.log
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @aux/Mig_estadisticas.sql >> ./CTLs_DATs/logs/$0.log ; exit 1 ; fi



echo "Fin de la carga de ficheros en Tablas MIG_. Revise directorio de logs y el directorio /bad."
exit
