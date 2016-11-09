#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi

sql_dir="DMLs_REM_MIGRATION/"

echo "#################################################################"
echo "#####    INICIO POSTERIOR #######################################"
echo "#################################################################"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2401_REM_MIG2_CLIENTES_COMERCIALES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2402_REM_MIG2_VIS_VISITAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2403_REM_MIG2_OFR_OFERTAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2404_REM_MIG2_OFERTAS_ACTIVO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2405_REM_MIG2_COE_CONDICIONAN_OFR_ACEP.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2406_REM_MIG2_RES_RESERVAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2407_REM_MIG2_OFR_TIA_TITULARES_ADI.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2408_REM_MIG2_COM_COMPRADORES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2409_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2410_REM_MIG2_GEX_GASTOS_EXPEDIENTE.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2411_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2412_REM_MIG2_FOR_FORMALIZACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2413_REM_MIG2_POS_POSICIONAMIENTO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2414_REM_MIG2_SUB_SUBSANACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2415_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2416_REM_MIG2_ACT_COE_CONDICION_ESPECIFICA.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2417_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2418_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2419_REM_MIG2_ACT_PRP.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2421_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2423_REM_MIG2_GPV_GASTOS_PROVEEDOR.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2424_REM_MIG2_GPV_ACT_TBJ.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2425_REM_MIG2_GDE_GASTOS_DET_ECONOMICO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2426_REM_MIG2_GGE_GASTOS_GESTION.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2427_REM_MIG2_GIM_GASTOS_IMPUGNACION.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2428_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2429_REM_MIG2_GPR_PROVISION_GASTOS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2430_REM_MIG2_ACT_PAC_PERIMETRO_ACTIVO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2432_REM_MIG2_ACT_ACTIVO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2433_REM_MIG2_ACQ_ACTIVO_ALQUILER.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2434_REM_MIG2_AGR_AGRUPACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_2435_REM_MIG2_PRO_PROPIETARIOS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DML_9999_REM_MIG2_TRA_TRAMITES_ACTIVOS.sql



echo "Fin POSTERIOR. Revise el fichero de log"
exit 0
