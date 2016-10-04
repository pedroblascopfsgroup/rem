--/*
--#########################################
--## AUTOR=Sergio Hernández
--## FECHA_CREACION=20161003
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_ACT_COE_CONDICIONES_ESPEC -> ACT_COE_CONDICION_ESPECIFICA
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_COE_CONDICION_ESPECIFICA';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_COE_CONDICIONES_ESPEC';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

  --COMPROBACIONES PREVIAS - ACTIVOS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.COE_ACT_NUMERO_ACTIVO
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
    WITH NOEXISTE AS (
                SELECT
                MIG.COE_ACT_NUMERO_ACTIVO AS NUMERO_ACTIVO
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.COE_ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                )
    )
        SELECT DISTINCT
        MIG.COE_ACT_NUMERO_ACTIVO                                               ACT_NUM_ACTIVO,
        '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
        SYSDATE                                                                 FECHA_COMPROBACION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
        INNER JOIN NOEXISTE
    ON NOEXISTE.NUMERO_ACTIVO = MIG.COE_ACT_NUMERO_ACTIVO
    '
    ;
    
    COMMIT;

  END IF;

--    --COMPROBACIONES PREVIAS - USUARIOS
--    DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO USUARIOS...');
--    
--    V_SENTENCIA := '
--    SELECT COUNT(1) 
--    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
--    WHERE NOT EXISTS (
--      SELECT 1 FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU WHERE USU.USU_USERNAME = MIG2.COE_COD_USUARIO_ALTA
--    ) OR COE_COD_USUARIO_ALTA IS NULL
--    '
--    ;
--    EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
--    
--    IF TABLE_COUNT = 0 THEN
--    
--        DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS USUARIOS EXISTEN EN REMMASTER.USU_USUARIOS');
--    
--    ELSE
--    
--        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' USUARIOS INEXISTENTES EN USU_USUARIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS.');
--        
--        --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
--        
--        EXECUTE IMMEDIATE '
--        DELETE FROM '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS
--        WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
--        '
--        ;
--        
--        COMMIT;
--        
--        EXECUTE IMMEDIATE '
--        INSERT INTO '||V_ESQUEMA||'.MIG2_USU_NOT_EXISTS (
--          TABLA_MIG,
--          USU_USERNAME,            
--          FECHA_COMPROBACION
--        )
--        WITH USERNAME_NOT_EXISTS AS (
--          SELECT DISTINCT MIG2.COE_COD_USUARIO_ALTA 
--          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
--          WHERE NOT EXISTS (
--            SELECT 1 
--            FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU
--            WHERE MIG2.COE_COD_USUARIO_ALTA = USU.USU_USERNAME
--          )
--        )
--        SELECT DISTINCT
--        '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
--        MIG2.COE_COD_USUARIO_ALTA                                                   OFA_COD_OFERTA,          
--        SYSDATE                                                                 FECHA_COMPROBACION
--        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
--        INNER JOIN USERNAME_NOT_EXISTS ON USERNAME_NOT_EXISTS.COE_COD_USUARIO_ALTA = MIG2.COE_COD_USUARIO_ALTA
--        '
--        ;
--        
--        COMMIT;      
--    
--    END IF;

      
      --Inicio del proceso de volcado sobre la tabla principal
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                COE_ID          ,
                ACT_ID          ,
                COE_TEXTO       ,
                COE_FECHA_DESDE ,
                COE_FECHA_HASTA ,
                COE_USUARIO_ALTA,
                COE_USUARIO_BAJA,
                VERSION         ,
                USUARIOCREAR    ,
                FECHACREAR      ,
                BORRADO         )

        SELECT 
                '||V_ESQUEMA||'.S_ACT_COE_CONDICION_ESPECIFICA.NEXTVAL                  AS COE_ID,
                ACT_ID,
                COE_COD_TEXTO AS COE_TEXTO,
                COE_FECHA_DESDE,
                COE_FECHA_HASTA,
                nvl(USU_ALTA.USU_ID, select usu_id from '||V_ESQUEMA_MASTER||'.USU_USUARIOS where USU_USERNAME = ''MIGRACION'') AS COE_USUARIO_ALTA,
                USU_BAJA.USU_ID AS COE_USUARIO_BAJA,
                0 AS VERSION,
                ''MIG2''           AS USUARIOCREAR,
                SYSDATE            AS FECHACREAR,
                0 AS BORRADO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT               ON  MIG.COE_ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
        INNER JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU_ALTA ON  USU_ALTA.USU_USERNAME = MIG.COE_COD_USUARIO_ALTA
        LEFT JOIN  '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU_BAJA ON  USU_BAJA.USU_USERNAME = MIG.COE_COD_USUARIO_BAJA'
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Registros insertados en REM
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = ''MIG2''';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;        

     -- Observaciones
      IF V_REJECTS != 0 THEN
        V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' CLIENTES_COMERCIALES, comprobar CLC_COD_CLIENTE_WEBCOM duplicados en la MIG2';
      END IF;
      
      EXECUTE IMMEDIATE '
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
      '
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












