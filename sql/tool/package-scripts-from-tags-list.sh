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
    echo "        EMPAQUETO LOS SCRIPTS DE BD DESDE UN LISTADO DE TAGS DETERMINADO"
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
    exit 1
fi

if [ "$#" -lt 2 ]; then
    print_banner
    echo "   Uso: $0 <tags-list-file> CLIENTE"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit 1
fi

if [ ! -f $1 ]; then
    print_banner
    echo "   No encuentro el fichero: "$1
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit 1
fi

print_banner
rm -rf ./package-tags
mkdir ./package-tags
cp sql/tool/scripts/run-scripts-package.sh ./package-tags
count=0
tagnametmp=''
while read tagname; do
    if [ $count == 0 ];then
        tagnametmp=$tagname
    else
        echo "Descargando repo en tag "$tagname" para crear empaquetado desde tag "$tagnametmp
        git checkout $tagname 
        ./sql/tool/package-scripts-from-tag.sh $tagnametmp $2
        mkdir ./package-tags/$count
        if [ -e ./sql/tool/tmp/package/DDL/DDL-scripts.zip ];then
            cp -r ./sql/tool/tmp/package/DDL ./package-tags/$count/
            rm ./package-tags/$count/DDL/*.zip
            echo "cd \$DIR_ORIG" >> ./package-tags/run-scripts-package.sh
            echo "cd ./$count/DDL/" >> ./package-tags/run-scripts-package.sh
            echo "./DDL-scripts.sh \$1 \$2" >> ./package-tags/run-scripts-package.sh
        fi
        if [ -e ./sql/tool/tmp/package/DML/DML-scripts.zip ];then
            cp -r ./sql/tool/tmp/package/DML ./package-tags/$count/
            rm ./package-tags/$count/DML/*.zip
            echo "cd \$DIR_ORIG" >> ./package-tags/run-scripts-package.sh
            echo "cd ./$count/DML/" >> ./package-tags/run-scripts-package.sh
            echo "./DML-scripts.sh \$1 \$2" >> ./package-tags/run-scripts-package.sh
        fi
        tagnametmp=$tagname
    fi
    count=$((count + 1))
    echo $count
done < $1
chmod a+x ./package-tags/*.sh
chmod a+x ./package-tags/**/**/*.sh
