--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20160929
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_RES_RESERVAS' -> 'RES_RESERVAS'
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
      V_TABLA VARCHAR2(40 CHAR) := 'RES_RESERVAS';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_RES_RESERVAS';
      V_SENTENCIA VARCHAR2(2000 CHAR);
      V_REG_MIG NUMBER(10,0) := 0;
      V_REG_INSERTADOS NUMBER(10,0) := 0;
      V_REJECTS NUMBER(10,0) := 0;
      V_COD NUMBER(10,0) := 0;
      V_DUP NUMBER(10,0) := 0;
      V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
      V_TABLE_ECO NUMBER(10,0) := 0;

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
      WHERE OFR.OFR_NUM_OFERTA = MIG.RES_COD_OFERTA
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
                  MIG.RES_COD_OFERTA 
                  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                  WHERE NOT EXISTS (
                  SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                  INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                  ON OFR.OFR_ID = ECO.OFR_ID
                  WHERE OFR.OFR_NUM_OFERTA = MIG.RES_COD_OFERTA
            )
            )
            SELECT DISTINCT
                  MIG.RES_COD_OFERTA                                                                            OFR_NUM_OFERTA,
                  '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
                  SYSDATE                                                                 FECHA_COMPROBACION
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
                  INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA ON OFR_NUM_OFERTA.RES_COD_OFERTA = MIG.RES_COD_OFERTA
            '
            ;
            
            COMMIT;
      
      END IF;   
      
      
      --Inicio del proceso de volcado sobre RES_RESERVAS
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE ('
      INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            RES_ID,
            ECO_ID,
            RES_NUM_RESERVA,
            RES_FECHA_FIRMA,
            RES_FECHA_VENCIMIENTO,
            RES_FECHA_ANULACION,
            RES_IND_IMP_ANULACION,
            RES_IMPORTE_DEVUELTO,
            DD_TAR_ID,
            DD_ERE_ID,
            RES_FECHA_SOLICITUD,
            RES_FECHA_RESOLUCION,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO
      )
            WITH INSERTAR AS (
            SELECT DISTINCT
                  ECO.ECO_ID,
                  MIGW.RES_COD_NUM_RESERVA,
                  MIGW.RES_FECHA_FIRMA,
                  MIGW.RES_FECHA_VENCIMIENTO,
                  MIGW.RES_FECHA_ANULACION,
                  MIGW.RES_IND_IMP_ANULACION,
                  MIGW.RES_IMPORTE_DEVUELTO,
                  TAR.DD_TAR_ID,
                  ERE.DD_ERE_ID,
                  MIGW.RES_FECHA_SOLICITUD,
                  MIGW.RES_FECHA_RESOLUCION
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
                  INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIGW.RES_COD_OFERTA
                  INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                  LEFT JOIN '||V_ESQUEMA||'.DD_TAR_TIPOS_ARRAS TAR ON TO_NUMBER(TAR.DD_TAR_CODIGO) = MIGW.RES_COD_TIPO_ARRA
                  LEFT JOIN '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE ON TO_NUMBER(ERE.DD_ERE_CODIGO) = MIGW.RES_COD_ESTADO_RESERVA
            WHERE NOT EXISTS (
                 SELECT 1 
                 FROM '||V_ESQUEMA||'.'||V_TABLA||' RESW 
                 WHERE MIGW.RES_COD_NUM_RESERVA = RESW.RES_NUM_RESERVA
            )
      )
      SELECT 
      '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                                           RES_ID,
      RES.ECO_ID                                                                                                                ECO_ID,
      RES.RES_COD_NUM_RESERVA                                                                                   RES_NUM_RESERVA,
      RES.RES_FECHA_FIRMA                                                                                               RES_FECHA_FIRMA,
      RES.RES_FECHA_VENCIMIENTO                                                                                 RES_FECHA_VENCIMIENTO,
      RES.RES_FECHA_ANULACION                                                                                   RES_FECHA_ANULACION,
      RES.RES_IND_IMP_ANULACION                                                                                 RES_IND_IMP_ANULACION,
      RES.RES_IMPORTE_DEVUELTO                                                                                  RES_IMPORTE_DEVUELTO,
      RES.DD_TAR_ID                                                                                                             DD_TAR_ID,
      DD_ERE_ID                                                                                                                 DD_ERE_ID,
      RES.RES_FECHA_SOLICITUD                                                                                   RES_FECHA_SOLICITUD,
      RES.RES_FECHA_RESOLUCION                                                                                  RES_FECHA_RESOLUCION,
      ''0''                                                                             VERSION,
      ''MIG2''                                                                          USUARIOCREAR,
      SYSDATE                                                                           FECHACREAR,
      0                                                                                 BORRADO
      FROM INSERTAR RES                                                                 
      ')
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -----------------------------------------
      -- ACTUALIZACION DE EXPEDIENTES COMERCIALES --
      -----------------------------------------   
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION DE EXPEDIENTES COMERCIALES');
      
      EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            USING
            (
                  SELECT 
                        ECO2.ECO_ID                                                                                                         AS ECO_ID,
                        CASE
                              WHEN EEC.DD_EEC_CODIGO = ''02''
                                    THEN RES.RES_FECHA_ANULACION
                              ELSE NULL
                        END                                                                                                                  AS ECO_FECHA_ANULACION,
                        CASE
                              WHEN EEC.DD_EEC_CODIGO = ''02''
                                    THEN RES.RES_MOTIVO_ANULACION
                              ELSE NULL
                        END                                                                                                                    AS ECO_MOTIVO_ANULACION,
                        NULL                                                                                                                   AS ECO_FECHA_CONT_PROPIETARIO,
                        NVL(OFR.USU_ID,
                              (SELECT USU_ID
                                    FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS
                                    WHERE USU_USERNAME = ''MIGRACION''
                                    AND BORRADO = 0)
                        )                                                                                                                         AS ECO_PETICIONARIO_ANULACION,
                        CASE
                              WHEN RES.RES_FECHA_ANULACION IS NOT NULL
                                    THEN RES_IMPORTE_DEVUELTO
                              ELSE NULL
                        END                                                                                                                   AS ECO_IMP_DEV_ENTREGAS,
                        CASE
                              WHEN EEC.DD_EEC_CODIGO = ''06'' AND RES.RES_IND_IMP_ANULACION = 1
                                    THEN SYSDATE
                              ELSE NULL
                        END                                                                                                                   AS ECO_FECHA_DEV_ENTREGAS,
                        DECODE(EEC.DD_EEC_CODIGO
                              ,''12'',OFR.OFR_FECHA_ALTA
                              ,''11'',OFR.OFR_FECHA_ALTA
                              ,''04'',OFR.OFR_FECHA_ALTA
                              ,NULL)                                                                                                          AS ECO_FECHA_SANCION_COMITE
                  FROM '||V_ESQUEMA||'.RES_RESERVAS RES
                  INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO2 ON ECO2.ECO_ID = RES.ECO_ID
                  INNER JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO2.DD_EEC_ID
                  INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO2.OFR_ID
            ) AUX
            ON (AUX.ECO_ID = ECO.ECO_ID)
            WHEN MATCHED THEN UPDATE SET
                  ECO.ECO_FECHA_ANULACION = AUX.ECO_FECHA_ANULACION
                  ,ECO.ECO_MOTIVO_ANULACION = AUX.ECO_MOTIVO_ANULACION
                  ,ECO.ECO_FECHA_CONT_PROPIETARIO = AUX.ECO_FECHA_CONT_PROPIETARIO
                  ,ECO.ECO_PETICIONARIO_ANULACION = AUX.ECO_PETICIONARIO_ANULACION
                  ,ECO.ECO_IMP_DEV_ENTREGAS = AUX.ECO_IMP_DEV_ENTREGAS
                  ,ECO.ECO_FECHA_DEV_ENTREGAS = AUX.ECO_FECHA_DEV_ENTREGAS
                  ,ECO.ECO_FECHA_SANCION_COMITE = AUX.ECO_FECHA_SANCION_COMITE      
      '
      ;   
      
      V_TABLE_ECO := SQL%ROWCOUNT;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL cargada. '||V_TABLE_ECO||' Filas.');
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ANALIZADA.');
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;
      
      -- Observaciones
      IF V_TABLE_ECO != 0 THEN
            V_OBSERVACIONES := 'Se han actualizado '||V_TABLE_ECO||' Expedientes Comerciales.';
      END IF;
      
      IF V_REJECTS != 0 THEN    
            V_OBSERVACIONES := 'Hay un total de '||V_REJECTS||' registros rechazados. Comprobar la unicidad del campo RES_COD_NUM_RESERVA';
      
            IF TABLE_COUNT != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' OFERTAS inexistentes. ';    
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
