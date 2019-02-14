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

	V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
	V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-2806';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(2000 CHAR);
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_GALEON_2';
	V_TABLA1 VARCHAR2(40 CHAR) := 'ACT_LLV_LLAVE';
	V_TABLA VARCHAR2(40 CHAR) := 'ACT_MLV_MOVIMIENTO_LLAVE';

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
    	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = '''||V_USUARIO||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 1  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA ESTAN INSERTADOS LOS REGISTROS EN LA TABLA ACT_LLV_LLAVE');
        
    ELSE 
  
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
	SELECT
	'||V_ESQUEMA||'.S_ACT_MLV_MOVIMIENTO_LLAVE.NEXTVAL      MLV_ID,
	LLV.LLV_ID                                               		LLV_ID,
	MLV.DD_TTE_ID										                DD_TTE_ID,
	MLV.MLV_COD_TENEDOR                                       MLV_COD_TENEDOR,
	MLV.MLV_NOM_TENEDOR                                       MLV_NOM_TENEDOR,
	MLV.MLV_FECHA_ENTREGA	                                 MLV_FECHA_ENTREGA,
	MLV.MLV_FECHA_DEVOLUCION                                     MLV_FECHA_DEVOLUCION,
	''0''                                                     VERSION,
	'''||V_USUARIO||'''                                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	0                                                         BORRADO
	    FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
	JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
	JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' LLV ON LLV.ACT_ID = ACT2.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA1||' LLV2 ON LLV2.ACT_ID = ACT.ACT_ID
	JOIN '||V_ESQUEMA||'.'||V_TABLA||' MLV ON MLV.LLV_ID = LLV2.LLV_ID
	'
	)
	;



  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  END IF;
  
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
