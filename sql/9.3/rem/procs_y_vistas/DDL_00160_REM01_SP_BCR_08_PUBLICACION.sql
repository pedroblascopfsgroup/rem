--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17716
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-14241
--##	    0.2 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - HREOS-14545
--##	    0.3 Cambios para el lanzamiento del SP de publicaciones y situación comercial - HREOS-14686
--##	    0.4 Se añade el FLAG EN REM en la insercción de la TMP_AGR_DESTINO_COMERCIAL - HREOS-14837
--##	    0.4 Se añade que cuando no viene DESTINO_COMERCIAL sea VR o su destino actual - HREOS-14649
--##	    0.5 Los flags de publicación Caixa siempre se actualizan, también sacamos de la ejecución del SP de publicaciones las agrupaciones restringidas OBREM que estén incluida en otras agrupaciones restringidas - HREOS-15137
--##	    0.6 Correciones perímetros- HREOS-15137
--##	    0.7 Se añade un consulta para insertar activos que no tiene el estado de publicación que debe y se añade flag para los activos/agrupaciones que procese el SP de publicaciones - HREOS-15423
--##	    0.8 El check de Visible gestión comercial se rellena con lo que tenga el de publicar - HREOS-15423
--##	    0.9 Filtrado de activos con ofertas en vuelo - HREOS-15634
--##	    0.10 Se añade paréntesis en consulta - HREOS-15634
--##	    0.11 Se cambia la llamada de SPs de publicaciones a los nuevos para Caixa - HREOS-15634
--##	    0.12 Se añade el vaciado en los situaciones comerciales para posteriormente lanzar el SP SCM de vacíos - HREOS-16087
--##	    0.13 Se recalcula el campo visible gestión comercial cuando pasa a Publicado el activo - HREOS-16087
--##	    0.14 Protegemos las creación de registros en la APU para activos nuevos - HREOS-16321
--##	    0.15 Se recalcula los activos que nos están consistentes con los flags BC - HREOS-16321
--##	    0.16 Filtramos activos para solo lanzar los que no están en estados publicación No publicado, ya sea de venta o alquiler - HREOS-16321
--##	    0.17 Historificación portales - HREOS-16321
--##	    0.18 Filtramos agrupaciones para solo lanzar los que no están en estados publicación No publicado, ya sea de venta o alquiler - HREOS-16321
--##        0.19 Cambio en lógica de ciertas consultas por errores con AND, OR y paréntesis
--##        0.20 Cambio en lógica de perímetros para que mande el check de publicar
--##        0.21 Cambio de cálculo en check Visible gestión comercial
--##        0.22 Cambio de cálculo de oferta viva y perímetros cuando es solo Indicadores API - HREOS-17078
--##        0.23 Se añade el borrado lógico al cursor de agrupaciones - HREOS-17716
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_08_PUBLICACION
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
   V_NUM_TABLAS number;
   V_TABLA VARCHAR2(30 CHAR);

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

   CURSOR ACTIVOS IS
        SELECT DISTINCT TMP.ACT_ID
        FROM #ESQUEMA#.TMP_ACT_DESTINO_COMERCIAL TMP
        JOIN #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = TMP.ACT_ID AND APU.BORRADO = 0
        LEFT JOIN #ESQUEMA#.DD_EPV_ESTADO_PUB_VENTA EPV ON APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0
		LEFT JOIN #ESQUEMA#.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0	
        WHERE NVL(TMP.EJECUTADO, 0) = 0
        AND (EPV.DD_EPV_CODIGO <> '01' OR EPA.DD_EPA_CODIGO <> '01');

   ACT_ID NUMBER(16);

    CURSOR AGRUPACIONES IS
        SELECT DISTINCT TMP.AGR_ID
        FROM #ESQUEMA#.TMP_AGR_DESTINO_COMERCIAL TMP
        WHERE NVL(TMP.EJECUTADO, 0) = 0
        AND EXISTS (SELECT 1
        FROM #ESQUEMA#.ACT_AGR_AGRUPACION AGR
        JOIN #ESQUEMA#.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = AGR.AGR_ID AND AGA.BORRADO = 0
        JOIN #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = AGA.ACT_ID AND APU.BORRADO = 0
        JOIN #ESQUEMA#.DD_EPV_ESTADO_PUB_VENTA EPV ON APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0
        JOIN #ESQUEMA#.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0
        WHERE AGR.BORRADO = 0 AND (EPV.DD_EPV_CODIGO <> '01' OR EPA.DD_EPA_CODIGO <> '01') AND AGR.AGR_ID = TMP.AGR_ID);

   AGR_ID NUMBER(16);

