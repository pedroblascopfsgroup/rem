--/*
--#########################################
--## AUTOR=Maria Presencia Herrero
--## FECHA_CREACION=20181119
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2806
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 
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

-- Variables
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2806';
V_SQL VARCHAR2(2500 CHAR) := '';
V_NUM NUMBER(25);
V_SENTENCIA VARCHAR2(2000 CHAR);

--Tablas
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AJD_ADJJUDICIAL';
V_TABLA_2 VARCHAR2(40 CHAR) := 'BIE_ADJ_ADJUDICACION';

V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON_2';


BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_ADM_INF_ADMINISTRATIVA');
        
    ELSE

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		AJD_ID,
		ACT_ID,
		BIE_ADJ_ID,
		DD_JUZ_ID,
		DD_PLA_ID,
		DD_EDJ_ID,
		DD_EEJ_ID,
		AJD_FECHA_ADJUDICACION,
		AJD_NUM_AUTO,
		AJD_PROCURADOR,
		AJD_LETRADO,
		AJD_ID_ASUNTO,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		USUARIOMODIFICAR,
		FECHAMODIFICAR,
		USUARIOBORRAR,
		FECHABORRAR,
		BORRADO
	)
	SELECT
		'||V_ESQUEMA||'.S_ACT_AJD_ADJJUDICIAL.NEXTVAL         AJD_ID,
		ACT2.ACT_ID,
		BIE.BIE_ADJ_ID,
		AJD.DD_JUZ_ID             						      DD_JUZ_ID,
		AJD.DD_PLA_ID       							      DD_PLA_ID,
		AJD.DD_EDJ_ID    									  DD_EDJ_ID,
		AJD.DD_EEJ_ID       								  DD_EEJ_ID,
		AJD.AJD_FECHA_ADJUDICACION                            AJD_FECHA_ADJUDICACION,
		AJD.AJD_NUM_AUTO                                      AJD_NUM_AUTO,
		AJD.AJD_PROCURADOR                                    AJD_PROCURADOR,
		AJD.AJD_LETRADO                                       AJD_LETRADO,
		AJD.AJD_ID_ASUNTO                                     AJD_ID_ASUNTO,
		''0''                                                 VERSION,
		'''||V_USUARIO||'''                                   USUARIOCREAR,
		SYSDATE                                               FECHACREAR,
		NULL                                                  USUARIOMODIFICAR,
		NULL                                                  FECHAMODIFICAR,
		NULL                                                  USUARIOBORRAR,
		NULL                                                  FECHABORRAR,
		0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' BIE ON ACT2.BIE_ID = BIE.BIE_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' AJD ON AJD.ACT_ID = ACT.ACT_ID
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  --------
    commit;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  

  COMMIT;

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
