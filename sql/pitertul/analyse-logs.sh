#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Parámetros: filename"
    exit 1
fi
extension="${1##*.}"
directory="labspace"

rm -rf labspace
mkdir labspace
if [ $extension == "zip" ]; then
    unzip -q $1 -d labspace
else
    tar xfv $1 -C labspace
    directory="labspace/DB"
fi

last_scriptname=""
while read -r line; do 
    result=`echo $line | cut -d: -f1 | xargs`
    scriptname=`echo $line | cut -d: -f2 | xargs`
    if [[ $scriptname =~ ^DDL.*$ ]]; then

        scriptname=`echo $scriptname | cut -d. -f1`
        if [[ $last_scriptname != $scriptname ]]; then
            echo "[INFO] Analizando snapshots de "$scriptname
            last_scriptname=$scriptname
            for file in `ls $directory/DB_SNAPSHOT_PREV_objects_*_${scriptname}.log`; 
            do
                schema=`echo $file | cut -d_ -f5`
                diff $directory/DB_SNAPSHOT_PREV_objects_${schema}_${scriptname}.log $directory/DB_SNAPSHOT_POST_objects_${schema}_${scriptname}.log > $directory/objectsdiff.log
                while read -r line; do
                    if [[ $line =~ ^\<.*$ ]]; then
                        objecttype=`echo $line | cut -d' ' -f3`
                        objectname=`echo $line | cut -d' ' -f4`
                        echo ";"$schema";"$objecttype";"$objectname";*;*;"${scriptname}".sql;" >> $directory/rmmetadata.log
                    elif [[ $line =~ ^\>.*$ ]]; then
                        objecttype=`echo $line | cut -d' ' -f3`
                        objectname=`echo $line | cut -d' ' -f4`
                        echo ";"$schema";"$objecttype";"$objectname";*;*;"${scriptname}".sql;" >> $directory/newmetadata.log
                    fi
                done < $directory/objectsdiff.log
            done

            for file in `ls $directory/DB_SNAPSHOT_PREV_tables_*_${scriptname}.log`; 
            do
                schema=`echo $file | cut -d_ -f5`
                diff $directory/DB_SNAPSHOT_PREV_tables_${schema}_${scriptname}.log $directory/DB_SNAPSHOT_POST_tables_${schema}_${scriptname}.log > $directory/tablesdiff.log
                while read -r line; do
                    if [[ $line =~ ^\<.*$ ]]; then
                        tablename=`echo $line | cut -d' ' -f3`
                        tablecolumnname=`echo $line | cut -d' ' -f4`
                        tablecolumntype=`echo $line | cut -d' ' -f5-`
                        numreg=`grep "\s$tablename\s" $directory/tablesdiff.log | grep "\s$tablecolumnname\s" | wc -l`
                        if [ $numreg -eq 1 ]; then
                            echo ";$schema;$tablename;$tablecolumnname;*;${tablecolumntype};${scriptname}.sql;" >> $directory/rmmetadata.log
                        fi
                    elif [[ $line =~ ^\>.*$ ]]; then
                        tablename=`echo $line | cut -d' ' -f3`
                        tablecolumnname=`echo $line | cut -d' ' -f4`
                        tablecolumntype=`echo $line | cut -d' ' -f5-`
                        numreg=`grep "\s$tablename\s" $directory/tablesdiff.log | grep "\s$tablecolumnname\s" | wc -l`
                        if [ $numreg -eq 1 ]; then
                            echo ";$schema;COLUMNA;${tablename}.${tablecolumnname};*;${tablecolumntype};${scriptname}.sql;" >> $directory/newmetadata.log
                        else
                            oldline=`grep "\s$tablename\s" $directory/tablesdiff.log | grep "\s$tablecolumnname\s" | grep "<"`
                            oldtablecolumntype=`echo $oldline | cut -d' ' -f5-`
                            echo ";$schema;COLUMNA;${tablename}.${tablecolumnname};$oldtablecolumntype;$tablecolumntype;${scriptname}.sql;" >> $directory/changedtablesinfo.log
                        fi
                    fi
                done < $directory/tablesdiff.log
            done
        fi
    fi
done < $directory/output.log

echo ";ESQUEMA;TIPO OBJETO;NOMBRE OBJETO;TIPO ANTERIOR;NUEVO TIPO;SCRIPT;" > $directory/final-report.csv
if [ -e $directory/newmetadata.log ]; then
    echo "OBJETOS NUEVOS" >> $directory/final-report.csv
    cat $directory/newmetadata.log >> $directory/final-report.csv
fi
if [ -e $directory/rmmetadata.log ]; then
    echo "OBJETOS ELIMINADOS" >> $directory/final-report.csv
    cat $directory/rmmetadata.log >> $directory/final-report.csv
fi
if [ -e $directory/changedtablesinfo.log ]; then
    echo "OBJETOS MODIFICADOS" >> $directory/final-report.csv
    cat $directory/changedtablesinfo.log >> $directory/final-report.csv
fi
sed -e 's/\r//g' -i $directory/final-report.csv
echo "[INFO] Generado fichero $directory/final-report.csv"
