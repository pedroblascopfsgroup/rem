--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15423
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
--##	      0.9 Se añade comprobación para no machacar tipo y subtipo de activo si no viene - HREOS-14837
--##	      0.10 Nuevo campos Origen Regulatorio - HREOS-14838 - Daniel Algaba
--##	      0.11 Uso dominante - [HREOS-14974] - Alejandra García
--##	      0.12 Tipo de activo - [HREOS-15133] - Daniel Algaba
--##	      0.13 Correcciones gestores - [HREOS-15254] - Daniel Algaba
--##	      0.14 Corrección estado técnico - [HREOS-15423] - Daniel Algaba
--##	      0.15 Corrección tipo/subtipo activo cuando solo viene tipo [HREOS-15423] - Daniel Algaba
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

      SALIDA := '[INICIO]'||CHR(10);

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE DATOS BÁSICOS.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - INSERTAR EN BIE_BIEN SI EL ACTIVO NO EXISTE'|| CHR(10);

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
   
      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);  

      SALIDA := SALIDA || '   [INFO] 2 - INSERTAR/ACTUALIZAR EN ACT_ACTIVO'|| CHR(10);

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO act
				using (				
                           
                  SELECT       
                  aux.NUM_INMUEBLE as ACT_NUM_ACTIVO,
                  aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
                  CASE
                     WHEN aux.SUBTIPO_VIVIENDA IS NOT NULL THEN sac_viv.DD_TPA_ID
                     WHEN aux.SUBTIPO_SUELO IS NOT NULL THEN sac_suelo.DD_TPA_ID
                     WHEN sac_uso.DD_TPA_ID IS NOT NULL THEN sac_uso.DD_TPA_ID
                     ELSE TPA.DD_TPA_ID
                  END DD_TPA_ID,
                  CASE 
                     WHEN aux.SUBTIPO_VIVIENDA IS NOT NULL THEN sac_viv.DD_SAC_ID
                     WHEN aux.SUBTIPO_SUELO IS NOT NULL THEN sac_suelo.DD_SAC_ID
                     WHEN sac_uso.DD_SAC_ID IS NOT NULL THEN sac_uso.DD_SAC_ID
                     WHEN TPA.DD_TPA_ID IS NOT NULL AND TPA.DD_TPA_ID = ACT.DD_TPA_ID THEN ACT.DD_SAC_ID
                     ELSE NULL
                  END DD_SAC_ID,
                  COALESCE(STA_OR.DD_TTA_ID, STA.DD_TTA_ID) AS DD_TTA_ID,
                  COALESCE(STA_OR.DD_STA_ID, STA.DD_STA_ID) AS DD_STA_ID,
                  prp.DD_PRP_ID as DD_PRP_ID,
                  CASE
                     WHEN AUX.CLASE_USO=''0001'' AND AUX.VIVIENDA_HABITUAL=''S'' THEN (SELECT DD_TUD_ID FROM '|| V_ESQUEMA ||'.DD_TUD_TIPO_USO_DESTINO WHERE DD_TUD_CODIGO=''01'')
                     WHEN AUX.CLASE_USO=''0001'' AND AUX.VIVIENDA_HABITUAL=''N'' THEN (SELECT DD_TUD_ID FROM '|| V_ESQUEMA ||'.DD_TUD_TIPO_USO_DESTINO WHERE DD_TUD_CODIGO=''06'')
                     ELSE NULL
                  END AS DD_TUD_ID,
                  tcr.DD_TCR_ID as DD_TCR_ID,
                  aux.PORC_OBRA_EJECUTADA/100 as ACT_PORCENTAJE_CONSTRUCCION,
                  SCR.DD_SCR_ID AS DD_SCR_ID, 
                  SCR.DD_CRA_ID AS DD_CRA_ID, 
                  SPG.DD_SPG_ID AS DD_SPG_ID,
                  bie.BIE_ID AS BIE_ID,
                  act.act_id as act_id
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
                  JOIN '|| V_ESQUEMA ||'.BIE_BIEN bie ON bie.BIE_NUMERO_ACTIVO = aux.NUM_IDENTIFICATIVO AND BIE.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = bie.BIE_NUMERO_ACTIVO AND ACT.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''PRODUCTO''  AND eqv1.DD_CODIGO_CAIXA = aux.PRODUCTO AND EQV1.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA ON STA.DD_STA_CODIGO = eqv1.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv10 ON eqv10.DD_NOMBRE_CAIXA = ''ORIGEN_REGULATORIO''  AND eqv10.DD_CODIGO_CAIXA = aux.ORIGEN_REGULATORIO AND eqv10.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_STA_SUBTIPO_TITULO_ACTIVO STA_OR ON STA_OR.DD_STA_CODIGO = eqv10.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''SOCIEDAD_PATRIMONIAL''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_PATRIMONIAL 
                                                            AND EQV2.DD_NOMBRE_REM=''DD_SCR_SUBCARTERA'' and eqv2.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SCR_SUBCARTERA scr ON scr.DD_SCR_CODIGO = eqv2.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''BANCO_ORIGEN''  AND eqv3.DD_CODIGO_CAIXA = aux.BANCO_ORIGEN AND EQV3.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SPG_SOCIEDAD_PAGO_ANTERIOR spg ON spg.DD_SPG_CODIGO = eqv3.DD_CODIGO_REM  
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv4 ON eqv4.DD_NOMBRE_CAIXA = ''CLASE_USO''  AND eqv4.DD_CODIGO_CAIXA = aux.CLASE_USO AND EQV4.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO sac_uso ON sac_uso.DD_SAC_CODIGO = eqv4.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv8 ON eqv8.DD_NOMBRE_CAIXA = ''SUBTIPO_VIVIENDA''  AND eqv8.DD_CODIGO_CAIXA = aux.SUBTIPO_VIVIENDA AND EQV8.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO sac_viv ON sac_viv.DD_SAC_CODIGO = eqv8.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv9 ON eqv9.DD_NOMBRE_CAIXA = ''SUBTIPO_SUELO''  AND eqv9.DD_CODIGO_CAIXA = aux.SUBTIPO_SUELO AND EQV9.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO sac_suelo ON sac_suelo.DD_SAC_CODIGO = eqv9.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv5 ON eqv5.DD_NOMBRE_CAIXA = ''PROCEDENCIA_PRODUCTO''  AND eqv5.DD_CODIGO_CAIXA = aux.PROCEDENCIA_PRODUCTO AND EQV5.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_PRP_PROCEDENCIA_PRODUCTO prp ON prp.DD_PRP_CODIGO = eqv5.DD_CODIGO_REM     
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv7 ON eqv7.DD_NOMBRE_CAIXA = ''CANAL_DISTRIBUCION_VENTA''  AND eqv7.DD_CODIGO_CAIXA = aux.CANAL_DISTRIBUCION_VENTA AND EQV7.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_TCR_TIPO_COMERCIALIZAR tcr ON tcr.DD_TCR_CODIGO = eqv7.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv11 ON eqv11.DD_NOMBRE_CAIXA = ''TIPO_ACTIVO'' AND eqv11.DD_CODIGO_CAIXA = aux.CLASE_USO AND eqv11.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_CODIGO = eqv11.DD_CODIGO_REM
                  WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                                       
                                 ) us ON (us.act_id = act.act_id)
                                 when matched then update set
                                    act.DD_TPA_ID = NVL(us.DD_TPA_ID,act.DD_TPA_ID)
                                    ,act.DD_SAC_ID = us.DD_SAC_ID
                                    ,act.DD_TTA_ID = NVL(us.DD_TTA_ID,act.DD_TTA_ID)
                                    ,act.DD_STA_ID = NVL(us.DD_STA_ID,act.DD_STA_ID)
                                    ,act.DD_PRP_ID = us.DD_PRP_ID
                                    ,act.DD_TUD_ID = NVL(us.DD_TUD_ID,act.DD_TUD_ID)
                                    ,act.DD_TCR_ID = us.DD_TCR_ID
                                    ,act.ACT_PORCENTAJE_CONSTRUCCION = us.ACT_PORCENTAJE_CONSTRUCCION           
                                    ,act.DD_SCR_ID = NVL(us.DD_SCR_ID,act.DD_SCR_ID)
                                    ,act.DD_CRA_ID = NVL(us.DD_CRA_ID,act.DD_CRA_ID)
                                    ,act.DD_SPG_ID = us.DD_SPG_ID
                                    ,act.USUARIOMODIFICAR = ''STOCK_BC''
                                    ,act.FECHAMODIFICAR = sysdate
                                       
                                 WHEN NOT MATCHED THEN
                                 INSERT  (ACT_ID, 
                                          ACT_NUM_ACTIVO,
                                          ACT_NUM_ACTIVO_REM,
                                          ACT_NUM_ACTIVO_CAIXA,      
                                          DD_TPA_ID,                                 
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
                                          '|| V_ESQUEMA ||'.S_ACT_NUM_ACTIVO_REM.NEXTVAL,
                                          us.ACT_NUM_ACTIVO_CAIXA,
                                          us.DD_TPA_ID,
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
                                          ''STOCK_BC'',
                                          sysdate)';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);  

   SALIDA := SALIDA || '   [INFO] 2.1 - INSERTAR/ACTUALIZAR EN ACT_ACTIVO'|| CHR(10);

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO act
				       using (	
                      SELECT
                         TUD.DD_TUD_ID AS DD_TUD_ID
                        ,ACT.ACT_ID
                      FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                      LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID=ACT.DD_SAC_ID
                      LEFT JOIN '|| V_ESQUEMA ||'.EQV_CAIXA_TUD EQVTUD ON EQVTUD.SUBTIPO=SAC.DD_SAC_CODIGO
                      LEFT JOIN '|| V_ESQUEMA ||'.DD_TUD_TIPO_USO_DESTINO TUD ON TUD.DD_TUD_CODIGO=EQVTUD.USO_DOMINANTE
                      JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO
                      WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
                  ) us ON (us.act_id = act.act_id)
                  when matched then update set
                      act.DD_TUD_ID = NVL(act.DD_TUD_ID,us.DD_TUD_ID)
                     ,act.USUARIOMODIFICAR = ''STOCK_BC''
                     ,act.FECHAMODIFICAR = sysdate   
                  ';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10); 


   SALIDA := SALIDA || '   [INFO] 3 - INSERTAR/ACTUALIZAR EN ACT_ACTIVO_CAIXA'|| CHR(10);

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
                  WHEN aux.ACTIVO_CARTERA_CONCENTRADA IN (''S'',''1'') THEN 1
                  WHEN aux.ACTIVO_CARTERA_CONCENTRADA IN (''N'',''0'') THEN 0
               END as CBX_CARTERA_CONCENTRADA,
               CASE
                  WHEN aux.ACTIVO_AAMM IN (''S'',''1'') THEN 1
                  WHEN aux.ACTIVO_AAMM IN (''N'',''0'') THEN 0
               END as CBX_ACTIVO_AAMM,
               CASE
                  WHEN aux.ACTIVO_PROMO_ESTRATEG IN (''S'',''1'') THEN 1
                  WHEN aux.ACTIVO_PROMO_ESTRATEG IN (''N'',''0'') THEN 0
               END as CBX_ACTIVO_PROM_ESTR,
               TO_DATE(aux.FEC_INICIO_CONCURENCIA,''yyyymmdd'') as CBX_FEC_INI_CONCU,
               TO_DATE(aux.FEC_FIN_CONCURENCIA,''yyyymmdd'') as CBX_FEC_FIN_CONCU,
               CASE
                  WHEN aux.NECESIDAD_ARRAS IN (''S'',''1'',''01'') THEN 1
                  WHEN aux.NECESIDAD_ARRAS IN (''N'',''0'',''02'') THEN 0
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
                  WHEN CAIXA.DD_EAT_ID IS NULL THEN (SELECT DD_EAT_ID FROM '|| V_ESQUEMA ||'.DD_EAT_EST_TECNICO WHERE DD_EAT_CODIGO=''E01'')
                  ELSE CAIXA.DD_EAT_ID
               END AS DD_EAT_ID,
               CASE
                  WHEN CAIXA.DD_EAT_ID IS NULL THEN SYSDATE
                  ELSE CAIXA.FECHA_EAT_EST_TECNICO
               END AS FECHA_EAT_EST_TECNICO,
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
                              ,act1.CBX_CARTERA_CONCENTRADA = us.CBX_CARTERA_CONCENTRADA 
                              ,act1.CBX_ACTIVO_AAMM = us.CBX_ACTIVO_AAMM 
                              ,act1.CBX_ACTIVO_PROM_ESTR = us.CBX_ACTIVO_PROM_ESTR 
                              ,act1.CBX_FEC_INI_CONCU = us.CBX_FEC_INI_CONCU 
                              ,act1.CBX_FEC_FIN_CONCU = us.CBX_FEC_FIN_CONCU 
                              ,act1.CBX_NECESIDAD_ARRAS = us.CBX_NECESIDAD_ARRAS 
                              ,act1.DD_MNA_ID = us.DD_MNA_ID 
                              ,act1.CBX_PRECIO_VENT_NEGO = us.CBX_PRECIO_VENT_NEGO 
                              ,act1.CBX_PRECIO_ALQU_NEGO = us.CBX_PRECIO_ALQU_NEGO 
                              ,act1.CBX_CAMP_PRECIO_ALQ_NEGO = us.CBX_CAMP_PRECIO_ALQ_NEGO 
                              ,act1.CBX_CAMP_PRECIO_VENT_NEGO = us.CBX_CAMP_PRECIO_VENT_NEGO 
                              ,act1.CBX_NEC_FUERZA_PUBL = us.CBX_NEC_FUERZA_PUBL
                              ,act1.DD_EAT_ID=us.DD_EAT_ID
                              ,act1.FECHA_EAT_EST_TECNICO=us.FECHA_EAT_EST_TECNICO
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
                                          CBX_CARTERA_CONCENTRADA,
                                          CBX_ACTIVO_AAMM,
                                          CBX_ACTIVO_PROM_ESTR,
                                          CBX_FEC_INI_CONCU,
                                          CBX_FEC_FIN_CONCU,
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
                                          FECHA_EAT_EST_TECNICO,
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
                                          us.CBX_CARTERA_CONCENTRADA,
                                          us.CBX_ACTIVO_AAMM,
                                          us.CBX_ACTIVO_PROM_ESTR,
                                          us.CBX_FEC_INI_CONCU,
                                          us.CBX_FEC_FIN_CONCU,
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
                                          us.FECHA_EAT_EST_TECNICO,
                                          us.CBX_CANAL_DIST_VENTA,
                                          us.CBX_CANAL_DIST_ALQUILER,
                                          us.DD_CTC_ID,
                                          ''STOCK_BC'',
                                          sysdate)';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);   

   SALIDA := SALIDA || '   [INFO] 4 - INSERTAR/ACTUALIZAR EN ACT_ABA_ACTIVO_BANCARIO'|| CHR(10);   

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.ACT_ABA_ACTIVO_BANCARIO act1
				using (		

               SELECT
               aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
               act2.ACT_ID as ACT_ID
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
               WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               
               ) us ON (us.ACT_ID = act1.ACT_ID )
                                 when matched then update set                                                                                                                                         
                              act1.USUARIOMODIFICAR = ''STOCK_BC''
                              ,act1.FECHAMODIFICAR = sysdate
                              
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

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);   

   SALIDA := SALIDA || '   [INFO] 5 - INSERTAR/ACTUALIZAR GESTORES GESTORÍA'|| CHR(10);  

   SALIDA := SALIDA || '      [INFO] 5.1 - INSERTAR/ACTUALIZAR GESTORÍA ADMISIÓN'|| CHR(10);   
   
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE
      USING (
         SELECT 
         AUX.ACT_ID
         , AUX.USU_ID
         , (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GGADM'') DD_TGE_ID
         , GEE.GEE_ID
         FROM (SELECT
            USU.USU_ID
            , ACT.ACT_ID
            , ROW_NUMBER() OVER (PARTITION BY PVE.PVE_ID, ACT.ACT_ID ORDER BY USU.USU_ID ASC) RN
            FROM '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
            JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0
            JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = PVC.USU_ID AND USU.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR ON APR.COD_GESTORIA = PVE.PVE_DOCIDENTIF
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
            WHERE PVC.BORRADO = 0
            AND TPR.DD_TPR_CODIGO = ''01''
            AND EPR.DD_EPR_CODIGO = ''04''
            AND PVE.PVE_COD_UVEM IS NOT NULL
            AND USU.USU_USERNAME LIKE ''%01''
            AND PVC.PVC_APELLID01 = ''Admisión''
            AND PVE.PVE_FECHA_BAJA IS NULL
            AND TRUNC(USU.USU_FECHA_VIGENCIA_PASS)>TRUNC(SYSDATE)
            AND APR.FLAG_EN_REM = '|| FLAG_EN_REM ||'
         ) AUX
         LEFT JOIN (SELECT AUX_GEE.GEE_ID, AUX_GAC.ACT_ID
         FROM '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO AUX_GAC
         JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD AUX_GEE ON AUX_GAC.GEE_ID = AUX_GEE.GEE_ID AND AUX_GEE.BORRADO = 0
         WHERE AUX_GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GGADM'')) GEE ON AUX.ACT_ID = GEE.ACT_ID
         WHERE RN = 1
      ) AUX
      ON (GEE.GEE_ID = AUX.GEE_ID)
      WHEN MATCHED THEN UPDATE SET 
         GEE.USU_ID = AUX.USU_ID
         ,GEE.USUARIOMODIFICAR = ''STOCK_BC''
         ,GEE.FECHAMODIFICAR = SYSDATE
         WHERE GEE.USU_ID != AUX.USU_ID
      WHEN NOT MATCHED THEN
         INSERT (
            GEE_ID
            , USU_ID
            , DD_TGE_ID
            , USUARIOCREAR
            , FECHACREAR
            , USUARIOMODIFICAR
         ) VALUES (
            '|| V_ESQUEMA ||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL,
            AUX.USU_ID,
            AUX.DD_TGE_ID,
            ''STOCK_BC'',
            SYSDATE,
            AUX.ACT_ID
         )';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);  

   SALIDA := SALIDA || '      [INFO] 5.2 - INSERTAR/ACTUALIZAR GESTORÍA ADMINISTRACIÓN'|| CHR(10);   
   
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE
      USING (
         SELECT 
         AUX.ACT_ID
         , AUX.USU_ID
         , (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GIAADMT'') DD_TGE_ID
         , GEE.GEE_ID
         FROM(SELECT
         USU.USU_ID
         , ACT.ACT_ID
         , ROW_NUMBER() OVER (PARTITION BY PVE.PVE_ID, APR.NUM_INMUEBLE ORDER BY USU.USU_ID ASC) RN
         FROM '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
         JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0
         JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = PVC.USU_ID AND USU.BORRADO = 0
         JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
         JOIN '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
         JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR ON APR.COD_GESTORIA_ADMINIS = PVE.PVE_DOCIDENTIF
         JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
         WHERE PVC.BORRADO = 0
         AND TPR.DD_TPR_CODIGO = ''01''
         AND EPR.DD_EPR_CODIGO = ''04''
         AND PVE.PVE_COD_UVEM IS NOT NULL
         AND USU.USU_USERNAME LIKE ''%02''
         AND PVC.PVC_APELLID01 = ''Administración''
         AND PVE.PVE_FECHA_BAJA IS NULL
         AND TRUNC(USU.USU_FECHA_VIGENCIA_PASS)>TRUNC(SYSDATE)
         AND APR.FLAG_EN_REM = '|| FLAG_EN_REM ||'
         ) AUX
         LEFT JOIN (SELECT AUX_GEE.GEE_ID, AUX_GAC.ACT_ID
         FROM '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO AUX_GAC
         JOIN '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD AUX_GEE ON AUX_GAC.GEE_ID = AUX_GEE.GEE_ID AND AUX_GEE.BORRADO = 0
         WHERE AUX_GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM REMMASTER.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GIAADMT'')) GEE ON AUX.ACT_ID = GEE.ACT_ID
         WHERE RN = 1
      ) AUX
      ON (GEE.GEE_ID = AUX.GEE_ID)
      WHEN MATCHED THEN UPDATE SET 
         GEE.USU_ID = AUX.USU_ID
         ,GEE.USUARIOMODIFICAR = ''STOCK_BC''
         ,GEE.FECHAMODIFICAR = SYSDATE
         WHERE GEE.USU_ID != AUX.USU_ID
      WHEN NOT MATCHED THEN
         INSERT (
            GEE_ID
            , USU_ID
            , DD_TGE_ID
            , USUARIOCREAR
            , FECHACREAR
            , USUARIOMODIFICAR
         ) VALUES (
            '|| V_ESQUEMA ||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL,
            AUX.USU_ID,
            AUX.DD_TGE_ID,
            ''STOCK_BC'',
            SYSDATE,
            AUX.ACT_ID
         )';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);  

   SALIDA := SALIDA || '      [INFO] 5.3 - INSERTAR REGISTRO EN TABLA DE RELACIÓN CON EL ACTIVO'|| CHR(10);   

   V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.GAC_GESTOR_ADD_ACTIVO
            (
            ACT_ID,
            GEE_ID
            )
            SELECT
               GEE.USUARIOMODIFICAR ACT_ID,
               GEE.GEE_ID
               FROM '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE
               WHERE GEE.USUARIOCREAR = ''STOCK_BC''
               AND TRUNC(SYSDATE) = TRUNC(GEE.FECHACREAR)
               AND GEE.USUARIOMODIFICAR IS NOT NULL
               AND GEE.FECHAMODIFICAR IS NULL';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 5.4 - DAR DE BAJA HISTÓRICO GESTORÍA ADMISIÓN'|| CHR(10);   
   
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH
      USING (
         SELECT 
         DISTINCT GEH.GEH_ID 
         FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
         JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
         JOIN '|| V_ESQUEMA ||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
         JOIN '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.BORRADO = 0 AND GEH.GEH_FECHA_HASTA IS NULL
         AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GGADM'') 
         WHERE APR.COD_GESTORIA IS NOT NULL
         AND NOT EXISTS (
            SELECT 
               1
               FROM(SELECT
                  USU.USU_ID
                  , ACT.ACT_ID
                  , ROW_NUMBER() OVER (PARTITION BY PVE.PVE_ID, ACT.ACT_ID ORDER BY USU.USU_ID ASC) RN
                  FROM '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
                  JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0
                  JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = PVC.USU_ID AND USU.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR ON APR.COD_GESTORIA = PVE.PVE_DOCIDENTIF
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
                  WHERE PVC.BORRADO = 0
                  AND TPR.DD_TPR_CODIGO = ''01''
                  AND EPR.DD_EPR_CODIGO = ''04''
                  AND PVE.PVE_COD_UVEM IS NOT NULL
                  AND USU.USU_USERNAME LIKE ''%01''
                  AND PVC.PVC_APELLID01 = ''Admisión''
                  AND PVE.PVE_FECHA_BAJA IS NULL
                  AND TRUNC(USU.USU_FECHA_VIGENCIA_PASS)>TRUNC(SYSDATE)
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) AUX
               WHERE RN = 1
               AND AUX.ACT_ID = GAH.ACT_ID
               AND AUX.USU_ID = GEH.USU_ID
            )
      ) AUX
      ON (GEH.GEH_ID = AUX.GEH_ID)
      WHEN MATCHED THEN UPDATE SET 
         GEH.GEH_FECHA_HASTA = SYSDATE
         ,GEH.USUARIOMODIFICAR = ''STOCK_BC''
         ,GEH.FECHAMODIFICAR = SYSDATE';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);  

   SALIDA := SALIDA || '      [INFO] 5.5 - DAR DE BAJA HISTÓRICO GESTORÍA ADMINISTRACIÓN'|| CHR(10);   
   
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH
      USING (
         SELECT 
         DISTINCT GEH.GEH_ID 
         FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
         JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
         JOIN '|| V_ESQUEMA ||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
         JOIN '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.BORRADO = 0 AND GEH.GEH_FECHA_HASTA IS NULL
         AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GIAADMT'') 
         WHERE APR.COD_GESTORIA_ADMINIS IS NOT NULL
         AND NOT EXISTS (
            SELECT 
               1
               FROM(SELECT
                  USU.USU_ID
                  , ACT.ACT_ID
                  , ROW_NUMBER() OVER (PARTITION BY PVE.PVE_ID, ACT.ACT_ID ORDER BY USU.USU_ID ASC) RN
                  FROM '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
                  JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0
                  JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = PVC.USU_ID AND USU.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR ON APR.COD_GESTORIA = PVE.PVE_DOCIDENTIF
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
                  WHERE PVC.BORRADO = 0
                  AND TPR.DD_TPR_CODIGO = ''01''
                  AND EPR.DD_EPR_CODIGO = ''04''
                  AND PVE.PVE_COD_UVEM IS NOT NULL
                  AND USU.USU_USERNAME LIKE ''%02''
                  AND PVC.PVC_APELLID01 = ''Administración''
                  AND PVE.PVE_FECHA_BAJA IS NULL
                  AND TRUNC(USU.USU_FECHA_VIGENCIA_PASS)>TRUNC(SYSDATE)
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) AUX
               WHERE RN = 1
               AND AUX.ACT_ID = GAH.ACT_ID
               AND AUX.USU_ID = GEH.USU_ID
            )
      ) AUX
      ON (GEH.GEH_ID = AUX.GEH_ID)
      WHEN MATCHED THEN UPDATE SET 
         GEH.GEH_FECHA_HASTA = SYSDATE
         ,GEH.USUARIOMODIFICAR = ''STOCK_BC''
         ,GEH.FECHAMODIFICAR = SYSDATE';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10); 

   SALIDA := SALIDA || '      [INFO] 5.6 - INSERTAR REGISTRO EN TABLA HISTÓRICA PAR GESTORÍA ADMISIÓN'|| CHR(10);   

   V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST
            (
               GEH_ID,
               USU_ID,
               DD_TGE_ID,
               GEH_FECHA_DESDE,
               USUARIOCREAR,
               FECHACREAR,
               USUARIOMODIFICAR
            )
            SELECT 
               '|| V_ESQUEMA ||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL
               , AUX.USU_ID
               , (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GGADM'') DD_TGE_ID
               , SYSDATE
               , ''STOCK_BC''
               , SYSDATE
               , AUX.ACT_ID 
               FROM(SELECT
                  USU.USU_ID
                  , ACT.ACT_ID
                  , ROW_NUMBER() OVER (PARTITION BY PVE.PVE_ID, ACT.ACT_ID ORDER BY USU.USU_ID ASC) RN
                  FROM '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
                  JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0
                  JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = PVC.USU_ID AND USU.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR ON APR.COD_GESTORIA = PVE.PVE_DOCIDENTIF
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
                  WHERE PVC.BORRADO = 0
                  AND TPR.DD_TPR_CODIGO = ''01''
                  AND EPR.DD_EPR_CODIGO = ''04''
                  AND PVE.PVE_COD_UVEM IS NOT NULL
                  AND USU.USU_USERNAME LIKE ''%01''
                  AND PVC.PVC_APELLID01 = ''Admisión''
                  AND PVE.PVE_FECHA_BAJA IS NULL
                  AND TRUNC(USU.USU_FECHA_VIGENCIA_PASS)>TRUNC(SYSDATE)
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) AUX
               WHERE RN = 1
               AND NOT EXISTS (
                     SELECT 1
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
                     JOIN '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.BORRADO = 0 AND GEH.GEH_FECHA_HASTA IS NULL
                     AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GGADM'') 
                     WHERE APR.COD_GESTORIA IS NOT NULL
                     AND GEH.USU_ID = AUX.USU_ID
                     AND GAH.ACT_ID = AUX.ACT_ID
               )';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10); 

   SALIDA := SALIDA || '      [INFO] 5.7 - INSERTAR REGISTRO EN TABLA HISTÓRICA PAR GESTORÍA ADMINISTRACIÓN'|| CHR(10); 

   V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST
            (
               GEH_ID,
               USU_ID,
               DD_TGE_ID,
               GEH_FECHA_DESDE,
               USUARIOCREAR,
               FECHACREAR,
               USUARIOMODIFICAR
            )
            SELECT 
               '|| V_ESQUEMA ||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL
               , AUX.USU_ID
               , (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GIAADMT'') DD_TGE_ID
               , SYSDATE
               , ''STOCK_BC''
               , SYSDATE
               , AUX.ACT_ID 
               FROM(SELECT
                  USU.USU_ID
                  , ACT.ACT_ID
                  , ROW_NUMBER() OVER (PARTITION BY PVE.PVE_ID, ACT.ACT_ID ORDER BY USU.USU_ID DESC) RN
                  FROM '|| V_ESQUEMA ||'.ACT_PVC_PROVEEDOR_CONTACTO PVC
                  JOIN '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID AND PVE.BORRADO = 0
                  JOIN '|| V_ESQUEMA_M ||'.USU_USUARIOS USU ON USU.USU_ID = PVC.USU_ID AND USU.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.DD_EPR_ESTADO_PROVEEDOR EPR ON PVE.DD_EPR_ID = EPR.DD_EPR_ID AND EPR.BORRADO = 0
                  JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR ON APR.COD_GESTORIA_ADMINIS = PVE.PVE_DOCIDENTIF
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
                  WHERE PVC.BORRADO = 0
                  AND TPR.DD_TPR_CODIGO = ''01''
                  AND EPR.DD_EPR_CODIGO = ''04''
                  AND PVE.PVE_COD_UVEM IS NOT NULL
                  AND USU.USU_USERNAME LIKE ''%02''
                  AND PVC.PVC_APELLID01 = ''Administración''
                  AND PVE.PVE_FECHA_BAJA IS NULL
                  AND TRUNC(USU.USU_FECHA_VIGENCIA_PASS)>TRUNC(SYSDATE)
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM ||'
               ) AUX
               WHERE RN = 1
               AND NOT EXISTS (
                     SELECT 1
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = APR.NUM_INMUEBLE AND ACT.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
                     JOIN '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH ON GEH.GEH_ID = GAH.GEH_ID AND GEH.BORRADO = 0 AND GEH.GEH_FECHA_HASTA IS NULL
                     AND GEH.DD_TGE_ID = (SELECT DD_TGE_ID FROM '|| V_ESQUEMA_M ||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GIAADMT'') 
                     WHERE APR.COD_GESTORIA_ADMINIS IS NOT NULL
                     AND GEH.USU_ID = AUX.USU_ID
                     AND GAH.ACT_ID = AUX.ACT_ID
               )';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10); 

   SALIDA := SALIDA || '      [INFO] 5.8 - INSERTAR REGISTRO EN TABLA DE RELACIÓN HISTÓRICO CON EL ACTIVO'|| CHR(10);   

   V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.GAH_GESTOR_ACTIVO_HISTORICO
            (
            ACT_ID,
            GEH_ID
            )
            SELECT
               GEH.USUARIOMODIFICAR ACT_ID,
               GEH.GEH_ID
               FROM '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH
               WHERE GEH.USUARIOCREAR = ''STOCK_BC''
               AND TRUNC(SYSDATE) = TRUNC(GEH.FECHACREAR)
               AND GEH.USUARIOMODIFICAR IS NOT NULL
               AND GEH.FECHAMODIFICAR IS NULL';
            
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 5.9 - BORRAR USUARIOMODIFICAR ACTUAL'|| CHR(10);   

   V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.GEE_GESTOR_ENTIDAD GEE
            SET GEE.USUARIOMODIFICAR = NULL
               WHERE GEE.USUARIOCREAR = ''STOCK_BC''
               AND TRUNC(SYSDATE) = TRUNC(GEE.FECHACREAR)
               AND GEE.USUARIOMODIFICAR IS NOT NULL
               AND GEE.FECHAMODIFICAR IS NULL';
            
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 5.10 - BORRAR USUARIOMODIFICAR HISTÓRICO'|| CHR(10);   

   V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.GEH_GESTOR_ENTIDAD_HIST GEH
            SET GEH.USUARIOMODIFICAR = NULL
               WHERE GEH.USUARIOCREAR = ''STOCK_BC''
               AND TRUNC(SYSDATE) = TRUNC(GEH.FECHACREAR)
               AND GEH.USUARIOMODIFICAR IS NOT NULL
               AND GEH.FECHAMODIFICAR IS NULL';
            
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
