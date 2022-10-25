--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20221007
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18793
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18793] - Alejandra García
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;                  



CREATE OR REPLACE PROCEDURE SP_COPIA_DATOS_ACT_MATRIZ
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
--Vamos a utilizar la tabla AUX_BCR_PROM_ALQUI_STOCK del anterior SP -> SP_BCR_PROM_ALQUI_STOCK

--TRUNCADO DE TABLAS:

   V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_GEE_COPIA_DATOS_MATRIZ';  
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('[INFO] SE HA TRUNCADO CORRECTAMENTE LA TABLA AUX_GEE_COPIA_DATOS_MATRIZ');  
   
   V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.AUX_GEH_COPIA_DATOS_MATRIZ';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('[INFO] SE HA TRUNCADO CORRECTAMENTE LA TABLA AUX_GEH_COPIA_DATOS_MATRIZ');  
   
   SALIDA := SALIDA || '   [INFO]  TRUNCADO DE TABLAS CORRECTO';

--1º BIE_BIEN
DBMS_OUTPUT.PUT_LINE('[INFO] 1º BIE_BIEN');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 1º BIE_BIEN'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_BIEN T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), BIEN_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO   
                           ,BIE.DD_TBI_ID
                           ,BIE.BIE_PARTICIPACION
                           ,BIE.BIE_VALOR_ACTUAL
                           ,BIE.BIE_IMPORTE_CARGAS
                           ,BIE.BIE_SUPERFICIE
                           ,BIE.BIE_POBLACION
                           ,BIE.BIE_DATOS_REGISTRALES
                           ,BIE.BIE_REFERENCIA_CATASTRAL
                           ,BIE.BIE_DESCRIPCION
                           ,BIE.BIE_FECHA_VERIFICACION
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.BIE_BIEN BIE ON BIE.BIE_NUMERO_ACTIVO = AM.NUM_IDENTIFICATIVO    
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
                           ,AUX.NUM_UNIDAD
                           ,BAM.NUM_IDENTIFICATIVO 
                           ,BAM.DD_TBI_ID
                           ,BAM.BIE_PARTICIPACION
                           ,BAM.BIE_VALOR_ACTUAL
                           ,BAM.BIE_IMPORTE_CARGAS
                           ,BAM.BIE_SUPERFICIE
                           ,BAM.BIE_POBLACION
                           ,BAM.BIE_DATOS_REGISTRALES
                           ,BAM.BIE_REFERENCIA_CATASTRAL
                           ,BAM.BIE_DESCRIPCION
                           ,BAM.BIE_FECHA_VERIFICACION
                     FROM BIEN_ACTIVO_MATRIZ BAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = BAM.NUM_IDENTIFICATIVO    
               ) T2 ON (T1.BIE_NUMERO_ACTIVO = T2.BIE_NUMERO_ACTIVO)
               WHEN MATCHED THEN UPDATE SET
                  T1.DD_TBI_ID = T2.DD_TBI_ID
                  ,T1.BIE_PARTICIPACION = T2.BIE_PARTICIPACION
                  ,T1.BIE_VALOR_ACTUAL = T2.BIE_VALOR_ACTUAL
                  ,T1.BIE_IMPORTE_CARGAS = T2.BIE_IMPORTE_CARGAS
                  ,T1.BIE_SUPERFICIE = T2.BIE_SUPERFICIE
                  ,T1.BIE_POBLACION = T2.BIE_POBLACION
                  ,T1.BIE_DATOS_REGISTRALES = T2.BIE_DATOS_REGISTRALES
                  ,T1.BIE_REFERENCIA_CATASTRAL = T2.BIE_REFERENCIA_CATASTRAL
                  ,T1.BIE_DESCRIPCION = T2.BIE_DESCRIPCION
                  ,T1.BIE_FECHA_VERIFICACION = T2.BIE_FECHA_VERIFICACION
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE
               ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN BIE_BIEN');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN BIE_BIEN: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

