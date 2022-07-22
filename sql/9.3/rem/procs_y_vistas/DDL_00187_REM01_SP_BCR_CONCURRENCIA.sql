--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20220721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18426
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18260] - Alejandra García
--##        0.2 Se modifica el formato de fecha y se añade un WITH para sacar la fecha fin de la concurrencia - [HREOS-18426] - Pier Gotta
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;                  



CREATE OR REPLACE PROCEDURE SP_BCR_CONCURRENCIA
   ( FLAG_EN_REM IN NUMBER,
   SALIDA OUT VARCHAR2, 
   COD_RETORNO OUT NUMBER)

   AS

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar
   V_COUNT NUMBER(16);
   V_SUBSTR NUMBER(16);
   V_INCREM NUMBER(16);

   V_NUM_TABLAS NUMBER(16);

BEGIN

DBMS_OUTPUT.PUT_LINE('[INFO] SE TRUNCA LA TABLA AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK'); 

   V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK';
	EXECUTE IMMEDIATE V_MSQL;


--1º CONDICIÓN
DBMS_OUTPUT.PUT_LINE('[INFO] 1º ACTIVOS SIN PERIODOS DE CONCURRENCIA');  
DBMS_OUTPUT.PUT_LINE('[INFO] 1.1 SE CREA UN NUEVO REGISTRO EN LA TABLA CON_CONCURRENCIA');  
DBMS_OUTPUT.PUT_LINE('[INFO] PARA LOS ACTIVOS QUE NO TENGAN REGISTROS EN LA TABLA O CUYOS PERIODOS HAYAN CADUCADO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 1º ACTIVOS SIN PERIODOS DE CONCURRENCIA'||CHR(10);
SALIDA := SALIDA || '[INFO] 1.1 SE CREA UN NUEVO REGISTRO EN LA TABLA CON_CONCURRENCIA'||CHR(10);
SALIDA := SALIDA || '[INFO] PARA LOS ACTIVOS QUE NO TENGAN REGISTROS EN LA TABLA O CUYOS PERIODOS HAYAN CADUCADO'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.CON_CONCURRENCIA (
                  CON_ID
                  ,ACT_ID
                  ,AGR_ID
                  ,CON_IMPORTE_MIN_OFR
                  ,CON_FECHA_INI
                  ,CON_FECHA_FIN
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
               )
               WITH SIN_CONCURRENCIA AS (
                     SELECT 
                           ACT.ACT_ID
                           ,CASE
                              WHEN AGA.ACT_ID IS NOT NULL THEN AGA.AGR_ID
                              ELSE NULL
                           END AGR_ID
                           ,AUX.IMP_PRECIO_VENTA
                           ,TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'') FEC_INICIO_CONCURENCIA
                           ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') FEC_FIN_CONCURENCIA
                     FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                           AND ACT.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                           AND CON.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                           AND AGA.BORRADO = 0
                     WHERE (CON.CON_ID IS NULL
                     OR 
                     TRUNC(CON.CON_FECHA_FIN) <  TRUNC(SYSDATE) )
                     AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  ), CONCURRENCIA_FUTURA AS (
                     SELECT 
                           ACT.ACT_ID
                           ,CASE
                              WHEN AGA.ACT_ID IS NOT NULL THEN AGA.AGR_ID
                              ELSE NULL
                           END AGR_ID
                           ,AUX.IMP_PRECIO_VENTA
                           ,AUX.FEC_INICIO_CONCURENCIA
                           ,AUX.FEC_FIN_CONCURENCIA
                     FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                           AND CON.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                           AND AGA.BORRADO = 0
                     WHERE TRUNC(CON.CON_FECHA_INI) >  TRUNC(SYSDATE)
                     AND TRUNC(CON.FECHACREAR) <> TRUNC(SYSDATE)
                     AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  ), CONCURRENCIA AS (
                     SELECT DISTINCT
                           SIN_CONCU.ACT_ID
                           ,SIN_CONCU.AGR_ID
                           ,SIN_CONCU.IMP_PRECIO_VENTA CON_IMPORTE_MIN_OFR
                           ,SIN_CONCU.FEC_INICIO_CONCURENCIA CON_FECHA_INI
                           ,SIN_CONCU.FEC_FIN_CONCURENCIA CON_FECHA_FIN
                     FROM SIN_CONCURRENCIA SIN_CONCU
                     WHERE NOT EXISTS (SELECT
                                             1   
                                       FROM CONCURRENCIA_FUTURA FUT 
                                       WHERE FUT.ACT_ID = SIN_CONCU.ACT_ID
                                       )
                     AND NOT EXISTS (SELECT
                                             1   
                                       FROM '||V_ESQUEMA||'.CON_CONCURRENCIA CON1
                                       WHERE CON1.ACT_ID = SIN_CONCU.ACT_ID
                                       AND CON1.AGR_ID = SIN_CONCU.AGR_ID
                                       AND CON1.CON_FECHA_INI = SIN_CONCU.FEC_INICIO_CONCURENCIA
                                       AND CON1.CON_FECHA_FIN = SIN_CONCU.FEC_FIN_CONCURENCIA
                                       )
                  )SELECT
                  '||V_ESQUEMA||'.S_CON_CONCURRENCIA.NEXTVAL
                  ,CONCU.ACT_ID
                  ,CONCU.AGR_ID
                  ,CONCU.CON_IMPORTE_MIN_OFR
                  ,CONCU.CON_FECHA_INI
                  ,CONCU.CON_FECHA_FIN
                  ,0 
                  ,''apr_alta_assets_from_caixabank''
                  ,SYSDATE
                  ,0
               FROM CONCURRENCIA CONCU';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN CON_CONCURRENCIA');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN CON_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 1.2 SE CREA UN NUEVO REGISTRO EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA');  
