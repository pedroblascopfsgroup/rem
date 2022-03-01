cd $DIR_INPUT_AUX
rm -f DatosDQ.csv

lftp -u usr_calidad_rem,b39b48b464 sftp://intercambio2.haya.es <<EOF
cd /Archivos
mget DatosDQ.csv
bye
EOF
