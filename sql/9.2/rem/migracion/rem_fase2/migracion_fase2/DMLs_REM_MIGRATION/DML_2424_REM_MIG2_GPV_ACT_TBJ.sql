--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161014
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GPV_ACT_TBJ -> GPV_ACT & GPC_TBJ
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

TABLE_COUNT    NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
TABLE_COUNT_3 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA_1 VARCHAR2(40 CHAR) := 'GPV_ACT';
V_TABLA_2 VARCHAR2(40 CHAR) := 'GPV_TBJ';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GPV_ACT_TBJ';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS_1 NUMBER(10,0) := 0;
V_REG_INSERTADOS_2 NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
    
  --COMPROBACIONES PREVIAS - ACTIVOS
  DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.GPT_ACT_NUMERO_ACTIVO
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
                MIG.GPT_ACT_NUMERO_ACTIVO 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.GPT_ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                )
    )
    SELECT DISTINCT
    MIG.GPT_ACT_NUMERO_ACTIVO                                                                   ACT_NUM_ACTIVO,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN ACT_NUM_ACTIVO
    ON ACT_NUM_ACTIVO.GPT_ACT_NUMERO_ACTIVO = MIG.GPT_ACT_NUMERO_ACTIVO
    '
    ;
    
    COMMIT;

  END IF;
  
      --COMPROBACIONES PREVIAS - ACT_TBJ_TRABAJO
      DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO ACT_TBJ_TRABAJO...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ 
        WHERE TBJ.TBJ_NUM_TRABAJO = MIG2.GPT_TBJ_NUM_TRABAJO
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
      
      IF TABLE_COUNT_2 = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TBJ_NUM_TRABAJO EXISTEN EN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' TBJ_NUM_TRABAJO INEXISTENTES EN ACT_TBJ_TRABAJO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_TBJ_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_TBJ_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_TBJ_NOT_EXISTS (
            TABLA_MIG,
            TBJ_NUM_TRABAJO,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.GPT_TBJ_NUM_TRABAJO 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
              WHERE MIG2.GPT_TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GPT_TBJ_NUM_TRABAJO                                                    TBJ_NUM_TRABAJO,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GPT_TBJ_NUM_TRABAJO = MIG2.GPT_TBJ_NUM_TRABAJO
          '
          ;
          
          COMMIT;      
      
      END IF;

          --COMPROBACIONES PREVIAS - GASTOS_PROVEEDOR
      DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBANDO GASTOS_PROVEEDOR...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
        WHERE GPV.GPV_NUM_GASTO_HAYA = MIG2.GPT_GPV_ID
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_3;
      
      IF TABLE_COUNT_3 = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS GASTOS_PROVEEDOR EXISTEN EN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_3||' GASTOS_PROVEEDOR INEXISTENTES EN GPV_GASTOS_PROVEEDOR. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_GPV_NOT_EXISTS (
            TABLA_MIG,
            GPV_NUM_GASTO_HAYA,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.GPT_GPV_ID 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
              WHERE MIG2.GPT_GPV_ID = GPV.GPV_NUM_GASTO_HAYA
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.GPT_GPV_ID                                                                                                 GPV_NUM_GASTO_HAYA,          
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.GPT_GPV_ID = MIG2.GPT_GPV_ID
          '
          ;
          
          COMMIT;      
      
      END IF;

          --Inicio del proceso de volcado sobre GPV_ACT
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_1||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_1||' (
                GPV_ACT_ID,
                GPV_ID,
                ACT_ID,
                VERSION
                )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA_1||'.NEXTVAL                               GPV_ACT_ID, 
                GPV.GPV_ID                                                                                                              GPV_ID,
                ACT.ACT_ID                                                                              ACT_ID,
                0                                                                               VERSION
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                        ON GPV.GPV_NUM_GASTO_HAYA = MIG.GPT_GPV_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT 
                        ON ACT.ACT_NUM_ACTIVO_UVEM = MIG.GPT_ACT_NUMERO_ACTIVO
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_1||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS_1 := SQL%ROWCOUNT;
      
       V_SENTENCIA := '
        MERGE INTO '||V_ESQUEMA||'.'||V_TABLA_1||' GPV
        USING ( 
                                WITH SUMATORIO AS(
                                        SELECT GPT_ACT_NUMERO_ACTIVO, SUM(GPT_BASE_IMPONIBLE) AS SUMA
                                        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'
                                        GROUP BY GPT_ACT_NUMERO_ACTIVO
                                )
                                SELECT MIG2.GPT_GPV_ID, ACT.ACT_ID, GPT_BASE_IMPONIBLE, ROUND(100*GPT_BASE_IMPONIBLE/OPERACION.SUMA,4) AS SUMA FROM MIG2_GPV_ACT_TBJ MIG2
                                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                                  ON ACT.ACT_NUM_ACTIVO = MIG2.GPT_ACT_NUMERO_ACTIVO
                                INNER JOIN SUMATORIO OPERACION
                                  ON MIG2.GPT_ACT_NUMERO_ACTIVO = OPERACION.GPT_ACT_NUMERO_ACTIVO                                       
                          ) AUX
                ON (GPV.ACT_ID = AUX.ACT_ID AND GPV.GPV_ID = AUX.GPT_GPV_ID)
                WHEN MATCHED THEN UPDATE SET
                  GPV.GPV_PARTICIPACION_GASTO = AUX.SUMA
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_1||' actualizada (GPV_PARTICIPACION_GASTO). '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_1||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_1||' ANALIZADA.');
          
      --Inicio del proceso de volcado sobre GPV_TBJ
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA_2||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_2||' (
                GPV_TBJ_ID,
                GPV_ID,
                TBJ_ID,
                VERSION
                )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA_2||'.NEXTVAL                               GPV_TBJ_ID, 
                GPV.GPV_ID                                                                                                              GPV_ID,
                TBJ.TBJ_ID                                                                              TBJ_ID,
                0                                                                               VERSION
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV 
                        ON GPV.GPV_NUM_GASTO_HAYA = MIG.GPT_GPV_ID
                INNER JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ 
                        ON TBJ.TBJ_NUM_TRABAJO = MIG.GPT_TBJ_NUM_TRABAJO
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA_2||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS_2 := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA_2||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA_2||' ANALIZADA.');
      
      
      -- INFORMAMOS A LA TABLA INFO GPV_ACT      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
            
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS_1;      
      
      -- Observaciones
      IF V_REJECTS != 0 THEN
            V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';
            
            IF TABLE_COUNT != 0  THEN
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay  '||TABLE_COUNT||' ACTIVOS inexistentes';
            END IF;
            
            IF TABLE_COUNT_3 != 0 THEN
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_3||' GASTOS_PROVEEDOR inexistentes.';
            END IF;
      END IF;
        
      V_SENTENCIA := '
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
      '''||V_TABLA_1||''',
      '||V_REG_MIG||',
      '||V_REG_INSERTADOS_1||',
      '||V_REJECTS||',
      '||V_COD||',
      SYSDATE,
      '''||V_OBSERVACIONES||'''
      FROM DUAL
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      COMMIT;  
      
      
      -- INFORMAMOS A LA TABLA INFO GPV_TBJ      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS_2;      
      
      -- Observaciones
            IF V_REJECTS != 0 THEN
            V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';
            
            IF TABLE_COUNT_2 != 0 THEN
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_2||' TRABAJOS inexistentes.';
            END IF;
            
            IF TABLE_COUNT_3 != 0  THEN
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay  '||TABLE_COUNT_3||' GASTOS_PROVEEDOR inexistentes';
            END IF;
      END IF;
        
      V_SENTENCIA := '
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
      '||V_REG_INSERTADOS_2||',
      '||V_REJECTS||',
      '||V_COD||',
      SYSDATE,
      '''||V_OBSERVACIONES||'''
      FROM DUAL
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
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
