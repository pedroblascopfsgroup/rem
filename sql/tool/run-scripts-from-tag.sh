#!/bin/bash

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
    echo "                 EJECUTO LOS SCRIPTS DE BD DESDE UN TAG DETERMINADO"
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

if [ "$0" != "./sql/tool/$(basename $0)" ]; then
    print_banner
    echo ""
    echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    echo ""
    echo "    ./sql/tool/$(basename $0)"
    echo ""
    exit
fi

if [ "$#" -lt 3 ]; then
    print_banner
    echo ""
    echo "Para simular antes de ejecutar:"
    echo ""
    if [ "$ORACLE_SID" == "" ] ; then
        echo "   Uso: $0 <tag> CLIENTE password_esquemas@sid"
    else
        echo "   Uso: $0 <tag> CLIENTE password_esquemas"
    fi
    echo ""
    echo "Para ejecutarlo:"
    echo ""
    if [ "$ORACLE_SID" == "" ] ; then
        echo "   Uso: $0 <tag> CLIENTE password_esquemas@sid go!"
        echo "   Uso: $0 <tag> CLIENTE password_esquemas@sid go! -v"
    else
        echo "   Uso: $0 <tag> CLIENTE password_esquemas go!"
        echo "   Uso: $0 <tag> CLIENTE password_esquemas go! -v"
    fi
    echo ""
    echo "       -v: verbose"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit
fi

if [ "$ORACLE_HOME" == "" ] ; then
    print_banner
    echo ""
    echo "Defina su variable de entorno ORACLE_HOME"
    echo ""
    exit
fi

CUSTOMER_IN_UPPERCASE=`echo $2 | tr '[:lower:]' '[:upper:]'`
CUSTOMER_IN_LOWERCASE=`echo $2 | tr '[:upper:]' '[:lower:]'`

print_banner

BASEDIR=$(dirname $0)

rm -rf $BASEDIR/tmp/*.txt $BASEDIR/tmp/*.log $BASEDIR/tmp/*.sh $BASEDIR/tmp/*.sql

for file in `git diff $1 --name-only sql/**/producto/*.sql`
do
    registerSQLScript $file $BASEDIR/tmp/product-list-from-tag.txt 
done

for file in `git diff $1 --name-only sql/**/$CUSTOMER_IN_LOWERCASE/*.sql`
do
    registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt
done

cat $BASEDIR/tmp/product-list-from-tag.txt | sort | cut -d# -f2 > $BASEDIR/tmp/list-from-tag.txt
cat $BASEDIR/tmp/customer-list-from-tag.txt | sort | cut -d# -f2 >> $BASEDIR/tmp/list-from-tag.txt


if [[ "$#" -ge 4 ]] && [[ "$4" == "go!" ]]; then
    while read -r line
    do
        if [[ "$5" == "-v" ]]; then
            echo "--------------------------------------------------------------------------------"
            echo "$BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE -v"
            $BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE -v
            echo "--------------------------------------------------------------------------------"
        else
            $BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE
        fi
    done < $BASEDIR/tmp/list-from-tag.txt
else
    echo ""
    echo "Lo que pretendo ejecutar es:"
    echo ""
    while read -r line
    do
        echo "$BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE"
    done < $BASEDIR/tmp/list-from-tag.txt
    echo ""
    echo "Si estás de acuerdo, añade go! al final de la línea de comandos"
    echo ""
    echo "******************************************************************************************"
fi
