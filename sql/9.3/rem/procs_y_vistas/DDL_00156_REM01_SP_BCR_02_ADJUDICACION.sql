--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210804
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14837
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14197] - Daniel Algaba
--##        0.2  Revisión - [HREOS-14344] - Alejandra García
--##        0.3 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - [HREOS-14545] - Daniel Algaba
--##        0.4 Se añade el truncado de la tabla TMP_ACT_SCM y se inserta si un activo pasa a tener Fecha de posesión o al contrario - [HREOS-14686] - Daniel Algaba
--##	      0.5 Se añade el FLAG EN REM en la insercción de la TMP_ACT_SCM - [HREOS-14837] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_02_ADJUDICACION
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

      SALIDA := SALIDA || '[INFO] TRUNCAMOS TMP_ACT_SCM  [INFO]'|| CHR(10);

      #ESQUEMA#.OPERACION_DDL.DDL_Table('TRUNCATE','TMP_ACT_SCM');

      V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_ACT_SCM (
                    ACT_ID
                    , FECHA_CALCULO
                  )
                  SELECT
                     DISTINCT ACT.ACT_ID
                     , SYSDATE
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION ADJ ON ACT.BIE_ID = ADJ.BIE_ID AND ADJ.BORRADO = 0
                  WHERE APR.FEC_POSESION IS NULL AND ADJ.BIE_ADJ_F_REA_POSESION IS NOT NULL
                  OR APR.FEC_POSESION IS NOT NULL AND ADJ.BIE_ADJ_F_REA_POSESION IS NULL 
                  OR TO_DATE(APR.FEC_POSESION,''yyyymmdd'') <> ADJ.BIE_ADJ_F_REA_POSESION
                  AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'';

      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '[INFO] SE HAN INSERTADO '|| SQL%ROWCOUNT||' REGISTROS EN TMP_ACT_SCM [INFO]'|| CHR(10);

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE ADJUDICACIÓN.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - BIE_ADJ_ADJUDICACION'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION ADJ
                  USING (
                  SELECT 
                  BIE_ADJ.BIE_ADJ_ID
                  , BIE.BIE_ID
                  , TO_DATE(APR.FEC_TITULO_FIRME,''yyyymmdd'') BIE_ADJ_F_DECRETO_FIRME
                  , TO_DATE(APR.FEC_SENYAL_LANZAMIENTO,''yyyymmdd'') BIE_ADJ_F_SEN_LANZAMIENTO
                  , TO_DATE(APR.FEC_LANZAMIENTO,''yyyymmdd'') BIE_ADJ_F_REA_LANZAMIENTO
                  , TO_DATE(APR.FEC_RESOLUCION_MORA,''yyyymmdd'') BIE_ADJ_F_RES_MORATORIA
                  , TO_DATE(APR.FEC_POSESION,''yyyymmdd'') BIE_ADJ_F_REA_POSESION
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION BIE_ADJ ON BIE_ADJ.BIE_ID = BIE.BIE_ID AND BIE_ADJ.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (ADJ.BIE_ADJ_ID = AUX.BIE_ADJ_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  ADJ.BIE_ADJ_F_DECRETO_FIRME = AUX.BIE_ADJ_F_DECRETO_FIRME
                  , ADJ.BIE_ADJ_F_SEN_LANZAMIENTO = AUX.BIE_ADJ_F_SEN_LANZAMIENTO
                  , ADJ.BIE_ADJ_F_REA_LANZAMIENTO = AUX.BIE_ADJ_F_REA_LANZAMIENTO
                  , ADJ.BIE_ADJ_F_RES_MORATORIA = AUX.BIE_ADJ_F_RES_MORATORIA
                  , ADJ.BIE_ADJ_F_REA_POSESION = AUX.BIE_ADJ_F_REA_POSESION
                  , ADJ.USUARIOMODIFICAR = ''STOCK_BC''
                  , ADJ.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (BIE_ADJ_ID
                  , BIE_ID
                  , BIE_ADJ_F_DECRETO_FIRME
                  , BIE_ADJ_F_SEN_LANZAMIENTO
                  , BIE_ADJ_F_REA_LANZAMIENTO
                  , BIE_ADJ_F_RES_MORATORIA
                  , BIE_ADJ_F_REA_POSESION
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_BIE_ADJ_ADJUDICACION.nextval
                  , AUX.BIE_ID
                  , AUX.BIE_ADJ_F_DECRETO_FIRME
                  , AUX.BIE_ADJ_F_SEN_LANZAMIENTO
                  , AUX.BIE_ADJ_F_REA_LANZAMIENTO
                  , AUX.BIE_ADJ_F_RES_MORATORIA
                  , AUX.BIE_ADJ_F_REA_POSESION
                  , ''STOCK_BC''
                  , SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 2 - ACT_AJD_ADJJUDICIAL'|| CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_AJD_ADJJUDICIAL AJD
                  USING (
                  SELECT 
                  BIE_ADJ.BIE_ADJ_ID
                  , ACT.ACT_ID
                  , TO_DATE(APR.FEC_ADJUDICACION,''yyyymmdd'') AJD_FECHA_ADJUDICACION
                  , APR.NUM_AUTOS_JUZGADO AJD_NUM_AUTO
                  , AJD.AJD_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND TTA.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION BIE_ADJ ON BIE_ADJ.BIE_ID = BIE.BIE_ID AND BIE_ADJ.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_AJD_ADJJUDICIAL AJD ON BIE_ADJ.BIE_ADJ_ID = AJD.BIE_ADJ_ID AND AJD.BORRADO = 0
                  WHERE TTA.DD_TTA_CODIGO = ''01''
                  AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (AJD.AJD_ID = AUX.AJD_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  AJD.AJD_FECHA_ADJUDICACION = AUX.AJD_FECHA_ADJUDICACION
                  , AJD.AJD_NUM_AUTO = AUX.AJD_NUM_AUTO
                  , AJD.USUARIOMODIFICAR = ''STOCK_BC''
                  , AJD.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (AJD_ID
                  , BIE_ADJ_ID
                  , ACT_ID
                  , AJD_FECHA_ADJUDICACION
                  , AJD_NUM_AUTO
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_ACT_AJD_ADJJUDICIAL.nextval
                  , AUX.BIE_ADJ_ID
                  , AUX.ACT_ID
                  , AUX.AJD_FECHA_ADJUDICACION
                  , AUX.AJD_NUM_AUTO
                  , ''STOCK_BC''
                  , SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 3 - ACT_ADN_ADJNOJUDICIAL'|| CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL ADN
                  USING (
                  SELECT 
                  ACT.ACT_ID
                  , APR.IMPORTE_CESION ADN_VALOR_ADQUISICION
                  , TO_DATE(APR.FEC_CESION_REMATE,''yyyymmdd'') ADN_FECHA_TITULO
                  , ADN.ADN_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TTA_TIPO_TITULO_ACTIVO TTA ON TTA.DD_TTA_ID = ACT.DD_TTA_ID AND TTA.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_ADN_ADJNOJUDICIAL ADN ON ADN.ACT_ID = ACT.ACT_ID AND ADN.BORRADO = 0
                  WHERE TTA.DD_TTA_CODIGO = ''02''
                  AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (ADN.ADN_ID = AUX.ADN_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  ADN.ADN_VALOR_ADQUISICION = AUX.ADN_VALOR_ADQUISICION
                  , ADN.ADN_FECHA_TITULO = AUX.ADN_FECHA_TITULO
                  , ADN.USUARIOMODIFICAR = ''STOCK_BC''
                  , ADN.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (ADN_ID
                  , ACT_ID
                  , ADN_VALOR_ADQUISICION
                  , ADN_FECHA_TITULO
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_ACT_ADN_ADJNOJUDICIAL.nextval
                  , AUX.ACT_ID
                  , AUX.ADN_VALOR_ADQUISICION
                  , AUX.ADN_FECHA_TITULO
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
END SP_BCR_02_ADJUDICACION;
/
EXIT;
