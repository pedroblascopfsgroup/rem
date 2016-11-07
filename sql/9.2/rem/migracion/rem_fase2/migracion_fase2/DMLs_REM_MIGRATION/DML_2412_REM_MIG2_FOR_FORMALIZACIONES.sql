--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_FOR_FORMALIZACIONES' -> 'FOR_FORMALIZACION'
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
V_TABLA VARCHAR2(40 CHAR) := 'FOR_FORMALIZACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_FOR_FORMALIZACIONES';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_DUP NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN 
  
  --COMPROBACIONES PREVIAS - EXPEDIENTE_ECONOMICO
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO EXPEDIENTE_ECONOMICO...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
    INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                ON OFR.OFR_ID = ECO.OFR_ID
        WHERE OFR.OFR_NUM_OFERTA = MIG.FOR_COD_OFERTA
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS OFERTAS EXISTEN EN EXPEDIENTE_ECONOMICO');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' EXPEDIENTE_ECONOMICO INEXISTENTES EN ECO_EXPEDIENTE_COMERCIAL. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_ECO_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.MIG2_ECO_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.MIG2_ECO_NOT_EXISTS (
    OFR_NUM_OFERTA,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH OFR_NUM_OFERTA AS (
                SELECT
                MIG.FOR_COD_OFERTA 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                        SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                                ON OFR.OFR_ID = ECO.OFR_ID
                        WHERE OFR.OFR_NUM_OFERTA = MIG.FOR_COD_OFERTA
                  )
    )
    SELECT DISTINCT
    MIG.FOR_COD_OFERTA                                                                          OFR_NUM_OFERTA,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA
    ON OFR_NUM_OFERTA.FOR_COD_OFERTA = MIG.FOR_COD_OFERTA
    '
    ;
    
    COMMIT;

  END IF;

  
  
  --Inicio del proceso de volcado sobre RES_RESERVAS
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE ('
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        FOR_ID,
        ECO_ID,
        FOR_PETICIONARIO,
        FOR_FECHA_PETICION,
        FOR_FECHA_RESOLUCION,
        FOR_FECHA_ESCRITURA,
        FOR_FECHA_CONTABILIZACION,
        FOR_FECHA_PAGO,
        FOR_IMPORTE,
        FOR_FORMA_PAGO,
        FOR_MOTIVO_RESOLUCION,
        VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
        )
        SELECT 
        '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL             RES_ID,
        ECO.ECO_ID                                                                                      ECO_ID,
        MIG.FOR_PETICIONARIO                                                            FOR_PETICIONARIO,
        MIG.FOR_FECHA_PETICION                                                          FOR_FECHA_PETICION,
        MIG.FOR_FECHA_RESOLUCION                                                        FOR_FECHA_RESOLUCION,
        MIG.FOR_FECHA_ESCRITURA                                                         FOR_FECHA_ESCRITURA,
        MIG.FOR_FECHA_CONTABILIZACION                                           FOR_FECHA_CONTABILIZACION,
        MIG.FOR_FECHA_PAGO                                                                      FOR_FECHA_PAGO,
        MIG.FOR_IMPORTE                                                                         FOR_IMPORTE,
        MIG.FOR_FORMA_PAGO                                                                      FOR_FORMA_PAGO,
        MIG.FOR_MOTIVO_RESOLUCION                                                       FOR_MOTIVO_RESOLUCION,
        ''0''                                               VERSION,
        ''MIG2''                                            USUARIOCREAR,
        SYSDATE                                             FECHACREAR,
        0                                                   BORRADO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
                ON OFR.OFR_NUM_OFERTA = MIG.FOR_COD_OFERTA
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                ON ECO.OFR_ID = OFR.OFR_ID                                                              
        ')
        ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
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
  
    V_OBSERVACIONES := 'Se han rechazado '||TABLE_COUNT||' registros.';
  
    IF TABLE_COUNT != 0 THEN    
      V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' EXPEDIENTE_ECONOMICO inexistentes. ';    
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