--2º ACT_ACTIVO
DBMS_OUTPUT.PUT_LINE('[INFO] 2º ACT_ACTIVO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 2º ACT_ACTIVO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), ACTIVO_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO   
                           ,ACT.DD_EAC_ID
                           ,ACT.DD_TAL_ID
                           ,ACT.ACT_BLOQUEO_TIPO_COMERCIALIZAR
                           ,ACT.ACT_PORCENTAJE_CONSTRUCCION
                           ,(SELECT DD_TTA_ID FROM '||V_ESQUEMA||'.DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = ''05'') DD_TTA_ID
                           ,(SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''07'') DD_SCM_ID 
                           ,ACT.ACT_NUM_INMOVILIZADO_BNK
                           ,0 ACT_DND 
                           ,(SELECT DD_SIN_ID FROM REMMASTER.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'') ACT_OVN_COMERC
                           ,ACT.CPR_ID
                           ,ACT.ACT_CON_CARGAS
                           ,ACT.ACT_FECHA_REV_CARGAS
                           ,ACT.ACT_VPO
                           ,ACT.DD_TDC_ID
                           ,ACT.ACT_ADMISION
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,AAM.DD_EAC_ID
                           ,AAM.DD_TAL_ID
                           ,AAM.ACT_BLOQUEO_TIPO_COMERCIALIZAR
                           ,AAM.ACT_PORCENTAJE_CONSTRUCCION
                           ,AAM.DD_TTA_ID
                           ,AAM.DD_SCM_ID 
                           ,AAM.ACT_NUM_INMOVILIZADO_BNK
                           ,AAM.ACT_DND 
                           ,AAM.ACT_OVN_COMERC
                           ,AAM.CPR_ID
                           ,AAM.ACT_CON_CARGAS
                           ,AAM.ACT_FECHA_REV_CARGAS
                           ,AAM.ACT_VPO
                           ,AAM.DD_TDC_ID
                           ,AAM.ACT_ADMISION
                     FROM ACTIVO_ACTIVO_MATRIZ AAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = AAM.NUM_IDENTIFICATIVO    
               ) T2 ON (T1.ACT_NUM_ACTIVO_CAIXA = T2.ACT_NUM_ACTIVO_CAIXA)
               WHEN MATCHED THEN UPDATE SET
                  T1.DD_EAC_ID = T2.DD_EAC_ID
                  ,T1.DD_TAL_ID = T2.DD_TAL_ID
                  ,T1.ACT_BLOQUEO_TIPO_COMERCIALIZAR = T2.ACT_BLOQUEO_TIPO_COMERCIALIZAR
                  ,T1.ACT_PORCENTAJE_CONSTRUCCION = T2.ACT_PORCENTAJE_CONSTRUCCION
                  ,T1.DD_TTA_ID = T2.DD_TTA_ID
                  ,T1.DD_SCM_ID  = T2.DD_SCM_ID
                  ,T1.ACT_NUM_INMOVILIZADO_BNK = T2.ACT_NUM_INMOVILIZADO_BNK
                  ,T1.ACT_DND = T2. ACT_DND
                  ,T1.ACT_OVN_COMERC = T2.ACT_OVN_COMERC
                  ,T1.CPR_ID = T2.CPR_ID
                  ,T1.ACT_CON_CARGAS = T2.ACT_CON_CARGAS
                  ,T1.ACT_FECHA_REV_CARGAS = T2.ACT_FECHA_REV_CARGAS
                  ,T1.ACT_VPO = T2.ACT_VPO
                  ,T1.DD_TDC_ID = T2.DD_TDC_ID
                  ,T1.ACT_ADMISION = T2.ACT_ADMISION
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--3º ACT_PTA_PATRIMONIO_ACTIVO
DBMS_OUTPUT.PUT_LINE('[INFO] 3º ACT_PTA_PATRIMONIO_ACTIVO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 3º ACT_PTA_PATRIMONIO_ACTIVO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), PTA_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,PTA.ACT_ID
                           ,PTA.DD_ADA_ID
                           ,PTA.DD_ADA_ID_ANTERIOR
                           ,PTA.CHECK_SUBROGADO
                           ,PTA.PTA_RENTA_ANTIGUA
                           ,PTA.DD_EAL_ID
                           ,PTA.DD_TPI_ID
                           ,1 CHECK_HPM
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID    
                           AND PTA.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                           ,PAM.DD_ADA_ID
                           ,PAM.DD_ADA_ID_ANTERIOR
                           ,PAM.CHECK_SUBROGADO
                           ,PAM.PTA_RENTA_ANTIGUA
                           ,PAM.DD_EAL_ID
                           ,PAM.DD_TPI_ID
                           ,PAM.CHECK_HPM
                     FROM PTA_ACTIVO_MATRIZ PAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = PAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0 
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.DD_ADA_ID = T2.DD_ADA_ID
                  ,T1.DD_ADA_ID_ANTERIOR = T2.DD_ADA_ID_ANTERIOR
                  ,T1.CHECK_SUBROGADO = T2.CHECK_SUBROGADO
                  ,T1.PTA_RENTA_ANTIGUA = T2.PTA_RENTA_ANTIGUA
                  ,T1.DD_EAL_ID = T2.DD_EAL_ID
                  ,T1.DD_TPI_ID = T2.DD_TPI_ID
                  ,T1.CHECK_HPM = T2.CHECK_HPM
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE
               WHEN NOT MATCHED THEN 
                  INSERT(
                        ACT_PTA_ID
                     ,ACT_ID
                     ,DD_ADA_ID
                     ,DD_ADA_ID_ANTERIOR
                     ,CHECK_SUBROGADO
                     ,PTA_RENTA_ANTIGUA
                     ,DD_EAL_ID
                     ,DD_TPI_ID
                     ,CHECK_HPM
                     ,VERSION
                     ,USUARIOCREAR
                     ,FECHACREAR
                     ,BORRADO
                  )VALUES(
                      '||V_ESQUEMA||'.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL
                     ,T2.ACT_ID
                     ,T2.DD_ADA_ID
                     ,T2.DD_ADA_ID_ANTERIOR
                     ,T2.CHECK_SUBROGADO
                     ,T2.PTA_RENTA_ANTIGUA
                     ,T2.DD_EAL_ID
                     ,T2.DD_TPI_ID
                     ,T2.CHECK_HPM
                     ,0
                     ,''SP_COPIA_DATOS_ACT_MATRIZ''
                     ,SYSDATE
                     ,0
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS/INSERTADOS EN ACT_PTA_PATRIMONIO_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS/INSERTADOS EN ACT_PTA_PATRIMONIO_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--4º ACT_APU_ACTIVO_PUBLICACION
DBMS_OUTPUT.PUT_LINE('[INFO] 4º ACT_APU_ACTIVO_PUBLICACION');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 4º ACT_APU_ACTIVO_PUBLICACION'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), APU_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,APU.ACT_ID
                           ,(SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''01'') DD_EPA_ID
                           ,(SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''01'') DD_EPV_ID
                           ,(SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''03'') DD_TCO_ID
                           ,0 APU_CHECK_OCULTAR_A
                           ,0 APU_CHECK_OCULTAR_PRECIO_A
                           ,0 APU_CHECK_OCULTAR_PRECIO_V
                           ,0 APU_CHECK_OCULTAR_V
                           ,0 APU_CHECK_PUBLICAR_A
                           ,0 APU_CHECK_PUBLICAR_V
                           ,0 APU_CHECK_PUB_SIN_PRECIO_A
                           ,0 APU_CHECK_PUB_SIN_PRECIO_V
                           ,SYSDATE APU_FECHA_INI_ALQUILER
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID    
                           AND APU.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                           ,AAM.DD_EPA_ID
                           ,AAM.DD_EPV_ID
                           ,AAM.DD_TCO_ID
                           ,AAM.APU_CHECK_OCULTAR_A
                           ,AAM.APU_CHECK_OCULTAR_PRECIO_A
                           ,AAM.APU_CHECK_OCULTAR_PRECIO_V
                           ,AAM.APU_CHECK_OCULTAR_V
                           ,AAM.APU_CHECK_PUBLICAR_A
                           ,AAM.APU_CHECK_PUBLICAR_V
                           ,AAM.APU_CHECK_PUB_SIN_PRECIO_A
                           ,AAM.APU_CHECK_PUB_SIN_PRECIO_V
                           ,AAM.APU_FECHA_INI_ALQUILER
                     FROM APU_ACTIVO_MATRIZ AAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = AAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0  
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.DD_EPA_ID = T2.DD_EPA_ID
                  ,T1.DD_EPV_ID = T2.DD_EPV_ID
                  ,T1.DD_TCO_ID = T2.DD_TCO_ID
                  ,T1.APU_CHECK_OCULTAR_A = T2.APU_CHECK_OCULTAR_A
                  ,T1.APU_CHECK_OCULTAR_PRECIO_A = T2.APU_CHECK_OCULTAR_PRECIO_A
                  ,T1.APU_CHECK_OCULTAR_PRECIO_V = T2.APU_CHECK_OCULTAR_PRECIO_V
                  ,T1.APU_CHECK_OCULTAR_V = T2.APU_CHECK_OCULTAR_V
                  ,T1.APU_CHECK_PUBLICAR_A = T2.APU_CHECK_PUBLICAR_A
                  ,T1.APU_CHECK_PUBLICAR_V = T2.APU_CHECK_PUBLICAR_V
                  ,T1.APU_CHECK_PUB_SIN_PRECIO_A = T2.APU_CHECK_PUB_SIN_PRECIO_A
                  ,T1.APU_CHECK_PUB_SIN_PRECIO_V = T2.APU_CHECK_PUB_SIN_PRECIO_V
                  ,T1.APU_FECHA_INI_ALQUILER = T2.APU_FECHA_INI_ALQUILER
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE
               WHEN NOT MATCHED THEN 
                  INSERT(
                      APU_ID
                     ,ACT_ID
                     ,DD_EPA_ID
                     ,DD_EPV_ID
                     ,DD_TCO_ID
                     ,APU_CHECK_OCULTAR_A
                     ,APU_CHECK_OCULTAR_PRECIO_A
                     ,APU_CHECK_OCULTAR_PRECIO_V
                     ,APU_CHECK_OCULTAR_V
                     ,APU_CHECK_PUBLICAR_A
                     ,APU_CHECK_PUBLICAR_V
                     ,APU_CHECK_PUB_SIN_PRECIO_A
                     ,APU_CHECK_PUB_SIN_PRECIO_V
                     ,APU_FECHA_INI_ALQUILER
                     ,VERSION
                     ,USUARIOCREAR
                     ,FECHACREAR
                     ,BORRADO
                  )VALUES(
                      '||V_ESQUEMA||'.S_ACT_APU_ACTIVO_PUBLICACION.NEXTVAL  
                     ,T2.ACT_ID      
                     ,T2.DD_EPA_ID
                     ,T2.DD_EPV_ID
                     ,T2.DD_TCO_ID
                     ,T2.APU_CHECK_OCULTAR_A
                     ,T2.APU_CHECK_OCULTAR_PRECIO_A
                     ,T2.APU_CHECK_OCULTAR_PRECIO_V
                     ,T2.APU_CHECK_OCULTAR_V
                     ,T2.APU_CHECK_PUBLICAR_A
                     ,T2.APU_CHECK_PUBLICAR_V
                     ,T2.APU_CHECK_PUB_SIN_PRECIO_A
                     ,T2.APU_CHECK_PUB_SIN_PRECIO_V
                     ,T2.APU_FECHA_INI_ALQUILER
                     ,0
                     ,''SP_COPIA_DATOS_ACT_MATRIZ''
                     ,SYSDATE
                     ,0
                  )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS/INSERTADOS EN ACT_APU_ACTIVO_PUBLICACION');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS/INSERTADOS EN ACT_APU_ACTIVO_PUBLICACION: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--5º ACT_AHP_HIST_PUBLICACION
DBMS_OUTPUT.PUT_LINE('[INFO] 5º ACT_AHP_HIST_PUBLICACION');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 5º ACT_AHP_HIST_PUBLICACION'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1
USING (
    WITH ACTIVOS_MATRIZ AS (
	    SELECT DISTINCT
            AM.NUM_UNIDAD NUM_IDENTIFICATIVO
		FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
	), AHP_ACTIVO_MATRIZ AS ( 
        SELECT 
             AM.NUM_IDENTIFICATIVO  
            ,AHP.ACT_ID
            ,AHP.DD_TPU_ID
            ,AHP.DD_EPV_ID
            ,AHP.DD_EPA_ID
            ,AHP.DD_TCO_ID
            ,AHP.DD_MTO_V_ID
            ,AHP.AHP_MOT_OCULTACION_MANUAL_V
            ,AHP.AHP_CHECK_PUBLICAR_V
            ,AHP.AHP_CHECK_OCULTAR_V
            ,AHP.AHP_CHECK_OCULTAR_PRECIO_V
            ,AHP.AHP_CHECK_PUB_SIN_PRECIO_V
            ,AHP.DD_MTO_A_ID
            ,AHP.AHP_MOT_OCULTACION_MANUAL_A
            ,AHP.AHP_CHECK_PUBLICAR_A
            ,AHP.AHP_CHECK_OCULTAR_A
            ,AHP.AHP_CHECK_OCULTAR_PRECIO_A
            ,AHP.AHP_CHECK_PUB_SIN_PRECIO_A
            ,AHP.AHP_FECHA_INI_VENTA
            ,AHP.AHP_FECHA_FIN_VENTA
            ,AHP.AHP_FECHA_INI_ALQUILER
            ,AHP.AHP_FECHA_FIN_ALQUILER
            ,AHP.ES_CONDICONADO_ANTERIOR
            ,AHP.DD_TPU_V_ID
            ,AHP.DD_TPU_A_ID
            ,AHP.DD_POR_ID
        FROM ACTIVOS_MATRIZ AM 
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
            AND ACT.BORRADO = 0
        LEFT JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = ACT.ACT_ID    
            AND AHP.BORRADO = 0
    )
    SELECT 
         AAM.ACT_ID
        ,AAM.DD_TPU_ID
        ,AAM.DD_EPV_ID
        ,AAM.DD_EPA_ID
        ,AAM.DD_TCO_ID
        ,AAM.DD_MTO_V_ID
        ,AAM.AHP_MOT_OCULTACION_MANUAL_V
        ,AAM.AHP_CHECK_PUBLICAR_V
        ,AAM.AHP_CHECK_OCULTAR_V
        ,AAM.AHP_CHECK_OCULTAR_PRECIO_V
        ,AAM.AHP_CHECK_PUB_SIN_PRECIO_V
        ,AAM.DD_MTO_A_ID
        ,AAM.AHP_MOT_OCULTACION_MANUAL_A
        ,AAM.AHP_CHECK_PUBLICAR_A
        ,AAM.AHP_CHECK_OCULTAR_A
        ,AAM.AHP_CHECK_OCULTAR_PRECIO_A
        ,AAM.AHP_CHECK_PUB_SIN_PRECIO_A
        ,AAM.AHP_FECHA_INI_VENTA
        ,AAM.AHP_FECHA_FIN_VENTA
        ,AAM.AHP_FECHA_INI_ALQUILER
        ,AAM.AHP_FECHA_FIN_ALQUILER
        ,AAM.ES_CONDICONADO_ANTERIOR
        ,AAM.DD_TPU_V_ID
        ,AAM.DD_TPU_A_ID
        ,AAM.DD_POR_ID
    FROM AHP_ACTIVO_MATRIZ AAM 
    JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = AAM.NUM_IDENTIFICATIVO
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
        AND ACT.BORRADO = 0
) T2 ON (T1.ACT_ID = T2.ACT_ID AND T1.BORRADO = 0)
WHEN NOT MATCHED THEN 
	INSERT(
         AHP_ID
        ,ACT_ID
        ,DD_TPU_ID
        ,DD_EPV_ID
        ,DD_EPA_ID
        ,DD_TCO_ID
        ,DD_MTO_V_ID
        ,AHP_MOT_OCULTACION_MANUAL_V
        ,AHP_CHECK_PUBLICAR_V
        ,AHP_CHECK_OCULTAR_V
        ,AHP_CHECK_OCULTAR_PRECIO_V
        ,AHP_CHECK_PUB_SIN_PRECIO_V
        ,DD_MTO_A_ID
        ,AHP_MOT_OCULTACION_MANUAL_A
        ,AHP_CHECK_PUBLICAR_A
        ,AHP_CHECK_OCULTAR_A
        ,AHP_CHECK_OCULTAR_PRECIO_A
        ,AHP_CHECK_PUB_SIN_PRECIO_A
        ,AHP_FECHA_INI_VENTA
        ,AHP_FECHA_FIN_VENTA
        ,AHP_FECHA_INI_ALQUILER
        ,AHP_FECHA_FIN_ALQUILER
        ,ES_CONDICONADO_ANTERIOR
        ,DD_TPU_V_ID
        ,DD_TPU_A_ID
        ,DD_POR_ID
        ,VERSION
        ,USUARIOCREAR
        ,FECHACREAR
        ,BORRADO
    )VALUES(
         '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL  
        ,T2.ACT_ID
        ,T2.DD_TPU_ID
        ,T2.DD_EPV_ID
        ,T2.DD_EPA_ID
        ,T2.DD_TCO_ID
        ,T2.DD_MTO_V_ID
        ,T2.AHP_MOT_OCULTACION_MANUAL_V
        ,T2.AHP_CHECK_PUBLICAR_V
        ,T2.AHP_CHECK_OCULTAR_V
        ,T2.AHP_CHECK_OCULTAR_PRECIO_V
        ,T2.AHP_CHECK_PUB_SIN_PRECIO_V
        ,T2.DD_MTO_A_ID
        ,T2.AHP_MOT_OCULTACION_MANUAL_A
        ,T2.AHP_CHECK_PUBLICAR_A
        ,T2.AHP_CHECK_OCULTAR_A
        ,T2.AHP_CHECK_OCULTAR_PRECIO_A
        ,T2.AHP_CHECK_PUB_SIN_PRECIO_A
        ,T2.AHP_FECHA_INI_VENTA
        ,T2.AHP_FECHA_FIN_VENTA
        ,T2.AHP_FECHA_INI_ALQUILER
        ,T2.AHP_FECHA_FIN_ALQUILER
        ,T2.ES_CONDICONADO_ANTERIOR
        ,T2.DD_TPU_V_ID
        ,T2.DD_TPU_A_ID
        ,T2.DD_POR_ID
        ,0
        ,''SP_COPIA_DATOS_ACT_MATRIZ''
        ,SYSDATE
        ,0
    )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_AHP_HIST_PUBLICACION');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_AHP_HIST_PUBLICACION: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--6º BIE_DATOS_REGISTRALES
DBMS_OUTPUT.PUT_LINE('[INFO] 6º BIE_DATOS_REGISTRALES');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 6º BIE_DATOS_REGISTRALES'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), BIE_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,BIE.BIE_ID
                           ,BIE.BIE_DREG_NUM_FINCA
                           ,BIE.DD_LOC_ID
                           ,BIE.DD_PRV_ID
                           ,BIE.BIE_DREG_TOMO
                           ,BIE.BIE_DREG_LIBRO
                           ,BIE.BIE_DREG_FOLIO
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BIE ON BIE.BIE_ID = ACT.BIE_ID    
                           AND BIE.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.BIE_ID
                           ,BAM.BIE_DREG_NUM_FINCA
                           ,BAM.DD_LOC_ID
                           ,BAM.DD_PRV_ID
                           ,BAM.BIE_DREG_TOMO
                           ,BAM.BIE_DREG_LIBRO
                           ,BAM.BIE_DREG_FOLIO
                     FROM BIE_ACTIVO_MATRIZ BAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = BAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0 
               ) T2 ON (T1.BIE_ID = T2.BIE_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.BIE_DREG_NUM_FINCA = T2.BIE_DREG_NUM_FINCA
                  ,T1.DD_LOC_ID = T2.DD_LOC_ID
                  ,T1.DD_PRV_ID = T2.DD_PRV_ID
                  ,T1.BIE_DREG_TOMO = T2.BIE_DREG_TOMO
                  ,T1.BIE_DREG_LIBRO = T2.BIE_DREG_LIBRO
                  ,T1.BIE_DREG_FOLIO = T2.BIE_DREG_FOLIO
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN BIE_DATOS_REGISTRALES');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN BIE_DATOS_REGISTRALES: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

--7º ACT_REG_INFO_REGISTRAL
DBMS_OUTPUT.PUT_LINE('[INFO] 7º ACT_REG_INFO_REGISTRAL');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 7º ACT_REG_INFO_REGISTRAL'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), REG_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,REG.ACT_ID
                           ,REG.REG_IDUFIR
                           ,REG.REG_HAN_CAMBIADO
                           ,REG.DD_LOC_ID_ANTERIOR
                           ,REG.REG_NUM_ANTERIOR
                           ,REG.REG_NUM_FINCA_ANTERIOR
                           ,REG.REG_DIV_HOR_INSCRITO
                           ,REG.DD_EDH_ID
                           ,REG.DD_EON_ID
                           ,REG.REG_FECHA_CFO
                           ,REG.TIENE_ANEJOS_REGISTRALES
                           ,0 REG_SUPERFICIE_ELEM_COMUN
                           ,0 REG_SUPERFICIE_PARCELA
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID    
                           AND REG.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                           ,RAM.REG_IDUFIR
                           ,RAM.REG_HAN_CAMBIADO
                           ,RAM.DD_LOC_ID_ANTERIOR
                           ,RAM.REG_NUM_ANTERIOR
                           ,RAM.REG_NUM_FINCA_ANTERIOR
                           ,RAM.REG_DIV_HOR_INSCRITO
                           ,RAM.DD_EDH_ID
                           ,RAM.DD_EON_ID
                           ,RAM.REG_FECHA_CFO
                           ,RAM.TIENE_ANEJOS_REGISTRALES
                           ,RAM.REG_SUPERFICIE_ELEM_COMUN
                           ,RAM.REG_SUPERFICIE_PARCELA
                     FROM REG_ACTIVO_MATRIZ RAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = RAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0 
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET	 
                  T1.REG_IDUFIR = T2.REG_IDUFIR
                  ,T1.REG_HAN_CAMBIADO = T2.REG_HAN_CAMBIADO
                  ,T1.DD_LOC_ID_ANTERIOR = T2.DD_LOC_ID_ANTERIOR
                  ,T1.REG_NUM_ANTERIOR = T2.REG_NUM_ANTERIOR
                  ,T1.REG_NUM_FINCA_ANTERIOR = T2.REG_NUM_FINCA_ANTERIOR
                  ,T1.REG_DIV_HOR_INSCRITO = T2.REG_DIV_HOR_INSCRITO
                  ,T1.DD_EDH_ID = T2.DD_EDH_ID
                  ,T1.DD_EON_ID = T2.DD_EON_ID
                  ,T1.REG_FECHA_CFO = T2.REG_FECHA_CFO
                  ,T1.TIENE_ANEJOS_REGISTRALES = T2.TIENE_ANEJOS_REGISTRALES
                  ,T1.REG_SUPERFICIE_ELEM_COMUN = T2.REG_SUPERFICIE_ELEM_COMUN
                  ,T1.REG_SUPERFICIE_PARCELA = T2.REG_SUPERFICIE_PARCELA
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_REG_INFO_REGISTRAL');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_REG_INFO_REGISTRAL: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

--8º ACT_ABA_ACTIVO_BANCARIO
DBMS_OUTPUT.PUT_LINE('[INFO] 8º ACT_ABA_ACTIVO_BANCARIO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 8º ACT_ABA_ACTIVO_BANCARIO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), ABA_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,ABA.ACT_ID
                           ,ABA.DD_CLA_ID
                           ,ABA.DD_EEI_ID
                           ,ABA.DD_SCA_ID
                           ,ABA.ABA_NEXPRIESGO
                           ,ABA.DD_TIP_ID
                           ,ABA.DD_EER_ID
                           ,ABA.ABA_TIPO_PRODUCTO
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_ABA_ACTIVO_BANCARIO ABA ON ABA.ACT_ID = ACT.ACT_ID    
                           AND ABA.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                           ,AAM.DD_CLA_ID
                           ,AAM.DD_EEI_ID
                           ,AAM.DD_SCA_ID
                           ,AAM.ABA_NEXPRIESGO
                           ,AAM.DD_TIP_ID
                           ,AAM.DD_EER_ID
                           ,AAM.ABA_TIPO_PRODUCTO
                     FROM ABA_ACTIVO_MATRIZ AAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = AAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0 
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET	 
                  T1.DD_CLA_ID = T2.DD_CLA_ID
                  ,T1.DD_EEI_ID = T2.DD_EEI_ID
                  ,T1.DD_SCA_ID = T2.DD_SCA_ID
                  ,T1.ABA_NEXPRIESGO = T2.ABA_NEXPRIESGO
                  ,T1.DD_TIP_ID = T2.DD_TIP_ID
                  ,T1.DD_EER_ID = T2.DD_EER_ID
                  ,T1.ABA_TIPO_PRODUCTO = T2.ABA_TIPO_PRODUCTO
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_ABA_ACTIVO_BANCARIO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_ABA_ACTIVO_BANCARIO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);

--9º ACT_AJD_ADJJUDICIAL
DBMS_OUTPUT.PUT_LINE('[INFO] 9º ACT_AJD_ADJJUDICIAL');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 9º ACT_AJD_ADJJUDICIAL'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), AJD_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,AJD.ACT_ID
                           ,AJD.BIE_ADJ_ID
                           ,AJD.AJD_EXP_DEF_TESTI
                           ,AJD.DD_EEJ_ID
                           ,AJD.DD_EDJ_ID
                           ,AJD.AJD_FECHA_ADJUDICACION
                           ,AJD.AJD_ID_ASUNTO
                           ,AJD.DD_JUZ_ID
                           ,AJD.AJD_LETRADO
                           ,AJD.AJD_NUM_AUTO
                           ,AJD.DD_PLA_ID
                           ,AJD.AJD_PROCURADOR
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL AJD ON AJD.ACT_ID = ACT.ACT_ID    
                           AND AJD.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                           ,AAM.BIE_ADJ_ID
                           ,AAM.AJD_EXP_DEF_TESTI
                           ,AAM.DD_EEJ_ID
                           ,AAM.DD_EDJ_ID
                           ,AAM.AJD_FECHA_ADJUDICACION
                           ,AAM.AJD_ID_ASUNTO
                           ,AAM.DD_JUZ_ID
                           ,AAM.AJD_LETRADO
                           ,AAM.AJD_NUM_AUTO
                           ,AAM.DD_PLA_ID
                           ,AAM.AJD_PROCURADOR
                     FROM AJD_ACTIVO_MATRIZ AAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = AAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0 
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET	 
                  T1.BIE_ADJ_ID = T2.BIE_ADJ_ID
                  ,T1.AJD_EXP_DEF_TESTI = T2.AJD_EXP_DEF_TESTI
                  ,T1.DD_EEJ_ID = T2.DD_EEJ_ID
                  ,T1.DD_EDJ_ID = T2.DD_EDJ_ID
                  ,T1.AJD_FECHA_ADJUDICACION = T2.AJD_FECHA_ADJUDICACION
                  ,T1.AJD_ID_ASUNTO = T2.AJD_ID_ASUNTO
                  ,T1.DD_JUZ_ID = T2.DD_JUZ_ID
                  ,T1.AJD_LETRADO = T2.AJD_LETRADO
                  ,T1.AJD_NUM_AUTO = T2.AJD_NUM_AUTO
                  ,T1.DD_PLA_ID = T2.DD_PLA_ID
                  ,T1.AJD_PROCURADOR = T2.AJD_PROCURADOR
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_AJD_ADJJUDICIAL');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_AJD_ADJJUDICIAL: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--10º ACT_ADN_ADJNOJUDICIAL
DBMS_OUTPUT.PUT_LINE('[INFO] 10º ACT_ADN_ADJNOJUDICIAL');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 10º ACT_ADN_ADJNOJUDICIAL'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), ADN_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,ADN.ACT_ID
                           ,ADN.ADN_EXP_DEF_TESTI
                           ,ADN.DD_EEJ_ID
                           ,ADN.ADN_FECHA_FIRMA_TITULO
                           ,ADN.ADN_FECHA_TITULO
                           ,ADN.ADN_NUM_REFERENCIA
                           ,ADN.ADN_TRAMITADOR_TITULO
                           ,ADN.ADN_VALOR_ADQUISICION
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID = ACT.ACT_ID    
                           AND ADN.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                           ,AAM.ADN_EXP_DEF_TESTI
                           ,AAM.DD_EEJ_ID
                           ,AAM.ADN_FECHA_FIRMA_TITULO
                           ,AAM.ADN_FECHA_TITULO
                           ,AAM.ADN_NUM_REFERENCIA
                           ,AAM.ADN_TRAMITADOR_TITULO
                           ,AAM.ADN_VALOR_ADQUISICION
                     FROM ADN_ACTIVO_MATRIZ AAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = AAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0 
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.ADN_EXP_DEF_TESTI = T2.ADN_EXP_DEF_TESTI
                  ,T1.DD_EEJ_ID = T2.DD_EEJ_ID
                  ,T1.ADN_FECHA_FIRMA_TITULO = T2.ADN_FECHA_FIRMA_TITULO
                  ,T1.ADN_FECHA_TITULO = T2.ADN_FECHA_TITULO
                  ,T1.ADN_NUM_REFERENCIA = T2.ADN_NUM_REFERENCIA
                  ,T1.ADN_TRAMITADOR_TITULO = T2.ADN_TRAMITADOR_TITULO
                  ,T1.ADN_VALOR_ADQUISICION = T2.ADN_VALOR_ADQUISICION
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_ADN_ADJNOJUDICIAL');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_ADN_ADJNOJUDICIAL: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--11º ACT_TIT_TITULO
DBMS_OUTPUT.PUT_LINE('[INFO] 11º ACT_TIT_TITULO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 11º ACT_TIT_TITULO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TIT_TITULO T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), TIT_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,TIT.ACT_ID
                           ,TIT.TIT_FECHA_ENTREGA_GESTORIA
                           ,TIT.TIT_FECHA_ENVIO_AUTO
                           ,TIT.TIT_FECHA_NOTA_SIMPLE
                           ,TIT.TIT_FECHA_INSC_REG
                           ,TIT.TIT_FECHA_PRESENT1_REG
                           ,TIT.TIT_FECHA_PRESENT2_REG
                           ,TIT.TIT_FECHA_RETIRADA_REG
                           ,TIT.TIT_FECHA_PRESENT_HACIENDA
                           ,TIT.DD_ETI_ID
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID = ACT.ACT_ID    
                           AND TIT.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO ACT_NUM_ACTIVO_CAIXA
                           ,AUX.NUM_UNIDAD
                           ,ACT.ACT_ID
                           ,TAM.TIT_FECHA_ENTREGA_GESTORIA
                           ,TAM.TIT_FECHA_ENVIO_AUTO
                           ,TAM.TIT_FECHA_NOTA_SIMPLE
                           ,TAM.TIT_FECHA_INSC_REG
                           ,TAM.TIT_FECHA_PRESENT1_REG
                           ,TAM.TIT_FECHA_PRESENT2_REG
                           ,TAM.TIT_FECHA_RETIRADA_REG
                           ,TAM.TIT_FECHA_PRESENT_HACIENDA
                           ,TAM.DD_ETI_ID
                     FROM TIT_ACTIVO_MATRIZ TAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = TAM.NUM_IDENTIFICATIVO   
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0 
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET        
                  T1.TIT_FECHA_ENTREGA_GESTORIA = T2.TIT_FECHA_ENTREGA_GESTORIA
                  ,T1.TIT_FECHA_ENVIO_AUTO = T2.TIT_FECHA_ENVIO_AUTO
                  ,T1.TIT_FECHA_NOTA_SIMPLE = T2.TIT_FECHA_NOTA_SIMPLE
                  ,T1.TIT_FECHA_INSC_REG = T2.TIT_FECHA_INSC_REG
                  ,T1.TIT_FECHA_PRESENT1_REG = T2.TIT_FECHA_PRESENT1_REG
                  ,T1.TIT_FECHA_PRESENT2_REG = T2.TIT_FECHA_PRESENT2_REG
                  ,T1.TIT_FECHA_RETIRADA_REG = T2.TIT_FECHA_RETIRADA_REG
                  ,T1.TIT_FECHA_PRESENT_HACIENDA = T2.TIT_FECHA_PRESENT_HACIENDA
                  ,T1.DD_ETI_ID = T2.DD_ETI_ID
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_TIT_TITULO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_TIT_TITULO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--12º BIE_CAR_CARGAS
DBMS_OUTPUT.PUT_LINE('[INFO] 12º BIE_CAR_CARGAS');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 12º BIE_CAR_CARGAS'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.BIE_CAR_CARGAS(
     BIE_ID
    ,BIE_CAR_ID
    ,DD_TPC_ID
    ,BIE_CAR_LETRA
    ,BIE_CAR_TITULAR
    ,BIE_CAR_IMPORTE_REGISTRAL
    ,BIE_CAR_IMPORTE_ECONOMICO
    ,BIE_CAR_REGISTRAL
    ,DD_SIC_ID
    ,BIE_CAR_FECHA_PRESENTACION
    ,BIE_CAR_FECHA_INSCRIPCION
    ,BIE_CAR_FECHA_CANCELACION
    ,BIE_CAR_ECONOMICA
    ,DD_SIC_ID2
    ,BIE_CAR_ID_RECOVERY
    ,VERSION
    ,USUARIOCREAR
    ,FECHACREAR
    ,USUARIOBORRAR
    ,BORRADO
)
WITH ACTIVOS_MATRIZ AS (
    SELECT DISTINCT
        AM.NUM_UNIDAD NUM_IDENTIFICATIVO
    FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
), CAR_ACTIVO_MATRIZ AS ( 
    SELECT 
         AM.NUM_IDENTIFICATIVO  
        ,CAR.BIE_ID
        ,CAR.BIE_CAR_ID
        ,CAR.DD_TPC_ID
        ,CAR.BIE_CAR_LETRA
        ,CAR.BIE_CAR_TITULAR
        ,CAR.BIE_CAR_IMPORTE_REGISTRAL
        ,CAR.BIE_CAR_IMPORTE_ECONOMICO
        ,CAR.BIE_CAR_REGISTRAL
        ,CAR.DD_SIC_ID
        ,CAR.BIE_CAR_FECHA_PRESENTACION
        ,CAR.BIE_CAR_FECHA_INSCRIPCION
        ,CAR.BIE_CAR_FECHA_CANCELACION
        ,CAR.BIE_CAR_ECONOMICA
        ,CAR.DD_SIC_ID2
        ,CAR.BIE_CAR_ID_RECOVERY
    FROM ACTIVOS_MATRIZ AM 
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
        AND ACT.BORRADO = 0
    JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS CAR ON CAR.BIE_ID = ACT.BIE_ID    
        AND CAR.BORRADO = 0
)
SELECT 
     ACT.BIE_ID
    ,'||V_ESQUEMA||'.S_BIE_CAR_CARGAS.NEXTVAL
    ,CAM.DD_TPC_ID
    ,CAM.BIE_CAR_LETRA
    ,CAM.BIE_CAR_TITULAR
    ,CAM.BIE_CAR_IMPORTE_REGISTRAL
    ,CAM.BIE_CAR_IMPORTE_ECONOMICO
    ,CAM.BIE_CAR_REGISTRAL
    ,CAM.DD_SIC_ID
    ,CAM.BIE_CAR_FECHA_PRESENTACION
    ,CAM.BIE_CAR_FECHA_INSCRIPCION
    ,CAM.BIE_CAR_FECHA_CANCELACION
    ,CAM.BIE_CAR_ECONOMICA
    ,CAM.DD_SIC_ID2
    ,CAM.BIE_CAR_ID_RECOVERY
    ,0
    ,''SP_COPIA_DATOS_ACT_MATRIZ''
    ,SYSDATE
    ,''BIE-CAR-NUEVA-''||CAM.BIE_CAR_ID
    ,0
FROM CAR_ACTIVO_MATRIZ CAM        
JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = CAM.NUM_IDENTIFICATIVO   
JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
    AND ACT.BORRADO = 0 
WHERE NOT EXISTS (SELECT
                        1
                  FROM '||V_ESQUEMA||'.BIE_CAR_CARGAS CAR1
                  WHERE CAR1.BIE_ID = ACT.BIE_ID
                  AND CAR1.BORRADO = 0
                 )
               ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN BIE_CAR_CARGAS');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN BIE_CAR_CARGAS: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--13º ACT_CRG_CARGAS
DBMS_OUTPUT.PUT_LINE('[INFO] 13º ACT_CRG_CARGAS');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 13º ACT_CRG_CARGAS'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_CRG_CARGAS(
     CRG_ID
    ,ACT_ID
    ,BIE_CAR_ID
    ,DD_TCA_ID
    ,DD_STC_ID
    ,CRG_DESCRIPCION
    ,CRG_ORDEN
    ,CRG_FECHA_CANCEL_REGISTRAL
    ,VERSION
    ,USUARIOCREAR
    ,FECHACREAR
    ,BORRADO
    ,CRG_RECOVERY_ID
    ,DD_ODT_ID
    ,CRG_OBSERVACIONES
    ,CRG_CARGAS_PROPIAS
    ,DD_ECG_ID
    ,DD_SCG_ID
    ,CRG_IMPIDE_VENTA
    ,CRG_OCULTO_CARGA_MASIVA
    ,CRG_ID_EXTERNO
    ,CRG_FECHA_SOLICITUD_CARTA
    ,CRG_FECHA_RECEPCION_CARTA
    ,CRG_FECHA_PRESENTACION_CARTA
    ,CRG_INDICADOR_PREFERENTE
    ,CRG_IDENTIFICADOR_CARGA_EJECUTADA
    ,CRG_IGUALDAD_RANGO
    ,CRG_IDENTIFICADOR_CARGA_INDEFINIDA
    ,CRG_IDENTIFICADOR_CARGA_ECONOMICA
)
WITH ACTIVOS_MATRIZ AS (
    SELECT DISTINCT
        AM.NUM_UNIDAD NUM_IDENTIFICATIVO
    FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
), BIE_CAR_CARGAS_NUEVOS AS (
    SELECT 
         SUBSTR(AUX.USUARIOBORRAR, 15,100) BIE_CAR_ID_AM
        ,AUX.BIE_CAR_ID BIE_CAR_ID_UA
        ,AUX.BIE_ID
    FROM '||V_ESQUEMA||'.BIE_CAR_CARGAS AUX 
    WHERE AUX.USUARIOBORRAR LIKE ''BIE-CAR-NUEVA-%''
    AND AUX.USUARIOBORRAR IS NOT NULL AND AUX.BORRADO = 0
), CRG_ACTIVO_MATRIZ AS ( 
    SELECT 
         AM.NUM_IDENTIFICATIVO  
        ,CRG.CRG_ID
        ,CRG.ACT_ID
        ,CRG.BIE_CAR_ID
        ,CRG.DD_TCA_ID
        ,CRG.DD_STC_ID
        ,CRG.CRG_DESCRIPCION
        ,CRG.CRG_ORDEN
        ,CRG.CRG_FECHA_CANCEL_REGISTRAL
        ,CRG.CRG_RECOVERY_ID
        ,CRG.DD_ODT_ID
        ,CRG.CRG_OBSERVACIONES
        ,CRG.CRG_CARGAS_PROPIAS
        ,CRG.DD_ECG_ID
        ,CRG.DD_SCG_ID
        ,CRG.CRG_IMPIDE_VENTA
        ,CRG.CRG_OCULTO_CARGA_MASIVA
        ,CRG.CRG_ID_EXTERNO
        ,CRG.CRG_FECHA_SOLICITUD_CARTA
        ,CRG.CRG_FECHA_RECEPCION_CARTA
        ,CRG.CRG_FECHA_PRESENTACION_CARTA
        ,CRG.CRG_INDICADOR_PREFERENTE
        ,CRG.CRG_IDENTIFICADOR_CARGA_EJECUTADA
        ,CRG.CRG_IGUALDAD_RANGO
        ,CRG.CRG_IDENTIFICADOR_CARGA_INDEFINIDA
        ,CRG.CRG_IDENTIFICADOR_CARGA_ECONOMICA
    FROM ACTIVOS_MATRIZ AM 
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
        AND ACT.BORRADO = 0
    JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS CAR ON CAR.BIE_ID = ACT.BIE_ID
        AND CAR.BORRADO = 0
    JOIN '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG ON CRG.BIE_CAR_ID = CAR.BIE_CAR_ID    
        AND CRG.BORRADO = 0
)
SELECT 
     '||V_ESQUEMA||'.S_ACT_CRG_CARGAS.NEXTVAL
    ,ACT.ACT_ID
    ,CAR.BIE_CAR_ID_UA
    ,CAM.DD_TCA_ID
    ,CAM.DD_STC_ID
    ,CAM.CRG_DESCRIPCION
    ,CAM.CRG_ORDEN
    ,CAM.CRG_FECHA_CANCEL_REGISTRAL
    ,0
    ,''SP_COPIA_DATOS_ACT_MATRIZ''
    ,SYSDATE
    ,0
    ,CAM.CRG_RECOVERY_ID
    ,CAM.DD_ODT_ID
    ,CAM.CRG_OBSERVACIONES
    ,CAM.CRG_CARGAS_PROPIAS
    ,CAM.DD_ECG_ID
    ,CAM.DD_SCG_ID
    ,CAM.CRG_IMPIDE_VENTA
    ,CAM.CRG_OCULTO_CARGA_MASIVA
    ,CAM.CRG_ID_EXTERNO
    ,CAM.CRG_FECHA_SOLICITUD_CARTA
    ,CAM.CRG_FECHA_RECEPCION_CARTA
    ,CAM.CRG_FECHA_PRESENTACION_CARTA
    ,CAM.CRG_INDICADOR_PREFERENTE
    ,CAM.CRG_IDENTIFICADOR_CARGA_EJECUTADA
    ,CAM.CRG_IGUALDAD_RANGO
    ,CAM.CRG_IDENTIFICADOR_CARGA_INDEFINIDA
    ,CAM.CRG_IDENTIFICADOR_CARGA_ECONOMICA   
FROM CRG_ACTIVO_MATRIZ CAM
JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = CAM.NUM_IDENTIFICATIVO   
JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
    AND ACT.BORRADO = 0 
JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS_NUEVOS CAR ON CAR.BIE_CAR_ID_AM = CAM.BIE_CAR_ID
WHERE NOT EXISTS (SELECT
                        1
                  FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG1
                  WHERE CRG1.BIE_CAR_ID = CAR.BIE_CAR_ID_UA
                  AND CRG1.BORRADO = 0
                 )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN ACT_CRG_CARGAS');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN ACT_CRG_CARGAS: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--13.1º VOLVER A PONER A NULL EL USUARIOBORRAR DE LA BIE_CAR_CARGAS
DBMS_OUTPUT.PUT_LINE('[INFO] 13.1º BIE_CAR_CARGAS');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 13.1º BIE_CAR_CARGAS'||CHR(10);

   V_MSQL := 'UPDATE '||V_ESQUEMA||'.BIE_CAR_CARGAS BIE
                  SET USUARIOBORRAR = NULL
               WHERE BIE.USUARIOBORRAR LIKE ''BIE-CAR-NUEVA %''
               AND BIE.USUARIOBORRAR IS NOT NULL AND BIE.BORRADO = 0';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS (USUARIOBORRAR = NULL) EN BIE_CAR_CARGAS');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS (USUARIOBORRAR = NULL) EN BIE_CAR_CARGAS: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--14º GEE_GESTOR_ENTIDAD
