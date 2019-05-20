--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170614
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2273
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AAA_AGRUPACIONES_ACTIVO' -> 'ACT_AGA_AGRUPACION_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGA_AGRUPACION_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AAA_AGRUPACION_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de AGRUPACIONES ACTIVO');

    -------------------------------------------------
    --INSERCION EN ACT_AGA_AGRUPACION_ACTIVO--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_AGA_AGRUPACION_ACTIVO'); 
  
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		AGA_ID,
		AGR_ID,
		ACT_ID,
		AGA_FECHA_INCLUSION,
		AGA_PRINCIPAL,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO
	)
	WITH ACT_NUMERO_ACTIVO AS (
		SELECT DISTINCT 
		    MIG.ACT_NUMERO_ACTIVO,
            MIG.AGR_EXTERNO,
            MIG.AGA_PRINCIPAL,
            MIG.AGA_FECHA_INCLUSION,
            ACT.ACT_ID,
            AGR.AGR_ID
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 				MIG
		JOIN '||V_ESQUEMA||'.ACT_ACTIVO 					ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
		JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION 			AGR ON AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_EXTERNO
        LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.AGR_ID = AGR.AGR_ID
		WHERE MIG.VALIDACION = 0 
		  AND AGA.AGA_ID IS NULL
	)
	SELECT
		'||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL		AGA_ID,
		MIG.AGR_ID												AGR_ID,
		MIG.ACT_ID												ACT_ID,
		MIG.AGA_FECHA_INCLUSION									AGA_FECHA_INCLUSION,
		MIG.AGA_PRINCIPAL										AGA_PRINCIPAL,
		''0''                                                 	VERSION,
		'''||V_USUARIO||'''                                     USUARIOCREAR,
		SYSDATE                                               	FECHACREAR,
		0                                                     	BORRADO
	FROM ACT_NUMERO_ACTIVO MIG
  ');

  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de AGRUPACIONES ACTIVO');
  
  
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
