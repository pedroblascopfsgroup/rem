--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ADJ_JUDICIAL' -> 'ACT_AJD_ADJJUDICIAL', 'BIE_ADJ_ADJUDICACION (Merge)'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AJD_ADJJUDICIAL';
V_TABLA_2 VARCHAR2(40 CHAR) := 'BIE_ADJ_ADJUDICACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ADJ_JUDICIAL_BNK';
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
    SELECT 1 FROM ACT_ACTIVO ACT WHERE MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
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
		  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
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
	AJD_ID,
	ACT_ID,
	BIE_ADJ_ID,
	DD_JUZ_ID,
	DD_PLA_ID,
	DD_EDJ_ID,
	DD_EEJ_ID,
	AJD_FECHA_ADJUDICACION,
	AJD_NUM_AUTO,
	AJD_PROCURADOR,
	AJD_LETRADO,
	AJD_ID_ASUNTO,
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
		WHERE NOT EXISTS (
		  SELECT 1 
		  FROM '||V_ESQUEMA||'.'||V_TABLA||' TAB
		  WHERE ACT_ID = TAB.ACT_ID
			)
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_AJD_ADJJUDICIAL.NEXTVAL         AJD_ID,
	(SELECT ACT_ID
	  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
	  WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO)   ACT_ID,
	(SELECT BIE_ADJ_ID
	  FROM '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION BIE
	  WHERE BIE.BIE_ID = (
      SELECT BIE_ID
      FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
      WHERE 
      ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
      )
      AND BIE.USUARIOCREAR = ''MIGRAREM01BNK'')     					BIE_ADJ_ID,
	(SELECT DD_JUZ_ID
	  FROM '||V_ESQUEMA||'.DD_JUZ_JUZGADOS_PLAZA
	  WHERE DD_JUZ_CODIGO = MIG.JUZGADO)                  DD_JUZ_ID,
	(SELECT DD_PLA_ID
	  FROM '||V_ESQUEMA||'.DD_PLA_PLAZAS
	  WHERE DD_PLA_CODIGO = MIG.PLAZA_JUZGADO)            DD_PLA_ID,
	(SELECT DD_EDJ_ID
	  FROM '||V_ESQUEMA||'.DD_EDJ_ESTADO_ADJUDICACION
	  WHERE DD_EDJ_CODIGO = MIG.ESTADO_ADJUDICACION)      DD_EDJ_ID,
	(SELECT DD_EEJ_ID
	  FROM '||V_ESQUEMA||'.DD_EEJ_ENTIDAD_EJECUTANTE
	  WHERE DD_EEJ_CODIGO = MIG.ENTIDAD_EJECUTANTE)       DD_EEJ_ID,
	MIG.ADJ_FECHA_ADJUDICACION                            AJD_FECHA_ADJUDICACION,
	MIG.ADJ_NUM_AUTO                                      AJD_NUM_AUTO,
	MIG.ADJ_PROCURADOR                                    AJD_PROCURADOR,
	MIG.ADJ_LETRADO                                       AJD_LETRADO,
	MIG.ADJ_ID_ASUNTO                                     AJD_ID_ASUNTO,
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
  
  --------
    
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'. [BIE_ADJ_F_SEN_POSESION, BIE_ADJ_IMPORTE_ADJUDICACION y ADJ_FECHA_DECRETO_FIRME]');

	EXECUTE IMMEDIATE ('
	MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_2||' BIE 
	USING (
		SELECT ACT.BIE_ADJ_ID, MIG.ADJ_IMPORTE, MIG.ADJ_FECHA_SEN_POSESION, MIG.ADJ_FECHA_DECRETO_FIRME
		FROM '||V_ESQUEMA||'.'||V_TABLA||' ACT
		INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACTIV
		ON ACTIV.ACT_ID = ACT.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		ON MIG.ACT_NUMERO_ACTIVO = ACTIV.ACT_NUM_ACTIVO
	) TMP
	ON (BIE.BIE_ADJ_ID = TMP.BIE_ADJ_ID)
	WHEN MATCHED THEN UPDATE SET
	BIE.BIE_ADJ_F_SEN_POSESION = TMP.ADJ_FECHA_SEN_POSESION,
	BIE.BIE_ADJ_IMPORTE_ADJUDICACION = TMP.ADJ_IMPORTE,
	BIE.BIE_ADJ_F_DECRETO_FIRME = TMP.ADJ_FECHA_DECRETO_FIRME
	')  
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' actualizada. '||SQL%ROWCOUNT||' Filas. Merge.');
  
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
	SELECT COUNT(ACT_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_JUZ_JUZGADOS_PLAZA'',''DD_PLA_PLAZAS'',''DD_EDJ_ESTADO_ADJUDICACION'',''DD_EEJ_ENTIDAD_EJECUTANTE'')
	AND FICHERO_ORIGEN = ''ACTIVO_ADJ_JUDICIAL.dat''
	AND CAMPO_ORIGEN IN (''JUZGADO'',''PLAZA_JUZGADO'',''ESTADO_ADJUDICACION'',''ENTIDAD_EJECUTANTE'')
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
