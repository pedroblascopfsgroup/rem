#!/bin/bash

#####################################################################################
#                                    FUNCTIONS                                      #
#####################################################################################

. ./sql/pitertul/commons/check.sh
. ./sql/pitertul/commons/configuration.sh

function print_banner() {
    echo '******************************************************************************************'
    echo '******************************************************************************************'
    echo ''
    echo '   .-------. .-./`) ,---------.    .----.  .-------. ,---------.   ___    _   .---.'
    echo '   \  _(`)_ \\ .-.`)\          \ .`_ _   \ |  _ _   \\          \.`   |  | |  | ,_|'
    echo '   | (_ o._)|/ `-` \ `--.  ,---`/ ( ` )   `| ( ` )  | `--.  ,--- |   .|  | |,-./  )'
    echo '   |  (_,_) / `-``-`    |   \  . (_ o _)  ||(_ o _) /    |   \   .`  `_  | |\   _  `)'
    echo '   |   |-.-   .---.     :_ _:  |  (_,_)___|| (_,_).  __  :_ _:   |   ( \.-.| > (_)  )'
    echo '   |   |      |   |     (_I_)  |  \   .---.|  |\ \  |  | (_I_)   | (`. _` /|(  .  .-'
    echo '   |   |      |   |    (_(=)_)  \  `--    /|  | \ `-   /(_(=)_)  | (_ (_) _) `- `-`|___'
    echo '   /   )      |   |     (_I_)    \       / |  |  \    /  (_I_)    \ /  . \ /  |        \'
    echo '   `---`      `---`     `---`     ``-..-`  ``-`   ``-`   `---`     ``- `-`    `--------`'
    echo ""
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    echo ""
    echo " EJECUTA UN ÚNICO SCRIPT"
    echo ""
    echo "******************************************************************************************"
    echo ""
}

function usoCorrecto() {
    print_banner
    if [ "$ORACLE_SID" == "" ] ; then
        echo "Uso 0: $0 fichero_sql password_esquemas@sid [CLIENTE|-]"
        echo "Uso 1: $0 fichero_sql password_esquemas@sid [CLIENTE|-] -v"
    else
        echo "Uso 0: $0 fichero_sql password_esquemas [CLIENTE|-]"
        echo "Uso 1: $0 fichero_sql password_esquemas [CLIENTE|-] -v"
    fi
    echo -e ""
    echo -e "   El tercer parámetro:"
    echo -e "      CLIENTE  (para que se use ~/setEnvGlobalCLIENTE.sh)" 
    echo -e "      -        (para que se use ~/setEnvGlobal.sh)"
    echo -e ""
    echo -e "   -v Para modo verbose"
    echo ""
}

function obtenerSetEnv() {
  export nombreFichero=`basename $1`
  export nombreSinExt=${nombreFichero%%.*}

  export nombreSetEnv=setEnv_${nombreSinExt}.sh
  if [[ $VERBOSE == 1 ]]; then
    echo "### Iniciando generación del fichero" $nombreSetEnv
  fi

  export AUTOR=`cat $1 | grep ' AUTOR=' | cut -d'=' -f2`
  if [ "$AUTOR" == "" ] ; then
      echo "No está definido el campo AUTOR en el fichero $1. No se puede procesar."
      exit 1
  fi

  export ARTEFACTO=`cat $1 | grep ' ARTEFACTO=' | cut -d'=' -f2`
  if [ "$ARTEFACTO" == "" ] ; then
      echo "No está definido el campo ARTEFACTO en el fichero $1. No se puede procesar."
      exit 1
  fi

  export VERSION_ARTEFACTO=`cat $1 | grep ' VERSION_ARTEFACTO=' | cut -d'=' -f2`
  if [ "$VERSION_ARTEFACTO" == "" ] ; then
      echo "No está definido el campo VERSION_ARTEFACTO en el fichero $1. No se puede procesar."
      exit 1
  fi

  export FECHA_CREACION=`cat $1 | grep ' FECHA_CREACION=' | cut -d'=' -f2`
  if [ "$FECHA_CREACION" == "" ] ; then
      echo "No está definido el campo FECHA_CREACION en el fichero $1. No se puede procesar."
      exit 1
  fi

  export INCIDENCIA_LINK=`cat $1 | grep ' INCIDENCIA_LINK=' | cut -d'=' -f2 | sed -e 's/ /_/g'`
  if [ "$INCIDENCIA_LINK" == "" ] ; then
      echo "No está definido el campo INCIDENCIA_LINK en el fichero $1. No se puede procesar."
      exit 1
  fi

  export PRODUCTO=`cat $1 | grep ' PRODUCTO=' | cut -d'=' -f2`
  if [ "$PRODUCTO" == "" ] ; then
      echo "No está definido el campo PRODUCTO en el fichero $1. No se puede procesar."
      exit 1
  fi

  # Eliminar los espacios dentro de VARIABLES_SUSTITUCION
  VARIABLES_SUSTITUCION=`echo -e "${VARIABLES_SUSTITUCION}" | tr -d '[[:space:]]'`

  echo "#!/bin/bash" > $BASEDIR/tmp/$nombreSetEnv
  echo "export NOMBRE_SCRIPT=$(basename $1)" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export ESQUEMA_EJECUCION=$ESQUEMA_EJECUCION" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export VARIABLES_SUSTITUCION='$VARIABLES_SUSTITUCION'" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export AUTOR='$AUTOR'" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export ARTEFACTO=$ARTEFACTO" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export VERSION_ARTEFACTO=$VERSION_ARTEFACTO" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export FECHA_CREACION=$FECHA_CREACION" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export INCIDENCIA_LINK=$INCIDENCIA_LINK" >> $BASEDIR/tmp/$nombreSetEnv
  echo "export PRODUCTO=$PRODUCTO" >> $BASEDIR/tmp/$nombreSetEnv

  if [[ $VERBOSE == 1 ]]; then
    echo "=== Fichero $BASEDIR/tmp/$nombreSetEnv generado"
  fi

}

