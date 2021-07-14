cd ${DIR_SALIDA}

echo "Inicio de transferencia ficheros RUFACTUCP_BFA_$1.txt / RUFACTUSP_BFA_$1.txt"

lftp -u pfs,SwQdLRyFE8A5 sftp://192.168.126.7 <<EOF
	
	cd /Archivos/REM/PFSToHaya/BFA
  	mput ${DIR_SALIDA}RUFACTUCP_BFA_$1.txt
  	mput ${DIR_SALIDA}RUFACTUSP_BFA_$1.txt
	mput ${DIR_SALIDA}RUFACTUCP_BFA_$1.sem  	
  	mput ${DIR_SALIDA}RUFACTUSP_BFA_$1.sem  
  	bye
bye
EOF

echo "Ha finalizado la transferencia de los ficheros RUFACTUCP_BFA_$1.txt / RUFACTUSP_BFA_$1.txt"
