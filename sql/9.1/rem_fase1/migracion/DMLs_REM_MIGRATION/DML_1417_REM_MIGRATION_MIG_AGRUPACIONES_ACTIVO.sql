--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160302
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
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

TABLE_COUNT NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGA_AGRUPACION_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AAA_AGRUPACIONES_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

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
		SELECT DISTINCT
		MIG.ACT_NUMERO_ACTIVO 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE MIG.ACT_NUMERO_ACTIVO = ACT_NUM_ACTIVO
		)
    )
    SELECT
    MIG.ACT_NUMERO_ACTIVO                              							 ACT_NUM_ACTIVO,
    '''||V_TABLA_MIG||'''                                                        TABLA_MIG,
    SYSDATE                                                                      FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN ACT_NUM_ACTIVO
    ON ACT_NUM_ACTIVO.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    '
    ;
    
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
    
    COMMIT;

  END IF;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO AGRUPACIONES...');
  
  V_SENTENCIA := '
  SELECT COUNT(AGR_UVEM) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM
  )
  '
  ;
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
  
  IF TABLE_COUNT_2 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS AGRUPACIONES EXISTEN EN ACT_AGR_AGRUPACION');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' AGRUPACIONES INEXISTENTES EN ACT_AGR_AGRUPACION. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.AGR_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.AGR_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.AGR_NOT_EXISTS (
    AGR_UVEM,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH AGR_UVEM AS (
		SELECT DISTINCT
		MIG.AGR_UVEM 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE MIG.AGR_UVEM = AGR_NUM_AGRUP_UVEM
		)
    )
    SELECT
    MIG.AGR_UVEM                              							 		 AGR_UVEM,
    '''||V_TABLA_MIG||'''                                                        TABLA_MIG,
    SYSDATE                                                                      FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN AGR_UVEM
    ON AGR_UVEM.AGR_UVEM = MIG.AGR_UVEM
    '
    ;
    
    /*
    DBMS_OUTPUT.PUT_LINE('[INFO] SE BORRARÁN DE '||V_ESQUEMA||'.'||V_TABLA_MIG||' LAS AGRUPACIONES INEXISTENTES. MIRAR '||V_ESQUEMA||'.AGR_NOT_EXISTS.');
    
    EXECUTE IMMEDIATE '
    DELETE 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    WHERE EXISTS (
      SELECT 1 FROM AGR_NOT_EXISTS WHERE MIG.AGR_UVEM = AGR_UVEM
    )
    '
    ;
    */
    
    COMMIT;

  END IF;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
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
		SELECT DISTINCT (ACT_NUMERO_ACTIVO || AGR_UVEM || AGA_PRINCIPAL) UNICO,
		ACT_NUMERO_ACTIVO,
		AGR_UVEM,
		AGA_PRINCIPAL,
		AGA_FECHA_INCLUSION
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
		WHERE ACT_NUMERO_ACTIVO NOT IN (
		  SELECT ACT_NUM_ACTIVO 
		  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		  INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' AGR
		  ON AGR.ACT_ID = ACT.ACT_ID 
			)
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL		AGA_ID,
	(SELECT AGR_ID
	FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR 
	WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)     		AGR_ID,
	(SELECT ACT_ID
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
	WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO)		ACT_ID,
	MIG.AGA_FECHA_INCLUSION									AGA_FECHA_INCLUSION,
	MIG.AGA_PRINCIPAL										AGA_PRINCIPAL,
	''0''                                                 	VERSION,
	''MIG''                                               	USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	0                                                     	BORRADO
	FROM ACT_NUMERO_ACTIVO MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
    ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    LEFT JOIN '||V_ESQUEMA||'.AGR_NOT_EXISTS NOT2
    ON NOT2.AGR_UVEM = MIG.AGR_UVEM
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
	AND NOT2.AGR_UVEM IS NULL
	')
	;

	
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
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
	IF TABLE_COUNT != 0 THEN
		V_OBSERVACIONES := 'Se han rechazado '||TABLE_COUNT||' registros por ACTIVOS inexistentes en ACT_ACTIVO. ';
	END IF;
   IF TABLE_COUNT_2 != 0 THEN
		V_OBSERVACIONES := 'Se han rechazado '||TABLE_COUNT_2||' registros por AGRUPACIONES inexistentes en ACT_AGR_AGRUPACIONES. ';
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
