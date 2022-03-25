--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220304
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17497
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Añadimos provincia de registro - HREOS-14533
--##        0.3 Añadimos nombre y número de registro de la propiedad - HREOS-14545
--##	      0.4 Se cambia el mapeo de INSCRIPCION al campo BIE_DREG_NUM_REGISTRO - HREOS-14837
--##	      0.5 Corrección de localidad, región y país - HREOS-14837
--##	      0.6 Corrección de latitud y longitud - HREOS-15423
--##	      0.7 Mejora de validaciones para latitud y longitud - HREOS-15423
--##	      0.8 Modificar la consulta para la equivalencia COMPLEMENTO - HREOS-15855
--##	      0.9 Se modifica la población para cruzar por el código, que es el código INE - HREOS-16321
--##	      0.10 Correcciones - HREOS-16321
--##	      0.11 Adaptación nuevo modelo catastro - HREOS-16866
--##	      0.12 Añadir campo idufir - HREOS-17150 - Javier Esbrí
--##	      0.13 Añadir campos nuevos REG_SUPERFICIE_SOBRE_RASANTE y REG_SUPERFICIE_BAJO_RASANTE - HREOS-17329 - Javier Esbrí
--##	      0.14 Añadir campos nuevos REG_SUPERFICIE_PARCELA - HREOS-17351 - Javier Esbrí
--##	      0.15 Corrección REG_SUPERFICIE_SOBRE_RASANTE y REG_SUPERFICIE_BAJO_RASANTE - HREOS-17497 - Daniel Algaba
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
   V_COUNT_CATASTRO NUMBER(10) := 0; -- Variable auxiliar

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
                  , APR.NUMERO_REGISTRO_PROPIEDAD BIE_DREG_NUM_REGISTRO
                  , APR.INSCRIPCION BIE_DREG_INSCRIPCION
                  , APR.NOMBRE_REGISTRO_PROPIEDAD BIE_DREG_MUNICIPIO_LIBRO
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_ID = BIE.BIE_ID AND BDR.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (BDR.BIE_DREG_ID = AUX.BIE_DREG_ID AND BDR.BORRADO = 0)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  BDR.BIE_DREG_NUM_FINCA = AUX.BIE_DREG_NUM_FINCA
                  , BDR.BIE_DREG_LIBRO = AUX.BIE_DREG_LIBRO
                  , BDR.BIE_DREG_TOMO = AUX.BIE_DREG_TOMO
                  , BDR.BIE_DREG_FOLIO = AUX.BIE_DREG_FOLIO
                  , BDR.BIE_DREG_NUM_REGISTRO = AUX.BIE_DREG_NUM_REGISTRO
                  , BDR.BIE_DREG_INSCRIPCION = AUX.BIE_DREG_INSCRIPCION
                  , BDR.BIE_DREG_MUNICIPIO_LIBRO = AUX.BIE_DREG_MUNICIPIO_LIBRO
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
                  , BIE_DREG_NUM_REGISTRO
                  , BIE_DREG_INSCRIPCION
                  , BIE_DREG_MUNICIPIO_LIBRO
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_BIE_DATOS_REGISTRALES.nextval
                  , AUX.BIE_ID
                  , AUX.BIE_DREG_NUM_FINCA
                  , AUX.BIE_DREG_LIBRO
                  , AUX.BIE_DREG_TOMO
                  , AUX.BIE_DREG_FOLIO
                  , AUX.BIE_DREG_NUM_REGISTRO
                  , AUX.BIE_DREG_INSCRIPCION
                  , AUX.BIE_DREG_MUNICIPIO_LIBRO
                  , ''STOCK_BC''
                  , SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 2 - ACT_REG_INFO_REGISTRAL'|| CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL REG
                  USING (
                  SELECT
                  ACT.ACT_ID 
                  , BDR.BIE_DREG_ID
                  , APR.NOMBRE_REGISTRO_PROPIEDAD REG_NOMBRE_REGISTRO
                  , APR.NUMERO_REGISTRO_PROPIEDAD REG_NUMERO_REGISTRO
                  , REG.REG_ID
                  , APR.IDUFIR AS REG_IDUFIR
                  , NVL(APR.SUP_SOBRE_RASANTE, REG.REG_SUPERFICIE_SOBRE_RASANTE)/100 REG_SUPERFICIE_SOBRE_RASANTE
                  , NVL(APR.SUP_BAJO_RASANTE, REG.REG_SUPERFICIE_BAJO_RASANTE)/100 REG_SUPERFICIE_BAJO_RASANTE
                  , NVL(APR.SUP_REG_SOLAR, REG.REG_SUPERFICIE_PARCELA)/100 REG_SUPERFICIE_PARCELA
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_ID = BIE.BIE_ID AND BDR.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID AND REG.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (REG.REG_ID = AUX.REG_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  REG.REG_NOMBRE_REGISTRO = AUX.REG_NOMBRE_REGISTRO
                  , REG.REG_NUMERO_REGISTRO = AUX.REG_NUMERO_REGISTRO
                  , REG.REG_IDUFIR = AUX.REG_IDUFIR
                  , REG.REG_SUPERFICIE_SOBRE_RASANTE = AUX.REG_SUPERFICIE_SOBRE_RASANTE
                  , REG.REG_SUPERFICIE_BAJO_RASANTE = AUX.REG_SUPERFICIE_BAJO_RASANTE
                  , REG.REG_SUPERFICIE_PARCELA = AUX.REG_SUPERFICIE_PARCELA
                  , USUARIOMODIFICAR = ''STOCK_BC''
                  , FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT (REG_ID
                     , ACT_ID
                     , BIE_DREG_ID
                     , REG_NOMBRE_REGISTRO
                     , REG_NUMERO_REGISTRO
                     , REG_IDUFIR
                     , REG_SUPERFICIE_SOBRE_RASANTE
                     , REG_SUPERFICIE_BAJO_RASANTE
                     , REG_SUPERFICIE_PARCELA
                     , USUARIOCREAR
                     , FECHACREAR)
                      VALUES 
                     ('|| V_ESQUEMA ||'.S_ACT_REG_INFO_REGISTRAL.nextval
                     , AUX.ACT_ID
                     , AUX.BIE_DREG_ID
                     , AUX.REG_NOMBRE_REGISTRO
                     , AUX.REG_NUMERO_REGISTRO
                     , AUX.REG_IDUFIR
                     , AUX.REG_SUPERFICIE_SOBRE_RASANTE
                     , AUX.REG_SUPERFICIE_BAJO_RASANTE
                     , AUX.REG_SUPERFICIE_PARCELA
                     , ''STOCK_BC''
                     , SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] INSERTADOS '|| SQL%ROWCOUNT|| CHR(10);

      IF FLAG_EN_REM = 0 THEN

      SALIDA := SALIDA || '   [INFO] 3 - ACT_CAT_CATASTRO'|| CHR(10);

      V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.AUX_CAT_CATASTRO';
   
      EXECUTE IMMEDIATE V_MSQL;

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.AUX_CAT_CATASTRO CAT
                  (ACT_ID, CAT_REF_CATASTRAL)
                  SELECT ACT.ACT_ID , APR.NUM_CARTILLA CAT_REF_CATASTRAL
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  WHERE APR.NUM_CARTILLA IS NOT NULL 
                  AND APR.FLAG_EN_REM = 0
                  AND NOT EXISTS (SELECT 1 FROM ACT_CAT_CATASTRO AUX_CAT WHERE AUX_CAT.ACT_ID = ACT.ACT_ID)';
   
      EXECUTE IMMEDIATE V_MSQL;

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_CAT_CATASTRO T1
                  USING(
                  SELECT DISTINCT CAT.CAT_ID, AUX_CAT.ACT_ID
                  FROM '|| V_ESQUEMA ||'.AUX_CAT_CATASTRO AUX_CAT 
                  INNER JOIN '|| V_ESQUEMA ||'.CAT_CATASTRO CAT ON AUX_CAT.CAT_REF_CATASTRAL = CAT.CAT_REF_CATASTRAL
                  ) T2
                  ON (T1.ACT_ID = T2.ACT_ID)
                  WHEN MATCHED THEN UPDATE SET
                  T1.CAT_ID = T2.CAT_ID';
   
      EXECUTE IMMEDIATE V_MSQL;

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO T1
                  USING(
                  SELECT DISTINCT ACT_ID, CAT_ID
                  FROM '|| V_ESQUEMA ||'.AUX_CAT_CATASTRO WHERE CAT_ID IS NOT NULL) T2
                  ON (T1.ACT_ID = T2.ACT_ID)
                  WHEN NOT MATCHED THEN INSERT (ACT_ID,CAT_ID,CAT_CATASTRO,USUARIOCREAR,FECHACREAR)
                           VALUES (T2.ACT_ID,'|| V_ESQUEMA ||'.S_ACT_CAT_CATASTRO.NEXTVAL,T2.CAT_ID,     
                                    ''STOCK_BC'',SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      V_COUNT_CATASTRO := V_COUNT_CATASTRO + SQL%ROWCOUNT;

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO T1
                  USING(
                  SELECT DISTINCT ACT_ID, CAT_REF_CATASTRAL
                  FROM '|| V_ESQUEMA ||'.AUX_CAT_CATASTRO WHERE CAT_ID IS NULL) T2
                  ON (T1.ACT_ID = T2.ACT_ID)
                  WHEN NOT MATCHED THEN INSERT (ACT_ID,CAT_ID,CAT_REF_CATASTRAL,USUARIOCREAR,FECHACREAR)
                           VALUES (T2.ACT_ID,'|| V_ESQUEMA ||'.S_ACT_CAT_CATASTRO.NEXTVAL,T2.CAT_REF_CATASTRAL,     
                                    ''STOCK_BC'',SYSDATE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      V_COUNT_CATASTRO := V_COUNT_CATASTRO + SQL%ROWCOUNT;

      SALIDA := SALIDA || '   [INFO] INSERTADOS '|| V_COUNT_CATASTRO|| CHR(10);

      REM01.SP_VALIDACION_REF_CATASTRAL();

      ELSE

      SALIDA := SALIDA || '   [INFO] 3 - ACT_CAT_CATASTRO NO PROCEDE EN ACTUALIZACION'|| CHR(10);

      END IF;

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
                  LEFT JOIN (SELECT EQV_TVI.DD_CODIGO_REM, EQV_TVI.DD_CODIGO_CAIXA, ROW_NUMBER() OVER (PARTITION BY EQV_TVI.DD_CODIGO_CAIXA ORDER BY EQV_TVI.PRIORIDAD asc) RN 
                              FROM '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_TVI WHERE EQV_TVI.DD_NOMBRE_CAIXA = ''COMPLEMENTO'' AND EQV_TVI.BORRADO = 0)
                                       EQV_TVI ON EQV_TVI.RN = 1 AND EQV_TVI.DD_CODIGO_CAIXA = APR.COMPLEMENTO
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_TVI_TIPO_VIA TVI ON TVI.DD_TVI_CODIGO = EQV_TVI.DD_CODIGO_REM AND TVI.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = APR.POBLACION AND LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV3 ON EQV3.DD_NOMBRE_CAIXA = ''REGION'' AND EQV3.DD_CODIGO_CAIXA = APR.REGION AND EQV3.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = EQV3.DD_CODIGO_REM AND PRV.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV4 ON EQV4.DD_NOMBRE_CAIXA = ''PAIS'' AND EQV4.DD_CODIGO_CAIXA = APR.PAIS AND EQV4.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA_M||'.DD_CIC_CODIGO_ISO_CIRBE_BKP CIC ON CIC.DD_CIC_CODIGO = EQV4.DD_CODIGO_REM AND CIC.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (BIE_LOC.BIE_LOC_ID = AUX.BIE_LOC_ID AND BIE_LOC.BORRADO = 0)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  BIE_LOC.DD_TVI_ID = NVL(AUX.DD_TVI_ID, BIE_LOC.DD_TVI_ID)
                  , BIE_LOC.BIE_LOC_NOMBRE_VIA = NVL(AUX.BIE_LOC_NOMBRE_VIA, BIE_LOC.BIE_LOC_NOMBRE_VIA)
                  , BIE_LOC.BIE_LOC_NUMERO_DOMICILIO = NVL(AUX.BIE_LOC_NUMERO_DOMICILIO,BIE_LOC.BIE_LOC_NUMERO_DOMICILIO)
                  , BIE_LOC.BIE_LOC_COD_POST = NVL(AUX.BIE_LOC_COD_POST, BIE_LOC.BIE_LOC_COD_POST)
                  , BIE_LOC.DD_LOC_ID = NVL(AUX.DD_LOC_ID,BIE_LOC.DD_LOC_ID)
                  , BIE_LOC.DD_PRV_ID = NVL(AUX.DD_PRV_ID,BIE_LOC.DD_PRV_ID)
                  , BIE_LOC.DD_CIC_ID = NVL(AUX.DD_CIC_ID,BIE_LOC.DD_CIC_ID)
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
                  , CASE WHEN IS_NUMERIC_X_Y(REPLACE(APR.X_GOOGLE, ''.'','','')) = 1 THEN REPLACE(APR.X_GOOGLE, ''.'','','') ELSE NULL END LOC_LONGITUD
                  , CASE WHEN IS_NUMERIC_X_Y(REPLACE(APR.Y_GOOGLE, ''.'','','')) = 1 THEN REPLACE(APR.Y_GOOGLE, ''.'','','') ELSE NULL END LOC_LATITUD
                  , APR.SIGLA_EDIFICIO LOC_BLOQUE
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID AND BIE.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE_LOC ON BIE_LOC.BIE_ID = BIE.BIE_ID AND BIE_LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_LOC_LOCALIZACION ACT_LOC ON ACT_LOC.ACT_ID = ACT.ACT_ID AND ACT_LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA = ''DISTRITO'' AND EQV.DD_CODIGO_CAIXA = APR.DISTRITO AND EQV.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_DIC_DISTRITO_CAIXA DIC ON DIC.DD_DIC_CODIGO = EQV.DD_CODIGO_REM AND DIC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV2 ON EQV2.DD_NOMBRE_CAIXA = ''ALA_EDIFICIO'' AND EQV2.DD_CODIGO_CAIXA = APR.ALA_EDIFICIO AND EQV2.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_ESE_ESCALERA_EDIFICIO ESE ON ESE.DD_ESE_CODIGO = EQV2.DD_CODIGO_REM AND ESE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV3 ON EQV3.DD_NOMBRE_CAIXA = ''PLANTA'' AND EQV3.DD_CODIGO_CAIXA = APR.PLANTA AND EQV3.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_PLN_PLANTA_EDIFICIO PLN ON PLN.DD_PLN_CODIGO = EQV3.DD_CODIGO_REM AND PLN.BORRADO = 0
                  WHERE APR.FLAG_EN_REM = '||FLAG_EN_REM||'
                  ) AUX
                  ON (ACT_LOC.LOC_ID = AUX.LOC_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  ACT_LOC.LOC_DIRECCION_DOS = NVL(AUX.LOC_DIRECCION_DOS,ACT_LOC.LOC_DIRECCION_DOS)
                  , ACT_LOC.DD_DIC_ID = NVL(AUX.DD_DIC_ID,ACT_LOC.DD_DIC_ID)
                  , ACT_LOC.DD_ESE_ID = NVL(AUX.DD_ESE_ID,ACT_LOC.DD_ESE_ID)
                  , ACT_LOC.DD_PLN_ID = NVL(AUX.DD_PLN_ID,ACT_LOC.DD_PLN_ID)
                  , ACT_LOC.LOC_LONGITUD = NVL(ACT_LOC.LOC_LONGITUD,AUX.LOC_LONGITUD)
                  , ACT_LOC.LOC_LATITUD = NVL(ACT_LOC.LOC_LATITUD,AUX.LOC_LATITUD)
                  , ACT_LOC.LOC_BLOQUE = NVL(AUX.LOC_BLOQUE,ACT_LOC.LOC_BLOQUE)
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
