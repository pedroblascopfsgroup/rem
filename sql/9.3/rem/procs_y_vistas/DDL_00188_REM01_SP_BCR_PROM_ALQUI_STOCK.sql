--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18692
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18692] - Alejandra García
--##        0.2 Eliminar campo AGA_FECHA_ESCRITURACION al insertar en la ACT_AGA_AGRUPACION_ACTIVO - [HREOS-18692] - Alejandra García
--##        0.3 Modificar el ROW_NUMBER del 7.2 y las consultas de cuando no viene el AM o la UA - [HREOS-18692] - Alejandra García
--##        0.4 Cambio de cálculo de comprobación de PAs creadas
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;                  



CREATE OR REPLACE PROCEDURE SP_BCR_PROM_ALQUI_STOCK
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

--1º TRUNCADO Y RELLENO DE TABLA AUX_BCR_PROM_ALQUI_STOCK PARA VER QUÉ ACTIVOS TIENEN AM NUEVOS Y EXISTENTES, PARA CREARLAS NUEVAS PROM ALQ
DBMS_OUTPUT.PUT_LINE('[INFO] SE TRUNCA LA TABLA AUX_BCR_PROM_ALQUI_STOCK'); 

   V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK';
	EXECUTE IMMEDIATE V_MSQL;



DBMS_OUTPUT.PUT_LINE('[INFO] 1.1 RELLENAR TABLA AUX_BCR_PROM_ALQUI_STOCK');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 1.1 RELLENAR TABLA AUX_BCR_PROM_ALQUI_STOCK'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK T1
               USING (   
                     SELECT
                           AUX.NUM_IDENTIFICATIVO
                           ,AUX.NUM_UNIDAD
                           ,AUX.NUM_INMUEBLE
                     FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                     WHERE AUX.NUM_UNIDAD IS NOT NULL
               ) T2 ON(T1.NUM_IDENTIFICATIVO = T2.NUM_IDENTIFICATIVO)
               WHEN NOT MATCHED THEN 
                  INSERT(
                        NUM_IDENTIFICATIVO
                     , NUM_UNIDAD
                     , NUM_INMUEBLE
                  )VALUES(
                        T2.NUM_IDENTIFICATIVO
                     , T2.NUM_UNIDAD
                     , T2.NUM_INMUEBLE
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN AUX_BCR_PROM_ALQUI_STOCK');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN AUX_BCR_PROM_ALQUI_STOCK: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 1.2 RELLENAR EL CAMPO PROMOCIÓN_NUEVA EN FUNCIÓN DE SI EXISTE O NO LA PROM');  
SALIDA := SALIDA ||'[INFO] 1.2 RELLENAR EL CAMPO PROMOCIÓN_NUEVA EN FUNCIÓN DE SI EXISTE O NO LA PROM'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AUX.NUM_UNIDAD
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  )
                  SELECT 
                     DISTINCT AM.NUM_UNIDAD 
                     ,CASE
                           WHEN AGR.AGR_ID IS NOT NULL AND TAG.DD_TAG_CODIGO = ''16'' AND AGR.AGR_FECHA_BAJA IS NULL AND AGA.AGA_PRINCIPAL = 1 THEN 0
                           ELSE 1
                        END PROMOCION_NUEVA
                  FROM ACTIVOS_MATRIZ AM
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_UNIDAD
                     AND ACT.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                     AND AGA.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                     AND AGR.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                     AND TAG.BORRADO = 0
               ) T2 ON (T1.NUM_UNIDAD = T2.NUM_UNIDAD)
               WHEN MATCHED THEN UPDATE SET
                  T1.PROMOCION_NUEVA = T2.PROMOCION_NUEVA';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN AUX_BCR_PROM_ALQUI_STOCK');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN AUX_BCR_PROM_ALQUI_STOCK: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 1.3 SE RELLENA EL CAMPO AGR_ID PARA LAS PROMOCIONES NUEVAS'); 
SALIDA := SALIDA ||'[INFO] 1.3 SE RELLENA EL CAMPO AGR_ID PARA LAS PROMOCIONES NUEVAS'||CHR(10);
   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK T1 
               USING (
                  WITH SECUENCIA AS(
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO
                        ,ROW_NUMBER() OVER(PARTITION BY AUX.NUM_UNIDAD ORDER BY AUX.NUM_IDENTIFICATIVO DESC NULLS LAST) RN
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                     WHERE AUX.PROMOCION_NUEVA = 1
                  ) 
                  SELECT
                        SEC.NUM_IDENTIFICATIVO
                  FROM SECUENCIA SEC
                  WHERE SEC.RN = 1
               ) T2 ON (T1.NUM_IDENTIFICATIVO = T2.NUM_IDENTIFICATIVO)
               WHEN MATCHED THEN UPDATE SET
                  T1.AGR_ID = S_ACT_AGR_AGRUPACION.NEXTVAL';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN AUX_BCR_PROM_ALQUI_STOCK');
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN AUX_BCR_PROM_ALQUI_STOCK: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK T1 
               USING (
                  SELECT 
                        AUX.NUM_UNIDAD
                     ,AUX.AGR_ID
                  FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  WHERE AUX.PROMOCION_NUEVA = 1
                  AND AUX.AGR_ID IS NOT NULL
               ) T2 ON (T1.NUM_UNIDAD = T2.NUM_UNIDAD)
               WHEN MATCHED THEN UPDATE SET
                  T1.AGR_ID = T2.AGR_ID
               WHERE T1.AGR_ID IS NULL';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN AUX_BCR_PROM_ALQUI_STOCK');
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN AUX_BCR_PROM_ALQUI_STOCK: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

