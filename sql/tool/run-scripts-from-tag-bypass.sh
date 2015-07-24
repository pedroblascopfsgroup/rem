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
    echo " EJECUTO LOS SCRIPTS DE BD DESDE UN TAG (PERO TODOS! NO SÓLO LOS QUE CUELGAN DE SQL/ ...."
    echo ""
    echo " ....... ahora ya sabes porque soy bypass, porque esto de paso ;))"
    echo ""
    echo "******************************************************************************************"
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
    echo "   Uso: $0 <tag> [haya|bankia|cajamar] password_esquemas"
    echo ""
    echo "Para ejecutarlo:"
    echo ""
    echo "   Uso: $0 <tag> [haya|bankia|cajamar] password_esquemas go!"
    echo ""
    echo "   Uso: $0 <tag> [haya|bankia|cajamar] password_esquemas go! -v"
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

for file in `git diff $1 --name-only  | grep "\.sql"`
do
        git log $file >> /dev/null 2>&1
        if [ $? -eq 0 ]; then
            HASH=`git rev-list HEAD $file | tail -n 1`    
            DATE=`git show -s --format="%ct" $HASH --`   
            printf "%s#%s \n" "$DATE" $file >> $BASEDIR/tmp/from-date-list-1.txt
        fi
done

#cat $BASEDIR/tmp/from-date-list-1.txt | grep "producto\|$CUSTOMER_IN_LOWERCASE" | sort | cut -d# -f2 > $BASEDIR/tmp/from-date-list-2.txt
cat $BASEDIR/tmp/from-date-list-1.txt | grep "DEFAULT" | sort | cut -d# -f2 > $BASEDIR/tmp/from-date-list-2.txt
cat $BASEDIR/tmp/from-date-list-1.txt | grep "default" | sort | cut -d# -f2 >> $BASEDIR/tmp/from-date-list-2.txt
cat $BASEDIR/tmp/from-date-list-1.txt | grep "producto" | sort | cut -d# -f2 >> $BASEDIR/tmp/from-date-list-2.txt
cat $BASEDIR/tmp/from-date-list-1.txt | grep "$CUSTOMER_IN_LOWERCASE" | sort | cut -d# -f2 >> $BASEDIR/tmp/from-date-list-2.txt


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
    done < $BASEDIR/tmp/from-date-list-2.txt
else
    echo ""
    echo "Lo que pretendo ejecutar es:"
    echo ""
    while read -r line
    do
        echo "$BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE"
    done < $BASEDIR/tmp/from-date-list-2.txt
    echo ""
    echo "Si estás de acuerdo, añade go! al final de la línea de comandos"
    echo ""
    echo "******************************************************************************************"
fi
