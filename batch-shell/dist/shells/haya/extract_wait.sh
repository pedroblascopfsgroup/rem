#!/bin/bash

if [ "$#" == "0" ] ; then
   echo "Error: necesita un parámetro"
   exit 1
fi

ECO=0
if [ "$2" != "" ] ; then
   ECO=1
fi

if [[ $1 =~ ^extract_1[\.|\_].*sh$ ]] ; then
	[[ $ECO = 1 ]] && echo "$1 - Grupo 1 - Sin espera"
        exit 0
fi

if [[ $1 =~ ^extract_2[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 1 - Sin espera"
        exit 0
fi

if [[ $1 =~ ^extract_3[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 1 - Sin espera"
        exit 0
fi

if [[ $1 =~ ^extract_4[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 2 - Espera 30 segundos"
	sleep 30
        exit 0
fi

if [[ $1 =~ ^extract_5[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 2 - Espera 30 segundos"
	sleep 30
        exit 0
fi

if [[ $1 =~ ^extract_6[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 2 - Espera 30 segundos"
	sleep 30
        exit 0
fi

if [[ $1 =~ ^extract_7[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 3 - Espera 60 segundos"
	sleep 60
        exit 0
fi

if [[ $1 =~ ^extract_104[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 3 - Espera 60 segundos"
	sleep 60
        exit 0
fi

if [[ $1 =~ ^extract_105[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 4 - Espera 90 segundos"
	sleep 90
        exit 0
fi

if [[ $1 =~ ^extract_106[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 4 - Espera 90 segundos"
	sleep 90
        exit 0
fi

if [[ $1 =~ ^extract_107[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 4 - Espera 90 segundos"
	sleep 90
        exit 0
fi

if [[ $1 =~ ^extract_110[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 5 - Espera 120 segundos"
	sleep 120
        exit 0
fi

if [[ $1 =~ ^extract_115[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 5 - Espera 120 segundos"
	sleep 120
        exit 0
fi

if [[ $1 =~ ^extract_502[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 5 - Espera 120 segundos"
	sleep 120
        exit 0
fi

if [[ $1 =~ ^extract_8[\.|\_].*sh$ ]] ; then
        [[ $ECO = 1 ]] && echo "$1 - Grupo 6 - Espera 150 segundos"
	sleep 150
        exit 0
fi

[[ $ECO = 1 ]] && echo "$1 - No pertenece a ningun grupo"
exit 1
