--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210714
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14545
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-14241
--##	    0.2 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - HREOS-14545
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
        SELECT ACT_ID 
        FROM #ESQUEMA#.TMP_ACT_DESTINO_COMERCIAL;

   ACT_ID NUMBER(16);

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

            V_NUM_FILAS := sql%rowcount;

            SALIDA := SALIDA || '[INFO]  INSERTAMOS EN '||V_TABLA||'  [INFO]'|| CHR(10);

              V_MSQL := 'INSERT  INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                            ACT_ID
                      )
                        SELECT DISTINCT
                            ACT_ID
                        FROM(
                        SELECT 
                             ACTOFR.ACT_ID AS ACT_ID
                            ,CASE
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND 
                                    AUX.DESTINO_COMERCIAL=''VT'' AND 
                                    TOF.DD_TOF_CODIGO=''02'' AND 
                                    EOF.DD_EOF_CODIGO=''01'' 
                                    THEN 0                     --SI ESTÁ EN ALQUILER(03) Y SE QUIERE CAMBIAR A VENTA(VT) CON OFERTA ALQUILER (02) EN TRAMITACIÓN (01)(NO SE PUEDEN HACER CAMBIOS)
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND 
                                    AUX.DESTINO_COMERCIAL=''RT'' AND 
                                    TOF.DD_TOF_CODIGO=''01'' AND 
                                    EOF.DD_EOF_CODIGO=''01'' 
                                    THEN 0                     --SI ESTÁ EN VENTA(01) Y SE QUIERE CAMBIAR A ALQUILER(RT) CON OFERTA DE VENTA(01) EN TRAMITACIÓN (01)(NO SE PUEDEN HACER CAMBIOS)
                                ELSE 1                         --(SE PUEDE CAMBIAR EL DESTINO COMERCIAL)
                            END AS DESTINO_ACTUAL
                        FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_OFR ACTOFR ON ACTOFR.ACT_ID=ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID=ACTOFR.OFR_ID AND OFR.BORRADO=0
                        JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID=EOF.DD_EOF_ID
                        JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID=TOF.DD_TOF_ID
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID=ACT.ACT_ID
                        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID=APU.DD_TCO_ID
                        WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
                        )WHERE DESTINO_ACTUAL=''1'' 
                                  
                     ';

              EXECUTE IMMEDIATE V_MSQL;

              V_NUM_FILAS := sql%rowcount;

            SALIDA := SALIDA || '[INFO] SE HAN INSERTADO ' || V_NUM_FILAS ||' REGISTROS EN '||V_TABLA||'  [INFO]'|| CHR(10);
        END IF;


--2º Borramos la segunda tabla temporal que se ha creado para almacenar los activos que se van a borrar de la TMP_ACT_DESTINO_COMERCIAL
        SALIDA := SALIDA || '[INFO] TRUNCAMOS TMP_DEST_COMERCIAL_REJECT  [INFO]'|| CHR(10);

        #ESQUEMA#.OPERACION_DDL.DDL_Table('TRUNCATE','TMP_DEST_COMERCIAL_REJECT');

