--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración 'MIG_AIA_INFOCOMERCIAL_ACTIVO' -> 'ACT_ICO_INFO_COMERCIAL'  - ACT_EDI_EDIFICIO - ACT_VIV_VIVIENDA - ACT_LCO_LOCAL_COMERCIAL - ACT_APR_PLAZA_APARCAMIENTO
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


V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_USUARIO VARCHAR2(50 CHAR) := 'TRASPASO_TANGO';
TABLE_COUNT NUMBER(10,0) := 0;
TABLE_COUNT2 NUMBER(10,0) := 0;
TABLE_COUNT3 NUMBER(10,0) := 0;
TABLE_COUNT4 NUMBER(10,0) := 0;



V_TABLA VARCHAR2(40 CHAR) := 'ACT_ICO_INFO_COMERCIAL';
V_TABLA3 VARCHAR2(40 CHAR) := 'ACT_EDI_EDIFICIO';
V_TABLA4 VARCHAR2(40 CHAR) := 'ACT_VIV_VIVIENDA';
V_TABLA5 VARCHAR2(40 CHAR) := 'ACT_LCO_LOCAL_COMERCIAL';
V_TABLA6 VARCHAR2(40 CHAR) := 'ACT_APR_PLAZA_APARCAMIENTO';

V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG_AIA_INFCOMERCIAL_ACT';
V_SENTENCIA VARCHAR2(1600 CHAR);
V_SENTENCIA2 VARCHAR2(1600 CHAR);
V_SENTENCIA3 VARCHAR2(1600 CHAR);
V_SENTENCIA4 VARCHAR2(1600 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
  
  

--Llenamos la primera tabla ACT_ICO_INFO_COMERCIAL
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN ACT_ICO_INFO_COMERCIAL...');

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
    ICO_ID,
    ACT_ID,
    DD_UAC_ID,
    DD_ECT_ID,
    DD_ECV_ID,
    DD_TIC_ID,
    DD_DIS_ID,
    ICO_MEDIADOR_ID,
    ICO_DESCRIPCION,
    ICO_ANO_CONSTRUCCION,
    ICO_ANO_REHABILITACION,
    ICO_APTO_PUBLICIDAD,
    ICO_ACTIVOS_VINC,
    ICO_FECHA_EMISION_INFORME,
    ICO_FECHA_ULTIMA_VISITA,
    ICO_FECHA_ACEPTACION,
    ICO_FECHA_RECHAZO,
    ICO_FECHA_RECEP_LLAVES,
    ICO_CONDICIONES_LEGALES,
    ICO_JUSTIFICACION_VENTA,
    ICO_JUSTIFICACION_RENTA,
    DD_TPA_ID,
    DD_SAC_ID,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
  )
  SELECT 
    '||V_ESQUEMA||'.S_ACT_ICO_INFO_COMERCIAL.NEXTVAL                                            ICO_ID,
    ACT.ACT_ID                                                            ACT_ID,
    (SELECT DD_UAC_ID
      FROM '||V_ESQUEMA||'.DD_UAC_UBICACION_ACTIVO UAC
      WHERE UAC.DD_UAC_CODIGO = MIG.UBICACION_ACTIVO)             DD_UAC_ID,
    (SELECT DD_ECT_ID
      FROM '||V_ESQUEMA||'.DD_ECT_ESTADO_CONSTRUCCION ECT
      WHERE ECT.DD_ECT_CODIGO = MIG.ESTADO_CONSTRUCCION)     DD_ECT_ID,     
    (SELECT DD_ECV_ID
      FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION ECV
      WHERE ECV.DD_ECV_CODIGO = MIG.ESTADO_CONSERVACION)      DD_ECV_ID,     
    (SELECT DD_TIC_ID
      FROM '||V_ESQUEMA||'.DD_TIC_TIPO_INFO_COMERCIAL TIC
      WHERE TIC.DD_TIC_CODIGO = MIG.TIPO_INFO_COMERCIAL)          DD_TIC_ID,
    (SELECT DIS.DD_DIS_ID
      FROM '||V_ESQUEMA||'.DD_DIS_DISTRITO DIS
      WHERE DIS.DD_DIS_CODIGO = MIG.ICO_DISTRITO)                 DD_DIS_ID, 
    (SELECT PVE.PVE_ID
      FROM '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE
      WHERE PVE.PVE_COD_UVEM = MIG.PVE_CODIGO AND ROWNUM=1)                        ICO_MEDIADOR_ID,
    MIG.ICO_DESCRIPCION                                                                  ICO_DESCRIPCION,
    MIG.ICO_ANO_CONSTRUCCION                                                     ICO_ANO_CONSTRUCCION,
    MIG.ICO_ANO_REHABILITACION                                                  ICO_ANO_REHABILITACION,
    MIG.ICO_APTO_PUBLICIDAD                                                         ICO_APTO_PUBLICIDAD,
    MIG.ICO_ACTIVOS_VINC                                                              ICO_ACTIVOS_VINC,
    MIG.ICO_FECHA_EMISION_INFORME                                            ICO_FECHA_EMISION_INFORME,
    MIG.ICO_FECHA_ULTIMA_VISITA                                                  ICO_FECHA_ULTIMA_VISITA,
    MIG.ICO_FECHA_ACEPTACION                                                      ICO_FECHA_ACEPTACION,
    MIG.ICO_FECHA_RECHAZO                                                            ICO_FECHA_RECHAZO,
    MIG.ICO_FECHA_RECEPCION_LLAVES                          ICO_FECHA_RECEP_LLAVES,
    MIG.ICO_CONDICIONES_LEGALES                                                  ICO_CONDICIONES_LEGALES,
    MIG.ICO_JUSTIFICANTE_IMP_VENTA                          ICO_JUSTIFICACION_VENTA,
    MIG.ICO_JUSTIFICANTE_IMP_ALQUILER                       ICO_JUSTIFICACION_RENTA,
    ACT.DD_TPA_ID,
    ACT.DD_SAC_ID,
    ''0''                                                                                                     VERSION,
    '''||V_USUARIO||'''                                                                   USUARIOCREAR,
    SYSDATE                                                                                     FECHACREAR,
    0                                                                                                   BORRADO
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
      INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    WHERE MIG.VALIDACION IN (0,1) AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' T1 WHERE T1.ACT_ID = ACT.ACT_ID AND T1.BORRADO = ACT.BORRADO)
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

  --

  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO ACT_ICO_INFO_COMERCIAL ICO_FECHA_EMISION_INFORME PARA ACEPTADOS...');

  EXECUTE IMMEDIATE ('UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL SET ICO_FECHA_EMISION_INFORME = ICO_FECHA_ACEPTACION WHERE ICO_FECHA_EMISION_INFORME IS NULL AND ICO_FECHA_ACEPTACION IS NOT NULL');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL actualizado. '||SQL%ROWCOUNT||' Filas.'); 
  
  --

  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO ACT_ICO_INFO_COMERCIAL ICO_FECHA_EMISION_INFORME PARA RECHAZADOS...');

  EXECUTE IMMEDIATE ('UPDATE '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL SET ICO_FECHA_EMISION_INFORME = ICO_FECHA_RECHAZO WHERE ICO_FECHA_EMISION_INFORME IS NULL AND ICO_FECHA_RECHAZO IS NOT NULL');
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL actualizado. '||SQL%ROWCOUNT||' Filas.'); 
  
  --

  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN ACT_HIC_EST_INF_COMER_HIST...');

  EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST 
    (
      HIC_ID
      ,ACT_ID
      ,DD_AIC_ID
      ,HIC_FECHA
      ,HIC_MOTIVO
      ,VERSION
      ,USUARIOCREAR
      ,FECHACREAR
      ,BORRADO
    )
    SELECT 
      '||V_ESQUEMA||'.S_ACT_HIC_EST_INF_COMER_HIST.NEXTVAL
      , ACT.ACT_ID
      , CASE
          WHEN ICO.ICO_FECHA_EMISION_INFORME IS NOT NULL AND ICO_FECHA_ACEPTACION IS NULL AND ICO_FECHA_RECHAZO IS NULL
            THEN (SELECT DD_AIC_ID FROM DD_AIC_ACCION_INF_COMERCIAL WHERE DD_AIC_CODIGO = ''03'')
          WHEN ICO_FECHA_ACEPTACION IS NOT NULL AND ICO_FECHA_RECHAZO IS NULL
            THEN (SELECT DD_AIC_ID FROM DD_AIC_ACCION_INF_COMERCIAL WHERE DD_AIC_CODIGO = ''02'')
          WHEN ICO_FECHA_ACEPTACION IS NULL AND ICO_FECHA_RECHAZO IS NOT NULL
            THEN (SELECT DD_AIC_ID FROM DD_AIC_ACCION_INF_COMERCIAL WHERE DD_AIC_CODIGO = ''04'')
        END                  AS DD_AIC_ID
      , SYSDATE              AS HIC_FECHA
      , NULL                 AS HIC_MOTIVO
      , ''0''                AS VERSION
      , '''||V_USUARIO||'''  AS USUARIOCREAR
      , SYSDATE              AS FECHACREAR
      , 0                    AS BORRADO
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
    INNER JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
    INNER JOIN '||V_ESQUEMA||'.MIG_ACA_CABECERA ACA ON ACA.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
    WHERE ICO.ICO_FECHA_EMISION_INFORME IS NOT NULL AND ACA.VALIDACION IN (1,0) AND ACT.BORRADO = 0
  '
  )
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST cargada. '||SQL%ROWCOUNT||' Filas.'); 
 