SALIDA := SALIDA ||'[INFO] 1.2 SE CREA UN NUEVO REGISTRO EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA T1
               USING (
                  SELECT
                        CON.CON_ID
                     ,ACO.DD_ACO_ID
                     ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') CPC_FECHA_FIN
                  FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                     AND CON.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_ACO_ACCIONES_CONCURRENCIA ACO ON ACO.DD_ACO_CODIGO = ''01'' 
                     AND ACO.BORRADO = 0
                  WHERE CON.CON_FECHA_INI = AUX.FEC_INICIO_CONCURENCIA
                  AND CON.CON_FECHA_FIN = AUX.FEC_FIN_CONCURENCIA
                  AND TRUNC(CON.FECHACREAR) = TRUNC(SYSDATE)
                  AND CON.USUARIOCREAR = ''apr_alta_assets_from_caixabank''
                  AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) T2 ON (T1.CON_ID = T2.CON_ID AND TRUNC(T1.FECHACREAR) = TRUNC(SYSDATE))
               WHEN NOT MATCHED THEN 
               INSERT(
                  CPC_ID
                  ,CON_ID
                  ,DD_ACO_ID
                  ,CPC_FECHA_FIN
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
               )VALUES(
                  '||V_ESQUEMA||'.S_CPC_CMB_PERIODO_CONCURRENCIA.NEXTVAL
                  ,T2.CON_ID
                  ,T2.DD_ACO_ID
                  ,T2.CPC_FECHA_FIN
                  ,0
                  ,''apr_alta_assets_from_caixabank''
                  ,SYSDATE
                  ,0
               )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);


