--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161017
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_ACQ_ACTIVO_ALQUILER -> ACT_HAL_HIST_ALQUILERES
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_HAL_HIST_ALQUILERES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACQ_ACTIVO_ALQUILER';
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
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.ACQ_NUMERO_ACTIVO
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
                MIG.ACQ_NUMERO_ACTIVO 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.ACQ_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                )
    )
    SELECT DISTINCT
    MIG.ACQ_NUMERO_ACTIVO                                                               ACT_NUM_ACTIVO,
    '''||V_TABLA_MIG||'''                                               TABLA_MIG,
    SYSDATE                                                             FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN ACT_NUM_ACTIVO
    ON ACT_NUM_ACTIVO.ACQ_NUMERO_ACTIVO = MIG.ACQ_NUMERO_ACTIVO
    '
    ;
    
    COMMIT;

  END IF;


          --Inicio del proceso de volcado sobre ACT_HAL_HIST_ALQUILERES
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                        HAL_ID,
            ACT_ID,
                        HAL_NUMERO_CONTRATO_ALQUILER,

                        HAL_FECHA_INICIO_CONTRATO,
                        HAL_FECHA_FIN_CONTRATO,
                        HAL_FECHA_RESOLUCION_CONTRATO,
                        HAL_IMPORTE_RENTA_CONTRATO,
                        HAL_PLAZO_OPCION_COMPRA,
                        HAL_PRIMA_OPCION_COMPRA,
                        HAL_PRECIO_OPCION_COMPRA,
                        HAL_CONDICIONES_OPCION_COMPRA,
                        HAL_IND_CONFLICTO_INTERESES,
                        HAL_IND_RIESGO_REPUTACIONAL,
                        HAL_GASTOS_IBI,
                        DD_TPC_ID_IBI,
                        HAL_GASTOS_COMUNIDAD,
                        DD_TPC_ID_COM,
                        DD_TPC_ID_SUMINISTRO,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO
        )
        SELECT
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                             HAL_ID,
            ACT.ACT_ID                                                                                                  ACT_ID,
                        MIG.ACQ_NUMERO_CONTRATO_ALQUILER                                                        HAL_NUMERO_CONTRATO_ALQUILER,
                        
                        MIG.ACQ_FECHA_INICIO_CONTRATO                                                           HAL_FECHA_INICIO_CONTRATO,
                        MIG.ACQ_FECHA_FIN_CONTRATO                                                                      HAL_FECHA_FIN_CONTRATO,
                        MIG.ACQ_FECHA_RESOLUCION_CONTRATO                                                       HAL_FECHA_RESOLUCION_CONTRATO,
                        MIG.ACQ_IMPORTE_RENTA_CONTRATO                                                          HAL_IMPORTE_RENTA_CONTRATO,
                        MIG.ACQ_PLAZO_OPCION_COMPRA                                                                     HAL_PLAZO_OPCION_COMPRA,
                        MIG.ACQ_PRIMA_OPCION_COMPRA                                                                     HAL_PRIMA_OPCION_COMPRA,
                        MIG.ACQ_PRECIO_OPCION_COMPRA                                                            HAL_PRECIO_OPCION_COMPRA,
                        MIG.ACQ_CONDICIONES_OPCION_COMPRA                                                       HAL_CONDICIONES_OPCION_COMPRA,
                        MIG.ACQ_IND_CONFLICTO_INTERESES                                                         HAL_IND_CONFLICTO_INTERESES,
                        MIG.ACQ_IND_RIESGO_REPUTACIONAL                                                         HAL_IND_RIESGO_REPUTACIONAL,
                        MIG.ACQ_GASTOS_IBI                                                                                      HAL_GASTOS_IBI,
                        TPC_IBI.DD_TPC_ID                                                                                       DD_TPC_ID_IBI,
                        MIG.ACQ_GASTOS_COMUNIDAD                                                                        HAL_GASTOS_COMUNIDAD,
                        TPC_COM.DD_TPC_ID                                                                                       DD_TPC_ID_COM,
            TPC_SUMINISTRO.DD_TPC_ID                                                                    DD_TPC_ID_SUMINISTRO,
            0                                                                                                                   VERSION,
            ''MIG2''                                                            USUARIOCREAR,
            SYSDATE                                                             FECHACREAR,
            0                                                                   BORRADO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
                        ON ACT.ACT_NUM_ACTIVO = MIG.ACQ_NUMERO_ACTIVO
                LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_IBI
                        ON TPC_IBI.DD_TPC_CODIGO = MIG.ACQ_COD_TIPO_PORCTA_IBI
                LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_COM
                        ON TPC_COM.DD_TPC_CODIGO = MIG.ACQ_COD_TIPO_PORCTA_COMUNIDAD
                LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_SUMINISTRO
                        ON TPC_SUMINISTRO.DD_TPC_CODIGO = MIG.ACQ_COD_TIPO_PORCTA_SUMINIS
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA     ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;        
      
      -- Observaciones
          IF V_REJECTS != 0 THEN
        V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';
                IF TABLE_COUNT != 0 THEN
                
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' ACTIVOS inexistentes. ';
                
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
