#!/bin/bash
if [ "$ORACLE_HOME" == "" ] ; then
    echo "Defina ORACLE_HOME. Este usuario tiene ORACLE_HOME vacío"
    exit
fi

function uso_correcto() {
    echo -e "-----------------------------------------------------------------------------"
    echo -e "Uso incorrecto de $0. Estos son los posibles usos correctos"
    echo -e "Uso 0: $0 password_esquema_principal@sid -v  (verbose)"
    echo -e "Uso 1: $0 password_esquema_principal@sid -p  (package)"
    echo -e "Uso 2: $0 password_esquema_principal@sid"
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

if [[ "$#" -eq 2 ]] && [[ "$2" == "-p" ]] ; then
    export PACKAGE=1
else
    export PACKAGE=0
fi

export NLS_LANG=.AL32UTF8

export nombreFichero=`basename $0`
export nombreSinExt=${nombreFichero%%.*}

export nombreSetEnv=setEnv_${nombreSinExt}.sh

BASEDIR=$(dirname $0)
source $BASEDIR/$nombreSetEnv
VARIABLES_SUSTITUCION=`echo -e "${VARIABLES_SUSTITUCION}" | tr -d '[[:space:]]'`
PW=$1

export nombreLog=${nombreSinExt}-`date +%Y%m%d-%H%M%S`.log

if [[ $PACKAGE == 0 ]]; then
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
fi

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

executionFile=""
if [[ $NOMBRE_SCRIPT =~ ^DML ]]; then
    executionFile=$BASEDIR/DML-scripts
else
    executionFile=$BASEDIR/DDL-scripts
fi
executionPass=""
if [[ $ESQUEMA_EJECUCION =~ MASTER$ ]]; then
    executionPass="\$1"
else
    executionPass="\$$((${ESQUEMA_EJECUCION: -1} + 1))"
fi

#Invocar PASO1
export PASO1=reg1.sql
sed -e s/#ESQUEMA#/${ESQUEMA_REGISTRO}/g "$BASEDIR/${PASO1}" > $BASEDIR/${FECHA_CREACION}-${PASO1}
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO1}  >> $BASEDIR/$nombreLog"
fi
if [[ $PACKAGE == 0 ]]; then
    $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${FECHA_CREACION}-${PASO1}  >> $BASEDIR/$nombreLog
    if [ $? != 0 ] ; then 
        echo -e "\n\n======>>> "Error en @$BASEDIR/${FECHA_CREACION}-${PASO1} >> $BASEDIR/$nombreLog
        echo " #KO# :  $BASEDIR/$nombreLog"
        exit 1
    fi
else
    cp $BASEDIR/${FECHA_CREACION}-${PASO1} $BASEDIR/DDL_000_$ESQUEMA_REGISTRO.sql
fi

#Invocar PASO2
export PASO2=reg2.sql
cat "$BASEDIR/${PASO2}" > $BASEDIR/${nombreSinExt}-${PASO2}
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null"
fi
if [[ $PACKAGE == 0 ]]; then
    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null
    export RESULTADO=$?
else
    echo "exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${nombreSinExt}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION" >> ${executionFile}.sh 
    echo "exit | sqlplus -s -l \$1 @./scripts/${nombreSinExt}-${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION" >> ${executionFile}-one-user.sh
    echo 'export RESULTADO=$?' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
fi
if [[ $PACKAGE == 0 ]]; then
    if [ $RESULTADO == 33 ] ; then 
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n\n======>>> "Script $BASEDIR/${NOMBRE_SCRIPT} ya ejecutado previamente > /dev/tty
        fi
        echo -e "\n\n======>>> "Script $BASEDIR/${NOMBRE_SCRIPT} ya ejecutado >> $BASEDIR/$nombreLog
        echo "  YE  :  $BASEDIR/$nombreLog"
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
        fi
        exit 0
    fi
    if [ $RESULTADO != 0 ] ; then 
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n\n======>>> "Error en @$BASEDIR/${nombreSinExt}-${PASO2} > /dev/tty
        fi
        echo -e "\n\n======>>> "Error en @$BASEDIR/${nombreSinExt}-${PASO2} >> $BASEDIR/$nombreLog
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
        fi
        echo " #KO# :  $BASEDIR/$nombreLog"
        exit 1
    fi
    echo "##### SCRIPT ${NOMBRE_SCRIPT} ${FECHA_CREACION} NO EJECUTADO PREVIAMENTE"  >> $BASEDIR/$nombreLog
else
    echo 'if [ $RESULTADO == 33 ] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo "    echo \" OK : Fichero ya ejecutado $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo 'elif [ $RESULTADO != 0 ] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo '    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo '    exit 1;' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo 'else' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
fi

#Inserción inicial de datos en tabla de registro
export PASO3=reg3.sql
cat "$BASEDIR/${PASO3}" > $BASEDIR/${nombreSinExt}-${PASO3}
if [[ $PACKAGE == 0 ]]; then
    echo "#####    Inserción inicial de datos en tabla de registro"  >> $BASEDIR/$nombreLog
