--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_ACT_HEP_HIST_EST_PUBLI -> ACT_HEP_HIST_EST_PUBLICACION
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

TABLE_COUNT_1 NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_HVA_HIST_VALORACIONES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_HVA_HIST_VALORACIONES';
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
		SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.HVA_ACT_NUMERO_ACTIVO
	  )
	  '
	  ;
	  
	  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_1;
	  
	  IF TABLE_COUNT_1 = 0 THEN	  
        DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN ACT_ACTIVO');		
	  ELSE
        
        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_1||' ACTIVOS INEXISTENTES EN ACT_ACTIVO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS.');
        
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
          MIG.HVA_ACT_NUMERO_ACTIVO 
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
          WHERE NOT EXISTS (
            SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.HVA_ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
          )
        )
        SELECT DISTINCT
        MIG.HVA_ACT_NUMERO_ACTIVO                              						ACT_NUM_ACTIVO,
        '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
        SYSDATE                                                                 FECHA_COMPROBACION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
        INNER JOIN ACT_NUM_ACTIVO
        ON ACT_NUM_ACTIVO.HVA_ACT_NUMERO_ACTIVO = MIG.HVA_ACT_NUMERO_ACTIVO
        '
        ;
        
        COMMIT;

	  END IF;

    --COMPROBACIONES PREVIAS - TIPO PRECIO
    DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO TIPO PRECIO...');
    
    V_SENTENCIA := '
        SELECT COUNT(1) 
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
        WHERE NOT EXISTS (
          SELECT 1 
          FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO DD 
          WHERE DD.DD_TPC_CODIGO = MIG2.HVA_COD_TIPO_PRECIO
    )
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
    
    IF TABLE_COUNT_2 = 0 THEN    
        DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TIPOS DE PRECIO EXISTEN EN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO');    
    ELSE
    
        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' TIPOS DE PRECIO INEXISTENTES EN DD_TPC_TIPO_PRECIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
        
        --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
        
        EXECUTE IMMEDIATE '
        DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
        WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
        '
        ;
        
        COMMIT;
        
        EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
              CLAVE           ,  
              TABLA_MIG  , 
              CAMPO_ORIGEN    ,
              DICCIONARIO     ,
              VALOR           ,
              FECHA_COMPROBACION

        )
              SELECT
                      HVA_ACT_NUMERO_ACTIVO,
                      '''||V_TABLA_MIG||''',
                      ''HVA_COD_TIPO_PRECIO'',
                      ''DD_TPC_TIPO_PRECIO'',
                      HVA_COD_TIPO_PRECIO,
                      SYSDATE
              FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
                    WHERE NOT EXISTS (
                      SELECT 1 
                      FROM '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO DD 
                      WHERE DD.DD_TPC_CODIGO = MIG2.HVA_COD_TIPO_PRECIO
              )'
        ;
        
        V_COD := SQL%ROWCOUNT;
        
        COMMIT;      
    
    END IF;

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' HVA (
              HVA_ID
              ,ACT_ID
              ,DD_TPC_ID
              ,HVA_IMPORTE
              ,HVA_FECHA_INICIO
              ,HVA_FECHA_FIN
              ,HVA_FECHA_APROBACION
              ,HVA_FECHA_CARGA
              ,USU_ID
              ,HVA_OBSERVACIONES
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT
            '||V_ESQUEMA||'.S_ACT_HVA_HIST_VALORACIONES.NEXTVAL                             AS HVA_ID,
            AUX.*
          FROM (
              SELECT DISTINCT
                  ACT.ACT_ID                                                                                AS ACT_ID,
                  TPC.DD_TPC_ID                                                                           AS DD_TPC_ID,
                  MIG2.HVA_IMPORTE                                                                    AS HVA_IMPORTE,
                  MIG2.HVA_FECHA_INICIO                                                             AS HVA_FECHA_INICIO,
                  MIG2.HVA_FECHA_FIN                                                                  AS HVA_FECHA_FIN,
                  MIG2.HVA_FECHA_APROBACION                                                   AS HVA_FECHA_APROBACION,
                  MIG2.HVA_FECHA_CARGA                                                            AS HVA_FECHA_CARGA,
                  USU.USU_ID                                                                                  AS USU_ID,
                  MIG2.HVA_OBSERVACIONES                                                          AS HVA_OBSERVACIONES,
                  0                                                                                               AS VERSION,
                  ''MIG2''                                                                                        AS USUARIOCREAR,
                  SYSDATE                                                                                   AS FECHACREAR,
                  0                                                                                               AS BORRADO
              FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
              INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG2.HVA_ACT_NUMERO_ACTIVO AND ACT.BORRADO = 0
              INNER JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = MIG2.HVA_COD_TIPO_PRECIO AND TPC.BORRADO = 0
              LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = MIG2.HVA_COD_USUARIO AND USU.BORRADO = 0
          ) AUX       
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA	;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Registros insertados en REM
      -- V_REG_INSERTADOS
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
      
      -- Observaciones
      IF V_REJECTS != 0 THEN
          V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' HIST_EST_PUBLICACIONES.';
          
          IF TABLE_COUNT_1 != 0 THEN
              V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_1||' ACTIVOS inexistentes.';
          END IF;
          
          IF TABLE_COUNT_2 != 0 THEN
              V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT_2||' TIPOS DE PRECIO inexistentes.';
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
