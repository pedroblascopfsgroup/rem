#!/bin/bash +x

DIRECTORIO=$1
if [[ "$DIRECTORIO" == "" ]] ; then
	echo "Uso: $0 <directorio-git>"
	exit 1
fi

if [[ ! -d "$DIRECTORIO" ]] ; then
	echo "'$DIRECTORIO' no es un directorio."
	exit 1
fi

if [[ ! -d "${DIRECTORIO}/.git" ]] ; then
	echo "'$DIRECTORIO' no es un directorio que albergue un repositorio git."
	exit 1
fi

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

function paint_error() {
	declare -n error_data=$1
	echo -e "Control código PFS: ${RED}${error_data[name]}${NC}"
	echo -e "Fichero afectado: ${RED}${error_data[file]}${NC}"
	echo "Problema: ${error_data[problem]}"
	echo "Solución: ${error_data[solution]}"
	echo "**********************************************************"
}


function check_RIA_RULE_R1() {
	file_content=$1
	declare -A rule=(	[name]="RIA_RULE_R1"
						[file]=$f 
						[problem]="Estás intentando incorporar un debugger en la interface, es muy peligroso."
						[solution]="Elimina la instrucción 'debugger'" )

	r=$(echo $file_content | grep "debugger")
	if [[ "x" != "x$r" ]]; then
		paint_error rule
	fi
}

function check_RIA_RULE_R2() {
	file_content=$1
	declare -A rule=(	[name]="RIA_RULE_R2"
						[file]=$f 
						[problem]="Estás intentando poner comentarios HTML en una JSP."
						[solution]="Convierte tus comentarios <!-- --> en comentarios JSP <%-- --%> o preferiblemente elimina las líneas comentadas." )

	r=$(echo $file_content | grep "<\!--.*-->")
	if [[ "x" != "x$r" ]]; then
		paint_error rule
	fi
}

