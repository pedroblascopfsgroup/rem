--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18227
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18227] - Santi Monzó 
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;                  



CREATE OR REPLACE PROCEDURE SP_EAS_03_ATRIBUTOS_LEGALES
   ( 
   SALIDA OUT VARCHAR2
   )

   AS

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar
   V_COUNT NUMBER(16);
   V_SUBSTR NUMBER(16);
   V_INCREM NUMBER(16);

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN

      SALIDA := '[INICIO]'||CHR(10);


       V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.AUX_APR_ATRIBUTOS_LEGALES';
       EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS EN AUX_APR_ATRIBUTOS_LEGALES.'|| CHR(10);


       V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.AUX_APR_ATRIBUTOS_LEGALES ale
				using (   


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



                ), 
                CEH AS (SELECT
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

                ),
                ISU AS (
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

                ), 
                LPO AS (
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
                ), 
                
                SST AS (
                    SELECT
                    PVE.PVE_DOCIDENTIF CODIGO_SST
                    , ACT_TBJ.ACT_ID
                    , ROW_NUMBER() OVER (PARTITION BY ACT_TBJ.ACT_ID ORDER BY TBJ.TBJ_FECHA_EJECUTADO desc) RN
                    FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                    JOIN '||V_ESQUEMA||'.ACT_TBJ ON TBJ.TBJ_ID = ACT_TBJ.TBJ_ID
                    JOIN '||V_ESQUEMA||'.DD_STR_SUBTIPO_TRABAJO STR ON TBJ.DD_STR_ID = STR.DD_STR_ID AND STR.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVC_ID = TBJ.PVC_ID AND PVC.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0
                    WHERE TBJ.BORRADO = 0
                    AND STR.DD_STR_CODIGO = ''18''
                  ),
                
                ACTIVO_MATRIZ AS (SELECT AGA.AGR_ID, ACT.ACT_ID,ACT.DD_SAC_ID,ACT.DD_TPA_ID
                                FROM ACT_AGR_AGRUPACION AGR
                                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga ON aga.AGR_ID = AGR.AGR_ID AND aga.BORRADO = 0
                                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = aga.ACT_ID AND ACT.BORRADO = 0                                                              
                                WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL
                                AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 1)
                               
                
                SELECT 
                            act.ACT_NUM_ACTIVO AS ZZEXTERNALID,   
                         CEE.DD_EDC_CODIGO,
                           CASE
                            WHEN CEE.DD_MEC_CODIGO IS NOT NULL THEN ''Y''
                            WHEN CEE.DD_ICE_CODIGO IS NOT NULL THEN ''W''
                            WHEN CEE.DD_EDC_CODIGO IS NOT NULL THEN ''X''                      
                            ELSE EQV_TCE.DD_CODIGO_CAIXA
                        END AS ZZ_CALIFENERG,
                           
                 
                            CEE.REGISTRO AS ZZ_CERTREGISTRADO,
                            TO_CHAR(CEE.ADO_FECHA_SOLICITUD,''YYYYMMDD'') AS ZZ_FECSOL,
                            TO_CHAR(CEE.ADO_FECHA_CADUCIDAD,''YYYYMMDD'') AS ZZ_FECFINVIG,
                            EQV_LEM.DD_CODIGO_CAIXA AS ZZ_LISTEMIIS,
                            
                            CEE.EMISION AS ZZ_VALEMISNS,
                            EQV_LEN.DD_CODIGO_CAIXA AS ZZ_LISTENEERG,
                            
                            CEE.CONSUMO AS ZZ_VALENERG,
                            
                            CASE WHEN EQV_MEC.DD_CODIGO_CAIXA IS NOT NULL THEN ''04''
                           WHEN CEE.DD_EDC_CODIGO = ''01'' THEN ''01''
                           WHEN CEE.DATA_ID_DOCUMENTO IS NOT NULL THEN ''02''
                           WHEN CEE.REGISTRO IS NOT NULL THEN ''03''
                           WHEN EQV_ICE.DD_CODIGO_CAIXA IS NOT NULL THEN ''05''
                           END ZZSITUACIONCEE,                          
                            CEE.DATA_ID_DOCUMENTO AS ZZNUMCEE,
                            EQV_MEC.DD_CODIGO_CAIXA AS ZZMOTEXONERACIONCEE,
                            EQV_ICE.DD_CODIGO_CAIXA AS ZZINCIDENCIACEE,          
                            CASE WHEN CEE.DD_EDC_CODIGO IS NOT NULL OR CEE.DATA_ID_DOCUMENTO IS NOT NULL OR EQV_MEC.DD_CODIGO_CAIXA IS NOT NULL OR CEE.REGISTRO IS NOT NULL OR EQV_ICE.DD_CODIGO_CAIXA IS NOT NULL THEN SST.CODIGO_SST END ZZCODIGOSST,                        
                            NULL AS ZZ_NUMEXPED,
                            NULL AS ZZPLANVPO,
                            NULL AS ZZPLANVPODESCRIPCION,
                            NULL AS ZZREGIMENTRANSMISION,
                            NULL AS ZZFECHAPROTECCIONINICIO,
                            NULL AS ZZFECHAPROTECCIONFIN,
                            NULL AS ZZFECHAPROHIBICDISPOFIN,
                            NULL AS ZZESTADOESTUDIOINICIAL,
                            CASE
                            WHEN CEH.DD_EDC_CODIGO = ''01'' THEN 1
                            WHEN CEH.DD_EDC_CODIGO = ''02'' THEN 4
                            WHEN CEH.DD_EDC_CODIGO NOT IN (''01'', ''02'') AND LPO.DD_EDC_CODIGO = ''01'' THEN 3
                            WHEN ISU.DD_EDC_CODIGO = ''01'' THEN 5
                            WHEN CEH.DD_EDC_CODIGO NOT IN (''01'', ''02'') AND CEH.CFD_OBLIGATORIO = 0 THEN 2
                            END ZZ_CEDHABIT
                                
                                
                                                      
                            FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION agr
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO aga ON aga.AGR_ID = AGR.AGR_ID AND aga.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = aga.ACT_ID AND ACT.BORRADO = 0     
                            JOIN ACTIVO_MATRIZ MAT ON MAT.AGR_ID = AGR.AGR_ID                                                                      
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA cra ON cra.DD_CRA_ID = ACT.DD_CRA_ID  AND cra.BORRADO= 0     
                            JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac ON pac.ACT_ID = ACT.ACT_ID AND pac.BORRADO = 0                                                                      
                           
                           
                            LEFT JOIN CEE ON CEE.ACT_ID = MAT.ACT_ID AND CEE.DD_TPA_ID = MAT.DD_TPA_ID AND (CEE.DD_SAC_ID IS NULL OR CEE.DD_SAC_ID = MAT.DD_SAC_ID) AND CEE.RN = 1
                            LEFT JOIN CEH ON CEH.ACT_ID = MAT.ACT_ID AND CEH.DD_TPA_ID = MAT.DD_TPA_ID AND (CEH.DD_SAC_ID IS NULL OR CEH.DD_SAC_ID = MAT.DD_SAC_ID) AND CEH.RN = 1
                            LEFT JOIN ISU ON ISU.ACT_ID = MAT.ACT_ID AND ISU.DD_TPA_ID = MAT.DD_TPA_ID AND (ISU.DD_SAC_ID IS NULL OR ISU.DD_SAC_ID = MAT.DD_SAC_ID) AND ISU.RN = 1
                            LEFT JOIN LPO ON LPO.ACT_ID = MAT.ACT_ID AND LPO.DD_TPA_ID = MAT.DD_TPA_ID AND (LPO.DD_SAC_ID IS NULL OR LPO.DD_SAC_ID = MAT.DD_SAC_ID) AND LPO.RN = 1
                            LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_ICE ON EQV_ICE.DD_NOMBRE_CAIXA = ''INCIDENCIA_CEE'' AND EQV_ICE.DD_CODIGO_REM = CEE.DD_ICE_CODIGO AND EQV_ICE.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_MEC ON EQV_MEC.DD_NOMBRE_CAIXA = ''MOTIVO_EXONERACION_CEE'' AND EQV_MEC.DD_CODIGO_REM = CEE.DD_MEC_CODIGO AND EQV_MEC.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_TCE ON EQV_TCE.DD_NOMBRE_CAIXA = ''CALIFICACION_ENERGETICA'' AND EQV_TCE.DD_CODIGO_REM = CEE.DD_TCE_CODIGO
                            LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_LEM ON EQV_LEM.DD_NOMBRE_CAIXA = ''LISTA_EMISIONES'' AND EQV_LEM.DD_CODIGO_REM = CEE.DD_LEM_CODIGO
                            LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV_LEN ON EQV_LEN.DD_NOMBRE_CAIXA = ''LISTA_EMISIONES'' AND EQV_LEN.DD_CODIGO_REM = CEE.LETRA_CONSUMO
                            LEFT JOIN SST ON SST.ACT_ID = MAT.ACT_ID AND SST.RN = 1
                            WHERE AGR.BORRADO = 0 
                            AND cra.DD_CRA_CODIGO = ''03''
                            AND pac.PAC_INCLUIDO = 1
                            AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'')
                            AND agr.AGR_FECHA_BAJA IS NULL
                            AND AGA.AGA_PRINCIPAL = 0  

                             ) us ON (us.ZZEXTERNALID = ale.ZZEXTERNALID)                          

                                 WHEN NOT MATCHED THEN
                                 INSERT     (ZZEXTERNALID,
                                            ZZ_CALIFENERG,
                                            ZZ_CERTREGISTRADO,
                                            ZZ_FECSOL,
                                            ZZ_FECFINVIG,
                                            ZZ_LISTEMIIS,
                                            ZZ_VALEMISNS,
                                            ZZ_LISTENEERG,
                                            ZZ_VALENERG,
                                            ZZSITUACIONCEE,
                                            ZZNUMCEE,
                                            ZZMOTEXONERACIONCEE,
                                            ZZINCIDENCIACEE,
                                            ZZCODIGOSST,
                                            ZZ_NUMEXPED,
                                            ZZPLANVPO,
                                            ZZPLANVPODESCRIPCION,
                                            ZZREGIMENTRANSMISION,
                                            ZZFECHAPROTECCIONINICIO,
                                            ZZFECHAPROTECCIONFIN,
                                            ZZFECHAPROHIBICDISPOFIN,
                                            ZZESTADOESTUDIOINICIAL,
                                            ZZ_CEDHABIT
                                          )
                                        VALUES (
                                            us.ZZEXTERNALID,
                                            us.ZZ_CALIFENERG,
                                            us.ZZ_CERTREGISTRADO,
                                            us.ZZ_FECSOL,
                                            us.ZZ_FECFINVIG,
                                            us.ZZ_LISTEMIIS,
                                            us.ZZ_VALEMISNS,
                                            us.ZZ_LISTENEERG,
                                            us.ZZ_VALENERG,
                                            us.ZZSITUACIONCEE,
                                            us.ZZNUMCEE,
                                            us.ZZMOTEXONERACIONCEE,
                                            us.ZZINCIDENCIACEE,
                                            us.ZZCODIGOSST,
                                            us.ZZ_NUMEXPED,
                                            us.ZZPLANVPO,
                                            us.ZZPLANVPODESCRIPCION,
                                            us.ZZREGIMENTRANSMISION,
                                            us.ZZFECHAPROTECCIONINICIO,
                                            us.ZZFECHAPROTECCIONFIN,
                                            us.ZZFECHAPROHIBICDISPOFIN,
                                            us.ZZESTADOESTUDIOINICIAL,
                                            us.ZZ_CEDHABIT)';

   EXECUTE IMMEDIATE V_MSQL;


   SALIDA := SALIDA || '   [INFO] MERGE TERMINADO ';   
COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_EAS_03_ATRIBUTOS_LEGALES;
/
EXIT;
