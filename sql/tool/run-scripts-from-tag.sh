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
        filename=`basename $1`
        if [[ ! $filename =~ ^D[MD]L_[0-9]+_[^_]+_[^\.]+\.sql$ ]] ; then
            echo "ERROR"
            echo "  El nombre del script no sigue la nomenclatura definida: "$filename
            echo "  Consulta sql/tool/templates para ver un ejemplo de plantilla"
            exit 1
        fi
        grep -Fqi 'WHENEVER SQLERROR' $1
        if [[ $? != 0 ]] ; then
            echo ""
            echo $1
            echo "El script no contiene la primera línea de control de errores: WHENEVER SQLERROR ..."
            echo "Consulta sql/tool/templates para ver un ejemplo de plantilla"
            exit 1
        fi
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
    echo "ERROR"
    echo "  No existe el fichero: $SETENVGLOBAL"
    echo "  Consulta las plantillas que hay en sql/tool/templates"
    exit 1
fi
source $SETENVGLOBAL

rm -rf $BASEDIR/tmp/*.txt $BASEDIR/tmp/*.log $BASEDIR/tmp/*.sh $BASEDIR/tmp/*.sql $BASEDIR/tmp/**/*

DIRECTORIO=""
if [[ "$#" -ge 4 ]] && [[ "$4" == "package!" ]] && [[ "$3" != "null" ]]; then
    DIRECTORIO="$3/"
fi

#PRODUCTO
for file in `git diff $1 --name-only sql/**/producto/$DIRECTORIO*.sql`
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
for file in `git diff $1 --name-only sql/**/$CUSTOMER_IN_LOWERCASE/$DIRECTORIO*.sql`
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
                echo "ERROR"
                echo "  ABORTADA EJECUCION POR #KO#"
                exit 1
            fi 
        fi
    done < $BASEDIR/tmp/list-from-tag.txt

elif [[ "$#" -ge 4 ]] && [[ "$4" == "package!" ]]; then

    while read -r line
    do
        NEW_LINE=$line
        if [ "$MULTIENTIDAD" == "" ] ; then
            NEW_LINE=`echo $line | cut -d' ' -f1`
            NEW_LINE=$NEW_LINE' pass'
        fi
        $BASEDIR/run-single-script.sh $NEW_LINE $CUSTOMER_IN_UPPERCASE -p
        if [[ "$?" != 0 ]]; then
            echo "ERROR"
            exit 1
        fi
    done < $BASEDIR/tmp/list-from-tag.txt
    mkdir -p $BASEDIR/tmp/package
    mkdir $BASEDIR/tmp/package/DDL
    mkdir $BASEDIR/tmp/package/DDL/scripts/
    mkdir $BASEDIR/tmp/package/DML
    mkdir $BASEDIR/tmp/package/DML/scripts/
    passtring=''
    if [ "$MULTIENTIDAD" != "" ] ; then
        IFS=',' read -a entidades <<< "$MULTIENTIDAD"
        for index in "${!entidades[@]}"
        do
            passtring="$passtring ""entity0$((index+1))_pass@host:port\/sid"
        done        
    else
        passtring="entity01_pass@host:port\/sid"
    fi
    if [ $2 == 'BANKIA' ]; then
        cp $BASEDIR/scripts/DxL-scripts-BK.sh $BASEDIR/tmp/package/DDL/DDL-scripts.sh
    else
        sed -e s/#ENTITY#/"${passtring}"/g $BASEDIR/scripts/DxL-scripts.sh > $BASEDIR/tmp/package/DDL/DDL-scripts.sh
    fi
    cp $BASEDIR/scripts/DxL-scripts-one-user.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh
    if [ $CUSTOMER_IN_UPPERCASE == 'CAJAMAR' ] ; then
        echo "export NLS_LANG=AMERICAN.AL32UTF8" | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null
        echo "export NLS_DATE_FORMAT=\"DD-MON-RR\"" | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null
    else
        echo "export NLS_LANG=.AL32UTF8" | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null 
    fi
    cp $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DML/DML-scripts.sh
    cp $BASEDIR/scripts/DxL-scripts-one-user.sh $BASEDIR/tmp/package/DML/DML-scripts-one-user.sh
    if [ -f $BASEDIR/tmp/DDL-scripts.sh ] ; then 

        # Herramientas de Pitertul (actualización)
        VARIABLES_SUSTITUCION=`echo -e "${VARIABLES_SUSTITUCION}" | tr -d '[[:space:]]'`
        IFS=',' read -a array <<< "$VARIABLES_SUSTITUCION"
        for index in "${!array[@]}"
        do
            KEY=`echo ${array[index]} | cut -d\; -f1`
            VALUE=`echo ${array[index]} | cut -d\; -f2`
            if [[ $KEY == '#ESQUEMA#' ]]; then
               ESQUEMA=$VALUE
                echo "exit | sqlplus -s -l $ESQUEMA/\$2 @./scripts/DDL_000_$ESQUEMA.sql" >> $BASEDIR/tmp/package/DDL/DDL-scripts.sh
                echo "exit | sqlplus -s -l \$1 @./scripts/DDL_000_$ESQUEMA.sql" >> $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh
            fi
        done
        cp $BASEDIR/tmp/DDL_000_$ESQUEMA.sql $BASEDIR/tmp/package/DDL/scripts/

        cat $BASEDIR/tmp/DDL-scripts.sh >> $BASEDIR/tmp/package/DDL/DDL-scripts.sh
        cat $BASEDIR/tmp/DDL-scripts-one-user.sh >> $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh
        cp -r $BASEDIR/tmp/DDL*reg*.sql $BASEDIR/tmp/package/DDL/scripts/
        cd $BASEDIR/tmp/package/DDL
        zip DDL-scripts.zip -r *
        cd -
    fi
    if [ -f $BASEDIR/tmp/DML-scripts.sh ] ; then
        cat $BASEDIR/tmp/DML-scripts.sh >> $BASEDIR/tmp/package/DML/DML-scripts.sh
        cat $BASEDIR/tmp/DML-scripts-one-user.sh >> $BASEDIR/tmp/package/DML/DML-scripts-one-user.sh
        cp -r $BASEDIR/tmp/DML*reg*.sql $BASEDIR/tmp/package/DML/scripts/
        cd $BASEDIR/tmp/package/DML
        zip DML-scripts.zip -r *
        cd -
    fi      
    echo ""
    echo "---------------------------------------------------"
    echo "---- EMPAQUETADOS PARA SOLICITUD DE DESPLIEGUE ----" 
    echo "---------------------------------------------------"
    echo ""
    echo `ls $BASEDIR/tmp/package/**/*.zip` 
    echo "---------------------------------------------------"

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
