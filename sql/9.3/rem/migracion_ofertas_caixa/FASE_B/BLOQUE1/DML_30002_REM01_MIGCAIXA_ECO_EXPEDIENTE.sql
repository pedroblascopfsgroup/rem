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
--## 		0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	TABLE_COUNT NUMBER(10,0) := 0;
	TABLE_COUNT_2 NUMBER(10,0) := 0;
	MAX_NUM_OFR NUMBER(10,0) := 0;
	V_NUM_TABLAS NUMBER(10,0) := 0;
	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
	V_USUARIO VARCHAR2(50 CHAR) := 'MIG_CAIXA';
	V_TABLA VARCHAR2(40 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL';
	V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ECO_EXPEDIENTE_CAIXA';
	V_SENTENCIA VARCHAR2(32000 CHAR);
	V_REG_MIG NUMBER(10,0) := 0;
	V_REG_INSERTADOS NUMBER(10,0) := 0;
	V_DUPLICADOS NUMBER(10,0) := 0;
	V_REJECTS NUMBER(10,0) := 0;
	V_COD NUMBER(10,0) := 0;
	V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
	V_OFR_ID NUMBER(16,0);    -- Varaible que almacenara las OFR_ID de aquellas ofertas aceptadas
	V_TABLE_ECO NUMBER(16,0); -- Variable que almacenara los Expedientes Comerciales creados
	V_TABLE_DD_EOF NUMBER(16,0); -- Variable que almacenara los ESTADOS_OFERTAS modificados
	V_TABLE_ECO_MER NUMBER(16,0); -- Variable que almacenara los Expedientes Comerciales mergeados
	V_NUM_TABLAS_2 NUMBER(16);
	V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

	--Inicio del proceso de volcado sobre OFR_OFERTAS

V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';

EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS_2;

IF V_NUM_TABLAS_2 = 0 THEN
DBMS_OUTPUT.PUT_LINE('La tabla/s de migración implicada está vacía. No se realiza ninguna acción');

ELSE
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

	V_SENTENCIA := 'INSERT INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL(ECO_ID	,
ECO_NUM_EXPEDIENTE	,
OFR_ID	,
DD_EEC_ID	,
ECO_FECHA_ALTA	,
ECO_FECHA_SANCION	,
ECO_FECHA_ANULACION	,
ECO_FECHA_CONT_PROPIETARIO	,
ECO_PETICIONARIO_ANULACION	,
ECO_IMP_DEV_ENTREGAS	,
ECO_FECHA_DEV_ENTREGAS	,
VERSION	,
USUARIOCREAR	,
FECHACREAR	,
USUARIOMODIFICAR	,
FECHAMODIFICAR	,
USUARIOBORRAR	,
FECHABORRAR	,
BORRADO	,
ECO_FECHA_INICIO_ALQUILER	,
ECO_FECHA_FIN_ALQUILER	,
ECO_IMPORTE_RENTA_ALQUILER	,
ECO_NUMERO_CONTRATO_ALQUILER	,
ECO_PLAZO_OPCION_COMPRA	,
ECO_PRIMA_OPCION_COMPRA	,
ECO_PRECIO_OPCION_COMPRA	,
ECO_CONDICIONES_OPCION_COMPRA	,
ECO_CONFLICTO_INTERESES	,
ECO_RIESGO_REPUTACIONAL	,
DD_COS_ID	,
DD_COS_ID_PROPUESTO	,
ECO_FECHA_SANCION_COMITE	,
ECO_ESTADO_PBC	,
ECO_FECHA_VENTA	,
DD_MAN_ID	,
ECO_BLOQUEADO	,
DD_MDE_ID	,
ECO_MDE_OTROS	,
DD_EEC_ID_ANT	,
TBJ_ID	,
DD_COS_ID_SUPERIOR	,
ECO_NECESITA_FINANCIACION	,
ECO_ASISTENCIA_PBC	,
ECO_ASISTENCIA_PBC_DESCRIPCION	,
DD_TAL_ID	,
ECO_TUBO_INQUILINO_DONE	,
DD_MAO_ID	,
DD_MRE_ID	,
DD_COA_ID	,
ECO_DOCUMENTACION_OK	,
ECO_FECHA_VALIDACION	,
ECO_FECHA_POSICIONAMIENTO_PREVISTA	,
ECO_CORRECW	,
ECO_COMOA3	,
ECO_DEVOL_AUTO_NUMBER	,
ECO_FECHA_RECOMENDACION_CES	,
ECO_ESTADO_PBC_R	,
ECO_FECHA_ENVIO_ADVISORY_NOTE	,
ECO_FECHA_CONT_VENTA	,
ECO_FECHA_GRAB_VENTA	,
DD_EEB_ID	,
ECO_ESTADO_ARRAS	,
ECO_ESTADO_CN	,
ECO_FECHA_RESER_DEPOS	,
ECO_FECHA_CONTAB	,
ECO_FECHA_FIRMA_CONT	,
ECO_NUM_PROTOCOLO	
		)SELECT MIG.ECO_ID, 