function isDosFile() {
  [[ $(head -1 "$1") == *$'\r' ]]  
}

function transformaDosFile() {
  if isDosFile $1 ; then
    if [[ $VERBOSE == 1 ]]; then
        echo "Fichero $1 es DOS"
    fi
    dos2unix -q $1
    if [ "$?" == 0 ] ; then
      if [[ $VERBOSE == 1 ]]; then
        echo "Fichero $1 transformado a Linux por dos2unix"
      fi
    else
      sed 's/\r$//' "$1" > $1.bak ; mv $1.bak $1
      if [[ $VERBOSE == 1 ]]; then
        echo "Fichero $1 transformado a Linux por sed (dos2unix no instalado)"
      fi
    fi
  else
    if [[ $VERBOSE == 1 ]]; then
      echo "Fichero $1 es Linux"
    fi
  fi
}


function print_ouput_console() {
  FILE=$1
  SHOW_WARNINGS=$2

  if [[ $SHOW_WARNINGS == "y" ]]; then
    CRITICAL_OBJECTS_FILE=sql/pitertul/scripts
    if [[ $nombreFicheroSinDir =~ ^DDL.*$ ]] ; then
        CRITICAL_OBJECTS_FILE=${CRITICAL_OBJECTS_FILE}/DDL-critical-objects.txt
    else
        CRITICAL_OBJECTS_FILE=${CRITICAL_OBJECTS_FILE}/DML-critical-objects.txt
    fi
    echo ""
    echo "         $FILE"
    while read -r line
        do
            grep -i "$line" $FILE > $BASEDIR/tmp/ocurrences.log
            if [ $? -eq 0 ]; then
                echo ""
                echo "******** WARNING - Incluye $line"
                while read -r ocurrence
                    do
                        echo "********         |   $ocurrence"
                    done < $BASEDIR/tmp/ocurrences.log
                echo ""
            fi
        done < $CRITICAL_OBJECTS_FILE
  else 
    echo "         $FILE"
  fi
}

#####################################################################################
#                                      MAIN                                         #
#####################################################################################
INPUT_PARAM_FILE=$1
INPUT_PARAM_PATH=$2
INPUT_PARAM_CLIENTE=$3
INPUT_PARAM_VERBOSE=$4

if [ "$ORACLE_HOME" == "" ] ; then
    print_banner
    echo ""
    echo "Defina su variable de entorno ORACLE_HOME"
    echo ""
    exit
fi

if [[ "$#" -lt 3 ]] ; then
    usoCorrecto
    exit 1
fi

if [[ "$#" -eq 4 ]] && [[ "$INPUT_PARAM_VERBOSE" == "-v" ]] ; then
    export VERBOSE=1
else
    export VERBOSE=0
fi
if [[ "$#" -eq 4 ]] && [[ "$INPUT_PARAM_VERBOSE" == "-p" ]] ; then
    export PACKAGE=1
else
    export PACKAGE=0
fi

loadEnvironmentVariables ${INPUT_PARAM_CLIENTE}

FICHERO=$INPUT_PARAM_FILE
PW=$INPUT_PARAM_PATH

BASEDIR=$(dirname $0)

if [ ! -f $FICHERO ] ; then
  echo "Fichero $FICHERO no encontrado."
  exit 1
fi

transformaDosFile $FICHERO

nombreFicheroSinDir=`basename $FICHERO`
nombreSinDirSinExt=${nombreFicheroSinDir%%.*}
nombreSetEnv=setEnv_${nombreSinDirSinExt}.sh

mkdir -p $BASEDIR/tmp

checkScriptFormat $FICHERO

obtenerSetEnv $FICHERO
if [ "$?" != "0" ] ; then
   echo "Error al obtener Variables de Entorno"
   exit 1
fi

cp -f $BASEDIR/scripts/reg_sql.sh $BASEDIR/tmp/$nombreSinDirSinExt.sh
cp -f $BASEDIR/scripts/reg?.sql $BASEDIR/tmp/
chmod u+x $BASEDIR/tmp/$nombreSinDirSinExt.sh

print_ouput_console $FICHERO

cp $FICHERO $BASEDIR/tmp/

if [[ $VERBOSE == 1 ]]; then
    echo "Ejecutando:"
fi

if [[ $VERBOSE == 1 ]]; then
    echo $BASEDIR/tmp/$nombreSinDirSinExt.sh $PW -v
    $BASEDIR/tmp/$nombreSinDirSinExt.sh $PW -v
elif [[ $PACKAGE == 1 ]]; then
    $BASEDIR/tmp/$nombreSinDirSinExt.sh $PW -p
else
    $BASEDIR/tmp/$nombreSinDirSinExt.sh $PW
fi
