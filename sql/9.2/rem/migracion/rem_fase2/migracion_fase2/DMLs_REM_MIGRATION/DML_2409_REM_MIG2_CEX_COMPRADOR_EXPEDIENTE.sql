--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20161007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_CEX_COMPRADOR_EXPEDIENTE -> CEX_COMPRADOR_EXPEDIENTE
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
V_TABLA VARCHAR2(40 CHAR) := 'CEX_COMPRADOR_EXPEDIENTE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_CEX_COMPRADOR_EXPEDIENTE';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
      
	  --COMPROBACIONES PREVIAS - CLIENTE_COMERCIAL (CLC_NUM_CLIENTE_HAYA)
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO CLIENTE_COMERCIAL...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
        WHERE CLC.CLC_NUM_CLIENTE_HAYA = MIG2.CEX_COD_COMPRADOR
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_1;
      
      IF TABLE_COUNT_1 = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS CLIENTE_COMERCIAL EXISTEN EN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_1||' CLIENTE_COMERCIAL INEXISTENTES EN CLC_CLIENTE_COMERCIAL. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS.');
          
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
            SELECT DISTINCT MIG2.CEX_COD_COMPRADOR 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
              WHERE MIG2.CEX_COD_COMPRADOR = CLC.CLC_NUM_CLIENTE_HAYA
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.CEX_COD_COMPRADOR                                   CODIGO_RECHAZADO,
          ''CLC_NUM_CLIENTE_HAYA''	                                      CAMPO_CLC_MOTIVO_RECHAZO,
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.CEX_COD_COMPRADOR = MIG2.CEX_COD_COMPRADOR
          '
          ;
          
          COMMIT;      
      
      END IF;
      
      --COMPROBACIONES PREVIAS - EXPEDIENTE_ECONOMICO
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO EXPEDIENTE_ECONOMICO...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
      WHERE NOT EXISTS (
        SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
        ON OFR.OFR_ID = ECO.OFR_ID
      WHERE OFR.OFR_NUM_OFERTA = MIG.CEX_COD_OFERTA
      )
      '
      ;
      
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
      
      IF TABLE_COUNT_2 = 0 THEN
      
        DBMS_OUTPUT.PUT_LINE('[INFO] TODAS LAS OFERTAS EXISTEN EN EXPEDIENTE_ECONOMICO');
        
      ELSE
      
        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' EXPEDIENTE_ECONOMICO INEXISTENTES EN ECO_EXPEDIENTE_COMERCIAL. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_ECO_NOT_EXISTS.');
        
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
        MIG.CEX_COD_OFERTA 
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
        WHERE NOT EXISTS (
          SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            ON OFR.OFR_ID = ECO.OFR_ID
          WHERE OFR.OFR_NUM_OFERTA = MIG.CEX_COD_OFERTA
          )
        )
        SELECT DISTINCT
        MIG.CEX_COD_OFERTA                              						RES_COD_OFERTA,
        '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
        SYSDATE                                                                 FECHA_COMPROBACION
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
        INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA
        ON OFR_NUM_OFERTA.CEX_COD_OFERTA = MIG.CEX_COD_OFERTA
        '
        ;
        
        COMMIT;
    
      END IF;
      
      --Inicio del proceso de volcado sobre CEX_COMPRADOR_EXPEDIENTE
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' CEX (
              COM_ID
              ,ECO_ID
              ,DD_ECV_ID
              ,DD_REM_ID
              ,CEX_DOCUMENTO_CONYUGE
              ,CEX_ANTIGUO_DEUDOR
              ,DD_UAC_ID
              ,CEX_IMPTE_PROPORCIONAL_OFERTA
              ,CEX_IMPTE_FINANCIADO
              ,CEX_RESPONSABLE_TRAMITACION
              ,CEX_PORCION_COMPRA
              ,CEX_TITULAR_RESERVA
              ,CEX_TITULAR_CONTRATACION
              ,CEX_NOMBRE_RTE
              ,CEX_APELLIDOS_RTE
              ,DD_TDI_ID_RTE
              ,CEX_DOCUMENTO_RTE
              ,CEX_TELEFONO1_RTE
              ,CEX_TELEFONO2_RTE
              ,CEX_EMAIL_RTE
              ,CEX_DIRECCION_RTE
              ,CEX_CODIGO_POSTAL_RTE
              ,VERSION
              ,BORRADO
              ,CEX_FECHA_PETICION
              ,CEX_FECHA_RESOLUCION
              ,DD_LOC_ID_RTE
              ,DD_PRV_ID_RTE
          )
          SELECT DISTINCT 
            COM.COM_ID                                            AS COM_ID,
            ECO.ECO_ID                                              AS ECO_ID,
            ECV.DD_ECV_ID                                         AS DD_ECV_ID,
            REM.DD_REM_ID                                       AS DD_REM_ID,
            MIG2.CEX_DOCUMENTO_CONYUGE              AS CEX_DOCUMENTO_CONYUGE,
            MIG2.CEX_IND_ANTIGUO_DEUDOR               AS CEX_ANTIGUO_DEUDOR,
            UAC.DD_UAC_ID                                          AS DD_UAC_ID,
            MIG2.CEX_IMPORTE_PROPORCIONAL_OFR     AS CEX_IMPTE_PROPORCIONAL_OFERTA,
            MIG2.CEX_IMPORTE_FINANCIADO                 AS CEX_IMPTE_FINANCIADO,
            MIG2.CEX_RESPONSABLE_TRAMITACION        AS CEX_RESPONSABLE_TRAMITACION,
            MIG2.CEX_PORCENTAJE_COMPRA                  AS CEX_PORCION_COMPRA,
            MIG2.CEX_IND_TITULAR_RESERVA                  AS CEX_TITULAR_RESERVA,
            MIG2.CEX_IND_TITULAR_CONTRATACION       AS CEX_TITULAR_CONTRATACION,
            MIG2.CEX_NOMBRE_REPRESENTANTE             AS CEX_NOMBRE_RTE,
            MIG2.CEX_APELLIDOS_REPRESENTANTE          AS CEX_APELLIDOS_RTE,
            TDI.DD_TDI_ID                                              AS DD_TDI_ID_RTE,
            MIG2.CEX_DOCUMENTO_RTE                        AS CEX_DOCUMENTO_RTE,
            MIG2.CEX_TELEFONO1_RTE                          AS CEX_TELEFONO1_RTE,
            MIG2.CEX_TELEFONO2_RTE                          AS CEX_TELEFONO2_RTE,
            MIG2.CEX_EMAIL_RTE                                  AS CEX_EMAIL_RTE,
            MIG2.CEX_DIRECCION_RTE                          AS CEX_DIRECCION_RTE,            
            MIG2.CEX_CODIGO_POSTAL_RTE                  AS CEX_CODIGO_POSTAL_RTE,
            0                                                               AS VERSION,
            0                                                               AS BORRADO,
            MIG2.CEX_FECHA_PETICION                         AS CEX_FECHA_PETICION,
            MIG2.CEX_FECHA_RESOLUCION                   AS CEX_FECHA_RESOLUCION,
            LOC.DD_LOC_ID                                          AS DD_LOC_ID_RTE,
            PRV.DD_PRV_ID                                           AS DD_PRV_ID_RTE
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
          INNER JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC ON CLC.CLC_NUM_CLIENTE_HAYA = MIG2.CEX_COD_COMPRADOR AND CLC.BORRADO = 0
          INNER JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.CLC_ID = CLC.CLC_ID AND COM.BORRADO = 0
          INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIG2.CEX_COD_OFERTA AND OFR.BORRADO =0
          INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_ECV_ESTADOS_CIVILES ECV ON ECV.DD_ECV_CODIGO = MIG2.CEX_COD_ESTADO_CIVIL AND ECV.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_REM_REGIMENES_MATRIMONIALES REM ON REM.DD_REM_CODIGO = MIG2.CEX_COD_REGIMEN_MATRIMONIAL AND REM.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_UAC_USOS_ACTIVO UAC ON UAC.DD_UAC_CODIGO = MIG2.CEX_COD_USO_ACTIVO AND UAC.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_CODIGO = MIG2.CEX_COD_TIPO_DOC_RTE AND TDI.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG2.CEX_COD_LOCALIDAD_RTE AND LOC.BORRADO = 0
          LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA  PRV ON PRV.DD_PRV_CODIGO = MIG2.CEX_COD_PROVINCIA_RTE AND PRV.BORRADO = 0   
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
          
          IF TABLE_COUNT_1 != 0 THEN
              V_OBSERVACIONES := V_OBSERVACIONES|| ' Hay '||TABLE_COUNT_1||'  COMPRADORES (CLIENTES_COMERCIALES) inexistentes. ';
          END IF;     
          
          IF TABLE_COUNT_2 != 0 THEN
              V_OBSERVACIONES := V_OBSERVACIONES|| ' Hay '||TABLE_COUNT_2||' EXPEDIENTES_ECONOMICOS (OFERTAS) inexistentes. ';
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
