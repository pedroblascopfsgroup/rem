#!/bin/bash

. ./sql/pitertul/commons/check.sh
. ./sql/pitertul/commons/configuration.sh

export DESCRIPCION="EJECUTO LOS SCRIPTS DE BD DESDE UN TAG DETERMINADO"

function getConnectionParam() {
    INPUT_FILE=$1
    INPUT_ENTIDAD=$2
    INPUT_PASSWORD=$3
    filename=`basename $INPUT_FILE`
    schema=`echo $filename | cut -d_ -f3`
    if [[ $schema == "BANKMASTER" ]] || [[ $schema == "MASTER" ]] || [[ $schema == "HAYAMASTER" ]]; then
        echo "$INPUT_PASSWORD"
    else
        echo "$INPUT_ENTIDAD/$INPUT_PASSWORD"
    fi
} 

function registerSQLScript() {
    INPUT_FILE_SH=$1
    INPUT_FILE_ACUM=$2
    INPUT_CONECTION=$3
    git log $INPUT_FILE_SH >> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        checkScriptFormat $INPUT_FILE_SH
        printf "%s %s\n" $INPUT_FILE_SH $INPUT_CONECTION >> $INPUT_FILE_ACUM
    fi
}

function ending_script {
    INPUT_PARAM_TAG=$1
    INPUT_PARAM_CLIENTE=$2
    echo '}'
    echo ''
    CLIENTE_UPPER=`echo $INPUT_PARAM_CLIENTE | tr '[:lower:]' '[:upper:]'`
    if [[ $CLIENTE_UPPER != 'CAJAMAR' ]]; then
        echo 'run_scripts "$@" > >(tee output.log)'
    else 
        echo 'run_scripts "$@" | tee output.log'
    fi
}

clear

FLAG_NO="n";
FLAG_YES="y";

INPUT_PARAM_TAG=$1
INPUT_PARAM_CLIENTE=$2
INPUT_PARAM_PASSWORD=$3
INPUT_PARAM_GO=$4
INPUT_PARAM_VERBOSE=$5
INPUT_PARAM_OUT_PROC_Y_VISTAS=`findInputParam out-pv $* | tr [:upper:] [:lower:]`
INPUT_PARAM_OUT_SCRIPTS=`findInputParam out-scripts $* | tr [:upper:] [:lower:]`
INPUT_PARAM_OUT_COMPILE=`findInputParam compile $* | tr [:upper:] [:lower:]`

