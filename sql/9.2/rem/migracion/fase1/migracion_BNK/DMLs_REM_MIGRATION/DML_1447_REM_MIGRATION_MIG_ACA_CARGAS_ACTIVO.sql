--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ACA_CARGAS_ACTIVO' -> 'ACT_CRG_CARGAS', 'BIE_CAR_CARGAS'
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
V_TABLA VARCHAR2(30 CHAR) := 'BIE_CAR_CARGAS';
V_TABLA_2 VARCHAR2(30 CHAR) := 'ACT_CRG_CARGAS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ACA_CARGAS_ACTIVO_BNK';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO ACTIVOS...');
  
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
    MIG.ACT_NUMERO_ACTIVO                              							             ACT_NUM_ACTIVO,
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
  
  --REGISTRAMOS CRG_ID Y BIE_CAR_ID
  
  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  SET
  BIE_CAR_ID = S_BIE_CAR_CARGAS.NEXTVAL,
  CRG_ID = S_ACT_CRG_CARGAS.NEXTVAL
  WHERE BIE_CAR_ID IS NULL
  OR CRG_ID IS NULL
  ')
  ;
  
  COMMIT; 
  
  --DAMOS REGISTROS EN ALTA BIE_CAR_CARGAS PARA LOS ACTIVOS QUE TRATAMOS

  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
  BIE_ID,
  BIE_CAR_ID,
  DD_TPC_ID,
  BIE_CAR_TITULAR,
  BIE_CAR_IMPORTE_REGISTRAL,
  BIE_CAR_IMPORTE_ECONOMICO,
  BIE_CAR_FECHA_PRESENTACION,
  BIE_CAR_FECHA_INSCRIPCION,
  BIE_CAR_FECHA_CANCELACION,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO
  )
  WITH ACTIVOS AS (
    SELECT 
    ACT_ID, BIE_ID, BIE_CAR_ID, MIG.ACT_NUMERO_ACTIVO, MIG.CRG_TITULAR, MIG.CRG_IMPORTE_REGISTRAL, MIG.CRG_IMPORTE_ECONOMICO,
    MIG.CRG_FECHA_INSCRIPCION, MIG.CRG_FECHA_PRESENTACION, MIG.CRG_FECHA_CANCELACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
  )
  SELECT
  ACT.BIE_ID                                                        BIE_ID,
  ACT.BIE_CAR_ID                                                    BIE_CAR_ID,
  (SELECT DD_TPC_ID
  FROM '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA
  WHERE DD_TPC_DESCRIPCION = ''DESCONOCIDO'')                       DD_TPC_ID,
  ACT.CRG_TITULAR													BIE_CAR_TITULAR,
  ACT.CRG_IMPORTE_REGISTRAL											BIE_CAR_IMPORTE_REGISTRAL,
  ACT.CRG_IMPORTE_ECONOMICO											BIE_CAR_IMPORTE_ECONOMICO,
  ACT.CRG_FECHA_INSCRIPCION											BIE_CAR_FECHA_INSCRIPCION,
  ACT.CRG_FECHA_CANCELACION											BIE_CAR_FECHA_CANCELACION,
  ACT.CRG_FECHA_PRESENTACION										BIE_CAR_FECHA_PRESENTACION,
  0                                                                 VERSION,
  ''MIGRAREM01BNK''                                                           USUARIOCREAR,
  SYSDATE                                                           FECHACREAR,
  0                                                                 BORRADO
  FROM ACTIVOS ACT
  LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
  ON NOTT.ACT_NUM_ACTIVO = ACT.ACT_NUMERO_ACTIVO
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' BIE 
    WHERE BIE.BIE_ID = (SELECT BIE_ID
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT2
    WHERE ACT2.ACT_ID = ACT.ACT_ID)
    )
  AND NOTT.ACT_NUM_ACTIVO IS NULL
  ')
  ;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;  
  
  EXECUTE IMMEDIATE ('
  MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' BIE
  USING (
    SELECT BIE_CAR_ID 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
    WHERE TIPO_CARGA = ''REG''
  ) MIG
  ON (BIE.BIE_CAR_ID = MIG.BIE_CAR_ID)
  WHEN MATCHED THEN UPDATE SET
  BIE_CAR_REGISTRAL = 1,
  BIE_CAR_ECONOMICA = 0
  ')
  ;
  
  COMMIT;
  
  EXECUTE IMMEDIATE ('
  MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' BIE
  USING (
    SELECT BIE_CAR_ID
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
    WHERE TIPO_CARGA = ''ECO''
  ) MIG
  ON (BIE.BIE_CAR_ID = MIG.BIE_CAR_ID)
  WHEN MATCHED THEN UPDATE SET
  BIE_CAR_REGISTRAL = 0,
  BIE_CAR_ECONOMICA = 1
  ')
  ;
  
  COMMIT;

  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
  SET
  BIE_CAR_IMPORTE_REGISTRAL = 0
  WHERE BIE_CAR_IMPORTE_REGISTRAL IS NULL
  ')
  ;
  
  COMMIT;
  
  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
  SET
  BIE_CAR_IMPORTE_ECONOMICO = 0
  WHERE BIE_CAR_IMPORTE_ECONOMICO IS NULL
  ')
  ;
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA_2||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
	CRG_ID,
	ACT_ID,
	BIE_CAR_ID,
	DD_TCA_ID,
	DD_STC_ID,
	CRG_DESCRIPCION,
	CRG_ORDEN,
	CRG_FECHA_CANCEL_REGISTRAL,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH MIG_CARGAS AS (
		SELECT
		ACT.ACT_ID,
		MIG.ACT_NUMERO_ACTIVO,
		MIG.BIE_CAR_ID,
		MIG.CRG_ID,
		MIG.SITUACION_CARGA,
		MIG.TIPO_CARGA,
		MIG.SUBTIPO_CARGA,
		MIG.CRG_DESCRIPCION,
		MIG.CRG_ORDEN,
		MIG.CRG_FECHA_CANCEL_REGISTRAL
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	)
	SELECT
	MIG.CRG_ID                        					            CRG_ID,
	MIG.ACT_ID                                             	ACT_ID,
	MIG.BIE_CAR_ID                                          BIE_CAR_ID,
	(SELECT DD_TCA_ID
	FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CARGA
	WHERE DD_TCA_CODIGO = MIG.TIPO_CARGA)                   DD_TCA_ID,
	(SELECT DD_STC_ID
	FROM '||V_ESQUEMA||'.DD_STC_SUBTIPO_CARGA
	WHERE DD_STC_CODIGO = MIG.SUBTIPO_CARGA)                DD_STC_ID,
	MIG.CRG_DESCRIPCION								                      CRG_DESCRIPCION,
	MIG.CRG_ORDEN							                              CRG_ORDEN,
	MIG.CRG_FECHA_CANCEL_REGISTRAL							            CRG_FECHA_CANCEL_REGISTRAL,
	0                                                 	    VERSION,
	''MIGRAREM01BNK''                                               	USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	0                                                     	BORRADO
	FROM MIG_CARGAS MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
	ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA_2||' CRG 
    WHERE CRG.ACT_ID = MIG.ACT_ID
    )
    AND NOTT.ACT_NUM_ACTIVO IS NULL
	')
	;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
  
  -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(BIE_CAR_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = ''MIGRAREM01BNK''
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
   V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TCA_TIPO_CARGA'',''DD_STC_SUBTIPO_CARGA'')
	AND FICHERO_ORIGEN = ''CARGAS_ACTIVO.dat''
	AND CAMPO_ORIGEN IN (''TIPO_CARGA'',''SUBTIPO_CARGA'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
   V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por ACTIVOS inexistentes en ACT_ACTIVO.';
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
  
  -- TABLA_2
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(ACT_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE USUARIOCREAR = ''MIGRAREM01BNK''
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
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
	'''||V_TABLA_2||''',
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
