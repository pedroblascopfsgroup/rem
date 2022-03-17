--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220316
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17351
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
--##        0.11 Nuevos campos F1.1 - [HREOS-17151] - Daniel Algaba
--##        0.12 Se cambia los campos por el nuevo modelo de Informe comercial - [HREOS-17366] - Daniel Algaba
--##        0.13 Se añaden nuevos campos Infrome comercial - [HREOS-17351] - Javier Esbri
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
                ,ICO.ICO_IDEF_TRASTERO AS IDEN_TRASTERO
                ,CASE
                    WHEN ICO.ICO_NUM_GARAJE > 0 THEN ''S''
                    ELSE ''N''
                 END AS EQUIPAMIENTO_015001
                ,ICO.ICO_IDEF_PLAZA_PARKING AS IDEN_PL_PARKING
                ,CASE
                    WHEN ICO.ICO_CALEFACCION = (SELECT DD_TCL_ID FROM '|| V_ESQUEMA ||'.DD_TCL_TIPO_CLIMATIZACION WHERE DD_TCL_CODIGO = ''01'') THEN ''01''
                    WHEN ICO.ICO_CALEFACCION = (SELECT DD_TCL_ID FROM '|| V_ESQUEMA ||'.DD_TCL_TIPO_CLIMATIZACION WHERE DD_TCL_CODIGO = ''02'') THEN ''01''
                    ELSE ''02''
                END AS CALEFACCION
                ,CASE
                    WHEN ICO.ICO_COCINA_AMUEBLADA = (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') THEN ''01''
                    ELSE ''02''
                 END AS COCINA_EQUIPADA
                , eqv.DD_CODIGO_CAIXA as EST_CONSERVACION
                ,CASE
                    WHEN ICO.ICO_JARDIN = (SELECT DD_DIS_ID FROM '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = ''02'') THEN ''01''
                    WHEN ICO.ICO_JARDIN = (SELECT DD_DIS_ID FROM '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = ''03'') THEN ''01''
                    ELSE ''02''
                END AS JARDIN
                ,CASE
                    WHEN ICO.ICO_JARDIN = (SELECT DD_DIS_ID FROM '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = ''02'') THEN ''01''
                    WHEN ICO.ICO_JARDIN = (SELECT DD_DIS_ID FROM '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = ''03'') THEN ''01''
                    ELSE ''02''
                END AS USO_JARDIN
                ,CASE
                    WHEN ICO.ICO_PISCINA = (SELECT DD_DIS_ID FROM '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = ''02'') THEN ''01''
                    WHEN ICO.ICO_PISCINA = (SELECT DD_DIS_ID FROM '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = ''03'') THEN ''01''
                    ELSE ''02''
                END AS PISCINA
                ,CASE
                    WHEN ICO.ICO_SALIDA_HUMOS = (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') THEN ''01''
                    ELSE ''02''
                END AS SALIDA_HUMOS
                ,CASE
                    WHEN ICO.ICO_TERRAZA = (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'') THEN ''01''
                    ELSE ''02''
                END AS TERRAZA
                ,  REPLACE(REPLACE(ICO.ICO_INFO_DISTRIBUCION_INTERIOR, CHR(10), '' ''), CHR(13), '' '') TXT_COMERCIAL_CAS_1
                ,  REPLACE(REPLACE(EDIF.EDI_DESCRIPCION, CHR(10), '' ''), CHR(13), '' '') TXT_COMERCIAL_CAS_2                
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
            JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID=ICO.ACT_ID AND ICO.BORRADO=0
            JOIN '|| V_ESQUEMA ||'.ACT_EDI_EDIFICIO EDIF ON EDIF.ICO_ID=ICO.ICO_ID AND EDIF.BORRADO=0    
            JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID=ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO=''03''
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID AND PAC.PAC_INCLUIDO = 1
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_ECV_ESTADO_CONSERVACION ECV ON ECV.DD_ECV_ID = ICO.DD_ECV_ID  
            LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv ON eqv.DD_NOMBRE_CAIXA = ''EST_CONSERVACION'' AND eqv.DD_CODIGO_REM = ECV.DD_ECV_CODIGO AND eqv.BORRADO=0 
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
                ,AUX.IDEN_TRASTERO=US.IDEN_TRASTERO
                ,AUX.EQUIPAMIENTO_015001=US.EQUIPAMIENTO_015001   
                ,AUX.IDEN_PL_PARKING=US.IDEN_PL_PARKING
                ,AUX.CALEFACCION=US.CALEFACCION
                ,AUX.COCINA_EQUIPADA=US.COCINA_EQUIPADA
                ,AUX.EST_CONSERVACION=US.EST_CONSERVACION
                ,AUX.JARDIN=US.JARDIN
                ,AUX.USO_JARDIN=US.USO_JARDIN
                ,AUX.PISCINA=US.PISCINA
                ,AUX.TXT_COMERCIAL_CAS_1=US.TXT_COMERCIAL_CAS_1   
                ,AUX.TXT_COMERCIAL_CAS_2=US.TXT_COMERCIAL_CAS_2   
                ,AUX.SALIDA_HUMOS=NVL(AUX.SALIDA_HUMOS, US.SALIDA_HUMOS)
                ,AUX.TERRAZA=US.TERRAZA
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
                ,IDEN_TRASTERO
                ,EQUIPAMIENTO_015001  
                ,IDEN_PL_PARKING
                ,CALEFACCION
                ,COCINA_EQUIPADA
                ,EST_CONSERVACION
                ,JARDIN
                ,USO_JARDIN
                ,PISCINA
                ,TXT_COMERCIAL_CAS_1
                ,TXT_COMERCIAL_CAS_2  
                ,SALIDA_HUMOS
                ,TERRAZA
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
                    ,US.IDEN_TRASTERO
                    ,US.EQUIPAMIENTO_015001
                    ,US.IDEN_PL_PARKING
                    ,US.CALEFACCION
                    ,US.COCINA_EQUIPADA
                    ,US.EST_CONSERVACION
                    ,US.JARDIN
                    ,US.USO_JARDIN
                    ,US.PISCINA
                    ,US.TXT_COMERCIAL_CAS_1
                    ,US.TXT_COMERCIAL_CAS_2
                    ,US.SALIDA_HUMOS
                    ,US.TERRAZA
                )
   ';
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

    SALIDA := SALIDA || '   [INFO] 2 - EXTRACCIÓN ACT_HIC_EST_INF_COMER_HIST Y V_FECHAS_PUB_CANALES'||CHR(10);

    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK AUX
	USING (			
            SELECT
            ACT.ACT_NUM_ACTIVO_CAIXA AS NUM_IDENTIFICATIVO
            , ACT.ACT_NUM_ACTIVO AS NUM_INMUEBLE  
            , NULL EST_COMERCIAL_SERVICER
            , NULL FEC_INICIO_INFORME
            , NULL FEC_FIN_INFORME
            , TO_CHAR(FPC.FECHA_ULTIMA_PUBLICACION_MIN,''YYYYMMDD'') FEC_PUBLI_SERVICER_APIS
            , TO_CHAR(FPC.FECHA_ULTIMA_PUBLICACION_MAY,''YYYYMMDD'') FEC_PUBLI_PORT_INVERSOR
            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
            LEFT JOIN '|| V_ESQUEMA ||'.V_FECHAS_PUB_CANALES FPC ON ACT.ACT_ID = FPC.ACT_ID
            JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''03''
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.PAC_INCLUIDO = 1
            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
            WHERE ACT.BORRADO = 0
            AND ACT.ACT_EN_TRAMITE = 0
            AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
            AND PRO.PRO_DOCIDENTIF NOT IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569'',''A80352750'', ''A80514466'')
            ) US ON (US.NUM_INMUEBLE = AUX.NUM_INMUEBLE AND US.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
            WHEN MATCHED THEN UPDATE SET
                 AUX.EST_COMERCIAL_SERVICER = US.EST_COMERCIAL_SERVICER
                , AUX.FEC_INICIO_INFORME = US.FEC_INICIO_INFORME
                , AUX.FEC_FIN_INFORME = US.FEC_FIN_INFORME
                , AUX.FEC_PUBLI_SERVICER_APIS = US.FEC_PUBLI_SERVICER_APIS
                , AUX.FEC_PUBLI_PORT_INVERSOR = US.FEC_PUBLI_PORT_INVERSOR
            WHEN NOT MATCHED THEN INSERT (
                 NUM_IDENTIFICATIVO
                , NUM_INMUEBLE
                , EST_COMERCIAL_SERVICER
                , FEC_INICIO_INFORME 
                , FEC_FIN_INFORME 
                , FEC_PUBLI_SERVICER_APIS 
                , FEC_PUBLI_PORT_INVERSOR 
                )VALUES(
                     US.NUM_IDENTIFICATIVO
                    , US.NUM_INMUEBLE
                    , US.EST_COMERCIAL_SERVICER
                    , US.FEC_INICIO_INFORME
                    , US.FEC_FIN_INFORME
                    , US.FEC_PUBLI_SERVICER_APIS
                    , US.FEC_PUBLI_PORT_INVERSOR
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
