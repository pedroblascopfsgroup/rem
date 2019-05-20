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
V_TABLA_0 VARCHAR2(40 CHAR) := 'ACT_LLV_LLAVE';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_MLV_MOVIMIENTO_LLAVE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AML_MOVIMIENTOS_LLAVE';
V_TABLA_MIG_2 VARCHAR2(40 CHAR) := 'MIG_ALA_LLAVES_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS LLAVES-MOVIMIENTOS');

    -------------------------------------------------
    --INSERCION EN ACT_MLV_MOVIMIENTO_LLAVE--
    -------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_MLV_MOVIMIENTO_LLAVE');
    
  
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
	WITH LLV_CODIGO AS 
	(
		    SELECT DISTINCT MIGW.LLV_CODIGO, LLAVES.LLV_ID
		    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 			MIGW
			JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG_2||' 		MIGG
			ON MIGG.LLV_CODIGO = MIGW.LLV_CODIGO
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO					ACT
			ON ACT.ACT_NUM_ACTIVO = MIGG.ACT_NUMERO_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA_0||' 		    LLAVES
			ON LLAVES.ACT_ID = ACT.ACT_ID
			WHERE MIGW.VALIDACION IN (0,1) AND MIGG.VALIDACION IN (0,1)
    )
	SELECT
		'||V_ESQUEMA||'.S_ACT_MLV_MOVIMIENTO_LLAVE.NEXTVAL      		MLV_ID,
		LLV.LLV_ID                                               		LLV_ID,
		(SELECT DD_TTE_ID
		FROM '||V_ESQUEMA||'.DD_TTE_TIPO_TENEDOR
		WHERE DD_TTE_CODIGO = MIG.MLV_TIPO_TENEDOR)                		DD_TTE_ID,
		MIG.MLV_COD_TENEDOR                                       		MLV_COD_TENEDOR,
		MIG.MLV_NOM_TENEDOR                                      	    MLV_NOM_TENEDOR,
		MIG.MLV_FECHA_ENTREGA	                                 		MLV_FECHA_ENTREGA,
		MIG.MLV_FECHA_DEVOLUCION                                     	MLV_FECHA_DEVOLUCION,
		''0''                                                     		VERSION,
		'''||V_USUARIO||'''                                             USUARIOCREAR,
		SYSDATE                                                   		FECHACREAR,
		0                                                         		BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	JOIN LLV_CODIGO 					   LLV  ON LLV.LLV_CODIGO = MIG.LLV_CODIGO
	JOIN '||V_ESQUEMA||'.ACT_LLV_LLAVE     LLV2 ON LLV2.LLV_ID = LLV.LLV_ID
  ');

  DBMS_OUTPUT.PUT_LINE('	[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS LLAVES-MOVIMIENTOS');
  
  
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
