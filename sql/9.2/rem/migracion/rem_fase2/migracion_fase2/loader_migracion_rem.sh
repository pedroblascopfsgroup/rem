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

$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/CLIENTES_COMERCIALES.ctl				log=./CTLs_DATs/logs/CLIENTES_COMERCIALES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/VISITAS.ctl							log=./CTLs_DATs/logs/VISITAS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/OFERTAS.ctl							log=./CTLs_DATs/logs/OFERTAS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/OFERTAS_ACTIVO.ctl					log=./CTLs_DATs/logs/OFERTAS_ACTIVO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/CONDICIONANTE_OFERTA_ACEPTADA.ctl 	log=./CTLs_DATs/logs/CONDICIONANTE_OFERTA_ACEPTADA.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/RESERVAS.ctl							log=./CTLs_DATs/logs/RESERVAS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ENTREGAS_RESERVAS.ctl					log=./CTLs_DATs/logs/ENTREGAS_RESERVAS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/TITULARES_ADICIONALES_OFERTA.ctl		log=./CTLs_DATs/logs/TITULARES_ADICIONALES_OFERTA.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/COMPRADORES.ctl						log=./CTLs_DATs/logs/COMPRADORES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/COMPRADOR_EXPEDIENTE.ctl				log=./CTLs_DATs/logs/COMPRADOR_EXPEDIENTE.log
#COMITE_OFERTA_ACEPTADA
#COMITES
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/COMPARECIENTES_VENDEDOR.ctl			log=./CTLs_DATs/logs/COMPARECIENTES_VENDEDOR.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/COMISIONES_GASTOS.ctl					log=./CTLs_DATs/logs/COMISIONES_GASTOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/OFERTAS_OBSERVACIONES.ctl				log=./CTLs_DATs/logs/OFERTAS_OBSERVACIONES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/FORMALIZACIONES.ctl					log=./CTLs_DATs/logs/FORMALIZACIONES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/POSICIONAMIENTOS.ctl					log=./CTLs_DATs/logs/POSICIONAMIENTOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/SUBSANACIONES.ctl						log=./CTLs_DATs/logs/SUBSANACIONES.log
#Información comercial
#Histórico estados informes comerciales
#Datos de publicación 
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/HIST_ESTADOS_PUBLICACIONES.ctl 		log=./CTLs_DATs/logs/HIST_ESTADOS_PUBLICACIONES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/COND_ESPEC_ACTIVOS_PUBLICADOS.ctl		log=./CTLs_DATs/logs/COND_ESPEC_ACTIVOS_PUBLICADOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_PRECIOS.ctl					log=./CTLs_DATs/logs/ACTIVO_PRECIOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/HIST_ACTIVOS_PRECIOS.ctl				log=./CTLs_DATs/logs/HIST_ACTIVOS_PRECIOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROPUESTAS_PRECIOS.ctl				log=./CTLs_DATs/logs/PROPUESTAS_PRECIOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVO_PROPUESTAS.ctl					log=./CTLs_DATs/logs/ACTIVO_PROPUESTAS.log
#Campañas -activo
#Campañas
#Fotos
#Clientes
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROVEEDORES.ctl						log=./CTLs_DATs/logs/PROVEEDORES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROVEEDORES_DIRECCIONES.ctl			log=./CTLs_DATs/logs/PROVEEDORES_DIRECCIONES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PROVEEDOR_CONTACTO.ctl				log=./CTLs_DATs/logs/PROVEEDOR_CONTACTO.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/GASTOS_PROVEEDORES.ctl				log=./CTLs_DATs/logs/GASTOS_PROVEEDORES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/GASTOS_PROVEEDORES_ACTIVOS.ctl		log=./CTLs_DATs/logs/GASTOS_PROVEEDORES_ACTIVOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/GASTOS_PROVEEDORES _TRABAJOS.ctl		log=./CTLs_DATs/logs/GASTOS_PROVEEDORES _TRABAJOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/DETALLE_ECONOMICO_GASTOS.ctl			log=./CTLs_DATs/logs/DETALLE_ECONOMICO_GASTOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/GESTION_GASTOS.ctl					log=./CTLs_DATs/logs/GESTION_GASTOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/GASTOS_IMPUGNACIONES.ctl				log=./CTLs_DATs/logs/GASTOS_IMPUGNACIONES.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/GASTOS_INFORMACION_CONTABILIDAD.ctl	log=./CTLs_DATs/logs/GASTOS_INFORMACION_CONTABILIDAD.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/ACTIVOS.ctl							log=./CTLs_DATs/logs/ACTIVOS.log
$ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/PERIMETRO_ACTIVOS.ctl					log=./CTLs_DATs/logs/PERIMETRO_ACTIVOS.log

#$ORACLE_HOME/bin/sqlplus REM01/$1 @aux/Mig_estadisticas.sql > ./CTLs_DATs/logs/$0.log
#if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @aux/Mig_estadisticas.sql >> ./CTLs_DATs/logs/$0.log ; exit 1 ; fi


echo "Fin de la carga de ficheros en Tablas MIG_. Revise directorio de logs y el directorio /bad."
exit
