--/*
--#########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AML_MOVIMIENTOS_LLAVE' -> 'ACT_MLV_MOVIMIENTO_LLAVE'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_MLV_MOVIMIENTO_LLAVE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AML_MOVIMIENTOS_LLAVE';
V_TABLA_MIG_2 VARCHAR2(40 CHAR) := 'MIG_ALA_LLAVES_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	MLV_ID,
	LLV_ID,
	DD_TTE_ID,
	MLV_COD_TENEDOR,
	MLV_NOM_TENEDOR,
	MLV_FECHA_ENTREGA,
	MLV_FECHA_DEVOLUCION,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH LLV_CODIGO_UVEM AS (
	  SELECT DISTINCT MIGW.LLV_CODIGO_UVEM, MIGG.LLV_ID
	  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
	  INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG_2||' migg
	   ON migg.LLV_CODIGO_UVEM = MIGW.LLV_CODIGO_UVEM
    WHERE MIGG.LLV_ID IS NOT NULL
	AND MIGW.VALIDACION IN (0, 1) AND MIGG.VALIDACION IN (0, 1)
  )
	SELECT
	'||V_ESQUEMA||'.S_ACT_MLV_MOVIMIENTO_LLAVE.NEXTVAL      MLV_ID,
	LLV.LLV_ID                                               		LLV_ID,
	(SELECT DD_TTE_ID
	FROM '||V_ESQUEMA||'.DD_TTE_TIPO_TENEDOR
	WHERE DD_TTE_CODIGO = MIG.MLV_TIPO_TENEDOR)                DD_TTE_ID,
	MIG.MLV_COD_TENEDOR                                       MLV_COD_TENEDOR,
	MIG.MLV_NOM_TENEDOR                                       MLV_NOM_TENEDOR,
	MIG.MLV_FECHA_ENTREGA	                                 MLV_FECHA_ENTREGA,
	MIG.MLV_FECHA_DEVOLUCION                                     MLV_FECHA_DEVOLUCION,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN LLV_CODIGO_UVEM LLV ON LLV.LLV_CODIGO_UVEM = MIG.LLV_CODIGO_UVEM
	INNER JOIN '||V_ESQUEMA||'.ACT_LLV_LLAVE LLV2 ON LLV2.LLV_ID = LLV.LLV_ID
	'
	)
	;



  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
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
