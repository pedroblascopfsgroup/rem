--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 ACT_EN_TRAMITE = 0  - [HREOS-14366] - Daniel Algaba
--##        0.3 Metemos NUM_IDENTFICATIVO como campos de cruce - [HREOS-14368] - Daniel Algaba
--##	      0.4 Filtramos las consultas para que no salgan los activos titulizados - HREOS-15423
--##        0.5 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_RBC_11_AGRUPACIONES
   (     
      FLAG_EN_REM IN NUMBER
      , SALIDA OUT VARCHAR2
      , COD_RETORNO OUT NUMBER
   )

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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE AGRUPACIONES.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN A AUX_APR_RBC_STOCK DE LA ACT_AGA_AGRUPACION_ACTIVO'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK APR
                  USING (
                     WITH MATRIZ AS (
                        SELECT AGA.ACT_ID
                        FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
                        JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON AGR.DD_TAG_ID = TAG.DD_TAG_ID AND TAG.BORRADO = 0
                        JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.AGA_PRINCIPAL = 1 AND AGA.BORRADO = 0
                        WHERE TAG.DD_TAG_CODIGO = ''16''
                        AND AGR.AGR_FECHA_BAJA IS NULL
                     )
                     SELECT 
                     ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO
                     , ACT.ACT_NUM_ACTIVO NUM_INMUEBLE
                     , CASE WHEN M.ACT_ID IS NOT NULL THEN ''S'' ELSE ''N'' END SITUACION_ALQUILER
                     FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                     JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
                     LEFT JOIN MATRIZ M ON ACT.ACT_ID = M.ACT_ID
                     WHERE ACT.BORRADO = 0
                     AND CRA.DD_CRA_CODIGO = ''03''
                     AND PAC.PAC_INCLUIDO = 1
                     AND ACT.ACT_EN_TRAMITE = 0
                     AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                     AND PRO.PRO_DOCIDENTIF NOT IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569''''A80352750'', ''A80514466'')   
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE AND APR.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN
                  UPDATE SET 
                     APR.SITUACION_ALQUILER = AUX.SITUACION_ALQUILER
                  WHEN NOT MATCHED THEN
                  INSERT 
                     (NUM_IDENTIFICATIVO
                     , NUM_INMUEBLE
                     , SITUACION_ALQUILER)
                     VALUES 
                     (AUX.NUM_IDENTIFICATIVO
                     , AUX.NUM_INMUEBLE
                     , AUX.SITUACION_ALQUILER)';
   
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
END SP_RBC_11_AGRUPACIONES;
/
EXIT;
