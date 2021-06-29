--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14368
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial [HREOS-14319] y revisión [HREOS-14344]
--##        0.2 Formatos númericos en ACT_EN_TRAMITE = 0 - [HREOS-14366] - Daniel Algaba
--##        0.3 Metemos NUM_IDENTFICATIVO como campos de cruce - [HREOS-14368] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_RBC_06_POSESION_TITULO
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
   V_NUM_FILAS number;

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN

--Merge tabla AUX_APR_RBC_STOCK
   DBMS_OUTPUT.PUT_LINE('[INFO] 1 MERGE A LA TABLA AUX_APR_RBC_STOCK.');

    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK AUX
                USING (
                    SELECT
                         ACT.ACT_NUM_ACTIVO_CAIXA AS NUM_IDENTIFICATIVO      
                        ,ACT.ACT_NUM_ACTIVO AS NUM_INMUEBLE                        
                        ,PAC.PAC_PORC_PROPIEDAD * 100 AS CUOTA
                        ,TGP.DD_TGP_ID AS GRADO_PROPIEDAD
                        ,CASE
                            WHEN SPS.SPS_OCUPADO=1 AND TPA.DD_TPA_CODIGO IN (''02'',''03'') THEN ''S''
                            ELSE ''N''
                        END AS AVISO_OCUP_SERVICER
                    FROM '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO PAC
                    JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON PAC.ACT_ID=ACT.ACT_ID AND ACT.BORRADO=0
                    LEFT JOIN '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD TGP ON TGP.DD_TGP_ID = PAC.DD_TGP_ID AND TGP.BORRADO=0
                    LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''GRADO_PROPIEDAD''  AND eqv1.DD_CODIGO_REM = TGP.DD_TGP_CODIGO AND EQV1.BORRADO=0            
                    JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID=SPS.ACT_ID AND SPS.BORRADO=0
                    JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT TPA ON SPS.DD_TPA_ID=TPA.DD_TPA_ID AND TPA.BORRADO=0
                    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO=''03''
                    JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID AND PAC.PAC_INCLUIDO = 1
                    WHERE PAC.BORRADO=0       
                    AND ACT.ACT_EN_TRAMITE = 0     
                    AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
            ) US ON (US.NUM_INMUEBLE=AUX.NUM_INMUEBLE AND US.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                WHEN MATCHED THEN UPDATE SET
                     AUX.CUOTA=US.CUOTA
                    ,AUX.GRADO_PROPIEDAD=US.GRADO_PROPIEDAD
                    ,AUX.AVISO_OCUP_SERVICER=US.AVISO_OCUP_SERVICER
                WHEN NOT MATCHED THEN INSERT (
                     NUM_IDENTIFICATIVO
                    ,NUM_INMUEBLE
                    ,CUOTA
                    ,GRADO_PROPIEDAD
                    ,AVISO_OCUP_SERVICER
                    )VALUES(
                         US.NUM_IDENTIFICATIVO
                        ,US.NUM_INMUEBLE
                        ,US.CUOTA
                        ,US.GRADO_PROPIEDAD
                        ,US.AVISO_OCUP_SERVICER
                    )
   ';
   EXECUTE IMMEDIATE V_MSQL;
   

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;



COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_RBC_06_POSESION_TITULO;
/
EXIT;