--3º PRIMER insert a TMP_DEST_COMERCIAL_REJECT
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ(--Ver si todos los activos que pertenecen a una agrupación de encuentran en la temporal
                    ACT_ID
                )
                SELECT 
                    ACT_ID
                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                WHERE EXISTS(
                        WITH AGRUPACION --Cuenta de activos por agrupaciónes existentes AGA, es decir, cuántos activos hay por agrupación (LOS QUE ESTÁN VIGENTES)
                        AS(
                            SELECT 
                                COUNT(*) CUENTA_AGA
                                ,AGA.AGR_ID AS AGR_ID
                            FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA 
                            JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID=AGR.AGR_ID AND AGR.BORRADO=0 
                            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TIPO ON AGR.DD_TAG_ID=TIPO.DD_TAG_ID
                            WHERE TIPO.DD_TAG_CODIGO IN (''02'',''14'',''15'')  AND AGA.BORRADO=0 AND SYSDATE BETWEEN COALESCE(AGR_INI_VIGENCIA,AGR_FECHA_ALTA,TO_DATE(''01/01/1999'',''DD/MM/YYYY'')) 
                                                                                                                AND COALESCE(AGR_FECHA_BAJA,AGR_FIN_VIGENCIA,TO_DATE(''31/12/2099'',''DD/MM/YYYY'')) 
                            GROUP BY AGA.AGR_ID
                        ),
                        TEMPORAL --Cuenta de activos por agrupaciones, de los activos insertados en la temporal
                        AS(
                            SELECT 
                                COUNT(*) CUENTA_TMP
                                ,AGR.AGR_ID  AS AGR_ID
                            FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID=TMP.ACT_ID AND AGA.BORRADO=0
                            JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID=AGR.AGR_ID AND AGR.BORRADO=0 
                            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TIPO ON AGR.DD_TAG_ID=TIPO.DD_TAG_ID
                            WHERE TIPO.DD_TAG_CODIGO IN (''02'',''14'',''15'') AND SYSDATE BETWEEN COALESCE(AGR_INI_VIGENCIA,AGR_FECHA_ALTA,TO_DATE(''01/01/1999'',''DD/MM/YYYY'')) 
                                                                                            AND COALESCE(AGR_FECHA_BAJA,AGR_FIN_VIGENCIA,TO_DATE(''31/12/2099'',''DD/MM/YYYY''))
                            GROUP BY AGR.AGR_ID
                        )
                            SELECT --En el caso de que no coincidan esas cuentas se borra el activo de la temporal
                                1
                            FROM AGRUPACION AGRU
                            JOIN TEMPORAL TEMP ON AGRU.AGR_ID=TEMP.AGR_ID
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID=TEMP.AGR_ID
                            WHERE AGRU.CUENTA_AGA!=TEMP.CUENTA_TMP AND TMP.ACT_ID=AGA.ACT_ID
                    )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS'|| CHR(10);

--4º SEGUNDO insert a TMP_DEST_COMERCIAL_REJECT
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ(--Vemos si todos los activos de una misma agrupación (02) tienen el mismo destino comercial
                    ACT_ID
                )
                SELECT 
                    ACT_ID
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
                            WHERE TIPO.DD_TAG_CODIGO =''02'' AND SYSDATE BETWEEN COALESCE(AGR_INI_VIGENCIA,AGR_FECHA_ALTA,TO_DATE(''01/01/1999'',''DD/MM/YYYY'')) 
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
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS'|| CHR(10);


--5º TERCER insert a TMP_DEST_COMERCIAL_REJECT
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ(--Vemos si todos los activos de comercial venta y comercial alquiler (14,15) tienen el mismo destino comercial
                    ACT_ID
                )
                SELECT 
                    ACT_ID
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
                                        WHEN AUX.DESTINO_COMERCIAL=''VT'' AND  TIPO.DD_TAG_CODIGO=''15'' THEN 0 --Si el destino comercial es venta (VT) y la agrupación es comercial alquiler (15) (NO PUEDE CAMBIAR EL DESTINO)
                                        WHEN AUX.DESTINO_COMERCIAL=''RT'' AND  TIPO.DD_TAG_CODIGO=''14'' THEN 0 --Si el destino comercial es alquiler (RT) y la agrupación es comercial venta (14) (NO PUEDE CAMBIAR EL DESTINO)
                                        ELSE 1
                                    END AS CAMBIO
                                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                                JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID=TMP.ACT_ID AND AGA.BORRADO=0
                                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGA.AGR_ID=AGR.AGR_ID AND AGR.BORRADO=0 
                                JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TIPO ON AGR.DD_TAG_ID=TIPO.DD_TAG_ID
                                WHERE TIPO.DD_TAG_CODIGO IN (''14'',''15'') AND SYSDATE BETWEEN COALESCE(AGR_INI_VIGENCIA,AGR_FECHA_ALTA,TO_DATE(''01/01/1999'',''DD/MM/YYYY'')) 
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
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS'|| CHR(10);

