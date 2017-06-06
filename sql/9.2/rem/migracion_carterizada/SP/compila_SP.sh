#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <pass@host:puerto/ORACLE_SID>"
    exit
fi

fichero="SP/SPs.list"
echo "INICIO DEL SCRIPT $0"

while read line
do
	if [ -f SP/$line.sql ] ; then
		echo "########################################################"
		echo "#####    INICIO" $line
		echo "########################################################"
		$ORACLE_HOME/bin/sqlplus $1 @"SP/""$line".sql > Logs/compile_$line.log

		if [ $? != 0 ] ; then 
		   	echo -e "\n\n======>>> "Error en @$line
		   	exit 1
		else
			echo Fin $line
			echo
		fi
	fi
done < "$fichero"

#if [ -f SP/SP_VALIDACION_DICCIONARIOS.sql ] ; then	
#	echo "########################################################"	
#	echo "#####    INICIO" SP_VALIDACION_DICCIONARIOS	
#	echo "########################################################"	
#	$ORACLE_HOME/bin/sqlplus $1 @SP/SP_VALIDACION_DICCIONARIOS.sql > Logs/compile_SP_VALIDACION_DICCIONARIOS.log
#	if [ $? != 0 ] ; then 
#	   	echo -e "\n\n======>>> "Error en @SP_VALIDACION_DICCIONARIOS
#	   	exit 1
#	else
#		echo Fin SP_VALIDACION_DICCIONARIOS
#		echo
#	fi
#fi
#
#if [ -f SP/SP_VALIDACION_DUPLICADOS.sql ] ; then	
#	echo "########################################################"	
#	echo "#####    INICIO" SP_VALIDACION_DUPLICADOS	
#	echo "########################################################"	
#	$ORACLE_HOME/bin/sqlplus $1 @SP/SP_VALIDACION_DUPLICADOS.sql > Logs/compile_SP_VALIDACION_DUPLICADOS.log
#	if [ $? != 0 ] ; then 
#	   	echo -e "\n\n======>>> "Error en @SP_VALIDACION_DUPLICADOS
#	   	exit 1
#	else
#		echo Fin SP_VALIDACION_DUPLICADOS
#		echo
#	fi
#fi
#
#if [ -f SP/SP_VALIDACION_FUNCIONALES.sql ] ; then	
#	echo "########################################################"	
#	echo "#####    INICIO" SP_VALIDACION_FUNCIONALES	
#	echo "########################################################"	
#	$ORACLE_HOME/bin/sqlplus $1 @SP/SP_VALIDACION_FUNCIONALES.sql > Logs/compile_SP_VALIDACION_FUNCIONALES.log
#	if [ $? != 0 ] ; then 
#	   	echo -e "\n\n======>>> "Error en @SP_VALIDACION_FUNCIONALES
#	   	exit 1
#	else
#		echo Fin SP_VALIDACION_FUNCIONALES
#		echo
#	fi
#fi
#
#if [ -f SP/SP_VALIDACION_DEPENDENCIAS.sql ] ; then	
#	echo "########################################################"	
#	echo "#####    INICIO" SP_VALIDACION_DEPENDENCIAS	
#	echo "########################################################"	
#	$ORACLE_HOME/bin/sqlplus $1 @SP/SP_VALIDACION_DEPENDENCIAS.sql > Logs/compile_SP_VALIDACION_DEPENDENCIAS.log
#	if [ $? != 0 ] ; then 
#	   	echo -e "\n\n======>>> "Error en @SP_VALIDACION_DEPENDENCIAS
#	   	exit 1
#	else
#		echo Fin SP_VALIDACION_DEPENDENCIAS
#		echo
#	fi
#fi

exit 0
