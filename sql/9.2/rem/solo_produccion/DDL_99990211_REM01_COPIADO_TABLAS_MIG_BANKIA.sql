--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-3577
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de copiado de tablas de MIG_BANKIA
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ERR_NUM NUMBER;-- Numero de errores
  ERR_MSG VARCHAR2(2048);-- Mensaje de error

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Copiado de tablas MIGRACION BANKIA en REM.');

    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ADJ_JUDICIAL_BK AS SELECT * FROM #ESQUEMA#.MIG_ADJ_JUDICIAL';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ADJ_NO_JUDICIAL_BK AS SELECT * FROM #ESQUEMA#.MIG_ADJ_NO_JUDICIAL';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ACA_CABECERA_BK AS SELECT * FROM #ESQUEMA#.MIG_ACA_CABECERA';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ADA_DATOS_ADI_BK AS SELECT * FROM #ESQUEMA#.MIG_ADA_DATOS_ADI';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_APL_PLANDINVENTAS_BK AS SELECT * FROM #ESQUEMA#.MIG_APL_PLANDINVENTAS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_APC_PRECIO_BK AS SELECT * FROM #ESQUEMA#.MIG_APC_PRECIO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_ACT_PRP_BK AS SELECT * FROM #ESQUEMA#.MIG2_ACT_PRP';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_ACT_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG2_ACT_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_ACQ_ACTIVO_ALQUILER_BK AS SELECT * FROM #ESQUEMA#.MIG2_ACQ_ACTIVO_ALQUILER';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_ACH_ACTIVOS_HITO_BK AS SELECT * FROM #ESQUEMA#.MIG2_ACH_ACTIVOS_HITO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ATI_TITULO_BK AS SELECT * FROM #ESQUEMA#.MIG_ATI_TITULO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ADD_ADMISION_DOC_BK AS SELECT * FROM #ESQUEMA#.MIG_ADD_ADMISION_DOC';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_AGR_AGRUPACIONES_BK AS SELECT * FROM #ESQUEMA#.MIG2_AGR_AGRUPACIONES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AAA_AGRUPACION_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG_AAA_AGRUPACION_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AAG_AGRUPACIONES_BK AS SELECT * FROM #ESQUEMA#.MIG_AAG_AGRUPACIONES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ACA_CALIDADES_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG_ACA_CALIDADES_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ACA_CARGAS_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG_ACA_CARGAS_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ACA_CATASTRO_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG_ACA_CATASTRO_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_CLC_CLIENTE_COMERCIAL_BK AS SELECT * FROM #ESQUEMA#.MIG2_CLC_CLIENTE_COMERCIAL';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GEX_GASTOS_EXPEDIENTE_BK AS SELECT * FROM #ESQUEMA#.MIG2_GEX_GASTOS_EXPEDIENTE';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_COM_COMPRADORES_BK AS SELECT * FROM #ESQUEMA#.MIG2_COM_COMPRADORES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_CEX_COMPRADOR_EXPEDIEN_BK AS SELECT * FROM #ESQUEMA#.MIG2_CEX_COMPRADOR_EXPEDIENTE';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_CPC_PROP_CABECERA_BK AS SELECT * FROM #ESQUEMA#.MIG_CPC_PROP_CABECERA';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_ACT_COE_CONDICION_ESPE_BK AS SELECT * FROM #ESQUEMA#.MIG2_ACT_COE_CONDICIONES_ESPEC';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_COE_CONDICIONA_OFR_ACP_BK AS SELECT * FROM #ESQUEMA#.MIG2_COE_CONDICIONAN_OFR_ACEP';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GDE_GASTOS_DET_ECONOMI_BK AS SELECT * FROM #ESQUEMA#.MIG2_GDE_GASTOS_DET_ECONOMICO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AEP_ENTIDAD_PROVEEDOR_BK AS SELECT * FROM #ESQUEMA#.MIG_AEP_ENTIDAD_PROVEEDOR';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_FOR_FORMALIZACIONES_BK AS SELECT * FROM #ESQUEMA#.MIG2_FOR_FORMALIZACIONES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GIM_GASTOS_IMPUGNACION_BK AS SELECT * FROM #ESQUEMA#.MIG2_GIM_GASTOS_IMPUGNACION';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GIC_GASTOS_INFO_CONTAB_BK AS SELECT * FROM #ESQUEMA#.MIG2_GIC_GASTOS_INFO_CONTABI';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GPV_ACT_TBJ_BK AS SELECT * FROM #ESQUEMA#.MIG2_GPV_ACT_TBJ';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GPV_GASTOS_PROVEEDORES_BK AS SELECT * FROM #ESQUEMA#.MIG2_GPV_GASTOS_PROVEEDORES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GPR_PROVISION_GASTOS_BK AS SELECT * FROM #ESQUEMA#.MIG2_GPR_PROVISION_GASTOS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GGE_GASTOS_GESTION_BK AS SELECT * FROM #ESQUEMA#.MIG2_GGE_GASTOS_GESTION';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GEA_GESTORES_ACTIVOS_BK AS SELECT * FROM #ESQUEMA#.MIG2_GEA_GESTORES_ACTIVOS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GEO_GESTORES_OFERTAS_BK AS SELECT * FROM #ESQUEMA#.MIG2_GEO_GESTORES_OFERTAS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_GRU_GRUPOS_USUARIOS_BK AS SELECT * FROM #ESQUEMA#.MIG2_GRU_GRUPOS_USUARIOS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_ACT_HVA_HIST_VALORACIO_BK AS SELECT * FROM #ESQUEMA#.MIG2_ACT_HVA_HIST_VALORACIONES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_ACT_HEP_HIST_EST_PUBLI_BK AS SELECT * FROM #ESQUEMA#.MIG2_ACT_HEP_HIST_EST_PUBLI';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AIA_INFCOMERCIAL_ACT_BK AS SELECT * FROM #ESQUEMA#.MIG_AIA_INFCOMERCIAL_ACT';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AID_INFCOMERCIAL_DISTR_BK AS SELECT * FROM #ESQUEMA#.MIG_AID_INFCOMERCIAL_DISTR';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ALA_LLAVES_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG_ALA_LLAVES_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AML_MOVIMIENTOS_LLAVE_BK AS SELECT * FROM #ESQUEMA#.MIG_AML_MOVIMIENTOS_LLAVE';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AOA_OBSERVACIONES_ACTIV_BK AS SELECT * FROM #ESQUEMA#.MIG_AOA_OBSERVACIONES_ACTIVOS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_AOA_OBSERVACION_AGRUP_BK AS SELECT * FROM #ESQUEMA#.MIG_AOA_OBSERVACION_AGRUP';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_OFA_OFERTAS_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG2_OFA_OFERTAS_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_OFR_OFERTAS_BK AS SELECT * FROM #ESQUEMA#.MIG2_OFR_OFERTAS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_OBF_OBSERVACIONES_OFER_BK AS SELECT * FROM #ESQUEMA#.MIG2_OBF_OBSERVACIONES_OFERTAS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_PAC_PERIMETRO_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG2_PAC_PERIMETRO_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_POS_POSICIONAMIENTO_BK AS SELECT * FROM #ESQUEMA#.MIG2_POS_POSICIONAMIENTO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_APT_PRESUPUESTO_TRABAJO_BK AS SELECT * FROM #ESQUEMA#.MIG_APT_PRESUPUESTO_TRABAJO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_APA_PROP_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG_APA_PROP_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_APC_PROP_CABECERA_BK AS SELECT * FROM #ESQUEMA#.MIG_APC_PROP_CABECERA';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_PRO_PROPIETARIOS_BK AS SELECT * FROM #ESQUEMA#.MIG2_PRO_PROPIETARIOS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_PRH_PROP_HIST_BK AS SELECT * FROM #ESQUEMA#.MIG2_PRH_PROP_HIST';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_PRP_PROPUESTAS_PRECIOS_BK AS SELECT * FROM #ESQUEMA#.MIG2_PRP_PROPUESTAS_PRECIOS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_PVC_PROVEEDOR_CONTACTO_BK AS SELECT * FROM #ESQUEMA#.MIG2_PVC_PROVEEDOR_CONTACTO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_PVE_PROVEEDORES_BK AS SELECT * FROM #ESQUEMA#.MIG2_PVE_PROVEEDORES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_PRD_PROVEEDOR_DIRECCIO_BK AS SELECT * FROM #ESQUEMA#.MIG2_PRD_PROVEEDOR_DIRECCION';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_RES_RESERVAS_BK AS SELECT * FROM #ESQUEMA#.MIG2_RES_RESERVAS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_SUB_SUBSANACIONES_BK AS SELECT * FROM #ESQUEMA#.MIG2_SUB_SUBSANACIONES';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ATA_TASACIONES_ACTIVO_BK AS SELECT * FROM #ESQUEMA#.MIG_ATA_TASACIONES_ACTIVO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_OFR_TIA_TITULARES_ADI_BK AS SELECT * FROM #ESQUEMA#.MIG2_OFR_TIA_TITULARES_ADI';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG_ATR_TRABAJO_BK AS SELECT * FROM #ESQUEMA#.MIG_ATR_TRABAJO';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_USU_USUARIOS_BK AS SELECT * FROM #ESQUEMA#.MIG2_USU_USUARIOS';
    EXECUTE IMMEDIATE 'CREATE TABLE #ESQUEMA#.MIG2_VIS_VISITAS_BK AS SELECT * FROM #ESQUEMA#.MIG2_VIS_VISITAS';

    DBMS_OUTPUT.PUT_LINE('[FIN] Copiado de tablas MIGRACION BANKIA en REM.');

    DBMS_OUTPUT.PUT_LINE('[INICIO] Truncado de tablas MIGRACION en REM.');

    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ADJ_JUDICIAL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ADJ_NO_JUDICIAL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ACA_CABECERA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ADA_DATOS_ADI';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_APL_PLANDINVENTAS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_APC_PRECIO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_ACT_PRP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_ACT_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_ACQ_ACTIVO_ALQUILER';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_ACH_ACTIVOS_HITO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ATI_TITULO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ADD_ADMISION_DOC';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_AGR_AGRUPACIONES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AAA_AGRUPACION_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AAG_AGRUPACIONES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ACA_CALIDADES_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ACA_CARGAS_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ACA_CATASTRO_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_CLC_CLIENTE_COMERCIAL';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GEX_GASTOS_EXPEDIENTE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_COM_COMPRADORES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_CEX_COMPRADOR_EXPEDIENTE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_CPC_PROP_CABECERA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_ACT_COE_CONDICIONES_ESPEC';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_COE_CONDICIONAN_OFR_ACEP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GDE_GASTOS_DET_ECONOMICO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AEP_ENTIDAD_PROVEEDOR';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_FOR_FORMALIZACIONES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GIM_GASTOS_IMPUGNACION';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GIC_GASTOS_INFO_CONTABI';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GPV_ACT_TBJ';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GPV_GASTOS_PROVEEDORES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GPR_PROVISION_GASTOS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GGE_GASTOS_GESTION';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GEA_GESTORES_ACTIVOS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GEO_GESTORES_OFERTAS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_GRU_GRUPOS_USUARIOS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_ACT_HVA_HIST_VALORACIONES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_ACT_HEP_HIST_EST_PUBLI';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AIA_INFCOMERCIAL_ACT';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AID_INFCOMERCIAL_DISTR';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ALA_LLAVES_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AML_MOVIMIENTOS_LLAVE';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AOA_OBSERVACIONES_ACTIVOS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_AOA_OBSERVACION_AGRUP';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_OFA_OFERTAS_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_OFR_OFERTAS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_OBF_OBSERVACIONES_OFERTAS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_PAC_PERIMETRO_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_POS_POSICIONAMIENTO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_APT_PRESUPUESTO_TRABAJO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_APA_PROP_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_APC_PROP_CABECERA';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_PRO_PROPIETARIOS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_PRH_PROP_HIST';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_PRP_PROPUESTAS_PRECIOS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_PVC_PROVEEDOR_CONTACTO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_PVE_PROVEEDORES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_PRD_PROVEEDOR_DIRECCION';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_RES_RESERVAS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_SUB_SUBSANACIONES';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ATA_TASACIONES_ACTIVO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_OFR_TIA_TITULARES_ADI';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG_ATR_TRABAJO';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_USU_USUARIOS';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE #ESQUEMA#.MIG2_VIS_VISITAS';

    DBMS_OUTPUT.PUT_LINE('[FIN] Truncado de tablas MIGRACION en REM.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT