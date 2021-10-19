--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211019
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						



CREATE OR REPLACE PROCEDURE SP_RBC_TIT_01_DATOS_GENERALES
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

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN

      SALIDA := '[INICIO]'||CHR(10);

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A EXTRAER LOS DATOS GENERALES'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN DE CAMPOS DE DATOS GENERALES'||CHR(10);

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_TIT_STOCK RBC_TIT
				USING (				                 
                  SELECT       
                     ACT.ACT_NUM_ACTIVO_CAIXA as NUM_IDENTIFICATIVO 
                     , EQV1.DD_CODIGO_CAIXA SOCIEDAD_PATRIMONIAL
                     , EQV2.DD_CODIGO_CAIXA FONDO
                     , BCR.ESTADO_POSESORIO
                     , BCR.FEC_ESTADO_POSESORIO
                     , TO_CHAR(COALESCE(ADJ.BIE_ADJ_F_DECRETO_FIRME, ADN.ADN_FECHA_TITULO),''YYYYMMDD'') FEC_TITULO_FIRME       
                     , ACT.ACT_PORCENTAJE_CONSTRUCCION PORC_OBRA_EJECUTADA
                     , NULL FEC_COMPRA
                     , BCR.FEC_VALIDO_DE
                     , NULL SUBTIPO_VIVIENDA/*BCR.SUBTIPO_VIVIENDA*/
                     , NULL /*BCR.*/IND_OCUPANTES_VIVIENDA
                     , NULL /*BCR.*/PRODUCTO
                     , NULL /*DECODE(TCO.DD_TCO_CODIGO, ''03'', ''N'', ''S'')*/ VENTA
                     , NULL /*BCR.*/SITUACION_VPO
                     , NULL LIC_PRI_OCUPACION
                     , BCR.CLASE_USO
                     , BCR.SUBTIPO_SUELO
                     FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                     LEFT JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK BCR ON ACT.ACT_NUM_ACTIVO_CAIXA = BCR.NUM_IDENTIFICATIVO
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION ADJ ON ADJ.BIE_ID = ACT.BIE_ID AND ADJ.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID = ACT.ACT_ID AND ADN.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID AND TCO.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV1 ON EQV1.DD_NOMBRE_CAIXA = ''SOCIEDAD_PATRIMONIAL'' AND EQV1.DD_CODIGO_REM = PRO.PRO_DOCIDENTIF AND EQV1.BORRADO = 0 
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV2 ON EQV2.DD_NOMBRE_CAIXA = ''FONDO'' AND EQV2.DD_CODIGO_REM = PRO.PRO_DOCIDENTIF AND EQV2.BORRADO = 0 
                     WHERE ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                     AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
                     AND ACT.BORRADO = 0
                     AND PAC.PAC_INCLUIDO = 1
                     AND ACT.ACT_EN_TRAMITE = 0
                     AND PRO.PRO_DOCIDENTIF IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569'')
                  ) AUX ON (RBC_TIT.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN UPDATE SET
                     RBC_TIT.SOCIEDAD_PATRIMONIAL = AUX.SOCIEDAD_PATRIMONIAL
                     , RBC_TIT.FONDO = AUX.FONDO
                     , RBC_TIT.ESTADO_POSESORIO = AUX.ESTADO_POSESORIO
                     , RBC_TIT.FEC_ESTADO_POSESORIO = AUX.FEC_ESTADO_POSESORIO
                     , RBC_TIT.FEC_TITULO_FIRME = AUX.FEC_TITULO_FIRME
                     , RBC_TIT.PORC_OBRA_EJECUTADA = AUX.PORC_OBRA_EJECUTADA
                     , RBC_TIT.FEC_COMPRA = AUX.FEC_COMPRA
                     , RBC_TIT.FEC_VALIDO_DE = AUX.FEC_VALIDO_DE
                     , RBC_TIT.SUBTIPO_VIVIENDA = AUX.SUBTIPO_VIVIENDA                             
                     , RBC_TIT.IND_OCUPANTES_VIVIENDA = AUX.IND_OCUPANTES_VIVIENDA
                     , RBC_TIT.PRODUCTO = AUX.PRODUCTO
                     , RBC_TIT.VENTA = AUX.VENTA
                     , RBC_TIT.SITUACION_VPO = AUX.SITUACION_VPO
                     , RBC_TIT.LIC_PRI_OCUPACION = AUX.LIC_PRI_OCUPACION
                     , RBC_TIT.CLASE_USO = AUX.CLASE_USO
                     , RBC_TIT.SUBTIPO_SUELO = AUX.SUBTIPO_SUELO
                  WHEN NOT MATCHED THEN
                  INSERT  (
                              NUM_IDENTIFICATIVO
                              , SOCIEDAD_PATRIMONIAL  
                              , FONDO                                                                      
                              , ESTADO_POSESORIO
                              , FEC_ESTADO_POSESORIO
                              , FEC_TITULO_FIRME   
                              , PORC_OBRA_EJECUTADA
                              , FEC_COMPRA
                              , FEC_VALIDO_DE
                              , SUBTIPO_VIVIENDA
                              , IND_OCUPANTES_VIVIENDA
                              , PRODUCTO
                              , VENTA
                              , SITUACION_VPO
                              , LIC_PRI_OCUPACION
                              , CLASE_USO
                              , SUBTIPO_SUELO
                           )
                  VALUES   (
                              AUX.NUM_IDENTIFICATIVO
                              , AUX.SOCIEDAD_PATRIMONIAL    
                              , AUX.FONDO                                                                   
                              , AUX.ESTADO_POSESORIO
                              , AUX.FEC_ESTADO_POSESORIO
                              , AUX.FEC_TITULO_FIRME 
                              , AUX.PORC_OBRA_EJECUTADA
                              , AUX.FEC_COMPRA
                              , AUX.FEC_VALIDO_DE
                              , AUX.SUBTIPO_VIVIENDA
                              , AUX.IND_OCUPANTES_VIVIENDA
                              , AUX.PRODUCTO
                              , AUX.VENTA
                              , AUX.SITUACION_VPO
                              , AUX.LIC_PRI_OCUPACION
                              , AUX.CLASE_USO
                              , AUX.SUBTIPO_SUELO
                           )';

   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_RBC_TIT_01_DATOS_GENERALES;
/
EXIT;
