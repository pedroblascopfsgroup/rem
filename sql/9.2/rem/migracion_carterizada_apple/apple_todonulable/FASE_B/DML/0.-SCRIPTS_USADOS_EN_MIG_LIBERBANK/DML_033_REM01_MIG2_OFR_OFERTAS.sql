--/*
--#########################################
--## AUTOR=Gustavo Mora
--## FECHA_CREACION=20180817
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-1550
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración [MIG2_OFR_OFERTAS -> OFR_OFERTAS] Y carga de ECO_EXPEDIENTE_COMERCIAL
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
  TABLE_COUNT_2 NUMBER(10,0) := 0;
  MAX_NUM_OFR NUMBER(10,0) := 0;
  V_NUM_TABLAS NUMBER(10,0) := 0;
  V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01'; --REM01
  V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER'; --REMMASTER
  V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
  V_TABLA VARCHAR2(40 CHAR) := 'OFR_OFERTAS';
  V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_OFR_OFERTAS';
  V_SENTENCIA VARCHAR2(32000 CHAR);
  V_REG_MIG NUMBER(10,0) := 0;
  V_REG_INSERTADOS NUMBER(10,0) := 0;
  V_DUPLICADOS NUMBER(10,0) := 0;
  V_REJECTS NUMBER(10,0) := 0;
  V_COD NUMBER(10,0) := 0;
  V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
  V_OFR_ID NUMBER(16,0);    -- Varaible que almacenara las OFR_ID de aquellas ofertas aceptadas
  V_TABLE_ECO NUMBER(16,0); -- Variable que almacenara los Expedientes Comerciales creados
  V_TABLE_DD_EOF NUMBER(16,0); -- Variable que almacenara los ESTADOS_OFERTAS modificados
  V_TABLE_ECO_MER NUMBER(16,0); -- Variable que almacenara los Expedientes Comerciales mergeados

BEGIN
  
  --Inicio del proceso de volcado sobre OFR_OFERTAS
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  V_SENTENCIA := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
      OFR_ID,
      OFR_NUM_OFERTA,            
      AGR_ID,
      OFR_IMPORTE,
      CLC_ID,
      DD_EOF_ID,
      DD_TOF_ID,
      VIS_ID,
      DD_EVO_ID,            
      OFR_FECHA_ALTA,
      OFR_FECHA_NOTIFICACION,
      OFR_IMPORTE_CONTRAOFERTA,
      OFR_FECHA_CONTRAOFERTA,
      USU_ID,
      OFR_FECHA_RECHAZO,
      OFR_IND_LOTE_RESTRINGIDO,
      OFR_IMPORTE_APROBADO,
      PVE_ID_PRESCRIPTOR,
      PVE_ID_API_RESPONSABLE,
      PVE_ID_CUSTODIO,
      PVE_ID_FDV,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      OFR_WEBCOM_ID
    )
    SELECT 
      '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                     OFR_ID, 
      MIG.OFR_COD_OFERTA                                          OFR_COD_OFERTA,            
      AGR.AGR_ID                                                  AGR_ID,
      CASE WHEN MIG.OFR_IMPORTE = 0 THEN null
        ELSE MIG.OFR_IMPORTE END                                  OFR_IMPORTE,
      CLC.CLC_ID                                                  CLC_ID,
      EOF.DD_EOF_ID                                               DD_EOF_ID,
      TOF.DD_TOF_ID                                               DD_TOF_ID,
      VIS.VIS_ID                                                  VIS_ID,
      EVO.DD_EVO_ID                                               DD_EVO_ID,            
      MIG.OFR_FECHA_ALTA                                          OFR_FECHA_ALTA,
      CASE 
        WHEN MIG.OFR_FECHA_NOTIFICACION IS null 
          AND MIG.OFR_COD_ESTADO_OFERTA LIKE ''01%'' 
            THEN SYSDATE                
        ELSE MIG.OFR_FECHA_NOTIFICACION 
      END                                                         OFR_FECHA_NOTIFICACION,
      CASE 
        WHEN MIG.OFR_IMPORTE <> MIG.OFR_IMPORTE_APROBADO AND MIG.OFR_IMPORTE_APROBADO <> 0 
          AND MIG.OFR_IMPORTE_APROBADO IS NOT NULL
          THEN MIG.OFR_IMPORTE_APROBADO
        WHEN MIG.OFR_IMPORTE_CONTRAOFERTA = 0
          THEN NULL
        ELSE MIG.OFR_IMPORTE_CONTRAOFERTA
      END                                                         OFR_IMPORTE_CONTRAOFERTA,
      CASE 
        WHEN MIG.OFR_IMPORTE_CONTRAOFERTA != 0 AND MIG.OFR_FECHA_CONTRAOFERTA is null 
          THEN SYSDATE
        ELSE MIG.OFR_FECHA_CONTRAOFERTA 
      END                                                         OFR_FECHA_CONTRAOFERTA,
      USU.USU_ID                                                  USU_ID,
      CASE 
        WHEN MIG.OFR_FECHA_RECHAZO IS null 
          AND MIG.OFR_COD_ESTADO_OFERTA = ''02'' 
            THEN SYSDATE
        ELSE MIG.OFR_FECHA_RECHAZO 
      END                                                         OFR_FECHA_RECHAZO,
      MIG.OFR_IND_LOTE_RESTRINGIDO                                OFR_IND_LOTE_RESTRINGIDO,
      CASE 
        WHEN MIG.OFR_IMPORTE_APROBADO = 0 
          THEN null
        ELSE MIG.OFR_IMPORTE_APROBADO 
      END                                                         OFR_IMPORTE_APROBADO,
      (
        SELECT PVE_ID 
        FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
        INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR 
        ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
        WHERE TPR.DD_TPR_CODIGO IN 
        (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
        AND PVE_COD_PRINEX = TO_CHAR(MIG.OFR_COD_PRESCRIPTOR_UVEM) AND PVE.PVE_FECHA_BAJA IS NULL
        AND ROWNUM = 1
      )                                                               PVE_ID_PRESCRIPTOR,
      (
        SELECT PVE_ID 
        FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
        INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR 
        ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
        WHERE TPR.DD_TPR_CODIGO IN 
        (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
        AND PVE_COD_PRINEX = TO_CHAR(MIG.OFR_COD_API_RESPONSABLE_UVEM) AND PVE.PVE_FECHA_BAJA IS NULL
        AND ROWNUM = 1
      )                                                               PVE_ID_API_RESPONSABLE,
      (
        SELECT PVE_ID 
        FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
        INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR 
        ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
        WHERE TPR.DD_TPR_CODIGO IN 
        (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
        AND PVE_COD_PRINEX = TO_CHAR(MIG.OFR_COD_CUSTODIO_UVEM) AND PVE.PVE_FECHA_BAJA IS NULL
        AND ROWNUM = 1
      )                                                              PVE_ID_CUSTODIO,
      (
        SELECT PVE_ID 
        FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
        INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR 
        ON TPR.DD_TPR_ID = PVE.DD_TPR_ID
        WHERE TPR.DD_TPR_CODIGO IN 
        (''04'',''18'',''23'',''28'',''29'',''30'',''31'',''38'')
        AND PVE_COD_PRINEX = TO_CHAR(MIG.OFR_COD_FDV_UVEM) AND PVE.PVE_FECHA_BAJA IS NULL
        AND ROWNUM = 1
      )                                                             PVE_ID_FDV,     
      0                                                             VERSION,
      '''||V_USUARIO||'''                                           USUARIOCREAR,
      SYSDATE                                                       FECHACREAR,
      0                                                             BORRADO,
      MIG.OFR_WEBCOM_ID                                             OFR_WEBCOM_ID
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
      LEFT JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_NUM_AGRUP_UVEM = MIG.OFR_COD_AGRUPACION
      LEFT JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC ON CLC.CLC_REM_ID = MIG.CLC_REM_ID OR (MIG.CLC_REM_ID IS NULL AND CLC.CLC_COD_CLIENTE_PRINEX = MIG.OFR_COD_CLIENTE_WEBCOM AND CLC.USUARIOCREAR = '''||V_USUARIO||''')
      LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_CODIGO = SUBSTR(MIG.OFR_COD_ESTADO_OFERTA,0,2)
      LEFT JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_CODIGO = MIG.OFR_COD_TIPO_OFERTA
      LEFT JOIN '||V_ESQUEMA||'.VIS_VISITAS VIS ON VIS.VIS_WEBCOM_ID = MIG.OFR_COD_VISITA_WEBCOM
      LEFT JOIN '||V_ESQUEMA||'.DD_EVO_EST_VISITA_OFERTA EVO ON EVO.DD_EVO_CODIGO = MIG.OFR_COD_ESTADO_VISITA_OFR
      LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = MIG.OFR_COD_USUARIO_LDAP_ACCION
    WHERE MIG.VALIDACION = 0 AND NOT EXISTS (SELECT 1 FROM REM01.OFR_OFERTAS OFR WHERE MIG.OFR_WEBCOM_ID = OFR.OFR_WEBCOM_ID)
  '
  ;
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
EXECUTE IMMEDIATE 'MERGE INTO OFR_OFERTAS T1
USING (SELECT T1.OFR_ID, T1.DD_EOF_ID
    FROM OFR_OFERTAS T1
    JOIN MIG2_OFR_OFERTAS T2 ON T1.OFR_NUM_OFERTA = T2.OFR_COD_OFERTA AND T2.VALIDACION = 0
    WHERE T2.OFR_FECHA_ANULACION IS NOT NULL
    ) T2
ON (T1.OFR_ID = T2.OFR_ID)
WHEN MATCHED THEN UPDATE SET
    T1.DD_EOF_ID = (SELECT DD_EOF_ID FROM REM01.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02'')
    , T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSTIMESTAMP
WHERE
    T1.DD_EOF_ID <> (SELECT DD_EOF_ID FROM REM01.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02'')';

DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' actualizada (DD_EOF_ID). '||SQL%ROWCOUNT||' Filas.');

  V_REG_INSERTADOS := SQL%ROWCOUNT;
  
  -- Inicializamos la secuencia S_OFR_NUM_OFERTA    
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INICIALIZACION DE LA SECUENCIA S_OFR_NUM_OFERTA  DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
  
  -- Obtenemos el valor maximo de la columna OFR_NUM_OFERTA y lo incrementamos en 1
  V_SENTENCIA := 'SELECT NVL(MAX(OFR_NUM_OFERTA),0) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
  EXECUTE IMMEDIATE V_SENTENCIA INTO MAX_NUM_OFR;
  
  MAX_NUM_OFR := MAX_NUM_OFR +1;
  
  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_OFR_NUM_OFERTA'' 
  AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS; 
  
  -- Si existe secuencia la borramos
  IF V_NUM_TABLAS = 1 THEN
  EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_OFR_NUM_OFERTA';
  DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_OFR_NUM_OFERTA... Secuencia eliminada');    
  END IF;
  
  EXECUTE IMMEDIATE 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_OFR_NUM_OFERTA  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||MAX_NUM_OFR||' NOCACHE NOORDER  NOCYCLE';
  
  DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_OFR_NUM_OFERTA... Secuencia creada e inicializada correctamente.');
  
  -----------------------------------------
  -- CREACION DE EXPEDIENTES COMERCIALES --
  -----------------------------------------   
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE GENERACION DE EXPEDIENTES COMERCIALES PARA OFERTAS ACEPTADAS');
  
  EXECUTE IMMEDIATE '
    INSERT INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL (
      ECO_ID
      ,ECO_NUM_EXPEDIENTE
      ,OFR_ID
      ,DD_EEC_ID
      ,ECO_FECHA_ALTA
      ,ECO_FECHA_SANCION 
      ,ECO_FECHA_ANULACION
      ,DD_MAN_ID 
      ,DD_EEC_ID_ANT
      , VERSION
      , USUARIOCREAR
      , FECHACREAR
      , DD_COS_ID
      , ECO_FECHA_SANCION_COMITE
    )
    SELECT
      '||V_ESQUEMA||'.S_ECO_EXPEDIENTE_COMERCIAL.NEXTVAL                                       AS ECO_ID,
      '||V_ESQUEMA||'.S_ECO_NUM_EXPEDIENTE.NEXTVAL                                             AS ECO_NUM_EXPEDIENTE,
      OFR.OFR_ID                                                                               AS OFR_ID,
      CASE
        WHEN MIG2.OFR_FECHA_ANULACION IS NULL
          THEN (SELECT DD.DD_EEC_ID
                FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DD
                WHERE DD.DD_EEC_CODIGO =  DECODE(MIG2.OFR_COD_ESTADO_OFERTA,''01-01'',''10'', 
                                                                            ''01-02'',''06'', 
                                                                            ''01-03'',''11'', 
                                                                            ''01-04'',''04'', 
                                                                            ''01-05'',''02'', 
                                                                            ''01-06'',''11'', 
                                                                            ''01-07'',''08'', 
                                                                            ''01-08'',''02'', 
                                                                            ''01-09'',''08'',
                                                                            ''01-10'',''01'',
                                                                            ''01-11'',''11'',
                                                                            ''01-12'',''11'',
                                                                            ''01-13'',''06'',
                                                                            ''01-14'',''01'',
                                                                            ''01-16'',''11'',
                                                                            ''01-17'',''06'',
                                                                            ''01-18'',''11'',
                                                                            ''01-20'',''06'',
                                                                            ''01-21'',''11'',
                                                                            ''01-22'',''08'',
                                                                            ''01-23'',''08'',
                                                                            ''01-24'',''08'',
                                                                            ''01-25'',''08'',   
                                                                            ''01-25'',''16''   
                                                                            ))
        ELSE (SELECT DD.DD_EEC_ID
              FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DD 
              WHERE DD.DD_EEC_CODIGO = ''02'')
      END                                                                                       AS DD_EEC_ID,
      OFR.OFR_FECHA_ALTA                                                                        AS ECO_FECHA_ALTA,
      DECODE(MIG2.OFR_COD_ESTADO_OFERTA, 
            ''01-01'',OFR.OFR_FECHA_ALTA,
			''01-02'',OFR.OFR_FECHA_ALTA,
			''01-03'',OFR.OFR_FECHA_ALTA,
			''01-04'',OFR.OFR_FECHA_ALTA,
			''01-05'',OFR.OFR_FECHA_ALTA,
			''01-06'',OFR.OFR_FECHA_ALTA,
			''01-07'',OFR.OFR_FECHA_ALTA,
			''01-08'',OFR.OFR_FECHA_ALTA,
			''01-09'',OFR.OFR_FECHA_ALTA,
			''01-10'',OFR.OFR_FECHA_ALTA,
			''01-11'',OFR.OFR_FECHA_ALTA,
			''01-12'',OFR.OFR_FECHA_ALTA,
			''01-13'',OFR.OFR_FECHA_ALTA,
			''01-14'',OFR.OFR_FECHA_ALTA,
			''01-16'',OFR.OFR_FECHA_ALTA,
			''01-17'',OFR.OFR_FECHA_ALTA,
			''01-18'',OFR.OFR_FECHA_ALTA,
			''01-20'',OFR.OFR_FECHA_ALTA,
			''01-21'',OFR.OFR_FECHA_ALTA,
			''01-22'',OFR.OFR_FECHA_ALTA,
			''01-23'',OFR.OFR_FECHA_ALTA,
			''01-24'',OFR.OFR_FECHA_ALTA,
			''01-25'',OFR.OFR_FECHA_ALTA,
			''01-26'',OFR.OFR_FECHA_ALTA,
            NULL)                                                                               AS ECO_FECHA_SANCION,
      CASE
        WHEN MIG2.OFR_FECHA_ANULACION IS NULL
          THEN (CASE 
                  WHEN MIG2.OFR_COD_ESTADO_OFERTA = ''01-08''
                    THEN MIG2.OFR_ESTADO_FECHA
                  ELSE NULL
                END)
        ELSE MIG2.OFR_FECHA_ANULACION
      END                                                                                        AS ECO_FECHA_ANULACION,
      CASE
        WHEN MIG2.OFR_COD_ESTADO_OFERTA = ''01-08''
          THEN MAN.DD_MAN_ID
        ELSE NULL
      END                                                                                        AS DD_MAN_ID,
      CASE
        WHEN MIG2.OFR_FECHA_ANULACION IS NULL
          THEN NULL
        ELSE (SELECT DD.DD_EEC_ID
              FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DD
              WHERE DD.DD_EEC_CODIGO =  DECODE(MIG2.OFR_COD_ESTADO_OFERTA,  ''01-01'',''10'', 
                                                                            ''01-02'',''06'', 
                                                                            ''01-03'',''11'', 
                                                                            ''01-04'',''04'', 
                                                                            ''01-05'',''02'', 
                                                                            ''01-06'',''11'', 
                                                                            ''01-07'',''08'', 
                                                                            ''01-08'',''02'', 
                                                                            ''01-09'',''08'',
                                                                            ''01-10'',''01'',
                                                                            ''01-11'',''11'',
                                                                            ''01-12'',''11'',
                                                                            ''01-13'',''06'',
                                                                            ''01-14'',''01'',
                                                                            ''01-16'',''11'',
                                                                            ''01-17'',''06'',
                                                                            ''01-18'',''11'',
                                                                            ''01-20'',''06'',
                                                                            ''01-21'',''11'',
                                                                            ''01-22'',''08'',
                                                                            ''01-23'',''08'',
                                                                            ''01-24'',''08'',
                                                                            ''01-25'',''08'',
                                                                            ''01-26'',''16''
																			))       
      END                                                                                        AS DD_EEC_ID_ANT,
      0                                                                                          AS VERSION,
      '''||V_USUARIO||'''                                                                        AS USUARIOCREAR,
      SYSDATE                                                                                    AS FECHACREAR,
      (
        SELECT DD_COS_ID 
        FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION 
        WHERE DD_COS_CODIGO = TRIM(LEADING ''0'' FROM MIG2.OFR_COMITE_SANCION) AND BORRADO = 0
      )                                                                                          AS DD_COS_ID,
      MIG2.OFR_FECHA_SANCION_COMITE                                                              AS ECO_FECHA_SANCION_COMITE
    FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
      INNER JOIN '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 ON MIG2.OFR_COD_OFERTA = OFR.OFR_NUM_OFERTA
      LEFT JOIN '||V_ESQUEMA||'.DD_MAN_MOTIVO_ANULACION MAN ON MIG2.OFR_COD_MOTIVO_ANULACION = MAN.DD_MAN_CODIGO
    WHERE SUBSTR(MIG2.OFR_COD_ESTADO_OFERTA,0,2) = ''01''
    AND NOT EXISTS (
      SELECT 1
      FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL AUX
      WHERE AUX.OFR_ID = OFR.OFR_ID
    ) AND MIG2.VALIDACION = 0
  '
  ;   
  
  V_TABLE_ECO := SQL%ROWCOUNT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL cargada. '||V_TABLE_ECO||' Filas.');

  -----------------------------------------
  -- ACTUALIZACION DE ESTADOS DE OFERTAS --
  -----------------------------------------   
  DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION DE LOS ESTADOS DE LAS OFERTAS');
  
  EXECUTE IMMEDIATE '
    MERGE INTO OFR_OFERTAS OFR
    USING 
    ( 
      SELECT  OFRW.OFR_ID
      FROM '||V_ESQUEMA||'.'||V_TABLA||' OFRW
      INNER JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFRW.OFR_ID
      WHERE OFRW.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''01'')
      AND (ECO.DD_EEC_ID =  (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''02'') OR ECO.DD_EEC_ID =  (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''12''))
    ) AUX
    ON (OFR.OFR_ID = AUX.OFR_ID)
    WHEN MATCHED THEN UPDATE SET
    OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02'')
  '
  ;   
  
  V_TABLE_DD_EOF := SQL%ROWCOUNT;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' ACTUALIZADAS. '||V_TABLE_DD_EOF||' Filas.');
  


    ---------------------------------
    -- ACTUALIZACION DE ESTADO PBC --
    ---------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MERGEO DEL ECO_ESTADO_PBC PARA LOS EXPEDIENTES COMERCIALES CREADOS');

    EXECUTE IMMEDIATE '
  MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
    USING (
    WITH SUMATORIO AS (SELECT CEX_COD_OFERTA, SUM(CEX_IND_PBC) AS SUMA, COUNT(1)AS CON FROM '||V_ESQUEMA||'.MIG2_CEX_COMPRADOR_EXPEDIENTE
            GROUP BY CEX_COD_OFERTA)
    SELECT CASE
    WHEN SUMA.CON = SUMA.SUMA
      THEN 1
    WHEN SUMA.SUMA = 0
      THEN 0
    ELSE NULL
    END AS RESULTADO, OFR.OFR_ID, SUMA.SUMA, SUMA.CON
    FROM SUMATORIO SUMA
    INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON SUMA.CEX_COD_OFERTA = OFR.OFR_NUM_OFERTA
    ) AUX
  ON (ECO.OFR_ID = AUX.OFR_ID)
  WHEN MATCHED THEN UPDATE SET
      ECO.ECO_ESTADO_PBC = AUX.RESULTADO
    '
    ;   
    
    V_TABLE_ECO_MER := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL cargada. '||V_TABLE_ECO_MER||' ECO_ESTADO_PBC mergeados.');
  
    EXECUTE IMMEDIATE 'MERGE INTO REM01.ECO_EXPEDIENTE_COMERCIAL T1
      USING (SELECT DISTINCT T4.ECO_ID
          FROM REM01.MIG2_OFR_OFERTAS T1
          JOIN REM01.MIG2_RES_RESERVAS T2 ON T1.OFR_COD_OFERTA = T2.RES_COD_OFERTA AND T2.VALIDACION = 0
          JOIN REM01.OFR_OFERTAS T3 ON T3.OFR_NUM_OFERTA = T1.OFR_COD_OFERTA AND T3.BORRADO = 0
          JOIN REM01.ECO_EXPEDIENTE_COMERCIAL T4 ON T4.OFR_ID = T3.OFR_ID AND T4.BORRADO = 0
          JOIN REM01.DD_EEC_EST_EXP_COMERCIAL T5 ON T5.DD_EEC_ID = T4.DD_EEC_ID AND T5.DD_EEC_CODIGO <> ''06''
          WHERE T1.OFR_COD_ESTADO_OFERTA = ''01-03'' AND T2.RES_FECHA_FIRMA IS NOT NULL AND T1.OFR_FECHA_ANULACION IS NULL AND T1.VALIDACION = 0) T2
      ON (T1.ECO_ID = T2.ECO_ID)
      WHEN MATCHED THEN UPDATE SET
          T1.DD_EEC_ID = (SELECT DD_EEC_ID FROM REM01.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''06'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL actualizada. '||SQL%ROWCOUNT||' DD_EEC_ID actualizados con estado RESERVADO.');

  COMMIT; 
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'','''||V_TABLA||''',''1''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;
  
  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''ECO_EXPEDIENTE_COMERCIAL'',''1''); END;';
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
