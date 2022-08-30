#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014

date=$1
fichero="INFORME_STOCK_BANKIA_$date.xlsx"
cd $DIR_SALIDA

if [[ -f $fichero ]] && [[ $date ]]; then
	echo "Subiendo fichero $fichero al FTP..."
	lftp -u pfs,SwQdLRyFE8A5 sftp://intercambio2.haya.es <<EOF
	cd "/Archivos/REM/HayaToPFS/BankiaToREM/"
	mput $fichero
	bye
EOF
else
	echo "##### ERROR: No existe el fichero $fichero #####"
	exit 1
fi
echo "Fichero subido al FTP"
exit 0
