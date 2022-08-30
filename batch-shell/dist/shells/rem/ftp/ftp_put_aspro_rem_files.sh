
lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es; ls /Archivos/REM/PFStoHaya/$1"
if [ $? -ne 0 ]; then
   lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es; mkdir /Archivos/REM/PFStoHaya/$1"
fi


lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es; ls /Archivos/REM/PFStoHaya/$1"

lftp -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es <<EOF
cd /Archivos/REM/PFStoHaya/$1
mput $DIR_SALIDA*$2.*
bye
EOF
