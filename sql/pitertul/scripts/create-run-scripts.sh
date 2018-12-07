#!/bin/bash

if [[ "$#" -ne 2 ]] && [[ "$#" -ne 1 ]] ; then
   echo -e "Nº parámetros incorrecto.\nUso 1: $0 [DML|DML_PFSRECOVERY|DDL|Grant] \nUso 1: $0 [DML|DML_PFSRECOVERY|DDL|Grant] [BANKIA|HAYA|-] "
   exit
fi

export TIPO=$1
if [[ "$TIPO" != "DML" ]] && [[ "$TIPO" != "DML_PFSRECOVERY" ]] && [[ "$TIPO" != "DDL" ]] && [[ "$TIPO" != "Grant" ]] ; then
   echo -e "\nInvocación incorrecta.\nUso 1: $0 [DML|DML_PFSRECOVERY|DDL|Grant] \nUso 1: $0 [DML|DML_PFSRECOVERY|DDL|Grant] [BANKIA|HAYA|-] "
   exit 1
fi

echo '#!/bin/bash'
echo 'if [ "$ORACLE_HOME" == "" ] ; then'
echo '    echo "Debe ejecutar este shell desde un usuario que tenga permisos de ejecución de Oracle. Este usuario tiene ORACLE_HOME vacío"'
echo '    exit'
echo 'fi'

export PFSRECOVERY=NO
if [ "$1" == "DML_PFSRECOVERY" ] ; then
   PFSRECOVERY=SI
   TIPO=DML
   echo 'if [ "$#" -ne 1 ]; then'
   echo '    echo "Parametros: PFSRECOVERY_pass@sid"'
   echo '    exit'
   echo 'fi'
else 
   echo 'if [ "$#" -ne 5 ]; then'
   echo '    echo "Parametros: bankmaster_pass@sid bank01_pass@sid minirec_pass@sid recovery_bankia_dwh@sid recovery_bankia_datastage_pass@sid"'
   echo '    exit'
   echo 'fi'
fi

echo 'export NLS_LANG=.AL32UTF8'
echo -e "\n"

echo 'echo "####### INICIO DEL SCRIPT $0"'

function salida () {
	esquema=$1
	f=$2
	directorio=$3
	pfsrecovery=$4 
	SETENVGLOBAL=$5

	nombreFicheroSinDir=`basename $f`
	nombreSinDirSinExt=${nombreFicheroSinDir%%.*}

	if [ ! -f $f ] ; then
	  echo "Fichero $f no encontrado."
	  exit 1
	fi

	transformaDosFile $f

	nombreSinDirSinExt=${nombreFicheroSinDir%%.*}
	nombreSetEnv=setEnv_${nombreSinDirSinExt}.sh

	if [ ! -f $directorio/$nombreSetEnv ] ; then
   		obtenerSetEnv $f $directorio $SETENVGLOBAL
   		if [ "$?" != "0" ] ; then
      		echo "Error al obtener Variables de Entorno"
      		exit 1
   		fi
	else 
   		transformaDosFile $directorio/$nombreSetEnv
	fi

	nombreFicheroLog=${nombreSinDirSinExt}-`date +%Y%m%d-%H%M%S`.log

	if [ $esquema == "BANKMASTER" ] ; then pass_sid='1' ; fi
	if [ $esquema == "BANK01" ] ; then pass_sid='2' ; fi
	if [ $esquema == "MINIREC" ] ; then pass_sid='3' ; fi
	if [ $esquema == "RECOVERY_BANKIA_DWH" ] ; then pass_sid='4' ; fi
	if [ $esquema == "RECOVERY_BANKIA_DATASTAGE" ] ; then pass_sid='5' ; fi

	if [ $pfsrecovery == "SI" ] ; then esquema='PFSRECOVERY' ; fi

	echo 'cp reg*.sql '$directorio
	echo 'cd '$directorio
	echo 'cp ../reg_sql.sh '$nombreSinDirSinExt.sh
	echo 'echo "#####    INICIO' "$f" '('$esquema')"' ' >> '$nombreFicheroLog
	if [ $pfsrecovery == "SI" ] ; then
	     echo './'$nombreSinDirSinExt'.sh $1 PFSRECOVERY >> '$nombreFicheroLog
	else
	     echo './'$nombreSinDirSinExt'.sh $'$pass_sid '  >> '$nombreFicheroLog
	fi        
	echo 'if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en '"@$f"' >> '$nombreFicheroLog ' ; fi'
        echo 'cd '..
}