DBMS_OUTPUT.PUT_LINE('[INFO] 14º GEE_GESTOR_ENTIDAD');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 14º GEE_GESTOR_ENTIDAD'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_GEE_COPIA_DATOS_MATRIZ (
    GEE_ID,
    USU_ID,
    DD_TGE_ID,
    ACT_ID_MATRIZ,
    ACT_ID_UA	
) 
WITH ACTIVOS_MATRIZ AS (
    SELECT DISTINCT
        AM.NUM_UNIDAD NUM_IDENTIFICATIVO
    FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
), GEE_ACTIVO_MATRIZ AS (
    SELECT 
         AM.NUM_IDENTIFICATIVO
        ,GAC.ACT_ID
        ,GAC.GEE_ID
        ,GEE.USU_ID
        ,TGE.DD_TGE_ID
    FROM ACTIVOS_MATRIZ AM 
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
        AND ACT.BORRADO = 0
    JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
    JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID
        AND GEE.BORRADO = 0
    JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
        AND TGE.BORRADO = 0
    WHERE TGE.DD_TGE_CODIGO NOT IN (''SADM'',''SUPADM'',''SADM'',''SCOM'',''GCOM'',''GTOADM'',''GGADM'',''GADM'',''GADMT'',''GIAADMT'')
) SELECT '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL, GEE.USU_ID, GEE.DD_TGE_ID, GEE.ACT_ID, ACT.ACT_ID
FROM GEE_ACTIVO_MATRIZ GEE
JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = GEE.NUM_IDENTIFICATIVO   
JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
    AND ACT.BORRADO = 0 
