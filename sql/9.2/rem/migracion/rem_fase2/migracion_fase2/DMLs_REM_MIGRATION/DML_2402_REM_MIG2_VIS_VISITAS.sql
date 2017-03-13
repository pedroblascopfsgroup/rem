--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161003
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_VIS_VISITAS -> VIS_VISITAS
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
V_TABLA VARCHAR2(40 CHAR) := 'VIS_VISITAS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_VIS_VISITAS';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_DUPLICADOS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

          --COMPROBACIONES PREVIAS - CLIENTE_COMERCIAL (CLC_WEBCOM_ID)
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO CLIENTE_COMERCIAL...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
        WHERE CLC.CLC_WEBCOM_ID = MIG2.VIS_COD_CLIENTE_WEBCOM
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS CLIENTE_COMERCIAL EXISTEN EN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' CLIENTE_COMERCIAL INEXISTENTES EN CLC_CLIENTE_COMERCIAL. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS (
            TABLA_MIG,
            CODIGO_RECHAZADO,
            CAMPO_CLC_MOTIVO_RECHAZO,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.VIS_COD_CLIENTE_WEBCOM 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
              WHERE MIG2.VIS_COD_CLIENTE_WEBCOM = CLC.CLC_WEBCOM_ID
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.VIS_COD_CLIENTE_WEBCOM                                             CODIGO_RECHAZADO,
          ''CLC_WEBCOM_ID''                                                           CAMPO_CLC_MOTIVO_RECHAZO,
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.VIS_COD_CLIENTE_WEBCOM = MIG2.VIS_COD_CLIENTE_WEBCOM
          '
          ;
          
          COMMIT;      
      
      END IF;
      
      
      --COMPROBACIONES PREVIAS - ACTIVOS
          DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO ACTIVOS...');
          
          V_SENTENCIA := '
          SELECT COUNT(1) 
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
          WHERE NOT EXISTS (
                SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.VIS_ACT_NUMERO_ACTIVO
          )
          '
          ;
          
          EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
          
          IF TABLE_COUNT_2 = 0 THEN
          
                DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS ACTIVOS EXISTEN EN ACT_ACTIVO');
                
          ELSE
          
                DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' ACTIVOS INEXISTENTES EN ACT_ACTIVO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_ACT_NOT_EXISTS.');
                
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
                        MIG.VIS_ACT_NUMERO_ACTIVO 
                        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                        WHERE NOT EXISTS (
                          SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.VIS_ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                        )
                )
                SELECT DISTINCT
                MIG.VIS_ACT_NUMERO_ACTIVO                                                               ACT_NUM_ACTIVO,
                '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
                SYSDATE                                                                 FECHA_COMPROBACION
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
                INNER JOIN ACT_NUM_ACTIVO
                ON ACT_NUM_ACTIVO.VIS_ACT_NUMERO_ACTIVO = MIG.VIS_ACT_NUMERO_ACTIVO
                '
                ;
                
                COMMIT;

          END IF;



      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                VIS_ID,
                VIS_WEBCOM_ID,
                VIS_NUM_VISITA,
                ACT_ID,
                CLC_ID,
                DD_EVI_ID,
                DD_SVI_ID,
                VIS_FECHA_VISITA,
                VIS_FECHA_SOLICTUD,
                PVE_ID_PRESCRIPTOR,
                PVE_ID_API_CUSTODIO,
                PVE_ID_API_RESPONSABLE,
                PVE_ID_FDV,
                VIS_OBSERVACIONES,
                VIS_FECHA_CONCERTACION,
                VERSION,
                USUARIOCREAR,
                FECHACREAR,
                BORRADO,
                VIS_PROCEDENCIA
                )
                WITH INSERTAR AS (
                SELECT DISTINCT 
                CLC.CLC_ID,
                ACT.ACT_ID,
                MIG.VIS_COD_VISITA_WEBCOM,
                MIG.VIS_COD_ESTADO_VISITA,
                MIG.VIS_COD_SUBESTADO_VISISTA,
                MIG.VIS_COD_PROCEDENCIA,
                MIG.VIS_COD_SUBPROCEDENCIA,
                MIG.VIS_FECHA_SOLCITUD,
                MIG.VIS_FECHA_CONCERTACION,
                MIG.VIS_FECHA_REAL_VISITA,
                MIG.VIS_COD_PRESCRIPTOR_UVEM,
                MIG.VIS_IND_VISITA_PRESCRIPTOR,
                MIG.VIS_COD_API_RESPONSABLE_UVEM,
                MIG.VIS_IND_VISITA_API_RESPONSABLE,
                MIG.VIS_COD_API_CUSTODIO_UVEM,
                MIG.VIS_IND_VISITA_API_CUSTODIO,
                MIG.VIS_COD_FVD_UVEM,
                MIG.VIS_IND_VISITA_FVD,
                MIG.VIS_OBSERVACIONES
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                INNER JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
                  ON CLC.CLC_WEBCOM_ID = MIG.VIS_COD_CLIENTE_WEBCOM
                INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                  ON ACT.ACT_NUM_ACTIVO = MIG.VIS_ACT_NUMERO_ACTIVO
          ),
      DUPLICADOS AS (
          SELECT DISTINCT VIS_COD_VISITA_WEBCOM
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
          GROUP BY VIS_COD_VISITA_WEBCOM 
          HAVING COUNT(1) > 1
          )
                SELECT
                '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                         					   VIS_ID, 
                VIS.VIS_COD_VISITA_WEBCOM                                                                              VIS_WEBCOM_ID,
                '||V_ESQUEMA||'.S_VIS_NUM_VISITA.NEXTVAL                                                			   VIS_NUM_VISITA,
                VIS.ACT_ID                                                                                             ACT_ID,
                VIS.CLC_ID                                                                                             CLC_ID,
                (SELECT DD_EVI_ID 
                FROM '||V_ESQUEMA||'.DD_EVI_ESTADOS_VISITA
                WHERE DD_EVI_CODIGO =  VIS.VIS_COD_ESTADO_VISITA)                               						DD_EVI_ID,
                (SELECT DD_SVI_ID 
                FROM '||V_ESQUEMA||'.DD_SVI_SUBESTADOS_VISITA
                WHERE DD_SVI_CODIGO =  VIS.VIS_COD_SUBESTADO_VISISTA)                   								DD_SVI_ID,
                VIS.VIS_FECHA_REAL_VISITA                                                                               VIS_FECHA_VISITA,
                VIS.VIS_FECHA_SOLCITUD                                                                                  VIS_FECHA_SOLCITUD,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_PRESCRIPTOR_UVEM
          AND ROWNUM = 1
    ) PVE_ID_PRESCRIPTOR,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_API_CUSTODIO_UVEM
          AND ROWNUM = 1
    )   PVE_ID_API_CUSTODIO,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_API_RESPONSABLE_UVEM
          AND ROWNUM = 1
    )                   PVE_ID_API_RESPONSABLE,
                (SELECT PVE_ID 
          FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
          INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
          WHERE TPR.DD_TPR_CODIGO IN (''04'',''18'',''23'',''28'',''29'',''30'',''31'')
          AND PVE_COD_UVEM = VIS.VIS_COD_FVD_UVEM
          AND ROWNUM = 1
    )                                           PVE_ID_FDV,
                VIS.VIS_OBSERVACIONES                                                                                   VIS_OBSERVACIONES,
                VIS.VIS_FECHA_CONCERTACION                                                                              VIS_FECHA_CONCERTACION,
                0                                                                                                       VERSION,
                ''MIG2''                                                                								USUARIOCREAR,
                SYSDATE                                                                         						FECHACREAR,
                0                                                                               						BORRADO,
                REPLACE(VIS.VIS_COD_PROCEDENCIA, ''.'')																	VIS_PROCEDENCIA
                FROM INSERTAR VIS
                WHERE NOT EXISTS (
            SELECT 1
            FROM DUPLICADOS DUP
            WHERE DUP.VIS_COD_VISITA_WEBCOM = VIS.VIS_COD_VISITA_WEBCOM)
                '
                ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      --VALIDACION DE DUPLICADOS
      V_SENTENCIA := '
      SELECT SUM(COUNT(1))
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
      GROUP BY VIS_COD_VISITA_WEBCOM 
      HAVING COUNT(1) > 1
      '
      ;  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_DUPLICADOS;
      
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
          
                V_OBSERVACIONES := 'Se han rechazado un total de '||V_REJECTS||' VISITAS.';
          
                IF TABLE_COUNT != 0 THEN                
                  V_OBSERVACIONES := V_OBSERVACIONES||' Hay '||TABLE_COUNT||' CLIENTE_COMERCIAL inexistentes. ';                
                END IF;
                
                IF TABLE_COUNT_2 != 0 THEN              
                  V_OBSERVACIONES := V_OBSERVACIONES||' Hay '||TABLE_COUNT_2||' ACTIVOS inexistentes. ';                
                END IF; 
                
                IF V_DUPLICADOS != 0 THEN
                        V_OBSERVACIONES := V_OBSERVACIONES||' Hay '||V_DUPLICADOS||' VIS_COD_VISITA_WEBCOM duplicados. ';       
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
