--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17151
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14292] - Daniel Algaba
--##        0.2 Revisión - [HREOS-14344] - Alejandra García
--##        0.3 Formatos númericos en ACT_EN_TRAMITE = 0 - [HREOS-14366] - Daniel Algaba
--##        0.4 Cambio de cálculos - [HREOS-14368] - Daniel Algaba
--##        0.5 Metemos NUM_IDENTFICATIVO como campos de cruce - [HREOS-14368] - Daniel Algaba
--##        0.6 Añadimos Certificado sustitutivo y miramos vigencia de documentos
--##        0.7 Revisión lógica equivalencia Calificación Energética- [HREOS-14974] - Alejandra García
--##	      0.8 Filtramos las consultas para que no salgan los activos titulizados - HREOS-15423
--##        0.9 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##        0.10 Nuevos campos F1.1 - [HREOS-17151] - Daniel Algaba
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
                        , ADO.ADO_FECHA_SOLICITUD
                        , ADO.ADO_FECHA_CADUCIDAD
                        , ADO.EMISION
                        , ADO.LETRA_CONSUMO
                        , ADO.CONSUMO
                        , NVL2(EDC.DD_EDC_CODIGO, ''S'', ''N'') REGISTRO
                        , CFD.CFD_OBLIGATORIO
                        , EDC.DD_EDC_CODIGO
                        , MEC.DD_MEC_CODIGO
                        , ICE.DD_ICE_CODIGO
                        , ADO.DATA_ID_DOCUMENTO
                        , ROW_NUMBER() OVER (PARTITION BY ADO.ACT_ID, ADO.CFD_ID, CFD.DD_TPA_ID, CFD.DD_SAC_ID ORDER BY ADO.DD_EDC_ID NULLS LAST, ADO.ADO_ID DESC) RN
                     FROM '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO
                     JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON ADO.CFD_ID = CFD.CFD_ID AND CFD.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO EDC ON ADO.DD_EDC_ID = EDC.DD_EDC_ID AND EDC.BORRADO = 0
                        --AND EDC.DD_EDC_CODIGO = ''01''
                     LEFT JOIN '||V_ESQUEMA||'.DD_TCE_TIPO_CALIF_ENERGETICA TCE ON ADO.DD_TCE_ID = TCE.DD_TCE_ID AND TCE.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.DD_LEM_LISTA_EMISIONES LEM ON ADO.DD_LEM_ID = LEM.DD_LEM_ID AND LEM.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.DD_MEC_MOTIVO_EXONERACION_CEE MEC ON ADO.DD_MEC_ID = MEC.DD_MEC_ID AND MEC.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.DD_ICE_INCIDENCIA_CEE ICE ON ADO.DD_ICE_ID = ICE.DD_ICE_ID AND ICE.BORRADO = 0
                     WHERE ADO.BORRADO = 0
                        AND TPD.DD_TPD_CODIGO IN (''11'')
                        AND SYSDATE BETWEEN NVL(ADO.ADO_FECHA_SOLICITUD, TO_DATE(''01/01/1900'',''DD/MM/YYYY'')) AND NVL(ADO.ADO_FECHA_CADUCIDAD, TO_DATE(''01/01/2099'',''DD/MM/YYYY''))
                  ), CEH AS (
                     SELECT
                        ADO.ACT_ID
                        , ADO.ADO_ID
                        , ADO.CFD_ID
                        , CFD.DD_TPA_ID
                        , CFD.DD_SAC_ID
                        , NVL(EDC.DD_EDC_CODIGO, ''00'') DD_EDC_CODIGO
                        , CFD.CFD_OBLIGATORIO
                        , ROW_NUMBER() OVER (PARTITION BY ADO.ACT_ID, ADO.CFD_ID, CFD.DD_TPA_ID, CFD.DD_SAC_ID ORDER BY ADO.DD_EDC_ID NULLS LAST, ADO.ADO_ID DESC) RN
                     FROM '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO
                     JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON ADO.CFD_ID = CFD.CFD_ID AND CFD.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO EDC ON ADO.DD_EDC_ID = EDC.DD_EDC_ID AND EDC.BORRADO = 0
                     WHERE ADO.BORRADO = 0
                        AND TPD.DD_TPD_CODIGO = ''13''
                        AND SYSDATE BETWEEN NVL(ADO.ADO_FECHA_SOLICITUD, TO_DATE(''01/01/1900'',''DD/MM/YYYY'')) AND NVL(ADO.ADO_FECHA_CADUCIDAD, TO_DATE(''01/01/2099'',''DD/MM/YYYY''))
                  ), LPO AS (
                     SELECT
                        ADO.ACT_ID
                        , ADO.ADO_ID
                        , ADO.CFD_ID
                        , CFD.DD_TPA_ID
                        , CFD.DD_SAC_ID
                        , NVL(EDC.DD_EDC_CODIGO, ''00'') DD_EDC_CODIGO
                        , CFD.CFD_OBLIGATORIO
                        , ROW_NUMBER() OVER (PARTITION BY ADO.ACT_ID, ADO.CFD_ID, CFD.DD_TPA_ID, CFD.DD_SAC_ID ORDER BY ADO.DD_EDC_ID NULLS LAST, ADO.ADO_ID DESC) RN
                     FROM '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO
                     JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON ADO.CFD_ID = CFD.CFD_ID AND CFD.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO EDC ON ADO.DD_EDC_ID = EDC.DD_EDC_ID AND EDC.BORRADO = 0
                     WHERE ADO.BORRADO = 0
                        AND TPD.DD_TPD_CODIGO = ''12''
                        AND SYSDATE BETWEEN NVL(ADO.ADO_FECHA_SOLICITUD, TO_DATE(''01/01/1900'',''DD/MM/YYYY'')) AND NVL(ADO.ADO_FECHA_CADUCIDAD, TO_DATE(''01/01/2099'',''DD/MM/YYYY''))
                  ), ISU AS (
                     SELECT
                        ADO.ACT_ID
                        , ADO.ADO_ID
                        , ADO.CFD_ID
                        , CFD.DD_TPA_ID
                        , CFD.DD_SAC_ID
                        , NVL(EDC.DD_EDC_CODIGO, ''00'') DD_EDC_CODIGO
                        , CFD.CFD_OBLIGATORIO
                        , ROW_NUMBER() OVER (PARTITION BY ADO.ACT_ID, ADO.CFD_ID, CFD.DD_TPA_ID, CFD.DD_SAC_ID ORDER BY ADO.DD_EDC_ID NULLS LAST, ADO.ADO_ID DESC) RN
                     FROM '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO
                     JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON ADO.CFD_ID = CFD.CFD_ID AND CFD.BORRADO = 0
                     JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
                     LEFT JOIN '||V_ESQUEMA||'.DD_EDC_ESTADO_DOCUMENTO EDC ON ADO.DD_EDC_ID = EDC.DD_EDC_ID AND EDC.BORRADO = 0
                     WHERE ADO.BORRADO = 0
                        AND TPD.DD_TPD_CODIGO IN (''27'', ''121'')
                        AND SYSDATE BETWEEN NVL(ADO.ADO_FECHA_SOLICITUD, TO_DATE(''01/01/1900'',''DD/MM/YYYY'')) AND NVL(ADO.ADO_FECHA_CADUCIDAD, TO_DATE(''01/01/2099'',''DD/MM/YYYY''))
                  )
                  SELECT DISTINCT 
                     ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO
                     , ACT.ACT_NUM_ACTIVO NUM_INMUEBLE
                     , CASE 
                           WHEN CEE.DD_EDC_CODIGO = ''02'' THEN ''X''
                           WHEN CEE.CFD_OBLIGATORIO = 0 THEN ''Y'' 
                           ELSE EQV_TCE.DD_CODIGO_CAIXA 
                       END AS CALIFICACION_ENERGETICA
                     , NVL(CEE.REGISTRO, ''N'') CERTIFICADO_REGISTRADO
                     , TO_CHAR(CEE.ADO_FECHA_SOLICITUD,''YYYYMMDD'') FEC_SOLICITUD
                     , TO_CHAR(CEE.ADO_FECHA_CADUCIDAD,''YYYYMMDD'') FEC_FIN_VIGENCIA
                     , EQV_LEM.DD_CODIGO_CAIXA LISTA_EMISIONES
                     , CEE.EMISION * 100 VALORES_EMISIONES
                     , CEE.LETRA_CONSUMO LISTA_ENERGIA
                     , CEE.CONSUMO * 100 VALOR_ENERGIA
                     , CASE
                        WHEN CEH.DD_EDC_CODIGO = ''01'' THEN 1
                        WHEN CEH.DD_EDC_CODIGO = ''02'' THEN 4
                        WHEN CEH.DD_EDC_CODIGO NOT IN (''01'', ''02'') AND LPO.DD_EDC_CODIGO = ''01'' THEN 3
                        WHEN ISU.DD_EDC_CODIGO = ''01'' THEN 5
                        WHEN CEH.DD_EDC_CODIGO NOT IN (''01'', ''02'') AND CEH.CFD_OBLIGATORIO = 0 THEN 2
                        END CEDULA_HABITABILIDAD
                        , CASE WHEN EQV_MEC.DD_CODIGO_CAIXA IS NOT NULL THEN ''04''
                           WHEN CEE.DD_EDC_CODIGO = ''01'' THEN ''01''
                           WHEN CEE.DATA_ID_DOCUMENTO IS NOT NULL THEN ''02''
                           WHEN CEE.REGISTRO IS NOT NULL THEN ''03''
                           WHEN EQV_ICE.DD_CODIGO_CAIXA IS NOT NULL THEN ''05''
                           END SITUACION_CEE
                        , EQV_MEC.DD_CODIGO_CAIXA MOTIVO_EXONERACION_CEE
                        , EQV_ICE.DD_CODIGO_CAIXA INCIDENCIA_CEE
                        , CEE.DATA_ID_DOCUMENTO NUMERO_CEE
                        , NULL CODIGO_SST
                  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                  JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID AND CRA.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
                  LEFT JOIN CEE ON CEE.ACT_ID = ACT.ACT_ID AND CEE.DD_TPA_ID = ACT.DD_TPA_ID AND (CEE.DD_SAC_ID IS NULL OR CEE.DD_SAC_ID = ACT.DD_SAC_ID) AND CEE.RN = 1
                  LEFT JOIN CEH ON CEH.ACT_ID = ACT.ACT_ID AND CEH.DD_TPA_ID = ACT.DD_TPA_ID AND (CEH.DD_SAC_ID IS NULL OR CEH.DD_SAC_ID = ACT.DD_SAC_ID) AND CEH.RN = 1
                  LEFT JOIN LPO ON LPO.ACT_ID = ACT.ACT_ID AND LPO.DD_TPA_ID = ACT.DD_TPA_ID AND (LPO.DD_SAC_ID IS NULL OR LPO.DD_SAC_ID = ACT.DD_SAC_ID) AND LPO.RN = 1
                  LEFT JOIN ISU ON ISU.ACT_ID = ACT.ACT_ID AND ISU.DD_TPA_ID = ACT.DD_TPA_ID AND (ISU.DD_SAC_ID IS NULL OR ISU.DD_SAC_ID = ACT.DD_SAC_ID) AND ISU.RN = 1
                  LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_TCE ON EQV_TCE.DD_NOMBRE_CAIXA = ''CALIFICACION_ENERGETICA'' AND EQV_TCE.DD_CODIGO_REM = CEE.DD_TCE_CODIGO
                  LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_LEM ON EQV_LEM.DD_NOMBRE_CAIXA = ''LISTA_EMISIONES'' AND EQV_LEM.DD_CODIGO_REM = CEE.DD_LEM_CODIGO
                  LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_MEC ON EQV_MEC.DD_NOMBRE_CAIXA = ''MOTIVO_EXONERACION_CEE'' AND EQV_MEC.DD_CODIGO_REM = CEE.DD_MEC_CODIGO
                  LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_ICE ON EQV_ICE.DD_NOMBRE_CAIXA = ''INCIDENCIA_CEE'' AND EQV_ICE.DD_CODIGO_REM = CEE.DD_ICE_CODIGO
                  WHERE ACT.BORRADO = 0
                     AND CRA.DD_CRA_CODIGO = ''03''
                     AND PAC.PAC_INCLUIDO = 1
                     AND ACT.ACT_EN_TRAMITE = 0
                     AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                     AND PRO.PRO_DOCIDENTIF NOT IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569'',''A80352750'',''A80514466'')
                  ) AUX
                  ON (APR.NUM_INMUEBLE = AUX.NUM_INMUEBLE AND APR.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
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
                  , APR.SITUACION_CEE = AUX.SITUACION_CEE
                  , APR.MOTIVO_EXONERACION_CEE = AUX.MOTIVO_EXONERACION_CEE
                  , APR.INCIDENCIA_CEE = AUX.INCIDENCIA_CEE
                  , APR.NUMERO_CEE = AUX.NUMERO_CEE
                  , APR.CODIGO_SST = AUX.CODIGO_SST
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
                  , CEDULA_HABITABILIDAD
                  , SITUACION_CEE
                  , MOTIVO_EXONERACION_CEE
                  , INCIDENCIA_CEE
                  , NUMERO_CEE
                  , CODIGO_SST)
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
                  , AUX.CEDULA_HABITABILIDAD
                  , AUX.SITUACION_CEE
                  , AUX.MOTIVO_EXONERACION_CEE
                  , AUX.INCIDENCIA_CEE
                  , AUX.NUMERO_CEE
                  , AUX.CODIGO_SST)';
   
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
