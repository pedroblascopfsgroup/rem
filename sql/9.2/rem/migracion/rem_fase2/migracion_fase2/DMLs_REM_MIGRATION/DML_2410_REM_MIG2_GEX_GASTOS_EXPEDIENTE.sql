--/*
--#########################################
--## AUTOR=CLV
--## FECHA_CREACION=20161007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_GEX_GASTOS_EXPEDIENTE -> GEX_GASTOS_EXPEDIENTE
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
V_TABLA VARCHAR2(40 CHAR) := 'GEX_GASTOS_EXPEDIENTE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_GEX_GASTOS_EXPEDIENTE';
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
      WHERE OFR.OFR_NUM_OFERTA = MIG.GEX_COD_OFERTA
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
        MIG.GEX_COD_OFERTA 
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
        WHERE NOT EXISTS (
          SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            ON OFR.OFR_ID = ECO.OFR_ID
          WHERE OFR.OFR_NUM_OFERTA = MIG.GEX_COD_OFERTA
          )
        )
        SELECT DISTINCT
        MIG.GEX_COD_OFERTA                                                                              RES_COD_OFERTA,
        '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
        SYSDATE                                                                 FECHA_COMPROBACION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
        INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA
        ON OFR_NUM_OFERTA.GEX_COD_OFERTA = MIG.GEX_COD_OFERTA
        '
        ;
        
        COMMIT;
    
      END IF;
      
      --Inicio del proceso de volcado sobre GEX_GASTOS_EXPEDIENTE
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' GEX (
             GEX_ID
            ,ECO_ID
            ,DD_ACC_ID
            ,GEX_CODIGO
            ,GEX_NOMBRE
            ,DD_TCC_ID
            ,GEX_IMPORTE_CALCULO
            ,GEX_IMPORTE_FINAL
            ,GEX_PAGADOR
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,USUARIOMODIFICAR
            ,FECHAMODIFICAR
            ,USUARIOBORRAR
            ,FECHABORRAR
            ,BORRADO
            ,GEX_WEBCOM_ID
            ,GEX_PROVEEDOR
            ,GEX_OBSERVACIONES
            ,GEX_APROBADO
            ,DD_DEG_ID
          )
          SELECT  
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                     AS GEX_ID
            ,ECO.ECO_ID                                                                                                 AS ECO_ID
            ,(SELECT DD_ACC.DD_ACC_ID FROM '||V_ESQUEMA||'.DD_ACC_ACCION_GASTOS DD_ACC WHERE DD_ACC.DD_ACC_CODIGO = MIG2.GEX_COD_CONCEPTO_GASTO AND DD_ACC.BORRADO = 0) DD_ACC_ID
            ,MIG2.GEX_CODIGO
            ,MIG2.GEX_NOMBRE
            ,(SELECT DD_TCC.DD_TCC_ID FROM '||V_ESQUEMA||'.DD_TCC_TIPO_CALCULO DD_TCC WHERE DD_TCC.DD_TCC_CODIGO = MIG2.GEX_COD_TIPO_CALCULO AND DD_TCC.BORRADO = 0) DD_TCC_ID
            ,MIG2.GEX_IMPORTE_CALCULO
            ,MIG2.GEX_IMPORTE_FINAL
            ,MIG2.GEX_IND_PAGADOR
            ,0 VERSION
            ,''MIG2'' USUARIOCREAR
            ,SYSDATE FECHACREAR
            ,NULL USUARIOMODIFICAR
            ,NULL FECHAMODIFICAR
            ,NULL USUARIOBORRAR
            ,NULL FECHABORRAR
            ,0 BORRADO
            ,MIG2.GEX_WEBCOM_ID
            ,(SELECT PVE.PVE_ID FROM ACT_PVE_PROVEEDOR PVE WHERE PVE.PVE_COD_UVEM = MIG2.GEX_COD_PROVEEDOR and pve.DD_TPR_ID is not null AND ROWNUM = 1) GEX_PROVEEDOR
            ,NULL GEX_OBSERVACIONES
            ,MIG2.GEX_IND_APROBADO
            ,(SELECT DD_DEG.DD_DEG_ID FROM '||V_ESQUEMA||'.DD_DEG_DESTINATARIOS_GASTO DD_DEG WHERE DD_DEG.DD_DEG_CODIGO = MIG2.GEX_COD_DESTINATARIO AND DD_DEG.BORRADO = 0) DD_DEG_ID
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                        ON OFR.OFR_NUM_OFERTA = MIG2.GEX_COD_OFERTA
                  INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                        ON ECO.OFR_ID = OFR.OFR_ID
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
              V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' EXPEDIENTES_ECONOMICOS (OFERTAS) inexistentes. ';
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
