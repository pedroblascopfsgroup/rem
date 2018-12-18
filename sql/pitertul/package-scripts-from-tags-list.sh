#!/bin/bash

. ./sql/pitertul/commons/configuration.sh

export DESCRIPCION="EMPAQUETO LOS SCRIPTS DE BD DESDE UN LISTADO DE TAGS DETERMINADO\n\n¡¡CUIDADO!! Hago RESET por lo que perderás los ficheros bajo control de versiones que hayas modificado"

clear

if [ "$0" != "./sql/pitertul/$(basename $0)" ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
    echo ""
    echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    echo ""
    echo "    ./sql/pitertul/$(basename $0)"
    echo ""
    exit 1
fi

if [ "$#" -lt 2 ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
    echo ""
    echo "   Uso: $0 <tags-list-file> CLIENTE"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit 1
fi

if [ ! -f $1 ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
    echo ""
    echo "   No encuentro el fichero: "$1
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit 1
fi

print_banner
print_banner_description "$DESCRIPCION"
echo ""
rm -rf ./package-tags
mkdir -p ./package-tags/DB
cp sql/pitertul/scripts/run-scripts-package.sh ./package-tags/DB/DB-scripts.sh
count=0
tagnametmp=''
while read tagname; do
    if [ $count == 0 ];then
        tagnametmp=$tagname
    else
        echo "Descargando repo en tag "$tagname" para crear empaquetado desde tag "$tagnametmp
        git reset --hard HEAD
        git checkout $tagname 
        ./sql/pitertul/package-scripts-from-tag.sh $tagnametmp $2
        if [ $? -ne 0 ]; then
            echo "ERROR al generar el empaquetado"
            exit 1
        fi
        mkdir ./package-tags/DB/$count
        if [ -e ./sql/pitertul/tmp/package/DDL/DDL-scripts.zip ] || [ -e ./sql/pitertul/tmp/package/DDL-scripts.zip ] ; then
            cp -r ./sql/pitertul/tmp/package/DDL ./package-tags/DB/$count/
            rm -f ./package-tags/DB/$count/DDL/*.zip
            for script in `find ./package-tags/DB/$count/DDL/ -name *PREPROYECT_CNT*3.1*`;
            do 
                sed -e 's/SET DEFINE OFF;/SET DEFINE OFF;\nalter session set "_pred_move_around"=FALSE;\n/g' -i $script
            done
            echo "if [ \$? != 0 ];then exit 1; fi" >> ./package-tags/DB/DB-scripts.sh
            echo "cd \$DIR_ORIG" >> ./package-tags/DB/DB-scripts.sh
            echo "cd ./$count/DDL/" >> ./package-tags/DB/DB-scripts.sh
            echo "./DDL-scripts.sh \$1 \$2" >> ./package-tags/DB/DB-scripts.sh
        fi
        if [ -e ./sql/pitertul/tmp/package/DML/DML-scripts.zip ] || [ -e ./sql/pitertul/tmp/package/DML-scripts.zip ] ; then
            cp -r ./sql/pitertul/tmp/package/DML ./package-tags/DB/$count/
            rm -f ./package-tags/DB/$count/DML/*.zip
            echo "if [ \$? != 0 ];then  exit 1; fi" >> ./package-tags/DB/DB-scripts.sh
            echo "cd \$DIR_ORIG" >> ./package-tags/DB/DB-scripts.sh
            echo "cd ./$count/DML/" >> ./package-tags/DB/DB-scripts.sh
            echo "./DML-scripts.sh \$1 \$2" >> ./package-tags/DB/DB-scripts.sh
        fi
        if [ -e ./sql/pitertul/tmp/package/DB-scripts.zip ] ; then
            cp -r ./sql/pitertul/tmp/package/DB ./package-tags/DB/$count/
            echo "if [ \$? != 0 ];then  exit 1; fi" >> ./package-tags/DB/DB-scripts.sh
            echo "cd \$DIR_ORIG" >> ./package-tags/DB/DB-scripts.sh
            echo "cd ./$count/DB/" >> ./package-tags/DB/DB-scripts.sh
            echo "./DB-scripts.sh \$1 \$2" >> ./package-tags/DB/DB-scripts.sh
        fi
        tagnametmp=$tagname
    fi
    count=$((count + 1))
done < $1
chmod a+x ./package-tags/DB/*.sh
chmod a+x ./package-tags/DB/**/**/*.sh
echo "----------------------------------------------"
echo "  TERMINADO: "
echo "     Consulta el directorio ./package-tags/"
echo "----------------------------------------------"
