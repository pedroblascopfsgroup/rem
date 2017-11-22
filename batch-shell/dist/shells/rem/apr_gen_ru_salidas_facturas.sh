#!/bin/bash
# Generado por GUSTAVO MORA 20170810
 


filename=$(basename $0)
nameETL="${filename%.*}"

export DIR_ETL=$DIR_BASE_ETL/$nameETL
export DIR_CONFIG=$DIR_BASE_ETL/config/
export CFG_FILE=config.ini
export MAINSH="$nameETL"_run.sh

cd "$DIR_ETL" &> /dev/null
if [ $? -ne 0 ] ; then
   echo "$(basename $0) Error en $filename: directorio inexistente $DIR_ETL"
   exit 1
fi

if [ -f $MAINSH ]; then
    CLASS="$(cat $MAINSH | grep "^ java" | cut -f10 -d" ")"
    CLASS2=`echo $CLASS | sed -e 's/$ROOT_PATH/./g'`
    CLASEINICIO="$(cat $MAINSH | grep "^ java" | cut -f11 -d" ")"
    java -Xms512M -Xmx1536M -Dconfig.dir=$DIR_CONFIG -Dconfig.file.mask=$CFG_FILE -Duser.country=ES -Duser.language=es -cp $CLASS2 $CLASEINICIO --context=Default "$@"
    
    
if [ $? = 0 ]; then
echo "Inicio de transferencia ficheros RUFACTUCP.txt/RUFACTUSP.txt"
   lftp -c "open -u rm02,R@95pr12 sftp://10.126.128.130; ls /$1"
   if [ $? -ne 0 ]; then
      lftp -c "open -u rm02,R@95pr12 sftp://10.126.128.130; mkdir /$1"
   fi

  lftp -u rm02,R@95pr12 sftp://10.126.128.130 <<EOF
  cd /$1/
  mput $DIR_SALIDA/RUFACTUCP.txt
  mput $DIR_SALIDA/RUFACTUSP.txt 
  bye
EOF

  exit 0    
fi    
else
    echo "$(basename $0) Error en $filename: no se ha encontrado  $MAINSH"
    exit 1
fi

