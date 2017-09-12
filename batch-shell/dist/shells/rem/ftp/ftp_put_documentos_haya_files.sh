echo "Inicio del proceso de volcado de los ficheros de documentos para Haya"

cd $DIR_SALIDA
echo "Documentos Haya - DOCUMENTOS_RH_${1}.dat"
lftp -u gestorias_rem,YugX0Gmt sftp://192.168.49.14 <<EOF
cd /home/input
mput $DIR_SALIDA/DOCUMENTOS_RH_${1}.dat
bye
EOF
echo "Fichero movido satisfactoriamente"

