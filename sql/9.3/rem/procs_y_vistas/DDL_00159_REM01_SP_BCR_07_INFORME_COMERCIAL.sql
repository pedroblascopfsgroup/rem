--/*
--##########################################
--## AUTOR=Danie Algaba
--## FECHA_CREACION=20210628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14436
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

CREATE OR REPLACE PROCEDURE SP_BCR_07_INFORME_COMERCIAL
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE INFORME COMERCIAL.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - ACT_ICO_INFO_COMERCIAL'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO
               USING (
                  SELECT
                  ICO.ICO_ID
                  , COALESCE(ICO.ICO_ANO_REHABILITACION, TO_NUMBER(APR.ANYO_ULTIMA_REFORMA)) ANYO_ULTIMA_REFORMA
                  , ACT.ACT_NUM_ACTIVO_CAIXA AS NUM_IDENTIFICATIVO      
                  , ACT.ACT_NUM_ACTIVO AS NUM_INMUEBLE  
                  , ACT.ACT_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID 
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                  WHERE ACT.BORRADO = 0
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  AND ACT.ACT_EN_TRAMITE = 0
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM||'
               ) AUX
               ON (ICO.ICO_ID = AUX.ICO_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  ICO.ICO_ANO_REHABILITACION = AUX.ANYO_ULTIMA_REFORMA
                  , ICO.USUARIOMODIFICAR = ''STOCK_BC''
                  , ICO.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (ICO_ID
                  , ACT_ID
                  , ICO_ANO_REHABILITACION
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_ACT_ICO_INFO_COMERCIAL.nextval
                  , AUX.ACT_ID
                  , AUX.ANYO_ULTIMA_REFORMA
                  , ''STOCK_BC''
                  , SYSDATE)';
      
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 2 - ACT_DIS_DISTRIBUCION TERRAZAS'||CHR(10);

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                  (DIS_ID
                  , DIS_NUM_PLANTA
                  , DD_TPH_ID
                  , DIS_CANTIDAD
                  , USUARIOCREAR
                  , FECHACREAR
                  , ICO_ID)
                  SELECT
                  '|| V_ESQUEMA ||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL DIS_ID   
                  , 0 DIS_NUM_PLANTA
                  , (SELECT TPH.DD_TPH_ID FROM '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH WHERE TPH.DD_TPH_CODIGO = ''15'') DD_TPH_ID
                  , APR.NUM_TERRAZAS/100 DIS_CANTIDAD
                  , ''STOCK_BC'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , ICO.ICO_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID 
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                  WHERE ACT.BORRADO = 0
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  AND ACT.ACT_EN_TRAMITE = 0
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM||'
                  AND NOT EXISTS (SELECT 1
                  FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                  JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID = DIS.DD_TPH_ID AND TPH.BORRADO=0
                  WHERE DIS.BORRADO = 0  
                  AND TPH.DD_TPH_CODIGO IN (''15'',''16'')
                  AND DIS.ICO_ID = ICO.ICO_ID)';
      
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 3 - ACT_DIS_DISTRIBUCION HABITACIONES'||CHR(10);

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                  (DIS_ID
                  , DIS_NUM_PLANTA
                  , DD_TPH_ID
                  , DIS_CANTIDAD
                  , USUARIOCREAR
                  , FECHACREAR
                  , ICO_ID)
                  SELECT
                  '|| V_ESQUEMA ||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL DIS_ID   
                  , 0 DIS_NUM_PLANTA
                  , (SELECT TPH.DD_TPH_ID FROM '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH WHERE TPH.DD_TPH_CODIGO = ''01'') DD_TPH_ID                        
                  , APR.NUM_HABITACIONES/100 DIS_CANTIDAD    
                  , ''STOCK_BC'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , ICO.ICO_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID 
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                  WHERE ACT.BORRADO = 0
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  AND ACT.ACT_EN_TRAMITE = 0
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM||'
                  AND NOT EXISTS (SELECT 1
                  FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                  JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID = DIS.DD_TPH_ID AND TPH.BORRADO=0
                  WHERE DIS.BORRADO = 0  
                  AND TPH.DD_TPH_CODIGO IN (''01'')
                  AND DIS.ICO_ID = ICO.ICO_ID)';
      
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 4 - ACT_DIS_DISTRIBUCION BAÑOS'||CHR(10);

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                  (DIS_ID
                  , DIS_NUM_PLANTA
                  , DD_TPH_ID
                  , DIS_CANTIDAD
                  , USUARIOCREAR
                  , FECHACREAR
                  , ICO_ID)
                  SELECT
                  '|| V_ESQUEMA ||'.S_ACT_DIS_DISTRIBUCION.NEXTVAL DIS_ID   
                  , 0 DIS_NUM_PLANTA
                  , (SELECT TPH.DD_TPH_ID FROM '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH WHERE TPH.DD_TPH_CODIGO = ''02'') DD_TPH_ID                            
                  , APR.NUM_BANYOS/100 DIS_CANTIDAD     
                  , ''STOCK_BC'' USUARIOCREAR
                  , SYSDATE FECHACREAR
                  , ICO.ICO_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID 
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                  WHERE ACT.BORRADO = 0
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  AND ACT.ACT_EN_TRAMITE = 0
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM||'
                  AND NOT EXISTS (SELECT 1
                  FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                  JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID = DIS.DD_TPH_ID AND TPH.BORRADO=0
                  WHERE DIS.BORRADO = 0  
                  AND TPH.DD_TPH_CODIGO IN (''02'')
                  AND DIS.ICO_ID = ICO.ICO_ID)';
      
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
END SP_BCR_07_INFORME_COMERCIAL;
/
EXIT;