export SETENVGLOBAL=~/setEnvGlobal.sh
if [ "$2" != "" ] ; then 
  if [[ "$2" != "BANKIA" ]] && [[ "$2" != "HAYA" ]] && [[ "$2" != "-" ]] ; then
    echo "El segundo parámetro debe ser uno de estos valores: BANKIA, HAYA o -"
    exit 1
  else
    if [[ "$2" == "BANKIA" ]] || [[ "$2" == "HAYA" ]] ; then
    	if [ -f ~/setEnvGlobal${2}.sh ] ; then
  	    export SETENVGLOBAL=~/setEnvGlobal${2}.sh
  	  fi
    fi
  fi
fi

function obtenerSetEnv() {
  export nombreFichero=`basename $1`
  export nombreSinExt=${nombreFichero%%.*}
  export nombreDir=$2
  export nombreSetEnv=$nombreDir/setEnv_${nombreSinExt}.sh
  SETENVGLOBAL=$3

  export AUTOR=`cat $1 | grep ' AUTOR=' | cut -d'=' -f2`
  if [ "$AUTOR" == "" ] ; then
      echo -e "\n*** No está definido el campo AUTOR en el fichero $1. No se puede procesar.\n" > /dev/tty
      exit 1
  fi

  export ARTEFACTO=`cat $1 | grep ' ARTEFACTO=' | cut -d'=' -f2`
  if [ "$ARTEFACTO" == "" ] ; then
      echo -e "\n*** No está definido el campo ARTEFACTO en el fichero $1. No se puede procesar.\n" > /dev/tty
      exit 1
  fi

  export VERSION_ARTEFACTO=`cat $1 | grep ' VERSION_ARTEFACTO=' | cut -d'=' -f2`
  if [ "$VERSION_ARTEFACTO" == "" ] ; then
      echo -e "\n*** No está definido el campo VERSION_ARTEFACTO en el fichero $1. No se puede procesar.\n" > /dev/tty
      exit 1
  fi

  export FECHA_CREACION=`cat $1 | grep ' FECHA_CREACION=' | cut -d'=' -f2`
  if [ "$FECHA_CREACION" == "" ] ; then
      echo -e "\n*** No está definido el campo FECHA_CREACION en el fichero $1. No se puede procesar.\n" > /dev/tty
      exit 1
  fi

  export INCIDENCIA_LINK=`cat $1 | grep ' INCIDENCIA_LINK=' | cut -d'=' -f2`
  if [ "$INCIDENCIA_LINK" == "" ] ; then
      echo -e "\n*** No está definido el campo INCIDENCIA_LINK en el fichero $1. No se puede procesar.\n" > /dev/tty
      exit 1
  fi

  export PRODUCTO=`cat $1 | grep ' PRODUCTO=' | cut -d'=' -f2`
  if [ "$PRODUCTO" == "" ] ; then
      echo -e "\n*** No está definido el campo PRODUCTO en el fichero $1. No se puede procesar.\n" > /dev/tty
      exit 1
  fi

  if [ -f $SETENVGLOBAL ] ; then
      source $SETENVGLOBAL
  else
      export ESQUEMA_EJECUCION=BANK01
      export VARIABLES_SUSTITUCION='#ESQUEMA#;BANK01,#ESQUEMA_MASTER#;BANKMASTER,#ESQUEMA_ENTIDAD#;BANK01,#ESQUEMA_MINIREC#;MINIREC,#ESQUEMA_DWH#;RECOVERY_BANKIA_DWH,#ESQUEMA_DATASTAGE#;RECOVERY_BANKIA_DATASTAGE'
  fi

  echo "#!/bin/bash" > $nombreSetEnv
  echo "export NOMBRE_SCRIPT=$nombreFichero" >> $nombreSetEnv
  echo "export ESQUEMA_EJECUCION=$ESQUEMA_EJECUCION" >> $nombreSetEnv
  echo "export VARIABLES_SUSTITUCION='$VARIABLES_SUSTITUCION'" >> $nombreSetEnv
  echo "export AUTOR='$AUTOR'" >> $nombreSetEnv
  echo "export ARTEFACTO=$ARTEFACTO" >> $nombreSetEnv
  echo "export VERSION_ARTEFACTO=$VERSION_ARTEFACTO" >> $nombreSetEnv
  echo "export FECHA_CREACION=$FECHA_CREACION" >> $nombreSetEnv
  echo "export INCIDENCIA_LINK=$INCIDENCIA_LINK" >> $nombreSetEnv
  echo "export PRODUCTO=$PRODUCTO" >> $nombreSetEnv

}

