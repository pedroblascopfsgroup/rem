--/*
--#########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20170712
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=Parche 2.0.6 - p2
--## INCIDENCIA_LINK=HREOS-2405
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ATR_TRABAJO' -> 'ACT_TBJ_TRABAJO', 'ACT_TBJ'
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_TBJ_TRABAJO';
V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_TBJ';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATR_TRABAJO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
--#############################################################
--############ TRABAJOS
--#############################################################
/*
EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA_2||' T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' TP JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG ON TP.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = TP.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA_2||' borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_PRT_PRESUPUESTO_TRABAJO T1 WHERE EXISTS (SELECT 1 FROM REM01.ACT_TBJ_TRABAJO TP JOIN REM01.MIG_ATR_TRABAJO MIG ON TP.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = TP.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_PRT_PRESUPUESTO_TRABAJO borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_TCT_TRABAJO_CFGTARIFA T1 WHERE EXISTS (SELECT 1 FROM REM01.ACT_TBJ_TRABAJO TP JOIN REM01.MIG_ATR_TRABAJO MIG ON TP.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = TP.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_TBO_TRABAJO_OBS T1 WHERE EXISTS (SELECT 1 FROM REM01.ACT_TBJ_TRABAJO TP JOIN REM01.MIG_ATR_TRABAJO MIG ON TP.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = TP.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_TBO_TRABAJO_OBS borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_ADT_ADJUNTO_TRABAJO T1 WHERE EXISTS (SELECT 1 FROM REM01.ACT_TBJ_TRABAJO TP JOIN REM01.MIG_ATR_TRABAJO MIG ON TP.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = TP.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_ADT_ADJUNTO_TRABAJO borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_PSU_PROVISION_SUPLIDO T1 WHERE EXISTS (SELECT 1 FROM REM01.ACT_TBJ_TRABAJO TP JOIN REM01.MIG_ATR_TRABAJO MIG ON TP.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = TP.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_PSU_PROVISION_SUPLIDO borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.ACT_RPV_RECARGOS_PROVEEDOR T1 WHERE EXISTS (SELECT 1 FROM REM01.ACT_TBJ_TRABAJO TP JOIN REM01.MIG_ATR_TRABAJO MIG ON TP.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = TP.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.ACT_RPV_RECARGOS_PROVEEDOR borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM REM01.GPV_TBJ T1 WHERE EXISTS (SELECT 1 FROM REM01.MIG_ATR_TRABAJO MIG JOIN REM01.ACT_TBJ_TRABAJO T2 ON T2.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1) WHERE T1.TBJ_ID = T2.TBJ_ID)';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');

EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' T1 WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG WHERE T1.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO AND MIG.VALIDACION IN (0,1))';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' borrada (Registros que vienen en la migración). '||SQL%ROWCOUNT||' Filas.');
*/
	EXECUTE IMMEDIATE ('
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
			TBJ_ID,
			ACT_ID,
			AGR_ID,
			TBJ_NUM_TRABAJO,
			PVC_ID,
			USU_ID,
			DD_TTR_ID,
			DD_STR_ID,
			DD_EST_ID,
			TBJ_DESCRIPCION,
			TBJ_FECHA_SOLICITUD,
			TBJ_FECHA_APROBACION,
			TBJ_FECHA_INICIO,
			TBJ_FECHA_FIN,
			TBJ_CONTINUO_OBSERVACIONES,
			TBJ_FECHA_FIN_COMPROMISO,
			TBJ_FECHA_TOPE,
			TBJ_FECHA_HORA_CONCRETA,
			TBJ_URGENTE,
			TBJ_CON_RIESGO_TERCEROS,
			TBJ_CUBRE_SEGURO,
			TBJ_CIA_ASEGURADORA,
			DD_TCA_ID,
			TBJ_TERCERO_NOMBRE,
			TBJ_TERCERO_EMAIL,
			TBJ_TERCERO_DIRECCION,
			TBJ_TERCERO_CONTACTO,
			TBJ_TERCERO_TEL1,
			TBJ_TERCERO_TEL2,
			TBJ_IMPORTE_PENAL_DIARIO,
			TBJ_OBSERVACIONES,
			TBJ_IMPORTE_TOTAL,
			TBJ_FECHA_RECHAZO,
			VERSION,
			USUARIOCREAR,
			FECHACREAR,
			BORRADO
		)
		SELECT
			'||V_ESQUEMA||'.S_ACT_TBJ_TRABAJO.NEXTVAL			                         TBJ_ID,
      SQLI.*
    FROM 
    (
      SELECT DISTINCT 
        NULL																	           ACT_ID,
        (SELECT AGR.AGR_ID
        FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
        WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)                 AGR_ID,
        MIG.TBJ_NUM_TRABAJO                                                                 TBJ_NUM_TRABAJO,
        (SELECT PVC.PVC_ID
        FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
        WHERE PVC.PVC_DOCIDENTIF = MIG.PVC_DOCIDENTIF
          AND rownum = 1)                  PVC_ID,
        NULL                                                                                         USU_ID,
        (SELECT TTR.DD_TTR_ID
        FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
        WHERE TTR.DD_TTR_CODIGO = MIG.TIPO_TRABAJO)                    DD_TTR_ID,
        (SELECT STR.DD_STR_ID
        FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR
        WHERE STR.DD_STR_CODIGO = MIG.SUBTIPO_TRABAJO)                 DD_STR_ID,
        (SELECT EST.DD_EST_ID
        FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST
        WHERE EST.DD_EST_CODIGO = MIG.ESTADO_TRABAJO)              DD_EST_ID,
        MIG.TBJ_DESCRIPCION                                                            TBJ_DESCRIPCION,
        MIG.TBJ_FECHA_SOLICITUD                                                        TBJ_FECHA_SOLICITUD,
        MIG.TBJ_FECHA_APROBACION                                                 TBJ_FECHA_APROBACION,
        MIG.TBJ_FECHA_INICIO                                                             TBJ_FECHA_INICIO,
        MIG.TBJ_FECHA_FIN                                                                  TBJ_FECHA_FIN,
        MIG.TBJ_CONTINUO_OBSERVACIONES                                       TBJ_CONTINUO_OBSERVACIONES,
        MIG.TBJ_FECHA_FIN_COMPROMISO                                                      TBJ_FECHA_FIN_COMPROMISO,
        MIG.TBJ_FECHA_TOPE                                                                  TBJ_FECHA_TOPE,
        MIG.TBJ_FECHA_HORA_CONCRETA                                          TBJ_FECHA_HORA_CONCRETA,
        MIG.TBJ_URGENTE                                                                 TBJ_URGENTE,
        MIG.TBJ_CON_RIESGO_TERCEROS                                                 TBJ_CON_RIESGO_TERCEROS,
        MIG.TBJ_CUBRE_SEGURO                                                       TBJ_CUBRE_SEGURO,
        MIG.TBJ_CIA_ASEGURADORA                                                    TBJ_CIA_ASEGURADORA,
        (SELECT TCA.DD_TCA_ID
        FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CALIDAD TCA
        WHERE TCA.DD_TCA_CODIGO = MIG.TIPO_CALIDAD)               DD_TCA_ID,
        MIG.TBJ_TERCERO_NOMBRE                                                     TBJ_TERCERO_NOMBRE,
        MIG.TBJ_TERCERO_EMAIL                                                       TBJ_TERCERO_EMAIL,
        MIG.TBJ_TERCERO_DIRECCION                                               TBJ_TERCERO_DIRECCION,
        MIG.TBJ_TERCERO_CONTACTO                                               TBJ_TERCERO_CONTACTO,
        MIG.TBJ_TERCERO_TEL1                                                       TBJ_TERCERO_TEL1,
        MIG.TBJ_TERCERO_TEL2                                                         TBJ_TERCERO_TEL2,
        MIG.TBJ_IMPORTE_PENAL_DIARIO                                            TBJ_IMPORTE_PENAL_DIARIO,
        MIG.TBJ_OBSERVACIONES                                                         TBJ_OBSERVACIONES,
        MIG.TBJ_IMPORTE_TOTAL                                                        TBJ_IMPORTE_TOTAL,
        MIG.TBJ_FECHA_DENEGACION												TBJ_FECHA_RECHAZO,
        ''0''                                                                                         VERSION,
        '''||V_USUARIO||'''                                                                                    USUARIOCREAR,
        SYSDATE                                                                            FECHACREAR,
        0                                                                                         BORRADO
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
      WHERE MIG.VALIDACION IN (0) AND NOT EXISTS (
        SELECT 1
        FROM ACT_TBJ_TRABAJO AUX
        WHERE AUX.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO
      )
    ) SQLI
	'
	)
	;

	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

	--#############################################################
	--############ ACT_TBJ
	--#############################################################

	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'.');
 
	EXECUTE IMMEDIATE ('
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
			ACT_ID,
			TBJ_ID,
			ACT_TBJ_PARTICIPACION,
			VERSION
		)
		WITH EXISTENTES AS (
			SELECT DISTINCT ACT_ID, TBJ_ID
			FROM '||V_ESQUEMA||'.'||V_TABLA_2||' TBJ
		),
		INSERTAR AS (
		SELECT DISTINCT ACT.ACT_ID, TBJ.TBJ_ID
		FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG ON TBJ.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
		WHERE MIG.VALIDACION IN (0)
		)
		SELECT 
			TBJ.ACT_ID  					ACT_ID,
			TBJ.TBJ_ID						TBJ_ID,
			0								ACT_TBJ_PARTICIPACION,
			0								VERSION
		FROM INSERTAR TBJ
		LEFT JOIN EXISTENTES EXI ON EXI.TBJ_ID = TBJ.TBJ_ID
		WHERE EXI.TBJ_ID IS NULL AND EXI.ACT_ID IS NULL'
	)
	;
  
	DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');

	COMMIT;

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''1''); END;';
	EXECUTE IMMEDIATE V_SENTENCIA;

	V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA_2||''',''1''); END;';
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
