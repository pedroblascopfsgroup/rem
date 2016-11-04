#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Parametros: <CM01_pass@host:puerto/ORACLE_SID>"
    exit
fi


sql_dir="PRE_MIGRACION/"

echo "#################################################################"
echo "#####    INICIO PREVIAS
echo "#################################################################"

$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3101_REM_MIG2_ACT_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3102_REM_MIG2_OFR_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3103_REM_MIG2_AGR_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3101_REM_MIG2_ACT_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3102_REM_MIG2_OFR_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3103_REM_MIG2_AGR_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3104_REM_MIG2_TBJ_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3105_REM_MIG2_USU_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3106_REM_MIG2_DD_COD_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3107_REM_MIG2_GPV_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3108_REM_MIG2_CLC_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3109_REM_MIG2_EJE_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3110_REM_MIG2_PRO_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3111_REM_MIG2_ECO_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3112_REM_MIG2_PRP_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_3113_REM_MIG2_PVE_NOT_EXISTS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_9999_REM_MIG2_TRA_TRAMITES_OFERTAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2201_REM_MIG2_CLIENTE_COMERCIAL.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2202_REM_MIG2_VIS_VISITAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2203_REM_MIG2_OFR_OFERTAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2204_REM_MIG2_OFA_OFERTAS_ACTIVO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2205_REM_MIG2_COE_CONDICIONANTE_OFR_ACEP.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2206_REM_MIG2_RES_RESERVAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2207_REM_MIG2_OFR_TIA_TITULARES_ADI.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2208_REM_MIG2_COM_COMPRADORES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2209_REM_MIG2_CEX_COMPRADOR_EXPEDIENTE.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2210_REM_MIG2_GEX_GASTOS_EXPEDIENTE.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2211_REM_MIG2_OBF_OBSERVACIONES_OFERTAS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2212_REM_MIG2_FOR_FORMALIZACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2213_REM_MIG2_POS_POSICIONAMIENTO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2214_REM_MIG2_SUB_SUBSANACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2215_REM_MIG2_ACT_HEP_HIST_EST_PUBLI.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2216_REM_MIG2_ACT_COE_CONDICIONES_ESPEC.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2217_REM_MIG2_ACT_HVA_HIST_VALORACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2218_REM_MIG2_PRP_PROPUESTAS_PRECIOS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2219_REM_MIG2_ACT_PRP.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2221_REM_MIG2_PRD_PROVEEDOR_DIRECCION.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2223_REM_MIG2_GPV_GASTOS_PROVEEDORES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2224_REM_MIG2_GPV_ACT_TBJ.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2225_REM_MIG2_GDE_GASTOS_DET_ECONOMICO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2226_REM_MIG2_GGE_GASTOS_GESTION.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2227_REM_MIG2_GIM_GASTOS_IMPUGNACION.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2228_REM_MIG2_GIC_GASTOS_INFO_CONTABILIDAD.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2229_REM_MIG2_GPR_PROVISION_GASTOS.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2230_REM_MIG2_PAC_PERIMETRO_ACTIVO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2231_REM_MIG2_ACH_ACTIVOS_HITO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2232_REM_MIG2_ACT_ACTIVO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2233_REM_MIG2_ACQ_ACTIVO_ALQUILER.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2234_REM_MIG2_AGR_AGRUPACIONES.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2235_REM_MIG2_PRO_PROPIETARIO.sql
$ORACLE_HOME/bin/sqlplus "$1" @"$sql_dir"DDL_2236_REM_MIG2_PRH_PROPIETARIOS_HISTORICO.sql



echo "Fin CJM_RECOVERY-2021_MIGRACION_LIQUIDACIONES. Revise el fichero de log"
exit 0