function check_RIA_RULE_R3() {
	file_content=$1
	regexp=",\s*(,|\]|\}|\)|(\<sec)(.*?)(\>),|(\<\/sec)(.*?)(\>)\s*(.*?)\s*(\<sec)(.*?)(\>),)"

	declare -A rule=(	[name]="RIA_RULE_R3"
						[file]=$f 
						[problem]="Estás intentando poner COMAS FURTIVAS en una JSP."
						[solution]="Revisa el siguiente enlace: https://link-doc.pfsgroup.es/confluence/x/CQDU.
Expresion regular para detectar comas furtivas: $regexp" )

	r=$(echo $file_content | sed 's/'"'"'.*'"'"'/_string_/g' \
                  | sed 's/".*"/_string_/g' \
                  | sed 's/replace(.*\,.*)/_regexp_/g' \
                  | grep -Pzo "$regexp")

	if [[ "x" != "x$r" ]]; then
		paint_error rule
	fi
}

function check_RIA_RULE_R4() {
	file_content=$1
	declare -A rule=(	[name]="RIA_RULE_R4"
						[file]=$f 
						[problem]="Esta expresión es problemática para IExplorer 'border:false'."
						[solution]="Reemplaza esta expresión por 'border:0px'." )

	r=$(echo $file_content | grep -E "border(\s*):(\s*)false")
	if [[ "x" != "x$r" ]]; then
		paint_error rule
	fi
}

function check_RIA_RULE_R5() {
	file_content=$1
	declare -A rule=(	[name]="RIA_RULE_R5"
						[file]=$f 
						[problem]="Esta expresión es problemática para IExplorer 'renderer:app.format.dateRenderer,'."
						[solution]="Reemplaza esta expresión por su equivalente en el JSON o Dto original." )

	r=$(echo $file_content | grep -E "renderer(\s*):(\s*)app.format.dateRenderer,")
	if [[ "x" != "x$r" ]]; then
		paint_error rule
	fi
}

function check_UTF8() {
	file=$1
	declare -A rule=(	[name]="Encodig (UTF-8/ASCII)"
						[file]=$file 
						[problem]="El fichero no está en formato correcto UTF-8 o ASCII."
						[solution]="Convierte el encoding del fichero a u UTF8." )

	encoding=`file -i $file | cut -f 2 -d";" | cut -f 2 -d=`
	if [ $encoding != "utf-8" ] &&  [ $encoding != "us-ascii" ]; then
		paint_error rule
	fi

}

function check_pitertul_format() {
	file_content=$1
	declare -A rule=(	[name]="Pitertul format"
						[file]=$f
						[problem]="El fichero no está en formato correcto para PITERTUL."
						[solution]="Puedes encontrar ayuda en https://link-doc.pfsgroup.es/confluence/display/TEC/PITERTUL%3A+making+of"
					)
	# Completa: r=$(cat $f | tr '\n' ' ' | grep -E -i "\sWHENEVER\sSQLERROR\sEXIT\sSQL\.SQLCODE(;|)\sSET\sSERVEROUTPUT\sON(;|)(\s*SET\sDEFINE\sOFF(;|)|)\s*(DECLARE(.*)\s*BEGIN|)\s*(.*)EXCEPTION(.*)ROLLBACK;\s*RAISE;\s*END(.*);\s*\/\s*EXIT(;|)\s*$")
	r=$(cat $f | tr '\n' ' ' | grep -E -i "WHENEVER\sSQLERROR\sEXIT\sSQL\.SQLCODE(;|)\sSET\sSERVEROUTPUT\sON(;|)(\s*SET\sDEFINE\sOFF(;|)|)\s*(DECLARE(.*)\s*BEGIN|)\s*(.*)(END(.*);\s*|)\/\s*EXIT(;|)\s*$")
	if [[ "x" == "x$r" ]]; then
		paint_error rule
	fi

}

# ***************************
# Control en RIA
# ***************************
function JSP_rules() {
	echo -e "${GREEN}REVISANDO FICHEROS jsp${NC}\n**********************************************************"
	ficheros_jsp=`find $DIRECTORIO -regex ".*\.jsp"`
	
	for f in $ficheros_jsp; do
		
		file_content=$(cat $f);

		# R1-RIA. Control de debugger en JSPs
		check_RIA_RULE_R1 "$file_content"
		# R2-RIA.  Control de comentarios en JSPs
		check_RIA_RULE_R2 "$file_content"
		# R3-RIA.  Control de comas furtivas
		check_RIA_RULE_R3 "$file_content"
		# R4-RIA.  Control de reglas border:false (desactivada)
		#check_RIA_RULE_R4 "$file_content"
		# R5-RIA.  Control de reglas dateRenderer()
		check_RIA_RULE_R5 "$file_content"
	done
}

# ***************************
# Control en JS y SQL
# ***************************
function JS_rules() {
	echo -e "${GREEN}REVISANDO FICHEROS js${NC}\n**********************************************************"
	ficheros_js=`find $DIRECTORIO -regex ".*\.js"`
	for f in $ficheros_js ; do
		
		file_content=$(cat $f);

		# R1-RIA. Control de debugger en JSPs
		check_RIA_RULE_R1 "$file_content"
		# R3-RIA.  Control de comas furtivas
		check_RIA_RULE_R3 "$file_content"
	done
}

function SQL_rules() {
	echo -e "${GREEN}REVISANDO FICHEROS sql${NC}\n**********************************************************"
	ficheros_sql=`find $DIRECTORIO -regex ".*\.sql" | grep -e "$DIRECTORIO\/sql/" | grep  -E \/D.*\.sql$ | grep -v ^reports/ | grep -v migracion | grep -v scripts | grep -v templates | grep -v rutinas  | grep -v produccion`
	for f in $ficheros_sql ; do
		file_content=$(cat $f);
		check_UTF8 $f

		# Comprueba formato de Pitertul
		check_pitertul_format "$file_content"
	done
}

function PROPERTIES_rules() {
	echo -e "${GREEN}REVISANDO FICHEROS properties${NC}\n**********************************************************"
	ficheros_properties=`find $DIRECTORIO -regex ".*\.properties"`
	for f in $ficheros_properties ; do
		check_UTF8 $f
	done
}

########################################################
##### MAIN
########################################################

JSP_rules
JS_rules
SQL_rules
PROPERTIES_rules

exit 0;
