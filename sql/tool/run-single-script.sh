#!/bin/bash

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
}


if [ "$ORACLE_HOME" == "" ] ; then
    print_banner
    echo ""
    echo "Defina su variable de entorno ORACLE_HOME"
    echo ""
    exit
fi

function usoCorrecto() {
    print_banner
    echo "Uso 1: $0 fichero_sql password_esquema_principal@sid [BANKIA|HAYA|-]"
    echo "Uso 2: $0 -p fichero_sql [BANKIA|HAYA|-]"
    echo -e "   El tercer parámetro (proyecto) sólo acepta estos posibles valores:"
    echo -e "      BANKIA (para que se use ~/setEnvGlobalBANKIA.sh)"
    echo -e "      HAYA   (para que se use ~/setEnvGlobalHAYA.sh)"
    echo -e "      -      (para que se use ~/setEnvGlobal.sh)"
    echo "Uso 3: $0 fichero_sql password_esquema_principal@sid"
    echo -e "      (se usará ~/setEnvGlobal.sh)"
    echo "Uso 4: $0 -p fichero_sql [BANKIA|HAYA|-]"
    echo -e "      (se usará ~/setEnvGlobal.sh)"
}

export SETENVGLOBAL=~/setEnvGlobal.sh
if [[ "$#" -ne 3 ]] && [[ "$#" -ne 2 ]] ; then
    usoCorrecto
    exit 1
else 
  if [ "$#" -eq 3 ] ; then
    if [[ "$3" != "BANKIA" ]] && [[ "$3" != "HAYA" ]] && [[ "$3" != "-" ]] ; then
      usoCorrecto
      exit 1
    else
      if [[ "$3" == "BANKIA" ]] || [[ "$3" == "HAYA" ]] ; then
        if [ -f ~/setEnvGlobal${3}.sh ] ; then
          export SETENVGLOBAL=~/setEnvGlobal${3}.sh
        fi
      fi
    fi
  fi
fi

if [ ! -f $SETENVGLOBAL ]; then
    echo "No existe el fichero: $SETENVGLOBAL"
    echo "Consulta las plantillas que hay en sql/tool/templates"
    exit 1
fi

if [ "$1" = "-p" ] ; then
   export FICHERO=$2
   export PRINT=SI
   export PW=-
else
   export FICHERO=$1
   export PRINT=NO   
   export PW=$2
fi

BASEDIR=$(dirname $0)

function obtenerSetEnv() {
  export nombreFichero=`basename $1`
  export nombreSinExt=${nombreFichero%%.*}

  export nombreSetEnv=setEnv_${nombreSinExt}.sh

  echo "### Iniciando generación del fichero" $nombreSetEnv

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

  echo "=== Fichero $BASEDIR/tmp/$nombreSetEnv generado"

}

function isDosFile() {
  [[ $(head -1 "$1") == *$'\r' ]]  
}

function transformaDosFile() {
  if isDosFile $1 ; then
    echo "Fichero $1 es DOS"
    dos2unix -q $1
    if [ "$?" == 0 ] ; then
      echo "Fichero $1 transformado a Linux por dos2unix"
    else
      sed 's/\r$//' "$1" > $1.bak ; mv $1.bak $1
      echo "Fichero $1 transformado a Linux por sed (dos2unix no instalado)"
    fi
  else
    echo "Fichero $1 es Linux"
  fi
}

if [ ! -f $FICHERO ] ; then
  echo "Fichero $FICHERO no encontrado."
  exit 1
fi

transformaDosFile $FICHERO

nombreFicheroSinDir=`basename $FICHERO`
nombreSinDirSinExt=${nombreFicheroSinDir%%.*}
nombreSetEnv=setEnv_${nombreSinDirSinExt}.sh

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

cp $1 $BASEDIR/tmp/

echo "Ejecutando:"
echo $BASEDIR/tmp/$nombreSinDirSinExt.sh $PW
if [ $PRINT = "SI" ] ; then
    $BASEDIR/tmp/$nombreSinDirSinExt.sh -p
else
    $BASEDIR/tmp/$nombreSinDirSinExt.sh $PW
fi

echo "Ejecutado! Revise el fichero de log"

#rm -f `date +%Y`*.sql
#rm -f reg*
#rm -f $nombreSinDirSinExt.sh
