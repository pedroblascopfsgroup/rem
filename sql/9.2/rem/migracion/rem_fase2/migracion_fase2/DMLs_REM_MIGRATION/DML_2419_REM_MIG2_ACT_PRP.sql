--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_ACT_PRP' -> 'ACT_PRP'
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_PRP';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_PRP';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_DUPLICADOS NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN 
  
    --COMPROBACIONES PREVIAS - ACTIVOS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_PRP_ACT_NUMERO_ACTIVO
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN ACT_ACTIVO');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' ACTIVOS INEXISTENTES EN ACT_ACTIVO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS (
    ACT_NUM_ACTIVO,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH ACT_NUM_ACTIVO AS (
                SELECT
                MIG.ACT_PRP_ACT_NUMERO_ACTIVO 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.ACT_PRP_ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                )
    )
    SELECT DISTINCT
    MIG.ACT_PRP_ACT_NUMERO_ACTIVO                                                       ACT_NUM_ACTIVO,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN ACT_NUM_ACTIVO
    ON ACT_NUM_ACTIVO.ACT_PRP_ACT_NUMERO_ACTIVO = MIG.ACT_PRP_ACT_NUMERO_ACTIVO
    '
    ;
    
    COMMIT;

  END IF;
  
  
    --COMPROBACIONES PREVIAS - PRUESTAS DE PRECIOS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO PRUESTAS DE PRECIOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.PRP_PROPUESTAS_PRECIOS PRP WHERE PRP.PRP_NUM_PROPUESTA = MIG.ACT_PRP_NUM_PROPUESTA
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
  
  IF TABLE_COUNT_2 = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN PRP_PROPUESTAS_PRECIOS');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' PRUESTAS DE PRECIOS INEXISTENTES EN PRP_PROPUESTAS_PRECIOS. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_PRP_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.MIG2_PRP_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.MIG2_PRP_NOT_EXISTS (
    PRP_NUM_PROPUESTA,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH PRP_NUM_PROPUESTA AS (
                SELECT
                MIG.ACT_PRP_NUM_PROPUESTA 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.PRP_PROPUESTAS_PRECIOS PRP WHERE MIG.ACT_PRP_NUM_PROPUESTA = PRP.PRP_NUM_PROPUESTA
                )
    )
    SELECT DISTINCT
    MIG.ACT_PRP_NUM_PROPUESTA                                                                   PRP_NUM_PROPUESTA,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN PRP_NUM_PROPUESTA
    ON PRP_NUM_PROPUESTA.ACT_PRP_NUM_PROPUESTA = MIG.ACT_PRP_NUM_PROPUESTA
    '
    ;
    
    COMMIT;

  END IF;  
  
  --Inicio del proceso de volcado sobre RES_RESERVAS
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE ('
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        ACT_ID,
        PRP_ID,
        ACT_PRP_PRECIO_PROPUESTO,
        ACT_PRP_PRECIO_SANCIONADO,
        ACT_PRP_MOTIVO_DESCARTE,
        VERSION
        ) WITH DUPLICADOS AS(
                          SELECT DISTINCT ACT_PRP_ACT_NUMERO_ACTIVO, ACT_PRP_NUM_PROPUESTA
                          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
                          GROUP BY ACT_PRP_ACT_NUMERO_ACTIVO, ACT_PRP_NUM_PROPUESTA 
                          HAVING COUNT(1) > 1
          )
        SELECT 
        ACT.ACT_ID                                                                                                                      ACT_ID,
        PRP.PRP_ID                                                                                                                      PRP_ID,
        MIG.ACT_PRP_PRECIO_PROPUESTO                                                                            ACT_PRP_PRECIO_PROPUESTO,
        MIG.ACT_PRP_PRECIO_SANCIONADO                                                                           ACT_PRP_PRECIO_SANCIONADO,
        MIG.ACT_PRP_MOTIVO_DESCARTE                                                                                     ACT_PRP_MOTIVO_DESCARTE,
        ''0''                                                                           VERSION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG              
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                ON ACT.ACT_NUM_ACTIVO = MIG.ACT_PRP_ACT_NUMERO_ACTIVO
        INNER JOIN '||V_ESQUEMA||'.PRP_PROPUESTAS_PRECIOS PRP
                ON PRP.PRP_NUM_PROPUESTA = MIG.ACT_PRP_NUM_PROPUESTA
        WHERE NOT EXISTS (
            SELECT 1
            FROM DUPLICADOS DUP
            WHERE DUP.ACT_PRP_ACT_NUMERO_ACTIVO = MIG.ACT_PRP_ACT_NUMERO_ACTIVO
            AND DUP.ACT_PRP_NUM_PROPUESTA = MIG.ACT_PRP_NUM_PROPUESTA)
        ')
        ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  V_REG_INSERTADOS := SQL%ROWCOUNT;
  
  COMMIT;
  
  EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
  
  --VALIDACION DE DUPLICADOS
  V_SENTENCIA := '
  SELECT SUM(COUNT(1))
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
  GROUP BY ACT_PRP_ACT_NUMERO_ACTIVO, ACT_PRP_NUM_PROPUESTA
  HAVING COUNT(1) > 1
  '
  ;  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_DUPLICADOS;
  
   -- INFORMAMOS A LA TABLA INFO
  
  -- Registros MIG
  V_SENTENCIA := '  SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';
 EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
 
 -- Registros insertados en REM
 -- V_REG_INSERTADOS
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
    V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';    
    
    IF TABLE_COUNT != 0 THEN    
      V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' ACTIVOS inexistentes. ';    
    END IF;     
    
    IF TABLE_COUNT_2 != 0 THEN    
      V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_2||' PRUESTAS DE PRECIOS inexistentes. ';    
    END IF; 
    
    IF V_DUPLICADOS != 0 THEN
                        V_OBSERVACIONES := V_OBSERVACIONES||' Hay '||V_DUPLICADOS||' ACT_PRP_ACT_NUMERO_ACTIVO, ACT_PRP_NUM_PROPUESTA duplicados. ';    
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
