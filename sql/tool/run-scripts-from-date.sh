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
    echo "                 EJECUTA LOS SCRIPTS DE BD DESDE UNA FECHA DETERMINADA"
    echo ""
    echo "******************************************************************************************"
}

clear

if [ "$ORACLE_HOME" == "" ] ; then
    print_banner
    echo "Debe ejecutar este shell desde un usuario que tenga permisos de ejecución de Oracle. Este usuario tiene ORACLE_HOME vacío"
    echo "Como alternativa, para no tener que iniciar sesión con otro usuario, puede utilizar el comando:"
    echo ""
    echo "   $> su - otroUsuario -c 'comando'"
    echo ""
    echo "Por ejemplo"
    echo ""
    echo "   $> su - otroUsuario -c '$0 'YYYY-MM-DD HH:MM' [haya|bankia] password_esquema_principal@sid'"
    echo ""
    exit
fi

if [ "$#" -lt 3 ]; then
    print_banner
    echo ""
    echo "Para simular lo que vas a ejecutar, antes de hacerlo:"
    echo ""
    echo "   Uso: $0 'YYYY-MM-DD HH:MM' [haya|bankia] password_esquema_principal@sid"
    echo ""
    echo "Para ejecutarlo:"
    echo ""
    echo "   Uso: $0 'YYYY-MM-DD HH:MM' [haya|bankia] password_esquema_principal@sid go!"
    echo ""
    echo "******************************************************************************************"
    echo "******************************************************************************************"
    exit
fi

CUSTOMER_IN_UPPERCASE=`echo $2 | tr '[:lower:]' '[:upper:]'`
CUSTOMER_IN_LOWERCASE=`echo $2 | tr '[:upper:]' '[:lower:]'`

print_banner

BASEDIR=$(dirname $0)

rm -rf $BASEDIR/tmp/*.txt $BASEDIR/tmp/*.log $BASEDIR/tmp/*.sh

for directory in `find $BASEDIR/../ -mindepth 1 -maxdepth 1 -name '?\.*'`
do
    for file in `find $directory -maxdepth 4 -type f -name *.sql -newermt "$1"`
    do    
        HASH=`git rev-list HEAD $file | tail -n 1`    
        DATE=`git show -s --format="%ct" $HASH --`    
        printf "%s#%s \n" "$DATE" $file >> $BASEDIR/tmp/from-date-list-1.txt
    done
done

#cat $BASEDIR/tmp/from-date-list-1.txt | grep "producto\|$CUSTOMER_IN_LOWERCASE" | sort | cut -d# -f2 > $BASEDIR/tmp/from-date-list-2.txt
cat $BASEDIR/tmp/from-date-list-1.txt | grep "producto" | sort | cut -d# -f2 > $BASEDIR/tmp/from-date-list-2.txt
cat $BASEDIR/tmp/from-date-list-1.txt | grep "$CUSTOMER_IN_LOWERCASE" | sort | cut -d# -f2 >> $BASEDIR/tmp/from-date-list-2.txt

if [[ "$#" -eq 4 ]] && [[ "$4" == "go!" ]]; then
    while read -r line
    do
        echo "$BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE"
        $BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE
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
