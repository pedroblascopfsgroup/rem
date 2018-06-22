lftp -c "open -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7; ls /Archivos/REM/PFStoHaya/$1"

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
cd /Archivos/REM/PFStoHaya/$1
mput $DIR_SALIDA/$1*$2.*
bye
EOF
