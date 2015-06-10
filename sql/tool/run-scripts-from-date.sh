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

if [ "$#" -lt 4 ]; then
    print_banner
    echo ""
    echo "Para simular antes de ejecutar:"
    echo ""
    echo "   Uso: $0 'YYYY-MM-DD HH:MM' [haya|bankia] password_esquema_principal@sid user_con_Oracle"
    echo ""
    echo "Para ejecutarlo:"
    echo ""
    echo "   Uso: $0 'YYYY-MM-DD HH:MM' [haya|bankia] password_esquema_principal@sid user_con_Oracle go!"
    echo ""
    echo "Ojo! Hasta que se corrija, si el usuario que tiene la instalación de Oracle no es el usuario con el que usas Git,"
    echo "tendrás que hacer lo siguiente para que no te pida la contraseña con cada ejecución (visudo):"
    echo ""
    echo "  user_con_Oracle ALL=(usuario) NOPASSWD: $(dirname $0)/$0"
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



if [[ "$#" -eq 5 ]] && [[ "$5" == "go!" ]]; then
    while read -r line
    do
        echo "$BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE"
        if [[ `whoami` == $4 ]]; then
            $BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE
        else 
            sudo -u $4 "$BASEDIR/run-single-script.sh $line $3 $CUSTOMER_IN_UPPERCASE"
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