if [ "$0" != "./sql/pitertul/$(basename $0)" ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
    echo ""
    echo "AUCH!! No me ejecutes desde aquí, por favor, que me electrocuto... sal a la raiz del repositorio RECOVERY y ejecútame como:"
    echo ""
    echo "    ./sql/pitertul/$(basename $0)"
    echo ""
    exit
fi

if [ "$#" -lt 3 ]; then
    print_banner
    print_banner_description "$DESCRIPCION"
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
        echo "   Uso: $0 <tag> CLIENTE password_esquemas@sid go! -v "
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
    print_banner_description "$DESCRIPCION"
    echo ""
    echo "Defina su variable de entorno ORACLE_HOME"
    echo ""
    exit
fi

CUSTOMER_IN_UPPERCASE=`echo $INPUT_PARAM_CLIENTE | tr '[:lower:]' '[:upper:]'`
CUSTOMER_IN_LOWERCASE=`echo $INPUT_PARAM_CLIENTE | tr '[:upper:]' '[:lower:]'`
OUTPUT_PROC_Y_VISTAS=$INPUT_PARAM_OUT_PROC_Y_VISTAS  # y (lo incluye) | n (no lo incluye)
OUTPUT_SCRIPTS=$INPUT_PARAM_OUT_SCRIPTS  # y (lo incluye) | n (no lo incluye)

print_banner

BASEDIR=$(dirname $0)

loadEnvironmentVariables ${CUSTOMER_IN_UPPERCASE} on

if [[ $OUTPUT_PROC_Y_VISTAS == "" ]]; then
    OUTPUT_PROC_Y_VISTAS=$FLAG_YES;
elif [[ $OUTPUT_PROC_Y_VISTAS != $FLAG_NO ]] && \
    [[ $OUTPUT_PROC_Y_VISTAS != $FLAG_YES ]]; then
    echo "   Parámetro salida out-proc_y_vistas erróneo. Valores permitidos: $FLAG_YES (defecto), $FLAG_NO!!"
    exit 1
fi
if [[ $OUTPUT_SCRIPTS == "" ]]; then
    OUTPUT_SCRIPTS=$FLAG_YES;
elif [[ $OUTPUT_SCRIPTS != $FLAG_NO ]] && \
    [[ $OUTPUT_SCRIPTS != $FLAG_YES ]]; then
    echo "   Parámetro salida out-scripts erróneo. Valores permitidos: $FLAG_YES (defecto), $FLAG_NO!!"
    exit 1
fi
COMPILE=0
if [[ "$INPUT_PARAM_OUT_COMPILE" == "$FLAG_YES" ]] ; then
	COMPILE=1
fi

mkdir -p $BASEDIR/tmp
rm -rf $BASEDIR/tmp/*.txt $BASEDIR/tmp/*.log $BASEDIR/tmp/*.sh $BASEDIR/tmp/*.bat $BASEDIR/tmp/*.sql $BASEDIR/tmp/**/*

DIRECTORIO=""
if [[ "$#" -ge 4 ]] && [[ "$INPUT_PARAM_GO" == "package!" ]] && [[ "$INPUT_PARAM_PASSWORD" != "null" ]]; then
    DIRECTORIO="$INPUT_PARAM_PASSWORD/"
fi

if [ "$INPUT_PARAM_TAG" != "null" ]; then

    #PRODUCTO

    if [ $OUTPUT_PROC_Y_VISTAS = $FLAG_YES ] && \
        [[ `find sql/**/producto/procs_y_vistas/ -name '*.sql' | wc -l` -ne 0 ]]; then
        for file in `git diff $INPUT_PARAM_TAG --name-only sql/**/producto/procs_y_vistas/*.sql`
        do
            filename=`basename $file`
            schema=`echo $filename | cut -d_ -f3`
            if [[ "$MULTIENTIDAD" != "" ]] && [[ ! $schema =~ ^MASTER$ ]] ; then
                IFS=',' read -a entidades <<< "$MULTIENTIDAD"
                for entidad in "${entidades[@]}"
                do
                    connectionParam=`getConnectionParam $file ${!entidad} $INPUT_PARAM_PASSWORD`
                    registerSQLScript $file $BASEDIR/tmp/product-list-from-tag-SPs.txt $connectionParam
                done
            else
                registerSQLScript $file $BASEDIR/tmp/product-list-from-tag-SPs.txt $INPUT_PARAM_PASSWORD
            fi
        done
    fi

    if [ $OUTPUT_SCRIPTS = $FLAG_YES ]; then
        for file in `git diff $INPUT_PARAM_TAG --name-only sql/**/producto/$DIRECTORIO*.sql`
        do
            filename=`basename $file`
            schema=`echo $filename | cut -d_ -f3`
            if [[ "$MULTIENTIDAD" != "" ]] && [[ ! $schema =~ ^MASTER$ ]] ; then
                IFS=',' read -a entidades <<< "$MULTIENTIDAD"
                for entidad in "${entidades[@]}"
                do
                    connectionParam=`getConnectionParam $file ${!entidad} $INPUT_PARAM_PASSWORD`
                    registerSQLScript $file $BASEDIR/tmp/product-list-from-tag.txt $connectionParam
                done
            else
                registerSQLScript $file $BASEDIR/tmp/product-list-from-tag.txt $INPUT_PARAM_PASSWORD
            fi
        done
    fi


    #CLIENTE
    if [ $OUTPUT_PROC_Y_VISTAS = $FLAG_YES ] && \
        [[ `find sql/**/$CUSTOMER_IN_LOWERCASE/procs_y_vistas/ -name '*.sql' | wc -l` -ne 0 ]]; then
        for file in `git diff $INPUT_PARAM_TAG --name-only sql/**/$CUSTOMER_IN_LOWERCASE/procs_y_vistas/*.sql`
        do
            filename=`basename $file`
            schema=`echo $filename | cut -d_ -f3`
            if [[ "$MULTIENTIDAD" != "" ]] && [[ ! $schema =~ ^MASTER$ ]] ; then
                IFS=',' read -a entidades <<< "$MULTIENTIDAD"
                for entidad in "${entidades[@]}"
                do
                    connectionParam=`getConnectionParam $file ${!entidad} $INPUT_PARAM_PASSWORD`
                    registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag-SPs.txt $connectionParam
                done
            else
                registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag-SPs.txt $INPUT_PARAM_PASSWORD
            fi
        done
    fi

    if [ $OUTPUT_SCRIPTS = $FLAG_YES ]; then
        for file in `git diff $INPUT_PARAM_TAG --name-only sql/**/$CUSTOMER_IN_LOWERCASE/$DIRECTORIO*.sql`
        do
            filename=`basename $file`
            schema=`echo $filename | cut -d_ -f3`
            if [[ "$MULTIENTIDAD" != "" ]] && [[ ! $schema =~ ^MASTER$ ]] ; then
                IFS=',' read -a entidades <<< "$MULTIENTIDAD"
                for entidad in "${entidades[@]}"
                do
                    connectionParam=`getConnectionParam $file ${!entidad} $INPUT_PARAM_PASSWORD`
                    registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt $connectionParam
                done
            else
                registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt $INPUT_PARAM_PASSWORD
            fi
        done
    fi
    
    #SUBCLIENTE EN CASO DE MULTIENTIDAD
    if [ "$MULTIENTIDAD" != "" ] ; then
        IFS=',' read -a entidades <<< "$MULTIENTIDAD"
        for entidad in "${entidades[@]}"
        do
            SUBENTITY=`echo $entidad | tr '[:upper:]' '[:lower:]'`

            if [ $OUTPUT_PROC_Y_VISTAS = $FLAG_YES ] && \
                [[ `find sql/**/$CUSTOMER_IN_LOWERCASE/$SUBENTITY/procs_y_vistas/ -name '*.sql' | wc -l` -ne 0 ]]; then
                for file in `git diff $INPUT_PARAM_TAG --name-only sql/**/$CUSTOMER_IN_LOWERCASE/$SUBENTITY/procs_y_vistas/*.sql`
                do
                    connectionParam=`getConnectionParam $file ${!entidad} $INPUT_PARAM_PASSWORD`
                    registerSQLScript $file $BASEDIR/tmp/customer-chapter-list-from-tag-SPs.txt $connectionParam
                done
            fi

            if [ $OUTPUT_SCRIPTS = $FLAG_YES ]; then
	            for file in `git diff $INPUT_PARAM_TAG --name-only sql/**/$CUSTOMER_IN_LOWERCASE/$SUBENTITY/$DIRECTORIO*.sql`
	            do
	                connectionParam=`getConnectionParam $file ${!entidad} $INPUT_PARAM_PASSWORD`
	                registerSQLScript $file $BASEDIR/tmp/customer-chapter-list-from-tag.txt $connectionParam
	            done
	        fi
        done
    fi
else
    for file in `cat SQLs-list.txt`
    do
        filename=`basename $file`
        schema=`echo $filename | cut -d_ -f3`
        if [[ "$MULTIENTIDAD" != "" ]] && [[ ! $schema =~ ^MASTER$ ]] ; then
            IFS=',' read -a entidades <<< "$MULTIENTIDAD"
            for entidad in "${entidades[@]}"
            do
                connectionParam=`getConnectionParam $file ${!entidad} $INPUT_PARAM_PASSWORD`
                registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt $connectionParam
            done
        else
            registerSQLScript $file $BASEDIR/tmp/customer-list-from-tag.txt $INPUT_PARAM_PASSWORD
        fi
    done    
fi
    
if [ -f $BASEDIR/tmp/product-list-from-tag.txt ] ; then
    cat $BASEDIR/tmp/product-list-from-tag.txt | sort > $BASEDIR/tmp/list-from-tag.txt
fi
if [ -f $BASEDIR/tmp/product-list-from-tag-SPs.txt ] ; then
    cat $BASEDIR/tmp/product-list-from-tag-SPs.txt | sort >> $BASEDIR/tmp/list-from-tag.txt
fi

if [ -f $BASEDIR/tmp/customer-list-from-tag.txt ] ; then
    cat $BASEDIR/tmp/customer-list-from-tag.txt | sort >> $BASEDIR/tmp/list-from-tag.txt
fi
if [ -f $BASEDIR/tmp/customer-list-from-tag-SPs.txt ] ; then
    cat $BASEDIR/tmp/customer-list-from-tag-SPs.txt | sort >> $BASEDIR/tmp/list-from-tag.txt
fi

if [ -f $BASEDIR/tmp/customer-chapter-list-from-tag.txt ] ; then
    cat $BASEDIR/tmp/customer-chapter-list-from-tag.txt | sort >> $BASEDIR/tmp/list-from-tag.txt
fi
if [ -f $BASEDIR/tmp/customer-chapter-list-from-tag-SPs.txt ] ; then
    cat $BASEDIR/tmp/customer-chapter-list-from-tag-SPs.txt | sort >> $BASEDIR/tmp/list-from-tag.txt
fi

if [ ! -f $BASEDIR/tmp/list-from-tag.txt ] ; then
    echo ""
    echo "No se encontraron scripts para los parámetros suministrados."
    exit 0
fi

if [[ "$#" -ge 4 ]] && [[ "$INPUT_PARAM_GO" == "go!" ]]; then

    while read -r line
    do
        if [[ "$INPUT_PARAM_VERBOSE" == "-v" ]]; then
			if [[ "$COMPILE" == "1" ]] ; then
				OPTION="-cv"
			else
				OPTION="-v"
			fi
            echo "--------------------------------------------------------------------------------"
            echo "$BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE $OPTION"
            $BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE $OPTION
            SALIDA_RUN_SINGLE_SCRIPT=$?
            echo "--------------------------------------------------------------------------------"
        else
			if [[ "$COMPILE" == "1" ]] ; then
				OPTION="-c"
			else
				OPTION=""
			fi
            $BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE $OPTION
            SALIDA_RUN_SINGLE_SCRIPT=$?
        fi
        if [[ $SALIDA_RUN_SINGLE_SCRIPT != 0 ]]; then
            echo -e "ERROR\n  ABORTADA EJECUCION POR #KO#"
            exit 1
        fi 
    done < $BASEDIR/tmp/list-from-tag.txt

elif [[ "$#" -ge 4 ]] && [[ "$INPUT_PARAM_GO" == "package!" ]]; then
	if [[ "$COMPILE" == "1" ]] ; then
		OPTION="-cp"
	else
		OPTION="-p"
	fi
    while read -r line
    do
        NEW_LINE=$line
        if [ "$MULTIENTIDAD" == "" ] ; then
            NEW_LINE=`echo $line | cut -d' ' -f1`
            NEW_LINE=$NEW_LINE' pass'
        fi
        $BASEDIR/run-single-script.sh $NEW_LINE $CUSTOMER_IN_UPPERCASE $OPTION
        SALIDA_RUN_SINGLE_SCRIPT=$?
        if [[ $SALIDA_RUN_SINGLE_SCRIPT != 0 ]]; then
            echo "ERROR"
            exit 1
        fi
    done < $BASEDIR/tmp/list-from-tag.txt
    mkdir -p $BASEDIR/tmp/package/DB/scripts/
    mkdir -p $BASEDIR/tmp/package/DDL/scripts/
    mkdir -p $BASEDIR/tmp/package/DML/scripts/
    passtring=''
    entities=0
    if [ "$MULTIENTIDAD" != "" ] ; then
        IFS=',' read -a entidades <<< "$MULTIENTIDAD"
        for index in "${!entidades[@]}"
        do
            passtring="$passtring ""entity0$((index+1))_pass@host:port\/sid"
            entities=$(($entities + 1))
        done        
    else
        passtring="entity01_pass@host:port\/sid"
        entities=$(($entities + 1))
    fi
    if [ $INPUT_PARAM_CLIENTE == 'BANKIA' ]; then
        cp $BASEDIR/scripts/DxL-scripts-BK.sh $BASEDIR/tmp/package/DDL/DDL-scripts.sh
    elif [ $INPUT_PARAM_CLIENTE == 'HAYA' ]; then
        entities=$(($entities + 2))
        sed -e s/#NUMBER#/"${entities}"/g $BASEDIR/scripts/DxL-scripts.sh > $BASEDIR/tmp/package/DDL/DDL-scripts.sh
        passtring="$passtring ""MINIREC_pass@host:port\/sid"
        sed -e s/#ENTITY#/"${passtring}"/g -i $BASEDIR/tmp/package/DDL/DDL-scripts.sh
    else
        entities=$(($entities + 1))
        sed -e s/#NUMBER#/"${entities}"/g $BASEDIR/scripts/DxL-scripts.sh > $BASEDIR/tmp/package/DDL/DDL-scripts.sh
        sed -e s/#ENTITY#/"${passtring}"/g -i $BASEDIR/tmp/package/DDL/DDL-scripts.sh
    fi
    cp $BASEDIR/scripts/DxL-scripts-one-user.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh
    if [ $CUSTOMER_IN_UPPERCASE == 'CAJAMAR' ] ; then
        echo $'\t'"export NLS_LANG=SPANISH_SPAIN.AL32UTF8" | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null
        echo $'\t'"export NLS_DATE_FORMAT=\"DD/MM/RR\"" | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null
        echo $'\t'"export NLS_TIMESTAMP_FORMAT=\"DD/MM/RR HH24:MI:SSXFF\"" | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null
    else
        echo $'\t'"export NLS_LANG=.AL32UTF8" | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null 
    fi
    cp $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DB/DB-scripts.sh
    cp $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DML/DML-scripts.sh
    cp $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh $BASEDIR/tmp/package/DML/DML-scripts-one-user.sh
    cp $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh $BASEDIR/tmp/package/DB/DB-scripts-one-user.sh

    chmod +x $BASEDIR/tmp/package/**/*.sh

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
                echo $'\t'"exit | sqlplus -s -l $ESQUEMA/\$2 @./scripts/DDL_000_$ESQUEMA.sql" >> $BASEDIR/tmp/package/DDL/DDL-scripts.sh
                echo $'\t'"exit | sqlplus -s -l \$1 @./scripts/DDL_000_$ESQUEMA.sql" >> $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh
            fi
        done
        cp $BASEDIR/tmp/DDL_000_*.sql $BASEDIR/tmp/package/DDL/scripts/
        cp $BASEDIR/tmp/DDL_000_*.sql $BASEDIR/tmp/package/DB/scripts/

        cat $BASEDIR/tmp/DDL-scripts.sh >> $BASEDIR/tmp/package/DDL/DDL-scripts.sh
        cat $BASEDIR/tmp/DDL-scripts-one-user.sh >> $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh

        if [[ $GENERATE_BAT == 'true' ]]; then
            cp $BASEDIR/tmp/DDL-scripts.bat $BASEDIR/tmp/package/DDL/
            cp $BASEDIR/tmp/DDL-scripts.bat $BASEDIR/tmp/package/DB/DB-scripts.bat
        fi

        cp -r $BASEDIR/tmp/DDL*reg*.sql $BASEDIR/tmp/package/DDL/scripts/
        cp -r $BASEDIR/tmp/DDL*reg*.sql $BASEDIR/tmp/package/DB/scripts/
        cp -r $BASEDIR/tmp/reg_check_compiled.sql $BASEDIR/tmp/package/DDL/scripts/
        cp -r $BASEDIR/tmp/reg_check_compiled.sql $BASEDIR/tmp/package/DB/scripts/

        cp $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DB/DB-scripts.sh
        cp $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh $BASEDIR/tmp/package/DB/DB-scripts-one-user.sh

        ending_script $INPUT_PARAM_TAG $INPUT_PARAM_CLIENTE | tee -a $BASEDIR/tmp/package/DDL/DDL-scripts.sh $BASEDIR/tmp/package/DDL/DDL-scripts-one-user.sh > /dev/null

        if [[ $UNIFIED_PACKAGE == 'false' ]]; then
            cd $BASEDIR/tmp/package
            zip --quiet DDL-scripts.zip -r DDL 
            cd - > /dev/null
        fi
    fi
    if [ -f $BASEDIR/tmp/DML-scripts.sh ] ; then
        ending_script $INPUT_PARAM_TAG $INPUT_PARAM_CLIENTE | tee -a $BASEDIR/tmp/DML-scripts.sh $BASEDIR/tmp/DML-scripts-one-user.sh > /dev/null
        cat $BASEDIR/tmp/DML-scripts.sh | tee -a $BASEDIR/tmp/package/DML/DML-scripts.sh $BASEDIR/tmp/package/DB/DB-scripts.sh > /dev/null
        cat $BASEDIR/tmp/DML-scripts-one-user.sh | tee -a $BASEDIR/tmp/package/DML/DML-scripts-one-user.sh $BASEDIR/tmp/package/DB/DB-scripts-one-user.sh > /dev/null
        if [[ $GENERATE_BAT == 'true' ]]; then
            cp $BASEDIR/tmp/DML-scripts.bat $BASEDIR/tmp/package/DML/
            cat $BASEDIR/tmp/DML-scripts.bat >> $BASEDIR/tmp/package/DB/DB-scripts.bat
        fi
        cp -r $BASEDIR/tmp/DML*reg*.sql $BASEDIR/tmp/package/DML/scripts/
        cp -r $BASEDIR/tmp/DML*reg*.sql $BASEDIR/tmp/package/DB/scripts/
        cp -r $BASEDIR/tmp/DML_000*.sql $BASEDIR/tmp/package/DML/scripts/
        cp -r $BASEDIR/tmp/DML_000*.sql $BASEDIR/tmp/package/DB/scripts/

        if [[ $UNIFIED_PACKAGE == 'false' ]]; then
            cd $BASEDIR/tmp/package
            zip --quiet DML-scripts.zip -r DML 
            cd - > /dev/null
        fi
    else
        ending_script $INPUT_PARAM_TAG $INPUT_PARAM_CLIENTE | tee -a $BASEDIR/tmp/package/DB/DB-scripts.sh $BASEDIR/tmp/package/DB/DB-scripts-one-user.sh > /dev/null
    fi     
    if [[ $UNIFIED_PACKAGE != 'false' ]]; then
        cd $BASEDIR/tmp/package
        zip --quiet DB-scripts.zip -r DB
        cd -
    fi
    echo ""
    echo "---------------------------------------------------"
    echo "---- EMPAQUETADOS PARA SOLICITUD DE DESPLIEGUE ----" 
    echo "---------------------------------------------------"
    echo ""
    echo `ls $BASEDIR/tmp/package/*.zip` 
    echo ""
    echo "Los scripts DDL y DML se empaquetan juntos o separados, según variable UNIFIED_PACKAGE en setEnvGlobal<CLIENTE>"
    echo "Por defecto, se empaquetan juntos" 
    echo ""
    echo "---------------------------------------------------"

else

	if [[ "$COMPILE" == "1" ]] ; then
		OPTION="-c"
	else
		OPTION=""
	fi
    echo ""
    echo "Lo que pretendo ejecutar es:"
    echo ""
    while read -r line
    do
        echo "$BASEDIR/run-single-script.sh $line $CUSTOMER_IN_UPPERCASE" $OPTION
    done < $BASEDIR/tmp/list-from-tag.txt
    echo ""
    echo "Si estás de acuerdo, añade go! como cuarto parámetro en la línea de comandos"
    echo ""
    echo "******************************************************************************************"

fi
