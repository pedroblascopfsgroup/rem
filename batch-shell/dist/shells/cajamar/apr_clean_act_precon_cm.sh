#!/bin/bash
 
if [[ -z ${DIR_HRE_INPUT} ]] || [[ ! -d ${DIR_HRE_INPUT} ]]; then
    echo "$(basename $0) Error: DIR_HRE_INPUT no definido o no es un directorio. Compruebe invocación previa a setBatchEnv.sh"
    exit 1
fi
rm -f ${DIR_HRE_INPUT}STOCK_PRECON*
exit 0
