#!/bin/bash
if [ "$ORACLE_HOME" == "" ] ; then
    echo "Debe ejecutar este shell desde un usuario que tenga permisos de ejecución de Oracle. Este usuario tiene ORACLE_HOME vacío"
    exit
fi

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 password_esquema_principal@sid"
    exit
fi
export NLS_LANG=.AL32UTF8

export nombreFichero=`basename $0`
export nombreSinExt=${nombreFichero%%.*}

export nombreSetEnv=setEnv_${nombreSinExt}.sh
source $nombreSetEnv

export nombreLog=${nombreSinExt}.log

echo "###############################################################"  > $nombreLog
echo 'NOMBRE_SCRIPT='$NOMBRE_SCRIPT   >> $nombreLog
echo 'ESQUEMA_EJECUCION='$ESQUEMA_EJECUCION  >> $nombreLog
echo 'VARIABLES_SUSTITUCION='$VARIABLES_SUSTITUCION  >> $nombreLog
echo 'AUTOR='$AUTOR  >> $nombreLog
echo 'ARTEFACTO='$ARTEFACTO  >> $nombreLog
echo 'VERSION_ARTEFACTO='$VERSION_ARTEFACTO  >> $nombreLog
echo 'FECHA_CREACION='$FECHA_CREACION  >> $nombreLog
echo 'INCIDENCIA_LINK='$INCIDENCIA_LINK  >> $nombreLog
echo 'PRODUCTO='$PRODUCTO  >> $nombreLog
echo "###############################################################"  >> $nombreLog
echo ""  >> $nombreLog

CADENAS_SUSTITUCION=""
IFS=',' read -a array <<< "$VARIABLES_SUSTITUCION"
for index in "${!array[@]}"
do
#    echo "$index ${array[index]}"
    IFS=';' read -a array2 <<< "${array[index]}"
    for index2 in "${!array2[@]}"
    do
       if [ "$index2" -eq "0" ] ; then
          CADENA="-e s/""${array2[index2]}""/"
       fi
       if [ "$index2" -eq "1" ] ; then
          CADENA="$CADENA""${array2[index2]}/g "
       fi
#      echo "--- $index2 ${array2[index2]}"
    done
    CADENAS_SUSTITUCION="$CADENAS_SUSTITUCION""$CADENA "
done
#echo "$CADENAS_SUSTITUCION"

#Invocar Creación de tabla de registro de SQLs
export DDL_RSR=DDL_001_ESQUEMA_CreateRegistroSQLs.sql
sed $CADENAS_SUSTITUCION "${DDL_RSR}" > ${FECHA_CREACION}-${DDL_RSR}
echo "###############################################################"  >> $nombreLog
echo "#####    INICIO Invocar Creación de tabla de registro de SQLs"  >> $nombreLog
echo "###############################################################"  >> $nombreLog
$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$1 @${FECHA_CREACION}-${DDL_RSR}  >> $nombreLog
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @${FECHA_CREACION}-${DDL_RSR} >> $nombreLog ; exit 1 ; fi
echo "###############################################################"  >> $nombreLog

#Invocar Comprobacion de ejecución previa
export DML_COMPROBACION_PREVIA=DML_001_ESQUEMA_ComprobacionEjecucionPrevia.sql
sed $CADENAS_SUSTITUCION "${DML_COMPROBACION_PREVIA}" > ${FECHA_CREACION}-${DML_COMPROBACION_PREVIA}
echo "###############################################################"  >> $nombreLog
echo "#####    INICIO Invocar Comprobacion de ejecución previa"  >> $nombreLog
echo "###############################################################"  >> $nombreLog
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$1 @${FECHA_CREACION}-${DML_COMPROBACION_PREVIA} $NOMBRE_SCRIPT $FECHA_CREACION > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then echo -e "\n\n======>>> "Script ${FECHA_CREACION}-${NOMBRE_SCRIPT} ya ejecutado >> $nombreLog ; exit 0 ; fi
if [ $RESULTADO != 0 ] ; then echo -e "\n\n======>>> "Error en @${FECHA_CREACION}-${DML_COMPROBACION_PREVIA} >> $nombreLog ; exit 1 ; fi
echo "##### SCRIPT ${NOMBRE_SCRIPT} ${FECHA_CREACION} NO EJECUTADO PREVIAMENTE"  >> $nombreLog
echo "###############################################################"  >> $nombreLog

#Inserción inicial de datos en tabla de registro
export DML_INSERCION_INICIAL=DML_002_ESQUEMA_InsercionInicial.sql
sed $CADENAS_SUSTITUCION "${DML_INSERCION_INICIAL}" > ${FECHA_CREACION}-${DML_INSERCION_INICIAL}
echo "###############################################################"  >> $nombreLog
echo "#####    Inserción inicial de datos en tabla de registro"  >> $nombreLog
echo "###############################################################"  >> $nombreLog
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$1 @${FECHA_CREACION}-${DML_INSERCION_INICIAL} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO" >> $nombreLog

#Ejecución del script en sí mismo
sed $CADENAS_SUSTITUCION "${NOMBRE_SCRIPT}" > ${FECHA_CREACION}-${NOMBRE_SCRIPT}
echo "###############################################################"  >> $nombreLog
echo "#####    Ejecución del script ${FECHA_CREACION}-${NOMBRE_SCRIPT}"  >> $nombreLog
echo "###############################################################"  >> $nombreLog
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$1 @${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $nombreLog
export RESULTADO=$?

export DML_ACTUALIZACION_FINAL=DML_003_ESQUEMA_ActualizacionFinal.sql
sed $CADENAS_SUSTITUCION "${DML_ACTUALIZACION_FINAL}" > ${FECHA_CREACION}-${DML_ACTUALIZACION_FINAL}

#Si ERROR, guardar respuesta y ejecución fallida
if [ $RESULTADO != 0 ] ; then
   echo -e "\n\n======>>> "Error en ${NOMBRE_SCRIPT}
   echo -e "\n\n======>>> "Error en @${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $nombreLog
   echo "###############################################################"  >> $nombreLog
   echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $nombreLog
   echo "###############################################################"  >> $nombreLog
   exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$1 @${FECHA_CREACION}-${DML_ACTUALIZACION_FINAL} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "KO" "$RESULTADO"  >> $nombreLog
   if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @${FECHA_CREACION}-${DML_ACTUALIZACION_FINAL} >> $nombreLog ; exit 1 ; fi
fi

#Si OK, guardar respuesta
if [ $RESULTADO == 0 ] ; then
   echo -e "\n\n======>>> "${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE
   echo -e "\n\nSCRIPT @${FECHA_CREACION}-${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE" >> $nombreLog
   echo "###############################################################"  >> $nombreLog
   echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $nombreLog
   echo "###############################################################"  >> $nombreLog
   exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$1 @${FECHA_CREACION}-${DML_ACTUALIZACION_FINAL} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "OK" "$RESULTADO"  >> $nombreLog
   if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @${FECHA_CREACION}-${DML_ACTUALIZACION_FINAL} >> $nombreLog ; exit 1 ; fi
fi

exit $RESULTADO
