--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210626
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14198
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

CREATE OR REPLACE PROCEDURE SP_BCR_03_REGISTRAL_LOCALIZACION
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE REGISTRAL Y LOCALIZACIÓN.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - BIE_DATOS_REGISTRALES'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR
                  USING (
                  SELECT 
                  BDR.BIE_DREG_ID
                  , BIE.BIE_ID
                  , APR.FINCA BIE_DREG_NUM_FINCA
                  , APR.LIBRO BIE_DREG_LIBRO
                  , APR.TOMO BIE_DREG_TOMO
                  , APR.FOLIO BIE_DREG_FOLIO
                  , APR.INSCRIPCION BIE_DREG_INSCRIPCION
                  , APR.COD_REGISTRO_PROPIEDAD BIE_DREG_NUM_REGISTRO
                  , LOC.DD_LOC_ID DD_LOC_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_ID = BIE.BIE_ID AND BDR.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''MUNI_REGISTRO_PROPIEDAD'' AND EQV.DD_CODIGO_CAIXA = APR.MUNI_REGISTRO_PROPIEDAD AND EQV.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = EQV.DD_CODIGO_REM AND LOC.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (BDR.BIE_DREG_ID = AUX.BIE_DREG_ID AND BDR.BORRADO = 0)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  BDR.BIE_DREG_NUM_FINCA = AUX.BIE_DREG_NUM_FINCA
                  , BDR.BIE_DREG_LIBRO = AUX.BIE_DREG_LIBRO
                  , BDR.BIE_DREG_TOMO = AUX.BIE_DREG_TOMO
                  , BDR.BIE_DREG_FOLIO = AUX.BIE_DREG_FOLIO
                  , BDR.BIE_DREG_INSCRIPCION = AUX.BIE_DREG_INSCRIPCION
                  , BDR.BIE_DREG_NUM_REGISTRO = AUX.BIE_DREG_NUM_REGISTRO
                  , BDR.DD_LOC_ID = AUX.DD_LOC_ID
                  , BDR.USUARIOMODIFICAR = ''STOCK_BC''
                  , BDR.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (BIE_DREG_ID
                  , BIE_ID
                  , BIE_DREG_NUM_FINCA
                  , BIE_DREG_LIBRO
                  , BIE_DREG_TOMO
                  , BIE_DREG_FOLIO
                  , BIE_DREG_INSCRIPCION
                  , BIE_DREG_NUM_REGISTRO
                  , DD_LOC_ID
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_BIE_DATOS_REGISTRALES.nextval
                  , AUX.BIE_ID
                  , AUX.BIE_DREG_NUM_FINCA
                  , AUX.BIE_DREG_LIBRO
                  , AUX.BIE_DREG_TOMO
                  , AUX.BIE_DREG_FOLIO
                  , AUX.BIE_DREG_INSCRIPCION
                  , AUX.BIE_DREG_NUM_REGISTRO
                  , AUX.DD_LOC_ID
                  , ''STOCK_BC''
                  , SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 2 - ACT_REG_INFO_REGISTRAL'|| CHR(10);

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL REG
                  (
                  REG_ID
                  , ACT_ID
                  , BIE_DREG_ID
                  , USUARIOCREAR
                  , FECHACREAR
                  )
                  SELECT 
                  '|| V_ESQUEMA ||'.S_ACT_REG_INFO_REGISTRAL.nextval REG_ID
                  , ACT.ACT_ID 
                  , BDR.BIE_DREG_ID
                  , ''STOCK_BC''
                  , SYSDATE
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_ID = BIE.BIE_ID AND BDR.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID AND REG.BORRADO = 0
                  WHERE REG.REG_ID IS NULL AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] INSERTADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 3 - ACT_CAT_CATASTRO'|| CHR(10);

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO CAT
                  (
                  CAT_ID
                  , ACT_ID
                  , CAT_REF_CATASTRAL
                  , USUARIOCREAR
                  , FECHACREAR
                  )
                  SELECT 
                  '|| V_ESQUEMA ||'.S_ACT_CAT_CATASTRO.nextval CAT_ID
                  , ACT.ACT_ID 
                  , APR.NUM_CARTILLA CAT_REF_CATASTRAL
                  , ''STOCK_BC''
                  , SYSDATE
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  WHERE APR.NUM_CARTILLA IS NOT NULL 
                  AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  AND NOT EXISTS (SELECT 1 FROM ACT_CAT_CATASTRO AUX_CAT WHERE AUX_CAT.ACT_ID = ACT.ACT_ID)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] INSERTADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 4 - BIE_LOCALIZACION'|| CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE_LOC
                  USING (
                  SELECT 
                  BIE_LOC.BIE_LOC_ID
                  , BIE.BIE_ID
                  , TVI.DD_TVI_ID DD_TVI_ID
                  , APR.CALLE BIE_LOC_NOMBRE_VIA
                  , APR.NUMERO BIE_LOC_NUMERO_DOMICILIO
                  , APR.APARTADO BIE_LOC_COD_POST
                  , LOC.DD_LOC_ID DD_LOC_ID
                  , PRV.DD_PRV_ID DD_PRV_ID
                  , CASE
                     WHEN APR.PAIS IS NULL THEN (SELECT DD_CIC_ID FROM '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE WHERE DD_CIC_CODIGO=''011'')
                     ELSE CIC.DD_CIC_ID 
                    END AS DD_CIC_ID
                  , APR.NUM_UBICACION BIE_LOC_PORTAL
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE_LOC ON BIE_LOC.BIE_ID = BIE.BIE_ID AND BIE_LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''COMPLEMENTO'' AND EQV.DD_CODIGO_CAIXA = APR.COMPLEMENTO AND EQV.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA TVI ON TVI.DD_TVI_CODIGO = EQV.DD_CODIGO_REM AND TVI.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''POBLACION'' AND EQV.DD_CODIGO_CAIXA = APR.POBLACION AND EQV.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = EQV.DD_CODIGO_REM AND LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''REGION'' AND EQV.DD_CODIGO_CAIXA = APR.REGION AND EQV.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = EQV.DD_CODIGO_REM AND PRV.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''PAIS'' AND EQV.DD_CODIGO_CAIXA = APR.PAIS AND EQV.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE_BKP CIC ON CIC.DD_CIC_CODIGO = EQV.DD_CODIGO_REM AND CIC.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (BIE_LOC.BIE_LOC_ID = AUX.BIE_LOC_ID AND BIE_LOC.BORRADO = 0)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  BIE_LOC.DD_TVI_ID = AUX.DD_TVI_ID
                  , BIE_LOC.BIE_LOC_NOMBRE_VIA = AUX.BIE_LOC_NOMBRE_VIA
                  , BIE_LOC.BIE_LOC_NUMERO_DOMICILIO = AUX.BIE_LOC_NUMERO_DOMICILIO
                  , BIE_LOC.BIE_LOC_COD_POST = AUX.BIE_LOC_COD_POST
                  , BIE_LOC.DD_LOC_ID = AUX.DD_LOC_ID
                  , BIE_LOC.DD_PRV_ID = AUX.DD_PRV_ID
                  , BIE_LOC.DD_CIC_ID = AUX.DD_CIC_ID
                  , BIE_LOC.USUARIOMODIFICAR = ''STOCK_BC''
                  , BIE_LOC.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (BIE_LOC_ID
                  , BIE_ID
                  , DD_TVI_ID
                  , BIE_LOC_NOMBRE_VIA
                  , BIE_LOC_NUMERO_DOMICILIO
                  , BIE_LOC_COD_POST
                  , DD_LOC_ID
                  , DD_PRV_ID
                  , DD_CIC_ID
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_BIE_LOCALIZACION.nextval
                  , AUX.BIE_ID
                  , AUX.DD_TVI_ID
                  , AUX.BIE_LOC_NOMBRE_VIA
                  , AUX.BIE_LOC_NUMERO_DOMICILIO
                  , AUX.BIE_LOC_COD_POST
                  , AUX.DD_LOC_ID
                  , AUX.DD_PRV_ID
                  , AUX.DD_CIC_ID
                  , ''STOCK_BC''
                  , SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

     SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 5 - ACT_LOC_LOCALIZACION'|| CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_LOC_LOCALIZACION ACT_LOC
                  USING (
                  SELECT 
                  ACT_LOC.LOC_ID
                  , BIE_LOC.BIE_LOC_ID
                  , ACT.ACT_ID
                  , APR.CALLE2 LOC_DIRECCION_DOS
                  , DIC.DD_DIC_ID DD_DIC_ID
                  , ESE.DD_ESE_ID DD_ESE_ID
                  , PLN.DD_PLN_ID DD_PLN_ID
                  , TO_NUMBER(APR.X_GOOGLE) LOC_LONGITUD
                  , TO_NUMBER(APR.Y_GOOGLE) LOC_LATITUD
                  , APR.SIGLA_EDIFICIO LOC_BLOQUE
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE_LOC ON BIE_LOC.BIE_ID = BIE.BIE_ID AND BIE_LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_LOC_LOCALIZACION ACT_LOC ON ACT_LOC.ACT_ID = ACT.ACT_ID AND ACT_LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''DISTRITO'' AND EQV.DD_CODIGO_CAIXA = APR.DISTRITO AND EQV.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_DIC_DISTRITO_CAIXA DIC ON DIC.DD_DIC_CODIGO = EQV.DD_CODIGO_REM AND DIC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''NUMERO'' AND EQV.DD_CODIGO_CAIXA = APR.NUMERO AND EQV.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_ESE_ESCALERA_EDIFICIO ESE ON ESE.DD_ESE_CODIGO = EQV.DD_CODIGO_REM AND ESE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''ALA_EDIFICIO'' AND EQV.DD_CODIGO_CAIXA = APR.ALA_EDIFICIO AND EQV.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_PLN_PLANTA_EDIFICIO PLN ON PLN.DD_PLN_CODIGO = EQV.DD_CODIGO_REM AND PLN.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (ACT_LOC.LOC_ID = AUX.LOC_ID AND ACT_LOC.BORRADO = 0)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  ACT_LOC.LOC_DIRECCION_DOS = AUX.LOC_DIRECCION_DOS
                  , ACT_LOC.DD_DIC_ID = AUX.DD_DIC_ID
                  , ACT_LOC.DD_ESE_ID = AUX.DD_ESE_ID
                  , ACT_LOC.DD_PLN_ID = AUX.DD_PLN_ID
                  , ACT_LOC.LOC_LONGITUD = AUX.LOC_LONGITUD
                  , ACT_LOC.LOC_LATITUD = AUX.LOC_LATITUD
                  , ACT_LOC.LOC_BLOQUE = AUX.LOC_BLOQUE
                  , ACT_LOC.USUARIOMODIFICAR = ''STOCK_BC''
                  , ACT_LOC.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (LOC_ID
                  , ACT_ID
                  , BIE_LOC_ID
                  , LOC_DIRECCION_DOS
                  , DD_DIC_ID
                  , DD_ESE_ID
                  , DD_PLN_ID
                  , LOC_LONGITUD
                  , LOC_LATITUD
                  , LOC_BLOQUE
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_ACT_LOC_LOCALIZACION.nextval
                  , AUX.ACT_ID
                  , AUX.BIE_LOC_ID
                  , AUX.LOC_DIRECCION_DOS
                  , AUX.DD_DIC_ID
                  , AUX.DD_ESE_ID
                  , AUX.DD_PLN_ID
                  , AUX.LOC_LONGITUD
                  , AUX.LOC_LATITUD
                  , AUX.LOC_BLOQUE
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
END SP_BCR_03_REGISTRAL_LOCALIZACION;
/
EXIT;