DBMS_OUTPUT.PUT_LINE('[INFO] 1.3 SE MODIFICA EL REGISTRO EN LA TABLA CON_CONCURRENCIA'); 
DBMS_OUTPUT.PUT_LINE('[INFO] PARA LOS ACTIVOS QUE TENGAN REGISTROS EN LA TABLA CON PERIODOS DE CONCURRENCIA FUTUROS');  
SALIDA := SALIDA ||'[INFO] 1.3 SE MODIFICA EL REGISTRO EN LA TABLA CON_CONCURRENCIA'||CHR(10);
SALIDA := SALIDA ||'[INFO] PARA LOS ACTIVOS QUE TENGAN REGISTROS EN LA TABLA CON PERIODOS DE CONCURRENCIA FUTUROS'||CHR(10);
   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CON_CONCURRENCIA T1
               USING (
                  WITH CONCURRENCIA_FUTURA AS (
                     SELECT 
                           CON.CON_ID
                           ,ACT.ACT_ID
                           ,CASE
                              WHEN AGA.ACT_ID IS NOT NULL THEN AGA.AGR_ID
                              ELSE NULL
                           END AGR_ID
                           ,AUX.IMP_PRECIO_VENTA
                           ,TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'') FEC_INICIO_CONCURENCIA
                           ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') FEC_FIN_CONCURENCIA
                     FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                           AND CON.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                           AND AGA.BORRADO = 0
                     WHERE TRUNC(CON.CON_FECHA_INI) >  TRUNC(SYSDATE)
                     AND TRUNC(CON.FECHACREAR) <> TRUNC(SYSDATE)
                     AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) <> TRUNC(CON.CON_FECHA_INI)
                     AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) <> TRUNC(CON.CON_FECHA_FIN)
                     AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  ), CONCURRENCIA AS (
                     SELECT DISTINCT 
                           FUT.CON_ID
                           ,FUT.ACT_ID
                           ,FUT.AGR_ID
                           ,FUT.IMP_PRECIO_VENTA CON_IMPORTE_MIN_OFR
                           ,FUT.FEC_INICIO_CONCURENCIA CON_FECHA_INI
                           ,FUT.FEC_FIN_CONCURENCIA CON_FECHA_FIN
                     FROM CONCURRENCIA_FUTURA FUT
                     WHERE NOT EXISTS (SELECT
                                             1   
                                       FROM '||V_ESQUEMA||'.CON_CONCURRENCIA CON1
                                       WHERE CON1.ACT_ID = FUT.ACT_ID
                                       AND CON1.AGR_ID = FUT.AGR_ID
                                       AND CON1.CON_FECHA_INI = FUT.FEC_INICIO_CONCURENCIA
                                       AND CON1.CON_FECHA_FIN = FUT.FEC_FIN_CONCURENCIA
                                       )
                  )SELECT
                        CONCU.CON_ID
                     ,CONCU.ACT_ID
                     ,CONCU.AGR_ID
                     ,CONCU.CON_IMPORTE_MIN_OFR
                     ,CONCU.CON_FECHA_INI
                     ,CONCU.CON_FECHA_FIN
                  FROM CONCURRENCIA CONCU

               ) T2 ON (T1.CON_ID = T2.CON_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.CON_FECHA_INI = T2.CON_FECHA_INI
                  , T1.CON_FECHA_FIN = T2.CON_FECHA_FIN
                  , T1.CON_IMPORTE_MIN_OFR = T2.CON_IMPORTE_MIN_OFR
                  , T1.USUARIOMODIFICAR = ''apr_alta_assets_from_caixabank''
                  , T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN CON_CONCURRENCIA');
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN CON_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 1.4 SE CREA MODIFICA LA FECHA FIN EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA');  
SALIDA := SALIDA ||'[INFO] 1.4 SE CREA MODIFICA LA FECHA FIN EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA T1
               USING (
                  WITH CONCURRENCIA_FUTURA AS (
                     SELECT 
                           CON.CON_ID
                           ,CPC.CPC_ID
                           ,ACT.ACT_ID
                           ,CASE
                              WHEN AGA.ACT_ID IS NOT NULL THEN AGA.AGR_ID
                              ELSE NULL
                           END AGR_ID
                           ,AUX.IMP_PRECIO_VENTA
                           ,TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'') FEC_INICIO_CONCURENCIA
                           ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') FEC_FIN_CONCURENCIA
                     FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                           AND CON.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                           AND AGA.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA CPC ON CPC.CON_ID = CON.CON_ID
                           AND CPC.BORRADO = 0
                     WHERE TRUNC(CON.CON_FECHA_INI) >  TRUNC(SYSDATE)
                     AND TRUNC(CON.FECHACREAR) <> TRUNC(SYSDATE)
                     AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_INI)
                     AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_FIN)
                     AND CPC.CPC_FECHA_FIN <> TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')
                     AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  ), CONCURRENCIA AS (
                     SELECT DISTINCT 
                           FUT.CON_ID
                           ,FUT.CPC_ID
                           ,FUT.ACT_ID
                           ,FUT.AGR_ID
                           ,FUT.IMP_PRECIO_VENTA CON_IMPORTE_MIN_OFR
                           ,FUT.FEC_INICIO_CONCURENCIA CON_FECHA_INI
                           ,FUT.FEC_FIN_CONCURENCIA CON_FECHA_FIN
                     FROM CONCURRENCIA_FUTURA FUT
                     WHERE NOT EXISTS (SELECT
                                             1   
                                       FROM '||V_ESQUEMA||'.CON_CONCURRENCIA CON1
                                       WHERE CON1.ACT_ID = FUT.ACT_ID
                                       AND CON1.AGR_ID = FUT.AGR_ID
                                       AND CON1.CON_FECHA_INI = FUT.FEC_INICIO_CONCURENCIA
                                       AND CON1.CON_FECHA_FIN = FUT.FEC_FIN_CONCURENCIA
                                       )
                  )SELECT
                        CONCU.CON_ID
                     ,CONCU.CPC_ID
                     ,CONCU.CON_FECHA_FIN CPC_FECHA_FIN
                  FROM CONCURRENCIA CONCU

               ) T2 ON (T1.CPC_ID = T2.CPC_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.CPC_FECHA_FIN = T2.CPC_FECHA_FIN
                  , T1.USUARIOMODIFICAR = ''apr_alta_assets_from_caixabank''
                  , T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN CPC_CMB_PERIODO_CONCURRENCIA'); 
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN CPC_CMB_PERIODO_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);


