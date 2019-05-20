--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_LLV_LLAVE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ALA_LLAVES_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS LLAVES');

    -------------------------------------------------
    --INSERCION EN ACT_LLV_LLAVE--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_LLV_LLAVE');
    
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' 
	(
		LLV_ID,
		ACT_ID,
		LLV_COD_CENTRO,
		LLV_NOMBRE_CENTRO,
		LLV_ARCHIVO1,
		LLV_ARCHIVO2,
		LLV_ARCHIVO3,
		LLV_COMPLETO,
		LLV_MOTIVO_INCOMPLETO,
		VERSION,
		USUARIOCREAR,
		FECHACREAR,
		BORRADO,
		LLV_NUM_LLAVE
	)
	SELECT 
		'||V_ESQUEMA||'.S_ACT_LLV_LLAVE.NEXTVAL								LLV_ID,
		AUX.*
	FROM (
	SELECT
		ACT.ACT_ID															ACT_ID,
		MIG.MLV_COD_CENTRO													LLV_COD_CENTRO,
		MIG.MLV_NOMBRE_CENTRO												LLV_NOMBRE_CENTRO,
		MIG.MLV_ARCHIVO1													LLV_ARCHIVO1,
		MIG.MLV_ARCHIVO2													LLV_ARCHIVO2,
		MIG.MLV_ARCHIVO3													LLV_ARCHIVO3,
		MIG.MLV_COMPLETO													LLV_COMPLETO,
		MIG.MLV_MOTIVO_INCOMPLETO											LLV_MOTIVO_INCOMPLETO,
		''0''                                                 				VERSION,
		'''||V_USUARIO||'''                                               	USUARIOCREAR,
		SYSDATE                                               				FECHACREAR,
		0                                                     				BORRADO,
		MIG.LLV_CODIGO														LLV_NUM_LLAVE
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE MIG.LLV_CODIGO != 0
	  AND MIG.LLV_CODIGO IS NOT NULL
	  AND MIG.VALIDACION IN (0,1)
	) AUX
  ');
	
  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS LLAVES');
  

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
