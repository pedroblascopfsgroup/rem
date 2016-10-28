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

echo "[INFO] Se ha establecido la variable de entorno NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1"
echo "[INFO] Comienzo de la migración."

# Introduce aqui la linea de la tabla MIG2 que quieres cargar.
# Ejemplo:
#
# $ORACLE_HOME/bin/sqlldr REM01/$1  control=./CTLs_DATs/OFERTAS_OBSERVACIONES.ctl				log=./CTLs_DATs/logs/OFERTAS_OBSERVACIONES.log

echo "[INFO] Fin de la carga de ficheros en Tablas MIG2_. Revise directorio de logs y el directorio /bad."

exit
