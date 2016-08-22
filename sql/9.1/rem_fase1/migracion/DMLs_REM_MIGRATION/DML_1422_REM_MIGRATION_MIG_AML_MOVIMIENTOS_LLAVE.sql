--/*
--#########################################
--## AUTOR=Manuel Rodriguez
--## FECHA_CREACION=20160308
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-166
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AML_MOVIMIENTOS_LLAVE' -> 'ACT_MLV_MOVIMIENTO_LLAVE'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_MLV_MOVIMIENTO_LLAVE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AML_MOVIMIENTOS_LLAVE';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
  
  
  V_SENTENCIA := '
  SELECT COUNT(LLV_CODIGO_UVEM) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.MIG_ALA_LLAVES_ACTIVO MIGG WHERE MIG.LLV_CODIGO_UVEM = MIGG.LLV_CODIGO_UVEM
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS LLAVES EXISTEN EN ACT_LLV_LLAVE');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||TABLE_COUNT||' LLAVES NO EXISTEN EN ACT_LLV_LLAVE.');
  
  
  END IF;

	EXECUTE IMMEDIATE ('
	INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
	MLV_ID,
	LLV_ID,
	DD_TTE_ID,
	MLV_COD_TENEDOR,
	MLV_NOM_TENEDOR,
	MLV_FECHA_ENTREGA,
	MLV_FECHA_DEVOLUCION,
	VERSION,
	USUARIOCREAR,
	FECHACREAR,
	BORRADO
	)
	WITH LLV_CODIGO_UVEM AS (
	  SELECT DISTINCT MIGW.LLV_CODIGO_UVEM, MIGG.LLV_ID
	  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
	  INNER JOIN '||V_ESQUEMA||'.MIG_ALA_LLAVES_ACTIVO migg
	   ON migg.LLV_CODIGO_UVEM = MIGW.LLV_CODIGO_UVEM
    WHERE MIGG.LLV_ID IS NOT NULL
  ),
  LLV_NOT_EXISTS AS (
    SELECT LLV_CODIGO_UVEM
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
    WHERE NOT EXISTS (
      SELECT 1 FROM '||V_ESQUEMA||'.MIG_ALA_LLAVES_ACTIVO MIGG WHERE MIG.LLV_CODIGO_UVEM = MIGG.LLV_CODIGO_UVEM
  )
  )
	SELECT
	'||V_ESQUEMA||'.S_ACT_MLV_MOVIMIENTO_LLAVE.NEXTVAL      MLV_ID,
	LLV.LLV_ID                                               		LLV_ID,
	(SELECT DD_TTE_ID
	FROM '||V_ESQUEMA||'.DD_TTE_TIPO_TENEDOR
	WHERE DD_TTE_CODIGO = MIG.MLV_TIPO_TENEDOR)                DD_TTE_ID,
	MIG.MLV_COD_TENEDOR                                       MLV_COD_TENEDOR,
	MIG.MLV_NOM_TENEDOR                                       MLV_NOM_TENEDOR,
	MIG.MLV_FECHA_ENTREGA	                                 MLV_FECHA_ENTREGA,
	MIG.MLV_FECHA_DEVOLUCION                                     MLV_FECHA_DEVOLUCION,
	''0''                                                     VERSION,
	''MIG''                                                   USUARIOCREAR,
	SYSDATE                                                   FECHACREAR,
	0                                                         BORRADO
	FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
	INNER JOIN LLV_CODIGO_UVEM LLV
    ON LLV.LLV_CODIGO_UVEM = MIG.LLV_CODIGO_UVEM
  LEFT JOIN LLV_NOT_EXISTS NOTT
    ON NOTT.LLV_CODIGO_UVEM = MIG.LLV_CODIGO_UVEM
  WHERE NOTT.LLV_CODIGO_UVEM IS NULL
	')
	;



  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  -- Registros MIG
  V_SENTENCIA := '
	SELECT COUNT(LLV_CODIGO_UVEM) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
  
  -- Registros insertados en REM
  V_SENTENCIA := '
	SELECT COUNT(MLV_ID) FROM '||V_ESQUEMA||'.'||V_TABLA||'
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
  
  -- Diccionarios rechazados
  V_SENTENCIA := '
  SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
	WHERE DICCIONARIO IN (''DD_TTE_TIPO_TENEDOR'')
	AND FICHERO_ORIGEN = ''MOVIMIENTOS_LLAVE.dat''
	AND CAMPO_ORIGEN IN (''MLV_TIPO_TENEDOR'')
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
   
  -- Observaciones
  IF V_REJECTS != 0 THEN
	IF TABLE_COUNT != 0 THEN
		V_OBSERVACIONES := 'Se han rechazado '||TABLE_COUNT||' por LLAVES inexistentes en ACT_LLV_LLAVE ';
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

