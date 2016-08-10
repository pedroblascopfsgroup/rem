--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ATI_TITULO' -> 'ACT_TIT_TITULO'
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_TIT_TITULO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATI_TITULO_BNK';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO NUMEROS DE ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM ACT_ACTIVO WHERE MIG.ACT_NUMERO_ACTIVO = ACT_NUM_ACTIVO
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
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	TIT_ID,
	ACT_ID,
	DD_ETI_ID,
	TIT_FECHA_ENTREGA_GESTORIA,
	TIT_FECHA_PRESENT_HACIENDA,
	TIT_FECHA_ENVIO_AUTO,
	TIT_FECHA_PRESENT1_REG,
	TIT_FECHA_PRESENT2_REG,
	TIT_FECHA_INSC_REG,
	TIT_FECHA_RETIRADA_REG,
	TIT_FECHA_NOTA_SIMPLE,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	USUARIOMODIFICAR,
	FECHAMODIFICAR,
	USUARIOBORRAR,
	FECHABORRAR,
	BORRADO
	)
	WITH ACT_NUM_ACTIVO AS (
		SELECT ACT_NUMERO_ACTIVO 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		WHERE ACT_NUMERO_ACTIVO NOT IN (
		  SELECT ACT_NUM_ACTIVO 
		  FROM '||V_ESQUEMA||'.ACT_ACTIVO 
		  WHERE ACT_ID IN (
			SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' 
			)
			)
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_TIT_TITULO.NEXTVAL              TIT_ID,
	(SELECT ACT_ID
		FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
		WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO) ACT_ID,
	(SELECT DD_ETI_ID
	  FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO DD
	  WHERE DD_ETI_CODIGO = MIG.ESTADO_TITULO)            DD_ETI_ID,
	MIG.TIT_FECHA_ENTREGA_GESTORIA                        TIT_FECHA_ENTREGA_GESTORIA,
	MIG.TIT_FECHA_PRESENT_HACIENDA                        TIT_FECHA_PRESENT_HACIENDA,
	MIG.TIT_FECHA_ENVIO_AUTO                              TIT_FECHA_ENVIO_AUTO,
	MIG.TIT_FECHA_PRESENT1_REG                            TIT_FECHA_PRESENT1_REG,
	MIG.TIT_FECHA_PRESENT2_REG                            TIT_FECHA_PRESENT2_REG,
	MIG.TIT_FECHA_INSC_REG                                TIT_FECHA_INSC_REG,
	MIG.TIT_FECHA_RETIRADA_REG                            TIT_FECHA_RETIRADA_REG,
	MIG.TIT_FECHA_NOTA_SIMPLE                             TIT_FECHA_NOTA_SIMPLE,
	''0''                                                 VERSION,
	''MIGRAREM01BNK''                                               USUARIOCREAR,
	SYSDATE                                               FECHACREAR,
	NULL                                                  USUARIOMODIFICAR,
	NULL                                                  FECHAMODIFICAR,
	NULL                                                  USUARIOBORRAR,
	NULL                                                  FECHABORRAR,
	0                                                     BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTT
	ON NOTT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	INNER JOIN ACT_NUM_ACTIVO ACT
	ON ACT.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
	WHERE NOTT.ACT_NUM_ACTIVO IS NULL
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
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_ETI_ESTADO_TITULO'')
	AND FICHERO_ORIGEN = ''ACTIVO_TITULO.dat''
	AND CAMPO_ORIGEN IN (''ESTADO_TITULO'')
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
  
