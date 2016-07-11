--/*
--#########################################
--## AUTOR=Manuel Rodriguez
--## FECHA_CREACION=20160309
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ATR_TRABAJO' -> 'ACT_TBJ_TRABAJO', 'ACT_TBJ'
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_TBJ_TRABAJO';
V_TABLA_2 VARCHAR2(40 CHAR) := 'ACT_TBJ';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ATR_TRABAJO';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_DUP NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN

   DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
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
    MIG.ACT_NUMERO_ACTIVO                              						ACT_NUM_ACTIVO,
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
  /*
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO AGRUPACIONES...');
  
  V_SENTENCIA := '
  SELECT COUNT(AGR_UVEM) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
  
  IF TABLE_COUNT_2 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LAS AGRUPACIONES EXISTEN EN ACT_AGR_AGRUPACION');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' TRABAJOS EN LOS QUE LAS AGRUPACIONES SON INEXISTENTES EN ACT_AGR_AGRUPACION. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.AGR_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.AGR_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.AGR_NOT_EXISTS (
    TABLA_MIG,
    AGR_UVEM,    
    FECHA_COMPROBACION
    )
  WITH AGR_UVEM AS (
		SELECT DISTINCT	MIG.AGR_UVEM
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
      SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM
      )
    )
    SELECT 
    '''||V_TABLA_MIG||'''                                               TABLA_MIG,
    MIG.AGR_UVEM                                        					  AGR_UVEM,                                                           
    SYSDATE                                                             FECHA_COMPROBACION
    FROM MIG_ATR_TRABAJO MIG  
    INNER JOIN AGR_UVEM AGR
    ON AGR.AGR_UVEM = MIG.AGR_UVEM
    '
    ;
    
    
    *//*
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE BORRARÁN DE '||V_ESQUEMA||'.'||V_TABLA_MIG||' LOS PROPIETARIOS INEXISTENTES. MIRAR '||V_ESQUEMA||'.PRO_NOT_EXISTS.');
    
    --SI ESTOS PROPIETARIOS NO EXISTEN EN LA TABLA DE AGRUPACIONES, SE HABRAN INFORMADO EN AGR_NOT_EXISTS Y SE BORRARAN DE LA INTERFAZ PARA NO SER INSERTADOS
    
    EXECUTE IMMEDIATE '
    DELETE 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    WHERE EXISTS (
      SELECT 1 FROM AGR_NOT_EXISTS WHERE MIG.AGR_UVEM = AGR_UVEM
    )
    '
    ;

  */
    /*
    COMMIT;

  END IF;*/
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  -- Estamos dando por hecho que el campo ACT_NUM_TRABAJO va a ser unico e identificara cada trabajo, cuando se reciban datos
  -- se comprobara si es asi, si se diera el caso de que no lo fuera, cambiar el filtro del WITH
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	TBJ_ID,
	ACT_ID,
	AGR_ID,
	TBJ_NUM_TRABAJO,
	PVC_ID,
	USU_ID,
	DD_TTR_ID,
	DD_STR_ID,
	DD_EST_ID,
	TBJ_DESCRIPCION,
	TBJ_FECHA_SOLICITUD,
	TBJ_FECHA_APROBACION,
	TBJ_FECHA_INICIO,
	TBJ_FECHA_FIN,
	TBJ_CONTINUO_OBSERVACIONES,
	TBJ_FECHA_FIN_COMPROMISO,
	TBJ_FECHA_TOPE,
	TBJ_FECHA_HORA_CONCRETA,
	TBJ_URGENTE,
	TBJ_CON_RIESGO_TERCEROS,
	TBJ_CUBRE_SEGURO,
	TBJ_CIA_ASEGURADORA,
	DD_TCA_ID,
	TBJ_TERCERO_NOMBRE,
	TBJ_TERCERO_EMAIL,
	TBJ_TERCERO_DIRECCION,
	TBJ_TERCERO_CONTACTO,
	TBJ_TERCERO_TEL1,
	TBJ_TERCERO_TEL2,
	TBJ_IMPORTE_PENAL_DIARIO,
	TBJ_OBSERVACIONES,
	TBJ_IMPORTE_TOTAL,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
  WITH TRABAJOS AS (
  SELECT * FROM (
   SELECT MIG.*, ROW_NUMBER() OVER (PARTITION BY TBJ_NUM_TRABAJO ORDER BY TBJ_FECHA_APROBACION DESC) ORDEN
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS ACTW
      ON ACTW.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    WHERE ACTW.ACT_NUM_ACTIVO IS NULL
  ) WHERE ORDEN = 1
  )
  SELECT
	'||V_ESQUEMA||'.S_ACT_TBJ_TRABAJO.NEXTVAL			                         TBJ_ID,
  NULL																	           ACT_ID,
  (SELECT AGR.AGR_ID
  FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
  WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)                 AGR_ID,
  MIG.TBJ_NUM_TRABAJO                                                                 TBJ_NUM_TRABAJO,
  (SELECT PVC.PVC_ID
  FROM '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
  WHERE PVC.PVC_DOCIDENTIF = MIG.PVC_DOCIDENTIF)                  PVC_ID,
  NULL                                                                                         USU_ID,
  (SELECT TTR.DD_TTR_ID
  FROM '||V_ESQUEMA||'.DD_TTR_TIPO_TRABAJO TTR
  WHERE TTR.DD_TTR_CODIGO = MIG.TIPO_TRABAJO)                    DD_TTR_ID,
  (SELECT STR.DD_STR_ID
  FROM '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR
  WHERE STR.DD_STR_CODIGO = MIG.SUBTIPO_TRABAJO)                 DD_STR_ID,
  (SELECT EST.DD_EST_ID
  FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST
  WHERE EST.DD_EST_CODIGO = MIG.ESTADO_TRABAJO)              DD_EST_ID,
  MIG.TBJ_DESCRIPCION                                                            TBJ_DESCRIPCION,
  MIG.TBJ_FECHA_SOLICITUD                                                        TBJ_FECHA_SOLICITUD,
  MIG.TBJ_FECHA_APROBACION                                                 TBJ_FECHA_APROBACION,
  MIG.TBJ_FECHA_INICIO                                                             TBJ_FECHA_INICIO,
  MIG.TBJ_FECHA_FIN                                                                  TBJ_FECHA_FIN,
  MIG.TBJ_CONTINUO_OBSERVACIONES                                       TBJ_CONTINUO_OBSERVACIONES,
  MIG.TBJ_FECHA_FIN_COMPROMISO                                                      TBJ_FECHA_FIN_COMPROMISO,
  MIG.TBJ_FECHA_TOPE                                                                  TBJ_FECHA_TOPE,
  MIG.TBJ_FECHA_HORA_CONCRETA                                          TBJ_FECHA_HORA_CONCRETA,
  MIG.TBJ_URGENTE                                                                 TBJ_URGENTE,
  MIG.TBJ_CON_RIESGO_TERCEROS                                                 TBJ_CON_RIESGO_TERCEROS,
  MIG.TBJ_CUBRE_SEGURO                                                       TBJ_CUBRE_SEGURO,
  MIG.TBJ_CIA_ASEGURADORA                                                    TBJ_CIA_ASEGURADORA,
  (SELECT TCA.DD_TCA_ID
  FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CALIDAD TCA
  WHERE TCA.DD_TCA_CODIGO = MIG.TIPO_CALIDAD)               DD_TCA_ID,
  MIG.TBJ_TERCERO_NOMBRE                                                     TBJ_TERCERO_NOMBRE,
  MIG.TBJ_TERCERO_EMAIL                                                       TBJ_TERCERO_EMAIL,
  MIG.TBJ_TERCERO_DIRECCION                                               TBJ_TERCERO_DIRECCION,
  MIG.TBJ_TERCERO_CONTACTO                                               TBJ_TERCERO_CONTACTO,
  MIG.TBJ_TERCERO_TEL1                                                       TBJ_TERCERO_TEL1,
  MIG.TBJ_TERCERO_TEL2                                                         TBJ_TERCERO_TEL2,
  MIG.TBJ_IMPORTE_PENAL_DIARIO                                            TBJ_IMPORTE_PENAL_DIARIO,
  MIG.TBJ_OBSERVACIONES                                                         TBJ_OBSERVACIONES,
  MIG.TBJ_IMPORTE_TOTAL                                                        TBJ_IMPORTE_TOTAL,
  ''0''                                                                                         VERSION,
  ''MIG''                                                                                    USUARIOCREAR,
  SYSDATE                                                                            FECHACREAR,
  0                                                                                         BORRADO
	FROM TRABAJOS MIG
	')
	;

  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'.');
 
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
	ACT_ID,
	TBJ_ID,
	ACT_TBJ_PARTICIPACION,
	VERSION
	)
	WITH EXISTENTES AS (
		SELECT DISTINCT ACT_ID, TBJ_ID
		FROM '||V_ESQUEMA||'.'||V_TABLA_2||' TBJ
	),
  INSERTAR AS (
    SELECT DISTINCT ACT.ACT_ID, TBJ.TBJ_ID
		FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ
    INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
      ON TBJ.TBJ_NUM_TRABAJO = MIG.TBJ_NUM_TRABAJO
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
      ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  )
	SELECT 
	TBJ.ACT_ID  					ACT_ID,
	TBJ.TBJ_ID						TBJ_ID,
	0								ACT_TBJ_PARTICIPACION,
	0								VERSION
	FROM INSERTAR TBJ
	LEFT JOIN EXISTENTES EXI
		ON EXI.TBJ_ID = TBJ.TBJ_ID
	WHERE EXI.TBJ_ID IS NULL
    AND EXI.ACT_ID IS NULL
	')
	;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '
  SELECT COUNT(*) FROM (
    SELECT MIG.*, ROW_NUMBER() OVER (PARTITION BY TBJ_NUM_TRABAJO ORDER BY TBJ_FECHA_APROBACION DESC) ORDEN
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  ) WHERE ORDEN = 1
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(TBJ_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TTR_TIPO_TRABAJO'',''DD_STR_SUBTIPO_TRABAJO'',''DD_EST_ESTADO_TRABAJO'',''DD_TCA_TIPO_CALIDAD'')
	AND FICHERO_ORIGEN = ''TRABAJO.dat''
	AND CAMPO_ORIGEN IN (''TIPO_TRABAJO'',''SUBTIPO_TRABAJO'',''ESTADO_TRABAJO'',''TIPO_CALIDAD'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
  
    IF TABLE_COUNT != 0 THEN
    
      V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por ACTIVOS inexistentes. ';
    
    END IF;
    
    IF TABLE_COUNT_2 != 0 THEN
    
      V_OBSERVACIONES := V_OBSERVACIONES||' '||TABLE_COUNT_2||' rechazados por AGRUPACIONES inexistentes. ';
    
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
  
  
  -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(ACT_NUMERO_ACTIVO) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(TBJ_ID) FROM '||V_ESQUEMA||'.'||V_TABLA_2||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
 
  -- Observaciones
  EXECUTE IMMEDIATE '
  SELECT COUNT(*) FROM (
  select act_numero_activo , tbj_num_trabajo, count(*) from '||V_ESQUEMA||'.'||V_TABLA_MIG||' group by act_numero_activo, tbj_num_trabajo having count(*) > 1
  )
  '
  INTO V_DUP
  ;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
  
    IF TABLE_COUNT != 0 THEN
    
      V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por ACTIVOS inexistentes. ';
    
    END IF;
    
    IF TABLE_COUNT_2 != 0 THEN
    
      V_OBSERVACIONES := V_OBSERVACIONES||' '||TABLE_COUNT_2||' rechazados por AGRUPACIONES inexistentes. ';
    
    END IF;
    
    IF V_DUP != 0 THEN
    
      V_OBSERVACIONES := V_OBSERVACIONES||' '||V_DUP||' rechazados por registros duplicados. ';
      
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
