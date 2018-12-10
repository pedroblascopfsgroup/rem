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
RAMA=`echo "$5" | sed -e "s|origin\/||g"`
FECHA=`date +%Y%m%d`

parsear_cadena_replace()
{
   fichero=$1
   token=$2
   esquema=$3
   cadena_replace=$4
   sed -e "s/${token} ${esquema}/${token} ${cadena_replace}/gI" $fichero > auxiliar.txt  
   cp auxiliar.txt $fichero

}

parsear_simple()
{
   fichero=$1
   token=$2
   cadena_replace=$3
   sed -e "s/${token}/${cadena_replace}/g" $fichero > auxiliar.txt  
   cp auxiliar.txt $fichero

}

#Copiamos el fichero y eliminamos los saltos de linea
sed -e ':a;N;$!ba;s/\n/ /g' $FICHERO > resultado.txt
sed -e 's/;/;\n/g' resultado.txt > resultado2.txt
mv resultado2.txt resultado.txt

#Tratamiento de secuencias
parsear_simple resultado.txt ",\s*s_\(.*\)\.nextval" ", \]\' \|\| V_ESQUEMA \|\| q\'\[\.s_\1\.nextval"
parsear_simple resultado.txt ",\s*HAYA0[12345]\.s_\(.*\)\.nextval" ", \]\' \|\| V_ESQUEMA \|\| q\'\[\.s_\1\.nextval"
parsear_simple resultado.txt ",\s*BANK01\.s_\(.*\)\.nextval" ", \]\' \|\| V_ESQUEMA \|\| q\'\[\.s_\1\.nextval"
parsear_simple resultado.txt ",\s*CM01\.s_\(.*\)\.nextval" ", \]\' \|\| V_ESQUEMA \|\| q\'\[\.s_\1\.nextval"
parsear_simple resultado.txt ",\s*REM01\.s_\(.*\)\.nextval" ", \]\' \|\| V_ESQUEMA \|\| q\'\[\.s_\1\.nextval"

IN1="INTO;FROM;DELETE;UPDATE;JOIN;into;from;delete;update;join"
IN2="HAYA;BANK;CM;REM;haya;bank;cm;rem"

IFS=';' read -ra ADDR1 <<< "$IN1"
for i in "${ADDR1[@]}"; do
	IFS=';' read -ra ADDR2 <<< "$IN2"
	for j in "${ADDR2[@]}"; do
	    parsear_cadena_replace resultado.txt "$i" "${j}0[12345]\." "$REPLACE_ESQUEMA"
	    parsear_cadena_replace resultado.txt "$i" "${j}MASTER\." "$REPLACE_MASTER"
	    parsear_cadena_replace resultado.txt "$i" "${j}master\." "$REPLACE_MASTER"
		parsear_cadena_replace resultado.txt "$i" "\([A-Z].\)" "$REPLACE_ESQUEMA2"
		parsear_cadena_replace resultado.txt "$i" "\([A-Z].\)" "$REPLACE_ESQUEMA2"
    done
done

cat resultado.txt | grep "[INSERT|DELETE|UPDATE|MERGE|insert|delete|update|merge]" > auxiliar.txt
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

mv DML.sql DML_999_ENTITY01_${TICKET}_${DESC_CORTA}.sql

rm auxiliar.txt resultado.txt
echo "Proceso de pitertulización finalizado correctamente: "
echo "*** FICHERO=$FICHERO"
echo "*** TICKET=$TICKET"
echo "*** DESCRIPCION=$DESCRIPCION"
echo "*** AUTOR=$AUTOR"
echo "*** RAMA=$RAMA"
echo "*** FECHA=$FECHA"
echo "Fichero resultante: " DML_999_ENTITY01_${TICKET}_${DESC_CORTA}.sql
exit 0
