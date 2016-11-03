--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_ASA_SUBDIVISIONES_AGRUP' -> 'ACT_SDV_SUBDIVISION_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_SDV_SUBDIVISION_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_ASA_SUBDIVISION_AGRUP_BNK';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO AGRUPACIONES...');
  
  V_SENTENCIA := '
  SELECT COUNT(AGR_UVEM) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR WHERE MIG.AGR_UVEM = AGR.AGR_NUM_AGRUP_UVEM
  )
  '
  ;
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS AGRUPACIONES EXISTEN EN ACT_AGR_AGRUPACION');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' AGRUPACIONES INEXISTENTES EN ACT_AGR_AGRUPACION. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.AGR_NOT_EXISTS.');
  
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.AGR_NOT_EXISTS (
	TABLA_MIG,
	AGR_UVEM,
	FECHA_COMPROBACION
    )
    WITH AGR_UVEM AS (
		SELECT
		MIG.AGR_UVEM 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION WHERE MIG.AGR_UVEM = AGR_NUM_AGRUP_UVEM
		)
    )
    SELECT
    '''||V_TABLA_MIG||'''							TABLA_MIG,
    MIG.AGR_UVEM									AGR_UVEM,
    SYSDATE											FECHA_COMPROBACION
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
  
  -- IMPORTANTE: Se esta ignorando el campo SDV_COD_UVEM de MIG_ASA hasta que se sepa que hacer con el.
  
  -- La migracion de los datos de esta tabla se hace en funcion de los datos que ya esten migrados en ACT_ONV_OBRA_NUEVA, no esten insertados en
  --  ACT_SDV y esten para migrar en MIG_ASA.
  -- Ejemplo: Si hay X filas para migrar en MIG_ASA de las cuales el AGR_ID de sus corresponientes AGRUPACIONES no estan insertados en
  --  la tabla ACT_ONV, no se hara el migrado de tales filas, ya que daria error por FK de ACT_ONV a ACT_AGR.
  
  -- El WITH obtiene los AGR_UVEM de MIG que existen en AGRUPACIONES y OBRA_NUEVA, no estan insertados en la tabla de volcado ACT_SDV 
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	SDV_ID,
	AGR_ID,
	DD_TSB_ID,
	SDV_NOMBRE,
	SDV_NUM_HABITACIONES,
	SDV_NUM_PLANTAS_INTER,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_SDV_SUBDIVISION_ACTIVO.NEXTVAL      SDV_ID,
	(SELECT AGRID.AGR_ID
  FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGRID
  WHERE AGRID.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)        AGR_ID,
	(SELECT TSB.DD_TSB_ID 
  FROM '||V_ESQUEMA||'.DD_TSB_TIPO_SUBDIVISION TSB
  WHERE TSB.DD_TSB_CODIGO = MIG.TIPO_SUBDIVISION)             DD_TSB_ID,
	MIG.SDV_NOMBRE                                                                   SDV_NOMBRE,
	MIG.SDV_NUM_HABITACIONES                                                  SDV_NUM_HABITACIONES,
  MIG.SDV_NUM_PLANTAS_INTER                                                 SDV_NUM_PLANTAS_INTER,
	''0''                                                                                         VERSION,
	''MIGRAREM01BNK''                                                                                     USUARIOCREAR,
	SYSDATE                                                                                 FECHACREAR,
	0                                                                                           BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG	
	INNER JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
	ON AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM
	INNER JOIN '||V_ESQUEMA||'.ACT_ONV_OBRA_NUEVA ONV
	ON ONV.AGR_ID = AGR.AGR_ID
	') 
	;



  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(AGR_UVEM) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(AGR_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = ''MIGRAREM01BNK''
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TSB_TIPO_SUBDIVISION'')
	AND FICHERO_ORIGEN = ''SUBDIVISIONES_AGRUPACION.dat''
	AND CAMPO_ORIGEN IN (''TIPO_SUBDIVISION'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] Se rechazan '||V_COD||'/'||V_REG_MIG||' registros por codigos de diccionario inexistentes. [DD_TSB_TIPO_SUBDIVISION]');
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
	V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por AGRUPACIONES inexistentes en ACT_AGR_AGRUPACION.';
     
	IF V_COD != 0 THEN
		V_SENTENCIA := '
		SELECT COUNT(1)
		FROM MIG_ASA_SUBDIVISIONES_AGRUP MIG
		INNER JOIN ACT_AGR_AGRUPACION AGR
		  ON AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM
		INNER JOIN ACT_ONV_OBRA_NUEVA ONV
		  ON ONV.AGR_ID = AGR.AGR_ID
		AND MIG.TIPO_SUBDIVISION = ''UNDEFINED''
		OR MIG.TIPO_SUBDIVISION IS NULL
		'	
		;
		EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;	
	
		V_OBSERVACIONES := V_OBSERVACIONES|| ' Y '||TABLE_COUNT||' registros deberian haber sido insertados, pero traen un DICCIONARIO invalido.';
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