WHERE NOT EXISTS (SELECT
                    1
                  FROM '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC2
                  JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE2 ON GEE2.GEE_ID = GAC2.GEE_ID
                        AND GEE2.BORRADO = 0
                  JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE2 ON TGE2.DD_TGE_ID = GEE2.DD_TGE_ID
                        AND TGE2.BORRADO = 0
                  WHERE GAC2.ACT_ID = ACT.ACT_ID
                  AND TGE2.DD_TGE_CODIGO NOT IN (''SADM'',''SUPADM'',''SADM'',''SCOM'',''GCOM'',''GTOADM'',''GGADM'',''GADM'',''GADMT'',''GIAADMT'') AND GEE2.USU_ID = GEE.USU_ID
                 )';
   EXECUTE IMMEDIATE V_MSQL;
   
   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (
    GEE_ID,
    USU_ID,
    DD_TGE_ID,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
	) 
	SELECT GEE_ID,
	USU_ID,
	DD_TGE_ID,
	0,
	''SP_COPIA_DATOS_ACT_MATRIZ'',
	SYSDATE,
	0
	FROM '||V_ESQUEMA||'.AUX_GEE_COPIA_DATOS_MATRIZ';

    EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN GEE_GESTOR_ENTIDAD');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN GEE_GESTOR_ENTIDAD: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--15º GEH_GESTOR_ENTIDAD_HIST
