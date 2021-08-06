--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210806
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
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_09_PRECIOS
	( FLAG_EN_REM IN NUMBER,
   SALIDA OUT VARCHAR2, 
	COD_RETORNO OUT NUMBER)

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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR PRECIOS.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - FECHA FIN EN ACT_VAL_VALORACIONES'||CHR(10);

       V_MSQL := '   MERGE INTO '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1
				using (		

             SELECT 
             act1.VAL_ID,
            act2.act_id as ACT_ID,
            IMP_PRECIO_VENTA/100 as VAL_IMPORTE,
            FEC_INICIO_PRECIO_VENTA  as VAL_FECHA_INICIO,
            FEC_FIN_PRECIO_VENTA as VAL_FECHA_FIN
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
              JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
              JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act2.ACT_ID = act1.ACT_ID AND act1.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02'') AND act1.BORRADO=0
             WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
             
             UNION
             
            SELECT 
            act1.VAL_ID,
            act2.act_id as ACT_ID,
            IMP_PRECIO_ALQUI/100 as VAL_IMPORTE,
            FEC_INICIO_PRECIO_ALQUI  as VAL_FECHA_INICIO,
            FEC_FIN_PRECIO_ALQUI as VAL_FECHA_FIN
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
              JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
              JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act2.ACT_ID = act1.ACT_ID AND act1.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03'') AND act1.BORRADO=0
             WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
             
             UNION
             
            SELECT 
            act1.VAL_ID,
            act2.act_id as ACT_ID,
            IMP_PRECIO_CAMP_VENTA/100 as VAL_IMPORTE,
            FEC_INICIO_PRECIO_CAMP_VENTA  as VAL_FECHA_INICIO,
            FEC_FIN_PRECIO_CAMP_VENTA as VAL_FECHA_FIN
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
              JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
              JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act2.ACT_ID = act1.ACT_ID AND act1.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07'') AND act1.BORRADO=0
             WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
             
              UNION
             
            SELECT 
            act1.VAL_ID,
            act2.act_id as ACT_ID,
            IMP_PRECIO_CAMP_ALQUI/100 as VAL_IMPORTE,
            FEC_INICIO_PRECIO_CAMP_ALQUI  as VAL_FECHA_INICIO,
            FEC_FIN_PRECIO_CAMP_ALQUI as VAL_FECHA_FIN
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
              JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
              JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act2.ACT_ID = act1.ACT_ID AND act1.DD_TPC_ID = (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA'') AND act1.BORRADO=0
             WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
            
            ) us ON (us.VAL_ID = act1.VAL_ID  )
            
                              when matched then update set
                            
                            act1.VAL_FECHA_FIN = 
                            (CASE WHEN (us.VAL_IMPORTE = act1.VAL_IMPORTE AND TO_DATE(us.VAL_FECHA_INICIO,''YYYYMMDD'') = act1.VAL_FECHA_INICIO) THEN TO_DATE(us.VAL_FECHA_FIN,''YYYYMMDD'') 
                                WHEN ((us.VAL_IMPORTE <> act1.VAL_IMPORTE OR TO_DATE(us.VAL_FECHA_INICIO,''YYYYMMDD'') <> act1.VAL_FECHA_INICIO)AND us.VAL_FECHA_INICIO IS NOT NULL ) THEN TO_DATE(us.VAL_FECHA_INICIO,''YYYYMMDD'') 
                                WHEN((us.VAL_IMPORTE <> act1.VAL_IMPORTE OR TO_DATE(us.VAL_FECHA_INICIO,''YYYYMMDD'') <> act1.VAL_FECHA_INICIO)AND us.VAL_FECHA_INICIO IS  NULL ) THEN  TO_DATE(SYSDATE,''DD/MM/YYYY'')
                            END)
                            ,act1.USUARIOMODIFICAR = ''STOCK_BC''
                            ,act1.FECHAMODIFICAR = sysdate';
 EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 2 - INSERTAR EN ACT_VAL_VALORACIONES VALORACIONES QUE EXISTEN'||CHR(10);

      V_MSQL := '  INSERT INTO '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES (VAL_ID,
                     ACT_ID,
                     DD_TPC_ID,
                     VAL_IMPORTE,
                     VAL_FECHA_INICIO,
                     VAL_FECHA_FIN,
                     USUARIOCREAR,
                     FECHACREAR)

                     SELECT '|| V_ESQUEMA ||'.S_ACT_VAL_VALORACIONES.NEXTVAL as VAL_ID,

                     a.ACT_ID,
                     a.DD_TPC_ID,
                     a.VAL_IMPORTE,
                     a.VAL_FECHA_INICIO,
                     a.VAL_FECHA_FIN,
                     a.USUARIOCREAR,
                     a.FECHACREAR
                     FROM(

                     SELECT
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02'') as DD_TPC_ID,
                     IMP_PRECIO_VENTA/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_VENTA,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_VENTA,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR                  
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act1.ACT_ID = act2.ACT_ID AND act1.BORRADO=0 
                     WHERE (aux.IMP_PRECIO_VENTA/100 <> act1.VAL_IMPORTE OR TO_DATE(aux.FEC_INICIO_PRECIO_VENTA,''YYYYMMDD'') <> act1.VAL_FECHA_INICIO)
                           AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02'')
                           AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                           AND act1.FECHACREAR = (SELECT MAX(act1.FECHACREAR) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 WHERE act1.ACT_ID =act2.act_id AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02'')  )                        


                        UNION

                     SELECT
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03'') as DD_TPC_ID,
                     IMP_PRECIO_ALQUI/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_ALQUI,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_ALQUI,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act1.ACT_ID = act2.ACT_ID AND act1.BORRADO=0
                     WHERE (aux.IMP_PRECIO_ALQUI/100 <> act1.VAL_IMPORTE OR TO_DATE(aux.FEC_INICIO_PRECIO_ALQUI,''YYYYMMDD'') <> act1.VAL_FECHA_INICIO)
                           AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03'')
                           AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                           AND act1.FECHACREAR = (SELECT MAX(act1.FECHACREAR) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 WHERE act1.ACT_ID =act2.act_id AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03'')  ) 

                           UNION

                     SELECT
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07'') as DD_TPC_ID,
                     IMP_PRECIO_CAMP_VENTA/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_CAMP_VENTA,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_CAMP_VENTA,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act1.ACT_ID = act2.ACT_ID AND act1.BORRADO=0
                     WHERE (aux.IMP_PRECIO_CAMP_VENTA/100 <> act1.VAL_IMPORTE OR TO_DATE(aux.FEC_INICIO_PRECIO_CAMP_VENTA,''YYYYMMDD'') <> act1.VAL_FECHA_INICIO)
                           AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07'')
                           AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                           AND act1.FECHACREAR = (SELECT MAX(act1.FECHACREAR) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 WHERE act1.ACT_ID =act2.act_id AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07'')  ) 

                        UNION

                     SELECT
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA'') as DD_TPC_ID,
                     IMP_PRECIO_CAMP_ALQUI/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_CAMP_ALQUI,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_CAMP_ALQUI,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 ON act1.ACT_ID = act2.ACT_ID AND act1.BORRADO=0
                     WHERE (aux.IMP_PRECIO_CAMP_ALQUI/100 <> act1.VAL_IMPORTE OR TO_DATE(aux.FEC_INICIO_PRECIO_CAMP_ALQUI,''YYYYMMDD'') <> act1.VAL_FECHA_INICIO)
                           AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA'')
                           AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                           AND act1.FECHACREAR = (SELECT MAX(act1.FECHACREAR) FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 WHERE act1.ACT_ID =act2.act_id AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA'')  ) 
                     )a';
 EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 3 - INSERTAR EN ACT_VAL_VALORACIONES VALORACIONES QUE NO EXISTEN'||CHR(10);

      V_MSQL := '  INSERT INTO '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES (VAL_ID,
                     ACT_ID,
                     DD_TPC_ID,
                     VAL_IMPORTE,
                     VAL_FECHA_INICIO,
                     VAL_FECHA_FIN,
                     USUARIOCREAR,
                     FECHACREAR)

                     SELECT '|| V_ESQUEMA ||'.S_ACT_VAL_VALORACIONES.NEXTVAL as VAL_ID,
                     a.ACT_ID,
                     a.DD_TPC_ID,
                     a.VAL_IMPORTE,
                     a.VAL_FECHA_INICIO,
                     a.VAL_FECHA_FIN,
                     a.USUARIOCREAR,
                     a.FECHACREAR
                     FROM(

                     SELECT 
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02'') as DD_TPC_ID,
                     IMP_PRECIO_VENTA/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_VENTA,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_VENTA,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     WHERE NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 
                                          WHERE act1.ACT_ID = act2.ACT_ID  
                                          AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02''))
                                          AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                                          
                     UNION
                     
                     SELECT 
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03'') as DD_TPC_ID,
                     IMP_PRECIO_ALQUI/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_ALQUI,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_ALQUI,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     WHERE NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 
                                          WHERE act1.ACT_ID = act2.ACT_ID  
                                          AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03''))
                                          AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                                          
                     UNION
                     
                     SELECT 
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA'') as DD_TPC_ID,
                     IMP_PRECIO_CAMP_ALQUI/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_CAMP_ALQUI,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_CAMP_ALQUI,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     WHERE NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 
                                          WHERE act1.ACT_ID = act2.ACT_ID  
                                          AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA''))    
                                          AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                     
                     UNION                   
                                          
                     SELECT 
                     aux.NUM_IDENTIFICATIVO,
                     act2.act_id,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07'') as DD_TPC_ID,
                     IMP_PRECIO_CAMP_VENTA/100 as VAL_IMPORTE,
                     NVL(TO_DATE(FEC_INICIO_PRECIO_CAMP_VENTA,''YYYYMMDD''),TO_CHAR(SYSDATE,''DD/MM/YYYY'') )  as VAL_FECHA_INICIO,
                     TO_DATE(FEC_FIN_PRECIO_CAMP_VENTA,''YYYYMMDD'') as VAL_FECHA_FIN,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
                     WHERE NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES act1 
                                          WHERE act1.ACT_ID = act2.ACT_ID  
                                          AND act1.DD_TPC_ID =(SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07''))     
                                          AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                                          
                     ) a';
 EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 4 - INSERTAR EN ACT_DCC_DESCUENTO_COLECTIVOS DESCUENTOS QUE LLEGAN Y NO EXISTEN'||CHR(10);

      V_MSQL := '  INSERT INTO '|| V_ESQUEMA ||'.ACT_DCC_DESCUENTO_COLECTIVOS (ADC_ID,
                     ACT_ID,
                     DD_DCC_ID,
                     DD_TPC_ID,
                     USUARIOCREAR,
                     FECHACREAR)

                     WITH DESCUENTOS AS 
                     (
                     
                     SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                     act1.ACT_ID as ACT_ID,
                     regexp_substr(DESC_COL_PRECIO_VENTA,''[^-]+'',1,LEVEL) AS DESCUENTO,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02'') as DD_TPC_ID,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0  AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                     CONNECT BY regexp_substr(DESC_COL_PRECIO_VENTA,''[^-]+'',1,LEVEL) IS NOT NULL

                     UNION

                     SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                     act1.ACT_ID as ACT_ID,
                     regexp_substr(DESC_COLEC_PRECIO_ALQUI,''[^-]+'',1,LEVEL) AS DESCUENTO,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03'') as DD_TPC_ID,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0  AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                     CONNECT BY regexp_substr(DESC_COLEC_PRECIO_ALQUI,''[^-]+'',1,LEVEL) IS NOT NULL

                     UNION

                     SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                     act1.ACT_ID as ACT_ID,
                     regexp_substr(DESC_COL_PRECIO_CAMP_VENTA,''[^-]+'',1,LEVEL) AS DESCUENTO,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07'') as DD_TPC_ID,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0  AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                     CONNECT BY regexp_substr(DESC_COL_PRECIO_CAMP_VENTA,''[^-]+'',1,LEVEL) IS NOT NULL

                     UNION

                     SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                     act1.ACT_ID as ACT_ID,
                     regexp_substr(DESC_COL_PRECIO_CAMP_ALQUI,''[^-]+'',1,LEVEL) AS DESCUENTO,
                     (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA'') as DD_TPC_ID,
                     ''STOCK_BC'' as USUARIOCREAR,
                     SYSDATE as FECHACREAR
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0  AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                     CONNECT BY regexp_substr(DESC_COL_PRECIO_CAMP_ALQUI,''[^-]+'',1,LEVEL) IS NOT NULL
                     )

                     SELECT '|| V_ESQUEMA ||'.S_ACT_DCC_DESCUENTO_COLECTIVOS.NEXTVAL as ADC_ID,
                     a.ACT_ID,
                     a.DESCUENTO,
                     a.DD_TPC_ID,
                     a.USUARIOCREAR,
                     a.FECHACREAR
                     FROM DESCUENTOS a                         
                           WHERE NOT EXISTS (SELECT ACT_ID,DD_DCC_ID,DD_TPC_ID 
                                             FROM '|| V_ESQUEMA ||'.ACT_DCC_DESCUENTO_COLECTIVOS act2 
                                             WHERE a.ACT_ID = act2.ACT_ID 
                                                   AND a.DESCUENTO = act2.DD_DCC_ID 
                                                   AND a.DD_TPC_ID = act2.DD_TPC_ID
                                                   
                                                   )';
 EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 4 - BORRADO LOGICO EN ACT_DCC_DESCUENTO_COLECTIVOS DESCUENTOS QUE EXISTEN Y YA NO LLEGAN'||CHR(10);

      V_MSQL := '  MERGE INTO '|| V_ESQUEMA ||'.ACT_DCC_DESCUENTO_COLECTIVOS act3
				using (


                  WITH DESCUENTOS AS 
                  (
                  
                  SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                  act1.ACT_ID as ACT_ID,
                  regexp_substr(DESC_COL_PRECIO_VENTA,''[^-]+'',1,LEVEL) AS DESCUENTO,
                  (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''02'') as DD_TPC_ID,
                  ''STOCK_BC'' as USUARIOCREAR,
                  SYSDATE as FECHACREAR
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0  AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  CONNECT BY regexp_substr(DESC_COL_PRECIO_VENTA,''[^-]+'',1,LEVEL) IS NOT NULL


                  UNION

                  SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                  act1.ACT_ID as ACT_ID,
                  regexp_substr(DESC_COLEC_PRECIO_ALQUI,''[^-]+'',1,LEVEL) AS DESCUENTO,
                  (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''03'') as DD_TPC_ID,
                  ''STOCK_BC'' as USUARIOCREAR,
                  SYSDATE as FECHACREAR
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0 AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  CONNECT BY regexp_substr(DESC_COLEC_PRECIO_ALQUI,''[^-]+'',1,LEVEL) IS NOT NULL


                  UNION

                  SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                  act1.ACT_ID as ACT_ID,
                  regexp_substr(DESC_COL_PRECIO_CAMP_VENTA,''[^-]+'',1,LEVEL) AS DESCUENTO,
                  (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''07'') as DD_TPC_ID,
                  ''STOCK_BC'' as USUARIOCREAR,
                  SYSDATE as FECHACREAR
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0  AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  CONNECT BY regexp_substr(DESC_COL_PRECIO_CAMP_VENTA,''[^-]+'',1,LEVEL) IS NOT NULL


                  UNION

                  SELECT DISTINCT aux.NUM_IDENTIFICATIVO,
                  act1.ACT_ID as ACT_ID,
                  regexp_substr(DESC_COL_PRECIO_CAMP_ALQUI,''[^-]+'',1,LEVEL) AS DESCUENTO,
                  (SELECT DD_TPC_ID FROM '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO WHERE DD_TPC_CODIGO=''DAA'') as DD_TPC_ID,
                  ''STOCK_BC'' as USUARIOCREAR,
                  SYSDATE as FECHACREAR
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act1 ON act1.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act1.BORRADO=0  AND aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  CONNECT BY regexp_substr(DESC_COL_PRECIO_CAMP_ALQUI,''[^-]+'',1,LEVEL) IS NOT NULL

                  )

                  SELECT 
                  act2.ACT_ID,
                  act2.DD_DCC_ID,
                  act2.DD_TPC_ID
                  FROM '|| V_ESQUEMA ||'.ACT_DCC_DESCUENTO_COLECTIVOS act2                      
                        WHERE NOT EXISTS (SELECT ACT_ID,DESCUENTO,DD_TPC_ID 
                                          FROM DESCUENTOS a 
                                          WHERE a.ACT_ID = act2.ACT_ID 
                                                AND act2.DD_DCC_ID = a.DESCUENTO 
                                                AND act2.DD_TPC_ID = a.DD_TPC_ID
                                                ) AND act2.BORRADO = 0
                                                
                                                
                                 ) us ON (us.ACT_ID = act3.ACT_ID AND us.DD_DCC_ID = act3.DD_DCC_ID AND us.DD_TPC_ID = act3.DD_TPC_ID)
                                          WHEN MATCHED THEN UPDATE SET
                                          act3.BORRADO = 1,
                                          act3.USUARIOBORRAR = ''STOCK_BC'',
                                          act3.FECHABORRAR = sysdate';
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
END SP_BCR_09_PRECIOS;
/
EXIT;
