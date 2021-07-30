--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210728
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14745
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14088] - Santi Monzó 
--##        0.2 Se ha modificado la equivalencia del campo ACT_ACTIVO.DD_SCR_ID  y Revisión- [HREOS-14344] - Alejandra García
--##        0.3 Inclusión de cambios en modelo Fase 1 - [HREOS-14442] - Daniel Algaba
--##        0.4 Imcluir campo ESTADO_TECNICO - [HREOS-14545] - Alejandra García
--##        0.5 Inclusión de cambios en modelo Fase 1 - [HREOS-14344] - Alejandra García
--##        0.6 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - [HREOS-14545] - Daniel Algaba
--##        0.7 Gestores de gestoría de admisión y administración - [HREOS-14545] - Daniel Algaba
--##	      0.8 Campos IND_ENTREGA_VOL_POSESI - HREOS-14745 - Alejandra García
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						



CREATE OR REPLACE PROCEDURE SP_BCR_01_DATOS_BASICOS
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

  

      DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR EN BIE_BIEN SI EL ACTIVO NO EXISTE.');

      V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.BIE_BIEN bie(
                  BIE_ID,
                  BIE_NUMERO_ACTIVO,
                  USUARIOCREAR,
                  FECHACREAR)
                  SELECT
                     '|| V_ESQUEMA ||'.S_BIE_BIEN.NEXTVAL AS BIE_ID,
                     BIE_NUMERO_ACTIVO,
                     USUARIOCREAR,
                     FECHACREAR
                     FROM(
                     SELECT DISTINCT 
                              BIE_NUMERO_ACTIVO,
                              ''STOCK_BC'' AS USUARIOCREAR,
                              sysdate AS FECHACREAR
                              FROM (SELECT
                                 aux.NUM_IDENTIFICATIVO as BIE_NUMERO_ACTIVO
                                 FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                                 WHERE NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.BIE_BIEN bie 
                                                   WHERE bie.BIE_NUMERO_ACTIVO = aux.NUM_IDENTIFICATIVO)))';
                  
      EXECUTE IMMEDIATE V_MSQL;
   
   
  

      DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR/ACTUALIZAR EN ACT_ACTIVO.');

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO act
				using (				
                           
                  SELECT       
                  aux.NUM_INMUEBLE as ACT_NUM_ACTIVO,
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
                  SAC.DD_SAC_ID AS DD_SAC_ID,
                  STA.DD_TTA_ID AS DD_TTA_ID,
                  STA.DD_STA_ID AS DD_STA_ID,
                  prp.DD_PRP_ID as DD_PRP_ID,
                  CASE
                     WHEN AUX.VIVIENDA_HABITUAL=''S'' THEN ''01''
                     ELSE NULL
                  END AS DD_TUD_ID,
                  aux.PORC_OBRA_EJECUTADA/100 as ACT_PORCENTAJE_CONSTRUCCION,
                  SCR.DD_SCR_ID AS DD_SCR_ID, 
                  SCR.DD_CRA_ID AS DD_CRA_ID, 
                  SPG.DD_SPG_ID AS DD_SPG_ID,
                  bie.BIE_ID AS BIE_ID,
                  act.act_id as act_id
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN bie ON bie.BIE_NUMERO_ACTIVO = aux.NUM_IDENTIFICATIVO
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = bie.BIE_NUMERO_ACTIVO AND ACT.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''PRODUCTO''  AND eqv1.DD_CODIGO_CAIXA = aux.PRODUCTO AND EQV1.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_CODIGO = eqv1.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''SOCIEDAD_PATRIMONIAL''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_PATRIMONIAL 
                                                            AND EQV2.DD_NOMBRE_REM=''DD_SCR_SUBCARTERA'' and eqv2.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_CODIGO = eqv2.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''BANCO_ORIGEN''  AND eqv3.DD_CODIGO_CAIXA = aux.BANCO_ORIGEN AND EQV3.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SPG_SOCIEDAD_PAGO_ANTERIOR spg ON spg.DD_SPG_CODIGO = eqv3.DD_CODIGO_REM  
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv4 ON eqv4.DD_NOMBRE_CAIXA = ''CLASE_USO''  AND eqv4.DD_CODIGO_CAIXA = aux.CLASE_USO AND EQV4.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO sac ON sac.DD_SAC_CODIGO = eqv4.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv5 ON eqv5.DD_NOMBRE_CAIXA = ''PROCEDENCIA_PRODUCTO''  AND eqv5.DD_CODIGO_CAIXA = aux.PROCEDENCIA_PRODUCTO AND EQV5.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_PRP_PROCEDENCIA_PRODUCTO prp ON prp.DD_PRP_CODIGO = eqv5.DD_CODIGO_REM  
                  WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                                       
                                 ) us ON (us.act_id = act.act_id)
                                 when matched then update set
                                    act.DD_SAC_ID = us.DD_SAC_ID 
                                    ,act.DD_TTA_ID = us.DD_TTA_ID  
                                    ,act.DD_STA_ID = us.DD_STA_ID
                                    ,act.DD_PRP_ID = us.DD_PRP_ID
                                    ,act.DD_TUD_ID = us.DD_TUD_ID
                                    ,act.ACT_PORCENTAJE_CONSTRUCCION = us.ACT_PORCENTAJE_CONSTRUCCION           
                                    ,act.DD_SCR_ID = us.DD_SCR_ID
                                    ,act.DD_CRA_ID = us.DD_CRA_ID
                                    ,act.DD_SPG_ID = us.DD_SPG_ID
                                    ,act.USUARIOMODIFICAR = ''STOCK_BC''
                                    ,act.FECHAMODIFICAR = sysdate
                                       
                                 WHEN NOT MATCHED THEN
                                 INSERT  (ACT_ID, 
                                          ACT_NUM_ACTIVO,
                                          ACT_NUM_ACTIVO_REM,
                                          ACT_NUM_ACTIVO_CAIXA,                                       
                                          DD_SAC_ID,
                                          DD_TTA_ID,
                                          DD_STA_ID,
                                          DD_PRP_ID,
                                          DD_TUD_ID,
                                          ACT_PORCENTAJE_CONSTRUCCION,
                                          DD_SCR_ID,
                                          DD_CRA_ID,
                                          DD_SPG_ID,
                                          BIE_ID,                                                                            
                                          USUARIOCREAR,
                                          FECHACREAR
                                          )
                                 VALUES ('|| V_ESQUEMA ||'.S_ACT_ACTIVO.NEXTVAL,
                                          us.ACT_NUM_ACTIVO,
                                          '|| V_ESQUEMA ||'.S_ACT_NUM_ACTIVO_REM.NEXTVAL,
                                          us.ACT_NUM_ACTIVO_CAIXA,
                                          us.DD_SAC_ID,
                                          us.DD_TTA_ID,
                                          us.DD_STA_ID,
                                          us.DD_PRP_ID,
                                          us.DD_TUD_ID,
                                          us.ACT_PORCENTAJE_CONSTRUCCION,
                                          us.DD_SCR_ID,
                                          us.DD_CRA_ID,
                                          us.DD_SPG_ID,
                                          us.BIE_ID,
                                          ''STOCK_BC'',
                                          sysdate)';

   EXECUTE IMMEDIATE V_MSQL;
   

      DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR/ACTUALIZAR EN ACT_ACTIVO_CAIXA.');

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO_CAIXA act1
				using (		

               SELECT
               aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
               act2.ACT_ID as ACT_ID,
               eca.DD_ECA_ID as DD_ECA_ID,
               TO_DATE(aux.FEC_ESTADO_COMERCIAL_ALQUILER,''yyyymmdd'') as FECHA_ECA_EST_COM_ALQUILER,
               ecv.DD_ECV_ID as DD_ECV_ID,
               TO_DATE(aux.FEC_ESTADO_COMERCIAL_VENTA,''yyyymmdd'') as FECHA_ECV_EST_COM_VENTA,
               CASE
                  WHEN aux.NECESIDAD_ARRAS IN (''S'',''1'') THEN 1
                  WHEN aux.NECESIDAD_ARRAS IN (''N'',''0'') THEN 0
               END as CBX_NECESIDAD_ARRAS,
               mna.DD_MNA_ID as DD_MNA_ID,
               CASE
                  WHEN aux.PRECIO_VENTA_NEGOCIABLE IN (''S'',''1'') THEN 1
                  WHEN aux.PRECIO_VENTA_NEGOCIABLE IN (''N'',''0'') THEN 0
               END as CBX_PRECIO_VENT_NEGO,
               CASE
                  WHEN aux.PRECIO_ALQUI_NEGOCIABLE IN (''S'',''1'') THEN 1
                  WHEN aux.PRECIO_ALQUI_NEGOCIABLE IN (''N'',''0'') THEN 0
               END as CBX_PRECIO_ALQU_NEGO,
               CASE
                  WHEN aux.PRECIO_CAMP_ALQUI_NEGOCIABLE IN (''S'',''1'') THEN 1
                  WHEN aux.PRECIO_CAMP_ALQUI_NEGOCIABLE IN (''N'',''0'') THEN 0
               END as CBX_CAMP_PRECIO_ALQ_NEGO,
               CASE
                  WHEN aux.PRECIO_CAMP_VENTA_NEGOCIABLE IN (''S'',''1'') THEN 1
                  WHEN aux.PRECIO_CAMP_VENTA_NEGOCIABLE IN (''N'',''0'') THEN 0
               END as CBX_CAMP_PRECIO_VENT_NEGO,
               CASE
                  WHEN aux.IND_FUERZA_PUBLICA IN (''S'',''1'') THEN 1
                  WHEN aux.IND_FUERZA_PUBLICA IN (''N'',''0'') THEN 0
               END as CBX_NEC_FUERZA_PUBL,
               CASE
                  WHEN aux.FLAG_EN_REM=0 THEN (SELECT DD_EAT_ID FROM '|| V_ESQUEMA ||'.DD_EAT_EST_TECNICO WHERE DD_EAT_CODIGO=''E01'')
               END AS DD_EAT_ID,
               tcr1.DD_TCR_ID as CBX_CANAL_DIST_VENTA,
               tcr2.DD_TCR_ID as CBX_CANAL_DIST_ALQUILER,
               ctc.DD_CTC_ID as DD_CTC_ID,
               CAIXA.CBX_ID
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND ACT2.BORRADO = 0  
               LEFT JOIN  '|| V_ESQUEMA ||'.ACT_ACTIVO_CAIXA CAIXA ON ACT2.ACT_ID=CAIXA.ACT_ID AND CAIXA.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''ESTADO_COMERCIAL_ALQUILER''  AND eqv1.DD_CODIGO_CAIXA = aux.ESTADO_COMERCIAL_ALQUILER AND EQV1.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_ECA_EST_COM_ALQUILER eca ON eca.DD_ECA_CODIGO = eqv1.DD_CODIGO_REM         
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''ESTADO_COMERCIAL_VENTA''  AND eqv2.DD_CODIGO_CAIXA = aux.ESTADO_COMERCIAL_VENTA AND EQV2.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_ECV_EST_COM_VENTA ecv ON ecv.DD_ECV_CODIGO = eqv2.DD_CODIGO_REM        
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''MOT_NECESIDAD_ARRAS''  AND eqv3.DD_CODIGO_CAIXA = aux.MOT_NECESIDAD_ARRAS AND EQV3.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_MNA_MOT_NECESIDAD_ARRAS mna ON mna.DD_MNA_CODIGO = eqv3.DD_CODIGO_REM     
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv7 ON eqv7.DD_NOMBRE_CAIXA = ''CANAL_DISTRIBUCION_VENTA''  AND eqv7.DD_CODIGO_CAIXA = aux.CANAL_DISTRIBUCION_VENTA AND EQV7.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_TCR_TIPO_COMERCIALIZAR tcr1 ON tcr1.DD_TCR_CODIGO = eqv7.DD_CODIGO_REM   
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv8 ON eqv8.DD_NOMBRE_CAIXA = ''CANAL_DISTRIBUCION_ALQUILER''  AND eqv8.DD_CODIGO_CAIXA = aux.CANAL_DISTRIBUCION_ALQ AND eqv8.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_TCR_TIPO_COMERCIALIZAR tcr2 ON tcr2.DD_TCR_CODIGO = eqv8.DD_CODIGO_REM                 
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''CAT_COMERCIALIZACION''  AND eqv1.DD_CODIGO_CAIXA = aux.CAT_COMERCIALIZACION
               LEFT JOIN '|| V_ESQUEMA ||'.DD_CTC_CATEG_COMERCIALIZ ctc ON ctc.DD_CTC_CODIGO = eqv1.DD_CODIGO_REM     
               WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               
               ) us ON (us.CBX_ID = act1.CBX_ID )
                                 when matched then update set
                              act1.DD_ECA_ID = us.DD_ECA_ID 
                              ,act1.FECHA_ECA_EST_COM_ALQUILER = us.FECHA_ECA_EST_COM_ALQUILER                              
                              ,act1.DD_ECV_ID = us.DD_ECV_ID 
                              ,act1.FECHA_ECV_EST_COM_VENTA = us.FECHA_ECV_EST_COM_VENTA 
                              ,act1.CBX_NECESIDAD_ARRAS = us.CBX_NECESIDAD_ARRAS 
                              ,act1.DD_MNA_ID = us.DD_MNA_ID 
                              ,act1.CBX_PRECIO_VENT_NEGO = us.CBX_PRECIO_VENT_NEGO 
                              ,act1.CBX_PRECIO_ALQU_NEGO = us.CBX_PRECIO_ALQU_NEGO 
                              ,act1.CBX_CAMP_PRECIO_ALQ_NEGO = us.CBX_CAMP_PRECIO_ALQ_NEGO 
                              ,act1.CBX_CAMP_PRECIO_VENT_NEGO = us.CBX_CAMP_PRECIO_VENT_NEGO 
                              ,act1.CBX_NEC_FUERZA_PUBL = us.CBX_NEC_FUERZA_PUBL
                              ,act1.DD_EAT_ID=us.DD_EAT_ID
                              ,act1.CBX_CANAL_DIST_VENTA= us.CBX_CANAL_DIST_VENTA
                              ,act1.CBX_CANAL_DIST_ALQUILER= us.CBX_CANAL_DIST_ALQUILER
                              ,act1.DD_CTC_ID = us.DD_CTC_ID                                                                                                                         
                              ,act1.USUARIOMODIFICAR = ''STOCK_BC''
                              ,act1.FECHAMODIFICAR = sysdate
                              
                              WHEN NOT MATCHED THEN
                                 INSERT  (CBX_ID,                                       
                                          ACT_ID,
                                          DD_ECA_ID,                                       
                                          FECHA_ECA_EST_COM_ALQUILER,
                                          DD_ECV_ID,
                                          FECHA_ECV_EST_COM_VENTA,
                                          CBX_NECESIDAD_ARRAS,
                                          DD_MNA_ID,
                                          CBX_PRECIO_VENT_NEGO,
                                          CBX_PRECIO_ALQU_NEGO,
                                          CBX_CAMP_PRECIO_ALQ_NEGO,
                                          CBX_CAMP_PRECIO_VENT_NEGO,
                                          CBX_NEC_FUERZA_PUBL,    
                                          DD_EAT_ID,  
                                          CBX_CANAL_DIST_VENTA,
                                          CBX_CANAL_DIST_ALQUILER,
                                          DD_CTC_ID,                                                                        
                                          USUARIOCREAR,
                                          FECHACREAR
                                          )
                                 VALUES ('|| V_ESQUEMA ||'.S_ACT_ACTIVO_CAIXA.NEXTVAL,
                                          us.ACT_ID,
                                          us.DD_ECA_ID,                                       
                                          us.FECHA_ECA_EST_COM_ALQUILER,
                                          us.DD_ECV_ID,
                                          us.FECHA_ECV_EST_COM_VENTA,
                                          us.CBX_NECESIDAD_ARRAS,
                                          us.DD_MNA_ID,
                                          us.CBX_PRECIO_VENT_NEGO,
                                          us.CBX_PRECIO_ALQU_NEGO,
                                          us.CBX_CAMP_PRECIO_ALQ_NEGO,
                                          us.CBX_CAMP_PRECIO_VENT_NEGO,
                                          us.CBX_NEC_FUERZA_PUBL,
                                          us.DD_EAT_ID, 
                                          us.CBX_CANAL_DIST_VENTA,
                                          us.CBX_CANAL_DIST_ALQUILER,
                                          us.DD_CTC_ID,
                                          ''STOCK_BC'',
                                          sysdate)';

   EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR/ACTUALIZAR EN ACT_ABA_ACTIVO_BANCARIO.');

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ABA_ACTIVO_BANCARIO act1
				using (		

               SELECT
               aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
               act2.ACT_ID as ACT_ID               
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux                        
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
               WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'               
               ) us ON (us.ACT_ID = act1.ACT_ID )
               WHEN NOT MATCHED THEN
                  INSERT  (ABA_ID,                                       
                           ACT_ID,
                           DD_CLA_ID,                                                                                                                                             
                           USUARIOCREAR,
                           FECHACREAR
                           )
                  VALUES ('|| V_ESQUEMA ||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL,
                           us.ACT_ID,
                           (SELECT DD_CLA_ID FROM DD_CLA_CLASE_ACTIVO WHERE DD_CLA_CODIGO=''02''),
                           ''STOCK_BC'',
                           sysdate)';

   EXECUTE IMMEDIATE V_MSQL;

   
 

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '   [INFO] 10 - INSERTAR/ACTUALIZAR EN ACT_SPS_SIT_POSESORIA'|| CHR(10);   

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA act1
				using (		
               SELECT
                  CASE
                     WHEN aux.IND_ENTREGA_VOL_POSESI IN (''S'',''1'') THEN 1
                     WHEN aux.IND_ENTREGA_VOL_POSESI IN (''N'',''0'') THEN 0
                  END as SPS_POSESION_NEG,
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
                  act2.ACT_ID as ACT_ID
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
               WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               
               ) us ON (us.ACT_ID = act1.ACT_ID )
               when matched then update set  
                   act1.SPS_POSESION_NEG=us.SPS_POSESION_NEG                                                                                                                                 
                  ,act1.USUARIOMODIFICAR = ''STOCK_BC''
                  ,act1.FECHAMODIFICAR = sysdate               
               WHEN NOT MATCHED THEN
                  INSERT  (SPS_ID,                                       
                           ACT_ID,
                           SPS_POSESION_NEG,                                                                                                                                           
                           USUARIOCREAR,
                           FECHACREAR
                           )
                  VALUES ('|| V_ESQUEMA ||'.S_ACT_SPS_SIT_POSESORIA.NEXTVAL,
                           us.ACT_ID,
                           us.SPS_POSESION_NEG,                                                        
                           ''STOCK_BC'',
                           sysdate)';

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
END SP_BCR_01_DATOS_BASICOS;
/
EXIT;