DBMS_OUTPUT.PUT_LINE('[INFO] 15º GEH_GESTOR_ENTIDAD_HIST');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 15º GEH_GESTOR_ENTIDAD_HIST'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_GEH_COPIA_DATOS_MATRIZ (
    GEH_ID,
    USU_ID,
    DD_TGE_ID,
    ACT_ID_MATRIZ,
    FECHA_DESDE,
    FECHA_HASTA,
    ACT_ID_UA
) 
WITH ACTIVOS_MATRIZ AS (
    SELECT DISTINCT
        AM.NUM_UNIDAD NUM_IDENTIFICATIVO
    FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
), GEH_ACTIVO_MATRIZ AS (
    SELECT 
         AM.NUM_IDENTIFICATIVO
        ,GAH.ACT_ID
        ,GAH.GEH_ID
        ,GEH.USU_ID
        ,GEH.GEH_FECHA_DESDE
        ,GEH.GEH_FECHA_HASTA
        ,TGE.DD_TGE_ID
    FROM ACTIVOS_MATRIZ AM 
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
        AND ACT.BORRADO = 0
    JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
    JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID
        AND GEH.BORRADO = 0
    JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEH.DD_TGE_ID
        AND TGE.BORRADO = 0
    WHERE TGE.DD_TGE_CODIGO NOT IN (''SADM'',''SUPADM'',''SADM'',''SCOM'',''GCOM'',''GTOADM'',''GGADM'',''GADM'',''GADMT'',''GIAADMT'')
) SELECT '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL, GEH.USU_ID, GEH.DD_TGE_ID, GEH.ACT_ID, GEH.GEH_FECHA_DESDE, GEH.GEH_FECHA_HASTA, ACT.ACT_ID
FROM GEH_ACTIVO_MATRIZ GEH
JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = GEH.NUM_IDENTIFICATIVO   
JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
    AND ACT.BORRADO = 0 
    WHERE NOT EXISTS (SELECT
                    1
                  FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH2
                  JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH2 ON GEH2.GEH_ID = GAH2.GEH_ID
                        AND GEH2.BORRADO = 0
                  JOIN REMMASTER.DD_TGE_TIPO_GESTOR TGE2 ON TGE2.DD_TGE_ID = GEH2.DD_TGE_ID
                        AND TGE2.BORRADO = 0
                  WHERE GAH2.ACT_ID = ACT.ACT_ID
                  AND TGE2.DD_TGE_CODIGO NOT IN (''SADM'',''SUPADM'',''SADM'',''SCOM'',''GCOM'',''GTOADM'',''GGADM'',''GADM'',''GADMT'',''GIAADMT'') AND GEH2.USU_ID = GEH.USU_ID
                 )';
   EXECUTE IMMEDIATE V_MSQL;
   
   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (
    GEH_ID,
    USU_ID,
    DD_TGE_ID,
    GEH_FECHA_DESDE,
    GEH_FECHA_HASTA,
    VERSION,
    USUARIOCREAR,
    FECHACREAR,
    BORRADO
	) 
	SELECT GEH_ID,
	USU_ID,
	DD_TGE_ID,
	FECHA_DESDE,
	FECHA_HASTA,
	0,
	''SP_COPIA_DATOS_ACT_MATRIZ'',
	SYSDATE,
	0
	FROM '||V_ESQUEMA||'.AUX_GEH_COPIA_DATOS_MATRIZ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN GEH_GESTOR_ENTIDAD_HIST');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN GEH_GESTOR_ENTIDAD_HIST: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--16º GAC_GESTOR_ADD_ACTIVO
