--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161010
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_POS_POSICIONAMIENTO -> POS_POSICIONAMIENTO
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
V_TABLA VARCHAR2(40 CHAR) := 'POS_POSICIONAMIENTO';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_POS_POSICIONAMIENTO';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
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
      WHERE OFR.OFR_NUM_OFERTA = MIG.POS_COD_OFERTA
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
        MIG.POS_COD_OFERTA 
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
        WHERE NOT EXISTS (
          SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            ON OFR.OFR_ID = ECO.OFR_ID
          WHERE OFR.OFR_NUM_OFERTA = MIG.POS_COD_OFERTA
          )
        )
        SELECT DISTINCT
        MIG.POS_COD_OFERTA                              						RES_COD_OFERTA,
        '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
        SYSDATE                                                                 FECHA_COMPROBACION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
        INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA
        ON OFR_NUM_OFERTA.POS_COD_OFERTA = MIG.POS_COD_OFERTA
        '
        ;
        
        COMMIT;
    
      END IF;
      
      --Inicio del proceso de volcado sobre POS_POSICIONAMIENTO
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' POS (
              POS_ID
              ,ECO_ID
              ,POS_FECHA_AVISO
              ,POS_NOTARIA
              ,POS_FECHA_POSICIONAMIENTO
              ,POS_MOTIVO_APLAZAMIENTO
              ,VERSION
              ,USUARIOCREAR
              ,FECHACREAR
              ,BORRADO
          )
          SELECT 
              '||V_ESQUEMA||'.S_POS_POSICIONAMIENTO.NEXTVAL             AS POS_ID,
              AUX.*
          FROM (
            SELECT DISTINCT
              ECO.ECO_ID                                                                    AS ECO_ID,
              MIG2.POS_FECHA_AVISO                                                  AS POS_FECHA_AVISO,
              MIG2.POS_COD_NOTARIO                                               AS POS_NOTARIA,                             -- este campo esta pendiente de definicion
              MIG2.POS_FECHA_POSICIONAMIENTO                              AS POS_FECHA_POSICIONAMIENTO,
              MIG2.POS_MOTIVO_APLAZAMIENTO                                 AS POS_MOTIVO_APLAZAMIENTO,
              0                                                                                  AS VERSION,
              ''MIG2''                                                                           AS USUARIOCREAR,
              SYSDATE                                                                     AS FECHACREAR,
              0                                                                                 AS BORRADO
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
            INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG2.POS_COD_OFERTA AND OFR.BORRADO = 0
            INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
          ) AUX
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
      -- Guardadis en V_REG_INSERTADOS
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
      
      /*  
      -- Diccionarios rechazados
      V_SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
      WHERE DICCIONARIO IN (''DD_TPR_TIPO_PROVEEDOR'',''DD_TDI_TIPO_DOCUMENTO_ID'',''DD_ZNG_ZONA_GEOGRAFICA'',''DD_PRV_PROVINCIA'',''DD_LOC_LOCALIDAD'')
      AND FICHERO_ORIGEN = ''PROVEEDORES.dat''
      AND CAMPO_ORIGEN IN (''TIPO_PROVEEDOR'',''TIPO_DOCUMENTO'',''ZONA_GEOGRAFICA'',''PVE_PROVINCIA'',''PVE_LOCALIDAD'')
      '
      ;
      
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
      */
      
      -- Observaciones
      IF V_REJECTS != 0 THEN      
          V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' COMPRADORES_EXPEDIENTES.';      
          
          IF TABLE_COUNT != 0 THEN
              V_OBSERVACIONES := V_OBSERVACIONES|| ' Hay un total de '||TABLE_COUNT||' EXPEDIENTES_ECONOMICOS (OFERTAS) inexistentes. ';
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
