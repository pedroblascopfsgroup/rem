#!/bin/bash
if [ "$ORACLE_HOME" == "" ] ; then
    echo "Defina ORACLE_HOME. Este usuario tiene ORACLE_HOME vacío"
    exit
fi

function uso_correcto() {
    echo -e "-----------------------------------------------------------------------------"
    echo -e "Uso incorrecto de $0. Estos son los posibles usos correctos"
    echo -e "Uso 0: $0 password_esquema_principal@sid -v"
    echo -e "Uso 1: $0 password_esquema_principal@sid"
    echo -e "Uso 2: $0 -p"
    echo -e "-----------------------------------------------------------------------------"
}


if [[ $# -gt 2 ]] || [[ $# -lt 1 ]] ; then
    uso_correcto
    exit
fi

if [[ "$#" -eq 2 ]] && [[ "$2" == "-v" ]] ; then
    export VERBOSE=1
else
    export VERBOSE=0
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

ESQUEMA='' # para reemplazo de variables
ESQUEMA_MASTER='' # para reemplazo de variables
ESQUEMA_EJECUCION='' # para la ejecución del script
ESQUEMA_REGISTRO='' # el que alberga la tabla de registro
CONNECTION='' # para la conexión a la BD

IFS=',' read -a array <<< "$VARIABLES_SUSTITUCION"
for index in "${!array[@]}"
do
    KEY=`echo ${array[index]} | cut -d\; -f1`
    VALUE=`echo ${array[index]} | cut -d\; -f2`
    if [[ $KEY == '#ESQUEMA_MASTER#' ]]; then
       ESQUEMA_MASTER=$VALUE
    fi
    if [[ $KEY == '#ESQUEMA#' ]]; then
       ESQUEMA=$VALUE
       ESQUEMA_REGISTRO=$ESQUEMA
    fi
done

if [ `expr index $PW '@'` -gt 0 ] ; then
    CONNECTION=`echo $PW | cut -f2 -d@`
    PW=`echo $PW | cut -f1 -d@`
fi

if [ `expr index $PW '/'` -gt 0 ] ; then
    ESQUEMA_EJECUCION=`echo $PW | cut -f1 -d/`
    ESQUEMA=$ESQUEMA_EJECUCION
    PW=`echo $PW | cut -f2 -d/`
else
    ESQUEMA_EJECUCION=`echo $nombreFichero | cut -d_ -f3`
    if [[ $ESQUEMA_EJECUCION == "BANK01" ]] || [[ $ESQUEMA_EJECUCION == "ENTITY01" ]] || [[ $ESQUEMA_EJECUCION == "HAYA01" ]]; then
        ESQUEMA_EJECUCION=$ESQUEMA 
    fi
    if [[ $ESQUEMA_EJECUCION == "BANKMASTER" ]] || [[ $ESQUEMA_EJECUCION == "MASTER" ]] || [[ $ESQUEMA_EJECUCION == "HAYAMASTER" ]]; then
        ESQUEMA_EJECUCION=$ESQUEMA_MASTER
    fi
fi
if [ "$CONNECTION" != "" ] ; then
    PW="$PW""@""$CONNECTION"
fi

CADENAS_SUSTITUCION=""
IFS=',' read -a array <<< "$VARIABLES_SUSTITUCION"
for index in "${!array[@]}"
do
    KEY=`echo ${array[index]} | cut -d\; -f1`
    VALUE=`echo ${array[index]} | cut -d\; -f2`
    if [[ $KEY == '#ESQUEMA#' ]]; then
        VALUE=$ESQUEMA
    fi
    CADENA="-e s/$KEY/$VALUE/g "
    CADENAS_SUSTITUCION="$CADENAS_SUSTITUCION""$CADENA "
done

#Invocar PASO1
export PASO1=reg1.sql
sed -e s/#ESQUEMA#/${ESQUEMA_REGISTRO}/g "$BASEDIR/${PASO1}" > $BASEDIR/${FECHA_CREACION}-${PASO1}
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO1}  >> $BASEDIR/$nombreLog"
fi
$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO1}  >> $BASEDIR/$nombreLog
if [ $? != 0 ] ; then 
    echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO1} >> $BASEDIR/$nombreLog
    echo " #KO# :  $BASEDIR/$nombreLog"
    exit 1
fi

#Invocar PASO2
export PASO2=reg2.sql
cat "$BASEDIR/${PASO2}" > $BASEDIR/${FECHA_CREACION}-${PASO2}
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null"
fi
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null
export RESULTADO=$?
if [ $RESULTADO == 33 ] ; then 
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n\n======>>> "Script $BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} ya ejecutado previamente > /dev/tty
    fi
    echo -e "\n\n======>>> "Script $BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} ya ejecutado >> $BASEDIR/$nombreLog
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
    fi
    echo "  YE  :  $BASEDIR/$nombreLog"
    exit 0
fi
if [ $RESULTADO != 0 ] ; then 
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO2} > /dev/tty
    fi
    echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO2} >> $BASEDIR/$nombreLog
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
    fi
    echo " #KO# :  $BASEDIR/$nombreLog"
    exit 1
fi
echo "##### SCRIPT ${NOMBRE_SCRIPT} ${FECHA_CREACION} NO EJECUTADO PREVIAMENTE"  >> $BASEDIR/$nombreLog

#Inserción inicial de datos en tabla de registro
export PASO3=reg3.sql
cat "$BASEDIR/${PASO3}" > $BASEDIR/${FECHA_CREACION}-${PASO3}
echo "#####    Inserción inicial de datos en tabla de registro"  >> $BASEDIR/$nombreLog
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR""
fi
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO" >> $BASEDIR/$nombreLog

#Ejecución del script en sí mismo
sed $CADENAS_SUSTITUCION "$BASEDIR/${NOMBRE_SCRIPT}" > $BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT}
echo "#####    Ejecución del script ${FECHA_CREACION}-${NOMBRE_SCRIPT}"  >> $BASEDIR/$nombreLog
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog"
fi
exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog
export RESULTADO=$?

export PASO4=reg4.sql
cat "$BASEDIR/${PASO4}" > $BASEDIR/${FECHA_CREACION}-${PASO4}

#Si ERROR, guardar respuesta y ejecución fallida
if [ $RESULTADO != 0 ] ; then
    echo " #KO# :  $BASEDIR/$nombreLog"
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} > /dev/tty
    fi
    echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog
    echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $BASEDIR/$nombreLog
    if [[ $VERBOSE == 1 ]]; then
        echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog"
    fi
    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog
    if [ $? != 0 ] ; then 
        echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO4} >> $BASEDIR/$nombreLog
        echo " #KO# :  $BASEDIR/$nombreLog"
        exit 1
    fi
fi

#Si OK, guardar respuesta
if [ $RESULTADO == 0 ] ; then
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n\n======>>> "$BASEDIR/${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE > /dev/tty
    fi
    echo -e "\n\nSCRIPT @${FECHA_CREACION}-${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE" >> $BASEDIR/$nombreLog
    echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $BASEDIR/$nombreLog
    if [[ $VERBOSE == 1 ]]; then
        echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog"
    fi
    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog
    if [ $? != 0 ] ; then 
        echo -e "\n\n======>>> "Error en @${FECHA_CREACION}-${PASO4} >> $BASEDIR/$nombreLog
        echo " #KO# :  $BASEDIR/$nombreLog"
        exit 1
    fi
    echo "  OK  :  $BASEDIR/$nombreLog"
fi

if [[ $VERBOSE == 1 ]]; then
    echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
fi
exit $RESULTADO