DBMS_OUTPUT.PUT_LINE('[INFO] 16º GAC_GESTOR_ADD_ACTIVO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 16º GAC_GESTOR_ADD_ACTIVO'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (
    GEE_ID,
    ACT_ID
	) 
	SELECT 
	GEE_ID,
	ACT_ID_UA
	FROM '||V_ESQUEMA||'.AUX_GEE_COPIA_DATOS_MATRIZ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN GAC_GESTOR_ADD_ACTIVO');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN GAC_GESTOR_ADD_ACTIVO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--17º GAH_GESTOR_ACTIVO_HISTORICO
DBMS_OUTPUT.PUT_LINE('[INFO] 17º GAH_GESTOR_ACTIVO_HISTORICO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 17º GAH_GESTOR_ACTIVO_HISTORICO'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO (
    GEH_ID,
    ACT_ID
	) 
	SELECT 
	GEH_ID,
	ACT_ID_UA
	FROM '||V_ESQUEMA||'.AUX_GEH_COPIA_DATOS_MATRIZ';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS INSERTADOS EN GAH_GESTOR_ACTIVO_HISTORICO');  
SALIDA := SALIDA || '   [INFO] REGISTROS INSERTADOS EN GAH_GESTOR_ACTIVO_HISTORICO: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--18º ACT_ICO_INFO_COMERCIAL
DBMS_OUTPUT.PUT_LINE('[INFO] 18º ACT_ICO_INFO_COMERCIAL');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 18º ACT_ICO_INFO_COMERCIAL'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL T1
USING (
	WITH ACTIVOS_MATRIZ AS (
	    SELECT DISTINCT
            AM.NUM_UNIDAD NUM_IDENTIFICATIVO
		FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
	), ICO_ACTIVO_MATRIZ AS ( 
        SELECT 
             AM.NUM_IDENTIFICATIVO   
            ,ICO.ICO_MEDIADOR_ID
            ,ICO.ICO_FECHA_RECEP_LLAVES
            ,ICO.ICO_FECHA_ULTIMA_VISITA
            ,ICO.ICO_AUTORIZACION_WEB
            ,ICO.ICO_FECHA_AUTORIZ_HASTA
        FROM ACTIVOS_MATRIZ AM 
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
            AND ACT.BORRADO = 0
        JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID   
            and ICO.BORRADO = 0
    )
        SELECT 
             AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
            ,AUX.NUM_UNIDAD
            ,ACT.ACT_ID
            ,IAM.ICO_MEDIADOR_ID
            ,IAM.ICO_FECHA_RECEP_LLAVES
            ,IAM.ICO_FECHA_ULTIMA_VISITA
            ,IAM.ICO_AUTORIZACION_WEB
            ,IAM.ICO_FECHA_AUTORIZ_HASTA
        FROM ICO_ACTIVO_MATRIZ IAM        
        JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = IAM.NUM_IDENTIFICATIVO  
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
            AND ACT.BORRADO = 0  
) T2 ON (T1.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN UPDATE SET
     T1.ICO_MEDIADOR_ID = T2.ICO_MEDIADOR_ID
    ,T1.ICO_FECHA_RECEP_LLAVES = T2.ICO_FECHA_RECEP_LLAVES
    ,T1.ICO_FECHA_ULTIMA_VISITA = T2.ICO_FECHA_ULTIMA_VISITA
    ,T1.ICO_AUTORIZACION_WEB = T2.ICO_AUTORIZACION_WEB
    ,T1.ICO_FECHA_AUTORIZ_HASTA = T2.ICO_FECHA_AUTORIZ_HASTA
	,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
	,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_ICO_INFO_COMERCIAL');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_ICO_INFO_COMERCIAL: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--19º ACT_ICM_INF_COMER_HIST_MEDI
DBMS_OUTPUT.PUT_LINE('[INFO] 19º ACT_ICM_INF_COMER_HIST_MEDI');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 19º ACT_ICM_INF_COMER_HIST_MEDI'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI T1
USING (
    WITH ACTIVOS_MATRIZ AS (
	    SELECT DISTINCT
            AM.NUM_UNIDAD NUM_IDENTIFICATIVO
		FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
	), ICM_ACTIVO_MATRIZ AS ( 
        SELECT 
             AM.NUM_IDENTIFICATIVO   
            ,ICM.ACT_ID
            ,ICM.ICO_MEDIADOR_ID
            ,ICM.ICM_FECHA_DESDE
            ,ICM.ICM_FECHA_HASTA
            ,ICM.DD_TRL_ID
        FROM ACTIVOS_MATRIZ AM 
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
            AND ACT.BORRADO = 0
        JOIN '||V_ESQUEMA||'.ACT_ICM_INF_COMER_HIST_MEDI ICM ON ICM.ACT_ID = ACT.ACT_ID   
            AND ICM.BORRADO = 0
    )
    SELECT 
         ACT.ACT_ID
        ,IAM.ICO_MEDIADOR_ID
        ,IAM.ICM_FECHA_DESDE
        ,IAM.ICM_FECHA_HASTA
        ,IAM.DD_TRL_ID
    FROM ICM_ACTIVO_MATRIZ IAM 
        JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = IAM.NUM_IDENTIFICATIVO  
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
        AND ACT.BORRADO = 0
) T2 ON (T1.ACT_ID = T2.ACT_ID AND T1.BORRADO = 0)
WHEN NOT MATCHED THEN 
	INSERT(
         ICM_ID
        ,ACT_ID
        ,ICO_MEDIADOR_ID
        ,ICM_FECHA_DESDE
        ,ICM_FECHA_HASTA
        ,DD_TRL_ID
        ,VERSION
        ,USUARIOCREAR
        ,FECHACREAR
        ,BORRADO
    )VALUES(
         '||V_ESQUEMA||'.S_ACT_ICM_INF_COMER_HIST_MEDI.NEXTVAL  
        ,T2.ACT_ID
        ,T2.ICO_MEDIADOR_ID
        ,T2.ICM_FECHA_DESDE
        ,T2.ICM_FECHA_HASTA
        ,T2.DD_TRL_ID
        ,0
        ,''SP_COPIA_DATOS_ACT_MATRIZ''
        ,SYSDATE
        ,0
    )';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_ICM_INF_COMER_HIST_MEDI');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_ICM_INF_COMER_HIST_MEDI: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--20º BIE_LOCALIZACION
DBMS_OUTPUT.PUT_LINE('[INFO] 20º BIE_LOCALIZACION');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 20º BIE_LOCALIZACION'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_LOCALIZACION T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), BIE_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO   
                           ,BIE.BIE_LOC_POBLACION
                           ,BIE.BIE_LOC_DIRECCION
                           ,BIE.BIE_LOC_COD_POST
                           ,BIE.DD_PRV_ID
                           ,BIE.BIE_LOC_PORTAL
                           ,BIE.BIE_LOC_BLOQUE
                           ,BIE.BIE_LOC_ESCALERA
                           ,BIE.BIE_LOC_PISO
                           ,BIE.BIE_LOC_PUERTA
                           ,BIE.BIE_LOC_BARRIO
                           ,BIE.DD_CIC_ID
                           ,BIE.DD_LOC_ID
                           ,BIE.DD_UPO_ID
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION BIE ON BIE.BIE_ID = ACT.BIE_ID   
                           and BIE.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
                           ,AUX.NUM_UNIDAD  
                           ,ACT.BIE_ID
                           ,BAM.BIE_LOC_POBLACION
                           ,BAM.BIE_LOC_DIRECCION
                           ,BAM.BIE_LOC_COD_POST
                           ,BAM.DD_PRV_ID
                           ,BAM.BIE_LOC_PORTAL
                           ,BAM.BIE_LOC_BLOQUE
                           ,BAM.BIE_LOC_ESCALERA
                           ,BAM.BIE_LOC_PISO
                           ,BAM.BIE_LOC_PUERTA
                           ,BAM.BIE_LOC_BARRIO
                           ,BAM.DD_CIC_ID
                           ,BAM.DD_LOC_ID
                           ,BAM.DD_UPO_ID
                     FROM BIE_ACTIVO_MATRIZ BAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = BAM.NUM_IDENTIFICATIVO
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0    
               ) T2 ON (T1.BIE_ID = T2.BIE_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.BIE_LOC_POBLACION = T2.BIE_LOC_POBLACION
                  ,T1.BIE_LOC_DIRECCION = T2.BIE_LOC_DIRECCION
                  ,T1.BIE_LOC_COD_POST = T2.BIE_LOC_COD_POST
                  ,T1.DD_PRV_ID = T2.DD_PRV_ID
                  ,T1.BIE_LOC_PORTAL = T2.BIE_LOC_PORTAL
                  ,T1.BIE_LOC_BLOQUE = T2.BIE_LOC_BLOQUE
                  ,T1.BIE_LOC_ESCALERA = T2.BIE_LOC_ESCALERA
                  ,T1.BIE_LOC_PISO = T2.BIE_LOC_PISO
                  ,T1.BIE_LOC_PUERTA = T2.BIE_LOC_PUERTA
                  ,T1.BIE_LOC_BARRIO = T2.BIE_LOC_BARRIO
                  ,T1.DD_CIC_ID = T2.DD_CIC_ID
                  ,T1.DD_LOC_ID = T2.DD_LOC_ID
                  ,T1.DD_UPO_ID = T2.DD_UPO_ID
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN BIE_LOCALIZACION');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN BIE_LOCALIZACION: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--21º ACT_LOC_LOCALIZACION
DBMS_OUTPUT.PUT_LINE('[INFO] 21º ACT_LOC_LOCALIZACION');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 21º ACT_LOC_LOCALIZACION'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), LOC_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO  
                           ,LOC.BIE_LOC_ID
                           ,LOC.LOC_LONGITUD
                           ,LOC.LOC_LATITUD
                           ,LOC.LOC_DIST_PLAYA
                           ,LOC.DD_TUB_ID
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_LOC_LOCALIZACION LOC ON LOC.ACT_ID = ACT.ACT_ID   
                           and LOC.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
                           ,AUX.NUM_UNIDAD  
                           ,ACT.ACT_ID
                           ,LAM.BIE_LOC_ID
                           ,LAM.LOC_LONGITUD
                           ,LAM.LOC_LATITUD
                           ,LAM.LOC_DIST_PLAYA
                           ,LAM.DD_TUB_ID
                     FROM LOC_ACTIVO_MATRIZ LAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = LAM.NUM_IDENTIFICATIVO
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0    
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.BIE_LOC_ID = T2.BIE_LOC_ID
                  ,T1.LOC_LONGITUD = T2.LOC_LONGITUD
                  ,T1.LOC_LATITUD = T2.LOC_LATITUD
                  ,T1.LOC_DIST_PLAYA = T2.LOC_DIST_PLAYA
                  ,T1.DD_TUB_ID = T2.DD_TUB_ID
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_LOC_LOCALIZACION');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_LOC_LOCALIZACION: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--22º ACT_SPS_SIT_POSESORIA
DBMS_OUTPUT.PUT_LINE('[INFO] 22º ACT_SPS_SIT_POSESORIA');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 22º ACT_SPS_SIT_POSESORIA'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), SPS_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO 
                           ,SPS.DD_TPO_ID
                           ,SPS.SPS_OTRO
                           ,SPS.SPS_FECHA_REVISION_ESTADO
                           ,SPS.SPS_FECHA_TOMA_POSESION
                           ,0 SPS_OCUPADO
                           ,''SP_COPIA_DATOS_ACT_MATRIZ'' SPS_USUARIOMODIFICAR_OCUPADO
                           ,0 SPS_ACC_ANTIOCUPA
                           ,0 SPS_ACC_TAPIADO
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID   
                           AND SPS.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
                           ,AUX.NUM_UNIDAD  
                           ,ACT.ACT_ID
                           ,SAM.DD_TPO_ID
                           ,SAM.SPS_OTRO
                           ,SAM.SPS_FECHA_REVISION_ESTADO
                           ,SAM.SPS_FECHA_TOMA_POSESION
                           ,SAM.SPS_OCUPADO
                           ,SAM.SPS_USUARIOMODIFICAR_OCUPADO
                           ,SAM.SPS_ACC_ANTIOCUPA
                           ,SAM.SPS_ACC_TAPIADO
                     FROM SPS_ACTIVO_MATRIZ SAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = SAM.NUM_IDENTIFICATIVO
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0    
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.DD_TPO_ID = T2.DD_TPO_ID
                  ,T1.SPS_OTRO = T2.SPS_OTRO
                  ,T1.SPS_FECHA_REVISION_ESTADO = T2.SPS_FECHA_REVISION_ESTADO
                  ,T1.SPS_FECHA_TOMA_POSESION = T2.SPS_FECHA_TOMA_POSESION
                  ,T1.SPS_OCUPADO = T2.SPS_OCUPADO
                  ,T1.SPS_USUARIOMODIFICAR_OCUPADO = T2.SPS_USUARIOMODIFICAR_OCUPADO
                  ,T1.SPS_ACC_ANTIOCUPA = T2.SPS_ACC_ANTIOCUPA
                  ,T1.SPS_ACC_TAPIADO = T2.SPS_ACC_TAPIADO
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_SPS_SIT_POSESORIA');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_SPS_SIT_POSESORIA: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--23º ACT_OLE_OCUPANTE_LEGAL
DBMS_OUTPUT.PUT_LINE('[INFO] 23º ACT_OLE_OCUPANTE_LEGAL');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 23º ACT_OLE_OCUPANTE_LEGAL'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), OLE_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO 
                           ,OLE.OLE_NOMBRE
                           ,OLE.OLE_NIF
                           ,OLE.OLE_EMAIL
                           ,OLE.OLE_TELF
                           ,OLE.OLE_OBS
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID   
                           AND SPS.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL OLE ON OLE.SPS_ID = SPS.SPS_ID   
                           AND OLE.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
                           ,AUX.NUM_UNIDAD  
                           ,SPS.SPS_ID
                           ,OAM.OLE_NOMBRE
                           ,OAM.OLE_NIF
                           ,OAM.OLE_EMAIL
                           ,OAM.OLE_TELF
                           ,OAM.OLE_OBS
                     FROM OLE_ACTIVO_MATRIZ OAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = OAM.NUM_IDENTIFICATIVO
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0  
                     JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID   
                           AND SPS.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_OLE_OCUPANTE_LEGAL OLE ON OLE.SPS_ID = SPS.SPS_ID   
                           AND OLE.BORRADO = 0  
               ) T2 ON (T1.SPS_ID = T2.SPS_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.OLE_NOMBRE = T2.OLE_NOMBRE
                  ,T1.OLE_NIF = T2.OLE_NIF
                  ,T1.OLE_EMAIL = T2.OLE_EMAIL
                  ,T1.OLE_TELF = T2.OLE_TELF
                  ,T1.OLE_OBS = T2.OLE_OBS
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_OLE_OCUPANTE_LEGAL');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_OLE_OCUPANTE_LEGAL: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--24º ACT_ACTIVO_CAIXA
DBMS_OUTPUT.PUT_LINE('[INFO] 24º ACT_ACTIVO_CAIXA');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 24º ACT_ACTIVO_CAIXA'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), CAIXA_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO 
                           ,CAIXA.DD_ETP_ID
                           ,CAIXA.FEC_EST_POSESORIO_BC
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAIXA ON CAIXA.ACT_ID = ACT.ACT_ID   
                           AND CAIXA.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
                           ,AUX.NUM_UNIDAD 
                           ,ACT.ACT_ID
                           ,CAM.DD_ETP_ID
                           ,CAM.FEC_EST_POSESORIO_BC
                     FROM CAIXA_ACTIVO_MATRIZ CAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = CAM.NUM_IDENTIFICATIVO
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0  
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.DD_ETP_ID = T2.DD_ETP_ID
                  ,T1.FEC_EST_POSESORIO_BC = T2.FEC_EST_POSESORIO_BC
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_ACTIVO_CAIXA');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_ACTIVO_CAIXA: '|| SQL%ROWCOUNT|| CHR(10);
SALIDA := SALIDA ||' '||CHR(10);


--25º ACT_HOT_HIST_OCUPADO_TITULO
DBMS_OUTPUT.PUT_LINE('[INFO] 25º ACT_HOT_HIST_OCUPADO_TITULO');  
SALIDA := '[INICIO]'||CHR(10);
SALIDA := SALIDA || '[INFO] 25º ACT_HOT_HIST_OCUPADO_TITULO'||CHR(10);

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_HOT_HIST_OCUPADO_TITULO T1
               USING (
                  WITH ACTIVOS_MATRIZ AS (
                     SELECT DISTINCT
                           AM.NUM_UNIDAD NUM_IDENTIFICATIVO
                     FROM '||V_ESQUEMA||'.AUX_BCR_PROM_ALQUI_STOCK AM
                  ), HOT_ACTIVO_MATRIZ AS ( 
                     SELECT 
                           AM.NUM_IDENTIFICATIVO 
                           ,HOT.HOT_OCUPADO
                           ,HOT.HOT_DD_TPA_ID
                           ,HOT.HOT_FECHA_HORA_ALTA
                           ,HOT.HOT_USUARIO_ALTA
                           ,HOT.HOT_LUGAR_MODIFICACION
                     FROM ACTIVOS_MATRIZ AM 
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AM.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.ACT_HOT_HIST_OCUPADO_TITULO HOT ON HOT.ACT_ID = ACT.ACT_ID   
                           AND HOT.BORRADO = 0
                  )
                     SELECT 
                           AUX.NUM_IDENTIFICATIVO BIE_NUMERO_ACTIVO
                           ,AUX.NUM_UNIDAD 
                           ,ACT.ACT_ID
                           ,HAM.HOT_OCUPADO
                           ,HAM.HOT_DD_TPA_ID
                           ,HAM.HOT_FECHA_HORA_ALTA
                           ,HAM.HOT_USUARIO_ALTA
                           ,HAM.HOT_LUGAR_MODIFICACION
                     FROM HOT_ACTIVO_MATRIZ HAM        
                     JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_UNIDAD = HAM.NUM_IDENTIFICATIVO
                     JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  
                           AND ACT.BORRADO = 0  
               ) T2 ON (T1.ACT_ID = T2.ACT_ID)
               WHEN MATCHED THEN UPDATE SET
                  T1.HOT_OCUPADO = T2.HOT_OCUPADO
                  ,T1.HOT_DD_TPA_ID = T2.HOT_DD_TPA_ID
                  ,T1.HOT_FECHA_HORA_ALTA = T2.HOT_FECHA_HORA_ALTA
                  ,T1.HOT_USUARIO_ALTA = T2.HOT_USUARIO_ALTA
                  ,T1.HOT_LUGAR_MODIFICACION = T2.HOT_LUGAR_MODIFICACION
                  ,T1.USUARIOMODIFICAR = ''SP_COPIA_DATOS_ACT_MATRIZ''
                  ,T1.FECHAMODIFICAR = SYSDATE';
   EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN ACT_HOT_HIST_OCUPADO_TITULO');  
SALIDA := SALIDA || '   [INFO] REGISTROS MODIFICADOS EN ACT_HOT_HIST_OCUPADO_TITULO: '|| SQL%ROWCOUNT|| CHR(10);
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
END SP_COPIA_DATOS_ACT_MATRIZ;
/
EXIT;
