#!/bin/bash
if [ "$ORACLE_HOME" == "" ] ; then
    echo "Debe ejecutar este shell desde un usuario que tenga permisos de ejecución de Oracle. Este usuario tiene ORACLE_HOME vacío"
    exit
fi

function uso_correcto() {
    nombre=$1
    echo -e "-----------------------------------------------------------------------------"
    echo -e "Uso incorrecto de $1. Estos son los posibles usos correctos"
    echo -e "Uso 1: $1 password_esquema_principal@sid"
    echo -e "Uso 2: $1 -p"
    echo -e "-----------------------------------------------------------------------------"
}


if [[ $# -gt 1 ]] || [[ $# -lt 1 ]] ; then
    uso_correcto $0
    exit
fi

export NLS_LANG=.AL32UTF8

export nombreFichero=`basename $0`
export nombreSinExt=${nombreFichero%%.*}

export nombreSetEnv=setEnv_${nombreSinExt}.sh

BASEDIR=$(dirname $0)
source $BASEDIR/$nombreSetEnv
VARIABLES_SUSTITUCION=`echo -e "${VARIABLES_SUSTITUCION}" | tr -d '[[:space:]]'`

export nombreLog=${nombreSinExt}-`date +%Y%m%d-%H%M%S`.log

if [[ "$#" -eq 1 ]] && [[ "$1" != "-p" ]] ; then
   PW=$1
fi

if [ "$1" = "-p" ] ; then
   echo "###############################################################"
   echo 'NOMBRE_SCRIPT='$NOMBRE_SCRIPT
   echo 'VARIABLES_SUSTITUCION='$VARIABLES_SUSTITUCION
   echo 'AUTOR='$AUTOR
   echo 'ARTEFACTO='$ARTEFACTO
   echo 'VERSION_ARTEFACTO='$VERSION_ARTEFACTO
   echo 'FECHA_CREACION='$FECHA_CREACION
   echo 'INCIDENCIA_LINK='$INCIDENCIA_LINK
   echo 'PRODUCTO='$PRODUCTO
   echo "###############################################################"
   echo ""
   exit 
fi

echo "###############################################################"  > $BASEDIR/$nombreLog
echo 'NOMBRE_SCRIPT='$NOMBRE_SCRIPT   >> $BASEDIR/$nombreLog
echo 'VARIABLES_SUSTITUCION='$VARIABLES_SUSTITUCION  >> $BASEDIR/$nombreLog
echo 'AUTOR='$AUTOR  >> $BASEDIR/$nombreLog
echo 'ARTEFACTO='$ARTEFACTO  >> $BASEDIR/$nombreLog
echo 'VERSION_ARTEFACTO='$VERSION_ARTEFACTO  >> $BASEDIR/$nombreLog
echo 'FECHA_CREACION='$FECHA_CREACION  >> $BASEDIR/$nombreLog
echo 'INCIDENCIA_LINK='$INCIDENCIA_LINK  >> $BASEDIR/$nombreLog
echo 'PRODUCTO='$PRODUCTO  >> $BASEDIR/$nombreLog
echo "###############################################################"  >> $BASEDIR/$nombreLog
echo ""  >> $BASEDIR/$nombreLog

ESQUEMA_MASTER=''
ESQUEMA_ENTIDAD=''
CADENAS_SUSTITUCION=""
IFS=',' read -a array <<< "$VARIABLES_SUSTITUCION"
for index in "${!array[@]}"
do
#    echo "$index ${array[index]}"

    KEY=`echo ${array[index]} | cut -d\; -f1`
    VALUE=`echo ${array[index]} | cut -d\; -f2`
    if [[ $KEY == '#ESQUEMA_MASTER#' ]]; then
       ESQUEMA_MASTER=$VALUE
    fi
    if [[ $KEY == '#ESQUEMA_ENTIDAD#' ]]; then
       ESQUEMA_ENTIDAD=$VALUE
    fi

    IFS=';' read -a array2 <<< "${array[index]}"
    for index2 in "${!array2[@]}"
    do
       if [ "$index2" -eq "0" ] ; then
          CADENA="-e s/""${array2[index2]}""/"
       fi
       if [ "$index2" -eq "1" ] ; then
          CADENA="$CADENA""${array2[index2]}/g "
       fi
       #echo "--- $index2 ${array2[index2]}"
    done
    CADENAS_SUSTITUCION="$CADENAS_SUSTITUCION""$CADENA "
done
#echo "$CADENAS_SUSTITUCION"

ESQUEMA_EJECUCION=`echo $nombreFichero | cut -d_ -f3`
if [[ $ESQUEMA_EJECUCION == "BANK01" ]] || [[ $ESQUEMA_EJECUCION == "ENTITY" ]] || [[ $ESQUEMA_EJECUCION == "HAYA01" ]]; then
    ESQUEMA_EJECUCION=$ESQUEMA_ENTIDAD 
fi
if [[ $ESQUEMA_EJECUCION == "BANKMASTER" ]] || [[ $ESQUEMA_EJECUCION == "MASTER" ]] || [[ $ESQUEMA_EJECUCION == "HAYAMASTER" ]]; then
    ESQUEMA_EJECUCION=$ESQUEMA_MASTER
fi

#Invocar PASO1
export PASO1=reg1.sql
sed -e s/#ESQUEMA#/${ESQUEMA_EJECUCION}/g "$BASEDIR/${PASO1}" > $BASEDIR/${FECHA_CREACION}-${PASO1}
echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO1}  >> $BASEDIR/$nombreLog"
$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO1}  >> $BASEDIR/$nombreLog
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO1} >> $BASEDIR/$nombreLog ; exit 1 ; fi

