--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170614
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2273
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AOA_OBSERVACIONES_AGRUP' -> 'ACT_AGO_AGRUPACION_OBS'
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
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGO_AGRUPACION_OBS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AOA_OBSERVACION_AGRUP';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
  
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de AGRUPACIONES OBSERVACIONES');

    -------------------------------------------------
    --INSERCION EN ACT_AGO_AGRUPACION_OBS--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_AGO_AGRUPACION_OBS'); 

  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		AGO_ID,
		AGR_ID,
		USU_ID,
		AGO_OBSERVACION,
		AGO_FECHA,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	SELECT
		'||V_ESQUEMA||'.S_ACT_AGO_AGRUPACION_OBS.NEXTVAL				AGO_ID,
		AGR.AGR_ID														AGR_ID,
		USU.USU_ID														USU_ID,
		MIG.AGO_OBSERVACION										        AGO_OBSERVACION,
		MIG.AGO_FECHA											        AGO_FECHA,
		''0''													        VERSION,
		'''||V_USUARIO||'''												USUARIOCREAR,
		SYSDATE													        FECHACREAR,
		0														        BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 		MIG
    JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION 	AGR ON AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_EXTERNO
    JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS 	USU ON USU.USU_USERNAME = MIG.USU_ID
	WHERE MIG.VALIDACION = 0
    ');

    DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
    COMMIT;
  
    EXECUTE IMMEDIATE  'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
  
    DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de AGRUPACIONES OBSERVACIONES');
  
  
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