--Llenamos la tercera tabla ACT_EDI_EDIFICIO
  DBMS_OUTPUT.PUT_LINE('[INFO] INSERTANDO EN ACT_EDI_EDIFICIO...');

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA3||' (
  EDI_ID,
  ICO_ID,
  DD_ECV_ID,
  DD_TPF_ID,
  EDI_ANO_REHABILITACION,
  EDI_NUM_PLANTAS,
  EDI_ASCENSOR,
  EDI_NUM_ASCENSORES,
  EDI_REFORMA_FACHADA,
  EDI_REFORMA_ESCALERA,
  EDI_REFORMA_PORTAL,
  EDI_REFORMA_ASCENSOR,
  EDI_REFORMA_CUBIERTA,
  EDI_REFORMA_OTRA_ZONA,
  EDI_REFORMA_OTRO,
  EDI_REFORMA_OTRO_DESC,
  EDI_DESCRIPCION,
  EDI_ENTORNO_INFRAESTRUCTURA,
  EDI_ENTORNO_COMUNICACION,
  VERSION,
  USUARIOCREAR,
  FECHACREAR,
  BORRADO
  )
  WITH ACT_NUM_ACTIVO AS (
    SELECT DISTINCT 
      MIGW.ACT_NUMERO_ACTIVO,
      MIGW.ESTADO_CONSERVACION_EDIFICIO,
      MIGW.TIPO_FACHADA_EDIFICIO,
      MIGW.ICO_ANYO_REHABILITA_EDIFICIO,
      MIGW.EDI_NUM_PLANTAS,
      MIGW.EDI_ASCENSOR,
      MIGW.EDI_NUM_ASCENSORES,
      MIGW.EDI_REFORMA_FACHADA,
      MIGW.EDI_REFORMA_ESCALERA,
      MIGW.EDI_REFORMA_PORTAL,
      MIGW.EDI_REFORMA_ASCENSOR,
      MIGW.EDI_REFORMA_CUBIERTA,
      MIGW.EDI_REFORMA_OTRA_ZONA,
      MIGW.EDI_REFORMA_OTRO,
      MIGW.EDI_REFORMA_OTRO_DESC,
      MIGW.EDI_DESCRIPCION,
      MIGW.EDI_ENTORNO_INFRAESTRUCTURA,
      MIGW.EDI_ENTORNO_COMUNICACION
    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACTW ON ACTW.ACT_NUM_ACTIVO = MIGW.ACT_NUMERO_ACTIVO
    INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICOW ON ICOW.ACT_ID = ACTW.ACT_ID
  WHERE MIGW.VALIDACION IN (0,1)
  )
  SELECT
  '||V_ESQUEMA||'.S_ACT_EDI_EDIFICIO.NEXTVAL                                                                          EDI_ID,
    (SELECT AC.ICO_ID
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT, '||V_ESQUEMA||'.'||V_TABLA||' AC
    WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    )                                                                                                                    ICO_ID,
    (SELECT ECV.DD_ECV_ID
    FROM '||V_ESQUEMA||'.DD_ECV_ESTADO_CONSERVACION ECV
    WHERE ECV.DD_ECV_CODIGO = MIG.ESTADO_CONSERVACION_EDIFICIO)            DD_ECV_ID,  
    (SELECT TPF.DD_TPF_ID
    FROM '||V_ESQUEMA||'.DD_TPF_TIPO_FACHADA TPF
    WHERE TPF.DD_TPF_CODIGO = MIG.TIPO_FACHADA_EDIFICIO)                            DD_TPF_ID,    
    MIG.ICO_ANYO_REHABILITA_EDIFICIO                                                                          EDI_ANO_REHABILITACION,
    MIG.EDI_NUM_PLANTAS                                                                                       EDI_NUM_PLANTAS,
    MIG.EDI_ASCENSOR                                                                                          EDI_ASCENSOR,
    MIG.EDI_NUM_ASCENSORES                                                                              EDI_NUM_ASCENSORES,
    MIG.EDI_REFORMA_FACHADA                                                                           EDI_REFORMA_FACHADA,
    MIG.EDI_REFORMA_ESCALERA                                                                            EDI_REFORMA_ESCALERA,
    MIG.EDI_REFORMA_PORTAL                                                                              EDI_REFORMA_PORTAL,
    MIG.EDI_REFORMA_ASCENSOR                                                                          EDI_REFORMA_ASCENSOR,
    MIG.EDI_REFORMA_CUBIERTA                                                                          EDI_REFORMA_CUBIERTA,
    MIG.EDI_REFORMA_OTRA_ZONA                                                                     EDI_REFORMA_OTRA_ZONA,
    MIG.EDI_REFORMA_OTRO                                                                                EDI_REFORMA_OTRO,
    MIG.EDI_REFORMA_OTRO_DESC                                                                     EDI_REFORMA_OTRO_DESC,
    MIG.EDI_DESCRIPCION                                                                                   EDI_DESCRIPCION,
    MIG.EDI_ENTORNO_INFRAESTRUCTURA                                                          EDI_ENTORNO_INFRAESTRUCTURA,
    MIG.EDI_ENTORNO_COMUNICACION                                                            EDI_ENTORNO_COMUNICACION,
    ''0''                                                                                                             VERSION,
    '''||V_USUARIO||'''                                                                                           USUARIOCREAR,
    SYSDATE                                                                                                 FECHACREAR,
    0                                                                                                               BORRADO
  FROM ACT_NUM_ACTIVO MIG
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA3||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
--Llenamos la cuarta tabla ACT_VIV_VIVIENDA