--2º CONDICIÓN
DBMS_OUTPUT.PUT_LINE('[INFO] 2º ACTIVOS CON PERIODOS DE CONCURRENCIA VIVO Y FECHA FIN RECIBIDA MAYOR QUE LA EXISTENTE');  
DBMS_OUTPUT.PUT_LINE('[INFO] 2.1 SE CREA UN NUEVO REGISTRO EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA'); 
SALIDA := SALIDA ||'[INFO] 2º ACTIVOS CON PERIODOS DE CONCURRENCIA VIVO Y FECHA FIN RECIBIDA MAYOR QUE LA EXISTENTE'||CHR(10);
SALIDA := SALIDA ||'[INFO] 2.1 SE CREA UN NUEVO REGISTRO EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA'||CHR(10); 

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA T1
               USING (
               WITH ULTIMA_FECHA_FIN AS(
               	SELECT CON_ID, CPC_FECHA_FIN, ROW_NUM FROM (
               	SELECT CON_ID, CPC_FECHA_FIN, ROW_NUMBER() OVER(
       		PARTITION BY CON_ID
        		ORDER BY FECHA_CREAR DESC) ROW_NUM
                	FROM '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA)
                	WHERE ROW_NUM = 1)
                        SELECT
                        CON.CON_ID
                     ,ACO.DD_ACO_ID
                     ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') CPC_FECHA_FIN
                  FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                     AND CON.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_ACO_ACCIONES_CONCURRENCIA ACO ON ACO.DD_ACO_CODIGO = ''02''
                     AND ACO.BORRADO = 0
                  JOIN ULTIMA_FECHA_FIN ULT ON ULT.CON_ID = CON.CON_ID
                  LEFT JOIN '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA CPC ON CPC.CON_ID = CON.CON_ID
                     AND CPC.BORRADO = 0
                  WHERE TRUNC(SYSDATE) BETWEEN TRUNC(CON.CON_FECHA_INI) AND TRUNC(CON.CON_FECHA_FIN)
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) > TRUNC(ULT.CPC_FECHA_FIN) 
                  AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_INI)
                  AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) T2 ON (T1.CON_ID = T2.CON_ID AND TRUNC(T1.FECHACREAR) = TRUNC(SYSDATE))
               WHEN NOT MATCHED THEN 
               INSERT(
                  CPC_ID
                  ,CON_ID
                  ,DD_ACO_ID
                  ,CPC_FECHA_FIN
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
               )VALUES(
                  '||V_ESQUEMA||'.S_CPC_CMB_PERIODO_CONCURRENCIA.NEXTVAL
                  ,T2.CON_ID
                  ,T2.DD_ACO_ID
                  ,T2.CPC_FECHA_FIN
                  ,0
                  ,''apr_alta_assets_from_caixabank''
                  ,SYSDATE
                  ,0
               )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA '|| SQL%ROWCOUNT|| CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 2.2 SE CREA UN NUEVO REGISTRO EN LA TABLA AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK');  
