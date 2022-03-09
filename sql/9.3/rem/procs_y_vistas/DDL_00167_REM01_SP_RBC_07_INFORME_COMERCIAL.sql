--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17366
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
--##        0.6 Metemos NUM_IDENTFICATIVO como campos de cruce - [HREOS-14368] - Daniel Algaba
--##	    0.7 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - HREOS-14545
--##	    0.8 Inclusión de campo TXT_COMERCIAL_CAS - HREOS-14838
--##	    0.9 Filtramos las consultas para que no salgan los activos titulizados - HREOS-15423
--##        0.10 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##        0.11 Se cambia los campos por el nuevo modelo de Informe comercial - [HREOS-17366] - Daniel Algaba
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
    SALIDA := '[INICIO]'||CHR(10);

    SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A EXTRAER INFORME COMERCIAL'|| CHR(10);

    SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN ACT_ICO_INFO_COMERCIAL, ACT_DIS_DISTRIBUCION y ACT_EDI_EDIFICIO'||CHR(10);

    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK AUX
	USING (			
           SELECT
                 TO_CHAR(ICO.ICO_FECHA_ULTIMA_VISITA,''YYYYMMDD'') AS FEC_VISITA_INMB_SERVICER
                ,ICO.ICO_ANO_CONSTRUCCION AS ANYO_CONSTRUCCION
                ,ICO.ICO_ANO_REHABILITACION AS ANYO_ULTIMA_REFORMA
                ,ACT.ACT_NUM_ACTIVO_CAIXA AS NUM_IDENTIFICATIVO      
                ,ACT.ACT_NUM_ACTIVO AS NUM_INMUEBLE               
                ,CASE
                    WHEN ICO.ICO_ASCENSOR = (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') THEN ''S''
                    ELSE ''N''
                 END AS TIENE_ASCENSOR                
                ,ICO.ICO_NUM_DORMITORIOS * 100 AS NUM_HABITACIONES
                ,ICO.ICO_NUM_BANYOS * 100 AS NUM_BANYOS
                ,CASE WHEN ICO.ICO_TERRAZA = (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'')  THEN 1 * 100 ELSE 0 END AS NUM_TERRAZAS
                ,ICO.ICO_NUM_GARAJE * 100 AS NUM_APARACAMIENTOS
                ,CASE
                    WHEN ICO.ICO_ANEJO_TRASTERO = (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') THEN ''S''
                    ELSE ''N''
                 END AS TIENE_TRASTERO
                ,CASE
                    WHEN ICO.ICO_NUM_GARAJE > 0 THEN ''S''
                    ELSE ''N''
                 END AS EQUIPAMIENTO_015001
                ,  REPLACE(REPLACE(ICO.ICO_INFO_DISTRIBUCION_INTERIOR, CHR(10), '' ''), CHR(13), '' '') TXT_COMERCIAL_CAS_1
                ,  REPLACE(REPLACE(EDIF.EDI_DESCRIPCION, CHR(10), '' ''), CHR(13), '' '') TXT_COMERCIAL_CAS_2                
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
            JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID=ICO.ACT_ID AND ICO.BORRADO=0
            JOIN '|| V_ESQUEMA ||'.ACT_EDI_EDIFICIO EDIF ON EDIF.ICO_ID=ICO.ICO_ID AND EDIF.BORRADO=0    
            JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO=''03''
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID AND PAC.PAC_INCLUIDO = 1
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
            WHERE ACT.BORRADO = 0
            AND ACT.ACT_EN_TRAMITE = 0
            AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
            AND PRO.PRO_DOCIDENTIF NOT IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569'',''A80352750'', ''A80514466'')
            ) US ON (US.NUM_INMUEBLE=AUX.NUM_INMUEBLE AND US.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
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
                ,AUX.TXT_COMERCIAL_CAS_1=US.TXT_COMERCIAL_CAS_1   
                ,AUX.TXT_COMERCIAL_CAS_2=US.TXT_COMERCIAL_CAS_2   
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
                ,TXT_COMERCIAL_CAS_1
                ,TXT_COMERCIAL_CAS_2  
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
                    ,US.TXT_COMERCIAL_CAS_1
                    ,US.TXT_COMERCIAL_CAS_2
                )
   ';
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
END SP_RBC_07_INFORME_COMERCIAL;
/
EXIT;
