--/*
--##########################################
--## AUTOR=Danie Algaba
--## FECHA_CREACION=20220309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17366
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se quita los filtrados - HREOS-15634
--##        0.3 Se añaden nuevos campos a la ICO (ICO_ANO_REHABILITACION y ICO_ANO_CONSTRUCCION) - HREOS-17329 - Javier Esbrí
--##        0.4 Se cambia los campos por el nuevo modelo de Informe comercial - HREOS-17366
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
                  , NVL(TO_NUMBER(APR.ANYO_ULTIMA_REFORMA), ICO.ICO_ANO_REHABILITACION) ICO_ANO_REHABILITACION
                  , ACT.ACT_NUM_ACTIVO_CAIXA AS NUM_IDENTIFICATIVO      
                  , ACT.ACT_NUM_ACTIVO AS NUM_INMUEBLE  
                  , ACT.ACT_ID
                  , NVL(TO_NUMBER(APR.ANYO_CONSTRUCCION),ICO.ICO_ANO_CONSTRUCCION) AS ICO_ANO_CONSTRUCCION
                  , APR.NUM_HABITACIONES/100 ICO_NUM_DORMITORIOS
                  , APR.NUM_BANYOS/100 ICO_NUM_BANYOS
                  , CASE WHEN APR.NUM_TERRAZAS > 0 THEN (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') ELSE (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'') END ICO_TERRAZA
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
                  WHERE ACT.BORRADO = 0
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM||'
               ) AUX
               ON (ICO.ICO_ID = AUX.ICO_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  , ICO.ICO_ANO_REHABILITACION = AUX.ICO_ANO_REHABILITACION
                  , ICO.ICO_ANO_CONSTRUCCION = AUX.ICO_ANO_CONSTRUCCION
				  , ICO.ICO_NUM_DORMITORIOS = NVL(ICO.ICO_NUM_DORMITORIOS, AUX.ICO_NUM_DORMITORIOS)
				  , ICO.ICO_NUM_BANYOS = NVL(ICO.ICO_NUM_BANYOS, AUX.ICO_NUM_BANYOS)
				  , ICO.ICO_TERRAZA = NVL(ICO.ICO_TERRAZA, AUX.ICO_TERRAZA)
                  , ICO.USUARIOMODIFICAR = ''STOCK_BC''
                  , ICO.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (ICO_ID
                  , ACT_ID
                  , ICO_ANO_REHABILITACION
                  , ICO_ANO_CONSTRUCCION
				  , ICO_NUM_DORMITORIOS
				  , ICO_NUM_BANYOS
				  , ICO_TERRAZA
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_ACT_ICO_INFO_COMERCIAL.nextval
                  , AUX.ACT_ID
                  , AUX.ICO_ANO_REHABILITACION
                  , AUX.ICO_ANO_CONSTRUCCION
                  , AUX.ANYO_ULTIMA_REFORMA
				  , AUX.ICO_NUM_DORMITORIOS
			      , AUX.ICO_NUM_BANYOS
				  , AUX.ICO_TERRAZA
                  , ''STOCK_BC''
                  , SYSDATE)';
      
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