---Validamos que el Subtipo Activo es de Vivienda

  V_SENTENCIA2 := '
  SELECT COUNT(DISTINCT MIG.ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
    ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
  WHERE SAC.DD_SAC_CODIGO IN  (''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''20'')
  AND MIG.VALIDACION IN (0,1)
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA2 INTO TABLE_COUNT2;
  
  IF TABLE_COUNT2 > 0 THEN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO VIVIENDAS EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA4||'.');

  EXECUTE IMMEDIATE ('
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA4||' (
    ICO_ID,
    DD_TPV_ID,
    DD_TPO_ID,
    DD_TPR_ID,
    VIV_ULTIMA_PLANTA,
    VIV_NUM_PLANTAS_INTERIOR,
    VIV_REFORMA_CARP_INT,
    VIV_REFORMA_CARP_EXT,
    VIV_REFORMA_COCINA,
    VIV_REFORMA_BANYO,
    VIV_REFORMA_SUELO,
    VIV_REFORMA_PINTURA,
    VIV_REFORMA_INTEGRAL,
    VIV_REFORMA_OTRO,
    VIV_REFORMA_OTRO_DESC,
    VIV_REFORMA_PRESUPUESTO,
    VIV_DISTRIBUCION_TXT
    )
    WITH ACT_NUM_ACTIVO AS (
      SELECT DISTINCT MIGW.ACT_NUMERO_ACTIVO,
        MIGW.TIPO_VIVIENDA,
        MIGW.TIPO_ORIENTACION,
        MIGW.TIPO_RENTA,
        MIGW.VIV_ULTIMA_PLANTA,
        MIGW.VIV_NUM_PLANTAS_INTERIOR,
        MIGW.VIV_REFORMA_CARP_INT,
        MIGW.VIV_REFORMA_CARP_EXT,
        MIGW.VIV_REFORMA_COCINA,
        MIGW.VIV_REFORMA_BANYO,
        MIGW.VIV_REFORMA_SUELO,
        MIGW.VIV_REFORMA_PINTURA,
        MIGW.VIV_REFORMA_INTEGRAL,
        MIGW.VIV_REFORMA_OTRO,
        MIGW.VIV_REFORMA_OTRO_DESC,
        MIGW.VIV_REFORMA_PRESUPUESTO,
        MIGW.VIV_DISTRIBUCION_TXT
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
      INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACTW
        ON ACTW.ACT_NUM_ACTIVO = MIGW.ACT_NUMERO_ACTIVO
      INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICOW
        ON ICOW.ACT_ID = ACTW.ACT_ID
      INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
        ON  SAC.DD_SAC_ID = ACTW.DD_SAC_ID
      AND SAC.DD_SAC_CODIGO IN (''05'',''06'',''07'',''08'',''09'',''10'',''11'',''12'',''20'')     
    WHERE MIGW.VALIDACION IN (0,1)
    )
    SELECT
    (SELECT AC.ICO_ID
      FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
      '||V_ESQUEMA||'.'||V_TABLA||' AC
      WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    )                                                                                                           ICO_ID,  
    (SELECT DD_TPV_ID
      FROM '||V_ESQUEMA||'.DD_TPV_TIPO_VIVIENDA TPV
      WHERE TPV.DD_TPV_CODIGO = MIG.TIPO_VIVIENDA)                           DD_TPV_ID,     
    (SELECT DD_TPO_ID
      FROM '||V_ESQUEMA||'.DD_TPO_TIPO_ORIENTACION TPO
      WHERE TPO.DD_TPO_CODIGO = MIG.TIPO_ORIENTACION)                    DD_TPO_ID, 
    (SELECT DD_TPR_ID
      FROM '||V_ESQUEMA||'.DD_TPR_TIPO_RENTA TPR
      WHERE TPR.DD_TPR_CODIGO = MIG.TIPO_RENTA)                               DD_TPR_ID, 
    MIG.VIV_ULTIMA_PLANTA                                                                        VIV_ULTIMA_PLANTA,
    MIG.VIV_NUM_PLANTAS_INTERIOR                                                          VIV_NUM_PLANTAS_INTERIOR,
    MIG.VIV_REFORMA_CARP_INT                                                                  VIV_REFORMA_CARP_INT,
    MIG.VIV_REFORMA_CARP_EXT                                                                VIV_REFORMA_CARP_EXT,
    MIG.VIV_REFORMA_COCINA                                                                    VIV_REFORMA_COCINA,
    MIG.VIV_REFORMA_BANYO                                                                      VIV_REFORMA_BANYO,
    MIG.VIV_REFORMA_SUELO                                                                     VIV_REFORMA_SUELO,
    MIG.VIV_REFORMA_PINTURA                                                                 VIV_REFORMA_PINTURA,
    MIG.VIV_REFORMA_INTEGRAL                                                                VIV_REFORMA_INTEGRAL,
    MIG.VIV_REFORMA_OTRO                                                                      VIV_REFORMA_OTRO,
    MIG.VIV_REFORMA_OTRO_DESC                                                              VIV_REFORMA_OTRO_DESC,
    MIG.VIV_REFORMA_PRESUPUESTO                                                           VIV_REFORMA_PRESUPUESTO,
    MIG.VIV_DISTRIBUCION_TXT                                                                    VIV_DISTRIBUCION_TXT
    FROM ACT_NUM_ACTIVO MIG
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA4||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
    
  -- Actualizamos el campo DD_TIC_ID de los ICO que son VIVIENDA
  EXECUTE IMMEDIATE ('
    UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO
    SET DD_TIC_ID = 1
    WHERE EXISTS  (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA4||' VIV 
    WHERE ICO.ICO_ID = VIV.ICO_ID)
    ')
    ;
    

END IF;

  --Llenamos la quinta tabla ACT_LCO_LOCAL_COMERCIAL
  
  
  ---Validamos que el Subtipo Activo es de Local Comercial

  V_SENTENCIA3 := '
  SELECT COUNT(DISTINCT MIG.ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
    ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
  WHERE SAC.DD_SAC_CODIGO IN  (''13'',''14'',''15'',''16'')
  AND MIG.VALIDACION IN (0,1)
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA3 INTO TABLE_COUNT3;
  
  IF TABLE_COUNT3 > 0 THEN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO LOCALES COMERCIALES EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA5||'.');

  EXECUTE IMMEDIATE ('
  INSERT INTO '||V_ESQUEMA||'.'||V_TABLA5||' (
  ICO_ID,
  LCO_MTS_FACHADA_PPAL,
  LCO_MTS_FACHADA_LAT,
  LCO_MTS_LUZ_LIBRE,
  LCO_MTS_ALTURA_LIBRE,
  LCO_MTS_LINEALES_PROF,
  LCO_DIAFANO,
  LCO_USO_IDONEO,
  LCO_USO_ANTERIOR,
  LCO_OBSERVACIONES
  )
  WITH ACT_NUM_ACTIVO AS (
      SELECT DISTINCT 
    MIGW.ACT_NUMERO_ACTIVO,
        MIGW.LCO_MTS_FACHADA_PPAL,
        MIGW.LCO_MTS_FACHADA_LAT,
        MIGW.LCO_MTS_LUZ_LIBRE,
        MIGW.LCO_MTS_ALTURA_LIBRE,
        MIGW.LCO_MTS_LINEALES_PROF,
        MIGW.LCO_DIAFANO,
        MIGW.LCO_USO_IDONEO,
        MIGW.LCO_USO_ANTERIOR,
        MIGW.VIV_DISTRIBUCION_TXT
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
      INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACTW
        ON ACTW.ACT_NUM_ACTIVO = MIGW.ACT_NUMERO_ACTIVO
      INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICOW
        ON ICOW.ACT_ID = ACTW.ACT_ID
      INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
        ON  SAC.DD_SAC_ID = ACTW.DD_SAC_ID
      AND SAC.DD_SAC_CODIGO IN  (''13'',''14'',''15'',''16'')
    WHERE MIGW.VALIDACION IN (0,1)
  )
  SELECT
  (SELECT AC.ICO_ID
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.'||V_TABLA||' AC
    WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    )                                                                                                       ICO_ID,
    MIG.LCO_MTS_FACHADA_PPAL                                                            LCO_MTS_FACHADA_PPAL,
    MIG.LCO_MTS_FACHADA_LAT                                                              LCO_MTS_FACHADA_LAT,
    MIG.LCO_MTS_LUZ_LIBRE                                                                     LCO_MTS_LUZ_LIBRE,
    MIG.LCO_MTS_ALTURA_LIBRE                                                              LCO_MTS_ALTURA_LIBRE, 
    MIG.LCO_MTS_LINEALES_PROF                                                             LCO_MTS_LINEALES_PROF,
    MIG.LCO_DIAFANO                                                                             LCO_DIAFANO,
    MIG.LCO_USO_IDONEO                                                                        LCO_USO_IDONEO,
    MIG.LCO_USO_ANTERIOR                                                                    LCO_USO_ANTERIOR,
    SUBSTR(MIG.VIV_DISTRIBUCION_TXT,1,512)                                                                   LCO_OBSERVACIONES
    FROM ACT_NUM_ACTIVO MIG
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA5||' cargada. '||SQL%ROWCOUNT||' Filas.');

  
    -- Actualizamos el campo DD_TIC_ID de los ICO que son LOCAL_COMERCIAL
  EXECUTE IMMEDIATE ('
    UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO
    SET DD_TIC_ID = 2
    WHERE EXISTS  (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA5||' LOC 
    WHERE ICO.ICO_ID = LOC.ICO_ID)
    ')
    ;
    
  
  END IF;

--Llenamos la sexta tabla ACT_APR_PLAZA_APARCAMIENTO

---Validamos que el Subtipo Activo es de Plaza de Aparcamiento
--- 19, 24 y 26??

  V_SENTENCIA4 := '
SELECT COUNT(DISTINCT MIG.ACT_NUMERO_ACTIVO) 
  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
  INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT
    ON ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
  INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
    ON SAC.DD_SAC_ID = ACT.DD_SAC_ID
  WHERE SAC.DD_SAC_CODIGO IN  (''19'',''24'',''26'')
  AND MIG.VALIDACION IN (0,1)
  '
  ;
  
  EXECUTE IMMEDIATE V_SENTENCIA4 INTO TABLE_COUNT4;
  
  IF TABLE_COUNT4 > 0 THEN
  
  DBMS_OUTPUT.PUT_LINE('[INFO] CARGANDO PLAZAS DE APARCAMIENTO EN LA TABLA '||V_ESQUEMA||'.'||V_TABLA6||'.');

  EXECUTE IMMEDIATE ('
INSERT INTO '||V_ESQUEMA||'.'||V_TABLA6||' (
  ICO_ID,
  APR_DESTINO_COCHE,
  APR_DESTINO_MOTO,
  APR_DESTINO_DOBLE,
  DD_TUA_ID,
  DD_TCA_ID,
  APR_ANCHURA,
  APR_PROFUNDIDAD,
  APR_FORMA_IRREGULAR
  )
  WITH ACT_NUM_ACTIVO AS (
      SELECT DISTINCT 
    MIGW.ACT_NUMERO_ACTIVO,
        MIGW.APR_DESTINO_COCHE,
        MIGW.APR_DESTINO_MOTO,
        MIGW.APR_DESTINO_DOBLE,
        MIGW.TIPO_UBICACION_APARCA,
        MIGW.TIPO_CALIDAD,
        MIGW.APR_ANCHURA,
        MIGW.APR_PROFUNDIDAD,
        MIGW.APR_FORMA_IRREGULAR
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIGW
      INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACTW
        ON ACTW.ACT_NUM_ACTIVO = MIGW.ACT_NUMERO_ACTIVO
      INNER JOIN '||V_ESQUEMA||'.'||V_TABLA||' ICOW
        ON ICOW.ACT_ID = ACTW.ACT_ID
      INNER JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC
        ON  SAC.DD_SAC_ID = ACTW.DD_SAC_ID
      AND SAC.DD_SAC_CODIGO IN  (''19'',''24'',''26'')
  WHERE MIGW.VALIDACION IN (0,1)
  )
  SELECT
  (SELECT AC.ICO_ID
    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT,
    '||V_ESQUEMA||'.'||V_TABLA||' AC
    WHERE ACT.ACT_NUM_ACTIVO = MIG.ACT_NUMERO_ACTIVO
    AND AC.ACT_ID = ACT.ACT_ID
    )                                                                                                 ICO_ID,
    MIG.APR_DESTINO_COCHE                                                           APR_DESTINO_COCHE,
    MIG.APR_DESTINO_MOTO                                                            APR_DESTINO_MOTO,
    MIG.APR_DESTINO_DOBLE                                                           APR_DESTINO_DOBLE,
    (SELECT DD_TUA_ID
    FROM '||V_ESQUEMA||'.DD_TUA_TIPO_UBICA_APARCA TUA
    WHERE TUA.DD_TUA_CODIGO = MIG.TIPO_UBICACION_APARCA)  DD_TUA_ID, 
    (SELECT DD_TCA_ID
    FROM '||V_ESQUEMA||'.DD_TCA_TIPO_CALIDAD TCA
    WHERE TCA.DD_TCA_CODIGO = MIG.TIPO_CALIDAD)                  DD_TCA_ID, 
    MIG.APR_ANCHURA                                                                   APR_ANCHURA,
    MIG.APR_PROFUNDIDAD                                                             APR_PROFUNDIDAD,
    MIG.APR_FORMA_IRREGULAR                                                     APR_FORMA_IRREGULAR
    FROM ACT_NUM_ACTIVO MIG
  ')
  ;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA6||' cargada. '||SQL%ROWCOUNT||' Filas.');
  
  
    -- Actualizamos el campo DD_TIC_ID de los ICO que son PLAZA_APARCAMIENTO
  EXECUTE IMMEDIATE ('
    UPDATE '||V_ESQUEMA||'.'||V_TABLA||' ICO
    SET DD_TIC_ID = 3
    WHERE EXISTS  (
    SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA6||' APR 
    WHERE ICO.ICO_ID = APR.ICO_ID)
    ')
    ;

  END IF;

  COMMIT;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA3||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''ACT_HIC_EST_INF_COMER_HIST'',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA6||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA5||''',''10''); END;';
  EXECUTE IMMEDIATE V_SENTENCIA;

  V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA4||''',''10''); END;';
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
  
