#!/bin/bash

. ./sql/pitertul/commons/configuration.sh

function print_banner() {
    echo '******************************************************************************************'
    echo '******************************************************************************************'
    echo ''
    echo '   .-------. .-./`) ,---------.    .----.  .-------. ,---------.   ___    _   .---.'
    echo '   \  _(`)_ \\ .-.`)\          \ .`_ _   \ |  _ _   \\          \.`   |  | |  | ,_|'
    echo '   | (_ o._)|/ `-` \ `--.  ,---`/ ( ` )   `| ( ` )  | `--.  ,--- |   .|  | |,-./  )'
    echo '   |  (_,_) / `-``-`    |   \  . (_ o _)  ||(_ o _) /    |   \   .`  `_  | |\   _  `)'
    echo '   |   |-.-   .---.     :_ _:  |  (_,_)___|| (_,_).  __  :_ _:   |   ( \.-.| > (_)  )'
    echo '   |   |      |   |     (_I_)  |  \   .---.|  |\ \  |  | (_I_)   | (`. _` /|(  .  .-'
    echo '   |   |      |   |    (_(=)_)  \  `--    /|  | \ `-   /(_(=)_)  | (_ (_) _) `- `-`|___'
    echo '   /   )      |   |     (_I_)    \       / |  |  \    /  (_I_)    \ /  . \ /  |        \'
    echo '   `---`      `---`     `---`     ``-..-`  ``-`   ``-`   `---`     ``- `-`    `--------`'
    echo ""
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    echo ""
    echo "                 LISTO LOS SCRIPTS DE OPERACIONAL DE sql/"
    echo ""
    echo "******************************************************************************************"
}

function registerSQLScript() {
    git log $1 >> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        HASH=`git rev-list HEAD $1 | tail -n 1`
        DATE=`git show -s --format="%ct" $HASH --`
        printf "%s#%s \n" "$DATE" $1 >> $2
    fi
}

clear

if [ "$0" != "./sql/pitertul/$(basename $0)" ]; then
    print_banner
    echo ""
    echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    echo ""
    echo "    ./sql/pitertul/$(basename $0)"
    echo ""
    exit
fi

if [ "$#" -lt 1 ]; then
    print_banner
    echo ""
    echo "   Uso: $0 [cliente]"
    echo ""
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit
fi

print_banner

CUSTOMER_IN_LOWERCASE=`echo $1 | tr '[:upper:]' '[:lower:]'`
CUSTOMER_IN_UPPERCASE=`echo $1 | tr '[:lower:]' '[:upper:]'`
BASEDIR=$(dirname $0)

loadEnvironmentVariables ${CUSTOMER_IN_UPPERCASE}

rm -rf $BASEDIR/tmp/*.txt

for file in `ls sql/**/producto/*.sql`
do
    registerSQLScript $file $BASEDIR/tmp/product-list.txt
done

for file in `ls sql/**/$CUSTOMER_IN_LOWERCASE/*.sql`
do
    registerSQLScript $file $BASEDIR/tmp/customer-list.txt
done

cat $BASEDIR/tmp/product-list.txt | sort | cut -d# -f2

if [ "$MULTIENTIDAD" != "" ] ; then
    IFS=',' read -a entidades <<< "$MULTIENTIDAD"
    for entidad in "${entidades[@]}"
    do
        SUBENTITY=`echo $entidad | tr '[:upper:]' '[:lower:]'`
        for file in `ls sql/**/$CUSTOMER_IN_LOWERCASE/$SUBENTITY/*.sql`
        do
            registerSQLScript $file $BASEDIR/tmp/customer-list.txt
        done
    done
fi

cat $BASEDIR/tmp/customer-list.txt | sort | cut -d# -f2
