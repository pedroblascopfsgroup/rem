#!/bin/bash
if [ "$ORACLE_HOME" == "" ] ; then
    echo "Debe ejecutar este shell desde un usuario que tenga permisos de ejecución de Oracle. Este usuario tiene ORACLE_HOME vacío"
    exit
fi
if [ "$#" -ne 5 ]; then
    echo "Parametros: bankmaster_pass@sid bank01_pass@sid minirec_pass@sid recovery_bankia_dwh@sid recovery_bankia_datastage_pass@sid"
    exit
fi
export NLS_LANG=.AL32UTF8
echo "INICIO DEL SCRIPT DE ACTUALIZACION $0"
cp registro_sqls.sh batch-2_10_11-pr-SQLs/DDL_001_BANK01_RERA_PRECAL_ARQUET_1.sh
cp *ESQUEMA*.sql batch-2_10_11-pr-SQLs
cd batch-2_10_11-pr-SQLs
echo "########################################################"  >> DDL_001_BANK01_RERA_PRECAL_ARQUET_1.log
echo "#####    INICIO batch-2_10_11-pr-SQLs/DDL_001_BANK01_RERA_PRECAL_ARQUET_1.sql (BANK01)"  >> DDL_001_BANK01_RERA_PRECAL_ARQUET_1.log
echo "########################################################"  >> DDL_001_BANK01_RERA_PRECAL_ARQUET_1.log
./DDL_001_BANK01_RERA_PRECAL_ARQUET_1.sh $2   >> DDL_001_BANK01_RERA_PRECAL_ARQUET_1.log
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @batch-2_10_11-pr-SQLs/DDL_001_BANK01_RERA_PRECAL_ARQUET_1.sql >> DDL_001_BANK01_RERA_PRECAL_ARQUET_1.log  ; fi
echo "########################################################"  >> DDL_001_BANK01_RERA_PRECAL_ARQUET_1.log
cd ..
cp registro_sqls.sh batch-2_10_11-pr-SQLs/DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.sh
cp *ESQUEMA*.sql batch-2_10_11-pr-SQLs
cd batch-2_10_11-pr-SQLs
echo "########################################################"  >> DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.log
echo "#####    INICIO batch-2_10_11-pr-SQLs/DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.sql (BANK01)"  >> DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.log
echo "########################################################"  >> DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.log
./DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.sh $2   >> DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.log
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @batch-2_10_11-pr-SQLs/DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.sql >> DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.log  ; fi
echo "########################################################"  >> DDL_002_BANK01_TMP_CNT_FIN_EXCEPCION.log
cd ..
cp registro_sqls.sh batch-2_10_11-pr-SQLs/DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.sh
cp *ESQUEMA*.sql batch-2_10_11-pr-SQLs
cd batch-2_10_11-pr-SQLs
echo "########################################################"  >> DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.log
echo "#####    INICIO batch-2_10_11-pr-SQLs/DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.sql (BANK01)"  >> DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.log
echo "########################################################"  >> DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.log
./DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.sh $2   >> DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.log
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @batch-2_10_11-pr-SQLs/DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.sql >> DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.log  ; fi
echo "########################################################"  >> DDL_003_BANK01_TMP_EXCEPCIONES_CONTRATOS.log
cd ..
cp registro_sqls.sh batch-2_10_11-pr-SQLs/DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.sh
cp *ESQUEMA*.sql batch-2_10_11-pr-SQLs
cd batch-2_10_11-pr-SQLs
echo "########################################################"  >> DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.log
echo "#####    INICIO batch-2_10_11-pr-SQLs/DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.sql (BANK01)"  >> DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.log
echo "########################################################"  >> DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.log
./DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.sh $2   >> DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.log
if [ $? != 0 ] ; then echo -e "\n\n======>>> "Error en @batch-2_10_11-pr-SQLs/DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.sql >> DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.log  ; fi
echo "########################################################"  >> DDL_004_BANK01_TMP_EXCEPCIONES_PERSONAS.log
cd ..
echo "########################################################"
echo "####### FICHEROS LOG COMPRIMIDOS EN EL FICHERO "$0.zip
echo "########################################################"
zip -r -q $0.zip *DDL*.log batch-2_10_11-pr-SQLs/*DDL*.log
