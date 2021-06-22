--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14368
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14222] - Alejandra García
--##        0.2 Cambio de numeración del SP y modificación de los checks de 1 y 0 a S y N respectivamente - [HREOS-14222] - Alejandra García
--##        0.3 Revisión - [HREOS-14344] - Alejandra García
--##        0.4 Formatos númericos en ACT_EN_TRAMITE = 0  - [HREOS-14366] - Daniel Algaba
--##        0.5 Cambiamos años  - [HREOS-14368] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_RBC_07_INFORME_COMERCIAL
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

--1º Merge tabla AUX_APR_RBC_STOCK
   DBMS_OUTPUT.PUT_LINE('[INFO] 1 MERGE A LA TABLA AUX_APR_RBC_STOCK.');

    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK AUX
	USING (			
           WITH DISTRIBUCION
           AS( 
                    SELECT
                         DIS.DIS_CANTIDAD AS DIS_CANTIDAD
                        ,DIS.ICO_ID AS ICO_ID
                        ,TPH.DD_TPH_CODIGO AS DD_TPH_CODIGO
                    FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                    JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID=DIS.DD_TPH_ID AND TPH.BORRADO=0
                        WHERE DIS.BORRADO=0                
           ), TERRAZAS AS (
                    SELECT
                         SUM(DIS.DIS_CANTIDAD) AS DIS_CANTIDAD
                        ,DIS.ICO_ID AS ICO_ID
                    FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                    JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID=DIS.DD_TPH_ID AND TPH.BORRADO=0
                        WHERE DIS.BORRADO=0  AND TPH.DD_TPH_CODIGO IN (''15'',''16'')
                        GROUP BY DIS.ICO_ID
           ), HABITACIONES AS (
                    SELECT
                         SUM(DIS.DIS_CANTIDAD) AS DIS_CANTIDAD
                        ,DIS.ICO_ID AS ICO_ID
                    FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                    JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID=DIS.DD_TPH_ID AND TPH.BORRADO=0
                        WHERE DIS.BORRADO=0  AND TPH.DD_TPH_CODIGO IN (''01'')
                        GROUP BY DIS.ICO_ID
           ), NUM_BANYOS AS (
                    SELECT
                         SUM(DIS.DIS_CANTIDAD) AS DIS_CANTIDAD
                        ,DIS.ICO_ID AS ICO_ID
                    FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                    JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID=DIS.DD_TPH_ID AND TPH.BORRADO=0
                        WHERE DIS.BORRADO=0  AND TPH.DD_TPH_CODIGO IN (''02'')
                        GROUP BY DIS.ICO_ID
           ), TRASTEROS AS (
                    SELECT
                         SUM(DIS.DIS_CANTIDAD) AS DIS_CANTIDAD
                        ,DIS.ICO_ID AS ICO_ID
                    FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                    JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID=DIS.DD_TPH_ID AND TPH.BORRADO=0
                        WHERE DIS.BORRADO=0  AND TPH.DD_TPH_CODIGO IN (''12'')
                        GROUP BY DIS.ICO_ID
           ), APARCAMIENTOS AS (
                    SELECT
                         SUM(DIS.DIS_CANTIDAD) AS DIS_CANTIDAD
                        ,DIS.ICO_ID AS ICO_ID
                    FROM '|| V_ESQUEMA ||'.ACT_DIS_DISTRIBUCION DIS
                    JOIN '|| V_ESQUEMA ||'.DD_TPH_TIPO_HABITACULO TPH ON TPH.DD_TPH_ID=DIS.DD_TPH_ID AND TPH.BORRADO=0
                        WHERE DIS.BORRADO=0  AND TPH.DD_TPH_CODIGO IN (''11'')
                        GROUP BY DIS.ICO_ID
           )
           SELECT
                 TO_CHAR(ICO.ICO_FECHA_ULTIMA_VISITA,''YYYYMMDD'') AS FEC_VISITA_INMB_SERVICER
                ,ICO.ICO_ANO_CONSTRUCCION AS ANYO_CONSTRUCCION
                ,ICO.ICO_ANO_REHABILITACION AS ANYO_ULTIMA_REFORMA
                ,ACT.ACT_NUM_ACTIVO_CAIXA AS NUM_IDENTIFICATIVO      
                ,ACT.ACT_NUM_ACTIVO AS NUM_INMUEBLE               
                ,CASE
                    WHEN EDIF.EDI_ASCENSOR >0 THEN ''S''
                    ELSE ''N''
                 END AS TIENE_ASCENSOR                
                ,DIST1.DIS_CANTIDAD * 100 AS NUM_HABITACIONES
                ,DIST2.DIS_CANTIDAD * 100 AS NUM_BANYOS
                ,DIST3.DIS_CANTIDAD * 100 AS NUM_TERRAZAS
                ,DIST4.DIS_CANTIDAD * 100 AS NUM_APARACAMIENTOS
                ,CASE
                    WHEN DIST5.DIS_CANTIDAD>0 THEN ''S''
                    ELSE ''N''
                 END AS TIENE_TRASTERO
                ,CASE
                    WHEN DIST4.DIS_CANTIDAD>0 THEN ''S''
                    ELSE ''N''
                 END AS EQUIPAMIENTO_015001                
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
            JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID=ICO.ACT_ID AND ICO.BORRADO=0
            JOIN '|| V_ESQUEMA ||'.ACT_EDI_EDIFICIO EDIF ON EDIF.ICO_ID=ICO.ICO_ID AND EDIF.BORRADO=0    
            LEFT JOIN HABITACIONES DIST1 ON DIST1.ICO_ID=ICO.ICO_ID
            LEFT JOIN NUM_BANYOS DIST2 ON DIST2.ICO_ID=ICO.ICO_ID
            LEFT JOIN TERRAZAS DIST3 ON DIST3.ICO_ID=ICO.ICO_ID 
            LEFT JOIN TRASTEROS DIST4 ON DIST4.ICO_ID=ICO.ICO_ID
            LEFT JOIN APARCAMIENTOS DIST5 ON DIST5.ICO_ID=ICO.ICO_ID
            JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO=''03''
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID AND PAC.PAC_INCLUIDO = 1
            WHERE ACT.BORRADO = 0
            AND ACT.ACT_EN_TRAMITE = 0
            ) US ON (US.NUM_INMUEBLE=AUX.NUM_INMUEBLE)
            WHEN MATCHED THEN UPDATE SET
                 AUX.FEC_VISITA_INMB_SERVICER=US.FEC_VISITA_INMB_SERVICER
                ,AUX.ANYO_CONSTRUCCION=US.ANYO_CONSTRUCCION
                ,AUX.ANYO_ULTIMA_REFORMA=US.ANYO_ULTIMA_REFORMA
                ,AUX.TIENE_ASCENSOR=US.TIENE_ASCENSOR
                ,AUX.NUM_HABITACIONES=US.NUM_HABITACIONES
                ,AUX.NUM_BANYOS=US.NUM_BANYOS
                ,AUX.NUM_TERRAZAS=US.NUM_TERRAZAS
                ,AUX.NUM_APARACAMIENTOS=US.NUM_APARACAMIENTOS
                ,AUX.TIENE_TRASTERO=US.TIENE_TRASTERO
                ,AUX.EQUIPAMIENTO_015001=US.EQUIPAMIENTO_015001   
            WHEN NOT MATCHED THEN INSERT (
                 NUM_IDENTIFICATIVO
                ,NUM_INMUEBLE
                ,FEC_VISITA_INMB_SERVICER
                ,ANYO_CONSTRUCCION
                ,ANYO_ULTIMA_REFORMA
                ,TIENE_ASCENSOR
                ,NUM_HABITACIONES
                ,NUM_BANYOS
                ,NUM_TERRAZAS
                ,NUM_APARACAMIENTOS
                ,TIENE_TRASTERO
                ,EQUIPAMIENTO_015001    
                )VALUES(
                     US.NUM_IDENTIFICATIVO
                    ,US.NUM_INMUEBLE
                    ,US.FEC_VISITA_INMB_SERVICER
                    ,US.ANYO_CONSTRUCCION
                    ,US.ANYO_ULTIMA_REFORMA
                    ,US.TIENE_ASCENSOR
                    ,US.NUM_HABITACIONES
                    ,US.NUM_BANYOS
                    ,US.NUM_TERRAZAS
                    ,US.NUM_APARACAMIENTOS
                    ,US.TIENE_TRASTERO
                    ,US.EQUIPAMIENTO_015001
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
END SP_RBC_07_INFORME_COMERCIAL;
/
EXIT;
