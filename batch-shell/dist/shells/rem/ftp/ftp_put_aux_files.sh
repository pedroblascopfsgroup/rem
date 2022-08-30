lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es; ls /Archivos/REM/HayaToPFS/$1"

lftp -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es <<EOF
cd /Archivos/REM/HayaToPFS/$1
mput $DIR_SALIDA/$1*$2.*
bye
EOF
