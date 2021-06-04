--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14088
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
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
                              ''STOCK'' AS USUARIOCREAR,
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
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO,
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_REM,
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
                  SAC.DD_SAC_ID AS DD_SAC_ID,
                  STA.DD_TTA_ID AS DD_TTA_ID,
                  STA.DD_STA_ID AS DD_STA_ID,
                  prp.DD_PRP_ID as DD_PRP_ID,
                  tud.DD_TUD_ID as DD_TUD_ID,
                  tcr.DD_TCR_ID as DD_TCR_ID,
                  aux.PORC_OBRA_EJECUTADA as ACT_PORCENTAJE_CONSTRUCCION,
                  SCR.DD_SCR_ID AS DD_SCR_ID, 
                  SCR.DD_CRA_ID AS DD_CRA_ID, 
                  SPG.DD_SPG_ID AS DD_SPG_ID,
                  bie.BIE_ID AS BIE_ID

                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''PRODUCTO''  AND eqv1.DD_CODIGO_CAIXA = aux.PRODUCTO AND EQV1.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_CODIGO = eqv1.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''SOCIEDAD_ORIGEN''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_ORIGEN AND EQV2.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_CODIGO = eqv2.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''BANCO_ORIGEN''  AND eqv3.DD_CODIGO_CAIXA = aux.BANCO_ORIGEN AND EQV3.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SPG_SOCIEDAD_PAGO_ANTERIOR spg ON spg.DD_SPG_CODIGO = eqv3.DD_CODIGO_REM  
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv4 ON eqv4.DD_NOMBRE_CAIXA = ''CLASE_USO''  AND eqv4.DD_CODIGO_CAIXA = aux.CLASE_USO AND EQV4.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO sac ON sac.DD_SAC_CODIGO = eqv4.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv5 ON eqv5.DD_NOMBRE_CAIXA = ''PROCEDENCIA_PRODUCTO''  AND eqv5.DD_CODIGO_CAIXA = aux.PROCEDENCIA_PRODUCTO AND EQV5.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_PRP_PROCEDENCIA_PRODUCTO prp ON prp.DD_PRP_CODIGO = eqv5.DD_CODIGO_REM   
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv6 ON eqv6.DD_NOMBRE_CAIXA = ''VIVIENDA_HABITUAL''  AND eqv6.DD_CODIGO_CAIXA = aux.VIVIENDA_HABITUAL AND EQV6.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_TUD_TIPO_USO_DESTINO tud ON tud.DD_TUD_CODIGO = eqv6.DD_CODIGO_REM         
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv7 ON eqv7.DD_NOMBRE_CAIXA = ''CANAL_DISTRIBUCION''  AND eqv7.DD_CODIGO_CAIXA = aux.CANAL_DISTRIBUCION AND EQV7.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_TCR_TIPO_COMERCIALIZAR tcr ON tcr.DD_TCR_CODIGO = eqv7.DD_CODIGO_REM
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN bie ON bie.BIE_NUMERO_ACTIVO = aux.NUM_IDENTIFICATIVO
                  WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                                       
                                 ) us ON (us.ACT_NUM_ACTIVO_CAIXA = act.ACT_NUM_ACTIVO_CAIXA AND act.BORRADO=0)
                                 when matched then update set
                                    act.DD_SAC_ID = us.DD_SAC_ID 
                                    ,act.DD_TTA_ID = us.DD_TTA_ID  
                                    ,act.DD_STA_ID = us.DD_STA_ID
                                    ,act.DD_PRP_ID = us.DD_PRP_ID
                                    ,act.DD_TUD_ID = us.DD_TUD_ID
                                    ,act.DD_TCR_ID = us.DD_TCR_ID
                                    ,act.ACT_PORCENTAJE_CONSTRUCCION = us.ACT_PORCENTAJE_CONSTRUCCION           
                                    ,act.DD_SCR_ID = us.DD_SCR_ID
                                    ,act.DD_CRA_ID = us.DD_CRA_ID
                                    ,act.DD_SPG_ID = us.DD_SPG_ID
                                    ,act.USUARIOMODIFICAR = ''STOCK''
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
                                          DD_TCR_ID,
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
                                          us.ACT_NUM_ACTIVO_REM,
                                          us.ACT_NUM_ACTIVO_CAIXA,
                                          us.DD_SAC_ID,
                                          us.DD_TTA_ID,
                                          us.DD_STA_ID,
                                          us.DD_PRP_ID,
                                          us.DD_TUD_ID,
                                          us.DD_TCR_ID,
                                          us.ACT_PORCENTAJE_CONSTRUCCION,
                                          us.DD_SCR_ID,
                                          us.DD_CRA_ID,
                                          us.DD_SPG_ID,
                                          us.BIE_ID,
                                          ''STOCK'',
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
               aux.FEC_ESTADO_COMERCIAL_VENTA as FECHA_ECV_EST_COM_VENTA,
               aux.NECESIDAD_ARRAS as CBX_NECESIDAD_ARRAS,
               mna.DD_MNA_ID as DD_MNA_ID,
               aux.PRECIO_VENTA_NEGOCIABLE as CBX_PRECIO_VENT_NEGO,
               aux.PRECIO_ALQUI_NEGOCIABLE as CBX_PRECIO_ALQU_NEGO,
               aux.PRECIO_CAMP_ALQUI_NEGOCIABLE as CBX_CAMP_PRECIO_ALQ_NEGO,
               aux.PRECIO_CAMP_VENTA_NEGOCIABLE as CBX_CAMP_PRECIO_VENT_NEGO,
               aux.IND_FUERZA_PUBLICA as CBX_NEC_FUERZA_PUBL,
               aux.IND_ENTREGA_VOL_POSESI as CBX_ENTRADA_VOLUN_POSES
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                        
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''ESTADO_COMERCIAL_ALQUILER''  AND eqv1.DD_CODIGO_CAIXA = aux.ESTADO_COMERCIAL_ALQUILER AND EQV1.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_ECA_EST_COM_ALQUILER eca ON eca.DD_ECA_CODIGO = eqv1.DD_CODIGO_REM         
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''ESTADO_COMERCIAL_VENTA''  AND eqv2.DD_CODIGO_CAIXA = aux.ESTADO_COMERCIAL_VENTA AND EQV2.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_ECV_EST_COM_VENTA ecv ON ecv.DD_ECV_CODIGO = eqv2.DD_CODIGO_REM        
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''MOT_NECESIDAD_ARRAS''  AND eqv3.DD_CODIGO_CAIXA = aux.MOT_NECESIDAD_ARRAS AND EQV3.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_MNA_MOT_NECESIDAD_ARRAS mna ON mna.DD_MNA_CODIGO = eqv3.DD_CODIGO_REM        
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
               WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               
               ) us ON (us.ACT_ID = act1.ACT_ID )
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
                              ,act1.CBX_ENTRADA_VOLUN_POSES = us.CBX_ENTRADA_VOLUN_POSES                                                                                                                        
                              ,act1.USUARIOMODIFICAR = ''STOCK''
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
                                          CBX_ENTRADA_VOLUN_POSES,                                                                            
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
                                          us.CBX_ENTRADA_VOLUN_POSES,  
                                          ''STOCK'',
                                          sysdate)';

   EXECUTE IMMEDIATE V_MSQL;

      DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR/ACTUALIZAR EN ACT_ABA_ACTIVO_BANCARIO.');

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ABA_ACTIVO_BANCARIO act1
				using (		

               SELECT
               aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
               act2.ACT_ID as ACT_ID,
               ctc.DD_CTC_ID as DD_CTC_ID
               
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                        
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''CAT_COMERCIALIZACION''  AND eqv1.DD_CODIGO_CAIXA = aux.CAT_COMERCIALIZACION
               LEFT JOIN '|| V_ESQUEMA ||'.DD_CTC_CATEG_COMERCIALIZ ctc ON ctc.DD_CTC_CODIGO = eqv1.DD_CODIGO_REM
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
               WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               
               ) us ON (us.ACT_ID = act1.ACT_ID )
                                 when matched then update set
                              act1.DD_CTC_ID = us.DD_CTC_ID                                                                                                                                             
                              ,act1.USUARIOMODIFICAR = ''STOCK''
                              ,act1.FECHAMODIFICAR = sysdate
                              
                              WHEN NOT MATCHED THEN
                                 INSERT  (ABA_ID,                                       
                                          ACT_ID,
                                          DD_CLA_ID,
                                          DD_CTC_ID,                                                                                                                                              
                                          USUARIOCREAR,
                                          FECHACREAR
                                          )
                                 VALUES ('|| V_ESQUEMA ||'.S_ACT_ABA_ACTIVO_BANCARIO.NEXTVAL,
                                          us.ACT_ID,
                                          (SELECT DD_CLA_ID FROM DD_CLA_CLASE_ACTIVO WHERE DD_CLA_CODIGO=''02''),
                                          us.DD_CTC_ID,                                                           
                                          ''STOCK'',
                                          sysdate)';

   EXECUTE IMMEDIATE V_MSQL;

   
 

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
