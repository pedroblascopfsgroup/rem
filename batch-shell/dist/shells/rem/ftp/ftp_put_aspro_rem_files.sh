
lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7; ls /Archivos/REM/PFStoHaya/$1"
if [ $? -ne 0 ]; then
   lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7; mkdir /Archivos/REM/PFStoHaya/$1"
fi


lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7; ls /Archivos/REM/PFStoHaya/$1"

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/PFStoHaya/$1
mput $DIR_SALIDA*$2.*
bye
EOF
