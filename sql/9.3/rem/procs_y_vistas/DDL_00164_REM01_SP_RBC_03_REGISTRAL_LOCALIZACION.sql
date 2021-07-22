--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210722
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14648
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14292] - Daniel Algaba
--##        0.2 Revisión - [HREOS-14344] - Alejandra García
--##        0.3 Formatos númericos en ACT_EN_TRAMITE = 0 - [HREOS-14366] - Daniel Algaba
--##        0.4 Cortamos cadenas - [HREOS-14368] - Daniel Algaba
--##        0.5 Metemos NUM_IDENTFICATIVO como campos de cruce - [HREOS-14368] - Daniel Algaba
--##        0.6 Se corrige error encontrado en la EQV por varios tipos de vía apuntando a diferentes tipos de caixa - [HREOS-14648] -  Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_RBC_03_REGISTRAL_LOCALIZACION
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE REGISTRAL Y LOCALIZACION.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN A AUX_APR_RBC_STOCK DE LA BIE_LOCALIZACION Y ACT_LOC_LOCALIZACION'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK APR
                  USING (
                  SELECT 
                  ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO
                  , ACT.ACT_NUM_ACTIVO NUM_INMUEBLE
                  , EQV_TVI.DD_CODIGO_CAIXA COMPLEMENTO
                  , SUBSTR(BIE_LOC.BIE_LOC_NOMBRE_VIA, 0, 60) CALLE
                  , SUBSTR(BIE_LOC.BIE_LOC_NUMERO_DOMICILIO, 0, 10) NUMERO
                  , BIE_LOC.BIE_LOC_COD_POST APARTADO
                  , LOC.DD_LOC_CODIGO POBLACION
                  , EQV_PRV.DD_CODIGO_CAIXA REGION
                  , EQV_CIC.DD_CODIGO_CAIXA PAIS
                  , ACT_LOC.LOC_DIRECCION_DOS CALLE2
                  , EQV_DIC.DD_CODIGO_CAIXA DISTRITO
                  , EQV_ESE.DD_CODIGO_CAIXA ALA_EDIFICIO
                  , EQV_PLN.DD_CODIGO_CAIXA PLANTA
                  , BIE_LOC.BIE_LOC_PUERTA NUM_UBICACION
                  , REPLACE(ACT_LOC.LOC_LONGITUD, '','',''.'') X_GOOGLE
                  , REPLACE(ACT_LOC.LOC_LATITUD, '','',''.'') Y_GOOGLE
                  , ACT_LOC.LOC_BLOQUE SIGLA_EDIFICIO
                  FROM '|| V_ESQUEMA ||'.BIE_LOCALIZACION BIE_LOC
                  JOIN '|| V_ESQUEMA ||'.ACT_LOC_LOCALIZACION ACT_LOC ON BIE_LOC.BIE_LOC_ID = ACT_LOC.BIE_LOC_ID AND ACT_LOC.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACT_LOC.ACT_ID AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_TVI_TIPO_VIA TVI ON TVI.DD_TVI_ID = BIE_LOC.DD_TVI_ID AND TVI.BORRADO = 0
                  LEFT JOIN (SELECT EQV_TVI.DD_CODIGO_REM, EQV_TVI.DD_CODIGO_CAIXA, ROW_NUMBER() OVER (PARTITION BY EQV_TVI.DD_CODIGO_REM ORDER BY EQV_TVI.DD_CODIGO_CAIXA DESC) RN FROM '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_TVI WHERE EQV_TVI.DD_NOMBRE_CAIXA = ''COMPLEMENTO'') 
                     EQV_TVI ON EQV_TVI.RN = 1 AND EQV_TVI.DD_CODIGO_REM = TVI.DD_TVI_CODIGO
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID AND LOC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = BIE_LOC.DD_PRV_ID AND PRV.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_PRV ON EQV_PRV.DD_NOMBRE_CAIXA = ''REGION'' AND EQV_PRV.DD_CODIGO_REM = PRV.DD_PRV_CODIGO
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_CIC_CODIGO_ISO_CIRBE_BKP CIC ON CIC.DD_CIC_ID = BIE_LOC.DD_CIC_ID AND CIC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_CIC ON EQV_CIC.DD_NOMBRE_CAIXA = ''PAIS'' AND EQV_CIC.DD_CODIGO_REM = CIC.DD_CIC_CODIGO
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_DIC_DISTRITO_CAIXA DIC ON DIC.DD_DIC_ID = ACT_LOC.DD_DIC_ID AND DIC.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_DIC ON EQV_DIC.DD_NOMBRE_CAIXA = ''DISTRITO'' AND EQV_DIC.DD_CODIGO_REM = DIC.DD_DIC_CODIGO
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_ESE_ESCALERA_EDIFICIO ESE ON ESE.DD_ESE_ID = ACT_LOC.DD_ESE_ID AND ESE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_ESE ON EQV_ESE.DD_NOMBRE_CAIXA = ''ALA_EDIFICIO'' AND EQV_ESE.DD_CODIGO_REM = ESE.DD_ESE_CODIGO
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_PLN_PLANTA_EDIFICIO PLN ON PLN.DD_PLN_ID = ACT_LOC.DD_PLN_ID AND PLN.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_PLN ON EQV_PLN.DD_NOMBRE_CAIXA = ''PLANTA'' AND EQV_PLN.DD_CODIGO_REM = PLN.DD_PLN_CODIGO
                  WHERE BIE_LOC.BORRADO = 0
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  AND ACT.ACT_EN_TRAMITE = 0
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE AND APR.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  APR.COMPLEMENTO = AUX.COMPLEMENTO
                  , APR.CALLE = AUX.CALLE
                  , APR.NUMERO = AUX.NUMERO
                  , APR.APARTADO = AUX.APARTADO
                  , APR.POBLACION = AUX.POBLACION
                  , APR.REGION = AUX.REGION
                  , APR.PAIS = AUX.PAIS
                  , APR.CALLE2 = AUX.CALLE2
                  , APR.DISTRITO = AUX.DISTRITO
                  , APR.ALA_EDIFICIO = AUX.ALA_EDIFICIO
                  , APR.PLANTA = AUX.PLANTA
                  , APR.NUM_UBICACION = AUX.NUM_UBICACION
                  , APR.X_GOOGLE = AUX.X_GOOGLE
                  , APR.Y_GOOGLE = AUX.Y_GOOGLE
                  , APR.SIGLA_EDIFICIO = AUX.SIGLA_EDIFICIO
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (NUM_IDENTIFICATIVO
                  , NUM_INMUEBLE
                  , COMPLEMENTO
                  , CALLE
                  , NUMERO
                  , APARTADO
                  , POBLACION
                  , REGION
                  , PAIS
                  , CALLE2
                  , DISTRITO
                  , ALA_EDIFICIO
                  , PLANTA
                  , NUM_UBICACION
                  , X_GOOGLE
                  , Y_GOOGLE
                  , SIGLA_EDIFICIO)
                  VALUES 
                  (AUX.NUM_IDENTIFICATIVO
                  , AUX.NUM_INMUEBLE
                  , AUX.COMPLEMENTO
                  , AUX.CALLE
                  , AUX.NUMERO
                  , AUX.APARTADO
                  , AUX.POBLACION
                  , AUX.REGION
                  , AUX.PAIS
                  , AUX.CALLE2
                  , AUX.DISTRITO
                  , AUX.ALA_EDIFICIO
                  , AUX.PLANTA
                  , AUX.NUM_UBICACION
                  , AUX.X_GOOGLE
                  , AUX.Y_GOOGLE
                  , AUX.SIGLA_EDIFICIO)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 2 - EXTRACCIÓN A AUX_APR_RBC_STOCK DE LA BIE_DATOS_REGISTRALES Y ACT_REG_INFO_REGISTRAL'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK APR
                  USING (
                  SELECT 
                  ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO
                  , ACT.ACT_NUM_ACTIVO NUM_INMUEBLE
                  , SUBSTR(ACT_REG.REG_SUPERFICIE_PARCELA * 100, 0, 10) SUP_TASACION_SOLAR
                  , ACT_REG.REG_SUPERFICIE_PARCELA_UTIL * 100 SUP_TASACION_UTIL
                  , ACT_REG.REG_SUPERFICIE_UTIL * 100 SUP_REGISTRAL_UTIL
                  , BIE_REG.BIE_DREG_SUPERFICIE_CONSTRUIDA * 100 SUP_TASACION_CONSTRUIDA
                  , ACT_REG.REG_SUPERFICIE_SOBRE_RASANTE * 100 SUP_SOBRE_RASANTE
                  , ACT_REG.REG_SUPERFICIE_BAJO_RASANTE * 100 SUP_BAJO_RASANTE
                  FROM '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES BIE_REG
                  JOIN '|| V_ESQUEMA ||'.ACT_REG_INFO_REGISTRAL ACT_REG ON BIE_REG.BIE_DREG_ID = ACT_REG.BIE_DREG_ID AND ACT_REG.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACT_REG.ACT_ID AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                  WHERE BIE_REG.BORRADO = 0
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  AND ACT.ACT_EN_TRAMITE = 0
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE AND APR.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  APR.SUP_TASACION_SOLAR = AUX.SUP_TASACION_SOLAR
                  , APR.SUP_TASACION_UTIL = AUX.SUP_TASACION_UTIL
                  , APR.SUP_REGISTRAL_UTIL = AUX.SUP_REGISTRAL_UTIL
                  , APR.SUP_TASACION_CONSTRUIDA = AUX.SUP_TASACION_CONSTRUIDA
                  , APR.SUP_SOBRE_RASANTE = AUX.SUP_SOBRE_RASANTE
                  , APR.SUP_BAJO_RASANTE = AUX.SUP_BAJO_RASANTE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (NUM_IDENTIFICATIVO
                  , NUM_INMUEBLE
                  , SUP_TASACION_SOLAR
                  , SUP_TASACION_UTIL
                  , SUP_REGISTRAL_UTIL
                  , SUP_TASACION_CONSTRUIDA
                  , SUP_SOBRE_RASANTE
                  , SUP_BAJO_RASANTE)
                  VALUES 
                  (AUX.NUM_IDENTIFICATIVO
                  , AUX.NUM_INMUEBLE
                  , AUX.SUP_TASACION_SOLAR
                  , AUX.SUP_TASACION_UTIL
                  , AUX.SUP_REGISTRAL_UTIL
                  , AUX.SUP_TASACION_CONSTRUIDA
                  , AUX.SUP_SOBRE_RASANTE
                  , AUX.SUP_BAJO_RASANTE)';
   
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 3 - EXTRACCIÓN A AUX_APR_RBC_STOCK DE LA ACT_CAT_CATASTRO'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK APR
                  USING (
                  SELECT 
                  ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO
                  , ACT.ACT_NUM_ACTIVO NUM_INMUEBLE
                  , CAT.CAT_REF_CATASTRAL NUM_CARTILLA
                  FROM (SELECT AUX_CAT.ACT_ID, AUX_CAT.CAT_REF_CATASTRAL, ROW_NUMBER() OVER (PARTITION BY AUX_CAT.ACT_ID ORDER BY AUX_CAT.CAT_ID DESC) RN 
                  FROM '|| V_ESQUEMA ||'.ACT_CAT_CATASTRO AUX_CAT 
                  WHERE AUX_CAT.BORRADO = 0 
                  AND AUX_CAT.CAT_F_BAJA_CATASTRO IS NULL) CAT
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = CAT.ACT_ID AND ACT.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                  WHERE CAT.RN = 1
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  AND ACT.ACT_EN_TRAMITE = 0
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE AND APR.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  APR.NUM_CARTILLA = AUX.NUM_CARTILLA
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (NUM_IDENTIFICATIVO
                  , NUM_INMUEBLE
                  , NUM_CARTILLA)
                  VALUES 
                  (AUX.NUM_IDENTIFICATIVO
                  , AUX.NUM_INMUEBLE
                  , AUX.NUM_CARTILLA)';
   
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
END SP_RBC_03_REGISTRAL_LOCALIZACION;
/
EXIT;
