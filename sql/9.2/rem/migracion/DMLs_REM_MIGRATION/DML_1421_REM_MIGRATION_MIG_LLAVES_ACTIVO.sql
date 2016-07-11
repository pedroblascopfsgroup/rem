--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160304
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
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

TABLE_COUNT NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_LLV_LLAVE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ALA_LLAVES_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
VAR1 NUMBER(10,0) := 0;
VAR2 NUMBER(10,0) := 0;

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
  )
  '
  ;
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN ACT_ACTIVO');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' ACTIVOS INEXISTENTES EN ACT_ACTIVO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.ACT_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.ACT_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.ACT_NOT_EXISTS (
    ACT_NUM_ACTIVO,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH ACT_NUM_ACTIVO AS (
		SELECT
		MIG.ACT_NUMERO_ACTIVO 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE MIG.ACT_NUMERO_ACTIVO = ACT_NUM_ACTIVO
		)
    )
    SELECT DISTINCT
    MIG.ACT_NUMERO_ACTIVO                              							 ACT_NUM_ACTIVO,
    '''||V_TABLA_MIG||'''                                                        TABLA_MIG,
    SYSDATE                                                                      FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN ACT_NUM_ACTIVO
    ON ACT_NUM_ACTIVO.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    '
    ;
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ACT_NOT_EXISTS COMPUTE STATISTICS');
    
    /*
    DBMS_OUTPUT.PUT_LINE('[INFO] SE BORRARÁN DE '||V_ESQUEMA||'.'||V_TABLA_MIG||' LOS ACTIVOS INEXISTENTES. MIRAR '||V_ESQUEMA||'.ACT_NOT_EXISTS.');
    
    EXECUTE IMMEDIATE '
    DELETE 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    WHERE EXISTS (
      SELECT 1 FROM ACT_NOT_EXISTS WHERE MIG.ACT_NUMERO_ACTIVO = ACT_NUM_ACTIVO
    )
    '
    ;
    */
    
    /*EXECUTE IMMEDIATE '
    UPDATE '||V_ESQUEMA||'.'||V_TABLA_MIG||' ALA
    SET LLV_ID = '||V_ESQUEMA||'.S_ACT_LLV_LLAVE.NEXTVAL
    WHERE NOT EXISTS (
      SELECT 1 FROM '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT WHERE NOTT.ACT_NUM_ACTIVO = ALA.ACT_NUMERO_ACTIVO AND NOTT.TABLA_MIG LIKE ''MIG_ALA_LLAVES_ACTIVO''
    )
    AND ALA.LLV_CODIGO_UVEM != 0
    AND ALA.LLV_CODIGO_UVEM IS NOT NULL
    '
    ;*/
    
    END IF;
    
    EXECUTE IMMEDIATE '
    UPDATE '||V_ESQUEMA||'.'||V_TABLA_MIG||' ALA
    SET LLV_ID = '||V_ESQUEMA||'.S_ACT_LLV_LLAVE.NEXTVAL
    WHERE ACT_NUMERO_ACTIVO NOT IN (
      SELECT ACT_NUM_ACTIVO FROM '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT WHERE NOTT.TABLA_MIG LIKE ''MIG_ALA_LLAVES_ACTIVO''
    )
    AND ALA.LLV_CODIGO_UVEM != 0
    AND ALA.LLV_CODIGO_UVEM IS NOT NULL
    AND ALA.LLV_ID IS NULL
    '
    ;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas. Update LLV_ID');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
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
	BORRADO
	)
	SELECT
	MIG.LLV_ID                              					LLV_ID,
	(SELECT ACT_ID
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
	WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO)     	ACT_ID,
	MIG.LLV_COD_CENTRO										LLV_COD_CENTRO,
	MIG.LLV_NOMBRE_CENTRO									LLV_NOMBRE_CENTRO,
	MIG.LLV_ARCHIVO1										LLV_ARCHIVO1,
	MIG.LLV_ARCHIVO2										LLV_ARCHIVO2,
	MIG.LLV_ARCHIVO3										LLV_ARCHIVO3,
	MIG.LLV_COMPLETO										LLV_COMPLETO,
	MIG.LLV_MOTIVO_INCOMPLETO								LLV_MOTIVO_INCOMPLETO,
	''0''                                                 	VERSION,
	''MIG''                                               	USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	0                                                     	BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
    ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND MIG.ACT_NUMERO_ACTIVO NOT IN (
		  SELECT ACT_NUM_ACTIVO 
		  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		  INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' CAT
		  ON CAT.ACT_ID = ACT.ACT_ID 
			)
  AND MIG.LLV_CODIGO_UVEM != 0
  AND MIG.LLV_CODIGO_UVEM IS NOT NULL
	')
	;

	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(ACT_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
	V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por ACTIVOS inexistentes en ACT_ACTIVO.';
	
	EXECUTE IMMEDIATE '
		SELECT COUNT(MIG.LLV_CODIGO_UVEM) FROM MIG_ALA_LLAVES_ACTIVO MIG
		WHERE MIG.LLV_CODIGO_UVEM = 0
	'
	INTO VAR1
	;
	
	IF VAR1 != 0 THEN
	
		V_OBSERVACIONES := V_OBSERVACIONES||' '||VAR1||' han sido rechazados por campo LLV_CODIGO_UVEM = 0 en MIG_ALA_LLAVES_ACTIVO. ';
		
	END IF;
	
	
	EXECUTE IMMEDIATE '
		SELECT COUNT(MIG.LLV_CODIGO_UVEM) FROM MIG_ALA_LLAVES_ACTIVO MIG
		WHERE MIG.LLV_CODIGO_UVEM IS NULL
	'
	INTO VAR2
	;
	
	IF VAR2 != 0 THEN
	
		V_OBSERVACIONES := V_OBSERVACIONES||' '||VAR2||' han sido rechazados por campo LLV_CODIGO_UVEM = NULL en MIG_ALA_LLAVES_ACTIVO. ';
		
	END IF;
  END IF;
  
  EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
	TABLA_MIG,
	TABLA_REM,
	REGISTROS_TABLA_MIG,
	REGISTROS_INSERTADOS,
	REGISTROS_RECHAZADOS,
	DD_COD_INEXISTENTES,
	FECHA,
	OBSERVACIONES
	)
	SELECT
	'''||V_TABLA_MIG||''',
	'''||V_TABLA||''',
	'||V_REG_MIG||',
	'||V_REG_INSERTADOS||',
	'||V_REJECTS||',
	'||V_COD||',
	SYSDATE,
	'''||V_OBSERVACIONES||'''
	FROM DUAL
  ')
  ;
  
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
