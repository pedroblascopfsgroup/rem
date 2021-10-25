--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211025
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15969
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##        0.3 Se añaden mapeos de campos creados en REM y se cambia la cartera por la nuevo Titulizada - [HREOS-15969] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						



CREATE OR REPLACE PROCEDURE SP_RBC_TIT_02_PATRIMONIO
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A EXTRAER LOS DATOS DE PATRIMONIO'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN DE CAMPOS DE PATRIMONIO'||CHR(10);


       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_TIT_STOCK RBC_TIT
				USING (				                 
                  SELECT       
                     ACT.ACT_NUM_ACTIVO_CAIXA as NUM_IDENTIFICATIVO   
                     , CASE WHEN PTA.ACUERDO_PAGO = 1 THEN ''S'' ELSE ''N'' END ACUERDO_PAGO
                     , CASE WHEN EAL.DD_EAL_CODIGO = ''02'' THEN ''S'' ELSE ''N'' END ALQUILADO
                     , CASE WHEN PTA.MOROSO = 1 THEN ''S'' ELSE ''N'' END MOROSO
                     , CASE WHEN PTA.ACTIVO_PROMO_ESTRATEG = 1 THEN ''S'' ELSE ''N'' END ACTIVO_PROMO_ESTRATEG
                     , CASE WHEN PTA.PTA_TRAMITE_ALQ_SOCIAL = 1 THEN ''S'' ELSE ''N'' END ALQUILER_GESTION
                     FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                     LEFT JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK BCR ON ACT.ACT_NUM_ACTIVO_CAIXA = BCR.NUM_IDENTIFICATIVO
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA ON PTA.ACT_ID = ACT.ACT_ID AND PTA.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EAL_ESTADO_ALQUILER EAL ON EAL.DD_EAL_ID = PTA.DD_EAL_ID AND EAL.BORRADO = 0
                     WHERE ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                     --AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''17'')
                     AND ACT.BORRADO = 0
                     AND PAC.PAC_INCLUIDO = 1
                     --AND ACT.ACT_EN_TRAMITE = 0
                     AND PRO.PRO_DOCIDENTIF IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569'')
                  ) AUX ON (RBC_TIT.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN UPDATE SET
                     RBC_TIT.ACUERDO_PAGO = AUX.ACUERDO_PAGO
                     , RBC_TIT.ALQUILADO = AUX.ALQUILADO
                     , RBC_TIT.MOROSO = AUX.MOROSO
                     , RBC_TIT.ACTIVO_PROMO_ESTRATEG = AUX.ACTIVO_PROMO_ESTRATEG
                     , RBC_TIT.ALQUILER_GESTION = AUX.ALQUILER_GESTION';

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
END SP_RBC_TIT_02_PATRIMONIO;
/
EXIT;
