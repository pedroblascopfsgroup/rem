#!/bin/bash

if [ $# -ne 5 ]; then 
	echo "Uso: $0 <fichero-sentencias> <item-link> '<Descripcion>' <autor> <rama>"
	exit 1
fi;

#q'[]'
REPLACE_ESQUEMA="\]\' \|\| V_ESQUEMA \|\| q\'\[\."
REPLACE_MASTER="\]\' \|\| V_ESQUEMA_MASTER \|\| q\'\[\."
REPLACE_ESQUEMA2="${REPLACE_ESQUEMA}\1"

FICHERO=$1
TICKET=$2
DESCRIPCION="$3"
DESC_CORTA=`echo "$DESCRIPCION" | tr -d ' '`
AUTOR=$4
RAMA=$5
FECHA=`date +%Y%m%d`

parsear_cadena_replace()
{
   fichero=$1
   token=$2
   esquema=$3
   cadena_replace=$4
   sed -e "s/${token} ${esquema}/${token} ${cadena_replace}/" $fichero > auxiliar.txt  
   cp auxiliar.txt $fichero

}

parsear_simple()
{
   fichero=$1
   token=$2
   cadena_replace=$3
   sed -e "s/${token}/${cadena_replace}/" $fichero > auxiliar.txt  
   cp auxiliar.txt $fichero

}

cp $FICHERO resultado.txt

IN1="INTO;FROM;DELETE;UPDATE;SELECT;JOIN;into;from;delete;update;select;join"
IN2="HAYA;BANK;CM;REM;haya;bank;cm;rem"

IFS=';' read -ra ADDR1 <<< "$IN1"
for i in "${ADDR1[@]}"; do
	IFS=';' read -ra ADDR2 <<< "$IN2"
	for j in "${ADDR2[@]}"; do
        #echo "******************** $i" - "$j"
	    parsear_cadena_replace resultado.txt "$i" "${j}0[123]\." "$REPLACE_ESQUEMA"
		parsear_cadena_replace resultado.txt "$i" "${j}MASTER\." "$REPLACE_MASTER"
		parsear_cadena_replace resultado.txt "$i" "\([A-Z].\)" "$REPLACE_ESQUEMA2"
		parsear_cadena_replace resultado.txt "$i" "\([A-Z].\)" "$REPLACE_ESQUEMA2"
    done
done

cat resultado.txt | grep "[INSERT|DELETE|UPDATE|MERGE]" > auxiliar.txt
mv auxiliar.txt resultado.txt

SENTENCIA1="V_SQL := q'["
SENTENCIA2="]';\nEXECUTE IMMEDIATE V_SQL;\nDBMS_OUTPUT.PUT_LINE(' ... ' || RPAD(substr(V_SQL, 1, 60), 60, ' ') || ' ... registros afectados ...' || sql%rowcount);\n"

touch auxiliar.txt
oldIFS=$IFS     # conserva el separador de campo
IFS=$';'     # nuevo separador de campo, punto y coma
for linea in $(cat resultado.txt)
do
   linea=`echo "${linea}" | tr '\n' ' '`
   echo -e "${SENTENCIA1}${linea}${SENTENCIA2}" >> auxiliar.txt
done
IFS=$old_IFS     # restablece el separador de campo predeterminado

cp DMLPLANTILLA1.sql DML.sql
cat auxiliar.txt >> DML.sql
cat DMLPLANTILLA2.sql >> DML.sql

parsear_simple DML.sql "#AUTOR#" $AUTOR
parsear_simple DML.sql "#FECHA#" $FECHA
parsear_simple DML.sql "#RAMA#" $RAMA
parsear_simple DML.sql "#TICKET#" $TICKET
parsear_simple DML.sql "#DESCRIPCION#" $DESCRIPCION

mv DML.sql DML_999_ESQUEMA01_${TICKET}_${DESC_CORTA}.sql

rm auxiliar.txt resultado.txt
echo "Proceso de pitertulización finalizado correctamente: "
echo "*** FICHERO=$FICHERO"
echo "*** TICKET=$TICKET"
echo "*** DESCRIPCION=$DESCRIPCION"
echo "*** AUTOR=$AUTOR"
echo "*** RAMA=$RAMA"
echo "*** FECHA=$FECHA"
echo "Fichero resultante: " DML_999_ESQUEMA01_${TICKET}_${DESC_CORTA}.sql
exit 0
