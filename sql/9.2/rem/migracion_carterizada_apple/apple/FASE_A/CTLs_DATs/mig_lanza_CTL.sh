#!/bin/bash
##Comprobamos que el número de parámetros en correcto.
if [ "$#" -ne 2 ] ; then
    echo "Uso $0 <REM01/pass@IP:PORT/SID> "  >> $2
    exit 1
fi

##Comprobamos que las variables globales necesarias se encuentran informadas.
if [ "$ORACLE_HOME" == "" ] ; then
	echo "No se ha encontrado el valor de ORACLE_HOME=$ORACLE_HOME" >> $2
fi
if [ "$ORACLE_SID" == "" ] ; then      
	echo "No se ha encontrado el valor de ORACLE_SID=$ORACLE_SID" >> $2
fi
export NLS_LANG=SPANISH_SPAIN.WE8ISO8859P1

##Comienza el proceso
echo "[INICIO] Comienza el proceso" >> $2
echo "--------------------------------------------------------------------"  >> $2

##Rutas y variables necesarias. Se crea el CTLs.list
echo "[INFO] Creando fichero lista de CTLs [CTLs.list]..."  >> $2
ruta="CTLs_DATs/"
fichero="CTLs.list"
ls --format=single-column $ruta*.ctl | sed 's/CTLs_DATs\///g' | sed 's/.ctl//g' > $ruta$fichero
if [ ! -f "$ruta""$fichero" ] ; then
	echo "No existe lista de ficheros CTL"  >> $2
	exit 1
fi

##Se borran los *.log y *.bad que haya de antes.
echo "[INFO] Borrando *.bad y *.log de ejecuciones anteriores en la carpeta [CTLs_DATs]..."  >> $2
rm -f "$ruta"logs/*.log
rm -f "$ruta"rejects/*.bad
rm -f "$ruta"bad/*.bad

##Se cargan las tablas MIG con los ficheros
echo "[INFO] Rellenando las tablas MIG a partir de los ficheros .dat de la carpeta [CTLs_DATs/DATs/]"  >> $2
while read line
do
	if [ -f $ruta$line.ctl ] ; then
		if [ -s $ruta"DATs/"$line.* ] ; then
			echo "--------------------------------------------------------------------------------------------"  >> $2
			echo "-----	[INFO] "$line.ctl  >> $2
			echo "--------------------------------------------------------------------------------------------"  >> $2
			echo "	[INFO] Ejecutando el "$line
			inicioctl=`date +%s`
			$ORACLE_HOME/bin/sqlldr $1 control=./$ruta$line.ctl log=./$ruta"logs/"$line.log  >> $2 2> /dev/null
			if [ $? != 0 ] ; then 
			   echo -e "\n\n======>>> "Error en @"$line"  >> $2
			   #exit 1
			fi
			finctl=`date +%s`
			let total=($finctl-$inicioctl)
			grep -ri -a 'Total de registro\|\Tabla' ./$ruta"logs/"$line.log | grep -a -v 'cargada\|\activa\|\omitidos\|\desechados' | sed 's/\://g' | tr -s ' ' | sed -e 's/Total.*//' | sed 's/rechazados/[RECHAZADOS] /g' | sed 's/Tabla/[TABLA] /g' | sed 's/dos/[REGISTROS] /g' | sed -e 's/.*\[/\[/' | tr -s ' ' | sed 's/\[/ \[/g' | grep -a '\[.*' | sed 's/gicos le//g' | cut -d ' ' -f2- | sed 's/\[/		\[/g'
			grep -ri -a "\;"$line"\.dat" "FICHEROS/renombrado.list" |  sed -e 's/\;.*//' | sed 's/Fich/		[FICHERO] Fich/g'
			echo "		[TIEMPO] $total segundos"
			echo "Fin $line"  >> $2
			echo ""  >> $2
		fi
	fi
done < $ruta$fichero

##[FIN] Fin del proceso
echo "[FIN] Acaba la carga de ficheros en Tablas MIG correctamente."  >> $2
exit 0