--6º Delete de los activos insertados en TMP_DEST_COMERCIAL_REJECT en la tabla TMP_ACT_DESTINO_COMERCIAL
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
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS BORRADAS'|| CHR(10);

--7º Insert de los activos borrados a la tabla AUX_APR_BCR_STOCK_REJ de errores
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_APR_BCR_STOCK_REJ REJ(
                    ERRORCODE
                    ,ERRORMESSAGE
                    ,ROWREJECTED
                )
                SELECT 
                    ''SP_08'' AS ERRORCODE
                    ,''Rechazado intento de cambio de destino comercial por agrupación de tipos restringida, comercial venta y comercial alquiler.'' AS ERRORMESSAGE
                    ,ACT.ACT_NUM_ACTIVO_CAIXA  AS ROWREJECTED
                FROM '||V_ESQUEMA||'.TMP_DEST_COMERCIAL_REJECT TREJ
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TREJ.ACT_ID AND ACT.BORRADO=0
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS'|| CHR(10);



--8º Actualización del histórico
--Modificamos en el caso de que ya exista un registro en la histórica
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.HDC_HIST_DESTINO_COMERCIAL HIST
	            USING (				
                    SELECT 
                        TMP.ACT_ID AS ACT_ID
                    FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                )US ON (US.ACT_ID = HIST.ACT_ID)
                WHEN MATCHED THEN UPDATE SET
                     HIST.HDC_FECHA_FIN=SYSDATE
                    ,HIST.HDC_GESTOR_ACTUALIZACION=''BATCH_USER''
                    ,HIST.USUARIOMODIFICAR = ''BATCH_USER''
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
                    ,TCO.DD_TCO_ID AS DD_TCO_ID
                    ,SYSDATE AS HDC_FECHA_INICIO
                    ,NULL AS HDC_FECHA_FIN
                    ,''BATCH_USER'' AS HDC_GESTOR_ACTUALIZACION
                    ,''BATCH_USER''AS USUARIOCREAR
                    ,SYSDATE AS FECHACREAR    
                FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''DESTINO_COMERCIAL''  AND eqv1.DD_CODIGO_CAIXA = AUX.DESTINO_COMERCIAL AND EQV1.BORRADO=0
                LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_CODIGO = eqv1.DD_CODIGO_REM
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS INSERTADAS'|| CHR(10);

