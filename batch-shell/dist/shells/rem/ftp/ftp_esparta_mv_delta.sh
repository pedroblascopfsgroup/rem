cd $DIR_INPUT_AUX

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/HayaToPFS
mv DELTA.csv Delta_Procesados/DELTA_$1.csv
bye
EOF
