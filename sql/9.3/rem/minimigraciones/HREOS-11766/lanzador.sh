#!/bin/bash

#$ORACLE_HOME/bin/sqlplus REM01/admin@192.168.31.33:1521/ibd031 @DDL_AUX_TIPO_SUBTIPO_DBE.sql

#$ORACLE_HOME/bin/sqlldr REM01/admin@192.168.49.30:1524/mbd014 control=./retail_singular.ctl log=./LOGS/retailsingular.log

#Desarrollo -> REM01/admin@192.168.31.33:1521/ibd031

#Formación -> REM01/admin@192.168.49.30:1524/mbd014


#CONEXION
#con=REM01/admin@192.168.31.33:1521/ibd031
#con=REM01/admin@192.168.49.30:1524/mbd014
con=$1


inicio=`date +%s`
hora=`date +%H:%M:%S`
fecha_ini=`date +%Y%m%d_%H%M%S`

#####################################################################################
############################    HREOS     ###########################################
#####################################################################################

echo "##############################################################################"
echo "####### [INICIO] Comienza la carga: $hora"
echo "##############################################################################"
echo ""
echo ""






echo "##############################################################################"
echo "####### [INFO] CARGA DE DDLs"
echo "##############################################################################"
echo ""
echo ""

fichero="./LISTS/DDLs.list"
ls --format=single-column DDL/DDL_*.sql > $fichero



echo "INICIO DEL SCRIPT $0"
echo "Se lanza contra $con"
echo ""
echo ""

while read line
do
	if [ -f "$line" ] ; then
		echo "########################################################################"
		echo "#####    CREANDO $line"
		echo "########################################################################"
		echo ""
		base_name="${line##*/}"
		$ORACLE_HOME/bin/sqlplus "$con" @"$line" > LOGS/DDL/DDL_$base_name.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
		mv "$line" DDL/YE
		
		echo "Fin $line"
		echo ""
		echo ""
	fi
done < "$fichero"



#####################################################################################

echo "##############################################################################"
echo "####### [INFO] CARGA DE CTLs"
echo "##############################################################################"
echo ""
echo ""

fichero="./LISTS/CTLs.list"
ls --format=single-column ./CTL/*.ctl > $fichero

while read line
do
	if [ -f "$line" ] ; then
		echo "########################################################################"
		echo "#####    CREANDO $line"
		echo "########################################################################"
		echo ""
		base_name="${line##*/}"
		$ORACLE_HOME/bin/sqlldr "$con" control= $line log=./LOGS/CTL/CTL_$base_name.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   #exit 1
		fi
		mv "$line" CTL/YE
		
		echo "Fin $line"
		echo ""
		echo ""
	fi
done < "$fichero"


#####################################################################################


echo ""
echo ""
echo "##############################################################################"
echo "####### [INFO] CARGA DE DML"
echo "##############################################################################"
echo ""
echo ""

fichero="./LISTS/DMLs.list"
ls --format=single-column DML/DML_*.sql > $fichero

while read line
do
	if [ -f "$line" ] ; then
		echo "########################################################################"
		echo "#####    MERGE $line"
		echo "########################################################################"
		echo ""
		base_name="${line##*/}"
		$ORACLE_HOME/bin/sqlplus "$con" @"$line" > LOGS/DML/DML_$base_name.log
		if [ $? != 0 ] ; then 
		   echo -e "\n\n======>>> "Error en @"$line"
		   exit 1
		fi
		mv "$line" DML/YE
		
		echo "Fin $line"
		echo ""
		echo ""
	fi
done < "$fichero"


echo ""
echo ""
echo "##############################################################################"
echo "####### [INFO] FIN LANZADOR"
echo "##############################################################################"
echo ""
echo ""

mv DDL/YE/*.sql ./DDL

echo "DDL's restaurados"

mv CTL/YE/*.ctl ./CTL

echo "CTL restaurados"

mv DML/YE/*.sql ./DML

echo "DML's restaurados"


exit 0
