#!/bin/bash

#
# Params:
#   CUSTOMER_IN_UPPERCASE
#
function loadEnvironmentVariables() {
    CUSTOMER_IN_UPPERCASE="$1"
    ECHO="$2"
    export SETENVGLOBAL=setEnvGlobal.sh
    if [[ "$CUSTOMER_IN_UPPERCASE" != "-" ]] ; then
        if [ -f setEnvGlobal$CUSTOMER_IN_UPPERCASE.sh ] ; then
            export SETENVGLOBAL=setEnvGlobal$CUSTOMER_IN_UPPERCASE.sh
        elif [ -f ~/setEnvGlobal$CUSTOMER_IN_UPPERCASE.sh ] ; then
            export SETENVGLOBAL=~/setEnvGlobal$CUSTOMER_IN_UPPERCASE.sh
        fi
    elif [ ! -f $SETENVGLOBAL ]; then
        export SETENVGLOBAL=~/setEnvGlobal.sh
    fi
    if [ ! -f $SETENVGLOBAL ]; then
        echo "ERROR"
        echo "  No existe el fichero $SETENVGLOBAL o similar"
        echo "  Consulta las plantillas que hay en sql/pitertul/templates"
        exit 1
    fi
    if [ "$ECHO" == "on" ]; then
        echo "CONF: Cargando variables de $SETENVGLOBAL"
    fi
    source $SETENVGLOBAL
}


function findInputParam() {
    SEARCH_STRING="-$1:"
    REGEX_SEARCH_STRING="$SEARCH_STRING*"
    PARAMS=$*
    for var in ${PARAMS}
    do
        if [[ $var = ${REGEX_SEARCH_STRING} ]]; then
            echo $var | sed "s/$SEARCH_STRING//g"
            return
        fi
    done
}

function print_banner() {
	GREEN='\033[1;32m'
	NC='\033[0m' 

    echo '******************************************************************************************'
    echo '******************************************************************************************'
    echo ''
    echo -e ${GREEN}
    echo '██████╗ ██╗████████╗███████╗██████╗ ████████╗██╗   ██╗██╗         ██████╗     ██████╗ '
    echo '██╔══██╗██║╚══██╔══╝██╔════╝██╔══██╗╚══██╔══╝██║   ██║██║         ╚════██╗   ██╔═████╗'
    echo '██████╔╝██║   ██║   █████╗  ██████╔╝   ██║   ██║   ██║██║          █████╔╝   ██║██╔██║'
    echo '██╔═══╝ ██║   ██║   ██╔══╝  ██╔══██╗   ██║   ██║   ██║██║         ██╔═══╝    ████╔╝██║'
    echo '██║     ██║   ██║   ███████╗██║  ██║   ██║   ╚██████╔╝███████╗    ███████╗██╗╚██████╔╝'
    echo '╚═╝     ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚══════╝    ╚══════╝╚═╝ ╚═════╝ '                                                                                      
    echo -e ${NC}
    echo '******************************************************************************************'
    echo '******************************************************************************************'
}

function print_banner_description() {
    echo -e "\n                  $1\n"
    echo -e "******************************************************************************************\n"
}