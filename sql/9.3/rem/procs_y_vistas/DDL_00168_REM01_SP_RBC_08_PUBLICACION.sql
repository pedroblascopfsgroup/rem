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

CREATE OR REPLACE PROCEDURE SP_RBC_08_PUBLICACION
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE PUBLICACIÓN.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN A AUX_APR_RBC_STOCK DE LA ACT_APU_ACTIVO_PUBLICACION'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK APR
                  USING (
                     WITH VENTA AS (
                        SELECT
                        APU.ACT_ID
                        , APU.APU_FECHA_INI_VENTA
                        FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                        JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
                        WHERE APU.BORRADO = 0 
                        AND EPV.DD_EPV_CODIGO = ''03''
                        AND APU.APU_FECHA_INI_VENTA IS NOT NULL
                     ), ALQUILER AS (
                        SELECT
                        APU.ACT_ID
                        , APU.APU_FECHA_INI_ALQUILER
                        FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                        JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID AND EPA.BORRADO = 0
                        WHERE APU.BORRADO = 0 
                        AND EPA.DD_EPA_CODIGO = ''03''
                        AND APU.APU_FECHA_INI_ALQUILER IS NOT NULL
                     )
                     SELECT 
                     ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO
                     , ACT.ACT_NUM_ACTIVO NUM_INMUEBLE
                     , CASE   WHEN VNT.ACT_ID IS NOT NULL AND ALQ.ACT_ID IS NOT NULL AND VNT.APU_FECHA_INI_VENTA < ALQ.APU_FECHA_INI_ALQUILER THEN TO_CHAR(VNT.APU_FECHA_INI_VENTA,''YYYYMMDD'') 
                              WHEN VNT.ACT_ID IS NOT NULL AND ALQ.ACT_ID IS NOT NULL AND VNT.APU_FECHA_INI_VENTA > ALQ.APU_FECHA_INI_ALQUILER THEN TO_CHAR(ALQ.APU_FECHA_INI_ALQUILER,''YYYYMMDD'') 
                              WHEN VNT.ACT_ID IS NOT NULL THEN TO_CHAR(VNT.APU_FECHA_INI_VENTA,''YYYYMMDD'') 
                              WHEN ALQ.ACT_ID IS NOT NULL THEN TO_CHAR(ALQ.APU_FECHA_INI_ALQUILER,''YYYYMMDD'') 
                     END FEC_PUBLICACION_SERVICER
                     FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                     LEFT JOIN VENTA VNT ON VNT.ACT_ID = ACT.ACT_ID
                     LEFT JOIN ALQUILER ALQ ON ALQ.ACT_ID = ACT.ACT_ID
                     JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
                     WHERE (VNT.APU_FECHA_INI_VENTA IS NOT NULL OR ALQ.APU_FECHA_INI_ALQUILER IS NOT NULL)
                     AND ACT.BORRADO = 0
                     AND CRA.DD_CRA_CODIGO = ''03''
                     AND PAC.PAC_INCLUIDO = 1
                     AND ACT.ACT_EN_TRAMITE = 0
                     AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                     AND PRO.PRO_DOCIDENTIF NOT IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569''''A80352750'', ''A80514466'')
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE AND APR.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  APR.FEC_PUBLICACION_SERVICER = AUX.FEC_PUBLICACION_SERVICER
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (NUM_IDENTIFICATIVO
                  , NUM_INMUEBLE
                  , FEC_PUBLICACION_SERVICER)
                  VALUES 
                  (AUX.NUM_IDENTIFICATIVO
                  , AUX.NUM_INMUEBLE
                  , AUX.FEC_PUBLICACION_SERVICER)';
   
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
END SP_RBC_08_PUBLICACION;
/
EXIT;
