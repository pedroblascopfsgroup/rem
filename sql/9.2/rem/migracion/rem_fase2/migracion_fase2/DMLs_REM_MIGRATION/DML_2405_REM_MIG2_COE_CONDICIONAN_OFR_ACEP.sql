--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG2_COE_CONDICIONAN_OFR_ACEP' -> 'COE_CONDICIONANTES_EXPEDIENTE'
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
V_TABLA VARCHAR2(40 CHAR) := 'COE_CONDICIONANTES_EXPEDIENTE';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_COE_CONDICIONAN_OFR_ACEP';
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
        WHERE OFR.OFR_NUM_OFERTA = MIG.COE_COD_OFERTA
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
                MIG.COE_COD_OFERTA 
                FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
                WHERE NOT EXISTS (
                        SELECT 1 FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR 
                        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                                ON OFR.OFR_ID = ECO.OFR_ID
                        WHERE OFR.OFR_NUM_OFERTA = MIG.COE_COD_OFERTA
                  )
    )
    SELECT DISTINCT
    MIG.COE_COD_OFERTA                                                                          OFR_NUM_OFERTA,
    '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
    SYSDATE                                                                 FECHA_COMPROBACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG  
    INNER JOIN '||V_ESQUEMA||'.OFR_NUM_OFERTA
    ON OFR_NUM_OFERTA.COE_COD_OFERTA = MIG.COE_COD_OFERTA
    '
    ;
    
    COMMIT;

  END IF;
  
  
  --Inicio del proceso de volcado sobre COE_CONDICIONANTES_EXPEDIENTE
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
 
        EXECUTE IMMEDIATE ('
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
        COE_ID,
        ECO_ID,
        COE_SOLICITA_FINANCIACION,
        COE_ENTIDAD_FINANCIACION_AJENA,
        DD_TCC_ID,
        COE_PORCENTAJE_RESERVA,
        COE_PLAZO_FIRMA_RESERVA,
        COE_IMPORTE_RESERVA,
        DD_TIT_ID,
        COE_TIPO_APLICABLE,
        COE_RENUNCIA_EXENCION,
        COE_RESERVA_CON_IMPUESTO,
        COE_GASTOS_PLUSVALIA,
        DD_TPC_ID_PLUSVALIA,
        COE_GASTOS_NOTARIA,
        DD_TPC_ID_NOTARIA,
        COE_GASTOS_OTROS,
        DD_TPC_ID_GASTOS_OTROS,
        COE_FECHA_ACTUALIZACION_CARGAS,
        COE_CARGAS_IMPUESTOS,
        DD_TPC_ID_IMPUESTOS,
        COE_CARGAS_COMUNIDAD,
        DD_TPC_ID_COMUNIDAD,
        COE_CARGAS_OTROS,
        DD_TPC_ID_CARGAS_OTROS,
        COE_SUJETO_TANTEO_RETRACTO,
        COE_RENUNCIA_SNMTO_EVICCION,
        COE_RENUNCIA_SNMTO_VICIOS,
        COE_VPO,
        COE_LICENCIA,
        DD_TPC_ID_LICENCIA,
        COE_PROCEDE_DESCALIFICACION,
        COE_POSESION_INICIAL,
        DD_SIP_ID,
        DD_ETI_ID,
        VERSION,
        USUARIOCREAR,
        FECHACREAR,
        BORRADO
        )       
        SELECT 
        '||V_ESQUEMA||'.S_COE_CONDICIONANTES_EXP.NEXTVAL                        COE_ID,
        ECO.ECO_ID                                                                                                                      ECO_ID,
        MIG.COE_SOLICITA_FINANCIACION                                                                           COE_SOLICITA_FINANCIACION,
        MIG.COE_ENTIDAD_FINANCIACION_AJENA                                                                      COE_ENTIDAD_FINANCIACION_AJENA,
        TCC.DD_TCC_ID                                                                                                           DD_TCC_ID,
        MIG.COE_PORCENTAJE_RESERVA                                                                                      COE_PORCENTAJE_RESERVA,
        MIG.COE_PLAZO_FIRMA_RESERVA                                                                                     COE_PLAZO_FIRMA_RESERVA,
        MIG.COE_IMPORTE_RESERVA                                                                                         COE_IMPORTE_RESERVA,
        TIT.DD_TIT_ID                                                                                                           DD_TIT_ID,
        MIG.COE_TIPO_APLICABLE                                                                                          COE_TIPO_APLICABLE,
        MIG.COE_IND_RENUNCIA_EXENCION                                                                           COE_RENUNCIA_EXENCION,
        MIG.COE_IND_RESERVA_CON_IMPUESTO                                                                        COE_RESERVA_CON_IMPUESTO,
        MIG.COE_GASTOS_PLUSVALIA                                                                                        COE_GASTOS_PLUSVALIA,
        TPC_PLUSVALIA.DD_TPC_ID                                                                                         DD_TPC_ID_PLUSVALIA,
        MIG.COE_GASTOS_NOTARIA                                                                                          COE_GASTOS_NOTARIA,
        TPC_NOTARIA.DD_TPC_ID                                                                                           DD_TPC_ID_NOTARIA,
        MIG.COE_GASTOS_OTROS                                                                                            COE_GASTOS_OTROS,
        TPC_OTROS.DD_TPC_ID                                                                                                     DD_TPC_ID_GASTOS_OTROS,
        MIG.COE_FECHA_ACTUALIZACION_CARGAS                                                                      COE_FECHA_ACTUALIZACION_CARGAS,                                 
        MIG.COE_CARGAS_IMPUESTOS                                                                                        COE_CARGAS_IMPUESTOS,
        TPC_IMPUESTOS.DD_TPC_ID                                                                                         DD_TPC_ID_IMPUESTOS,
        MIG.COE_CARGAS_COMUNIDAD                                                                                        COE_CARGAS_COMUNIDAD,
        TPC_COMUNIDAD.DD_TPC_ID                                                                                         DD_TPC_ID_COMUNIDAD,
        MIG.COE_COE_CARGAS_OTROS                                                                                        COE_GASTOS_OTROS,
        TPC_GST_OTROS.DD_TPC_ID                                                                                         DD_TPC_ID_CARGAS_OTROS,
        MIG.COE_IND_SUJETO_TANTEO_RETRACTO                                                                      COE_SUJETO_TANTEO_RETRACTO,
        MIG.COE_IND_RENUNCIA_SNMTO_EVICCI                                                                       COE_RENUNCIA_SNMTO_EVICCION,
        MIG.COE_IND_RENUNCIA_SNMTO_VICIO                                                                        COE_RENUNCIA_SNMTO_VICIOS,
        MIG.COE_IND_VPO                                                                                                         COE_VPO,
        MIG.COE_IND_LICENCIA                                                                                            COE_LICENCIA,
        TPC_LICENCIA.DD_TPC_ID                                                                                          DD_TPC_ID_LICENCIA,
        MIG.COE_IND_PROCEDE_DESCALIFICA                                                                         COE_PROCEDE_DESCALIFICACION,
        MIG.COE_IND_POSESION_INICIAL                                                                            COE_POSESION_INICIAL,
        SIP.DD_SIP_ID                                                                                                           DD_SIP_ID,                                                                                              
        ETI.DD_ETI_ID                                                                                                           DD_ETI_ID,
        ''0''                                                                           VERSION,
        ''MIG2''                                                                        USUARIOCREAR,
        SYSDATE                                                                         FECHACREAR,
        0                                                                               BORRADO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR
                ON OFR.OFR_NUM_OFERTA = MIG.COE_COD_OFERTA
        INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                ON ECO.OFR_ID = OFR.OFR_ID
        LEFT JOIN '||V_ESQUEMA||'.DD_TCC_TIPO_CALCULO TCC
                ON TCC.DD_TCC_CODIGO = MIG.COE_COD_TIPO_CALCULO
        LEFT JOIN '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO TIT
                ON TIT.DD_TIT_CODIGO = MIG.COE_COD_TIPO_IMPUESTO
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_PLUSVALIA
                ON TPC_PLUSVALIA.DD_TPC_CODIGO = MIG.COE_COD_TIPO_PORCTA_PLUSVALIA
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_NOTARIA
                ON TPC_NOTARIA.DD_TPC_CODIGO = MIG.COE_COD_TIPO_PORCTA_NOTARIA
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_OTROS
                ON TPC_OTROS.DD_TPC_CODIGO = MIG.COE_COD_TIPO_PORCTA_OTROS
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_IMPUESTOS
                ON TPC_IMPUESTOS.DD_TPC_CODIGO = MIG.COE_COD_TIPO_CARGAS_IMPUESTOS
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_COMUNIDAD
                ON TPC_COMUNIDAD.DD_TPC_CODIGO = MIG.COE_COD_TIPO_CARGAS_COMUNIDAD
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_GST_OTROS
                ON TPC_GST_OTROS.DD_TPC_CODIGO = MIG.COE_COD_TIPO_CARGAS_OTROS
        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA TPC_LICENCIA
                ON TPC_LICENCIA.DD_TPC_CODIGO = MIG.COE_COD_TIPO_LICENCIA
        LEFT JOIN '||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA SIP
                ON SIP.DD_SIP_CODIGO = MIG.COE_COD_SITUACION_POSESORIA
        LEFT JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI
                ON ETI.DD_ETI_CODIGO = MIG.COE_COD_ESTADO_TITULO                                                                        
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
   
    V_OBSERVACIONES := 'Hay un total de '||V_REJECTS||' registros rechazados.';
  
    IF TABLE_COUNT != 0 THEN    
      V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' EXPEDIENTE_ECONOMICO inexistentes.';    
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