BEGIN
------------------------------------------------------------------------------------------------
-------------------------Lógica a aplicar en campo Destino comercial----------------------------
------------------------------------------------------------------------------------------------
--1º Insertar los activos que cambien de destino comercial en la temporal.

   SALIDA := '[INICIO]'||CHR(10);

   SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS REFERENTES A LA PUBLICACIÓN DEL ACTIVO.'|| CHR(10);

    V_TABLA:='TMP_ACT_DESTINO_COMERCIAL';
    --Comprobamos el dato a insertar
      V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
      EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

      --Si  no existe la tabla
      IF V_NUM_TABLAS < 1 THEN

        SALIDA := SALIDA || '[INFO]: TABLA '''||V_TABLA||''' NO EXISTE'|| CHR(10);

      --Si existe la tabla, lo insertamos
      ELSE

            --Insertar registro en tabla.
            SALIDA := SALIDA || '[INFO] TRUNCAMOS '||V_TABLA||'  [INFO]'|| CHR(10);

            #ESQUEMA#.OPERACION_DDL.DDL_Table('TRUNCATE',V_TABLA);

            SALIDA := SALIDA || '[INFO] TRUNCAMOS TMP_AGR_DESTINO_COMERCIAL  [INFO]'|| CHR(10);

            #ESQUEMA#.OPERACION_DDL.DDL_Table('TRUNCATE','TMP_AGR_DESTINO_COMERCIAL');
            
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'							
                        SELECT ACT.ACT_ID, 0, NULL
                        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                            AND APU.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_IDENTIFICATIVO = ACT.ACT_NUM_ACTIVO_CAIXA
                        JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID
                            AND EPV.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
                            AND EPA.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CBX ON CBX.ACT_ID = ACT.ACT_ID
                            AND CBX.BORRADO = 0
                        WHERE ((EPV.DD_EPV_CODIGO = ''03'' AND (CBX.CBX_PUBL_PORT_PUBL_VENTA = 0 OR CBX.CBX_PUBL_PORT_INV_VENTA = 0))
                            OR (EPA.DD_EPA_CODIGO = ''03'' AND (CBX.CBX_PUBL_PORT_PUBL_ALQUILER = 0 OR CBX.CBX_PUBL_PORT_INV_ALQUILER = 0)))
                        AND AUX.FLAG_EN_REM = '|| FLAG_EN_REM||'';
            EXECUTE IMMEDIATE V_MSQL;
            
            V_NUM_FILAS := sql%rowcount;

            SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN '||V_TABLA||' POR TENER UN ESTADO DE PUBLICACIÓN DIFERENTE AL QUE DEBE [INFO]'|| CHR(10);

            V_MSQL := 'INSERT  INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                            ACT_ID
                        )
                        SELECT
                            ACT.ACT_ID
                        FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                        JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA=''DESTINO_COMERCIAL'' AND EQV.DD_CODIGO_CAIXA = AUX.DESTINO_COMERCIAL AND EQV.BORRADO=0
                        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO_NUEVO ON TCO_NUEVO.DD_TCO_CODIGO = EQV.DD_CODIGO_REM
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID=ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CBX ON CBX.ACT_ID = ACT.ACT_ID AND CBX.BORRADO = 0
                        WHERE AUX.FLAG_EN_REM = '|| FLAG_EN_REM||'
                        AND (APU.DD_TCO_ID <> TCO_NUEVO.DD_TCO_ID OR
                        (CBX.CBX_PUBL_PORT_PUBL_VENTA <> CASE WHEN AUX.PUBLICABLE_PORT_PUBLI_VENTA IN (''S'',''1'') THEN 1 ELSE 0 END
                        OR CBX.CBX_PUBL_PORT_PUBL_ALQUILER <> CASE WHEN AUX.PUBLICABLE_PORT_PUBLI_ALQUI IN (''S'',''1'') THEN 1 ELSE 0 END
                        OR CBX.CBX_PUBL_PORT_INV_VENTA <> CASE WHEN AUX.PUBLICABLE_PORT_INVER_VENTA IN (''S'',''1'') THEN 1 ELSE 0 END
                        OR CBX.CBX_PUBL_PORT_INV_ALQUILER <> CASE WHEN AUX.PUBLICABLE_PORT_INVER_ALQUI IN (''S'',''1'') THEN 1 ELSE 0 END
                        OR CBX.CBX_PUBL_PORT_API_VENTA <> CASE WHEN AUX.PUBLICABLE_PORT_API_VENTA IN (''S'',''1'') THEN 1 ELSE 0 END
                        OR CBX.CBX_PUBL_PORT_API_ALQUILER <> CASE WHEN AUX.PUBLICABLE_PORT_API_ALQUI IN (''S'',''1'') THEN 1 ELSE 0 END))';

            EXECUTE IMMEDIATE V_MSQL;

            V_NUM_FILAS := sql%rowcount;

            SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN '||V_TABLA||' POR TENER UN DESTINO COMERCIAL DIFERENTE [INFO]'|| CHR(10);

--2º Borramos la segunda tabla temporal que se ha creado para almacenar los activos que se van a borrar de la TMP_ACT_DESTINO_COMERCIAL
            SALIDA := SALIDA || '[INFO] TRUNCAMOS TMP_DEST_COMERCIAL_REJECT  [INFO]'|| CHR(10);

            #ESQUEMA#.OPERACION_DDL.DDL_Table('TRUNCATE','TMP_DEST_COMERCIAL_REJECT');

            SALIDA := SALIDA || '[INFO] INSERTAMOS EN TMP_DEST_COMERCIAL_REJECT  [INFO]'|| CHR(10);

            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ (
                            ACT_ID
                            , COD_RECHAZO
                      )
                        SELECT DISTINCT
                            ACT_ID
                            , ''01''
                        FROM(
                        SELECT
                             ACTOFR.ACT_ID AS ACT_ID
                            ,CASE
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND
                                    AUX.DESTINO_COMERCIAL=''VT'' AND
                                    TOF.DD_TOF_CODIGO=''02'' AND
                                    AUX.FLAG_OFERTA_VIVA = 1
                                    THEN 0                     --SI ESTÁ EN ALQUILER(03) Y SE QUIERE CAMBIAR A VENTA(VT) CON OFERTA ALQUILER (02) APROBADA/RESERVADA(NO SE PUEDEN HACER CAMBIOS)
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND
                                    AUX.DESTINO_COMERCIAL=''RT'' AND
                                    TOF.DD_TOF_CODIGO=''01'' AND
                                    AUX.FLAG_OFERTA_VIVA = 1
                                    THEN 0                     --SI ESTÁ EN VENTA(01) Y SE QUIERE CAMBIAR A ALQUILER(RT) CON OFERTA DE VENTA(01) APROBADA/RESERVADA(NO SE PUEDEN HACER CAMBIOS)
                                ELSE 1                         --(SE PUEDE CAMBIAR EL DESTINO COMERCIAL)
                            END AS DESTINO_ACTUAL
                        FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR ON ACTOFR.ACT_ID=ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID=ACTOFR.OFR_ID AND OFR.BORRADO=0
                        JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID=TOF.DD_TOF_ID
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID=ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID=APU.DD_TCO_ID
                        WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
                        )WHERE DESTINO_ACTUAL = ''0''

                     ';

              EXECUTE IMMEDIATE V_MSQL;

              V_NUM_FILAS := sql%rowcount;

            SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN TMP_DEST_COMERCIAL_REJECT POR TENER OFERTAS EN VUELO [INFO]'|| CHR(10);
        END IF;

--3º SEGUNDO insert a TMP_DEST_COMERCIAL_REJECT
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ(--Vemos si todos los activos de una misma agrupación (18) tienen el mismo destino comercial
                    ACT_ID
                    , COD_RECHAZO
                )
                SELECT
                    ACT_ID
                    , ''02''
                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                WHERE EXISTS(
                    WITH DESTINO
                    AS (
                        SELECT
                            COUNT(*)
                            ,AGR_ID
                        FROM(
                            SELECT
                                AUX.DESTINO_COMERCIAL AS DD_TCO_ID
                                ,AGR.AGR_ID AS AGR_ID
                            FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                            JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID=TMP.ACT_ID AND AGA.BORRADO=0
                            JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID=AGR.AGR_ID AND AGR.BORRADO=0
                            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TIPO ON AGR.DD_TAG_ID=TIPO.DD_TAG_ID
                            WHERE TIPO.DD_TAG_CODIGO =''18'' AND SYSDATE BETWEEN COALESCE(AGR_INI_VIGENCIA,AGR_FECHA_ALTA,TO_DATE(''01/01/1999'',''DD/MM/YYYY''))
                                                                            AND COALESCE(AGR_FECHA_BAJA,AGR_FIN_VIGENCIA,TO_DATE(''31/12/2099'',''DD/MM/YYYY''))
                            GROUP BY AUX.DESTINO_COMERCIAL,AGR.AGR_ID
                        )GROUP BY AGR_ID HAVING COUNT(*)>1
                    )SELECT
                        1
                    FROM DESTINO DEST
                    JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID=DEST.AGR_ID
                    WHERE TMP.ACT_ID=AGA.ACT_ID
                    )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS POR TENER DESTINO COMERCIAL DIFERENTE EN UNA RESTRINGIDA OBREM'|| CHR(10);


--4º TERCER insert a TMP_DEST_COMERCIAL_REJECT
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ(--Vemos si todos los activos de restringida venta y restringida alquiler (02,17) tienen el mismo destino comercial
                    ACT_ID
                    , COD_RECHAZO
                )
                SELECT
                    ACT_ID
                    , ''03''
                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                WHERE EXISTS(
                    WITH DESTINO
                        AS (
                            SELECT DISTINCT --Sacamos la agrupación que no cumpla con la validación de abajo (CAMBIO=0), es decir, que no puede haber cambio
                                AGR_ID
                            FROM(
                                SELECT
                                    AGR.AGR_ID AS AGR_ID
                                    ,CASE
                                        WHEN AUX.DESTINO_COMERCIAL=''VT'' AND  TIPO.DD_TAG_CODIGO=''17'' THEN 0 --Si el destino comercial es venta (VT) y la agrupación es restringida alquiler (17) (NO PUEDE CAMBIAR EL DESTINO)
                                        WHEN AUX.DESTINO_COMERCIAL=''RT'' AND  TIPO.DD_TAG_CODIGO=''02'' THEN 0 --Si el destino comercial es alquiler (RT) y la agrupación es restringida venta (02) (NO PUEDE CAMBIAR EL DESTINO)
                                        ELSE 1
                                    END AS CAMBIO
                                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                                JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID=TMP.ACT_ID AND AGA.BORRADO=0
                                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID=AGR.AGR_ID AND AGR.BORRADO=0
                                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TIPO ON AGR.DD_TAG_ID=TIPO.DD_TAG_ID
                                WHERE TIPO.DD_TAG_CODIGO IN (''02'',''17'') AND SYSDATE BETWEEN COALESCE(AGR_INI_VIGENCIA,AGR_FECHA_ALTA,TO_DATE(''01/01/1999'',''DD/MM/YYYY''))
                                                                                AND COALESCE(AGR_FECHA_BAJA,AGR_FIN_VIGENCIA,TO_DATE(''31/12/2099'',''DD/MM/YYYY''))
                            )WHERE CAMBIO=0
                        )SELECT
                            1
                        FROM DESTINO DEST
                        JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID=DEST.AGR_ID
                        WHERE TMP.ACT_ID=AGA.ACT_ID
                    )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS POR CAMBIAR EL DESTINO COMERCIAL A UNO INCORRECTO ESTANDO EN ALGUNA AGRUPACIÓN RESTRINGIDA VENTA Y RESTRINGIDA ALQUILER'|| CHR(10);

--5º Delete de los activos insertados en TMP_DEST_COMERCIAL_REJECT en la tabla TMP_ACT_DESTINO_COMERCIAL
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                WHERE EXISTS(
                    SELECT
                        1
                    FROM '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ
                    WHERE TMP.ACT_ID=TREJ.ACT_ID
                )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS BORRADAS POR ESTAR LOS ACTIVOS RECHAZADOS'|| CHR(10);

--6º Insert de los activos borrados a la tabla AUX_APR_BCR_STOCK_REJ de errores
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_APR_BCR_STOCK_REJ REJ(
                    ERRORCODE
                    ,ERRORMESSAGE
                    ,ROWREJECTED
                )
                SELECT
                    ''SP_08-01'' AS ERRORCODE
                    , ''Rechazado intento de cambio de destino comercial cuando el activo tiene una oferta en vuelo.'' AS ERRORMESSAGE
                    , ACT.ACT_NUM_ACTIVO_CAIXA  AS ROWREJECTED
                FROM '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TREJ.ACT_ID AND ACT.BORRADO=0
                WHERE TREJ.COD_RECHAZO = ''01''
   ';
   EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;
    SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS EN AUX_APR_BCR_STOCK_REJ POR ACTIVO CON OFERTAS EN VUELO'|| CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_APR_BCR_STOCK_REJ REJ(
                    ERRORCODE
                    ,ERRORMESSAGE
                    ,ROWREJECTED
                )
                SELECT
                    ''SP_08-02'' AS ERRORCODE
                    , ''Rechazado intento de cambio de destino comercial por agrupación restringida obrem, todos deben tener el mismo destino.'' AS ERRORMESSAGE
                    , ACT.ACT_NUM_ACTIVO_CAIXA  AS ROWREJECTED
                FROM '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TREJ.ACT_ID AND ACT.BORRADO=0
                WHERE TREJ.COD_RECHAZO = ''02''
   ';
   EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;
    SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS EN AUX_APR_BCR_STOCK_REJ POR ACTIVOS EN AGRUPACIÓN RESTRINGIDA OBREM CON DESTINOS DIFERENTES'|| CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_APR_BCR_STOCK_REJ REJ(
                    ERRORCODE
                    ,ERRORMESSAGE
                    ,ROWREJECTED
                )
                SELECT
                    ''SP_08-03'' AS ERRORCODE
                    , ''Rechazado intento de cambio de destino comercial por agrupación de tipos restringida venta y restringida alquiler.'' AS ERRORMESSAGE
                    , ACT.ACT_NUM_ACTIVO_CAIXA  AS ROWREJECTED
                FROM '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TREJ.ACT_ID AND ACT.BORRADO=0
                WHERE TREJ.COD_RECHAZO = ''03''
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS EN AUX_APR_BCR_STOCK_REJ POR CAMBIO DE DESTINO EN AGRUPACIONES RESTRINGIDA VENTA Y RESTRINGIDA ALQUILER'|| CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_AGR_DESTINO_COMERCIAL (
                    AGR_ID
                )
                SELECT DISTINCT AGR.AGR_ID
                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON TMP.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID AND AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL
                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 AND TAG.DD_TAG_CODIGO IN (''02'',''17'',''18'')';

    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;

    SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN TMP_AGR_DESTINO_COMERCIAL POR ESTAR DENTRO DE UNA AGRUPACIÓN RESTRINGIDA [INFO]'|| CHR(10);

--7º Actualización del histórico
--Modificamos en el caso de que ya exista un registro en la histórica
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.HDC_HIST_DESTINO_COMERCIAL HIST
	            USING (
                    SELECT
                        DISTINCT TMP.ACT_ID AS ACT_ID
                    FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                )US ON (US.ACT_ID = HIST.ACT_ID)
                WHEN MATCHED THEN UPDATE SET
                     HIST.HDC_FECHA_FIN=SYSDATE
                    ,HIST.HDC_GESTOR_ACTUALIZACION=''STOCK_BC''
                    ,HIST.USUARIOMODIFICAR = ''STOCK_BC''
                    ,HIST.FECHAMODIFICAR = SYSDATE
                    WHERE HIST.HDC_FECHA_FIN IS NULL  AND HIST.BORRADO=0
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS MODIFICADAS'|| CHR(10);

--Insertamos tanto si es el primer registro del activo como si ya tenía, puesto que el punto anterior se le ha puesto fecha de fin al existente
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.HDC_HIST_DESTINO_COMERCIAL HIST(
                     HIST.HDC_ID
                    ,HIST.ACT_ID
                    ,HIST.DD_TCO_ID
                    ,HIST.HDC_FECHA_INICIO
                    ,HIST.HDC_FECHA_FIN
                    ,HIST.HDC_GESTOR_ACTUALIZACION
                    ,HIST.USUARIOCREAR
                    ,HIST.FECHACREAR
                )SELECT
                    '||V_ESQUEMA||'.S_HDC_HIST_DESTINO_COMERCIAL.NEXTVAL AS HDC_ID
                    ,TMP.ACT_ID AS ACT_ID
                    , NVL(TCO.DD_TCO_ID, APU.DD_TCO_ID)  AS DD_TCO_ID
                    ,SYSDATE AS HDC_FECHA_INICIO
                    ,NULL AS HDC_FECHA_FIN
                    ,''STOCK_BC'' AS HDC_GESTOR_ACTUALIZACION
                    ,''STOCK_BC''AS USUARIOCREAR
                    ,SYSDATE AS FECHACREAR
                FROM (SELECT DISTINCT ACT_ID FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL) TMP
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
                JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''DESTINO_COMERCIAL''  AND eqv1.DD_CODIGO_CAIXA = AUX.DESTINO_COMERCIAL AND EQV1.BORRADO=0
                LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_CODIGO = eqv1.DD_CODIGO_REM
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS'|| CHR(10);

--8º Se cambia el destino comercial
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION ACT
	            USING (
                    SELECT
                         TCO.DD_TCO_ID AS DD_TCO_ID
                        ,TMP.ACT_ID AS ACT_ID
                    FROM (SELECT DISTINCT ACT_ID FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL) TMP
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                    JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                    LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''DESTINO_COMERCIAL''  AND eqv1.DD_CODIGO_CAIXA = aux.DESTINO_COMERCIAL AND EQV1.BORRADO=0
                    LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_CODIGO = eqv1.DD_CODIGO_REM
                ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
                WHEN MATCHED THEN UPDATE SET
                    ACT.DD_TCO_ID = NVL(US.DD_TCO_ID, ACT.DD_TCO_ID)
                    ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                    ,ACT.FECHAMODIFICAR = SYSDATE
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS MODIFICADAS'|| CHR(10);


------------------------------------------------------------------------------------------------
------------------------------Lógica para el canal de publicación-------------------------------
------------------------------------------------------------------------------------------------
--1º Merge tabla ACT_ACTIVO_CAIXA
   SALIDA := SALIDA || '[INFO] 1 MERGE A LA TABLA ACT_ACTIVO_CAIXA.'|| CHR(10);

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA ACT
	            USING (
                    SELECT
                            CASE
                                WHEN AUX.PUBLICABLE_PORT_PUBLI_VENTA IN(''S'',''1'') THEN 1
                                WHEN AUX.PUBLICABLE_PORT_PUBLI_VENTA IN(''N'',''0'') THEN 0
                                ELSE 0
                            END AS CBX_PUBL_PORT_PUBL_VENTA
                            ,CASE
                                WHEN AUX.PUBLICABLE_PORT_PUBLI_ALQUI IN(''S'',''1'') THEN 1
                                WHEN AUX.PUBLICABLE_PORT_PUBLI_ALQUI IN(''N'',''0'') THEN 0
                                ELSE 0
                            END AS CBX_PUBL_PORT_PUBL_ALQUILER
                            ,CASE
                                WHEN AUX.PUBLICABLE_PORT_INVER_VENTA IN(''S'',''1'') THEN 1
                                WHEN AUX.PUBLICABLE_PORT_INVER_VENTA IN(''N'',''0'') THEN 0
                                ELSE 0
                            END AS CBX_PUBL_PORT_INV_VENTA
                            ,CASE
                                WHEN AUX.PUBLICABLE_PORT_INVER_ALQUI IN(''S'',''1'') THEN 1
                                WHEN AUX.PUBLICABLE_PORT_INVER_ALQUI IN(''N'',''0'') THEN 0
                                ELSE 0
                            END AS CBX_PUBL_PORT_INV_ALQUILER
                            ,CASE
                                WHEN AUX.PUBLICABLE_PORT_API_VENTA IN(''S'',''1'') THEN 1
                                WHEN AUX.PUBLICABLE_PORT_API_VENTA IN(''N'',''0'') THEN 0
                                ELSE 0
                            END AS CBX_PUBL_PORT_API_VENTA
                            ,CASE
                                WHEN AUX.PUBLICABLE_PORT_API_ALQUI IN(''S'',''1'') THEN 1
                                WHEN AUX.PUBLICABLE_PORT_API_ALQUI IN(''N'',''0'') THEN 0
                                ELSE 0
                            END AS CBX_PUBL_PORT_API_ALQUILER
                            ,ACT.ACT_ID AS ACT_ID
                        FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                        JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                        WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
                ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
                 WHEN MATCHED THEN UPDATE SET
                    ACT.CBX_PUBL_PORT_PUBL_VENTA=US.CBX_PUBL_PORT_PUBL_VENTA
                    ,ACT.CBX_PUBL_PORT_PUBL_ALQUILER=US.CBX_PUBL_PORT_PUBL_ALQUILER
                    ,ACT.CBX_PUBL_PORT_INV_VENTA=US.CBX_PUBL_PORT_INV_VENTA
                    ,ACT.CBX_PUBL_PORT_INV_ALQUILER=US.CBX_PUBL_PORT_INV_ALQUILER
                    ,ACT.CBX_PUBL_PORT_API_VENTA=US.CBX_PUBL_PORT_API_VENTA
                    ,ACT.CBX_PUBL_PORT_API_ALQUILER=US.CBX_PUBL_PORT_API_ALQUILER
                    ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                    ,ACT.FECHAMODIFICAR = SYSDATE
                 WHEN NOT MATCHED THEN INSERT (
                    CBX_ID
                    ,CBX_PUBL_PORT_PUBL_VENTA
                    ,CBX_PUBL_PORT_PUBL_ALQUILER
                    ,CBX_PUBL_PORT_INV_VENTA
                    ,CBX_PUBL_PORT_INV_ALQUILER
                    ,CBX_PUBL_PORT_API_VENTA
                    ,CBX_PUBL_PORT_API_ALQUILER
                    ,act_id
                    ,USUARIOCREAR
                    ,FECHACREAR
                    )VALUES(
                        '||V_ESQUEMA||'.S_ACT_ACTIVO_CAIXA.NEXTVAL
                        ,US.CBX_PUBL_PORT_PUBL_VENTA
                        ,US.CBX_PUBL_PORT_PUBL_ALQUILER
                        ,US.CBX_PUBL_PORT_INV_VENTA
                        ,US.CBX_PUBL_PORT_INV_ALQUILER
                        ,US.CBX_PUBL_PORT_API_VENTA
                        ,US.CBX_PUBL_PORT_API_ALQUILER
                        ,us.act_id
                        ,''STOCK_BC''
                        ,SYSDATE
                    )
   ';
   EXECUTE IMMEDIATE V_MSQL;


   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FUSIONADAS'|| CHR(10);

--2º Validaciones en función de los destinos comerciales e indicadores

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
	USING (
           SELECT
                 DD_POR_ID
                ,ACT_ID
            FROM(
               SELECT
                    CASE
                        WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA=1 THEN ''01''
                        WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER=1 THEN ''01''
                        WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_PUBL_VENTA=1 OR CAI.CBX_PUBL_PORT_PUBL_ALQUILER=1) THEN ''01''
                        WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA=0 AND CAI.CBX_PUBL_PORT_INV_VENTA=1 THEN ''02''
                        WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER=0  AND CAI.CBX_PUBL_PORT_INV_ALQUILER=1 THEN ''02''
                        WHEN TCO.DD_TCO_CODIGO=''02'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA=0  AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER=0 AND
                             (CAI.CBX_PUBL_PORT_INV_VENTA=1 OR CAI.CBX_PUBL_PORT_INV_ALQUILER =1) THEN ''02''
                        WHEN CAI.CBX_PUBL_PORT_PUBL_VENTA=0  AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER=0  AND
                             CAI.CBX_PUBL_PORT_INV_VENTA=0  AND CAI.CBX_PUBL_PORT_INV_ALQUILER=0  THEN NULL
                    END AS DD_POR_CODIGO
                    ,ACT.ACT_ID AS ACT_ID
               FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
               JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
               JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID=ACT.ACT_ID AND CAI.BORRADO=0
               JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID=APU.ACT_ID
               JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID=TCO.DD_TCO_ID
               ) AUX
               LEFT JOIN '||V_ESQUEMA||'.DD_POR_PORTAL POR ON AUX.DD_POR_CODIGO=POR.DD_POR_CODIGO

            ) US ON (US.ACT_ID = APU.ACT_ID)
            WHEN MATCHED THEN UPDATE SET
                 APU.DD_POR_ID=US.DD_POR_ID
                ,APU.USUARIOMODIFICAR = ''STOCK_BC''
                ,APU.FECHAMODIFICAR = SYSDATE
            WHERE APU.BORRADO=0 AND NVL(APU.DD_POR_ID,0)!=NVL(US.DD_POR_ID,0)
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' PORTALES CAMBIADOS'|| CHR(10);

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                USING (
                    SELECT TMP.AHP_ID FROM (SELECT ROW_NUMBER() OVER(PARTITION BY AHP.ACT_ID ORDER BY AHP.FECHACREAR DESC) RN, AHP.AHP_ID
                    FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AHP.ACT_ID
                    JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
                    WHERE ACT.BORRADO = 0
                        AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
                        AND AHP.BORRADO = 0
                        AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL
                        AND AHP.AHP_FECHA_FIN_VENTA IS NULL
                        AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                        AND NVL(APU.DD_POR_ID,0) <> NVL(AHP.DD_POR_ID,0)
                    ) TMP WHERE RN = 1
                ) AUX
                    ON (AHP.AHP_ID = AUX.AHP_ID)
                WHEN MATCHED THEN
                    UPDATE SET AHP.AHP_FECHA_FIN_VENTA = SYSDATE
                    , AHP.USUARIOMODIFICAR = ''STOCK_BC_PORTALES''
                    , AHP.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;
    SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FINALIZADOS EN LA AHP'|| CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (AHP_ID,ACT_ID
                ,DD_TPU_A_ID,DD_TPU_V_ID,DD_EPV_ID,DD_EPA_ID,DD_TCO_ID,DD_MTO_V_ID
                ,AHP_MOT_OCULTACION_MANUAL_V,AHP_CHECK_PUBLICAR_V,AHP_CHECK_OCULTAR_V
                ,AHP_CHECK_OCULTAR_PRECIO_V,AHP_CHECK_PUB_SIN_PRECIO_V
                ,DD_MTO_A_ID
                ,AHP_MOT_OCULTACION_MANUAL_A,AHP_CHECK_PUBLICAR_A
                ,AHP_CHECK_OCULTAR_A,AHP_CHECK_OCULTAR_PRECIO_A
                ,AHP_CHECK_PUB_SIN_PRECIO_A
                ,AHP_FECHA_INI_VENTA
                ,DD_POR_ID
                ,VERSION
                ,USUARIOCREAR,FECHACREAR
                ,BORRADO
                ,ES_CONDICONADO_ANTERIOR)
                SELECT '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL, APU.ACT_ID
                ,APU.DD_TPU_A_ID,APU.DD_TPU_V_ID,APU.DD_EPV_ID,APU.DD_EPA_ID,APU.DD_TCO_ID,APU.DD_MTO_V_ID
                ,APU.APU_MOT_OCULTACION_MANUAL_V,APU.APU_CHECK_PUBLICAR_V,APU.APU_CHECK_OCULTAR_V
                ,APU.APU_CHECK_OCULTAR_PRECIO_V,APU.APU_CHECK_PUB_SIN_PRECIO_V
                ,APU.DD_MTO_A_ID
                ,APU.APU_MOT_OCULTACION_MANUAL_A,APU.APU_CHECK_PUBLICAR_A
                ,APU.APU_CHECK_OCULTAR_A,APU.APU_CHECK_OCULTAR_PRECIO_A
                ,APU.APU_CHECK_PUB_SIN_PRECIO_A
                ,SYSDATE AHP_FECHA_INI_VENTA
                ,APU.DD_POR_ID
                ,APU.VERSION
                ,''STOCK_BC_PORTALES'' USUARIOCREAR
                ,SYSDATE FECHACREAR
                ,0 BORRADO
                ,APU.ES_CONDICONADO_ANTERIOR
                FROM (SELECT ROW_NUMBER() OVER(PARTITION BY AHP.ACT_ID ORDER BY AHP.FECHACREAR DESC) RN, AHP.ACT_ID
                FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AHP.ACT_ID
                JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID = APU.ACT_ID
                WHERE ACT.BORRADO = 0
                    AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
                    AND AHP.BORRADO = 0
                    AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL
                    AND AHP.AHP_FECHA_FIN_VENTA IS NOT NULL
                    AND AHP.USUARIOMODIFICAR = ''STOCK_BC_PORTALES''
                    AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                    AND NVL(APU.DD_POR_ID,0) <> NVL(AHP.DD_POR_ID,0)
                ) AUX
                JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = AUX.ACT_ID AND APU.BORRADO = 0
                WHERE AUX.RN = 1
                AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AUX_AHP WHERE AUX_AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AUX_AHP.AHP_FECHA_FIN_VENTA IS NULL AND AUX_AHP.ACT_ID = APU.ACT_ID AND AUX_AHP.BORRADO = 0)';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;
    SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' NUEVOS EN AHP'|| CHR(10);




------------------------------------------------------------------------------------------------
----------Lógica para el check de perímetro de comercialización, publicación, visible gestión comercial y formalización------------
------------------------------------------------------------------------------------------------

--1º Validaciones en función de los destinos comerciales e indicadores API
    IF FLAG_EN_REM = 1 THEN
        V_MSQL :=  'INSERT  INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                                ACT_ID
                            )
                            SELECT
                                ACT.ACT_ID AS ACT_ID
                            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX 
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO=0
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID=ACT.ACT_ID AND CAI.BORRADO=0
                            JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID=APU.ACT_ID
                            JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID=TCO.DD_TCO_ID
                            LEFT JOIN '||V_ESQUEMA||'.DD_POR_PORTAL POR ON APU.DD_POR_ID = POR.DD_POR_ID
                            JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                            WHERE AUX.FLAG_EN_REM <> 0
                            AND AUX.FLAG_OFERTA_VIVA = 0
                            AND (CASE
                                   WHEN TCO.DD_TCO_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_API_VENTA = 1 THEN 1
								    WHEN TCO.DD_TCO_CODIGO = ''03'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_API_ALQUILER = 1 THEN 1
								    WHEN TCO.DD_TCO_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND (CAI.CBX_PUBL_PORT_API_VENTA = 1 OR CAI.CBX_PUBL_PORT_API_ALQUILER = 1) THEN 1
                                    WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_VENTA = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''01'' AND (CAI.CBX_PUBL_PORT_PUBL_VENTA=1 OR CAI.CBX_PUBL_PORT_PUBL_ALQUILER=1) THEN 1
                                    WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''02'' AND (CAI.CBX_PUBL_PORT_INV_VENTA=1 OR CAI.CBX_PUBL_PORT_INV_ALQUILER=1) THEN 1
                                    ELSE 0
                                END <> NVL(PAC.PAC_CHECK_COMERCIALIZAR, 0)
                                OR CASE
									WHEN TCO.DD_TCO_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_API_VENTA = 1 THEN 0
									WHEN TCO.DD_TCO_CODIGO = ''03'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_API_ALQUILER = 1 THEN 0
									WHEN TCO.DD_TCO_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND (CAI.CBX_PUBL_PORT_API_VENTA = 1 OR CAI.CBX_PUBL_PORT_API_ALQUILER = 1) THEN 0
                                    WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_VENTA = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''01'' AND (CAI.CBX_PUBL_PORT_PUBL_VENTA=1 OR CAI.CBX_PUBL_PORT_PUBL_ALQUILER=1) THEN 1
                                    WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''02'' AND (CAI.CBX_PUBL_PORT_INV_VENTA=1 OR CAI.CBX_PUBL_PORT_INV_ALQUILER=1) THEN 1
                                    ELSE 0
                                END <> NVL(PAC.PAC_CHECK_PUBLICAR, 0)
                                OR CASE
                                    WHEN TCO.DD_TCO_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_API_VENTA = 1 THEN 1
								    WHEN TCO.DD_TCO_CODIGO = ''03'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_API_ALQUILER = 1 THEN 1
								    WHEN TCO.DD_TCO_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND (CAI.CBX_PUBL_PORT_API_VENTA = 1 OR CAI.CBX_PUBL_PORT_API_ALQUILER = 1) THEN 1
                                    WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_VENTA = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 1 THEN  1
                                    WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''01'' AND (CAI.CBX_PUBL_PORT_PUBL_VENTA=1 OR CAI.CBX_PUBL_PORT_PUBL_ALQUILER=1) THEN 1
                                    WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''02'' AND (CAI.CBX_PUBL_PORT_INV_VENTA=1 OR CAI.CBX_PUBL_PORT_INV_ALQUILER=1) THEN 1
                                    ELSE 0
                                END <> NVL(PAC.PAC_CHECK_FORMALIZAR, 0))';
        EXECUTE IMMEDIATE V_MSQL;


        V_NUM_FILAS := sql%rowcount;
        SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' ACTIVOS CON EL PERÍMETRO DISCORDANTE CON LOS FLAGS BC'|| CHR(10);
    END IF;

    V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                USING (
                        SELECT
                            TMP.ACT_ID AS ACT_ID
                            ,CASE
								WHEN TCO.DD_TCO_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_API_VENTA = 1 THEN 0
								WHEN TCO.DD_TCO_CODIGO = ''03'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_API_ALQUILER = 1 THEN 0
								WHEN TCO.DD_TCO_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND (CAI.CBX_PUBL_PORT_API_VENTA = 1 OR CAI.CBX_PUBL_PORT_API_ALQUILER = 1) THEN 0
                                WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_VENTA = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''01'' AND (CAI.CBX_PUBL_PORT_PUBL_VENTA=1 OR CAI.CBX_PUBL_PORT_PUBL_ALQUILER=1) THEN 1
                                WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''02'' AND (CAI.CBX_PUBL_PORT_INV_VENTA=1 OR CAI.CBX_PUBL_PORT_INV_ALQUILER=1) THEN 1
                                ELSE 0
                            END AS PAC_CHECK_PUBLICAR
                            ,CASE
                            	WHEN TCO.DD_TCO_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_API_VENTA = 1 THEN 1
								WHEN TCO.DD_TCO_CODIGO = ''03'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_API_ALQUILER = 1 THEN 1
								WHEN TCO.DD_TCO_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 0 AND CAI.CBX_PUBL_PORT_INV_VENTA = 0 AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 0 AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 0 AND (CAI.CBX_PUBL_PORT_API_VENTA = 1 OR CAI.CBX_PUBL_PORT_API_ALQUILER = 1) THEN 1
                                WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_VENTA = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''01'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_VENTA = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''01'' AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''03'' AND POR.DD_POR_CODIGO = ''02'' AND CAI.CBX_PUBL_PORT_INV_ALQUILER = 1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''01'' AND (CAI.CBX_PUBL_PORT_PUBL_VENTA=1 OR CAI.CBX_PUBL_PORT_PUBL_ALQUILER=1) THEN 1
                                WHEN TCO.DD_TCO_CODIGO = ''02'' AND POR.DD_POR_CODIGO = ''02'' AND (CAI.CBX_PUBL_PORT_INV_VENTA=1 OR CAI.CBX_PUBL_PORT_INV_ALQUILER=1) THEN 1
                                ELSE 0
                            END AS PAC_CHECK_COMERCIALIZAR
                        FROM (SELECT DISTINCT ACT_ID FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL) TMP
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID=ACT.ACT_ID AND CAI.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID=APU.ACT_ID
                        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID=TCO.DD_TCO_ID
                        LEFT JOIN '||V_ESQUEMA||'.DD_POR_PORTAL POR ON APU.DD_POR_ID = POR.DD_POR_ID
                        WHERE AUX.FLAG_OFERTA_VIVA = 0
                        ) US ON (US.ACT_ID = PAC.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                             PAC.PAC_CHECK_PUBLICAR = US.PAC_CHECK_PUBLICAR
                            ,PAC.PAC_FECHA_PUBLICAR = CASE WHEN PAC.PAC_CHECK_PUBLICAR <> US.PAC_CHECK_PUBLICAR THEN SYSDATE END
                            ,PAC.PAC_MOTIVO_PUBLICAR = CASE WHEN PAC.PAC_CHECK_PUBLICAR <> US.PAC_CHECK_PUBLICAR THEN NULL END
                            ,PAC.PAC_CHECK_COMERCIALIZAR = US.PAC_CHECK_COMERCIALIZAR
                            ,PAC.PAC_FECHA_COMERCIALIZAR = CASE WHEN PAC.PAC_CHECK_COMERCIALIZAR <> US.PAC_CHECK_COMERCIALIZAR THEN SYSDATE END
                            ,PAC.DD_MCO_ID = CASE WHEN PAC.PAC_CHECK_COMERCIALIZAR <> US.PAC_CHECK_COMERCIALIZAR AND US.PAC_CHECK_COMERCIALIZAR = 0 THEN NULL ELSE PAC.DD_MCO_ID END
                            ,PAC.PAC_MOT_EXCL_COMERCIALIZAR = CASE WHEN PAC.PAC_CHECK_COMERCIALIZAR <> US.PAC_CHECK_COMERCIALIZAR AND US.PAC_CHECK_COMERCIALIZAR = 1 THEN NULL ELSE PAC.PAC_MOT_EXCL_COMERCIALIZAR END
                            ,PAC.PAC_CHECK_FORMALIZAR = US.PAC_CHECK_COMERCIALIZAR
                            ,PAC.PAC_FECHA_FORMALIZAR = CASE WHEN PAC.PAC_CHECK_COMERCIALIZAR <> US.PAC_CHECK_COMERCIALIZAR THEN SYSDATE END
                            ,PAC.PAC_MOTIVO_FORMALIZAR = CASE WHEN PAC.PAC_CHECK_COMERCIALIZAR <> US.PAC_CHECK_COMERCIALIZAR THEN NULL END
                            ,PAC.USUARIOMODIFICAR = ''STOCK_BC''
                            ,PAC.FECHAMODIFICAR = SYSDATE
                            WHERE PAC.BORRADO=0
                            AND (NVL(PAC.PAC_CHECK_COMERCIALIZAR,0)!=NVL(US.PAC_CHECK_COMERCIALIZAR,0)
                            OR NVL(PAC.PAC_CHECK_PUBLICAR,0)!=NVL(US.PAC_CHECK_PUBLICAR,0)
                            OR NVL(PAC.PAC_CHECK_FORMALIZAR,0)!=NVL(US.PAC_CHECK_COMERCIALIZAR,0))

   ';
   EXECUTE IMMEDIATE V_MSQL;


   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' ACTIVOS RECALCULADO EL PERÍMETRO'|| CHR(10);

   V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP_DEL
               WHERE TMP_DEL.ACT_ID IN (SELECT DISTINCT AGA.ACT_ID
                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON TMP.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID AND AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL
                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 AND TAG.DD_TAG_CODIGO IN (''02'',''17'',''18''))';

    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;

    SALIDA := SALIDA || '[INFO] SE HAN BORRADO ' || V_NUM_FILAS ||' REGISTROS EN TMP_ACT_DESTINO_COMERCIAL POR ESTAR DENTRO DE UNA AGRUPACIÓN RESTRINGIDA [INFO]'|| CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_AGR_DESTINO_COMERCIAL (
                    AGR_ID
                )
                SELECT DISTINCT AGR.AGR_ID
                FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO=0
                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID = AGR.AGR_ID AND AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL
                JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND AGR.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 AND TAG.DD_TAG_CODIGO IN (''02'',''17'',''18'')
                WHERE (TRUNC(PAC.FECHACREAR) = TRUNC(SYSDATE) AND PAC.USUARIOCREAR = ''STOCK_BC''
                OR TRUNC(PAC.FECHAMODIFICAR) = TRUNC(SYSDATE) AND PAC.USUARIOMODIFICAR = ''STOCK_BC'')
                AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TMP_AGR_DESTINO_COMERCIAL TMP WHERE TMP.AGR_ID = AGR.AGR_ID)
                AND AUX.FLAG_EN_REM = '||FLAG_EN_REM||'';

    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;

    SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN TMP_AGR_DESTINO_COMERCIAL POR POR CAMBIOS DE PERÍMETRO [INFO]'|| CHR(10);

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_AGR_DESTINO_COMERCIAL TMP
                WHERE TMP.AGR_ID IN (SELECT TMP_DEL.AGR_ID FROM '||V_ESQUEMA||'.TMP_AGR_DESTINO_COMERCIAL TMP_DEL
                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON TMP_DEL.AGR_ID = AGR.AGR_ID AND AGR.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGR.AGR_ACT_PRINCIPAL AND ACT.BORRADO = 0
                WHERE TAG.DD_TAG_CODIGO = ''18''
                AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AUX_AGR
                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AUX_AGA ON AUX_AGA.AGR_ID = AUX_AGR.AGR_ID AND AUX_AGA.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION AUX_TAG ON AUX_TAG.DD_TAG_ID = AUX_AGR.DD_TAG_ID AND AUX_TAG.BORRADO = 0
                WHERE AUX_TAG.DD_TAG_CODIGO IN (''02'',''17'')
                AND AUX_AGR.AGR_FECHA_BAJA IS NULL
                AND AUX_AGA.ACT_ID = ACT.ACT_ID))';

    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;

    SALIDA := SALIDA || '[INFO] SE HAN BORRADO ' || V_NUM_FILAS ||' REGISTROS EN TMP_AGR_DESTINO_COMERCIAL POR ESTAR DENTRO DE UNA AGRUPACIÓN RESTRINGIDA OBREM Y DE VENTA O ALQUILER [INFO]'|| CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_ACT_SCM (
                    ACT_ID
                    , FECHA_CALCULO
                )
                SELECT TMP.ACT_ID, SYSDATE
                FROM (SELECT DISTINCT ACT_ID FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL) TMP
                WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TMP_ACT_SCM SCM WHERE SCM.ACT_ID = TMP.ACT_ID)
                UNION
                SELECT DISTINCT AGA.ACT_ID, SYSDATE
                FROM '||V_ESQUEMA||'.TMP_AGR_DESTINO_COMERCIAL TMP
                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON TMP.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
                WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TMP_ACT_SCM SCM WHERE SCM.ACT_ID = AGA.ACT_ID)';

    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;

    SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN TMP_ACT_SCM [INFO]'|| CHR(10);

    IF 0 = FLAG_EN_REM THEN

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_ACT_SCM (
                        ACT_ID
                        , FECHA_CALCULO
                    )
                    SELECT ACT.ACT_ID, SYSDATE
                    FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                    WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TMP_ACT_SCM SCM WHERE SCM.ACT_ID = ACT.ACT_ID)
                    AND AUX.FLAG_EN_REM = 0';

        EXECUTE IMMEDIATE V_MSQL;

        V_NUM_FILAS := sql%rowcount;

        SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN TMP_ACT_SCM PARA LOS ACTIVOS DE NUEVA CREACIÓN [INFO]'|| CHR(10);

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION (
                        APU_ID
                        , ACT_ID
                        , DD_TPU_ID
                        , DD_EPV_ID
                        , DD_EPA_ID
                        , DD_TCO_ID
                        , APU_FECHA_INI_VENTA
                        , APU_FECHA_INI_ALQUILER
                        , USUARIOCREAR
                        , FECHACREAR
                        , DD_TPU_V_ID
                        , DD_TPU_A_ID
                    )
                        SELECT
                            '||V_ESQUEMA||'.S_ACT_APU_ACTIVO_PUBLICACION.NEXTVAL
                            , ACT.ACT_ID
                            , ACT.DD_TPU_ID
                            , (SELECT DD_EPV_ID FROM '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = ''01'')
                            , (SELECT DD_EPA_ID FROM '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = ''01'')
                            , CASE WHEN TCO_NUEVO.DD_TCO_ID IS NULL THEN (SELECT DD_TCO_ID FROM '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = ''02'')
                                    WHEN TCO_NUEVO.DD_TCO_ID IS NOT NULL THEN TCO_NUEVO.DD_TCO_ID END
                            ,  CASE WHEN TCO_NUEVO.DD_TCO_ID IS NULL THEN SYSDATE
                                WHEN TCO_NUEVO.DD_TCO_CODIGO = ''01'' OR TCO_NUEVO.DD_TCO_CODIGO = ''02'' THEN SYSDATE
                               ELSE NULL END
                            ,  CASE WHEN TCO_NUEVO.DD_TCO_ID IS NULL THEN SYSDATE
                                WHEN TCO_NUEVO.DD_TCO_CODIGO = ''02'' OR TCO_NUEVO.DD_TCO_CODIGO = ''03'' THEN SYSDATE
                               ELSE NULL END
                            , ''STOCK_BC''
                            , SYSDATE
                            , ACT.DD_TPU_ID
                            , ACT.DD_TPU_ID
                        FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                        LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM EQV ON EQV.DD_NOMBRE_CAIXA=''DESTINO_COMERCIAL'' AND EQV.DD_CODIGO_CAIXA = AUX.DESTINO_COMERCIAL AND EQV.BORRADO=0
                        LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO_NUEVO ON TCO_NUEVO.DD_TCO_CODIGO = EQV.DD_CODIGO_REM
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO=0
                        WHERE AUX.FLAG_EN_REM = 0
                        AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.BORRADO = 0 AND APU.ACT_ID = ACT.ACT_ID)';

        EXECUTE IMMEDIATE V_MSQL;

        V_NUM_FILAS := sql%rowcount;

        SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN ACT_APU_ACTIVO_PUBLICACION PARA LOS ACTIVOS DE NUEVA CREACIÓN [INFO]'|| CHR(10);

        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION (
                        AHP_ID
                        , ACT_ID
                        , DD_TPU_ID
                        , DD_EPV_ID
                        , DD_EPA_ID
                        , DD_TCO_ID
                        , AHP_FECHA_INI_VENTA
                        , AHP_FECHA_INI_ALQUILER
                        , USUARIOCREAR
                        , FECHACREAR
                        , DD_TPU_V_ID
                        , DD_TPU_A_ID
                    )
                        SELECT
                            '||V_ESQUEMA||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
                            , APU.ACT_ID
                            , APU.DD_TPU_ID
                            , APU.DD_EPV_ID
                            , APU.DD_EPA_ID
                            , APU.DD_TCO_ID
                            , APU.APU_FECHA_INI_VENTA
                            , APU.APU_FECHA_INI_ALQUILER
                            , ''STOCK_BC''
                            , SYSDATE
                            , APU.DD_TPU_V_ID
                            , APU.DD_TPU_A_ID
                        FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
                        WHERE AUX.FLAG_EN_REM = 0';

        EXECUTE IMMEDIATE V_MSQL;

        V_NUM_FILAS := sql%rowcount;

        SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN ACT_AHP_HIST_PUBLICACION PARA LOS ACTIVOS DE NUEVA CREACIÓN [INFO]'|| CHR(10);

    END IF;

--9º Llamar al SP de SCM para cada activo guardado en la tabla temporal
--Ejecutamos el Sp por cada activo de la tabla temporal

    V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_ACTIVO ACT
                USING   (SELECT
                            DISTINCT TMP.ACT_ID AS ACT_ID
                        FROM '||V_ESQUEMA||'.TMP_ACT_SCM TMP) US 
                        ON (ACT.ACT_ID = US.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                                ACT.DD_SCM_ID = NULL';
    EXECUTE IMMEDIATE V_MSQL;

    V_NUM_FILAS := sql%rowcount;

    SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' ACTIVOS PARA ACTUALIZAR SU SITUACIÓN COMERCIAL'|| CHR(10);

    SALIDA := SALIDA || '##INICIO: SP_ASC_ACT_SIT_COM_VACIOS_V2'|| CHR(10);

    #ESQUEMA#.SP_ASC_ACT_SIT_COM_VACIOS_V2(0);

    SALIDA := SALIDA || '##FIN: SP_ASC_ACT_SIT_COM_VACIOS_V2'|| CHR(10);

--10º Llamar al SP para cada activo guardado en la tabla temporal
--Ejecutamos el Sp por cada activo de la tabla temporal

    SALIDA := SALIDA || '##INICIO: SP_CAMBIO_ESTADO_PUBLICACION '|| CHR(10);

        FOR I IN ACTIVOS LOOP
            ACT_ID:=I.ACT_ID;

            #ESQUEMA#.SP_CAMBIO_ESTADO_PUBLICACION(ACT_ID);
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL SET EJECUTADO = 1, FECHA_EJECUCION = SYSDATE WHERE ACT_ID = '||ACT_ID;
            EXECUTE IMMEDIATE V_MSQL;
            COMMIT;

            EXIT WHEN ACTIVOS%NOTFOUND;
        END LOOP;

    SALIDA := SALIDA || '##FIN: SP_CAMBIO_ESTADO_PUBLICACION '|| CHR(10);

--11º Llamar al SP para cada activo guardado en la tabla temporal
--Ejecutamos el Sp por cada activo de la tabla temporal

    SALIDA := SALIDA || '##INICIO: SP_CAMBIO_ESTADO_PUBLI_AGR '|| CHR(10);

        FOR I IN AGRUPACIONES LOOP
            AGR_ID:=I.AGR_ID;

            #ESQUEMA#.SP_CAMBIO_ESTADO_PUBLI_AGR(AGR_ID);
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_AGR_DESTINO_COMERCIAL SET EJECUTADO = 1, FECHA_EJECUCION = SYSDATE WHERE AGR_ID = '||AGR_ID;
            EXECUTE IMMEDIATE V_MSQL;
            COMMIT;

            EXIT WHEN AGRUPACIONES%NOTFOUND;
        END LOOP;

    SALIDA := SALIDA || '##FIN: SP_CAMBIO_ESTADO_PUBLI_AGR '|| CHR(10);

--12º Revisamos el campo Visible gestión comercial tras recalcular el estado de publicación de los activos, si es Publicado tiene que estar a Si


    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
	USING (
            SELECT ACT.ACT_ID, 1 PAC_CHECK_GESTION_COMERCIAL
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK BCR 
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = BCR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID=ACT.ACT_ID AND CAI.BORRADO=0
            JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
            WHERE
            NOT(NVL(CBX_PUBL_PORT_PUBL_VENTA, 0) = 0 AND NVL(CBX_PUBL_PORT_PUBL_ALQUILER, 0) = 0 AND NVL(CBX_PUBL_PORT_INV_VENTA, 0) = 0
            AND NVL(CBX_PUBL_PORT_INV_ALQUILER, 0) = 0 AND NVL(CBX_PUBL_PORT_API_VENTA, 0) = 0 AND NVL(CBX_PUBL_PORT_API_ALQUILER, 0) = 0)
            AND BCR.FLAG_EN_REM = '|| FLAG_EN_REM||'
            UNION ALL
            SELECT ACT.ACT_ID, 0 PAC_CHECK_GESTION_COMERCIAL
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK BCR 
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = BCR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID=ACT.ACT_ID AND CAI.BORRADO=0
            JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
            WHERE
            (NVL(CBX_PUBL_PORT_PUBL_VENTA, 0) = 0 AND NVL(CBX_PUBL_PORT_PUBL_ALQUILER, 0) = 0 AND NVL(CBX_PUBL_PORT_INV_VENTA, 0) = 0
            AND NVL(CBX_PUBL_PORT_INV_ALQUILER, 0) = 0 AND NVL(CBX_PUBL_PORT_API_VENTA, 0) = 0 AND NVL(CBX_PUBL_PORT_API_ALQUILER, 0) = 0)
            AND BCR.FLAG_EN_REM = '|| FLAG_EN_REM||'
            ) US ON (US.ACT_ID = PAC.ACT_ID)
            WHEN MATCHED THEN UPDATE SET
                 PAC.PAC_CHECK_GESTION_COMERCIAL = US.PAC_CHECK_GESTION_COMERCIAL
                ,PAC.PAC_FECHA_GESTION_COMERCIAL = SYSDATE
                ,PAC.PAC_MOTIVO_GESTION_COMERCIAL = CASE WHEN US.PAC_CHECK_GESTION_COMERCIAL = 0 THEN (SELECT DD_MGC_ID FROM '||V_ESQUEMA||'.DD_MGC_MOTIVO_GEST_COMERCIAL WHERE DD_MGC_CODIGO = ''01'') ELSE NULL END
                ,PAC.USUARIOMODIFICAR = ''STOCK_BC''
                ,PAC.FECHAMODIFICAR = SYSDATE
            WHERE NVL(PAC.PAC_CHECK_GESTION_COMERCIAL, 0) <> US.PAC_CHECK_GESTION_COMERCIAL
   ';
   EXECUTE IMMEDIATE V_MSQL;


   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FUSIONADAS PARA MODIFICAR EL CHECK VISIBLE GESTIÓN COMERCIAL'|| CHR(10);

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_BCR_08_PUBLICACION;
/
EXIT;
