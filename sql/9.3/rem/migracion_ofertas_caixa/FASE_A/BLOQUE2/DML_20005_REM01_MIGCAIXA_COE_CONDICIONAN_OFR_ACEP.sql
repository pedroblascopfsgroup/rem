--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210727
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.11
--## INCIDENCIA_LINK=HREOS-14680
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
V_USUARIO VARCHAR2(50 CHAR) := 'MIG_CAIXA';
V_TABLA VARCHAR2(40 CHAR) := 'COE_CONDICIONANTES_EXPEDIENTE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_COE_CONDICIONAN_OFR_ACEP_CAIXA';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_NUM_TABLAS NUMBER(16);
V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN 
 
	--Inicio del proceso de volcado sobre COE_CONDICIONANTES_EXPEDIENTE

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
	EXECUTE IMMEDIATE '
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_MIG||' (
			OFR_NUM_OFERTA	,
			COE_SOLICITA_FINANCIACION	,
			COE_ENTIDAD_FINANCIACION_AJENA	,
			COE_INICIO_EXPEDIENTE	,
			COE_INICIO_FINANCIACION	,
			COE_FIN_FINANCIACION	,
			DD_ESF_ID	,
			DD_TCC_ID	,
			COE_PORCENTAJE_RESERVA	,
			COE_PLAZO_FIRMA_RESERVA	,
			COE_IMPORTE_RESERVA	,
			DD_TIT_ID	,
			COE_TIPO_APLICABLE	,
			COE_RENUNCIA_EXENCION	,
			COE_RESERVA_CON_IMPUESTO	,
			COE_GASTOS_PLUSVALIA	,
			DD_TPC_ID_PLUSVALIA	,
			COE_GASTOS_NOTARIA	,
			DD_TPC_ID_NOTARIA	,
			COE_GASTOS_OTROS	,
			DD_TPC_ID_GASTOS_OTROS	,
			COE_FECHA_ACTUALIZACION_CARGAS	,
			COE_CARGAS_IMPUESTOS	,
			DD_TPC_ID_IMPUESTOS	,
			COE_CARGAS_COMUNIDAD	,
			DD_TPC_ID_COMUNIDAD	,
			COE_CARGAS_OTROS	,
			DD_TPC_ID_CARGAS_OTROS	,
			COE_SUJETO_TANTEO_RETRACTO	,
			COE_RENUNCIA_SNMTO_EVICCION	,
			COE_RENUNCIA_SNMTO_VICIOS	,
			COE_VPO	,
			COE_LICENCIA	,
			DD_TPC_ID_LICENCIA	,
			COE_PROCEDE_DESCALIFICACION	,
			DD_TPC_ID_DESCALIFICACION	,
			COE_POSESION_INICIAL	,
			DD_SIP_ID	,
			DD_ETI_ID	,
			COE_ESTADO_TRAMITE	,
			COE_GASTOS_IBI	,
			COE_GASTOS_COMUNIDAD	,
			COE_GASTOS_SUMINISTROS	,
			DD_TPC_ID_IBI	,
			DD_TPC_ID_COMUNIDAD_ALQUILER	,
			DD_TPC_ID_SUMINISTROS	,
			COE_SOLICITA_RESERVA	,
			COE_OPERACION_EXENTA	,
			COE_INVERSION_SUJETO_PASIVO	,
			ALQ_FIANZA_MESES	,
			ALQ_FIANZA_IMPORTE	,
			ALQ_FIANZA_ACTUALIZABLE	,
			ALQ_DEPOSITO_MESES	,
			ALQ_DEPOSITO_IMPORTE	,
			ALQ_DEPOSITO_ACTUALIZABLE	,
			ALQ_AVALISTA	,
			ALQ_FIADOR_DOCUMENTO	,
			ALQ_FIADOR_ENTIDAD_BANCARIA	,
			ALQ_IMPORTE_AVAL	,
			ALQ_RENUNCIA_TANTEO	,
			ALQ_CARENCIA	,
			ALQ_BONIFICACION	,
			ALQ_GASTOS_REPERCUTIBLES	,
			ALQ_NUMERO_AVAL	,
			ALQ_RENTA_FIJO	,
			ALQ_RENTA_PORCENTUAL	,
			ALQ_RENTA_IPC	,
			ALQ_RENTA_PORC_IMPUESTOS	,
			ALQ_RENTA_REVISION_MERCADO	,
			ALQ_RENTA_MERCADO_FECHA	,
			ALQ_RENTA_MERCADO_CADA	,
			ALQ_FECHA_FIJO	,
			ALQ_FECHA_INC_RENTA	,
			ALQ_CARENCIA_MESES	,
			ALQ_CARENCIA_IMPORTE	,
			ALQ_BONIFICACION_MESES	,
			ALQ_BONIFICACION_IMPORTE	,
			ALQ_BONIFICACION_DURACION	,
			ALQ_REPERCUTIBLES_COMMENTS	,
			ALQ_ENTIDAD_COMMENTS	,
			ALQ_FECHA_FIRMA	,
			COE_DEPOSITO_RESERVA	,
			DD_ETF_ID	,
			COE_TRIBUTOS_PROPIEDAD	,
			ID_FINANCIACION_BOARDING	,
			COE_OTRA_ENT_FINANCIERA	,
			COE_FIANZA_EXONERADA	,
			COE_OBLIGADO_CUMPLIMIENTO	,
			COE_VENCIMIENTO_AVAL,
			COE_ADECUACIONES,
			COE_CERTIFICACIONES,
			COE_DER_CESION_ARREND,
			COE_FECHA_PREAVISO_VENC_CONT,
			COE_FECHA_INGR_ARREND,
			COE_ANT_DEUDOR_LOCALIZABLE,
			COE_CNT_SUSCR_POST_ADJ,
			COE_OFR_NUEVAS_CONDICIONES,
			COE_ENTREGAS_CUENTA,
			COE_IMPORTE_ENTREGAS_CUENTA,
			COE_RENTAS_CUENTA,
			COE_FIANZAS_CNT_SUBROGADOS,
			COE_VULNERABILIDAD_DETECTADA,
			DD_RFC_ID,
			COE_CHECK_IGC,
			COE_PERIODICIDAD,
			COE_FECHA_ACTU,
			DD_MTA_ID,
			DD_RGI_ID,
			COE_SCORING_BC,
			COE_AVAL_BC,
			COE_SEG_RENTAS_BC,
			ALQ_FECHA_VENC_AVAL,
			ALQ_MESES_AVAL,
			DD_GRI_ID
		)
		SELECT 
			MIG.COD_OFERTA_CAIXA	,
			COE_SOLICITA_FINANCIACION	,
			COE_ENTIDAD_FINANCIACION_AJENA	,
			COE_INICIO_EXPEDIENTE	,
			COE_INICIO_FINANCIACION	,
			COE_FIN_FINANCIACION	,
			DD_ESF_ID	,
			DD_TCC_ID	,
			COE_PORCENTAJE_RESERVA	,
			COE_PLAZO_FIRMA_RESERVA	,
			COE_IMPORTE_RESERVA	,
			DD_TIT_ID	,
			COE_TIPO_APLICABLE	,
			COE_RENUNCIA_EXENCION	,
			COE_RESERVA_CON_IMPUESTO	,
			COE_GASTOS_PLUSVALIA	,
			DD_TPC_ID_PLUSVALIA	,
			COE_GASTOS_NOTARIA	,
			DD_TPC_ID_NOTARIA	,
			COE_GASTOS_OTROS	,
			DD_TPC_ID_GASTOS_OTROS	,
			COE_FECHA_ACTUALIZACION_CARGAS	,
			COE_CARGAS_IMPUESTOS	,
			DD_TPC_ID_IMPUESTOS	,
			COE_CARGAS_COMUNIDAD	,
			DD_TPC_ID_COMUNIDAD	,
			COE_CARGAS_OTROS	,
			DD_TPC_ID_CARGAS_OTROS	,
			COE_SUJETO_TANTEO_RETRACTO	,
			COE_RENUNCIA_SNMTO_EVICCION	,
			COE_RENUNCIA_SNMTO_VICIOS	,
			COE_VPO	,
			COE_LICENCIA	,
			DD_TPC_ID_LICENCIA	,
			COE_PROCEDE_DESCALIFICACION	,
			DD_TPC_ID_DESCALIFICACION	,
			COE_POSESION_INICIAL	,
			DD_SIP_ID	,
			DD_ETI_ID	,
			COE_ESTADO_TRAMITE	,
			COE_GASTOS_IBI	,
			COE_GASTOS_COMUNIDAD	,
			COE_GASTOS_SUMINISTROS	,
			DD_TPC_ID_IBI	,
			DD_TPC_ID_COMUNIDAD_ALQUILER	,
			DD_TPC_ID_SUMINISTROS	,
			COE_SOLICITA_RESERVA	,
			COE_OPERACION_EXENTA	,
			COE_INVERSION_SUJETO_PASIVO	,
			ALQ_FIANZA_MESES	,
			ALQ_FIANZA_IMPORTE	,
			ALQ_FIANZA_ACTUALIZABLE	,
			ALQ_DEPOSITO_MESES	,
			ALQ_DEPOSITO_IMPORTE	,
			ALQ_DEPOSITO_ACTUALIZABLE	,
			ALQ_AVALISTA	,
			ALQ_FIADOR_DOCUMENTO	,
			ALQ_FIADOR_ENTIDAD_BANCARIA	,
			ALQ_IMPORTE_AVAL	,
			ALQ_RENUNCIA_TANTEO	,
			ALQ_CARENCIA	,
			ALQ_BONIFICACION	,
			ALQ_GASTOS_REPERCUTIBLES	,
			ALQ_NUMERO_AVAL	,
			ALQ_RENTA_FIJO	,
			ALQ_RENTA_PORCENTUAL	,
			ALQ_RENTA_IPC	,
			ALQ_RENTA_PORC_IMPUESTOS	,
			ALQ_RENTA_REVISION_MERCADO	,
			ALQ_RENTA_MERCADO_FECHA	,
			ALQ_RENTA_MERCADO_CADA	,
			ALQ_FECHA_FIJO	,
			ALQ_FECHA_INC_RENTA	,
			ALQ_CARENCIA_MESES	,
			ALQ_CARENCIA_IMPORTE	,
			ALQ_BONIFICACION_MESES	,
			ALQ_BONIFICACION_IMPORTE	,
			ALQ_BONIFICACION_DURACION	,
			ALQ_REPERCUTIBLES_COMMENTS	,
			ALQ_ENTIDAD_COMMENTS	,
			ALQ_FECHA_FIRMA	,
			COE_DEPOSITO_RESERVA	,
			DD_ETF_ID	,
			COE_TRIBUTOS_PROPIEDAD	,
			ID_FINANCIACION_BOARDING	,
			COE_OTRA_ENT_FINANCIERA	,
			COE_FIANZA_EXONERADA	,
			COE_OBLIGADO_CUMPLIMIENTO	,
			COE_VENCIMIENTO_AVAL	,
			COE_ADECUACIONES,
			COE_CERTIFICACIONES,
			COE_DER_CESION_ARREND,
			COE_FECHA_PREAVISO_VENC_CONT,
			COE_FECHA_INGR_ARREND,
			COE_ANT_DEUDOR_LOCALIZABLE,
			COE_CNT_SUSCR_POST_ADJ,
			COE_OFR_NUEVAS_CONDICIONES,
			COE_ENTREGAS_CUENTA,
			COE_IMPORTE_ENTREGAS_CUENTA,
			COE_RENTAS_CUENTA,
			COE_FIANZAS_CNT_SUBROGADOS,
			COE_VULNERABILIDAD_DETECTADA,
			DD_RFC_ID,
			COE_CHECK_IGC,
			COE_PERIODICIDAD,
			COE_FECHA_ACTU,
			DD_MTA_ID,
			DD_RGI_ID,
			COE_SCORING_BC,
			COE_AVAL_BC,
			COE_SEG_RENTAS_BC,
			ALQ_FECHA_VENC_AVAL,
			ALQ_MESES_AVAL,
			DD_GRI_ID
		FROM '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE COE
		JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.ECO_ID = COE.ECO_ID
		JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
		JOIN '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS MIG ON MIG.COD_OFERTA_CAIXA = OFR.OFR_NUM_OFERTA
	';
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE (V_SENTENCIA);
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');

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
