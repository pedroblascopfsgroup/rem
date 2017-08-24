#!/bin/bash

echo "Incio del proceso de aprovisionamiento de los ficheros ENTIDADES_ACTIVOS_GR"

#############
### OGF
############# 
echo "Se inicia la transferecia de los ficheros de la gestoria OGF"
fichero=OGF_DOCUMENTOS_GR

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
    ficheroTxt=$INSTALL_DIR/control/etl/ogf/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestoria_ogf_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/ogf/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/ogf/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria OGF"

#############
### TECNOTRAMIT
#############
echo "Se inicia la transferecia de los ficheros de la gestoria TECNOTRAMIT"
fichero=TECNOTRAMIT_DOCUMENTOS_GR

if [[ -z ${INSTALL_DIR/control/etl/tecnotramit/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/tecnotramit/input} ]]; then
    echo "$(basename $0) Error: DIR_DESTINO no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
#rm -f ${INSTALL_DIR/control/etl/tecnotramit/input}$fichero_$1

extensionTxt=".dat"

OIFS=$IFS
IFS=','
arrayfichero=${fichero}

for fichero in $arrayfichero
do
    ficheroTxt=$INSTALL_DIR/control/etl/tecnotramit/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestoria_tecnotramit_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/tecnotramit/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/tecnotramit/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria TECNOTRAMIT"

#############
### TINSA_CERTIFY
#############
echo "Se inicia la transferecia de los ficheros de la gestoria TINSA_CERTIFY"
fichero=TINSA_CERTIFY_DOCUMENTOS_GR

if [[ -z ${INSTALL_DIR/control/etl/tinsa_certify/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/tinsa_certify/input} ]]; then
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
    ficheroTxt=$INSTALL_DIR/control/etl/tinsa_certify/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestorias_tinsa_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/tinsa_certify/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/tinsa_certify/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria TINSA_CERTIFY"
