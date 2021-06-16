--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210616
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14226
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

CREATE OR REPLACE PROCEDURE SP_RBC_04_DOCUMENTOS_ADMISION
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE DOCUMENTOS DE ADMISIÓN.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN A AUX_APR_RBC_STOCK'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK APR
                  USING (
                  WITH CEE AS(
                  SELECT 
                  ADO.ACT_ID
                  , ADO.ADO_ID
                  , ADO.CFD_ID
                  , CFD.DD_TPA_ID
                  , CFD.DD_SAC_ID
                  , TCE.DD_TCE_CODIGO
                  , LEM.DD_LEM_CODIGO
                  , ADO.REGISTRO 
                  , ADO.ADO_FECHA_SOLICITUD 
                  , ADO.ADO_FECHA_CADUCIDAD 
                  , ADO.EMISION 
                  , ADO.LETRA_CONSUMO 
                  , ADO.CONSUMO
                  FROM '|| V_ESQUEMA ||'.ACT_ADO_ADMISION_DOCUMENTO ADO
                  JOIN '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON ADO.CFD_ID = CFD.CFD_ID AND CFD.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_TCE_TIPO_CALIF_ENERGETICA TCE ON ADO.DD_TCE_ID = TCE.DD_TCE_ID AND TCE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_LEM_LISTA_EMISIONES LEM ON ADO.DD_LEM_ID = LEM.DD_LEM_ID AND LEM.BORRADO = 0
                  WHERE ADO.BORRADO = 0
                  AND TPD.DD_TPD_CODIGO IN (''11'')
                  ), CEH AS (
                  SELECT 
                  ADO.ACT_ID
                  , ADO.ADO_ID
                  , ADO.CFD_ID
                  , CFD.DD_TPA_ID
                  , CFD.DD_SAC_ID
                  FROM '|| V_ESQUEMA ||'.ACT_ADO_ADMISION_DOCUMENTO ADO
                  JOIN '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON ADO.CFD_ID = CFD.CFD_ID AND CFD.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
                  WHERE ADO.BORRADO = 0
                  AND TPD.DD_TPD_CODIGO = ''13''
                  )
                  SELECT 
                  DISTINCT ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO
                  , ACT.ACT_NUM_ACTIVO NUM_INMUEBLE
                  , EQV_TCE.DD_CODIGO_CAIXA CALIFICACION_ENERGETICA
                  , CEE.REGISTRO CERTIFICADO_REGISTRADO
                  , CEE.ADO_FECHA_SOLICITUD FEC_SOLICITUD
                  , CEE.ADO_FECHA_CADUCIDAD FEC_FIN_VIGENCIA
                  , EQV_LEM.DD_CODIGO_CAIXA LISTA_EMISIONES
                  , CEE.EMISION VALORES_EMISIONES
                  , CEE.LETRA_CONSUMO LISTA_ENERGIA
                  , CEE.CONSUMO VALOR_ENERGIA
                  , NVL2(CEH.ADO_ID, ''S'', ''N'') CEDULA_HABITABILIDAD
                  FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                  JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                  LEFT JOIN CEE ON CEE.ACT_ID = ACT.ACT_ID AND CEE.DD_TPA_ID = ACT.DD_TPA_ID AND (CEE.DD_SAC_ID IS NULL OR CEE.DD_SAC_ID = ACT.DD_SAC_ID)
                  LEFT JOIN CEH ON CEH.ACT_ID = ACT.ACT_ID AND CEH.DD_TPA_ID = ACT.DD_TPA_ID AND (CEH.DD_SAC_ID IS NULL OR CEH.DD_SAC_ID = ACT.DD_SAC_ID)
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_TCE ON EQV_TCE.DD_NOMBRE_CAIXA = ''CALIFICACION_ENERGETICA'' AND EQV_TCE.DD_CODIGO_REM = CEE.DD_TCE_CODIGO
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV_LEM ON EQV_LEM.DD_NOMBRE_CAIXA = ''LISTA_EMISIONES'' AND EQV_LEM.DD_CODIGO_REM = CEE.DD_LEM_CODIGO
                  WHERE ACT.BORRADO = 0
                  AND CRA.DD_CRA_CODIGO = ''03''
                  AND PAC.PAC_INCLUIDO = 1
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE)
                  WHEN MATCHED THEN
                  UPDATE SET 
                  APR.CALIFICACION_ENERGETICA = AUX.CALIFICACION_ENERGETICA
                  , APR.CERTIFICADO_REGISTRADO = AUX.CERTIFICADO_REGISTRADO
                  , APR.FEC_SOLICITUD = AUX.FEC_SOLICITUD
                  , APR.FEC_FIN_VIGENCIA = AUX.FEC_FIN_VIGENCIA
                  , APR.LISTA_EMISIONES = AUX.LISTA_EMISIONES
                  , APR.VALORES_EMISIONES = AUX.VALORES_EMISIONES
                  , APR.LISTA_ENERGIA = AUX.LISTA_ENERGIA
                  , APR.VALOR_ENERGIA = AUX.VALOR_ENERGIA
                  , APR.CEDULA_HABITABILIDAD = AUX.CEDULA_HABITABILIDAD
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (NUM_IDENTIFICATIVO
                  , NUM_INMUEBLE
                  , CALIFICACION_ENERGETICA
                  , CERTIFICADO_REGISTRADO
                  , FEC_SOLICITUD
                  , FEC_FIN_VIGENCIA
                  , LISTA_EMISIONES
                  , VALORES_EMISIONES
                  , LISTA_ENERGIA
                  , VALOR_ENERGIA
                  , CEDULA_HABITABILIDAD)
                  VALUES 
                  (AUX.NUM_IDENTIFICATIVO
                  , AUX.NUM_INMUEBLE
                  , AUX.CALIFICACION_ENERGETICA
                  , AUX.CERTIFICADO_REGISTRADO
                  , AUX.FEC_SOLICITUD
                  , AUX.FEC_FIN_VIGENCIA
                  , AUX.LISTA_EMISIONES
                  , AUX.VALORES_EMISIONES
                  , AUX.LISTA_ENERGIA
                  , AUX.VALOR_ENERGIA
                  , AUX.CEDULA_HABITABILIDAD)';
   
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
END SP_RBC_04_DOCUMENTOS_ADMISION;
/
EXIT;
