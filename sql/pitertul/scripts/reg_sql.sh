#!/bin/bash
if [ "$ORACLE_HOME" == "" ] ; then
    echo "Defina ORACLE_HOME. Este usuario tiene ORACLE_HOME vacío"
    exit
fi

function uso_correcto() {
    echo -e "-----------------------------------------------------------------------------"
    echo -e "Uso incorrecto de $0. Estos son los posibles usos correctos"
    echo -e "Uso 1: $0 password_esquema_principal@sid -v  (verbose)"
    echo -e "Uso 2: $0 password_esquema_principal@sid -p  (package)"
    echo -e "Uso 3: $0 password_esquema_principal@sid -cv (compile-verbose)"
    echo -e "Uso 4: $0 password_esquema_principal@sid -cp (compile-package)"
    echo -e "Uso 5: $0 password_esquema_principal@sid -c  (compile)"
    echo -e "Uso 6: $0 password_esquema_principal@sid"
    echo -e "-----------------------------------------------------------------------------"
}

if [[ $# -gt 2 ]] || [[ $# -lt 1 ]] ; then
    uso_correcto
    exit
fi

export VERBOSE=0
export COMPILE=0
export PACKAGE=0

if [[ "$#" -eq 2 ]] && [[ "$2" == "-v" ]] ; then
    export VERBOSE=1
fi

if [[ "$#" -eq 2 ]] && [[ "$2" == "-p" ]] ; then
    export PACKAGE=1
fi

if [[ "$#" -eq 2 ]] && [[ "$2" == "-c" ]] ; then
    export COMPILE=1
fi

if [[ "$#" -eq 2 ]] && [[ "$2" == "-cv" ]] ; then
    export VERBOSE=1
    export COMPILE=1
fi

if [[ "$#" -eq 2 ]] && [[ "$2" == "-cp" ]] ; then
    export PACKAGE=1
    export COMPILE=1
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
    echo 'COMPILE='$COMPILE >> $BASEDIR/$nombreLog 
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
    ESQUEMA_FICHERO=`echo $nombreFichero | cut -d_ -f3`
    if [[ $ESQUEMA_FICHERO == "MINIREC" ]]; then
        ESQUEMA_EJECUCION="MINIREC"
    else
        ESQUEMA_EJECUCION=`echo $PW | cut -f1 -d/`
    fi
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
    if [[ ${!ESQUEMA_EJECUCION} != '' ]]; then
        ESQUEMA_EJECUCION=${!ESQUEMA_EJECUCION}
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
regFile=""
if [[ $NOMBRE_SCRIPT =~ ^DML ]]; then
    executionFile=$BASEDIR/DML-scripts
	regFile=DML_000_ENTITY01_
else
    executionFile=$BASEDIR/DDL-scripts
	regFile=DDL_000_ENTITY01_
fi
executionPass=""
executionPassWin=""
if [[ $ESQUEMA_EJECUCION =~ MASTER$ ]]; then
    executionPass="\$1"
    executionPassWin="%1"
elif [[ $ESQUEMA_EJECUCION == 'MINIREC' ]]; then
    if [[ "$MULTIENTIDAD" != "" ]]; then
        executionPass="\$4"
        executionPassWin="%4"
    else
        executionPass="\$3"
        executionPassWin="%3"
    fi
else
    executionPass="\$$((${ESQUEMA_EJECUCION: -1} + 1))"
    executionPassWin="%$((${ESQUEMA_EJECUCION: -1} + 1))"
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
        echo " #KO# [$AUTOR][$INCIDENCIA_LINK] :  $BASEDIR/$nombreLog"
        exit 1
    fi
else
    cp $BASEDIR/${FECHA_CREACION}-${PASO1} $BASEDIR/DDL_000_$ESQUEMA_REGISTRO.sql
fi

export PROC_VISTA=0
if [[ ${NOMBRE_SCRIPT} =~ ^DDL_[0-9]+_[^_]+_(SP|MV|VI)_[^\.]+\.sql$ ]] ; then
	export PROC_VISTA=1
fi

# Si se trata de un script de procs_y_vistas
if [[ "$COMPILE" == "0" ]] ; then
	if [[ "$PROC_VISTA" == "1" ]] ; then
	    # Registro
	    PASO3=reg3.sql
	    sed -e s/#ESQUEMA#/${ESQUEMA_REGISTRO}/g "$BASEDIR/${PASO3}" > "$BASEDIR/${regFile}${PASO3}"
	    PASO3=${regFile}${PASO3}
	    if [[ $PACKAGE == 0 ]]; then
	        echo "#####    Inserción inicial de datos en tabla de registro"  >> $BASEDIR/$nombreLog
	    fi
	    if [[ $VERBOSE == 1 ]]; then
	        echo $'\t'"$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO""
	    fi
	    if [[ $PACKAGE == 0 ]]; then
	        exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO" >> $BASEDIR/$nombreLog
	    else
	        echo $'\t'"exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${PASO3} \"$NOMBRE_SCRIPT\" \"$ESQUEMA_EJECUCION\" \"$AUTOR\" \"$ARTEFACTO\"  \"$VERSION_ARTEFACTO\" \"$FECHA_CREACION\" \"$INCIDENCIA_LINK\" \"$PRODUCTO\" > /dev/null" >> ${executionFile}.sh
	        echo $'\t'"exit | sqlplus -s -l \$1 @./scripts/${PASO3} \"$NOMBRE_SCRIPT\" \"$ESQUEMA_EJECUCION\" \"$AUTOR\" \"$ARTEFACTO\"  \"$VERSION_ARTEFACTO\" \"$FECHA_CREACION\" \"$INCIDENCIA_LINK\" \"$PRODUCTO\"" >> ${executionFile}-one-user.sh
	    fi

	    # Ejecución
	    dos2unix -q "$BASEDIR/${NOMBRE_SCRIPT}"
	    sed $CADENAS_SUSTITUCION "$BASEDIR/${NOMBRE_SCRIPT}" > $BASEDIR/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql
	    if [[ $VERBOSE == 1 ]]; then
	        echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql >> $BASEDIR/$nombreLog"
	    fi
	    if [[ $PACKAGE == 0 ]]; then
	        echo "#####    Ejecución del script ${NOMBRE_SCRIPT}"  >> $BASEDIR/$nombreLog
	        exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql >> $BASEDIR/$nombreLog
	        echo "   -- : $BASEDIR/$nombreLog"
	    else
		   	#Arreglo temporal para que las vistas materializadas esperen 15 segundos antes de comenzar
			if [[ "$nombreSinExt" =~ "VI_V_TAP_STA" ]] || 
			   [[ "$nombreSinExt" =~ "VI_ISG_INVENTARIO_SITUACION_GESTION" ]] || 
			   [[ "$nombreSinExt" =~ "VI_DSG_DETALLE_SITUACION_GESTION" ]] || 
			   [[ "$nombreSinExt" =~ "VI_VLIS_CUADROS_CRUZADOS" ]] ; then
		   		echo $'\t'"  sleep 15" >> ${executionFile}.sh
			fi
	        echo $'\t'"exit | sqlplus -s -l $ESQUEMA_EJECUCION/$executionPass @./scripts/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql > ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}.sh
	        echo $'\t'"exit | sqlplus -s -l \$1 @./scripts/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql > ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}-one-user.sh
	        echo "echo 'exit' | sqlplus $ESQUEMA_EJECUCION/$executionPassWin @./scripts/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql > ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}.bat
	        echo $'\t'"echo \" -- : $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh ${executionFile}.bat > /dev/null
	    fi

	    exit 0
	fi
fi

#Invocar PASO2
PASO2=reg2.sql
sed -e s/#ESQUEMA#/${ESQUEMA_REGISTRO}/g "$BASEDIR/${PASO2}" > "$BASEDIR/${regFile}${PASO2}"
PASO2=${regFile}${PASO2}
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null"
fi
if [[ $PACKAGE == 0 ]]; then
    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null
    export RESULTADO=$?
else
    echo $'\t'"exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null" >> ${executionFile}.sh 
    echo $'\t'"exit | sqlplus -s -l \$1 @./scripts/${PASO2} $NOMBRE_SCRIPT $FECHA_CREACION $ESQUEMA_EJECUCION > /dev/null" >> ${executionFile}-one-user.sh
    echo $'\t''export RESULTADO=$?' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
fi

if [[ $PACKAGE == 0 ]]; then
    if [[ $RESULTADO == 33 ]] ; then 
    	if [[ "$PROC_VISTA" != "0" ]] && [[ "$COMPILE" != "0" ]] ; then
	    #Si es un script de procs y vistas y estamos en modo COMPILE y ya ha sido ejecutado, se vuelve a ejecutar
	        if [[ $VERBOSE == 1 ]]; then
	            echo -e "\n\n======>>> "Script $BASEDIR/${NOMBRE_SCRIPT} ya ejecutado previamente pero se vuelve a ejecutar por ser de procs y vistas > /dev/tty
	        fi
	        echo -e "\n\n======>>> "Script $BASEDIR/${NOMBRE_SCRIPT} ya ejecutado pero se vuelve a ejecutar por ser de procs y vistas >> $BASEDIR/$nombreLog
	    else
		# Si es un script normal y ya ya sido ejecutado
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
    elif [ $RESULTADO != 0 ] ; then 
    #Si se ha producido error
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n\n======>>> "Error en @$BASEDIR/${PASO2} > /dev/tty
        fi
        echo -e "\n\n======>>> "Error en @$BASEDIR/${PASO2} >> $BASEDIR/$nombreLog
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
        fi
        echo " #KO# [$AUTOR][$INCIDENCIA_LINK] :  $BASEDIR/$nombreLog"
        exit 1
    else
	    echo "##### SCRIPT ${NOMBRE_SCRIPT} ${FECHA_CREACION} NO EJECUTADO PREVIAMENTE"  >> $BASEDIR/$nombreLog
	fi
else
    echo $'\t''if [[ $RESULTADO == 33 ]] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"    if [[ $PROC_VISTA != 0 ]] && [[ $COMPILE != 0 ]] ; then" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"        echo \" VE : Fichero se vuelve a ejecutar $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"        export RESULTADO=0" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''    else' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"        echo \" YE : Fichero ya ejecutado $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''    fi' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''elif [[ $RESULTADO != 0 ]] ; then ' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''    echo "Fin de ejecución por fallo. Remita los ficheros de logs para que se analice lo sucedido."' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''    exit 1' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''fi' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
fi


#Inserción inicial de datos en tabla de registro (sólo en el caso en que no se hubiera ejecutado anteriormente)
PASO3=reg3.sql
sed -e s/#ESQUEMA#/${ESQUEMA_REGISTRO}/g "$BASEDIR/${PASO3}" > "$BASEDIR/${regFile}${PASO3}"
PASO3=${regFile}${PASO3}
if [[ $RESULTADO != 33 ]] ; then
	if [[ $PACKAGE == 0 ]]; then
	    echo "#####    Inserción inicial de datos en tabla de registro"  >> $BASEDIR/$nombreLog
	fi
	if [[ $VERBOSE == 1 ]]; then
	    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO""
	fi
	if [[ $PACKAGE == 0 ]]; then
	    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO3} "$NOMBRE_SCRIPT" "$ESQUEMA_EJECUCION" "$AUTOR" "$ARTEFACTO" "$VERSION_ARTEFACTO" "$FECHA_CREACION" "$INCIDENCIA_LINK" "$PRODUCTO" >> $BASEDIR/$nombreLog
	else
	    echo $'\t''if [[ $RESULTADO == 0 ]] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null	
	    echo $'\t'"  exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${PASO3} \"$NOMBRE_SCRIPT\" \"$ESQUEMA_EJECUCION\" \"$AUTOR\" \"$ARTEFACTO\"  \"$VERSION_ARTEFACTO\" \"$FECHA_CREACION\" \"$INCIDENCIA_LINK\" \"$PRODUCTO\" > /dev/null" >> ${executionFile}.sh 
	    echo $'\t'"  exit | sqlplus -s -l \$1 @./scripts/${PASO3} \"$NOMBRE_SCRIPT\" \"$ESQUEMA_EJECUCION\" \"$AUTOR\" \"$ARTEFACTO\"  \"$VERSION_ARTEFACTO\" \"$FECHA_CREACION\" \"$INCIDENCIA_LINK\" \"$PRODUCTO\" > /dev/null" >> ${executionFile}-one-user.sh
	fi
else
	if [[ $PACKAGE != 0 ]]; then
	    echo $'\t''if [[ $RESULTADO == 0 ]] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null	
	fi
fi

#Ejecución del script en si mismo
dos2unix -q "$BASEDIR/${NOMBRE_SCRIPT}"
sed $CADENAS_SUSTITUCION "$BASEDIR/${NOMBRE_SCRIPT}" > $BASEDIR/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql
if [[ $VERBOSE == 1 ]]; then
    echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql >> $BASEDIR/$nombreLog"
fi
if [[ $PACKAGE == 0 ]]; then
    echo "#####    Ejecución del script ${NOMBRE_SCRIPT}"  >> $BASEDIR/$nombreLog
    exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql >> $BASEDIR/$nombreLog
    export RESULTADO=$?
    if [[ $RESULTADO == 0 ]] && [[ $COMPILE == 1 ]]  && [[ $PROC_VISTA == 1 ]] ; then
       	exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_EJECUCION/$PW @$BASEDIR/reg_check_compiled.sql $nombreSinExt $ESQUEMA_EJECUCION >> $BASEDIR/$nombreLog 
       	export RESULTADO=$?
    fi
else
	#Arreglo temporal para que las vistas materializadas esperen 15 segundos antes de comenzar
	if [[ "$nombreSinExt" =~ "VI_V_TAP_STA" ]] || 
	   [[ "$nombreSinExt" =~ "VI_ISG_INVENTARIO_SITUACION_GESTION" ]] || 
	   [[ "$nombreSinExt" =~ "VI_DSG_DETALLE_SITUACION_GESTION" ]] || 
	   [[ "$nombreSinExt" =~ "VI_VLIS_CUADROS_CRUZADOS" ]] ; then
	   		echo $'\t'"  sleep 15" >> ${executionFile}.sh
	fi
    echo $'\t'"  exit | sqlplus -s -l $ESQUEMA_EJECUCION/$executionPass @./scripts/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql > ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}.sh
    echo $'\t'"  exit | sqlplus -s -l \$1 @./scripts/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql > ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}-one-user.sh
    echo $'\t''  export RESULTADO=$?' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    if [[ $COMPILE == 1 ]]  && [[ $PROC_VISTA == 1 ]] ; then
	    echo $'\t'"  export COMPILE=$COMPILE ; export PROC_VISTA=$PROC_VISTA " >> ${executionFile}.sh
	    echo $'\t'"  export COMPILE=$COMPILE ; export PROC_VISTA=$PROC_VISTA " >> ${executionFile}-one-user.sh
	    echo $'\t''  if [[ $RESULTADO == 0 ]] && [[ $COMPILE == 1 ]]  && [[ $PROC_VISTA == 1 ]] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null	
	    echo $'\t'"     exit | sqlplus  -s -l $ESQUEMA_EJECUCION/$executionPass @./scripts/reg_check_compiled.sql $nombreSinExt $ESQUEMA_EJECUCION >> ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}.sh
	    echo $'\t''     export RESULTADO=$?' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
	    echo $'\t''  fi' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null	
	fi

    echo "echo 'exit' | sqlplus $ESQUEMA_EJECUCION/$executionPassWin @./scripts/${nombreSinExt}-$ESQUEMA_EJECUCION-reg3.1.sql > ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}.bat
    echo "if errorlevel 1 (" >> ${executionFile}.bat 
    echo "  echo ERROR. Revise ${nombreSinExt}-$ESQUEMA_EJECUCION.log" >> ${executionFile}.bat
    echo "  exit 1" >> ${executionFile}.bat
    echo ")" >> ${executionFile}.bat
fi

PASO4=reg4.sql
sed -e s/#ESQUEMA#/${ESQUEMA_REGISTRO}/g "$BASEDIR/${PASO4}" > "$BASEDIR/${regFile}${PASO4}"
PASO4=${regFile}${PASO4}
if [[ $PACKAGE == 0 ]]; then
    #Si ERROR, guardar respuesta y ejecución fallida
    if [ $RESULTADO != 0 ] ; then
        echo " #KO# [$AUTOR][$INCIDENCIA_LINK] :  $BASEDIR/$nombreLog"
        if [[ $VERBOSE == 1 ]]; then
            echo -e "\n\n======>>> "Error en @$BASEDIR/${NOMBRE_SCRIPT} > /dev/tty
        fi
        echo -e "\n\n======>>> "Error en @$BASEDIR/${NOMBRE_SCRIPT} >> $BASEDIR/$nombreLog
        echo "#####    Ejecución la actualización de resultados en la tabla de registro"  >> $BASEDIR/$nombreLog
        if [[ $VERBOSE == 1 ]]; then
            echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog"
        fi
        exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "KO" "$RESULTADO"  >> $BASEDIR/$nombreLog
        if [ $? != 0 ] ; then 
            echo -e "\n\n======>>> "Error en @$BASEDIR/${PASO4} >> $BASEDIR/$nombreLog
            echo " #KO# [$AUTOR][$INCIDENCIA_LINK] :  $BASEDIR/$nombreLog"
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
            echo "$ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog"
        fi
        exit | $ORACLE_HOME/bin/sqlplus -s -l $ESQUEMA_REGISTRO/$PW @$BASEDIR/${PASO4} "$NOMBRE_SCRIPT" "$FECHA_CREACION" "$ESQUEMA_EJECUCION" "OK" "$RESULTADO"  >> $BASEDIR/$nombreLog
        if [ $? != 0 ] ; then 
            echo -e "\n\n======>>> "Error en @${PASO4} >> $BASEDIR/$nombreLog
            echo " #KO# [$AUTOR][$INCIDENCIA_LINK] :  $BASEDIR/$nombreLog"
            exit 1
        fi
        echo "  OK  :  $BASEDIR/$nombreLog"
    fi
    
    if [[ $VERBOSE == 1 ]]; then
        echo -e "\n#####    Fichero log generado: $BASEDIR/$nombreLog" > /dev/tty
    fi
    exit $RESULTADO
else
    echo $'\t''  if [ $RESULTADO != 0 ] ; then' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"      exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"KO\" \"$RESULTADO\" > /dev/null" >> ${executionFile}.sh 
    echo $'\t'"      exit | sqlplus -s -l \$1 @./scripts/${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"KO\" \"$RESULTADO\" > /dev/null" >> ${executionFile}-one-user.sh
    echo $'\t'"      echo \"@KO@ [$AUTOR][$INCIDENCIA_LINK] : $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"      cat ${nombreSinExt}-$ESQUEMA_EJECUCION.log" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"      exit 1" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''  else' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t'"      exit | sqlplus -s -l $ESQUEMA_REGISTRO/\$2 @./scripts/${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"OK\" \"$RESULTADO\" > /dev/null" >> ${executionFile}.sh 
    echo $'\t'"      exit | sqlplus -s -l \$1 @./scripts/${PASO4} \"$NOMBRE_SCRIPT\" \"$FECHA_CREACION\" \"$ESQUEMA_EJECUCION\" \"OK\" \"$RESULTADO\" > /dev/null" >> ${executionFile}-one-user.sh
    echo $'\t'"      echo \" OK : $NOMBRE_SCRIPT\"" | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''  fi' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
    echo $'\t''fi' | tee -a ${executionFile}.sh ${executionFile}-one-user.sh > /dev/null
fi
