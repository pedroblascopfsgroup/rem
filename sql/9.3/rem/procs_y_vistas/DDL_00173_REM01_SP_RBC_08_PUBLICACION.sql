--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210616
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14325
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
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
                     , CASE   WHEN VNT.ACT_ID IS NOT NULL AND ALQ.ACT_ID IS NOT NULL AND VNT.APU_FECHA_INI_VENTA < ALQ.APU_FECHA_INI_ALQUILER THEN VNT.APU_FECHA_INI_VENTA 
                              WHEN VNT.ACT_ID IS NOT NULL AND ALQ.ACT_ID IS NOT NULL AND VNT.APU_FECHA_INI_VENTA > ALQ.APU_FECHA_INI_ALQUILER THEN ALQ.APU_FECHA_INI_ALQUILER 
                              WHEN VNT.ACT_ID IS NOT NULL THEN VNT.APU_FECHA_INI_VENTA 
                              WHEN ALQ.ACT_ID IS NOT NULL THEN ALQ.APU_FECHA_INI_ALQUILER 
                     END FEC_PUBLICACION_SERVICER
                     FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                     LEFT JOIN VENTA VNT ON VNT.ACT_ID = ACT.ACT_ID
                     LEFT JOIN ALQUILER ALQ ON ALQ.ACT_ID = ACT.ACT_ID
                     JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     WHERE (VNT.APU_FECHA_INI_VENTA IS NOT NULL OR ALQ.APU_FECHA_INI_ALQUILER IS NOT NULL)
                     AND CRA.DD_CRA_CODIGO = ''03''
                     AND PAC.PAC_INCLUIDO = 1
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE)
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
