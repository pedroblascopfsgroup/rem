#!/bin/bash

echo "Desactivada la generación automática de shells, porque ya hay unos cuantos que se han editado manualmente."
exit 1

LIST=list-all-shells.txt

TIPO_WAIT=wait
TIPO_ETL=etl
TIPO_JMX=jmx
TIPO_ESP1=esp1
TIPO_ESP2=esp2
TIPO_ESP3=esp3

DEST_DIR=../../dist/shells/
ENTIDAD=2038
DIR_INPUT=/datos/usuarios/recovecb/transferencia/aprov_troncal/
DIR_BASE_ETL=/aplicaciones/recovecb/programas/etl
#DIR_BASE_ETL=/home/pedro/DocumentosPedro/arquitectura-bankia/dca/etls/project
MAX_WAITING_MINUTES=10

rm $DEST_DIR*

for linea in $(cat $LIST); do
    ########################################################
    #### SEPARAR LOS ELEMENTOS DE CADA LINEA
    ########################################################
	echo '---------'
	comando=`echo $linea | awk -F ";" '{print $1}'`
    echo 'Comando:' $comando 
	tipo=`echo $linea | awk -F ";" '{print $2}'`
    echo 'Tipo:' $tipo 
	launchJob=`echo $linea | awk -F ";" '{print $3}'`
    echo 'Launch Job:' $launchJob 
	waitForJobs=`echo $linea | awk -F ";" '{print $4}'`
    echo 'Wait for Jobs:' $waitForJobs 
	waitForFiles=`echo $linea | awk -F ";" '{print $5}'`
    echo 'Wait for Files:' $waitForFiles
	horaLimite=`echo $linea | awk -F ";" '{print $6}'`
    echo 'Hora Limite:' $horaLimite 

    ########################################################
    #### VALIDACIONES SEGUN LOS TIPOS
    ########################################################
    if [ "$tipo" = "$TIPO_WAIT" -a -z "$waitForFiles" ]
	then
		echo "Error en la línea $linea. Proceso de tipo $tipo: faltan las máscaras de ficheros esperados."
		exit 1
	fi
    if [ "$tipo" = "$TIPO_JMX" -a  \( -z "$launchJob" -o -z "$waitForJobs" \) ]
	then
		echo "Error en la línea $linea. Proceso de tipo $tipo: falta el job de lanzamiento o los jobs esperados."
		exit 1
	fi
    if [ "$tipo" = "$TIPO_ESP1" -a  \( -z "$waitForFiles" -o -z "$waitForJobs" \) ]
	then
		echo "Error en la línea $linea. Proceso de tipo $tipo: faltan las máscaras de ficheros esperados o los jobs esperados."
		exit 1
	fi
    if [ "$tipo" = "$TIPO_ESP2" -a -z "$horaLimite" ]
	then
		echo "Error en la línea $linea. Proceso de tipo $tipo: falta la hora limite."
		exit 1
	fi
    if [ "$tipo" = "$TIPO_ESP3" -a -z "$waitForJobs" ]
	then
		echo "Error en la línea $linea. Proceso de tipo $tipo: faltan los jobs esperados."
		exit 1
	fi
    if [ "$tipo" != "$TIPO_WAIT" -a "$tipo" != "$TIPO_ETL" -a "$tipo" != "$TIPO_JMX" -a "$tipo" != "$TIPO_ESP1" -a "$tipo" != "$TIPO_ESP2"  -a "$tipo" != "$TIPO_ESP3" ]
	then
		echo "Error en la línea $linea. Proceso de tipo $tipo: no es ninguno de los tipos válidos ($TIPO_WAIT, $TIPO_ETL, $TIPO_JMX, $TIPO_ESP1, $TIPO_ESP2, $TIPO_ESP3)."
		exit 1
	fi
	
    shellFile="$DEST_DIR$comando"
    templateFile="${tipo}-template"

    ########################################################
    #### CREACION DE LA CABECERA COMUN DE TODOS LOS SHELL
    ########################################################
	echo '#!/bin/bash' > $shellFile
	echo "# Generado automaticamente a las `date`" >> $shellFile
	echo " " >> $shellFile >> $shellFile

    ########################################################
    #### DECLARACIONES PARTICULARES DEL SHELL DE TIPO ESPERA
    ########################################################
    if [ "$tipo" = "$TIPO_WAIT" ] ; then
		echo "ENTIDAD=$ENTIDAD" >> $shellFile
		echo "DIR_INPUT=$DIR_INPUT" >> $shellFile
		echo "MAX_WAITING_MINUTES=$MAX_WAITING_MINUTES" >> $shellFile
		echo "ficheros=$waitForFiles" >> $shellFile
	fi

    ########################################################
    #### DECLARACIONES PARTICULARES DEL SHELL DE TIPO ETL
    ########################################################
    if [ "$tipo" = "$TIPO_ETL" ] ; then
		echo "DIR_BASE_ETL=$DIR_BASE_ETL" >> $shellFile
	fi

    ########################################################
    #### DECLARACIONES PARTICULARES DEL SHELL DE TIPO JMX
    ########################################################
    if [ "$tipo" = "$TIPO_JMX" ] ; then
		echo "LAUNCH_JOB=$launchJob" >> $shellFile
		echo "ENTIDAD=$ENTIDAD" >> $shellFile
		echo "WAIT_FOR_JOBS=$waitForJobs" >> $shellFile
	fi

    ########################################################
    #### DECLARACIONES PARTICULARES DEL SHELL DE TIPO ESP1
    ########################################################
    if [ "$tipo" = "$TIPO_ESP1" ] ; then
		echo "ENTIDAD=$ENTIDAD" >> $shellFile
		echo "CARPETA=`echo $waitForFiles | tr [:upper:] [:lower:]`" >> $shellFile
		echo 'DIR_DESTINO=/$DEVON_HOME/tmp/pfs/$ENTIDAD/$CARPETA/' >> $shellFile
		echo "DIR_INPUT=$DIR_INPUT" >> $shellFile
		echo "MAX_WAITING_MINUTES=$MAX_WAITING_MINUTES" >> $shellFile
		echo "ficheros=$waitForFiles" >> $shellFile
		echo "WAIT_FOR_JOBS=$waitForJobs" >> $shellFile
	fi

    ########################################################
    #### DECLARACIONES PARTICULARES DEL SHELL DE TIPO ESP2
    ########################################################
    if [ "$tipo" = "$TIPO_ESP2" ] ; then
		echo "HORA_LIMITE=$horaLimite" >> $shellFile
		echo "DIR_BASE_ETL=$DIR_BASE_ETL" >> $shellFile
	fi

    ########################################################
    #### DECLARACIONES PARTICULARES DEL SHELL DE TIPO ESP3
    ########################################################
    if [ "$tipo" = "$TIPO_ESP3" ] ; then
		echo "ENTIDAD=$ENTIDAD" >> $shellFile
		echo "WAIT_FOR_JOBS=$waitForJobs" >> $shellFile
	fi

    ########################################################
    #### COPIA DE LA PLANTILLA Y RESTO DE ACCIONES COMUNES
    ########################################################
	cat $templateFile >> $shellFile
	chmod +x $shellFile
	echo "Generado correctamente el shell $shellFile"

done

exit 0

