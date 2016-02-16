#!/bin/bash

#####################################################################################
#                                    FUNCTIONS                                      #
#####################################################################################

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

  if [ -f $SETENVGLOBAL ] ; then
      source $SETENVGLOBAL
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

#####################################################################################
#                                      MAIN                                         #
#####################################################################################

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

if [[ "$#" -eq 4 ]] && [[ "$4" == "-v" ]] ; then
    export VERBOSE=1
else
    export VERBOSE=0
fi
if [[ "$#" -eq 4 ]] && [[ "$4" == "-p" ]] ; then
    export PACKAGE=1
else
    export PACKAGE=0
fi

export SETENVGLOBAL=~/setEnvGlobal.sh
if [[ "$3" != "-" ]] ; then
  if [ -f ~/setEnvGlobal${3}.sh ] ; then
    export SETENVGLOBAL=~/setEnvGlobal${3}.sh
  fi
fi

if [ ! -f $SETENVGLOBAL ]; then
    echo "No existe el fichero: $SETENVGLOBAL"
    echo "Consulta las plantillas que hay en sql/tool/templates"
    exit 1
fi

export FICHERO=$1
export PW=$2

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
if [[ $PACKAGE == 0 ]]; then
    rm -f $BASEDIR/tmp/*$nombreSinDirSinExt* 
fi

if [[ ! $nombreFicheroSinDir =~ ^D[MD]L_[0-9]+_[^_]+_[^\.]+\.sql$ ]] ; then
    echo ""
    echo "El nombre del script $nombreFicheroSinDir no sigue la nomenclatura definida"
    echo "Consulta sql/tool/templates para ver un ejemplo de plantilla"
    exit 1
fi
grep -Fqi "WHENEVER SQLERROR" $FICHERO
if [[ $? != 0 ]] ; then
    echo ""
    echo "El script no contiene la primera línea de control de errores: WHENEVER SQLERROR ..."
    echo "Consulta sql/tool/templates para ver un ejemplo de plantilla"
    exit 1
fi

if [ ! -f $BASEDIR/tmp/$nombreSetEnv ] ; then
   obtenerSetEnv $FICHERO
   if [ "$?" != "0" ] ; then
      echo "Error al obtener Variables de Entorno"
      exit 1
   fi
else 
   transformaDosFile $BASEDIR/tmp/$nombreSetEnv
fi

cp -f $BASEDIR/scripts/reg_sql.sh $BASEDIR/tmp/$nombreSinDirSinExt.sh
cp -f $BASEDIR/scripts/reg?.sql $BASEDIR/tmp/
chmod u+x $BASEDIR/tmp/$nombreSinDirSinExt.sh

echo ""
echo "         $1"
cp $1 $BASEDIR/tmp/

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
