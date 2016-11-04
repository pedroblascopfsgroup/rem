--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161004
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_OFR_TIA_TITULARES_ADI' -> 'OFR_TIA_TITULARES_ADICIONALES'
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
V_TABLA VARCHAR2(40 CHAR) := 'OFR_TIA_TITULARES_ADICIONALES';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_OFR_TIA_TITULARES_ADI';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_DUP NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';


BEGIN

  --COMPROBACIONES PREVIAS - OFERTAS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO OFERTAS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR WHERE OFR.OFR_NUM_OFERTA = MIG.OFR_TIA_COD_OFERTA
  )
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
  
  IF TABLE_COUNT = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS OFERTAS EXISTEN EN OFR_OFERTAS');
    
  ELSE
  
    DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' OFERTAS INEXISTENTES EN OFR_OFERTAS. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS.');
    
    --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
    
    EXECUTE IMMEDIATE '
    DELETE FROM '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS
    WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
    '
    ;
    
    COMMIT;
  
    EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.MIG2_OFR_NOT_EXISTS (
    OFR_NUM_OFERTA,
    TABLA_MIG,
    FECHA_COMPROBACION
    )
    WITH OFR_NUM_OFERTA AS (
                SELECT
                MIG.OFR_TIA_COD_OFERTA 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE MIG.OFR_TIA_COD_OFERTA = OFR_NUM_OFERTA
                )
    )
    SELECT DISTINCT
    MIG.OFR_TIA_COD_OFERTA                                                                      OFR_NUM_OFERTA,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN OFR_NUM_OFERTA
    ON OFR_NUM_OFERTA.OFR_TIA_COD_OFERTA = MIG.OFR_TIA_COD_OFERTA
    '
    ;
    
    COMMIT;

  END IF;
  
  
  --Inicio del proceso de volcado sobre OFR_TIA_TITULARES_ADICIONALES
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE ('
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        TIA_ID,
        OFR_ID,
        TIA_NOMBRE,
        DD_TDI_ID,
        TIA_DOCUMENTO,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO
        )
        WITH INSERTAR AS (
    SELECT DISTINCT 
                OFR.OFR_ID,
                MIG.OFR_TIA_NOMBRE,
                MIG.OFR_TIA_COD_TIPO_DOC_TITUL_ADI,
                MIG.OFR_TIA_DOCUMENTO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
      ON OFR.OFR_NUM_OFERTA = MIG.OFR_TIA_COD_OFERTA
  )
        SELECT
        '||V_ESQUEMA||'.S_OFR_TIA_TIT_ADICIONALES.NEXTVAL                                       TIA_ID,
        TIA.OFR_ID                                                                                                              OFR_ID,
        TIA.OFR_TIA_NOMBRE                                                                                                      TIA_NOMBRE,
        (SELECT DD_TDI_ID 
        FROM '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID
        WHERE DD_TDI_CODIGO = TIA.OFR_TIA_COD_TIPO_DOC_TITUL_ADI)                       DD_TDI_ID,
        TIA.OFR_TIA_DOCUMENTO                                                                                           TIA_DOCUMENTO,
        ''0''                                                                           VERSION,
        ''MIG2''                                                                        USUARIOCREAR,
        SYSDATE                                                                                 FECHACREAR,
        0                                                                               BORRADO
        FROM INSERTAR TIA
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
  
  EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
  
  -- Total registros rechazados
  V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;
  
  -- Observaciones
  IF V_REJECTS != 0 THEN
    
    V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros rechazados.';
    
    IF TABLE_COUNT != 0 THEN    
      V_OBSERVACIONES := V_OBSERVACIONES||' Hay '||TABLE_COUNT||' OFERTAS inexistentes. ';    
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
