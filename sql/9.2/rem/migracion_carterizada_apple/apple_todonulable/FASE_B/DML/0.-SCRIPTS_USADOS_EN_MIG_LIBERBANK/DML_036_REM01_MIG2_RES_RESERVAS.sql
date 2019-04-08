--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
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
      V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
      V_TABLA VARCHAR2(40 CHAR) := 'RES_RESERVAS';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_RES_RESERVAS';
      V_SENTENCIA VARCHAR2(2000 CHAR);

BEGIN 
 
      --Inicio del proceso de volcado sobre RES_RESERVAS
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
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
                  DD_MAR_ID,
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
                  MAN.DD_MAR_ID,
                  TAR.DD_TAR_ID,
                  ERE.DD_ERE_ID,
                  MIGW.RES_FECHA_SOLICITUD,
                  MIGW.RES_FECHA_RESOLUCION
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
                  INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_NUM_OFERTA = MIGW.RES_COD_OFERTA
                  INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
                  LEFT JOIN '||V_ESQUEMA||'.DD_TAR_TIPOS_ARRAS TAR ON TO_NUMBER(TAR.DD_TAR_CODIGO) = MIGW.RES_COD_TIPO_ARRA
                  LEFT JOIN '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE ON TO_NUMBER(ERE.DD_ERE_CODIGO) = MIGW.RES_COD_ESTADO_RESERVA
                  LEFT JOIN '||V_ESQUEMA||'.DD_MAR_MOTIVO_ANULACION_RES MAN ON MAN.DD_MAR_CODIGO = MIGW.RES_COD_MOTIVO_ANULACION
            WHERE MIGW.VALIDACION = 0
      )
      SELECT 
      '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                           RES_ID,
      RES.ECO_ID                                                        ECO_ID,
      RES.RES_COD_NUM_RESERVA                                           RES_NUM_RESERVA,
      RES.RES_FECHA_FIRMA                                               RES_FECHA_FIRMA,
      RES.RES_FECHA_VENCIMIENTO                                         RES_FECHA_VENCIMIENTO,
      RES.RES_FECHA_ANULACION                                           RES_FECHA_ANULACION,
      RES.RES_IND_IMP_ANULACION                                         RES_IND_IMP_ANULACION,
      RES.RES_IMPORTE_DEVUELTO                                          RES_IMPORTE_DEVUELTO,   
      RES.DD_TAR_ID                                                     DD_TAR_ID,
      RES.DD_ERE_ID                                                     DD_ERE_ID,
      RES.RES_FECHA_SOLICITUD                                           RES_FECHA_SOLICITUD,
      RES.RES_FECHA_RESOLUCION                                          RES_FECHA_RESOLUCION,
      RES.DD_MAR_ID                                                                                   DD_MAR_ID,
      ''0''                                                             VERSION,
      '''||V_USUARIO||'''                                           USUARIOCREAR,
      SYSDATE                                                           FECHACREAR,
      0                                                                 BORRADO
      FROM INSERTAR RES';
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -----------------------------------------
      -- ACTUALIZACION DE EXPEDIENTES COMERCIALES --
      -----------------------------------------   
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION DE EXPEDIENTES COMERCIALES');
      
      EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            USING
            (
                  SELECT DISTINCT
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
                        NULL                                                                                                                   AS ECO_PETICIONARIO_ANULACION,
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
                  ECO.ECO_FECHA_CONT_PROPIETARIO = AUX.ECO_FECHA_CONT_PROPIETARIO
                  ,ECO.ECO_PETICIONARIO_ANULACION = AUX.ECO_PETICIONARIO_ANULACION
                  ,ECO.ECO_IMP_DEV_ENTREGAS = AUX.ECO_IMP_DEV_ENTREGAS
                  ,ECO.ECO_FECHA_DEV_ENTREGAS = AUX.ECO_FECHA_DEV_ENTREGAS
                  ,ECO.ECO_FECHA_SANCION_COMITE = AUX.ECO_FECHA_SANCION_COMITE      
      '
      ;   
      
      --Según comentario de Tomás y Manuel, eliminamos ECO_PETICIONARIO_ANULACION porque nunca va a venir informado y mejor que esté blanco.
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL cargada. '||SQL%ROWCOUNT||' Filas.');

      DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO EL ESTADO DEL EXPEDIENTE COMERCIAL A RESERVADO PARA AQUELLOS QUE TIENEN RESERVA Y CODIGO 01-06');
      
      EXECUTE IMMEDIATE '
            MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
            USING 
            (
              SELECT ECO.ECO_ID
              FROM '||V_ESQUEMA||'.RES_RESERVAS RES
                INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON RES.ECO_ID = ECO.ECO_ID
                INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
                INNER JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0
                INNER JOIN '||V_ESQUEMA||'.MIG2_OFR_OFERTAS MIG2 ON MIG2.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
              WHERE RES.RES_FECHA_FIRMA IS NOT NULL AND MIG2.OFR_COD_ESTADO_OFERTA = ''01-06'' AND EOF.DD_EOF_CODIGO = ''01''
            ) SQLI ON (SQLI.ECO_ID = ECO.ECO_ID)
            WHEN MATCHED THEN UPDATE SET
              ECO.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''06'' AND BORRADO = 0)    
      '
      ;   
      
      --Según comentario de Tomás y Manuel, eliminamos ECO_PETICIONARIO_ANULACION porque nunca va a venir informado y mejor que esté blanco.
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL actualizada. '||SQL%ROWCOUNT||' Filas.');
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ECO_EXPEDIENTE_COMERCIAL'',''10''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      

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
