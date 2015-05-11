#!/bin/bash

export DIR=$(dirname $0)/dist
FECHA=$(date +%Y%m%d)

export ENABLE_DATE_DIR=no

export DESCRIPCION="Envio de fichero de rechazos del Proceso de Impulsos Automáticos"
export HOST=vip.lindorff.nl
export USER=PFS
export PASS=tNCWdYVnbP
export FTP_DIR=SALIDA/IMPULSOS_AUTOMATICOS/RECHAZOS
export DIR_ENTRADA=/tmp/impulsos/rechazos
export DATA_FILE_MASK=*.*
export SEM_FILE_MASK=*
export SEM_NEED=no

export CLEAN_FILES=yes
#export SCP_DST_HOST=inte
#export SCP_DST_USER=intelindorff
#export SCP_DST_DIR=/tmp


export ERR_CODE_DEFAULT=1
export ERR_CODE_FILE_NOT_FOUND=0
export ERR_CODE_FILE_FTP_FAILURE=1
export ERR_CODE_FILE_SCP_FAILURE=1


$DIR/ftp.put.sh
