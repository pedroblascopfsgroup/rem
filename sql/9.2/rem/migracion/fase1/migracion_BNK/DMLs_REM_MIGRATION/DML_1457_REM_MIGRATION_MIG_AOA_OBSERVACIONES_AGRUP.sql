--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20160803
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-719
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AOA_OBSERVACIONES_AGRUP' -> 'ACT_AGO_AGRUPACION_OBS'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGO_AGRUPACION_OBS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AOA_OBSERVACION_AGRUP_BNK';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
VAR1 NUMBER(10,0) := 0;

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
  
  -- IMPORTANTE: ESTAMOS TENIENDO EN CUENTA QUE NOS PASEN USU_ID, SI PASARAN NOMBRES DE USUARIO PE TENDRIAMOS
  -- QUE BUSCAR LA ID QUE CORRESPONDE A ESE NOMBRE DE USUARIO PARA APLICAR EL FILTRO
  
  
  -- EL PRIMER WITH OBTIENE LOS AGR_UVEM DE LA TABLA MIG QUE EXISTEN EN AGRUPACIONES Y NO ESTAN INSERTADOS EN 
  --    LA TABLA DE VOLCADO
  
  -- EL SEGUNDO WITH OBTIENE LAS USU_ID DE LA TABLA MIG QUE EXISTEN EN LA TABLA DE USU_USUARIOS 
  
	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	AGO_ID,
	AGR_ID,
	USU_ID,
	AGO_OBSERVACION,
	AGO_FECHA,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	SELECT
	'||V_ESQUEMA||'.S_ACT_AGO_AGRUPACION_OBS.NEXTVAL		AGO_ID,
	(SELECT AGR.AGR_ID 
	  FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
	  WHERE AGR.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)    AGR_ID,
	(SELECT USU_ID 
  FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
  WHERE USU_USERNAME = ''GESTADM'')                                       USU_ID,
	MIG.AGO_OBSERVACION										                                AGO_OBSERVACION,
	MIG.AGO_FECHA											                                        AGO_FECHA,
	''0''													                                                        VERSION,
	''MIGRAREM01BNK''													                                                    USUARIOCREAR,
	SYSDATE													                                                FECHACREAR,
	0														                                                        BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	LEFT JOIN '||V_ESQUEMA||'.AGR_NOT_EXISTS NOTT
    ON NOTT.AGR_UVEM = MIG.AGR_UVEM
  WHERE NOTT.AGR_UVEM IS NULL
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
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
	V_OBSERVACIONES := 'Del total de registros rechazados, '||TABLE_COUNT||' han sido por AGRUPACIONES inexistentes en ACT_AGR_AGRUPACION.';
	
	EXECUTE IMMEDIATE '
	 SELECT COUNT(AOA.USU_ID) 
	 FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' AOA
     WHERE NOT EXISTS (
      SELECT 1 FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_ID = AOA.USU_ID
	)
	'
	INTO VAR1
	;
	
	IF VAR1 != 0 THEN
	
		V_OBSERVACIONES := V_OBSERVACIONES||' '||VAR1||' han sido rechazados por USUARIOS mal informados en MIG_AOA_OBSERVACIONES_AGRUP. ';
		
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
