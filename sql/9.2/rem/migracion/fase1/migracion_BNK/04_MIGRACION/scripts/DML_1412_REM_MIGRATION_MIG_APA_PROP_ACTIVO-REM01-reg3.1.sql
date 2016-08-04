--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160229
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_APA_PROP_ACTIVO' -> 'ACT_PAC_PROPIETARIO_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PAC_PROPIETARIO_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_APA_PROP_ACTIVO';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_COD_NULLS NUMBER(10,0) := 0;
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
  
  DBMS_OUTPUT.PUT_LINE('[INFO] [ACT_PAC_PROPIETARIO_ACTIVO] COMPROBANDO PROPIETARIOS...');
  --COMPROBAMOS QUE PARA LOS PROPIETARIOS QUE NOS VIENEN APROVISIONADOS EXISTEN REGISTROS EN LA TABLA DE PROPIETARIOS
  
  V_SENTENCIA := '
  SELECT COUNT(PRO_CODIGO_UVEM) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_CODIGO_UVEM = MIG.PRO_CODIGO_UVEM
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
  
  IF TABLE_COUNT_2 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS PROPIETARIOS EXISTEN EN ACT_PAC_PROPIETARIO_ACTIVO');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' PROPIETARIOS INEXISTENTES EN ACT_PAC_PROPIETARIO_ACTIVO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.PRO_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.PRO_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.PRO_NOT_EXISTS (
    PRO_CODIGO_UVEM,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
	WITH PRO_CODIGO_UVEM AS (
		SELECT DISTINCT	MIG.PRO_CODIGO_UVEM 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO WHERE MIG.PRO_CODIGO_UVEM = PRO_CODIGO_UVEM
		)
    )
    SELECT 
    MIG.PRO_CODIGO_UVEM                              							    PRO_CODIGO_UVEM,
    '''||V_TABLA_MIG||'''                                                       TABLA_MIG,
    SYSDATE                                                                      FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN PRO_CODIGO_UVEM PRO
    ON PRO.PRO_CODIGO_UVEM = MIG.PRO_CODIGO_UVEM
    '
    ;
    
    
    /*
    
    DBMS_OUTPUT.PUT_LINE('[INFO] SE BORRARÁN DE '||V_ESQUEMA||'.'||V_TABLA_MIG||' LOS PROPIETARIOS INEXISTENTES. MIRAR '||V_ESQUEMA||'.PRO_NOT_EXISTS.');
    
    --SI ESTOS PROPIETARIOS NO EXISTEN EN LA TABLA DE PROPIETARIOS, SE HABRAN INFORMADO EN PRO_NOT_EXISTS Y SE BORRARAN DE LA INTERFAZ PARA NO SER INSERTADOS
    
    EXECUTE IMMEDIATE '
    DELETE 
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    WHERE EXISTS (
      SELECT 1 FROM PRO_NOT_EXISTS WHERE MIG.PRO_CODIGO_UVEM = PRO_CODIGO_UVEM
    )
    '
    ;

  */
    
    COMMIT;

  END IF;
  
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	PAC_ID,
	ACT_ID,
	PRO_ID,
	DD_TGP_ID,
	PAC_PORC_PROPIEDAD,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH MIG AS (
		SELECT DISTINCT (ACT_NUMERO_ACTIVO),
		PRO_CODIGO_UVEM,
		GRADO_PROPIEDAD,
		PORCENTAJE
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL						    PAC_ID,
	(SELECT ACT_ID
	FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
	WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO)     	     ACT_ID,
	(SELECT PRO_ID
	FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO ACT 
	WHERE ACT.PRO_CODIGO_UVEM = MIG.PRO_CODIGO_UVEM)		         PRO_ID,
	(SELECT DD_TGP_ID
	FROM '||V_ESQUEMA||'.DD_TGP_TIPO_GRADO_PROPIEDAD  
	WHERE DD_TGP_CODIGO = MIG.GRADO_PROPIEDAD)				                DD_TGP_ID,
	MIG.PORCENTAJE                 					                                          		PAC_PORC_PROPIEDAD,
	''0''                                                                                          	VERSION,
	''MIG''                                                                                         	USUARIOCREAR,
	SYSDATE                                                                                	FECHACREAR,
	0                                                                                           	BORRADO
	FROM MIG
	LEFT JOIN '||V_ESQUEMA||'.ACT_NOT_EXISTS NOTA
      ON NOTA.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  LEFT JOIN '||V_ESQUEMA||'.PRO_NOT_EXISTS NOTP
      ON NOTP.PRO_CODIGO_UVEM = MIG.PRO_CODIGO_UVEM
    WHERE NOTA.ACT_NUM_ACTIVO IS NULL
    AND NOTP.PRO_CODIGO_UVEM IS NULL
	')
	;
	/*WITH MIG AS (
    SELECT DISTINCT (ACT_NUMERO_ACTIVO),
    PRO_CODIGO_UVEM,
    GRADO_PROPIEDAD,
    PORCENTAJE
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
    WHERE GRADO_PROPIEDAD IS NOT NULL
	)*/

	
  
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
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
    SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TGP_TIPO_GRADO_PROPIEDAD'')
	AND FICHERO_ORIGEN = ''PROPIETARIOS_ACTIVO.dat''
	AND CAMPO_ORIGEN IN (''GRADO_PROPIEDAD'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
  /*V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  WHERE GRADO_PROPIEDAD IS NULL
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD_NULLS;*/
  
  V_COD := V_COD + V_COD_NULLS;
   
  -- Observaciones
  IF V_REJECTS != 0 THEN
	IF TABLE_COUNT != 0 THEN
		V_OBSERVACIONES := 'Se han rechazado '||TABLE_COUNT||' por ACTIVOS inexistentes en ACT_ACTIVO.';
	END IF;
	IF TABLE_COUNT_2 != 0 THEN
		V_OBSERVACIONES := V_OBSERVACIONES || 'Se han rechazado '||TABLE_COUNT_2||' por PROPIETARIOS inexistentes en ACT_PRO_PROPIETARIO.';
	END IF;
	/*IF V_COD_NULLS != 0 THEN
		V_OBSERVACIONES := V_OBSERVACIONES || 'Se han rechazado '||V_COD_NULLS||' por CODIGO DE DICCIONARIO [NULL].';
	END IF;*/
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
