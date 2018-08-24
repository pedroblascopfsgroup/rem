#!/bin/bash

echo "Incio del proceso de aprovisionamiento de los ficheros ENTIDADES_ACTIVOS_GR"

#############
### OGF
############# 
echo "Se inicia la transferecia de los ficheros de la gestoria OGF"
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
fichero=TECNOTRAMIT_ENTIDADES_ACTIVOS_GR

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
echo "Se inicia la transferecia de los ficheros de la gestoria TINSACERTIFY"
fichero=TINSACERTIFY_ENTIDADES_ACTIVOS_GR

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
        ./ftp/ftp_get_gestoria_tinsa_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/tinsa_certify/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/tinsa_certify/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria TINSACERTIFY"

#############
### GARSA
#############
echo "Se inicia la transferecia de los ficheros de la gestoria GARSA"
fichero=GARSA_ENTIDADES_ACTIVOS_GR

if [[ -z ${INSTALL_DIR/control/etl/garsa/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/garsa/input} ]]; then
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
    ficheroTxt=$INSTALL_DIR/control/etl/garsa/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestoria_garsa_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/garsa/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/garsa/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria GARSA"

#############
### GUTIERREZ_LABRADOR
#############
echo "Se inicia la transferecia de los ficheros de la gestoria GUTIERREZ_LABRADOR"
fichero=GUTIERREZL_ENTIDADES_ACTIVOS_GR

if [[ -z ${INSTALL_DIR/control/etl/gutierrez_labrador/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/gutierrez_labrador/input} ]]; then
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
    ficheroTxt=$INSTALL_DIR/control/etl/gutierrez_labrador/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestoria_gutierrez_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/gutierrez_labrador/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/gutierrez_labrador/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria GUTIERREZ LABRADOR"

#############
### MONTALVO
#############
echo "Se inicia la transferecia de los ficheros de la gestoria MONTALVO"
fichero=MONTALVO_ENTIDADES_ACTIVOS_GR

if [[ -z ${INSTALL_DIR/control/etl/montalvo/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/montalvo/input} ]]; then
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
    ficheroTxt=$INSTALL_DIR/control/etl/montalvo/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestoria_montalvo_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/montalvo/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/montalvo/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria MONTALVO"

#############
### PINOS
#############
echo "Se inicia la transferecia de los ficheros de la gestoria PINOS"
fichero=PINOS_ENTIDADES_ACTIVOS_GR

if [[ -z ${INSTALL_DIR/control/etl/pinos/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/pinos/input} ]]; then
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
    ficheroTxt=$INSTALL_DIR/control/etl/pinos/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestoria_pinos_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/pinos/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/pinos/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria PINOS"

#############
### UNIGES
#############
echo "Se inicia la transferecia de los ficheros de la gestoria UNIGES"
fichero=UNIGES_ENTIDADES_ACTIVOS_GR

if [[ -z ${INSTALL_DIR/control/etl/uniges/input} ]] || [[ ! -d ${INSTALL_DIR/control/etl/uniges/input} ]]; then
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
    ficheroTxt=$INSTALL_DIR/control/etl/uniges/input/${fichero}_$1$extensionTxt
    echo "fichero .dat: $ficheroTxt"
    if [[ "$#" -eq 1 ]]; then
        ./ftp/ftp_get_gestoria_uniges_files.sh $1 ${fichero}_$1 $INSTALL_DIR/control/etl/uniges/input/
		echo "Fichero movido al destino $INSTALL_DIR/control/etl/uniges/input/"
    fi
done

echo "Fin de la transferecia de los ficheros de la gestoria UNIGES"
