#!/bin/bash +x
#
# Params:
#    $1: full path of script 
#
function checkScriptFormat() {
    INPUT_PARAM_FULL_PATH=$1
    filename=`basename $INPUT_PARAM_FULL_PATH`
    if [[ ! $INPUT_PARAM_FULL_PATH =~ ^.*procs_y_vistas.*$ ]] ; then
        if [[ ! $filename =~ ^D[MD]L_[0-9]+_[^_]+_[^\.]+\.sql$ ]] ; then
            echo "ERROR"
            echo "  El nombre del script $INPUT_PARAM_FULL_PATH no sigue la nomenclatura definida"
            echo "  Consulta sql/pitertul/templates para ver un ejemplo de plantilla"
            exit 1
        fi
        grep -Fqi "WHENEVER SQLERROR" $INPUT_PARAM_FULL_PATH
        if [[ $? != 0 ]] ; then
            echo "ERROR"
            echo "  El script $INPUT_PARAM_FULL_PATH no contiene la primera línea de control de errores: WHENEVER SQLERROR ..."
            echo "  Consulta sql/pitertul/templates para ver un ejemplo de plantilla"
            exit 1
        fi
    else
        if [[ ! $filename =~ ^DDL_[0-9]+_[^_]+_(SP|MV|VI)_[^\.]+\.sql$ ]] ; then
            echo "ERROR"
            echo "El nombre del script $INPUT_PARAM_FULL_PATH no sigue la nomenclatura definida"
            echo "  DDL_xxx_ENTITY01_[SP|MV|VI]_nombreObjetoBBDD.sql"
            exit 1
        fi
    fi

    # Encoding
    encoding=`file -i $INPUT_PARAM_FULL_PATH | cut -f 2 -d";" | cut -f 2 -d=`
    if [ $encoding != "utf-8" ] && [ $encoding != "us-ascii" ]; then
        echo "ERROR"
        echo "  El script $INPUT_PARAM_FULL_PATH no está en UTF-8"
        exit 1
    fi

    #rCompleto=$(cat $INPUT_PARAM_FULL_PATH | tr '\n' ' ' | grep -E -i "\sWHENEVER\sSQLERROR\sEXIT\sSQL\.SQLCODE(;|)\sSET\sSERVEROUTPUT\sON(;|)(\s*SET\sDEFINE\sOFF(;|)|)\s*(DECLARE(.*)\s*BEGIN|)\s*(.*)EXCEPTION(.*)ROLLBACK;\s*RAISE;\s*END(.*);\s*\/\s*EXIT(;|)\s*$");
    #rSinSetDefineOff=$(cat $INPUT_PARAM_FULL_PATH | tr '\n' ' ' | grep -E -i "\sWHENEVER\sSQLERROR\sEXIT\sSQL\.SQLCODE;\sSET\sSERVEROUTPUT\sON;(\s*SET\sDEFINE\sOFF;|)\s*(DECLARE(.*)\s*BEGIN|)\s*(.*)EXCEPTION(.*)ROLLBACK;\s*RAISE;\s*END(.*);\s*\/\s*EXIT(;|)\s*$");
    r=$(cat $INPUT_PARAM_FULL_PATH | tr '\n' ' ' | grep -E -i "WHENEVER\sSQLERROR\sEXIT\sSQL\.SQLCODE(;|)\sSET\sSERVEROUTPUT\sON(;|)(\s*SET\sDEFINE\sOFF(;|)|)\s*(DECLARE(.*)\s*BEGIN|)\s*(.*)(END(.*);\s*|)\/\s*EXIT(;|)\s*$");
    if [[ "x" == "x$r" ]]; then
        echo "ERROR"
        echo "El script $INPUT_PARAM_FULL_PATH no cumple el formato PITERTUL"
        echo "Puedes encontrar una plantilla en https://link-doc.pfsgroup.es/confluence/display/TEC/PITERTUL%3A+making+of";
        #exit 1
    fi

}
