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
}
function print_banner_description() {
    echo ""
    echo "                 EJECUTO LOS SCRIPTS DE BD DESDE UN TAG DETERMINADO"
    echo ""
    echo "******************************************************************************************"
}

function getConnectionParam() {
    filename=`basename $1`
    schema=`echo $filename | cut -d_ -f3`
    if [[ $schema == "BANKMASTER" ]] || [[ $schema == "MASTER" ]] || [[ $schema == "HAYAMASTER" ]]; then
        echo "$3"
    else
        echo "$2/$3"
    fi
} 

function registerSQLScript() {
    git log $1 >> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        printf "%s %s\n" $1 $3 >> $2
    fi
}

clear

if [ "$0" != "./sql/tool/$(basename $0)" ]; then
    print_banner
    print_banner_description
    echo ""
    echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    echo ""
    echo "    ./sql/tool/$(basename $0)"
    echo ""
    exit
fi

if [ "$#" -lt 3 ]; then
    print_banner
    print_banner_description
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
    print_banner_description
    echo ""
    echo "Defina su variable de entorno ORACLE_HOME"
    echo ""
    exit
fi

CUSTOMER_IN_UPPERCASE=`echo $2 | tr '[:lower:]' '[:upper:]'`
CUSTOMER_IN_LOWERCASE=`echo $2 | tr '[:upper:]' '[:lower:]'`

print_banner

BASEDIR=$(dirname $0)

export SETENVGLOBAL=~/setEnvGlobal.sh
if [ -f ~/setEnvGlobal${CUSTOMER_IN_UPPERCASE}.sh ] ; then
  export SETENVGLOBAL=~/setEnvGlobal${CUSTOMER_IN_UPPERCASE}.sh
fi
if [ ! -f $SETENVGLOBAL ]; then
    echo "No existe el fichero: $SETENVGLOBAL"
    echo "Consulta las plantillas que hay en sql/tool/templates"
    exit 1
fi
source $SETENVGLOBAL

rm -rf $BASEDIR/tmp/*.txt $BASEDIR/tmp/*.log $BASEDIR/tmp/*.sh $BASEDIR/tmp/*.sql $BASEDIR/tmp/**/*

#PRODUCTO
for file in `git diff $1 --name-only sql/**/producto/*.sql`
do
    if [ "$MULTIENTIDAD" != "" ] ; then
        IFS=',' read -a entidades <<< "$MULTIENTIDAD"
        for entidad in "${entidades[@]}"
        do
            connectionParam=`getConnectionParam $file ${!entidad} $3`
            registerSQLScript $file $BASEDIR/tmp/product-list-from-tag.txt $connectionParam
        done
    else
        registerSQLScript $file $BASEDIR/tmp/product-list-from-tag.txt $3
    fi
done

#CLIENTE
for file in `git diff $1 --name-only sql/**/$CUSTOMER_IN_LOWERCASE/*.sql`
do
    if [ "$MULTIENTIDAD" != "" ] ; then
        IFS=',' read -a entidades <<< "$MULTIENTIDAD"
        for entidad in "${entidades[@]}"
        do
            connectionParam=`getConnectionParam $file ${!entidad} $3`
            registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt $connectionParam
        done
    else
        registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt $3
    fi
done

#SUBCLIENTE EN CASO DE MULTIENTIDAD
if [ "$MULTIENTIDAD" != "" ] ; then
    IFS=',' read -a entidades <<< "$MULTIENTIDAD"
    for entidad in "${entidades[@]}"
    do
        SUBENTITY=`echo $entidad | tr '[:upper:]' '[:lower:]'`
        for file in `git diff $1 --name-only sql/**/$CUSTOMER_IN_LOWERCASE/$SUBENTITY/*.sql`
        do
            connectionParam=`getConnectionParam $file ${!entidad} $3`
            registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt $connectionParam
        done
    done
fi

if [ -f $BASEDIR/tmp/product-list-from-tag.txt ] ; then
    cat $BASEDIR/tmp/product-list-from-tag.txt | sort > $BASEDIR/tmp/list-from-tag.txt
fi
if [ -f $BASEDIR/tmp/customer-list-from-tag.txt ] ; then
    cat $BASEDIR/tmp/customer-list-from-tag.txt | sort >> $BASEDIR/tmp/list-from-tag.txt
fi


if [[ "$#" -ge 4 ]] && [[ "$4" == "go!" ]]; then
    while read -r line
    do
        if [[ "$5" == "-v" ]]; then
            echo "--------------------------------------------------------------------------------"
            echo "$BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE -v"
            $BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE -v
            echo "--------------------------------------------------------------------------------"
        else
            $BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE
            if [[ "$?" != 0 ]]; then
                echo ""
                echo "ABORTADA EJECUCION POR #KO#"
                exit 1
            fi 
        fi
    done < $BASEDIR/tmp/list-from-tag.txt
elif [[ "$#" -ge 4 ]] && [[ "$4" == "package!" ]]; then
    while read -r line
    do
        $BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE -p
    done < $BASEDIR/tmp/list-from-tag.txt
    mkdir -p $BASEDIR/tmp/package
    mkdir $BASEDIR/tmp/package/ddl
    mkdir $BASEDIR/tmp/package/ddl/scripts/
    mkdir $BASEDIR/tmp/package/dml
    mkdir $BASEDIR/tmp/package/dml/scripts/
    cp -r $BASEDIR/tmp/DML*reg*.sql $BASEDIR/tmp/package/dml/scripts/
    cat $BASEDIR/scripts/DxL-scripts.sh $BASEDIR/tmp/DML-scripts.sh >> $BASEDIR/tmp/package/dml/DML-scripts.sh
    cp -r $BASEDIR/tmp/DDL*reg*.sql $BASEDIR/tmp/package/ddl/scripts/
    cat $BASEDIR/scripts/DxL-scripts.sh $BASEDIR/tmp/DDL-scripts.sh >> $BASEDIR/tmp/package/ddl/DDL-scripts.sh
    cd $BASEDIR/tmp/package/ddl
    zip DDL-scripts.zip -r *
    cd ../dml
    zip DML-scripts.zip -r *
    cd ..
    mv **/*.zip .
else
    echo ""
    echo "Lo que pretendo ejecutar es:"
    echo ""
    while read -r line
    do
        echo "$BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE"
    done < $BASEDIR/tmp/list-from-tag.txt
    echo ""
    echo "Si estás de acuerdo, añade go! al final de la línea de comandos"
    echo ""
    echo "******************************************************************************************"
fi
