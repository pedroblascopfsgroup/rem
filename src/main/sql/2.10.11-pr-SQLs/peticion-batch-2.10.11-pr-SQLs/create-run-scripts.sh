#!/bin/bash

echo '#!/bin/bash'
echo 'if [ "$ORACLE_HOME" == "" ] ; then'
echo '    echo "Debe ejecutar este shell desde un usuario que tenga permisos de ejecución de Oracle. Este usuario tiene ORACLE_HOME vacío"'
echo '    exit'
echo 'fi'

echo 'if [ "$#" -ne 5 ]; then'
echo '    echo "Parametros: bankmaster_pass@sid bank01_pass@sid minirec_pass@sid recovery_bankia_dwh@sid recovery_bankia_datastage_pass@sid"'
echo '    exit'
echo 'fi'
echo 'export NLS_LANG=.AL32UTF8'

echo 'echo "INICIO DEL SCRIPT DE ACTUALIZACION $0"'

function salida () {
	esquema=$1
	f=$2
	directorio=$3

	nombreFicheroSinDir=`basename $f`
	nombreSinDirSinExt=${nombreFicheroSinDir%%.*}

	nombreSinExt=${f%%.*}
	nombreFicheroLog=${nombreSinDirSinExt}.log

	if [ $esquema == "BANKMASTER" ] ; then pass_sid='1' ; fi
	if [ $esquema == "BANK01" ] ; then pass_sid='2' ; fi
	if [ $esquema == "MINIREC" ] ; then pass_sid='3' ; fi
	if [ $esquema == "RECOVERY_BANKIA_DWH" ] ; then pass_sid='4' ; fi
	if [ $esquema == "RECOVERY_BANKIA_DATASTAGE" ] ; then pass_sid='5' ; fi


	echo 'cp registro_sqls.sh '$nombreSinExt.sh
	echo 'cp *ESQUEMA*.sql '$directorio
	echo 'cd '$directorio
	echo 'echo "########################################################"' ' >> '$nombreFicheroLog
	echo 'echo "#####    INICIO' "$f" '('$esquema')"' ' >> '$nombreFicheroLog
	echo 'echo "########################################################"' ' >> '$nombreFicheroLog
	echo './'$nombreSinDirSinExt'.sh $'$pass_sid '  >> '$nombreFicheroLog
	echo 'if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en '"@$f"' >> '$nombreFicheroLog ' ; fi'
	echo 'echo "########################################################"' ' >> '$nombreFicheroLog
        echo 'cd '..
}


for d in $( ls )
do
    for f in $d/$1*.sql $d/**/$1*.sql $d/**/**/$1*.sql
    do
            if [[ $f =~ "master" ]] || [[ $f =~ "BANKMASTER" ]]; then 
				salida BANKMASTER $f $d
            fi
            if [[ $f =~ "entity" ]] || [[ $f =~ "ENTITY" ]] || [[ $f =~ "bank01" ]] || [[ $f =~ "BANK01" ]]; then
				salida BANK01 $f $d
            fi
            if [[ $f =~ "MINIREC" ]] || [[ $f =~ "minirec" ]] || [[ $f =~ "MINIRECOVERY" ]]; then
				salida MINIREC $f $d
            fi
            if [[ $f =~ "RECOVERY_BANKIA_DWH" ]] || [[ $f =~ "recovery_bankia_dwh" ]]; then 
				salida RECOVERY_BANKIA_DWH $f $d
            fi
            if [[ $f =~ "RECOVERY_BANKIA_DATASTAGE" ]] || [[ $f =~ "recovery_bankia_datastage" ]]; then 
				salida RECOVERY_BANKIA_DATASTAGE $f $d
            fi
    done
done

export mascara=""
if [[ $1 =~ "DML" ]] ; then 
	mascara="*DML*.log"
fi
if [[ $1 =~ "DDL" ]] ; then 
	mascara="*DDL*.log"
fi
if [[ $1 =~ "Grant" ]] ; then 
	mascara="*Grant*.log"
fi

export fileLogs=""
for d in $( ls -d */ ) ; do fileLogs="${fileLogs} ${d}${mascara}" ; done

echo 'echo "########################################################"'
echo 'echo "####### FICHEROS LOG COMPRIMIDOS EN EL FICHERO "$0.zip' 
echo 'echo "########################################################"'
echo 'zip -r -q $0.zip '$mascara $fileLogs

