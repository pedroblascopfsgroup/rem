#!/bin/bash
##############################################################################################
#1.- Se comprueba que los parámetros de ejecución son correctos.
# Criticidad BAJA
##############################################################################################
if [ "$#" -ne 3 ]; then
    echo "[ERROR] Uso del script: Parámetro 1: <REM01/pass@IP:PORT/SID> Parámetro 2: 'USUARIO_MIGRACION' Parámetro 3: 'BLOQUE' (BLOQUE1, BLOQUE2, BLOQUE3 o TODOS)"
    echo "********************************************************************************************************************************************************"
    echo "USUARIO_MIGRACION ---> MIG_SAREB, MIG_CAJAMAR, MIG_BANKIA, MIG_COOPER, MIG_LIBERBANK, MIG_APPLE, MIG_DIVARIAN, [MIG_BBVA]"
    echo "Ejecutar desde: sql/9.3/rem/migracion_bbva/FASE_A/"
    rm -f sqlnet.log
    exit 1
fi
inicio=`date +%s`
export NLS_LANG=SPANISH_SPAIN.UTF8
migracion="$(echo $2 | cut -d '_' -f2)"

##############################################################################################
#2.- Se guardan los logs anteriores en la carpeta "/LOGS/LOGS_ANTERIORES/" y se crea nuevo log en "/LOGS/migracion_completo_FECHA.log"
# Criticidad BAJA
##############################################################################################
mkdir -p LOGS/LOGS_ANTERIORES
mv -f LOGS/*.log LOGS/LOGS_ANTERIORES 2> /dev/null
fecha_log=`date +%Y%m%d_%H%M%S`
bloque=$3
log_completo="LOGS/migracion_"$bloque"_FASEA_"$2"_"$fecha_log".log"

##############################################################################################
#3.- Comienza la FASE_A de la migración
##############################################################################################
hora=`date +%H:%M:%S`
echo " "
echo "#################################################################################"
echo "####### [INICIO] Comienza la migración (FASE_A) de $3 para $migracion: $hora"
echo "#################################################################################"
echo " "

##############################################################################################
######3.1.- Se crean las tablas MIG
##############################################################################################
######[EJECUTABLE] 
######			   "./DDL/mig_lanza_DDL.sh"
######[PROCESO] 
######             Ejecuta todos los scripts que haya en "DDL/*.sql"
######[LOG]
######             Se guarda el log en "/LOGS/001_creacion_tablas_FECHA.log" y en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza la creación de las tablas MIG"
echo "	-------------------------------------------------------------------------------------"
fecha_ini=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=LOGS/001_creacion_tablas_$fecha_ini.log 
log1=LOGS/001_creacion_tablas_$fecha_ini.log 
./DDL/mig_lanza_DDL.sh $1 $3 > $salida
if [ $? != 0 ] ; then 
   error=$(grep -ri "======>>> Error en" $salida)
   echo " "
   echo -e "	[ERROR] ======>>> "Error/es encontrados en la creación de las tablas MIG
   echo " "  
   grep -ri -a "======>>> Error"  $log1 | sed -e s/"@"/""/g | sed -e s/"======>>> "/"\[ERROR\] ======>>> "/g
   grep -ri -a "ORA-" $log1 | sed -e s/"@"/""/g | sed -e s/"ORA-"/"\[ERROR\] ======>>> ORA-"/g
   echo " "
   echo -e "	[LOG] ======>>> $log1"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
   rm -f sqlnet.log
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
numTablasCreadas=`grep -ri -c "Procedimiento PL/SQL terminado correctamente" $log1`
numTablasAUXCreadas=`grep -ri -c "#####    \[INICIO\] Creacion de la tabla DDL/DDL_099" $log1`
let numTablasINTERFAZCreadas=($numTablasCreadas-$numTablasAUXCreadas)
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	[INFO] Tablas MIG creadas en $total segundos."
   echo "	[INFO] $numTablasCreadas tablas creadas"
   echo "		$numTablasINTERFAZCreadas tablas de interfaces (MIG_)"
   echo "		$numTablasAUXCreadas tablas auxiliares"
else
   echo "	[INFO] Tablas MIG creadas en $total minutos."
   echo "	[INFO] $numTablasCreadas tablas creadas"
   echo "		$numTablasINTERFAZCreadas tablas de interfaces (MIG_)"
   echo "		$numTablasAUXCreadas tablas auxiliares"
fi

##############################################################################################
######3.2.- Se descomprimen los .zip de ficheros y se reubican los ficheros.
##############################################################################################
######[EJECUTABLE] 
######			   "./FICHEROS/cambia_nombre_ficheros.sh"
######[PROCESO] 
######             Se descomprimen los .zip de "FICHEROS/*_FaseI_*.zip" y "FICHEROS/*_FaseII_*.zip" en "FICHEROS/"
######             Se borran los ficheros antiguos que haya en "CTLs_DATs/DATs/"     
######             Se reubican los ficheros .dat descomprimidos de "FICHEROS/" a "CTLs_DATs/DATs/" cambiándoles el nombre según el "FICHEROS/renombrado.list"
######             Se borran los ficheors .dat de "FICHEROS/"
######[LOG]     
######             Se guarda el log en "/LOGS/002_despliegue_ficheros_FECHA.log" y en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza el proceso de descompresión y reubicación de ficheros: "
echo "	-------------------------------------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=LOGS/002_despliegue_ficheros_$fecha.log
log2="LOGS/002_despliegue_ficheros_$fecha.log"
./FICHEROS/cambia_nombre_ficheros.sh $salida > $salida 2>/dev/null
if [ $? != 0 ] ; then 
	echo " "
	echo -e "[ERROR] ======>>> "Error/es econtrados en la descompresión y/o reubicación de ficheros
	echo -e "[ERROR] ======>>> "No existen ficheros .zip en la carpeta FICHEROS/ o los .zip no tienen ficheros.
	echo " "
	echo -e "[LOG] ======>>> $log2"
	echo -e "[LOG] ======>>> Log completo: $log_completo"
	echo " "
	rm -f sqlnet.log
	exit 1
fi
numFicherosReubicados=`grep -ri -c "Se reubica el fichero" $log2`
numFicherosDescomprimidos=`grep -ri "Ficheros descomprimidos:" $log2 | sed -e s/"Ficheros descomprimidos:"/""/g` 
if [ $numFicherosReubicados = 0 ] ; then
	echo " "
	echo -e "	[ERROR] ======>>> "Error/es econtrados en la descompresión y/o reubicación de ficheros
	echo -e "	[ERROR] ======>>> "No se ha reubicado ningún fichero. Revise los .zip de ficheros.
	echo " "
	echo -e "	[LOG] ======>>> $log2"
	echo -e "	[LOG] ======>>> Log completo: $log_completo"
	echo " "
	rm -f sqlnet.log
	exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	[INFO] Ficheros reubicados y renombrados en $total segundos."
   echo "	[INFO] $numFicherosDescomprimidos ficheros descomprimidos."
   echo "	[INFO] $numFicherosReubicados ficheros reubicados para ser cargados."
else
   echo "	[INFO] Ficheros reubicados y renombrados en $total minutos."
   echo "	[INFO] $numFicherosDescomprimidos ficheros descomprimidos."
   echo "	[INFO] $numFicherosReubicados ficheros reubicados para ser cargados."
fi
if [ $numFicherosReubicados != $numFicherosDescomprimidos ] ; then
	echo "	[ERROR] Hay ficheros en el .zip que no se han podido reubicar. Es posible que el nombre de algún fichero sea incorrecto."
	echo "	[ERROR] Mirar el fichero FICHEROS/renombrado.list para comprobarlo"
else
	echo "	[INFO] Todos los ficheros del .zip reubicados correctamente."
fi

##############################################################################################
######3.3.- Se rellenan las tablas MIG a partir de los ficheros.
##############################################################################################
######[EJECUTABLE] 
######			   "/CTLs_DATs/mig_lanza_CTL.sh"
######[PROCESO] 
######             Se crea el fichero [/CTLs_DATs/CTLs.list] con todos los .ctl a ejecutar
######             Se borran los .log y .dat de ejecuciones anteriores
######             Se ejecutan los ficheros .ctl para rellenar cada tabla MIG a partir de los ficheros de [/CTLs_DATs/DATs/]
######[LOG]     
######             Se guarda el log en "/LOGS/003_carga_migs_FECHA.log" y en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza el rellenado de las tablas MIG"
echo "	-------------------------------------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=LOGS/003_carga_migs_$fecha.log
log3="LOGS/003_carga_migs_$fecha.log"
./CTLs_DATs/mig_lanza_CTL.sh $1 $salida $3
if [ $? != 0 ] ; then 
   echo -e "	[ERROR] ======>>> "Error/es encontrados en la carga de las tablas MIG
   echo -e "	[ERROR] ======>>> "Error en la ejecución del script /CTLs_DATs/mig_lanza_CTL.sh
   echo " "
   echo -e "	[LOG] ======>>> $log3"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
   rm -f sqlnet.log
   exit 1
fi
cat $salida >> $log_completo
nr_errors_graves=`grep -ro  "Loader-" CTLs_DATs/logs/ | wc -l`
nr_errors_leves=`grep -i -c "======>>> Error en" $salida`
num_ctls_ejecutados=`grep -ri -c "Carga terminada" $log3`
if [ $nr_errors_graves != 0 ] ; then 
   error=$(grep -ri "======>>> Error en" $salida)
   echo " "
   echo -e "	[ERROR] ======>>> "Error/es encontrados en la carga de las tablas MIG
   echo $error | sed -e s/"======>>>"/"\n[ERROR] ======>>>"/g
   echo " "
   grep -ri -a "Loader-" CTLs_DATs/logs/ | sed -e s/":.*:"/": "/g | perl -ne 'print "	[LOG] ======>>> CTLs_DATs/log/$_"'
   echo -e "	[LOG] ======>>> Log de la carga: $log3"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
   rm -f sqlnet.log
   #exit 1
fi
if [ $nr_errors_leves != 0 ] ; then 
   error=$(grep -ri "======>>> Error en" $salida)
   echo " "
   echo -e "	[ERROR] ======>>> "Ficheros con registros rechazados
   echo $error | sed -e s/"======>>>"/"\n	[ERROR] ======>>>"/g | sed -e s/"Error"/"Registros rechazados"/g
   echo " "   
   find  CTLs_DATs/bad/ -type f | sed s/"CTLs_DATs\/bad\/empty"/""/g | sed '/^[[:space:]]*$/d' | perl -ne 'print "	[LOG] ======>>> Revise el fichero de rechazos $_"'
   find  CTLs_DATs/rejects/ -type f | sed s/"CTLs_DATs\/rejects\/empty"/""/g | sed '/^[[:space:]]*$/d' | perl -ne 'print "	[LOG] ======>>> Revise el fichero de rechazos $_"'
   echo -e "	[LOG] ======>>> Log de la carga: $log3"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
fi
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	[INFO] Tablas MIG rellenadas en $total segundos."
   echo "	[INFO] $num_ctls_ejecutados ctls ejecutados."
else
   echo "	[INFO] Tablas MIG rellenadas en $total minutos."
   echo "	[INFO] $num_ctls_ejecutados ctls ejecutados."
fi

##############################################################################################
######3.4.- Se ejecutan los DMLs para rellenar las tablas de validaciones requeridas.
##############################################################################################
######[EJECUTABLE] 
######			   "./DML/mig_lanza_DML.sh"
######[PROCESO]    
######			   Se crea el fichero [/DMLs/DMLs.list] con todos los .sql a ejecutar de la carpeta [DML/]
######             Se ejecutan los ficheros .sql de la carpeta [/DML/]           
######[LOG]     
######             Se guarda el log en "/LOGS/004_carga_validaciones_FECHA.log" y en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza la ejecucion de [DML] de FASE_A"
echo "	-------------------------------------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=LOGS/004_carga_validaciones_$fecha.log
log4="LOGS/004_carga_validaciones_$fecha.log"
./DML/mig_lanza_DML.sh $1 > $salida
if [ $? != 0 ] ; then 
   echo " "
   echo -e "	[ERROR] ======>>> "Error/es encontrados en la carga de las tablas de validación
   echo " "
   grep -ri -a -e "ORA-" -e "-----	"  $log4 | sed -e s/"ORA-.*: "/""/g -e s/"-----	\[INFO\] Ejecutando "/""/g | perl -ne 'print "	[ERROR] ======>>> $_"' | sed -e s/".sql"/".sql\n======================================================="/g 
   echo " "
   echo -e "	[LOG] ======>>> $log4"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
   rm -f sqlnet.log
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	[INFO] DMLs ejecutados en $total segundos."
else
   echo "	[INFO] DMLs ejecutados en $total minutos."
fi

##############################################################################################
######3.4.1- Se ejecutan los DMLs correctores para corregir datos de origen mal recibidos.
##############################################################################################
######[EJECUTABLE] 
######			   "./DML_CORRECTORES/mig_lanza_DML_corrector.sh"
######[PROCESO]    
######			   Se crea el fichero [/DML_CORRECTORES/DMLs.list] con todos los .sql a ejecutar de la carpeta [DML_CORRECTORES/]
######             Se ejecutan los ficheros .sql de la carpeta [/DML_CORRECTORES/]           
######[LOG]     
######             Se guarda el log en "/LOGS/0041_carga_correctores_FECHA.log" y en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza la ejecucion de [DML_CORRECTORES] de FASE_A"
echo "	-------------------------------------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=LOGS/0041_carga_correctores_$fecha.log
log41="LOGS/0041_carga_correctores_$fecha.log"
./DML_CORRECTORES/mig_lanza_DML_corrector.sh $1 $2 > $salida
if [ $? != 0 ] ; then 
   echo " "
   echo -e "	[ERROR] ======>>> "Error/es encontrados en la ejecucion de scripts correctores
   echo " "
   grep -ri -a -e "ORA-" -e "-----	"  $log41 | sed -e s/"ORA-.*: "/""/g -e s/"-----	\[INFO\] Ejecutando "/""/g | perl -ne 'print "	[ERROR] ======>>> $_"' | sed -e s/".sql"/".sql\n======================================================="/g 
   echo " "
   echo -e "	[LOG] ======>>> $log41"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
   rm -f sqlnet.log
   exit 1
fi
cat $salida >> $log_completo
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   grep -ri -a -e "INFO_MIGRA" $log41 | sed -e s/"\["/"	\["/g
   echo "	[INFO] Scripts correctores ejecutados en $total segundos."
else
   echo "	[INFO] Scripts correctores ejecutados en $total minutos."
fi

##############################################################################################
######3.5.- Se compilan los SPs de las validaciones.
##############################################################################################
######[EJECUTABLE] 
######			   "./SP/compila_SP.sh"
######[PROCESO]    
###### 			   Se crea el fichero [/SP/SPs.list] con todos los SPs a compilar.
######             Se compilan todos los SPs de la carpeta [/SP/]
######[LOG]     
######             Se guarda el log en "/LOGS/005_compila_procedimientos_almacenados_FECHA.log" y en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza el compilando de procesos almacenados de las validaciones (SPs)"
echo "	-------------------------------------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=LOGS/005_compila_procedimientos_almacenados_$fecha.log
log5="LOGS/005_compila_procedimientos_almacenados_$fecha.log"
./SP/compila_SP.sh $1 $fecha >> $salida
if [ $? != 0 ] ; then 
   echo " "
   echo -e "	[ERROR] ======>>> "Error compilando SPs de validaciones
   echo -e "	[ERROR] ======>>> $log5"
   echo " "
   rm -f sqlnet.log
   exit 1
fi
cat $salida >> $log_completo
nr_errors=`grep -i -c "Procedimiento creado con errores de compilaci" $salida`
if [ $nr_errors != 0 ] ; then   
   echo " "
   echo -e "	[ERROR] ======>>> "Error/es encontrados en la compilación de los SPs de validaciones
   grep -ri -a "======>>> Error"  $log5 | sed -e s/"======>>> Error en @"/"	[ERROR] ======>>> Error de compilado en el "/g
   echo " "
   echo -e "	[LOG] ======>>> $log5"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
   rm -f sqlnet.log
   exit 1
fi
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	[INFO] SPs de validaciones compilados en $total segundos."
else
   echo "	[INFO] SPs de validaciones compilados en $total minutos."
fi

##############################################################################################
######3.6- Se ejecutan los SPs para validar.
##############################################################################################
######[EJECUTABLE] 
######			   "./SP/lanza_SP.sh"
######[PROCESO]    
###### 			   Se crea el fichero [/SP/SPs_lanza.list] con todos los SPs a ejecutar.
######             Se ejecutan todos los SPs de la carpeta [/SP/] que realizan las diferentes validaciones.
######[LOG]     
######             Se guarda el log en "/LOGS/006_ejecuta_procedimientos_almacenado_FECHA.log" y en "/LOGS/migracion_completo_FECHA.log"
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Comienza la ejecución de las validaciones (SPs)"
echo "	-------------------------------------------------------------------------------------"
fecha=`date +%Y%m%d_%H%M%S`
inicioparte=`date +%s`
salida=LOGS/006_ejecuta_procedimientos_almacenados_$fecha.log
log6="LOGS/006_ejecuta_procedimientos_almacenados_$fecha.log"
./SP/lanza_SP.sh $1 $fecha $salida
if [ $? != 0 ] ; then 
   echo " "
   echo -e "	[ERROR] ======>>> "Error ejecutando SPs de validaciones
   echo -e "	[ERROR] ======>>> $log6"
   echo " "
   rm -f sqlnet.log
   exit 1
fi
cat $salida >> $log_completo
nr_errors=`grep -i -c ^ORA-.....: $salida`
if [ $nr_errors != 0 ] ; then 
   echo " "
   echo -e "	[ERROR] ======>>> "Error/es encontrados en la ejecución de los SPs de validaciones
   grep -ri -a "======>>> Error"  $log6 | sed -e s/"======>>> Error en @"/"	[ERROR] ======>>> Error de ejecución en el "/g
   echo " "
   echo -e "	[LOG] ======>>> $log6"
   echo -e "	[LOG] ======>>> Log completo: $log_completo"
   echo " "
   rm -f sqlnet.log
   exit 1	
fi
fin=`date +%s`
let total=($fin-$inicioparte)/60
if [ $total = 0 ] ; then
   let total=($fin-$inicioparte)
   echo "	[INFO] SPs de validaciones ejecutados en $total segundos."
   echo "	[INFO] Revise los resultados de las validaciones en la tabla: VALIDACIONES_RESULTADOS"
   echo "   [INFO] Ejecute la siguiente query para sacar un resumen de los errores: select nombre_interfaz, motivo_rechazo, count(1) from validaciones_resultados group by nombre_interfaz, motivo_rechazo order by 3 desc; ó select nombre_interfaz, campo_clave_dato, clave_dato, motivo_rechazo, fecha_validado from validaciones_resultados order by motivo_rechazo, clave_dato desc;"
   echo " "
   echo " "
   echo " [INFO] Lanza la siguiente query para sacar los Proveedores informados en las Comisiones (GEX) que no existen en la Interfaz ni en REM por PVE_COD_ORIGEN: 
                     SELECT NI.GEX_COD_PROVEEDOR
                      FROM REM01.MIG2_GEX_GASTOS_EXPEDIENTE NI
                      JOIN REM01.VALIDACIONES_TIPOS DR ON DR.CODIGO_RECHAZO = '2'
                      LEFT JOIN MIG2_PVE_PROVEEDORES DD ON NI.GEX_COD_PROVEEDOR = DD.PVE_COD_ORIGEN AND DD.BORRADO = 0
                      LEFT JOIN ACT_PVE_PROVEEDOR DDREM ON NI.GEX_COD_PROVEEDOR = DDREM.PVE_COD_ORIGEN AND DDREM.BORRADO = 0
                      WHERE (DD.PVE_COD_ORIGEN IS NULL AND NI.GEX_COD_PROVEEDOR IS NOT NULL)
                      AND (DDREM.PVE_COD_ORIGEN IS NULL AND NI.GEX_COD_PROVEEDOR IS NOT NULL);"
else
   echo "	[INFO] SPs de validaciones ejecutados en $total minutos."
   echo "	[INFO] Revise los resultados de las validaciones en la tabla: VALIDACIONES_RESULTADOS"
   echo "   [INFO] Ejecute la siguiente query para sacar un resumen de los errores: select nombre_interfaz, motivo_rechazo, count(1) from validaciones_resultados group by nombre_interfaz, motivo_rechazo order by 3 desc; ó select nombre_interfaz, campo_clave_dato, clave_dato, motivo_rechazo, fecha_validado from validaciones_resultados order by motivo_rechazo, clave_dato desc;"
   echo " "
   echo " "
   echo " [INFO] Lanza la siguiente query para sacar los Proveedores informados en las Comisiones (GEX) que no existen en la Interfaz ni en REM por PVE_COD_ORIGEN: 
                     SELECT NI.GEX_COD_PROVEEDOR
                      FROM REM01.MIG2_GEX_GASTOS_EXPEDIENTE NI
                      JOIN REM01.VALIDACIONES_TIPOS DR ON DR.CODIGO_RECHAZO = '2'
                      LEFT JOIN MIG2_PVE_PROVEEDORES DD ON NI.GEX_COD_PROVEEDOR = DD.PVE_COD_ORIGEN AND DD.BORRADO = 0
                      LEFT JOIN ACT_PVE_PROVEEDOR DDREM ON NI.GEX_COD_PROVEEDOR = DDREM.PVE_COD_ORIGEN AND DDREM.BORRADO = 0
                      WHERE (DD.PVE_COD_ORIGEN IS NULL AND NI.GEX_COD_PROVEEDOR IS NOT NULL)
                      AND (DDREM.PVE_COD_ORIGEN IS NULL AND NI.GEX_COD_PROVEEDOR IS NOT NULL);"
fi

############################################################################################## -----> Lanzar cuando se suba a producción
##echo " "
##echo "	-------------------------------------------------------"
##echo "	------ [INFO] Copiando tablas de migración y validación funcional"
##echo "	-------------------------------------------------------"
##fecha_ini=`date +%Y%m%d_%H%M%S`
##inicioparte=`date +%s`
##salida=Logs/007_copiando_tablas_$fecha_ini.log 
##./POST_FASEA/mig_lanza_DDL.sh $1 $2 > $salida
##if [ $? != 0 ] ; then 
   ##echo -e "\n\n======>>> "Error creando tablas
   ##exit 1
##fi
##cat $salida >> $log_completo
##fin=`date +%s`
##let total=($fin-$inicioparte)/60
##if [ $total = 0 ] ; then
   ##let total=($fin-$inicioparte)
   ##echo "	Tablas copiadas en $total segundos."
##else
   ##echo "	Tablas copiadas en $total minutos."
##fi

##############################################################################################
#4.-Finaliza la FASE_A de la migración
##############################################################################################
echo " "
echo "	-------------------------------------------------------------------------------------"
echo "	------ [INFO] [`date +%H:%M:%S`] Revise los logs:"
echo "	-------------------------------------------------------------------------------------"
echo "	Log completo:"
echo "		$log_completo"
echo "	Logs por partes:"
echo "		$log1"
echo "		$log2"
echo "		$log3"
echo "		$log4"
echo "		$log41"
echo "		$log5"
echo "		$log6"
fin=`date +%s`
let total=($fin-$inicio)/60
rm -f sqlnet.log
echo " "
echo "#########################################################################"
echo "####### [FIN] Migración Fase A completada en [$total] minutos"
echo "#########################################################################"
echo " "
exit 0