function isDosFile() {
  [[ $(head -1 "$1") == *$'\r' ]]  
}

function transformaDosFile() {
  if isDosFile $1 ; then
    dos2unix -q $1 
    if [ "$?" != 0 ] ; then
      sed 's/\r$//' "$1" > $1.bak ; mv $1.bak $1
    fi
  fi
}

for d in $( ls )
do
    for f in $d/${TIPO}*.sql $d/**/${TIPO}*.sql $d/**/**/${TIPO}q*.sql
    do
            if [[ $f =~ "master" ]] || [[ $f =~ "BANKMASTER" ]]  || [[ $f =~ "HAYAMASTER" ]] ; then 
				salida BANKMASTER $f $d $PFSRECOVERY $SETENVGLOBAL
            fi
            if [[ $f =~ "entity" ]] || [[ $f =~ "ENTITY" ]] || [[ $f =~ "bank01" ]] || [[ $f =~ "BANK01" ]] || [[ $f =~ "hay01" ]] || [[ $f =~ "HAYA01" ]] ; then
				salida BANK01 $f $d $PFSRECOVERY $SETENVGLOBAL
            fi
            if [[ $f =~ "MINIREC" ]] || [[ $f =~ "minirec" ]] || [[ $f =~ "MINIRECOVERY" ]]; then
				salida MINIREC $f $d $PFSRECOVERY $SETENVGLOBAL
            fi
            if [[ $f =~ "RECOVERY_BANKIA_DWH" ]] || [[ $f =~ "recovery_bankia_dwh" ]]; then 
				salida RECOVERY_BANKIA_DWH $f $PFSRECOVERY $SETENVGLOBAL
            fi
            if [[ $f =~ "RECOVERY_BANKIA_DATASTAGE" ]] || [[ $f =~ "recovery_bankia_datastage" ]]; then 
				salida RECOVERY_BANKIA_DATASTAGE $f $PFSRECOVERY $SETENVGLOBAL
            fi
    done
done

export mascara=""
if [[ $TIPO =~ "DML" ]] ; then 
	mascara="*DML*.log"
fi
if [[ $TIPO =~ "DDL" ]] ; then 
	mascara="*DDL*.log"
fi
if [[ $TIPO =~ "Grant" ]] ; then 
	mascara="*Grant*.log"
fi


echo 'export nombreFicheroLogGlobal=$0-`date +%Y%m%d-%H%M`.log'
echo 'echo -e "\n#################################################"' 
echo 'echo -e "####### FICHEROS LOG RECOPILADOS EN EL FICHERO "$nombreFicheroLogGlobal' 
echo 'echo -e "#################################################\n"' 
echo 'export mascara='$mascara
echo 'for d in $( ls -ld * ) ; do if [ -d $d ] ; then for f in $d/*.log ; do cat $f >> $nombreFicheroLogGlobal ; done ; fi ; done'

echo 'for d in $( ls -ld * ) ; do if [ -d $d ] ; then for f in $d/reg*.sql ; do rm -f $f  ; done ; fi ; done'
echo 'find . -type f -name "`date +%Y`*" -exec rm {} \;'
echo 'find . -type f -name "D*.log" -exec rm {} \;'
echo 'find . -type f -name "D*.sh" -exec rm {} \;'
