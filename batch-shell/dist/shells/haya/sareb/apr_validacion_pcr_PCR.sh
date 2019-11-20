#!/bin/bash
# Generado automaticamente a las mié jul 23 13:32:51 CEST 2014

DIR_ACTUAL=`pwd`
cd /recovery/haya/batch-server/sareb/shells
#cd /Documentos/Git/recovery/batch-shell/dist/shells/haya/sareb
./apr_validacion_pcr.sh PCR
RETURN_VAL=$?
cd $DIR_ACTUAL
#echo $RETURN_VAL
exit $RETURN_VAL
