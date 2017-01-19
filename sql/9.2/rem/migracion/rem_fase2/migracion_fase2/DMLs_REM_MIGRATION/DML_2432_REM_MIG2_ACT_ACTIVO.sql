--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161003
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_ACT_ACTIVO -> ACT_ACTIVO
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
V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ACTIVO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_ACT_ACTIVO';
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
    SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
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
                MIG.ACT_NUMERO_ACTIVO 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT WHERE MIG.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
                )
    )
    SELECT DISTINCT
    MIG.ACT_NUMERO_ACTIVO                                                                       ACT_NUM_ACTIVO,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN ACT_NUM_ACTIVO
    ON ACT_NUM_ACTIVO.ACT_NUMERO_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    '
    ;
    
    COMMIT;

  END IF;


      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA := '
        MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' ACT
        USING ( SELECT  
                                ACT_NUMERO_ACTIVO,
                                ACT_COD_SUBCARTERA,
                                ACT_BLOQUEO_PRECIO_FECHA_INI,
                                ACT_BLOQUEO_PRECIO_USU_ID,
                                ACT_COD_TIPO_PUBLICACION,
                                ACT_COD_ESTADO_PUBLICACION,
                                ACT_COD_TIPO_COMERCIALIZACION,
                                ACT_FECHA_IND_PRECIAR,
                                ACT_FECHA_IND_REPRECIAR,
                                ACT_FECHA_IND_DESCUENTO,
                                ACT_FECHA_VENTA,
                                ACT_IMPORTE_VENTA
                                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' 
                          ) AUX
                ON (ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO)
                WHEN MATCHED THEN UPDATE SET
				  ACT.DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = AUX.ACT_COD_SUBCARTERA)
                  ,ACT.ACT_BLOQUEO_PRECIO_FECHA_INI = AUX.ACT_BLOQUEO_PRECIO_FECHA_INI
                  ,ACT.ACT_BLOQUEO_PRECIO_USU_ID = AUX.ACT_BLOQUEO_PRECIO_USU_ID
                  ,ACT.DD_TPU_ID = (SELECT DD_TPU_ID FROM '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION WHERE DD_TPU_CODIGO = AUX.ACT_COD_TIPO_PUBLICACION)
                  ,ACT.DD_EPU_ID = (SELECT DD_EPU_ID FROM '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION WHERE DD_EPU_CODIGO = AUX.ACT_COD_ESTADO_PUBLICACION)
                  ,ACT.DD_TCO_ID = (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = AUX.ACT_COD_TIPO_COMERCIALIZACION)
                  ,ACT.ACT_FECHA_IND_PRECIAR = AUX.ACT_FECHA_IND_PRECIAR
                  ,ACT.ACT_FECHA_IND_REPRECIAR = AUX.ACT_FECHA_IND_REPRECIAR
                  ,ACT.ACT_FECHA_IND_DESCUENTO = AUX.ACT_FECHA_IND_DESCUENTO
                  ,ACT.ACT_VENTA_EXTERNA_FECHA = AUX.ACT_FECHA_VENTA
                  ,ACT.ACT_VENTA_EXTERNA_IMPORTE = AUX.ACT_IMPORTE_VENTA
          ,ACT.USUARIOMODIFICAR = ''MIG2''
          ,ACT.FECHAMODIFICAR = SYSDATE
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