--2º TRUNCADO Y RELLENO DE LA TABLA AUX_AM_NO_VIENE_STOCK ACTIVOS MATRIZ Y SUS UAs QUE NO VIENE POR STOCK (LOS AMs)
DBMS_OUTPUT.PUT_LINE('[INFO] SE TRUNCA LA TABLA AUX_AM_NO_VIENE_STOCK'); 

   V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_AM_NO_VIENE_STOCK';
	EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] 2.1 SE RELLLENA LA TABLA AUX_AM_NO_VIENE_STOCK');  
SALIDA := SALIDA ||'[INFO] 2.1 SE RELLLENA LA TABLA AUX_AM_NO_VIENE_STOCK'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_AM_NO_VIENE_STOCK T1 
               USING (   
                     WITH ACTIVOS_MATRIZ_EXISTENTES_STOCK AS (
                           SELECT DISTINCT
                              AUX.NUM_UNIDAD
                              ,ACT.ACT_ID
                              ,AGA.AGA_ID
                              ,AGR.AGR_ID
                           FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                           JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_UNIDAD
                              AND ACT.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID 
                              AND AGA.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                              AND AGR.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                              AND TAG.BORRADO = 0
                           WHERE AUX.PROMOCION_NUEVA = 0
                           AND TAG.DD_TAG_CODIGO = ''16''
                           AND AGR.AGR_FECHA_BAJA IS NULL
                     ), PROM_ALQUI_EXISTENTES AS (
                           SELECT 
                              ACT.ACT_ID
                              ,ACT.ACT_NUM_ACTIVO_CAIXA 
                              ,AGA.AGA_ID
                              ,AGR.AGR_ID
                           FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR    
                           JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID 
                              AND AGA.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID
                              AND ACT.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                              AND TAG.BORRADO = 0
                           WHERE AGR.BORRADO = 0
                           AND TAG.DD_TAG_CODIGO = ''16''
                           AND AGR.AGR_FECHA_BAJA IS NULL
                     )
                     SELECT
                           PROM.ACT_NUM_ACTIVO_CAIXA
                           ,PROM.ACT_ID
                           ,PROM.AGA_ID
                           ,PROM.AGR_ID
                     FROM PROM_ALQUI_EXISTENTES PROM
                     LEFT JOIN ACTIVOS_MATRIZ_EXISTENTES_STOCK STOCK ON STOCK.AGR_ID = PROM.AGR_ID
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = PROM.ACT_ID 
                           AND ACT.BORRADO = 0 
                     LEFT JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_IDENTIFICATIVO = ACT.ACT_NUM_ACTIVO_CAIXA 
                     LEFT JOIN '||V_ESQUEMA||'.AUX_STOCK_REGISTRO REGISTRO ON REGISTRO.ACT_ID = PROM.ACT_ID
                     WHERE (STOCK.AGR_ID IS NULL AND TRUNC(REGISTRO.ULT_FECHA) + 5 <= TRUNC(SYSDATE))
                     OR (TO_DATE(AUX.FEC_VALIDO_A, ''yyyyMMdd'') IS NOT NULL AND STOCK.AGR_ID IS NOT NULL)
               ) T2 ON(T1.ACT_ID = T2.ACT_ID)
               WHEN NOT MATCHED THEN 
                  INSERT(
                        ACT_NUM_ACTIVO_CAIXA
                     ,ACT_ID
                     ,AGA_ID
                     ,AGR_ID
                  )VALUES(
                        T2.ACT_NUM_ACTIVO_CAIXA
                     , T2.ACT_ID
                     , T2.AGA_ID
                     , T2.AGR_ID
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN AUX_AM_NO_VIENE_STOCK'); 
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN AUX_AM_NO_VIENE_STOCK: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--3º DAR DE BAJA AGRUPACIONES Y ACTIVOS DE TODOS LOS AMs Y SUS UAs QUE NO VENGAN POR STOCK (LAS AMs)
DBMS_OUTPUT.PUT_LINE('[INFO] 3.1 SACAR DE PERÍMETRO Y PONER CHCEKS A 0 DE TODOS LOS AMs Y SUS UAs QUE NO VENGAN POR STOCK');  
SALIDA := SALIDA ||'[INFO] 3.1 SACAR DE PERÍMETRO Y PONER CHCEKS A 0 DE TODOS LOS AMs Y SUS UAs QUE NO VENGAN POR STOCK'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1 
               USING (
                  SELECT DISTINCT
                     AGA.ACT_ID
                  FROM '||V_ESQUEMA||'.AUX_AM_NO_VIENE_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AUX.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.PAC_INCLUIDO = 0
                  ,T1.PAC_CHECK_TRA_ADMISION = 0
                  ,T1.PAC_FECHA_TRA_ADMISION = SYSDATE
                  ,T1.PAC_MOTIVO_TRA_ADMISION = ''El Activo Matriz ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_GESTIONAR = 0
                  ,T1.PAC_FECHA_GESTIONAR = SYSDATE
                  ,T1.PAC_MOTIVO_GESTIONAR = ''El Activo Matriz ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_ASIGNAR_MEDIADOR = 0
                  ,T1.PAC_FECHA_ASIGNAR_MEDIADOR = SYSDATE
                  ,T1.PAC_MOTIVO_ASIGNAR_MEDIADOR = ''El Activo Matriz ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_COMERCIALIZAR = 0
                  ,T1.PAC_FECHA_COMERCIALIZAR = SYSDATE
                  ,T1.PAC_CHECK_FORMALIZAR = 0
                  ,T1.PAC_FECHA_FORMALIZAR = SYSDATE
                  ,T1.PAC_MOTIVO_FORMALIZAR = ''El Activo Matriz ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.USUARIOMODIFICAR = ''SP_BCR_PROM_ALQUI_STOCK''
                  ,T1.FECHAMODIFICAR = SYSDATE
                  ,T1.PAC_CHECK_PUBLICAR = 0
                  ,T1.PAC_FECHA_PUBLICAR = SYSDATE
                  ,T1.PAC_MOTIVO_PUBLICAR = ''El Activo Matriz ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_ADMISION = 0
                  ,T1.PAC_FECHA_ADMISION = SYSDATE
                  ,T1.PAC_MOTIVO_ADMISION = ''El Activo Matriz ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_GESTION_COMERCIAL = 0
                  ,T1.PAC_FECHA_GESTION_COMERCIAL = SYSDATE
                  ,T1.PAC_MOTIVO_GESTION_COMERCIAL = (SELECT DD_MGC_ID FROM '||V_ESQUEMA||'.DD_MGC_MOTIVO_GEST_COMERCIAL WHERE DD_MGC_CODIGO = ''04'')
                  ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_PAC_PERIMETRO_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_PAC_PERIMETRO_ACTIVO '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

/*DBMS_OUTPUT.PUT_LINE('[INFO] 3.2 BORRADOS LÓGICOS EN LA ACT_AGA_AGRUPACION_ACTIVO DE ESOS ACTIVOS');  
SALIDA := SALIDA ||'[INFO] 3.2 BORRADOS LÓGICOS EN LA ACT_AGA_AGRUPACION_ACTIVO DE ESOS ACTIVOS'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 
               USING (
                  SELECT DISTINCT
                     AUX.AGA_ID
                  FROM '||V_ESQUEMA||'.AUX_AM_NO_VIENE_STOCK AUX
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN MATCHED THEN UPDATE SET
                   T1.BORRADO = 1
                  ,T1.USUARIOBORRAR  = ''SP_BCR_PROM_ALQUI_STOCK''
                  ,T1.FECHABORRAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS BORRADOS LÓGICAMENTE EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS BORRADOS LÓGICAMENTE EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);*/

DBMS_OUTPUT.PUT_LINE('[INFO] 3.2 DAR DE BAJA LAS AGRUPACIONES DE ESOS ACTIVOS ');  
SALIDA := SALIDA ||'[INFO] 3.2 DAR DE BAJA LAS AGRUPACIONES DE ESOS ACTIVOS'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T1 
               USING (
                  SELECT DISTINCT
                     AUX.AGR_ID
                  FROM '||V_ESQUEMA||'.AUX_AM_NO_VIENE_STOCK AUX
               ) T2 ON (T1.AGR_ID = T2.AGR_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.AGR_FECHA_BAJA = SYSDATE
                  ,T1.USUARIOMODIFICAR  = ''SP_BCR_PROM_ALQUI_STOCK''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS DADOS DE BAJA EN ACT_AGR_AGRUPACION'); 
SALIDA := SALIDA || '   [INFO] REGISTROS DADOS DE BAJA EN ACT_AGR_AGRUPACION: '|| SQL%ROWCOUNT|| CHR(10); 
SALIDA := SALIDA ||' '||CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

--4º TRUNCADO Y RELLENO DE TABLA AUX_UA_NO_VIENE_STOCK PARA VER QUÉ UAs DEJAN DE VENIR POR STOCK Y ASÍ PODER QUITARLOS DE LA AGRUPACIÓN 
DBMS_OUTPUT.PUT_LINE('[INFO] SE TRUNCA LA TABLA AUX_UA_NO_VIENE_STOCK'); 

   V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_UA_NO_VIENE_STOCK';
	EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] 4.1  RELLENAR TABLA AUX_UA_NO_VIENE_STOCK');  
SALIDA := SALIDA ||'[INFO] 4.1  RELLENAR TABLA AUX_UA_NO_VIENE_STOCK'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_UA_NO_VIENE_STOCK T1 
               USING (   
                     WITH UAS_EXISTENTES_STOCK AS (
                           SELECT 
                              AUX.NUM_IDENTIFICATIVO
                              ,ACT.ACT_ID
                              ,AGA.AGA_ID
                              ,AGR.AGR_ID
                           FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                           JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                              AND ACT.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID 
                              AND AGA.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                              AND AGR.BORRADO = 0
                           WHERE AUX.PROMOCION_NUEVA = 0
                     ), PROM_ALQUI_EXISTENTES AS (
                           SELECT 
                              ACT.ACT_ID
                              ,ACT.ACT_NUM_ACTIVO_CAIXA 
                              ,AGA.AGA_ID
                              ,AGR.AGR_ID
                           FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR    
                           JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID 
                              AND AGA.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID
                              AND ACT.BORRADO = 0
                           JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                              AND TAG.BORRADO = 0
                           WHERE AGR.BORRADO = 0
                           AND TAG.DD_TAG_CODIGO = ''16''
                           AND AGR.AGR_FECHA_BAJA IS NULL  
                           AND AGA.AGA_PRINCIPAL = 0
                     )
                     SELECT
                           PROM.ACT_NUM_ACTIVO_CAIXA
                           ,PROM.ACT_ID
                           ,PROM.AGA_ID
                           ,PROM.AGR_ID
                     FROM PROM_ALQUI_EXISTENTES PROM
                     LEFT JOIN UAS_EXISTENTES_STOCK STOCK ON STOCK.ACT_ID = PROM.ACT_ID
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = PROM.ACT_ID 
                           AND ACT.BORRADO = 0 
                     LEFT JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_IDENTIFICATIVO = ACT.ACT_NUM_ACTIVO_CAIXA 
                     LEFT JOIN '||V_ESQUEMA||'.AUX_STOCK_REGISTRO REGISTRO ON REGISTRO.ACT_ID = PROM.ACT_ID
                     WHERE (STOCK.ACT_ID IS NULL AND TRUNC(REGISTRO.ULT_FECHA) + 5 <= TRUNC(SYSDATE))
                     OR (TO_DATE(AUX.FEC_VALIDO_A, ''yyyyMMdd'') IS NOT NULL AND AUX.NUM_UNIDAD IS NOT NULL AND STOCK.AGR_ID IS NOT NULL)
               ) T2 ON(T1.ACT_ID = T2.ACT_ID)
               WHEN NOT MATCHED THEN 
                  INSERT(
                        ACT_NUM_ACTIVO_CAIXA
                     ,ACT_ID
                     ,AGA_ID
                     ,AGR_ID
                  )VALUES(
                        T2.ACT_NUM_ACTIVO_CAIXA
                     , T2.ACT_ID
                     , T2.AGA_ID
                     , T2.AGR_ID
                  )';
   EXECUTE IMMEDIATE V_MSQL;


DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN AUX_UA_NO_VIENE_STOCK');   
SALIDA := SALIDA || '   [INFO]  REGISTROS INSERTADOS EN AUX_UA_NO_VIENE_STOCK: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--5º DAR DE BAJA AGRUPACIONES Y ACTIVOS DE TODOS LAS UAs QUE NO VENGAN POR STOCK
DBMS_OUTPUT.PUT_LINE('[INFO] 5.1 SACAR DE PERÍMETRO Y PONER CHCEKS A 0 DE TODOS LAS UAs QUE NO VENGAN POR STOCK');  
SALIDA := SALIDA ||'[INFO] 5.1 SACAR DE PERÍMETRO Y PONER CHCEKS A 0 DE TODOS LAS UAs QUE NO VENGAN POR STOC'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1 
               USING (
                  SELECT DISTINCT
                     AUX.ACT_ID
                  FROM '||V_ESQUEMA||'.AUX_UA_NO_VIENE_STOCK AUX
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.PAC_INCLUIDO = 0
                  ,T1.PAC_CHECK_TRA_ADMISION = 0
                  ,T1.PAC_FECHA_TRA_ADMISION = SYSDATE
                  ,T1.PAC_MOTIVO_TRA_ADMISION = ''La Unidad Alquilable ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_GESTIONAR = 0
                  ,T1.PAC_FECHA_GESTIONAR = SYSDATE
                  ,T1.PAC_MOTIVO_GESTIONAR = ''La Unidad Alquilable ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_ASIGNAR_MEDIADOR = 0
                  ,T1.PAC_FECHA_ASIGNAR_MEDIADOR = SYSDATE
                  ,T1.PAC_MOTIVO_ASIGNAR_MEDIADOR = ''La Unidad Alquilable ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_COMERCIALIZAR = 0
                  ,T1.PAC_FECHA_COMERCIALIZAR = SYSDATE
                  ,T1.PAC_CHECK_FORMALIZAR = 0
                  ,T1.PAC_FECHA_FORMALIZAR = SYSDATE
                  ,T1.PAC_MOTIVO_FORMALIZAR = ''La Unidad Alquilable ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.USUARIOMODIFICAR = ''SP_BCR_PROM_ALQUI_STOCK''
                  ,T1.FECHAMODIFICAR = SYSDATE
                  ,T1.PAC_CHECK_PUBLICAR = 0
                  ,T1.PAC_FECHA_PUBLICAR = SYSDATE
                  ,T1.PAC_MOTIVO_PUBLICAR = ''La Unidad Alquilable ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_ADMISION = 0
                  ,T1.PAC_FECHA_ADMISION = SYSDATE
                  ,T1.PAC_MOTIVO_ADMISION = ''La Unidad Alquilable ha sido dado de baja/ha dejado de venir por stock''
                  ,T1.PAC_CHECK_GESTION_COMERCIAL = 0
                  ,T1.PAC_FECHA_GESTION_COMERCIAL = SYSDATE
                  ,T1.PAC_MOTIVO_GESTION_COMERCIAL =  (SELECT DD_MGC_ID FROM '||V_ESQUEMA||'.DD_MGC_MOTIVO_GEST_COMERCIAL WHERE DD_MGC_CODIGO = ''04'')
                  ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_PAC_PERIMETRO_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_PAC_PERIMETRO_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

/*DBMS_OUTPUT.PUT_LINE('[INFO] 5.2 BORRADOS LÓGICOS EN LA ACT_AGA_AGRUPACION_ACTIVO DE ESOS ACTIVOS'); 
SALIDA := SALIDA ||'[INFO] 5.2 BORRADOS LÓGICOS EN LA ACT_AGA_AGRUPACION_ACTIVO DE ESOS ACTIVOS'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 
               USING (
                  SELECT DISTINCT
                     AUX.AGA_ID
                  FROM '||V_ESQUEMA||'.AUX_UA_NO_VIENE_STOCK AUX
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.BORRADO = 1
                  ,T1.USUARIOBORRAR  = ''SP_BCR_PROM_ALQUI_STOCK''
                  ,T1.FECHABORRAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS BORRADOS LÓGICAMENTE EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS BORRADOS LÓGICAMENTE EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);*/

DBMS_OUTPUT.PUT_LINE('[INFO] 5.2 CALCULAR LAS PARTICIPACIONES DE LAS UAs CUANDO ALGUNA DE ELLAS SE HA BORRADO'); 
SALIDA := SALIDA ||'[INFO] 5.2 CALCULAR LAS PARTICIPACIONES DE LAS UAs CUANDO ALGUNA DE ELLAS SE HA BORRADO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 
               USING (
                  WITH AGRUP AS (
                     SELECT DISTINCT
                           AUX.AGR_ID
                     FROM '||V_ESQUEMA||'.AUX_UA_NO_VIENE_STOCK AUX
                  ),CANTIDAD_AGRUP AS (
                     SELECT
                           AGA.AGR_ID
                           ,COUNT(*) TOTAL
                     FROM AGRUP AGRU
                     JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGRU.AGR_ID
                           AND AGA.BORRADO = 0
                     GROUP BY AGA.AGR_ID
                  ), PORCENTAJE_UAS AS (
                     SELECT
                           AGA.AGR_ID
                           ,AGA.AGA_ID
                           ,CANT.TOTAL
                           ,ROUND(100 / CANT.TOTAL, 2) TODOS_EXCEPTO_ULTIMO
                           ,100 - ((ROUND(100 / CANT.TOTAL, 2)) * (CANT.TOTAL - 1)) ULTIMO
                           ,ROW_NUMBER() OVER(PARTITION BY AGA.AGR_ID ORDER BY AGA.ACT_ID DESC NULLS LAST) RN
                     FROM CANTIDAD_AGRUP CANT
                     JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = CANT.AGR_ID
                           AND AGA.BORRADO = 0
                  )
                  SELECT 
                      AGA.ACT_ID
                     ,AGA.AGR_ID   
                     ,AGA.AGA_ID 
                     ,CASE
                           WHEN  PORC.RN <> PORC.TOTAL THEN PORC.TODOS_EXCEPTO_ULTIMO
                           ELSE PORC.ULTIMO
                        END AS ACT_AGA_PARTICIPACION_UA
                  FROM PORCENTAJE_UAS PORC
                  JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGA_ID = PORC.AGA_ID 
                     AND AGA.BORRADO = 0
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.ACT_AGA_PARTICIPACION_UA = T2.ACT_AGA_PARTICIPACION_UA
                  ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

--6º PROMOCIONES ALQUILER NUEVAS
DBMS_OUTPUT.PUT_LINE('[INFO] 6.1 DAR DE ALTA NUEVA AGRUPACIONES EN LA ACT_AGR_AGRUPACION'); 
SALIDA := SALIDA ||'[INFO] 6.1 DAR DE ALTA NUEVA AGRUPACIONES EN LA ACT_AGR_AGRUPACION'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGR_AGRUPACION T1 
               USING (
                  SELECT DISTINCT
                        AUX.AGR_ID 
                     ,AUX.NUM_UNIDAD ACT_NUM_ACTIVO_CAIXA
                     ,ACT.ACT_ID
                     ,STOCK.CALLE
                  FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_UNIDAD
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK STOCK ON STOCK.NUM_IDENTIFICATIVO = AUX.NUM_UNIDAD
                  WHERE AUX.PROMOCION_NUEVA = 1
               ) T2 ON (T1.AGR_ID = T2.AGR_ID)
               WHEN NOT MATCHED THEN 
                  INSERT( 
                        AGR_ID
                     ,DD_TAG_ID
                     ,AGR_NOMBRE 
                     ,AGR_DESCRIPCION 
                     ,AGR_NUM_AGRUP_REM 
                     ,AGR_FECHA_ALTA 
                     ,AGR_ACT_PRINCIPAL 
                     ,VERSION
                     ,USUARIOCREAR
                     ,FECHACREAR
                     ,BORRADO
                     ,AGR_INI_VIGENCIA 
                     ,AGR_NUM_AGRUP_BC 
                  )VALUES(
                        T2.AGR_ID
                        ,(SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'')
                        ,T2.CALLE 
                        ,T2.CALLE 
                        ,S_AGR_NUM_AGRUP_REM.NEXTVAL
                        ,SYSDATE 
                        ,T2.ACT_ID
                        ,0
                        ,''SP_BCR_PROM_ALQUI_STOCK''
                        ,SYSDATE
                        ,0
                        ,SYSDATE
                        ,T2.ACT_NUM_ACTIVO_CAIXA
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_AGR_AGRUPACION');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN ACT_AGR_AGRUPACION: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 6.2 DAR DE ALTA LAS NUEVAS AGRUPACIONES CON LOS AM NUEVOS EN LA ACT_AGA_AGRUPACION_ACTIVO'); 
SALIDA := SALIDA ||'[INFO] 6.2 DAR DE ALTA LAS NUEVAS AGRUPACIONES CON LOS AM NUEVOS EN LA ACT_AGA_AGRUPACION_ACTIVO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1
               USING (
                  SELECT DISTINCT
                        ACT.ACT_ID
                     ,AUX.AGR_ID  
                     ,AGA.AGA_ID
                  FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_UNIDAD
                     AND ACT.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.AGR_ID = AUX.AGR_ID
                     AND AGA.BORRADO = 0
                  WHERE AUX.PROMOCION_NUEVA = 1
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN NOT MATCHED THEN 
                  INSERT( 
                        AGA_ID
                     ,AGR_ID
                     ,ACT_ID
                     ,AGA_FECHA_INCLUSION
                     ,AGA_PRINCIPAL
                     ,VERSION
                     ,USUARIOCREAR
                     ,FECHACREAR
                     ,BORRADO
                     ,ACT_AGA_PARTICIPACION_UA
                     ,ACT_AGA_ID_PRINEX_HPM
                     ,PISO_PILOTO
                  )VALUES(
                        S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL
                        ,T2.AGR_ID
                        ,T2.ACT_ID
                        ,SYSDATE
                        ,1
                        ,0
                        ,''SP_BCR_PROM_ALQUI_STOCK''
                        ,SYSDATE
                        ,0
                        ,0 
                        ,NULL
                        ,0
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 6.3 DAR DE ALTA LAS NUEVAS AGRUPACIONES CON LAS UAs NUEVAS EN LA ACT_AGA_AGRUPACION_ACTIVO'); 
SALIDA := SALIDA ||'[INFO] 6.3 DAR DE ALTA LAS NUEVAS AGRUPACIONES CON LAS UAs NUEVAS EN LA ACT_AGA_AGRUPACION_ACTIVO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 
               USING (
                  SELECT 
                        ACT.ACT_ID
                     ,AUX.AGR_ID   
                     ,AGA.AGA_ID      
                  FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.AGR_ID = AUX.AGR_ID
                     AND AGA.BORRADO = 0
                  WHERE AUX.PROMOCION_NUEVA = 1
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN NOT MATCHED THEN 
                  INSERT( 
                        AGA_ID
                     ,AGR_ID
                     ,ACT_ID
                     ,AGA_FECHA_INCLUSION
                     ,AGA_PRINCIPAL
                     ,VERSION
                     ,USUARIOCREAR
                     ,FECHACREAR
                     ,BORRADO
                     ,ACT_AGA_PARTICIPACION_UA
                     ,ACT_AGA_ID_PRINEX_HPM
                     ,PISO_PILOTO
                  )VALUES(
                        S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL
                        ,T2.AGR_ID
                        ,T2.ACT_ID
                        ,SYSDATE
                        ,0
                        ,0
                        ,''SP_BCR_PROM_ALQUI_STOCK''
                        ,SYSDATE
                        ,0
                        ,NULL 
                        ,NULL
                        ,0
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 6.4 CALCULAR LAS PARTICIPACIONES DE LA UAs DEL AM NUEVO'); 
SALIDA := SALIDA ||'[INFO] 6.4 CALCULAR LAS PARTICIPACIONES DE LA UAs DEL AM NUEVO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 
               USING (
                  WITH CANTIDAD_UAS AS (
                     SELECT 
                           AUX.NUM_UNIDAD
                           ,COUNT(*) TOTAL
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                     WHERE AUX.PROMOCION_NUEVA = 1
                     GROUP BY AUX.NUM_UNIDAD
                  ), PORCENTAJE_UAS AS (
                     SELECT
                           AUX.NUM_UNIDAD
                           ,AUX.NUM_IDENTIFICATIVO
                           ,CANT.TOTAL
                           ,ROUND(100 / CANT.TOTAL, 2) TODOS_EXCEPTO_ULTIMO
                           ,100 - ((ROUND(100 / CANT.TOTAL, 2)) * (CANT.TOTAL - 1)) ULTIMO
                           ,ROW_NUMBER() OVER(PARTITION BY AUX.NUM_UNIDAD ORDER BY AUX.NUM_IDENTIFICATIVO DESC NULLS LAST) RN
                     FROM CANTIDAD_UAS CANT
                     JOIN '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX ON AUX.NUM_UNIDAD = CANT.NUM_UNIDAD
                  )
                  SELECT 
                        ACT.ACT_ID
                     ,AGA.AGR_ID   
                     ,AGA.AGA_ID 
                     ,CASE
                           WHEN  PORC.RN <> PORC.TOTAL THEN PORC.TODOS_EXCEPTO_ULTIMO
                           ELSE PORC.ULTIMO
                        END AS ACT_AGA_PARTICIPACION_UA
                  FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID 
                     AND AGA.BORRADO = 0
                  JOIN PORCENTAJE_UAS PORC ON PORC.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO
                  JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                           AND AGR.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                     AND TAG.BORRADO = 0
                  WHERE AUX.PROMOCION_NUEVA = 1
                  AND TAG.DD_TAG_CODIGO = ''16''
                  AND AGR.AGR_FECHA_BAJA IS NULL 
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.ACT_AGA_PARTICIPACION_UA = T2.ACT_AGA_PARTICIPACION_UA
                  ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 6.5 SE INSERTA EL AM EN LA ACT_PAL_PROMOCION_ALQUILER'); 
SALIDA := SALIDA ||'[INFO] 6.5 SE INSERTA EL AM EN LA ACT_PAL_PROMOCION_ALQUILER'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAL_PROMOCION_ALQUILER T1
               USING (
                  SELECT DISTINCT
                        ACT.ACT_ID
                     ,AUX.AGR_ID     
                     ,TO_NUMBER(SUBSTR(STOCK.POBLACION,0 , 2)) DD_PRV_CODIGO
                     ,STOCK.POBLACION DD_LOC_CODIGO
                     ,STOCK.CALLE PAL_DIRECCION
                     ,STOCK.APARTADO PAL_CP
                  FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_UNIDAD
                     AND ACT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK STOCK ON STOCK.NUM_IDENTIFICATIVO = AUX.NUM_UNIDAD
                  WHERE AUX.PROMOCION_NUEVA = 1
               ) T2 ON (T1.AGR_ID = T2.AGR_ID)
               WHEN NOT MATCHED THEN 
                  INSERT( 
                        AGR_ID
                     ,DD_PRV_ID
                     ,DD_LOC_ID
                     ,PAL_DIRECCION
                     ,PAL_CP
                  )VALUES(
                     T2.AGR_ID
                     ,(SELECT DD_PRV_ID FROM REMMASTER.DD_PRV_PROVINCIA WHERE DD_PRV_CODIGO = T2.DD_PRV_CODIGO)
                     ,(SELECT DD_LOC_ID FROM REMMASTER.DD_LOC_LOCALIDAD WHERE DD_LOC_CODIGO = T2.DD_LOC_CODIGO)
                     ,T2.PAL_DIRECCION
                     ,T2.PAL_CP
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_PAL_PROMOCION_ALQUILER');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN ACT_PAL_PROMOCION_ALQUILER: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--7º AÑADIR UAs A UNA PROMOCIÓN ALQUILER EXISTENTE
DBMS_OUTPUT.PUT_LINE('[INFO] 7.1 AÑADIR UAs A UNA PROMOCIÓN ALQUILER EXISTENTE EN LA ACT_AGA_AGRUPACION_ACTIVO'); 
SALIDA := SALIDA ||'[INFO] 7.1 AÑADIR UAs A UNA PROMOCIÓN ALQUILER EXISTENTE EN LA ACT_AGA_AGRUPACION_ACTIVO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 
               USING (
                  WITH ACTIVOS_MATRIZ_EXISTENTES AS (
                     SELECT DISTINCT
                           AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_UNIDAD
                           AND ACT.BORRADO = 0
                     WHERE AUX.PROMOCION_NUEVA = 0
                  ), AGRUP_ACTIVOS_MATRIZ_EXISTENTES AS (
                     SELECT
                           AME.NUM_UNIDAD
                           ,AME.ACT_ID
                           ,AGA.AGA_ID
                           ,AGR.AGR_ID
                     FROM ACTIVOS_MATRIZ_EXISTENTES AME
                     JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = AME.ACT_ID
                           AND AGA.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                           AND AGR.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                           AND TAG.BORRADO = 0
                     WHERE TAG.DD_TAG_CODIGO = ''16''
                     AND AGR.AGR_FECHA_BAJA IS NULL 
                  )
                  SELECT 
                        ACT.ACT_ID
                     ,AAME.AGR_ID   
                     ,AGA.AGA_ID     
                  FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                     AND ACT.BORRADO = 0
                  JOIN AGRUP_ACTIVOS_MATRIZ_EXISTENTES AAME ON AAME.NUM_UNIDAD = AUX.NUM_UNIDAD
                  LEFT JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.AGR_ID = AAME.AGR_ID
                     AND AGA.BORRADO = 0
                  WHERE AUX.PROMOCION_NUEVA = 0
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN NOT MATCHED THEN 
                  INSERT( 
                        AGA_ID
                     ,AGR_ID
                     ,ACT_ID
                     ,AGA_FECHA_INCLUSION
                     ,AGA_PRINCIPAL
                     ,VERSION
                     ,USUARIOCREAR
                     ,FECHACREAR
                     ,BORRADO
                     ,ACT_AGA_PARTICIPACION_UA
                     ,ACT_AGA_ID_PRINEX_HPM
                     ,PISO_PILOTO
                  )VALUES(
                        S_ACT_AGA_AGRUPACION_ACTIVO.NEXTVAL
                        ,T2.AGR_ID
                        ,T2.ACT_ID
                        ,SYSDATE
                        ,0
                        ,0
                        ,''SP_BCR_PROM_ALQUI_STOCK''
                        ,SYSDATE
                        ,0
                        ,NULL 
                        ,NULL
                        ,0
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

DBMS_OUTPUT.PUT_LINE('[INFO] 7.2 CALCULAR LAS PARTICIPACIONES DE LA UAs QUE SE HAN AÑADIDO'); 
SALIDA := SALIDA ||'[INFO] 7.2 CALCULAR LAS PARTICIPACIONES DE LA UAs QUE SE HAN AÑADIDO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO T1 
               USING (
                  WITH UAS_STOCK_NUEVAS AS (
                     SELECT DISTINCT
                           AGA.AGR_ID
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AUX
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID 
                           AND AGA.BORRADO = 0
                     WHERE AUX.PROMOCION_NUEVA = 0
                     AND AGA.USUARIOCREAR = ''SP_BCR_PROM_ALQUI_STOCK''
                     AND TRUNC(AGA.FECHACREAR ) = TRUNC(SYSDATE)
                     AND AGA.AGA_PRINCIPAL = 0
                  ), CANTIDAD_UAS_STOCK AS (
                     SELECT 
                           AGA.AGR_ID
                           ,COUNT(*) TOTAL
                     FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA 
                     JOIN '||V_ESQUEMA||'.UAS_STOCK_NUEVAS UAS ON UAS.AGR_ID = AGA.AGR_ID
                     WHERE AGA.BORRADO = 0
                     AND AGA.AGA_PRINCIPAL = 0
                     GROUP BY AGA.AGR_ID
                  ), PORCENTAJE_UAS AS (
                     SELECT
                           ACT.ACT_ID
                           ,AGA.AGA_ID
                           ,CANT.TOTAL
                           ,ROUND(100 / CANT.TOTAL, 2) TODOS_EXCEPTO_ULTIMO
                           ,100 - ((ROUND(100/ CANT.TOTAL, 2)) * (CANT.TOTAL - 1)) ULTIMO
                           ,ROW_NUMBER() OVER(PARTITION BY AGA.AGR_ID ORDER BY ACT.ACT_ID DESC NULLS LAST) RN
                     FROM CANTIDAD_UAS_STOCK CANT
                     JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = CANT.AGR_ID 
                           AND AGA.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID
                           AND ACT.BORRADO = 0
                     WHERE AGA.AGA_PRINCIPAL = 0
                  )
                  SELECT DISTINCT
                        AGA.ACT_ID
                     ,AGA.AGR_ID   
                     ,AGA.AGA_ID 
                     ,CASE
                           WHEN  PORC.RN <> PORC.TOTAL THEN PORC.TODOS_EXCEPTO_ULTIMO
                           ELSE PORC.ULTIMO
                        END AS ACT_AGA_PARTICIPACION_UA
                  FROM PORCENTAJE_UAS PORC 
                  JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = PORC.ACT_ID 
                     AND AGA.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                           AND AGR.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                     AND TAG.BORRADO = 0
                  WHERE TAG.DD_TAG_CODIGO = ''16''
                  AND AGR.AGR_FECHA_BAJA IS NULL 
               ) T2 ON (T1.AGA_ID = T2.AGA_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.ACT_AGA_PARTICIPACION_UA = T2.ACT_AGA_PARTICIPACION_UA';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN ACT_AGA_AGRUPACION_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_BCR_PROM_ALQUI_STOCK;
/
EXIT;
