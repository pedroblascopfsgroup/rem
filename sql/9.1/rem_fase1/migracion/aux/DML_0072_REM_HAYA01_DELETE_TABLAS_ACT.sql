--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160304
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ALA_LLAVES_ACTIVO' -> 'ACT_LLV_LLAVE'
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';

BEGIN

EXECUTE IMMEDIATE 'delete from '||V_ESQUEMA||'ACT_GES_DISTRIBUCION';
EXECUTE IMMEDIATE 'delete from ACT_PVE_PROVEEDOR where USUARIOCREAR like ''%MIG%''';
EXECUTE IMMEDIATE 'delete from ACT_TAS_TASACION';
EXECUTE IMMEDIATE 'delete from ACT_CRG_CARGAS';
EXECUTE IMMEDIATE 'delete from ACT_ADA_ADJUNTO_ACTIVO';
EXECUTE IMMEDIATE 'delete from ACT_TIT_TITULO';
EXECUTE IMMEDIATE 'delete from ACT_PDV_PLAN_DIN_VENTAS';
commit;
EXECUTE IMMEDIATE 'delete from ACT_AJD_ADJJUDICIAL';
EXECUTE IMMEDIATE 'delete from ACT_ADN_ADJNOJUDICIAL';
EXECUTE IMMEDIATE 'delete from ACT_ADM_INF_ADMINISTRATIVA';
EXECUTE IMMEDIATE 'delete from ACT_SPS_SIT_POSESORIA';
EXECUTE IMMEDIATE 'delete from ACT_REG_INFO_REGISTRAL';
commit;
EXECUTE IMMEDIATE 'delete from ACT_LOC_LOCALIZACION';
EXECUTE IMMEDIATE 'delete from ACT_CPR_COM_PROPIETARIOS';
EXECUTE IMMEDIATE 'delete from ACT_LLV_LLAVE';
EXECUTE IMMEDIATE 'delete from ACT_PAC_PROPIETARIO_ACTIVO';
EXECUTE IMMEDIATE 'delete from ACT_PRO_PROPIETARIO';
commit;
EXECUTE IMMEDIATE 'delete from ACT_CAT_CATASTRO';
EXECUTE IMMEDIATE 'delete from ACT_LLV_LLAVE';
EXECUTE IMMEDIATE 'delete from ACT_VAL_VALORACIONES';
EXECUTE IMMEDIATE 'delete from ACT_EDI_EDIFICIO';
commit;
EXECUTE IMMEDIATE 'delete from ACT_LCO_LOCAL_COMERCIAL';
EXECUTE IMMEDIATE 'delete from ACT_APR_PLAZA_APARCAMIENTO';
EXECUTE IMMEDIATE 'delete from ACT_CRI_CARPINTERIA_INT';
EXECUTE IMMEDIATE 'delete from ACT_CRE_CARPINTERIA_EXT';
EXECUTE IMMEDIATE 'delete from ACT_PRV_PARAMENTO_VERTICAL';
commit;
EXECUTE IMMEDIATE 'delete from ACT_SOL_SOLADO';
EXECUTE IMMEDIATE 'delete from ACT_INF_INFRAESTRUCTURA';
EXECUTE IMMEDIATE 'delete from ACT_ZCO_ZONA_COMUN';
EXECUTE IMMEDIATE 'delete from ACT_INS_INSTALACION';
EXECUTE IMMEDIATE 'delete from ACT_BNY_BANYO';
commit;
EXECUTE IMMEDIATE 'delete from ACT_COC_COCINA';
EXECUTE IMMEDIATE 'delete from ACT_DIS_DISTRIBUCION';
EXECUTE IMMEDIATE 'delete from ACT_AGA_AGRUPACION_ACTIVO';
EXECUTE IMMEDIATE 'delete from ACT_ONV_OBRA_NUEVA';
commit;
EXECUTE IMMEDIATE 'delete from ACT_RES_RESTRINGIDA';
EXECUTE IMMEDIATE 'delete from ACT_AGR_AGRUPACION';
EXECUTE IMMEDIATE 'delete from ACT_VIV_VIVIENDA';
EXECUTE IMMEDIATE 'delete from ACT_ICO_INFO_COMERCIAL';
EXECUTE IMMEDIATE 'delete from ACT_SDV_SUBDIVISION_ACTIVO';
commit;
EXECUTE IMMEDIATE 'delete from ACT_ACTIVO';
commit;


EXECUTE IMMEDIATE 'delete from bie_car_cargas';
commit;

EXECUTE IMMEDIATE 'delete from bie_adicional';
commit;

EXECUTE IMMEDIATE 'delete from bie_adj_adjudicacion';
commit;

EXECUTE IMMEDIATE 'delete from bie_anc_analisis_contratos';
commit;

EXECUTE IMMEDIATE 'delete from bie_bien_entidad';
commit;

EXECUTE IMMEDIATE 'delete from bie_datos_registrales';
commit;

EXECUTE IMMEDIATE 'delete from bie_localizacion';
commit;

EXECUTE IMMEDIATE 'delete from bie_sui_subasta_instrucciones';
commit;

EXECUTE IMMEDIATE 'delete from bie_valoraciones';
commit;

EXECUTE IMMEDIATE 'delete from lob_lote_bien';
EXECUTE IMMEDIATE 'delete from emp_nmbembargos_procedimientos';
commit;

EXECUTE IMMEDIATE 'delete from bie_bien';
commit;

EXECUTE IMMEDIATE 'delete from RSR_REGISTRO_SQLS';
commit;

 EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;