fi
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO""
fi
if [[ $PACKAGE == 0 ]]; then
    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO" >> $BASEDIR/$nombreLog
else
    echo "  exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${nombreSinExt}-${PASO3} \"$NOMBRE_SCRIPT\" \"$ESQUEMA_EJECUCION\" \"$AUTOR\" \"$ARTEFACTO\"  \"$VERSION_ARTEFACTO\" \"$FECHA_CREACION\" \"$INCIDENCIA_LINK\" \"$PRODUCTO\"" >> ${executionFile}.sh 
    echo "  exit | sqlplus -s -l \$1 @./scripts/${nombreSinExt}-${PASO3} \"$NOMBRE_SCRIPT\" \"$ESQUEMA_EJECUCION\" \"$AUTOR\" \"$ARTEFACTO\"  \"$VERSION_ARTEFACTO\" \"$FECHA_CREACION\" \"$INCIDENCIA_LINK\" \"$PRODUCTO\"" >> ${executionFile}-one-user.sh
fi

#Ejecución del script en sí mismo
dos2unix -q "$BASEDIR/${NOMBRE_SCRIPT}"
sed $CADENAS_SUSTITUCION "$BASEDIR/${NOMBRE_SCRIPT}" > $BASEDIR/${nombreSinExt}-reg3.1.sql
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${nombreSinExt}-reg3.1.sql >> $BASEDIR/$nombreLog"
fi
if [[ $PACKAGE == 0 ]]; then
    echo "#####    Ejecución del script ${NOMBRE_SCRIPT}"  >> $BASEDIR/$nombreLog
    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${nombreSinExt}-reg3.1.sql >> $BASEDIR/$nombreLog
    export RESULTADO=$?
else
    echo "  exit | sqlplus -s -l $ESQUEMA_EJECUCION/$executionPass @./scripts/${nombreSinExt}-reg3.1.sql > ${nombreSinExt}.log" >> ${executionFile}.sh
    echo "  exit | sqlplus -s -l \$1 @./scripts/${nombreSinExt}-reg3.1.sql > ${nombreSinExt}.log" >> ${executionFile}-one-user.sh
    echo '  export RESULTADO=$?' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
fi

export PASO4=reg4.sql
cat "$BASEDIR/${PASO4}" > $BASEDIR/${nombreSinExt}-${PASO4}
if [[ $PACKAGE == 0 ]]; then
    #Si ERROR, guardar respuesta y ejecución fallida
    if [ $RESULTADO != 0 ] ; then
        echo " #KO# :  $BASEDIR/$nombreLog"
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n\n======>>> "Error en @$BASEDIR/${NOMBRE_SCRIPT} > /dev/tty
        fi
        echo -e "\n\n======>>> "Error en @$BASEDIR/${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog
        echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $BASEDIR/$nombreLog
        if [[ $VERBOSE == 1 ]]; then
            echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog"
        fi
        exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog
        if [ $? != 0 ] ; then 
            echo -e "\n\n======>>> "Error en @$BASEDIR/${nombreSinExt}-${PASO4} >> $BASEDIR/$nombreLog
            echo " #KO# :  $BASEDIR/$nombreLog"
            exit 1
        fi
    fi
    
    #Si OK, guardar respuesta
    if [ $RESULTADO == 0 ] ; then
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n\n======>>> "$BASEDIR/${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE > /dev/tty
        fi
        echo -e "\n\nSCRIPT @${NOMBRE_SCRIPT} FINALIZADO CORRECTAMENTE" >> $BASEDIR/$nombreLog
        echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $BASEDIR/$nombreLog
        if [[ $VERBOSE == 1 ]]; then
            echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog"
        fi
        exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${nombreSinExt}-${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog
        if [ $? != 0 ] ; then 
            echo -e "\n\n======>>> "Error en @${nombreSinExt}-${PASO4} >> $BASEDIR/$nombreLog
            echo " #KO# :  $BASEDIR/$nombreLog"
            exit 1
        fi
        echo "  OK  :  $BASEDIR/$nombreLog"
    fi
    
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
    fi
    exit $RESULTADO
else
    echo '  if [ $RESULTADO != 0 ] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo "      exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${nombreSinExt}-${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"KO\" \"$RESULTADO\"" >> ${executionFile}.sh 
    echo "      exit | sqlplus -s -l \$1 @./scripts/${nombreSinExt}-${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"KO\" \"$RESULTADO\"" >> ${executionFile}-one-user.sh
    echo "      echo \"@KO@: $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo "      exit 1" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo '  else' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo "      exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${nombreSinExt}-${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"OK\" \"$RESULTADO\"" >> ${executionFile}.sh 
    echo "      exit | sqlplus -s -l \$1 @./scripts/${nombreSinExt}-${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"OK\" \"$RESULTADO\"" >> ${executionFile}-one-user.sh
    echo "      echo \" OK : $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo '  fi' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo 'fi' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
fi
