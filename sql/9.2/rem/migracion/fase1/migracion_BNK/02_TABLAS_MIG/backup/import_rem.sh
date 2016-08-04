if [ "$#" -ne "2" ] ; then
   #echo "Uso: $0 <nombre_fichero_dump>"
   echo "Uso: $0 <nombre_fichero_dump> <contrasenya_system>"
   exit 1
fi

export FECHA=$1
export ENTIDAD=REM01
export MASTER=REMMASTER
export DIR_DUMP=/backup
export pw=$2

export NLS_LANG=SPANISH_SPAIN.AL32UTF8

echo "***Import del usuario $MASTER `date`"
echo "***Comando: impdp system/$pw schemas=$MASTER,$ENTIDAD dumpfile=BACKUP_DIR:${1} logfile=BACKUP_DIR:${1}.log"
impdp system/$pw schemas=$MASTER,$ENTIDAD dumpfile=BACKUP_DIR:${1} logfile=BACKUP_DIR:${1}.log

echo "***FIN DE LA IMPORTACION DE $ENTIDAD y $MASTER DE FECHA $FECHA `date`"

