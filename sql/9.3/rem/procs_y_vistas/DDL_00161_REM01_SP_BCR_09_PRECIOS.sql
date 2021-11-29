--/*
--##########################################
--## AUTOR=DÀP
--## FECHA_CREACION=20210812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14837
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-14270
--##	      0.2 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - HREOS-14545
--##	      0.2 Formato de importes - HREOS-14837
--##          0.3 Ajustes de optimización y rendimiento - HREOS-14837
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_09_PRECIOS
    (FLAG_EN_REM IN NUMBER,
    SALIDA OUT VARCHAR2, 
    COD_RETORNO OUT NUMBER) AS

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_AUX NUMBER(10); -- Variable auxiliar
    V_FECHA_INICIO VARCHAR2(100 CHAR);
    V_FECHA_FIN VARCHAR2(100 CHAR);
    V_COUNT NUMBER(16);
    V_SUBSTR NUMBER(16);
    V_INCREM NUMBER(16);
    
    TYPE D_COLECTIVOS IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE D_ARRAY_COLECTIVOS IS TABLE OF D_COLECTIVOS;
    V_DESCUENTOS D_ARRAY_COLECTIVOS := D_ARRAY_COLECTIVOS(
          D_COLECTIVOS('DESC_COL_PRECIO_VENTA', '02'),
          D_COLECTIVOS('DESC_COLEC_PRECIO_ALQUI', '03'),
          D_COLECTIVOS('DESC_COL_PRECIO_CAMP_VENTA', '07'),
          D_COLECTIVOS('DESC_COL_PRECIO_CAMP_ALQUI', 'DAA')
    ); 
    V_TMP_DESCUENTOS D_COLECTIVOS;


BEGIN

    SALIDA := '[INICIO]'||CHR(10);
    
    SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR PRECIOS.'|| CHR(10);
    
    SALIDA := SALIDA || '   [INFO] 1 - TRUNCAMOS TABLA TEMPORAL DE DESCUENTOS COLECTIVOS.'||CHR(10);
    
    EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_DESCUENTOS_COLECTIVOS_STOCK';
    
    SALIDA := SALIDA || '       [INFO] TABLA TRUNCADA.'|| CHR(10);

    SALIDA := SALIDA || '   [INFO] 2 - FECHA FIN EN PRECIOS CADUCADOS'||CHR(10);

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES T1
        USING (
            SELECT VAL.VAL_ID,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_VENTA, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_INICIO,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_VENTA, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_FIN
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID 
                AND VAL.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
                AND TPC.BORRADO = 0
            WHERE TPC.DD_TPC_CODIGO = ''02''
                AND AUX.FLAG_EN_REM = '||FLAG_EN_REM||'
                AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                AND (NVL(AUX.IMP_PRECIO_VENTA, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0)
                    OR COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    OR COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                )
                
            UNION
            
            SELECT VAL.VAL_ID,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_ALQUI, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_INICIO,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_ALQUI, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_FIN
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID 
                AND VAL.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
                AND TPC.BORRADO = 0
            WHERE TPC.DD_TPC_CODIGO = ''03''
                AND AUX.FLAG_EN_REM = '||FLAG_EN_REM||'
                AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                AND (NVL(AUX.IMP_PRECIO_ALQUI, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0)
                    OR COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    OR COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                ) 
            
            UNION

            SELECT VAL.VAL_ID,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_CAMP_VENTA, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_INICIO,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_CAMP_VENTA, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_FIN
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID 
                AND VAL.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
                AND TPC.BORRADO = 0
            WHERE TPC.DD_TPC_CODIGO = ''07''
                AND AUX.FLAG_EN_REM = '||FLAG_EN_REM||'
                AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                AND (NVL(AUX.IMP_PRECIO_CAMP_VENTA, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0)
                    OR COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    OR COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_VENTA, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                )
                
            UNION
            
            SELECT VAL.VAL_ID,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_CAMP_ALQUI, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_INICIO,
                CASE
                    WHEN NVL(AUX.IMP_PRECIO_CAMP_ALQUI, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0) 
                        THEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    WHEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        THEN COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                        ELSE NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                    END NEW_VAL_FECHA_FIN
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID 
                AND VAL.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
                AND TPC.BORRADO = 0
            WHERE TPC.DD_TPC_CODIGO = ''DAA''
                AND AUX.FLAG_EN_REM = '||FLAG_EN_REM||'
                AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                AND (NVL(AUX.IMP_PRECIO_CAMP_ALQUI, 0)/100 <> NVL(VAL.VAL_IMPORTE, 0)
                    OR COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD''))
                    OR COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD'')) <> NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                ) 
        ) T2
        ON (T1.VAL_ID = T2.VAL_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.VAL_FECHA_FIN = T2.NEW_VAL_FECHA_FIN
                , T1.VAL_FECHA_INICIO = LEAST(T2.NEW_VAL_FECHA_INICIO, T2.NEW_VAL_FECHA_FIN)
                , T1.USUARIOMODIFICAR = ''STOCK_BC''
                , T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;

    SALIDA := SALIDA || '       [INFO] PRECIOS FINALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

    SALIDA := SALIDA || '   [INFO] 3 - INSERTAR NUEVOS PRECIOS'||CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_VAL_VALORACIONES (VAL_ID, ACT_ID, DD_TPC_ID, VAL_IMPORTE, VAL_FECHA_INICIO, VAL_FECHA_FIN, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_VAL_VALORACIONES.NEXTVAL, ACT_ID, DD_TPC_ID, VAL_IMPORTE, VAL_FECHA_INICIO, VAL_FECHA_FIN, ''STOCK_BC'', SYSDATE
        FROM (
            SELECT ACT.ACT_ID AS ACT_ID,
                AUX.IMP_PRECIO_VENTA/100 AS VAL_IMPORTE,
                COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_VENTA, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AS VAL_FECHA_INICIO,
                COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_VENTA, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD'')) AS VAL_FECHA_FIN,
                TPC.DD_TPC_ID
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = ''02''
                AND TPC.BORRADO = 0
            WHERE SYSDATE BETWEEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_VENTA, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AND COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_VENTA, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD''))
                AND NVL(AUX.IMP_PRECIO_VENTA, 0) <> 0
                AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
                        WHERE VAL.BORRADO = 0
                            AND NVL(VAL.VAL_IMPORTE, 0) = AUX.IMP_PRECIO_VENTA/100
                            AND VAL.DD_TPC_ID = TPC.DD_TPC_ID
                            AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                            AND VAL.ACT_ID = ACT.ACT_ID
                    )

            UNION

            SELECT ACT.ACT_ID AS ACT_ID,
                AUX.IMP_PRECIO_ALQUI/100 AS VAL_IMPORTE,
                COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_ALQUI, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AS VAL_FECHA_INICIO,
                COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_ALQUI, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD'')) AS VAL_FECHA_FIN,
                TPC.DD_TPC_ID
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = ''03''
                AND TPC.BORRADO = 0
            WHERE SYSDATE BETWEEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_ALQUI, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AND COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_ALQUI, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD''))
                AND NVL(AUX.IMP_PRECIO_ALQUI, 0) <> 0
                AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
                        WHERE NVL(VAL.VAL_IMPORTE, 0) = AUX.IMP_PRECIO_ALQUI/100
                            AND VAL.DD_TPC_ID = TPC.DD_TPC_ID
                            AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                            AND VAL.ACT_ID = ACT.ACT_ID
                    )   

            UNION

            SELECT ACT.ACT_ID AS ACT_ID,
                AUX.IMP_PRECIO_CAMP_VENTA/100 AS VAL_IMPORTE,
                COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_VENTA, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AS VAL_FECHA_INICIO,
                COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_VENTA, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD'')) AS VAL_FECHA_FIN,
                TPC.DD_TPC_ID
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = ''07''
                AND TPC.BORRADO = 0
            WHERE SYSDATE BETWEEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_VENTA, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AND COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_VENTA, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD''))
                AND NVL(AUX.IMP_PRECIO_CAMP_VENTA, 0) <> 0
                AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
                        WHERE NVL(VAL.VAL_IMPORTE, 0) = AUX.IMP_PRECIO_CAMP_VENTA/100
                            AND VAL.DD_TPC_ID = TPC.DD_TPC_ID
                            AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                            AND VAL.ACT_ID = ACT.ACT_ID
                    )   

            UNION

            SELECT ACT.ACT_ID AS ACT_ID,
                AUX.IMP_PRECIO_CAMP_ALQUI/100 AS VAL_IMPORTE,
                COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AS VAL_FECHA_INICIO,
                COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD'')) AS VAL_FECHA_FIN,
                TPC.DD_TPC_ID
            FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO 
                AND ACT.BORRADO=0
            JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = ''DAA''
                AND TPC.BORRADO = 0
            WHERE SYSDATE BETWEEN COALESCE(TO_DATE(AUX.FEC_INICIO_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), TO_DATE(''19000101'',''YYYYMMDD'')) AND COALESCE(TO_DATE(AUX.FEC_FIN_PRECIO_CAMP_ALQUI, ''YYYYMMDD''), TO_DATE(''20991231'',''YYYYMMDD''))
                AND NVL(AUX.IMP_PRECIO_CAMP_ALQUI, 0) <> 0
                AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL
                        WHERE NVL(VAL.VAL_IMPORTE, 0) = AUX.IMP_PRECIO_CAMP_ALQUI/100
                            AND VAL.DD_TPC_ID = TPC.DD_TPC_ID
                            AND SYSDATE BETWEEN NVL(VAL.VAL_FECHA_INICIO, TO_DATE(''19000101'',''YYYYMMDD'')) AND NVL(VAL.VAL_FECHA_FIN, TO_DATE(''20991231'',''YYYYMMDD''))
                            AND VAL.ACT_ID = ACT.ACT_ID
                    )   
        )';
    EXECUTE IMMEDIATE V_MSQL;

    SALIDA := SALIDA || '       [INFO] PRECIOS CREADOS '|| SQL%ROWCOUNT|| CHR(10);

    SALIDA := SALIDA || '   [INFO] 4 - DESCOMPONEMOS CAMPOS DESCUENTOS COLECTIVOS QUE LLEGAN'||CHR(10);
    
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_DCC_DESCUENTOS_COLECTIVOS WHERE BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    
    V_MSQL := 'SELECT MAX(LENGTH(DD_DCC_CODIGO)) + 1 INCREM FROM '||V_ESQUEMA||'.DD_DCC_DESCUENTOS_COLECTIVOS WHERE BORRADO = 0';
    EXECUTE IMMEDIATE V_MSQL INTO V_INCREM;
    
    FOR I IN V_DESCUENTOS.FIRST .. V_DESCUENTOS.LAST
    LOOP
        V_TMP_DESCUENTOS := V_DESCUENTOS(I);
        
        V_SUBSTR := 1;
        
        FOR J IN 1 .. V_COUNT
        LOOP
        
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_DESCUENTOS_COLECTIVOS_STOCK (ACT_ID, DD_DCC_ID, DD_TPC_ID)
                SELECT ACT.ACT_ID, 
                    DCC.DD_DCC_ID, 
                    TPC.DD_TPC_ID
                FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO
                    AND ACT.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_DCC_DESCUENTOS_COLECTIVOS DCC ON DCC.DD_DCC_CODIGO = SUBSTR(AUX.'||V_TMP_DESCUENTOS(1)||', '||V_SUBSTR||', 3)
                    AND DCC.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_CODIGO = '''||V_TMP_DESCUENTOS(2)||'''
                    AND TPC.BORRADO = 0
                WHERE AUX.FLAG_EN_REM = '||FLAG_EN_REM;
            EXECUTE IMMEDIATE V_MSQL;
            
            V_SUBSTR := V_SUBSTR + V_INCREM;
        
        END LOOP;
        
    END LOOP;
    
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TMP_DESCUENTOS_COLECTIVOS_STOCK';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;

    SALIDA := SALIDA || '       [INFO] INSERTADOS '|| V_COUNT ||CHR(10);

    SALIDA := SALIDA || '   [INFO] 5 - INSERTAR EN ACT_DCC_DESCUENTO_COLECTIVOS DESCUENTOS QUE LLEGAN Y NO EXISTEN'||CHR(10);

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_DCC_DESCUENTO_COLECTIVOS (ADC_ID, ACT_ID, DD_DCC_ID, DD_TPC_ID, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_ACT_DCC_DESCUENTO_COLECTIVOS.NEXTVAL AS ADC_ID,
            DES.ACT_ID,
            DES.DD_DCC_ID,
            DES.DD_TPC_ID,
            ''STOCK_BC'' USUARIOCREAR,
            SYSDATE
        FROM '||V_ESQUEMA||'.TMP_DESCUENTOS_COLECTIVOS_STOCK DES
        WHERE NOT EXISTS (
                SELECT 1
                FROM '||V_ESQUEMA||'.ACT_DCC_DESCUENTO_COLECTIVOS COL 
                WHERE DES.ACT_ID = COL.ACT_ID 
                    AND DES.DD_DCC_ID = COL.DD_DCC_ID 
                    AND DES.DD_TPC_ID = COL.DD_TPC_ID
                    AND COL.BORRADO = 0
            )';
    EXECUTE IMMEDIATE V_MSQL;

    SALIDA := SALIDA || '       [INFO] INSERTADOS '|| SQL%ROWCOUNT|| CHR(10);

    SALIDA := SALIDA || '   [INFO] 6 - BORRADO LOGICO EN ACT_DCC_DESCUENTO_COLECTIVOS DESCUENTOS QUE EXISTEN Y YA NO LLEGAN'||CHR(10);

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_DCC_DESCUENTO_COLECTIVOS T1
        USING (
            SELECT DCC.ADC_ID
            FROM '||V_ESQUEMA||'.ACT_DCC_DESCUENTO_COLECTIVOS DCC
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = DCC.ACT_ID
                AND ACT.BORRADO = 0
            JOIN '||V_ESQUEMA||'.AUX_APR_BCR_STOCK AUX ON AUX.NUM_IDENTIFICATIVO = ACT.ACT_NUM_ACTIVO_CAIXA
            WHERE AUX.FLAG_EN_REM = '||FLAG_EN_REM||'
                AND DCC.BORRADO = 0
                AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.TMP_DESCUENTOS_COLECTIVOS_STOCK TMP
                        WHERE TMP.ACT_ID = DCC.ACT_ID
                            AND TMP.DD_DCC_ID = DCC.DD_DCC_ID
                            AND TMP.DD_TPC_ID = DCC.DD_TPC_ID
                    )
        ) T2
        ON (T1.ADC_ID = T2.ADC_ID)
        WHEN MATCHED THEN
            UPDATE SET T1.USUARIOBORRAR = ''STOCK_BC''
                , T1.FECHABORRAR = SYSDATE
                , T1.BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

    SALIDA := SALIDA || '       [INFO] BORRADOS '|| SQL%ROWCOUNT|| CHR(10);

    DBMS_OUTPUT.PUT_LINE(SALIDA);
    
    COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    [V_MSQL] ';
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_BCR_09_PRECIOS;
/
EXIT;