--9º Se cambia el destino comercial
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION ACT
	            USING (				
                    SELECT 
                         TCO.DD_TCO_ID AS DD_TCO_ID 
                        ,TMP.ACT_ID AS ACT_ID    
                    FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                    JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                    LEFT JOIN '||V_ESQUEMA||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''DESTINO_COMERCIAL''  AND eqv1.DD_CODIGO_CAIXA = aux.DESTINO_COMERCIAL AND EQV1.BORRADO=0
                    LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_CODIGO = eqv1.DD_CODIGO_REM
                ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
                WHEN MATCHED THEN UPDATE SET
                     ACT.DD_TCO_ID=US.DD_TCO_ID  
                    ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                    ,ACT.FECHAMODIFICAR = SYSDATE
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FILAS MODIFICADAS'|| CHR(10); 



--10º Llamar al SP para cada activo guardado en la tabla temporal
--Ejecutamos el Sp por cada activo de la tabla temporal

SALIDA := SALIDA || '##INICIO: SP_CAMBIO_ESTADO_PUBLICACION '|| CHR(10);

    FOR I IN ACTIVOS LOOP
        ACT_ID:=I.ACT_ID;

        SP_CAMBIO_ESTADO_PUBLICACION(ACT_ID);
        
        EXIT WHEN ACTIVOS%NOTFOUND;
    END LOOP;

SALIDA := SALIDA || '##FIN: SP_CAMBIO_ESTADO_PUBLICACION '|| CHR(10);



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
                            ,TMP.ACT_ID AS ACT_ID 
                        FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
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
                             CAI.CBX_PUBL_PORT_INV_VENTA=1 AND CAI.CBX_PUBL_PORT_INV_ALQUILER =1 THEN ''02''
                        WHEN CAI.CBX_PUBL_PORT_PUBL_VENTA=0  AND CAI.CBX_PUBL_PORT_PUBL_ALQUILER=0  AND 
                             CAI.CBX_PUBL_PORT_INV_VENTA=0  AND CAI.CBX_PUBL_PORT_INV_ALQUILER=0  THEN NULL
                    END AS DD_POR_CODIGO
                    ,ACT.ACT_ID AS ACT_ID                    
               FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
               JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
               JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID=ACT.ACT_ID AND CAI.BORRADO=0
               JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID=APU.ACT_ID
               JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID=TCO.DD_TCO_ID
               ) AUX
               LEFT JOIN '||V_ESQUEMA||'.DD_POR_PORTAL POR ON AUX.DD_POR_CODIGO=POR.DD_POR_CODIGO
               
            ) US ON (US.ACT_ID = APU.ACT_ID)
            WHEN MATCHED THEN UPDATE SET
                 APU.DD_POR_ID=US.DD_POR_ID            
                ,APU.USUARIOMODIFICAR = ''BATCH_USER''
                ,APU.FECHAMODIFICAR = SYSDATE
                WHERE APU.BORRADO=0 AND NVL(APU.DD_POR_ID,0)!=NVL(US.DD_POR_ID,0)
   ';
   EXECUTE IMMEDIATE V_MSQL;
   

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FUSIONADAS'|| CHR(10);




------------------------------------------------------------------------------------------------
----------Lógica para el check de perímetro de comercialización, el de formalización------------
------------------------------------------------------------------------------------------------