SALIDA := SALIDA ||'[INFO] 2.2 SE CREA UN NUEVO REGISTRO EN LA TABLA AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK T1
               USING (
                  SELECT
                        CON.CON_ID
                     ,ACO.DD_ACO_ID
                     ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') CPC_FECHA_FIN
                  FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                     AND CON.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_ACO_ACCIONES_CONCURRENCIA ACO ON ACO.DD_ACO_CODIGO = ''02'' 
                     AND ACO.BORRADO = 0
                  WHERE TRUNC(SYSDATE) BETWEEN TRUNC(CON.CON_FECHA_INI) AND TRUNC(CON.CON_FECHA_FIN)
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) > TRUNC(CON.CON_FECHA_FIN) 
                  AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_INI)
                  AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) T2 ON ((T1.CON_ID = T2.CON_ID AND T1.DD_ACO_ID = T2.DD_ACO_ID AND TRUNC(T1.FECHACREAR) = TRUNC(SYSDATE))
                           OR
                        (T1.CON_ID = T2.CON_ID AND T1.DD_ACO_ID = T2.DD_ACO_ID AND TRUNC(T1.FECHACREAR) <> TRUNC(SYSDATE)))
               WHEN NOT MATCHED THEN 
               INSERT(
                  CCS_ID
                  ,CON_ID
                  ,DD_ACO_ID
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
               )VALUES(
                  '||V_ESQUEMA||'.S_AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK.NEXTVAL
                  ,T2.CON_ID
                  ,T2.DD_ACO_ID
                  ,0
                  ,''apr_alta_assets_from_caixabank''
                  ,SYSDATE
                  ,0
               )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 2.3 SE MODIFICA REGISTRO EXISTENTE EN LA TABLA CON_CONCURRENCIA');  
SALIDA := SALIDA ||'[INFO] 2.3 SE MODIFICA REGISTRO EXISTENTE EN LA TABLA CON_CONCURRENCIA'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CON_CONCURRENCIA T1
               USING (
                  SELECT
                        CON.CON_ID
                     ,AUX.FEC_FIN_CONCURENCIA
                  FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                     AND CON.BORRADO = 0
                  WHERE TRUNC(SYSDATE) BETWEEN TRUNC(CON.CON_FECHA_INI) AND TRUNC(CON.CON_FECHA_FIN)
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) > TRUNC(CON.CON_FECHA_FIN) 
                  AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_INI) 
                  AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) T2 ON (T1.CON_ID = T2.CON_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.CON_FECHA_FIN = T2.FEC_FIN_CONCURENCIA
                  , T1.USUARIOMODIFICAR = ''apr_alta_assets_from_caixabank''
                  , T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN CON_CONCURRENCIA');  


--3º CONDICIÓN
DBMS_OUTPUT.PUT_LINE('[INFO] 3º  ACTIVOS CON PERIODOS DE CONCURRENCIA VIVO Y FECHA FIN RECIBIDA MENOR QUE LA EXISTENTE E IGUAL A HOY');  
DBMS_OUTPUT.PUT_LINE('[INFO] 3.1 SE CREA UN NUEVO REGISTRO EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA'); 
SALIDA := SALIDA ||'[INFO] 3º  ACTIVOS CON PERIODOS DE CONCURRENCIA VIVO Y FECHA FIN RECIBIDA MENOR QUE LA EXISTENTE E IGUAL A HOY'||CHR(10);
SALIDA := SALIDA ||'[INFO] 3.1 SE CREA UN NUEVO REGISTRO EN LA TABLA CPC_CMB_PERIODO_CONCURRENCIA'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA T1
               USING (
                 WITH ULTIMA_FECHA_FIN AS(
               	SELECT CON_ID, CPC_FECHA_FIN, ROW_NUM FROM (
               	SELECT CON_ID, CPC_FECHA_FIN, ROW_NUMBER() OVER(
       		PARTITION BY CON_ID
        		ORDER BY FECHA_CREAR DESC) ROW_NUM
                	FROM '||V_ESQUEMA||'.CPC_CMB_PERIODO_CONCURRENCIA)
                	WHERE ROW_NUM = 1)
                  SELECT
                        CON.CON_ID
                     ,ACO.DD_ACO_ID
                     ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') CPC_FECHA_FIN
                  FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                     AND CON.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_ACO_ACCIONES_CONCURRENCIA ACO ON ACO.DD_ACO_CODIGO = ''03'' 
                     AND ACO.BORRADO = 0
                  JOIN ULTIMA_FECHA_FIN ULT ON ULT.CON_ID = CON.CON_ID
                  WHERE TRUNC(SYSDATE) BETWEEN TRUNC(CON.CON_FECHA_INI) AND TRUNC(CON.CON_FECHA_FIN)
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) < TRUNC(ULT.CPC_FECHA_FIN) 
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) = TRUNC(SYSDATE) 
                  AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_INI)
                  AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) T2 ON (T1.CON_ID = T2.CON_ID AND TRUNC(T1.FECHACREAR) = TRUNC(SYSDATE))
               WHEN NOT MATCHED THEN 
               INSERT(
                  CPC_ID
                  ,CON_ID
                  ,DD_ACO_ID
                  ,CPC_FECHA_FIN
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
               )VALUES(
                  '||V_ESQUEMA||'.S_CPC_CMB_PERIODO_CONCURRENCIA.NEXTVAL
                  ,T2.CON_ID
                  ,T2.DD_ACO_ID
                  ,T2.CPC_FECHA_FIN
                  ,0
                  ,''apr_alta_assets_from_caixabank''
                  ,SYSDATE
                  ,0
               )';
   EXECUTE IMMEDIATE V_MSQL;


DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA');   
SALIDA := SALIDA || '   [INFO]  REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 3.2 SE CREA UN NUEVO REGISTRO EN LA TABLA AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK');  
SALIDA := SALIDA ||'[INFO] 3.2 SE CREA UN NUEVO REGISTRO EN LA TABLA AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK T1
               USING (
                  SELECT
                        CON.CON_ID
                     ,ACO.DD_ACO_ID
                     ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') CPC_FECHA_FIN
                  FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                     AND CON.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_ACO_ACCIONES_CONCURRENCIA ACO ON ACO.DD_ACO_CODIGO = ''03'' 
                     AND ACO.BORRADO = 0
                  WHERE TRUNC(SYSDATE) BETWEEN TRUNC(CON.CON_FECHA_INI) AND TRUNC(CON.CON_FECHA_FIN)
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) < TRUNC(CON.CON_FECHA_FIN) 
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) = TRUNC(SYSDATE) 
                  AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_INI)
                  AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) T2 ON ((T1.CON_ID = T2.CON_ID AND T1.DD_ACO_ID = T2.DD_ACO_ID AND TRUNC(T1.FECHACREAR) = TRUNC(SYSDATE))
                           OR
                     (T1.CON_ID = T2.CON_ID AND T1.DD_ACO_ID = T2.DD_ACO_ID AND TRUNC(T1.FECHACREAR) <> TRUNC(SYSDATE)))
               WHEN NOT MATCHED THEN 
               INSERT(
                  CCS_ID
                  ,CON_ID
                  ,DD_ACO_ID
                  ,VERSION
                  ,USUARIOCREAR
                  ,FECHACREAR
                  ,BORRADO
               )VALUES(
                  '||V_ESQUEMA||'.S_AUX_CORREOS_CAMBIOS_CONCURRENCIA_STOCK.NEXTVAL
                  ,T2.CON_ID
                  ,T2.DD_ACO_ID
                  ,0
                  ,''apr_alta_assets_from_caixabank''
                  ,SYSDATE
                  ,0
               )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN CPC_CMB_PERIODO_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);


DBMS_OUTPUT.PUT_LINE('[INFO] 3.3 SE MODIFICA REGISTRO EXISTENTE EN LA TABLA CON_CONCURRENCIA'); 
SALIDA := SALIDA ||'[INFO] 3.3 SE MODIFICA REGISTRO EXISTENTE EN LA TABLA CON_CONCURRENCIA'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.CON_CONCURRENCIA T1
               USING (
                  SELECT
                      CON.CON_ID
                     ,TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'') FEC_FIN_CONCURENCIA
                  FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
                     AND CON.BORRADO = 0
                  WHERE TRUNC(SYSDATE) BETWEEN TRUNC(CON.CON_FECHA_INI) AND TRUNC(CON.CON_FECHA_FIN)
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) < TRUNC(CON.CON_FECHA_FIN) 
                  AND TRUNC(TO_DATE(AUX.FEC_FIN_CONCURENCIA, ''yyyymmdd'')) = TRUNC(SYSDATE) 
                  AND TRUNC(TO_DATE(AUX.FEC_INICIO_CONCURENCIA, ''yyyymmdd'')) = TRUNC(CON.CON_FECHA_INI) 
                  AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) T2 ON(T1.CON_ID = T2.CON_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.CON_FECHA_FIN = T2.FEC_FIN_CONCURENCIA
                  , T1.USUARIOMODIFICAR = ''apr_alta_assets_from_caixabank''
                  , T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN CON_CONCURRENCIA');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN CON_CONCURRENCIA: '|| SQL%ROWCOUNT|| CHR(10);

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_BCR_CONCURRENCIA;
/
EXIT;
