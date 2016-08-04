--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160307
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ATA_TASACIONES_ACTIVO' -> 'ACT_TAS_TASACION', 'BIE_VALORACIONES'
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
V_TABLA VARCHAR2(40 CHAR) := 'BIE_VALORACIONES';
V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_TAS_TASACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATA_TASACIONES_ACTIVO';
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
  
  --REGISTRAMOS TAS_ID Y BIE_VAL_ID
  
  EXECUTE IMMEDIATE ('
  UPDATE '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  SET
  BIE_VAL_ID = S_BIE_VALORACIONES.NEXTVAL,
  TAS_ID = S_ACT_TAS_TASACION.NEXTVAL
  WHERE BIE_VAL_ID IS NULL
  OR TAS_ID IS NULL
  ')
  ;
  
  COMMIT; 
  
  --DAMOS REGISTROS EN ALTA BIE_VALORACIONES PARA LOS ACTIVOS QUE TRATAMOS
  
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
  BIE_VAL_ID,
  BIE_ID,
  BIE_IMPORTE_VALOR_TASACION,
  BIE_FECHA_VALOR_TASACION,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO
  )
  WITH ACTIVOS AS (
	SELECT 
	ACT_ID, BIE_VAL_ID, TAS_ID, BIE_ID, MIG.ACT_NUMERO_ACTIVO, MIG.TAS_IMPORTE_VALOR_TASACION, MIG.TAS_FECHA_RECEPCION_TASACION
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
	ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  )
  SELECT
  ACT.BIE_VAL_ID													BIE_VAL_ID,
  ACT.BIE_ID                                                	  	BIE_ID,
  ACT.TAS_IMPORTE_VALOR_TASACION									BIE_IMPORTE_VALOR_TASACION,
  ACT.TAS_FECHA_RECEPCION_TASACION									BIE_FECHA_VALOR_TASACION,
  ''0''                                                             VERSION,
  ''MIG''                                                           USUARIOCREAR,
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
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');

  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO REGISTROS EN '||V_ESQUEMA||'.'||V_TABLA_2||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
	TAS_ID,
	ACT_ID,
	BIE_VAL_ID,
	DD_TTS_ID,
	TAS_FECHA_INI_TASACION,
	TAS_FECHA_RECEPCION_TASACION,
	TAS_CODIGO_FIRMA,
	TAS_NOMBRE_TASADOR,
	TAS_IMPORTE_TAS_FIN,
	TAS_COSTE_REPO_NETO_ACTUAL,
	TAS_COSTE_REPO_NETO_FINALIZADO,
	TAS_COEF_MERCADO_ESTADO,
	TAS_COEF_POND_VALOR_ANYADIDO,
	TAS_VALOR_REPER_SUELO_CONST,
	TAS_COSTE_CONST_CONST,
	TAS_INDICE_DEPRE_FISICA,
	TAS_INDICE_DEPRE_FUNCIONAL,
	TAS_INDICE_TOTAL_DEPRE,
	TAS_COSTE_CONST_DEPRE,
	TAS_COSTE_UNI_REPO_NETO,
	TAS_COSTE_REPOSICION,
	TAS_PORCENTAJE_OBRA,
	TAS_IMPORTE_VALOR_TER,
	TAS_ID_TEXTO_ASOCIADO,
	TAS_IMPORTE_VAL_LEGAL_FINCA,
	TAS_IMPORTE_VAL_SOLAR,
	TAS_OBSERVACIONES,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH MIG_TASACIONES AS (
		SELECT DISTINCT 
		ACT.ACT_ID,
		MIG.ACT_NUMERO_ACTIVO,
		MIG.BIE_VAL_ID,
		MIG.TAS_ID,
		MIG.TAS_CODIGO_TASA_UVEM,
		MIG.TAS_TIPO_TASACION,
		MIG.TAS_FECHA_INI_TASACION,				
		MIG.TAS_FECHA_RECEPCION_TASACION,	
		MIG.TAS_CODIGO_FIRMA,				
		MIG.TAS_NOMBRE_TASADOR,				
		MIG.TAS_IMPORTE_TAS_FIN,				
		MIG.TAS_COSTE_REPO_NETO_ACTUAL,		
		MIG.TAS_COSTE_REPO_NETO_FINALIZADO,	
		MIG.TAS_COEF_MERCADO_ESTADO,			
		MIG.TAS_COEF_POND_VALOR_ANYADIDO,	
		MIG.TAS_VALOR_REPER_SUELO_CONST,     
		MIG.TAS_COSTE_CONST_CONST,           
		MIG.TAS_INDICE_DEPRE_FISICA ,        
		MIG.TAS_INDICE_DEPRE_FUNCIONAL,      
		MIG.TAS_INDICE_TOTAL_DEPRE,          
		MIG.TAS_COSTE_CONST_DEPRE,           
		MIG.TAS_COSTE_UNI_REPO_NETO,         
		MIG.TAS_COSTE_REPOSICION,            
		MIG.TAS_PORCENTAJE_OBRA,             
		MIG.TAS_IMPORTE_VALOR_TER,           
		MIG.TAS_ID_TEXTO_ASOCIADO,           
		MIG.TAS_IMPORTE_VAL_LEGAL_FINCA ,    
		MIG.TAS_IMPORTE_VAL_SOLAR,           
		MIG.TAS_OBSERVACIONES
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
		ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
		INNER JOIN '||V_ESQUEMA||'.BIE_VALORACIONES BIE
		ON BIE.BIE_ID = ACT.BIE_ID
	)
	SELECT
	MIG.TAS_ID												TAS_ID,
	MIG.ACT_ID     											ACT_ID,
	MIG.BIE_VAL_ID                                      	BIE_VAL_ID,
	(SELECT DD_TTS_ID
	FROM '||V_ESQUEMA||'.DD_TTS_TIPO_TASACION
	WHERE DD_TTS_CODIGO = MIG.TAS_TIPO_TASACION)			DD_TTS_ID,
	MIG.TAS_FECHA_INI_TASACION								TAS_FECHA_INI_TASACION,
	MIG.TAS_FECHA_RECEPCION_TASACION						TAS_FECHA_RECEPCION_TASACION,
	MIG.TAS_CODIGO_FIRMA									TAS_CODIGO_FIRMA,
	MIG.TAS_NOMBRE_TASADOR									TAS_NOMBRE_TASADOR,
	MIG.TAS_IMPORTE_TAS_FIN									TAS_IMPORTE_TAS_FIN,
	MIG.TAS_COSTE_REPO_NETO_ACTUAL							TAS_COSTE_REPO_NETO_ACTUAL,
	MIG.TAS_COSTE_REPO_NETO_FINALIZADO						TAS_COSTE_REPO_NETO_FINALIZADO,
	MIG.TAS_COEF_MERCADO_ESTADO								TAS_COEF_MERCADO_ESTADO,
	MIG.TAS_COEF_POND_VALOR_ANYADIDO						TAS_COEF_POND_VALOR_ANYADIDO,
	MIG.TAS_VALOR_REPER_SUELO_CONST                         TAS_VALOR_REPER_SUELO_CONST,
	MIG.TAS_COSTE_CONST_CONST                               TAS_COSTE_CONST_CONST,
	MIG.TAS_INDICE_DEPRE_FISICA                             TAS_INDICE_DEPRE_FISICA,
	MIG.TAS_INDICE_DEPRE_FUNCIONAL                          TAS_INDICE_DEPRE_FUNCIONAL,
	MIG.TAS_INDICE_TOTAL_DEPRE                              TAS_INDICE_TOTAL_DEPRE,
	MIG.TAS_COSTE_CONST_DEPRE                               TAS_COSTE_CONST_DEPRE,
	MIG.TAS_COSTE_UNI_REPO_NETO                             TAS_COSTE_UNI_REPO_NETO,
	MIG.TAS_COSTE_REPOSICION                                TAS_COSTE_REPOSICION,
	MIG.TAS_PORCENTAJE_OBRA                                 TAS_PORCENTAJE_OBRA,
	MIG.TAS_IMPORTE_VALOR_TER                               TAS_IMPORTE_VALOR_TER,
	MIG.TAS_ID_TEXTO_ASOCIADO                               TAS_ID_TEXTO_ASOCIADO,
	MIG.TAS_IMPORTE_VAL_LEGAL_FINCA                         TAS_IMPORTE_VAL_LEGAL_FINCA,
	MIG.TAS_IMPORTE_VAL_SOLAR                               TAS_IMPORTE_VAL_SOLAR,
	MIG.TAS_OBSERVACIONES                                   TAS_OBSERVACIONES,
	''0''                                                 	VERSION,
	''MIG''                                               	USUARIOCREAR,
	SYSDATE                                               	FECHACREAR,
	0                                                     	BORRADO
	FROM MIG_TASACIONES MIG
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
	SELECT COUNT(BIE_VAL_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
   
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
	SELECT COUNT(ACT_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
   -- Diccionarios rechazados
   V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TTS_TIPO_TASACION'')
	AND FICHERO_ORIGEN = ''TASACIONES_ACTIVO.dat''
	AND CAMPO_ORIGEN IN (''TAS_TIPO_TASACION'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;  
  
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