--1º Validaciones en función de los destinos comerciales e indicadores API
    V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                USING (		
                        SELECT 
                            TMP.ACT_ID AS ACT_ID
                            ,CASE                                                                  
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=1 THEN 1
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=1 OR CAI.CBX_PUBL_PORT_API_ALQUILER=1) THEN 1
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=0 THEN  0
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=0 THEN 0
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=0 OR CAI.CBX_PUBL_PORT_API_ALQUILER=0) THEN 0
                            END AS PAC_CHECK_COMERCIALIZAR
                            ,CASE
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=1 THEN  SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=1 THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=1 OR CAI.CBX_PUBL_PORT_API_ALQUILER=1) THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=0 THEN  SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=0 THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=0 OR CAI.CBX_PUBL_PORT_API_ALQUILER=0) THEN SYSDATE
                            END AS PAC_FECHA_COMERCIALIZAR
                            ,CASE
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=1 THEN  1
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=1 THEN 1
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=1 OR CAI.CBX_PUBL_PORT_API_ALQUILER=1) THEN 1
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=0 THEN  0
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=0 THEN 0
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=0 OR CAI.CBX_PUBL_PORT_API_ALQUILER=0) THEN 0
                            END AS  PAC_CHECK_FORMALIZAR
                            ,CASE
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=1 THEN  SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=1 THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=1 OR CAI.CBX_PUBL_PORT_API_ALQUILER=1) THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND CAI.CBX_PUBL_PORT_API_VENTA=0 THEN  SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND CAI.CBX_PUBL_PORT_API_ALQUILER=0 THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND (CAI.CBX_PUBL_PORT_API_VENTA=0 OR CAI.CBX_PUBL_PORT_API_ALQUILER=0) THEN SYSDATE
                            END AS  PAC_FECHA_FORMALIZAR
                        FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO_CAIXA CAI ON CAI.ACT_ID=ACT.ACT_ID AND CAI.BORRADO=0
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID=APU.ACT_ID
                        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID=TCO.DD_TCO_ID
                        ) US ON (US.ACT_ID = PAC.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                            PAC.PAC_CHECK_COMERCIALIZAR=US.PAC_CHECK_COMERCIALIZAR  
                            ,PAC.PAC_FECHA_COMERCIALIZAR=US.PAC_FECHA_COMERCIALIZAR
                            ,PAC.PAC_CHECK_FORMALIZAR=US.PAC_CHECK_FORMALIZAR
                            ,PAC.PAC_FECHA_FORMALIZAR=US.PAC_FECHA_FORMALIZAR
                            ,PAC.USUARIOMODIFICAR = ''BATCH_USER''
                            ,PAC.FECHAMODIFICAR = SYSDATE
                            WHERE PAC.BORRADO=0 AND NVL(PAC.PAC_CHECK_COMERCIALIZAR,0)!=NVL(US.PAC_CHECK_COMERCIALIZAR,0) AND NVL(PAC.PAC_CHECK_FORMALIZAR,0)!=NVL(US.PAC_CHECK_FORMALIZAR,0)

   ';
   EXECUTE IMMEDIATE V_MSQL;
   

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' FUSIONADAS'|| CHR(10);


------------------------------------------------------------------------------------------------
----------------------------Lógica para el check de gestión comercial---------------------------
------------------------------------------------------------------------------------------------

--1º Validaciones en función de los destinos comerciales e indicadores API
    V_MSQL :=  'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                USING (	
                        SELECT
                            TMP.ACT_ID AS ACT_ID
                            ,CASE
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND DD_EPU_CODIGO=''01'' THEN 1
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND DD_EPU_CODIGO=''01'' THEN 1
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND DD_EPU_CODIGO=''01'' THEN 1
                                ELSE 0
                            END AS PAC_CHECK_GESTION_COMERCIAL 
                            ,CASE
                                WHEN TCO.DD_TCO_CODIGO=''01'' AND DD_EPU_CODIGO=''01'' THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''03'' AND DD_EPU_CODIGO=''01'' THEN SYSDATE
                                WHEN TCO.DD_TCO_CODIGO=''02'' AND DD_EPU_CODIGO=''01'' THEN SYSDATE
                                ELSE SYSDATE
                            END AS PAC_FECHA_GESTION_COMERCIAL
                        FROM '||V_ESQUEMA||'.TMP_ACT_DESTINO_COMERCIAL TMP
                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID=TMP.ACT_ID AND ACT.BORRADO=0
                        JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION EPU ON EPU.DD_EPU_ID=ACT.DD_EPU_ID
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON ACT.ACT_ID=APU.ACT_ID
                        JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID=TCO.DD_TCO_ID
                    ) US ON (US.ACT_ID = PAC.ACT_ID)
                                WHEN MATCHED THEN UPDATE SET
                                    PAC.PAC_CHECK_GESTION_COMERCIAL=US.PAC_CHECK_GESTION_COMERCIAL  
                                    ,PAC.PAC_FECHA_GESTION_COMERCIAL=US.PAC_FECHA_GESTION_COMERCIAL
                                    ,PAC.USUARIOMODIFICAR = ''BATCH_USER''
                                    ,PAC.FECHAMODIFICAR = SYSDATE
                                    WHERE PAC.BORRADO=0 AND NVL(PAC.PAC_CHECK_GESTION_COMERCIAL,0)!=NVL(US.PAC_CHECK_GESTION_COMERCIAL,0) 
   ';
   EXECUTE IMMEDIATE V_MSQL;
   

   V_NUM_FILAS := sql%rowcount;
   SALIDA := SALIDA || '##INFO: ' || V_NUM_FILAS ||' MODIFICADAS'|| CHR(10);



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
