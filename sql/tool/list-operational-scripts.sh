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
    echo "                 LISTO LOS SCRIPTS DE OPERACIONAL DE sql/"
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

if [ "$#" -lt 1 ]; then
    print_banner
    echo ""
    echo "   Uso: $0 [haya|bankia]"
    echo ""
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit
fi

print_banner

CUSTOMER_IN_LOWERCASE=`echo $1 | tr '[:upper:]' '[:lower:]'`

BASEDIR=$(dirname $0)

rm -rf $BASEDIR/tmp/*.txt

for directory in `find ./sql -mindepth 1 -maxdepth 1 -name '?\.*'`
do
    for file in `find $directory -maxdepth 4 -type f -name *.sql`
    do
        git log $file >> /dev/null 2>&1
        if [ $? -eq 0 ]; then
            HASH=`git rev-list HEAD $file | tail -n 1`    
            DATE=`git show -s --format="%ct" $HASH --`   
            printf "%s#%s \n" "$DATE" $file >> $BASEDIR/tmp/from-date-list-1.txt
        fi
    done
done

cat $BASEDIR/tmp/from-date-list-1.txt | grep "producto" | sort | cut -d# -f2 
cat $BASEDIR/tmp/from-date-list-1.txt | grep "$CUSTOMER_IN_LOWERCASE" | sort | cut -d# -f2 
