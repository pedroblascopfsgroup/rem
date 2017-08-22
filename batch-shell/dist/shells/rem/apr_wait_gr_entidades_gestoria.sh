#!/bin/bash
 
fichero=OGF_ENTIDADES_ACTIVOS_GR

if [[ -z ${INSTALL_DIR/control/etl/ogf/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/ogf/input} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
#rm -f ${INSTALL_DIR/control/etl/ogf/input}$fichero_$1

extensionTxt=".dat"

OIFS=$IFS
IFS=','
arrayfichero=${fichero}

for fichero in $arrayfichero
do
    ficheroTxt=$INSTALL_DIR/control/etl/ogf/input/{fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_aspro_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/ogf/input/
		echo "Fichero movido al destino $DIR_DESTINO"
    fi
done