#Invocar PASO2
export PASO2=reg2.sql
sed -e s/#ESQUEMA#/${ESQUEMA_EJECUCION}/g "$BASEDIR/${PASO2}" > $BASEDIR/${FECHA_CREACION}-${PASO2}
echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION > /dev/null"
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then 
    echo -e "\n\n======>>> "Script $BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} ya ejecutado previamente > /dev/tty
    echo -e "\n\n======>>> "Script $BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} ya ejecutado >> $nombreLog
    echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
    exit 0
fi
if [ $RESULTADO != 0 ] ; then 
    echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO2} > /dev/tty
    echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO2} >> $nombreLog
    echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
    exit 1
fi
echo "##### SCRIPT ${NOMBRE_SCRIPT} ${FECHA_CREACION} NO EJECUTADO PREVIAMENTE"  >> $BASEDIR/$nombreLog

#Inserción inicial de datos en tabla de registro
export PASO3=reg3.sql
sed -e s/#ESQUEMA#/${ESQUEMA_EJECUCION}/g "$BASEDIR/${PASO3}" > $BASEDIR/${FECHA_CREACION}-${PASO3}
echo "#####    Inserción inicial de datos en tabla de registro"  >> $BASEDIR/$nombreLog
echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR""
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO" >> $BASEDIR/$nombreLog

#Ejecución del script en sí mismo
sed $CADENAS_SUSTITUCION "$BASEDIR/${NOMBRE_SCRIPT}" > $BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT}
echo "#####    Ejecución del script ${FECHA_CREACION}-${NOMBRE_SCRIPT}"  >> $BASEDIR/$nombreLog
echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog"
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog
export RESULTADO=$?

export PASO4=reg4.sql
sed -e s/#ESQUEMA#/${ESQUEMA_EJECUCION}/g "$BASEDIR/${PASO4}" > $BASEDIR/${FECHA_CREACION}-${PASO4}

#Si ERROR, guardar respuesta y ejecución fallida
if [ $RESULTADO != 0 ] ; then
   echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} > /dev/tty
   echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog
   echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $BASEDIR/$nombreLog
   echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog"
   exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog
   if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO4} >> $BASEDIR/$nombreLog ; exit 1 ; fi
fi

#Si OK, guardar respuesta
if [ $RESULTADO == 0 ] ; then
   echo -e "\n\n======>>> "$BASEDIR/${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE > /dev/tty
   echo -e "\n\nSCRIPT @${FECHA_CREACION}-${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE" >> $BASEDIR/$nombreLog
   echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $BASEDIR/$nombreLog
   echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog"
   exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog
   if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @${FECHA_CREACION}-${PASO4} >> $BASEDIR/$nombreLog ; exit 1 ; fi
fi

echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
exit $RESULTADO
