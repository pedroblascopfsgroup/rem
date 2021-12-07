--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-16499
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
V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16499';
V_SQL VARCHAR2(30000 CHAR) := '';
V_NUM NUMBER(25);

--Tablas AUX
V_TABLA_AUX VARCHAR2(30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
V_TABLA_AUX1 VARCHAR2(30 CHAR) := 'AUX_OFR_ID';


--Tablas OFERTAS
V_TABLA_OFR VARCHAR2 (30 CHAR) := 'OFR_OFERTAS';
V_TABLA_ACT_OFR VARCHAR2 (30 CHAR) := 'ACT_OFR';
V_SENTENCIA VARCHAR2(30000 CHAR);


BEGIN

	
	--INSERT EN AUX_OFR_ID

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_OFR_ID (

					OFR_ID_VIEJO,
					OFR_ID_NUEVO
					)

					SELECT 
					OFR_ID
					,'||V_ESQUEMA||'.S_OFR_OFERTAS.NEXTVAL    OFR_ID_NUEVO  			
					FROM(			
					SELECT DISTINCT 
					OFR.OFR_ID
					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO               			
					JOIN '||V_ESQUEMA||'.ACT_OFR ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
					JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID AND OFR.BORRADO = 0
					LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
										
						WHERE 
						((OFR.DD_EOF_ID IN (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = (''01''))
						AND ECO.DD_EEC_ID IN (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN (''01'',''04'',''10'',''43'')))           
						OR OFR.DD_EOF_ID IN (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = (''04''))))';

      EXECUTE IMMEDIATE V_SQL;


	--INSERT EN OFR_OFERTAS
	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.OFR_OFERTAS  (
				OFR_ID,
				OFR_NUM_OFERTA,
				OFR_WEBCOM_ID,
				AGR_ID,
				OFR_IMPORTE,
				CLC_ID,
				DD_EOF_ID,
				DD_TOF_ID,
				VIS_ID,
				DD_EVO_ID,
				OFR_FECHA_ACCION,
				OFR_FECHA_ALTA,
				OFR_FECHA_NOTIFICACION,
				OFR_IMPORTE_CONTRAOFERTA,
				OFR_FECHA_CONTRAOFERTA,
				USU_ID,
				PVE_ID_PRESCRIPTOR,
				PVE_ID_API_RESPONSABLE,
				PVE_ID_CUSTODIO,
				PVE_ID_FDV,
					VERSION,
					USUARIOCREAR,
					FECHACREAR,
					USUARIOMODIFICAR,
					FECHAMODIFICAR,
					USUARIOBORRAR,
					FECHABORRAR,
					BORRADO,
					OFR_IND_LOTE_RESTRINGIDO,
				OFR_IMPORTE_APROBADO,
				OFR_DESDE_TANTEO,
				OFR_INTENCION_FINANCIAR,
				DD_CAP_ID,
				OFR_CONDICIONES_TX,
				OFR_FECHA_COMUNIC_REG,
				OFR_FECHA_CONTESTACION,
				OFR_FECHA_HASTA_TANTEO,
				DD_DRT_ID,
				OFR_FECHA_MAX_FORMALIZACION,
				OFR_FECHA_SOLICITUD_VISITA,
				OFR_FECHA_REALIZACION_VISITA,
				OFR_FECHA_RECHAZO,
				PVE_ID_SUCURSAL,
				DD_MRO_ID,
				OFR_USUARIO_BAJA,
				OFR_ORIGEN,
				OFR_OFERTA_EXPRESS,
				OFR_NECESITA_FINANCIACION,
				OFR_OBSERVACIONES,
				OFR_UVEM_ID,
				OFR_VENTA_DIRECTA,
				DD_TAL_ID,
				DD_TPI_ID,
				OFR_CONTRATO_PRINEX,
				OFR_REF_CIRCUITO_CLIENTE,
				OFR_FECHA_RESPUESTA,
				OFR_FECHA_APROBACION_PRO_MANZANA,
				OFR_FECHA_RESPUESTA_OFERTANTE_CES,
				OFR_FECHA_RESPUESTA_OFERTANTE_PM,
				OFR_IMP_CONTRAOFERTA_PM,
				OFR_FECHA_RESPUESTA_PM,
				OFR_IMP_CONTRAOFERTA_CES,
				OFR_FECHA_RESOLUCION_CES,
				DD_ORC_ID,
				DD_CLO_ID,
				OFR_GES_COM_PRES,
				OFR_CONTRAOFERTA_OFERTANTE_CES,
				OFR_OFERTA_SINGULAR,
				OFR_ID_PRES_ORI_LEAD,
				OFR_FECHA_ORI_LEAD,
				OFR_COD_TIPO_PROV_ORI_LEAD,
				OFR_ID_REALIZA_ORI_LEAD,
				OFR_COD_DIVARIAN,
				ID_OFERTA_ORIGEN,
				OFR_RECOMENDACION_RC,
				OFR_FECHA_RECOMENDACION_RC,
				OFR_RECOMENDACION_DC,
				OFR_FECHA_RECOMENDACION_DC,
				OFR_DOC_RESP_PRESCRIPTOR,
				OFR_VENTA_CARTERA,
				OFR_OFERTA_ESPECIAL,
				OFR_VENTA_SOBRE_PLANO,
				DD_ROP_ID,
				DD_RDC_ID,
				FECHA_ENT_CRM_SF,
				OFR_SOSPECHOSA,
				OFR_FECHA_OFERTA_PENDIENTE,
				DD_MJO_ID,
				DD_TFN_ID,
				DD_ETF_ID,
				OFR_TITULARES_CONFIRMADOS,
				DD_CCA_ID,
				DD_CAL_ID,
				OFR_FECHA_APR_GARANTIAS_APORTADAS,
				OFR_FECHA_PRIMER_VENCIMIENTO,
				OFR_FECHA_INICIO_CONTRATO,
				OFR_FECHA_FIN_CONTRATO,
				OFR_ALQUILER_OPCION_COMPRA,
				OFR_VALOR_OPCION_COMPRA,
				OFR_FECHA_VENC_OPCION_COMPRA,
				OFR_CHECK_DOCUMENTACION,
				OFR_FECHA_ALTA_WEBCOM,
				DD_TOA_ID
					)
					
				WITH OFR_NUM_OFERTA
						AS(SELECT
						AUX.OFR_ID
						,(ROW_NUMBER () OVER (PARTITION BY AUX.NUM_MAX ORDER BY AUX.NUM_MAX DESC)  + AUX.NUM_MAX) AS OFR_NUM_OFERTA
						FROM(
								
						SELECT DISTINCT AUX_OFR_ID.OFR_ID_NUEVO           OFR_ID
						,(SELECT MAX(OFR_NUM_OFERTA) FROM '||V_ESQUEMA||'.OFR_OFERTAS) NUM_MAX
						FROM '||V_ESQUEMA||'.AUX_OFR_ID AUX_OFR_ID  
						JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON AUX_OFR_ID.OFR_ID_VIEJO = OFR.OFR_ID) AUX
				)
					
					SELECT DISTINCT
					AUX_OFR_ID.OFR_ID_NUEVO               OFR_ID,   
				OFR_NUM_OFERTA.OFR_NUM_OFERTA,
				NULL 									OFR_WEBCOM_ID,
				AUX_AGA_AGR.AGR_ID_NUEVO,
				OFR.OFR_IMPORTE,
				OFR.CLC_ID,
				OFR.DD_EOF_ID,
				OFR.DD_TOF_ID,
				OFR.VIS_ID,
				OFR.DD_EVO_ID,
				OFR.OFR_FECHA_ACCION,
				OFR.OFR_FECHA_ALTA,
				OFR.OFR_FECHA_NOTIFICACION,
				OFR.OFR_IMPORTE_CONTRAOFERTA,
				OFR.OFR_FECHA_CONTRAOFERTA,
				OFR.USU_ID,
				OFR.PVE_ID_PRESCRIPTOR,
				OFR.PVE_ID_API_RESPONSABLE,
				OFR.PVE_ID_CUSTODIO,
				OFR.PVE_ID_FDV,
					''0''                                                    VERSION,
					''HREOS-16499''                                   	  USUARIOCREAR,
					SYSDATE                                                   FECHACREAR,
					NULL                                                      USUARIOMODIFICAR,
					NULL                                                      FECHAMODIFICAR,
					NULL                                                      USUARIOBORRAR,
					NULL                                                      FECHABORRAR,
					OFR.BORRADO                                                         BORRADO,
						OFR.OFR_IND_LOTE_RESTRINGIDO,
				OFR.OFR_IMPORTE_APROBADO,
				OFR.OFR_DESDE_TANTEO,
				OFR.OFR_INTENCION_FINANCIAR,
				OFR.DD_CAP_ID,
				OFR.OFR_CONDICIONES_TX,
				OFR.OFR_FECHA_COMUNIC_REG,
				OFR.OFR_FECHA_CONTESTACION,
				OFR.OFR_FECHA_HASTA_TANTEO,
				OFR.DD_DRT_ID,
				OFR.OFR_FECHA_MAX_FORMALIZACION,
				OFR.OFR_FECHA_SOLICITUD_VISITA,
				OFR.OFR_FECHA_REALIZACION_VISITA,
				OFR.OFR_FECHA_RECHAZO,
				OFR.PVE_ID_SUCURSAL,
				OFR.DD_MRO_ID,
				OFR.OFR_USUARIO_BAJA,
				OFR.OFR_ORIGEN,
				OFR.OFR_OFERTA_EXPRESS,
				OFR.OFR_NECESITA_FINANCIACION,
				OFR.OFR_OBSERVACIONES,
				OFR.OFR_UVEM_ID,
				OFR.OFR_VENTA_DIRECTA,
				OFR.DD_TAL_ID,
				OFR.DD_TPI_ID,
				OFR.OFR_CONTRATO_PRINEX,
				OFR.OFR_REF_CIRCUITO_CLIENTE,
				OFR.OFR_FECHA_RESPUESTA,
				OFR.OFR_FECHA_APROBACION_PRO_MANZANA,
				OFR.OFR_FECHA_RESPUESTA_OFERTANTE_CES,
				OFR.OFR_FECHA_RESPUESTA_OFERTANTE_PM,
				OFR.OFR_IMP_CONTRAOFERTA_PM,
				OFR.OFR_FECHA_RESPUESTA_PM,
				OFR.OFR_IMP_CONTRAOFERTA_CES,
				OFR.OFR_FECHA_RESOLUCION_CES,
				OFR.DD_ORC_ID,
				OFR.DD_CLO_ID,
				OFR.OFR_GES_COM_PRES,
				OFR.OFR_CONTRAOFERTA_OFERTANTE_CES,
				OFR.OFR_OFERTA_SINGULAR,
				OFR.OFR_ID_PRES_ORI_LEAD,
				OFR.OFR_FECHA_ORI_LEAD,
				OFR.OFR_COD_TIPO_PROV_ORI_LEAD,
				OFR.OFR_ID_REALIZA_ORI_LEAD,
				OFR.OFR_COD_DIVARIAN,
				OFR.ID_OFERTA_ORIGEN,
				OFR.OFR_RECOMENDACION_RC,
				OFR.OFR_FECHA_RECOMENDACION_RC,
				OFR.OFR_RECOMENDACION_DC,
				OFR.OFR_FECHA_RECOMENDACION_DC,
				OFR.OFR_DOC_RESP_PRESCRIPTOR,
				OFR.OFR_VENTA_CARTERA,
				OFR.OFR_OFERTA_ESPECIAL,
				OFR.OFR_VENTA_SOBRE_PLANO,
				OFR.DD_ROP_ID,
				OFR.DD_RDC_ID,
				OFR.FECHA_ENT_CRM_SF,
				OFR.OFR_SOSPECHOSA,
				OFR.OFR_FECHA_OFERTA_PENDIENTE,
				OFR.DD_MJO_ID,
				OFR.DD_TFN_ID,
				OFR.DD_ETF_ID,
				OFR.OFR_TITULARES_CONFIRMADOS,
				OFR.DD_CCA_ID,
				OFR.DD_CAL_ID,
				OFR.OFR_FECHA_APR_GARANTIAS_APORTADAS,
				OFR.OFR_FECHA_PRIMER_VENCIMIENTO,
				OFR.OFR_FECHA_INICIO_CONTRATO,
				OFR.OFR_FECHA_FIN_CONTRATO,
				OFR.OFR_ALQUILER_OPCION_COMPRA,
				OFR.OFR_VALOR_OPCION_COMPRA,
				OFR.OFR_FECHA_VENC_OPCION_COMPRA,
				OFR.OFR_CHECK_DOCUMENTACION,
				NULL					OFR_FECHA_ALTA_WEBCOM,
				OFR.DD_TOA_ID


				FROM '||V_ESQUEMA||'.AUX_OFR_ID AUX_OFR_ID 
					JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON AUX_OFR_ID.OFR_ID_VIEJO = OFR.OFR_ID 
					LEFT JOIN '||V_ESQUEMA||'.AUX_AGA_AGR AUX_AGA_AGR ON AUX_AGA_AGR.AGR_ID_VIEJO = OFR.AGR_ID
					JOIN OFR_NUM_OFERTA OFR_NUM_OFERTA ON OFR_NUM_OFERTA.OFR_ID = AUX_OFR_ID.OFR_ID_NUEVO';
      EXECUTE IMMEDIATE V_SQL;

	
--INSERT EN ACT_OFR

	V_SQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_OFR  (
				ACT_ID,
				OFR_ID,
				ACT_OFR_IMPORTE,
				VERSION,
				OFR_ACT_PORCEN_PARTICIPACION
				)
				SELECT 			
				ACT2.ACT_ID,
				AUX_OFR_ID.OFR_ID_NUEVO    OFR_ID,
				ACT_OFR.ACT_OFR_IMPORTE,
				''0''                                                    VERSION,
				ACT_OFR.OFR_ACT_PORCEN_PARTICIPACION

					FROM '||V_ESQUEMA||'.AUX_ACT_TRASPASO_ACTIVO AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AUX.ACT_NUM_ACTIVO_ANT = ACT.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_OFR ACT_OFR ON ACT.ACT_ID = ACT_OFR.ACT_ID
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.AUX_OFR_ID AUX_OFR_ID ON AUX_OFR_ID.OFR_ID_VIEJO = ACT_OFR.OFR_ID';
					
      EXECUTE IMMEDIATE V_SQL;

  
  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_OFR||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA_ACT_OFR||''',''2''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;






  
  
  
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
