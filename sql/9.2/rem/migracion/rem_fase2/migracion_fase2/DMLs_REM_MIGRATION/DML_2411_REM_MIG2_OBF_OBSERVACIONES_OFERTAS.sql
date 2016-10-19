--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_OBF_OBSERVACIONES_OFERTAS -> TXO_TEXTOS_OFERTA
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
V_TABLA VARCHAR2(40 CHAR) := 'TXO_TEXTOS_OFERTA';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_OBF_OBSERVACIONES_OFERTAS';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN

  --COMPROBACIONES PREVIAS - OFERTAS
  DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO OFERTAS...');
  
  V_SENTENCIA := '
  SELECT COUNT(1) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
  WHERE NOT EXISTS (
    SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR WHERE OFR.OFR_NUM_OFERTA = MIG.OBF_COD_OFERTA
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
		MIG.OBF_COD_OFERTA 
		FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		WHERE NOT EXISTS (
		  SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE MIG.OBF_COD_OFERTA = OFR_NUM_OFERTA
		)
    )
    SELECT DISTINCT
    MIG.OBF_COD_OFERTA                              						OFR_NUM_OFERTA,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN OFR_NUM_OFERTA
    ON OFR_NUM_OFERTA.OBF_COD_OFERTA = MIG.OBF_COD_OFERTA
    '
    ;
    
    COMMIT;

  END IF;

          
      /*--COMPROBACIONES PREVIAS - EXPEDIENTE_ECONOMICO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO EXPEDIENTE_ECONOMICO...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
      WHERE NOT EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
        ON OFR.OFR_ID = ECO.OFR_ID
      WHERE OFR.OFR_NUM_OFERTA = MIG.OBF_COD_OFERTA
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
        MIG.OBF_COD_OFERTA 
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
        WHERE NOT EXISTS (
          SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            ON OFR.OFR_ID = ECO.OFR_ID
          WHERE OFR.OFR_NUM_OFERTA = MIG.OBF_COD_OFERTA
          )
        )
        SELECT DISTINCT
        MIG.OBF_COD_OFERTA                              						RES_COD_OFERTA,
        '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
        SYSDATE                                                                 FECHA_COMPROBACION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
        INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA
        ON OFR_NUM_OFERTA.OBF_COD_OFERTA = MIG.OBF_COD_OFERTA
        '
        ;
        
        COMMIT;
    
      END IF;*/
      
      --Inicio del proceso de volcado sobre TXO_TEXTOS_OFERTA
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' OEX (
          TXO_ID
          ,OFR_ID
          ,DD_TTX_ID
          ,TXO_TEXTO
          ,VERSION
          ,USUARIOCREAR
          ,FECHACREAR
          ,BORRADO
          )
          SELECT
            '||V_ESQUEMA||'.S_TXO_TEXTOS_OFERTA.NEXTVAL  				AS TXO_ID,
            OFR.OFR_ID                                                  AS OFR_ID,
            TTX.DD_TTX_ID												AS DD_TTX_ID,
            MIG2.OBF_OBSERVACION                                        AS TXO_TEXTO,
            0                                                           AS VERSION,
            ''MIG2''                                                    AS USUARIOCREAR,
            MIG2.OBF_FECHA                                              AS FECHACREAR,
            0                                                           AS BORRADO
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG2.OBF_COD_OFERTA AND OFR.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_TTX_TIPOS_TEXTO_OFERTA TTX ON DD_TTX_CODIGO = MIG2.OBF_COD_TIPO_OBS
      '
      ;
      
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
          V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';      
                   
          IF TABLE_COUNT != 0 THEN
              V_OBSERVACIONES := V_OBSERVACIONES|| ' Hay un total de '||TABLE_COUNT||' OFERTAS inexistentes. ';
          END IF;
        
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