ECO_NUM_EXPEDIENTE	,
MIG.OFR_ID	,
DD_EEC_ID	,
ECO_FECHA_ALTA	,
ECO_FECHA_SANCION	,
ECO_FECHA_ANULACION	,
ECO_FECHA_CONT_PROPIETARIO	,
ECO_PETICIONARIO_ANULACION	,
ECO_IMP_DEV_ENTREGAS	,
ECO_FECHA_DEV_ENTREGAS	,
VERSION	,
''MIG_CAIXA''	,
SYSDATE	,
USUARIOMODIFICAR	,
FECHAMODIFICAR	,
USUARIOBORRAR	,
FECHABORRAR	,
BORRADO	,
ECO_FECHA_INICIO_ALQUILER	,
ECO_FECHA_FIN_ALQUILER	,
ECO_IMPORTE_RENTA_ALQUILER	,
ECO_NUMERO_CONTRATO_ALQUILER	,
ECO_PLAZO_OPCION_COMPRA	,
ECO_PRIMA_OPCION_COMPRA	,
ECO_PRECIO_OPCION_COMPRA	,
ECO_CONDICIONES_OPCION_COMPRA	,
ECO_CONFLICTO_INTERESES	,
ECO_RIESGO_REPUTACIONAL	,
DD_COS_ID	,
DD_COS_ID_PROPUESTO	,
ECO_FECHA_SANCION_COMITE	,
ECO_ESTADO_PBC	,
ECO_FECHA_VENTA	,
DD_MAN_ID	,
ECO_BLOQUEADO	,
DD_MDE_ID	,
ECO_MDE_OTROS	,
DD_EEC_ID_ANT	,
TBJ_ID	,
DD_COS_ID_SUPERIOR	,
ECO_NECESITA_FINANCIACION	,
ECO_ASISTENCIA_PBC	,
ECO_ASISTENCIA_PBC_DESCRIPCION	,
DD_TAL_ID	,
ECO_TUBO_INQUILINO_DONE	,
DD_MAO_ID	,
DD_MRE_ID	,
DD_COA_ID	,
ECO_DOCUMENTACION_OK	,
ECO_FECHA_VALIDACION	,
ECO_FECHA_POSICIONAMIENTO_PREVISTA	,
ECO_CORRECW	,
ECO_COMOA3	,
ECO_DEVOL_AUTO_NUMBER	,
ECO_FECHA_RECOMENDACION_CES	,
ECO_ESTADO_PBC_R	,
ECO_FECHA_ENVIO_ADVISORY_NOTE	,
ECO_FECHA_CONT_VENTA	,
ECO_FECHA_GRAB_VENTA	,
DD_EEB_ID	,
ECO_ESTADO_ARRAS	,
ECO_ESTADO_CN	,
ECO_FECHA_RESER_DEPOS	,	
ECO_FECHA_CONTAB	,
ECO_FECHA_FIRMA_CONT	,
ECO_NUM_PROTOCOLO	

		FROM '||V_ESQUEMA||'.MIG2_ECO_EXPEDIENTE_CAIXA MIG2
		JOIN '||V_ESQUEMA||'.MIG2_OFR_MAPEO_NUM_OFERTAS MIG ON MIG2.OFR_ID = MIG.OFR_ID';

END IF;
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

	COMMIT; 

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''1''); END;';
	EXECUTE IMMEDIATE V_SENTENCIA;

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA2||''',''1''); END;';
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
