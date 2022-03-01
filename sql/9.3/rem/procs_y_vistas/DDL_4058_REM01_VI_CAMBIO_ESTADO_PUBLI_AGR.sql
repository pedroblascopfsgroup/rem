--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14686
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        	0.1 Versión inicial
--##		0.2 Modificado precio_v y precio_a - Maria Presencia Herrero - REMVIP-2638
--##		0.3 Sergio Beleña -HREOS-4931- Optimización de tiempos   
--##		0.4 Oscar Diestre -HREOS-5358- Modificado para mostrar agrupaciones asisitidas vencidas 
--##		0.5 Oscar Diestre -HREOS-5358- Corregidas por coma simple
--##		0.6 Carles Molins -REMVIP-3995- Incidencia Precios
--##    	0.7 David Gonzalez -HREOS-6184- Ajustes joins
--##    0.8 Daniel Algaba -HREOS-14686-  Añadir nuevas agrupaciones Restringida Alquiler y Restringida OB-REM
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CAMBIO_ESTADO_PUBLI_AGR' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_CAMBIO_ESTADO_PUBLI_AGR';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CAMBIO_ESTADO_PUBLI_AGR' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_CAMBIO_ESTADO_PUBLI_AGR';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR... borrada OK');
  END IF;

      V_MSQL := 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_CAMBIO_ESTADO_PUBLI_AGR 
	    AS
        SELECT AGR_ID
			 , MIN(DD_TCO_CODIGO)DD_TCO_CODIGO
             , MIN(CODIGO_ESTADO_A)CODIGO_ESTADO_A
             , MIN(DESC_ESTADO_A)DESC_ESTADO_A
             , MIN(CHECK_PUBLICAR_A)CHECK_PUBLICAR_A
             , MIN(CHECK_OCULTAR_A) CHECK_OCULTAR_A
             , MIN(DD_MTO_CODIGO_A)DD_MTO_CODIGO_A
             , MIN(DD_MTO_MANUAL_A)DD_MTO_MANUAL_A
             , MIN(CODIGO_ESTADO_V)CODIGO_ESTADO_V
             , MIN(DESC_ESTADO_V)DESC_ESTADO_V
             , MIN(CHECK_PUBLICAR_V)CHECK_PUBLICAR_V
             , MIN(CHECK_OCULTAR_V) CHECK_OCULTAR_V
             , MIN(DD_MTO_CODIGO_V) DD_MTO_CODIGO_V
             , MIN(DD_MTO_MANUAL_V) DD_MTO_MANUAL_V
             , MIN(DD_TPU_CODIGO_A)DD_TPU_CODIGO_A
             , MIN(DD_TPU_CODIGO_V)DD_TPU_CODIGO_V
             , MIN(DD_TAL_CODIGO)DD_TAL_CODIGO
             , MIN(ADMISION)ADMISION
             , MIN(GESTION)GESTION
             , MIN(INFORME_COMERCIAL)INFORME_COMERCIAL
             , MIN(PRECIO_A)PRECIO_A
             , MIN(PRECIO_V)PRECIO_V
             , MIN(CEE_VIGENTE)CEE_VIGENTE
             , MIN(ADECUADO)ADECUADO
             , MIN(ES_CONDICIONADO_PUBLI) ES_CONDICIONADO_PUBLI
 FROM(
 SELECT DISTINCT AGR.AGR_ID
			       , TCO.DD_TCO_CODIGO DD_TCO_CODIGO
             , EPA.DD_EPA_CODIGO CODIGO_ESTADO_A
             , EPA.DD_EPA_DESCRIPCION DESC_ESTADO_A
             , APU.APU_CHECK_PUBLICAR_A CHECK_PUBLICAR_A
             , APU.APU_CHECK_OCULTAR_A CHECK_OCULTAR_A 
             , MTO.DD_MTO_CODIGO DD_MTO_CODIGO_A
             , NVL(MTO.DD_MTO_MANUAL,0) DD_MTO_MANUAL_A
             , EPV.DD_EPV_CODIGO CODIGO_ESTADO_V
             , EPV.DD_EPV_DESCRIPCION DESC_ESTADO_V
             , APU.APU_CHECK_PUBLICAR_V CHECK_PUBLICAR_V
             , APU.APU_CHECK_OCULTAR_V CHECK_OCULTAR_V 
             , MTO2.DD_MTO_CODIGO DD_MTO_CODIGO_V   
             , NVL(MTO2.DD_MTO_MANUAL,0) DD_MTO_MANUAL_V 
             , TPU.DD_TPU_CODIGO DD_TPU_CODIGO_A
             , TPU2.DD_TPU_CODIGO DD_TPU_CODIGO_V
             , TAL.DD_TAL_CODIGO DD_TAL_CODIGO     
             , nvl(ACT.ACT_ADMISION,0) AS ADMISION
             , nvl(ACT.ACT_GESTION,0) AS GESTION
             , nvl(HIC.INFORME_COMERCIAL,0)INFORME_COMERCIAL
             , nvl(VAL.PRECIO_A,0) PRECIO_A
             , nvl(VAL2.PRECIO_V,0) PRECIO_V
             , CASE
                 WHEN ADO.ACT_ID IS NOT NULL THEN 1
                 ELSE 0
               END AS CEE_VIGENTE
             , CASE
                 WHEN PTA.ACT_ID IS NOT NULL THEN 1
                 ELSE 0
               END AS ADECUADO  
             , V.ES_CONDICIONADO_PUBLI ES_CONDICIONADO_PUBLI
          FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
          JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
          JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID AND AGA.BORRADO = 0
          JOIN '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID AND AGR.BORRADO = 0
          JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID AND TAG.BORRADO = 0 
                        AND (             
                              (        TAG.DD_TAG_CODIGO = ''02''	/*Restringida*/
                                AND (AGR.AGR_FIN_VIGENCIA IS NULL OR TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))
                              )     
                            OR(     TAG.DD_TAG_CODIGO = ''13''	/*Asistida*/
                                AND (TRUNC(AGR.AGR_FIN_VIGENCIA) < TRUNC(SYSDATE))
                                )
                            OR(     TAG.DD_TAG_CODIGO = ''17''	/*Restringida alquiler*/
                                AND (AGR.AGR_FIN_VIGENCIA IS NULL OR TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))
                                )
                            OR(     TAG.DD_TAG_CODIGO = ''18''	/*Restringida OBREM*/
                                AND (AGR.AGR_FIN_VIGENCIA IS NULL OR TRUNC(AGR.AGR_FIN_VIGENCIA) >= TRUNC(SYSDATE))
                                )
                            )    
          LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON APU.DD_TCO_ID = TCO.DD_TCO_ID AND TCO.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0

		  LEFT JOIN '|| V_ESQUEMA ||'.V_ACT_ESTADO_DISP V ON V.ACT_ID = APU.ACT_ID
          
          LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO ON APU.DD_MTO_A_ID = MTO.DD_MTO_ID AND MTO.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.DD_MTO_MOTIVOS_OCULTACION MTO2 ON APU.DD_MTO_V_ID = MTO2.DD_MTO_ID AND MTO2.BORRADO = 0
          
          LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU ON APU.DD_TPU_A_ID = TPU.DD_TPU_ID AND TPU.BORRADO = 0
          LEFT JOIN '|| V_ESQUEMA ||'.DD_TPU_TIPO_PUBLICACION TPU2 ON APU.DD_TPU_V_ID = TPU2.DD_TPU_ID AND TPU2.BORRADO = 0
          
          LEFT JOIN '|| V_ESQUEMA ||'.DD_TAL_TIPO_ALQUILER TAL ON TAL.DD_TAL_ID = ACT.DD_TAL_ID AND TAL.BORRADO = 0
          
          LEFT JOIN (SELECT act_id, informe_comercial
                       FROM (SELECT hic.act_id, DECODE (aic.dd_aic_codigo, ''02'', 1, 0)/*Aceptado*/ informe_comercial,
                                    ROW_NUMBER () OVER (PARTITION BY hic.act_id ORDER BY DECODE (aic.dd_aic_codigo, ''02'', 0, ''04'', 0, ''01'', 1, ''03'', 1, 2), hic.hic_fecha DESC) rn
                               FROM '|| V_ESQUEMA ||'.ACT_HIC_EST_INF_COMER_HIST HIC 
                               LEFT JOIN '|| V_ESQUEMA ||'.DD_AIC_ACCION_INF_COMERCIAL AIC ON hic.dd_aic_id = aic.dd_aic_id AND AIC.BORRADO = 0
                              WHERE HIC.BORRADO = 0
                            )
                      WHERE rn = 1) HIC ON ACT.ACT_ID = HIC.ACT_ID
          LEFT JOIN (SELECT act_id, precio_A
                       FROM (SELECT APU.act_id,
                                   CASE
                                      WHEN NVL (tpc.dd_tpc_codigo, ''00'') = ''03'' /*Aprobado de renta (web)*/ AND NVL (tco.dd_tco_codigo, ''00'') IN (''02'', ''03'', ''04'')
                                         THEN 1
                                      WHEN APU.APU_CHECK_PUB_SIN_PRECIO_A = 1
                                         THEN 1
                                      ELSE 0
                                   END AS precio_A,
                                   tpc.dd_tpc_codigo, tco.dd_tco_codigo,
                                   ROW_NUMBER () OVER (PARTITION BY APU.act_id ORDER BY DECODE (tpc.dd_tpc_codigo || tco.dd_tco_codigo, ''0201'', 0, ''0202'', 0, ''0204'', 0, ''0302'', 0, ''0303'', 0, ''0304'', 0, 1)) rn
                              FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU 
                              LEFT JOIN '|| V_ESQUEMA ||'.act_val_valoraciones val ON val.act_id = APU.act_id AND val.borrado = 0
                              LEFT JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO tpc ON tpc.dd_tpc_id = val.dd_tpc_id AND tpc.dd_tpc_codigo = ''03'' AND TPC.BORRADO = 0
                              JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = APU.dd_tco_id AND TCO.BORRADO = 0 AND tco.dd_tco_codigo IN (''01'', ''02'', ''03'', ''04'')
                             WHERE APU.borrado = 0
                              )
                      WHERE rn = 1)VAL ON VAL.ACT_ID = ACT.ACT_ID  
          LEFT JOIN ( SELECT act_id, precio_V
                       FROM (SELECT APU.act_id,
                                   CASE
                                      WHEN NVL (tpc.dd_tpc_codigo, ''00'') = ''02'' /*Aprobado de venta (web)*/ AND NVL (tco.dd_tco_codigo, ''00'') IN (''01'', ''02'', ''04'')
                                         THEN 1
                                      WHEN APU.APU_CHECK_PUB_SIN_PRECIO_V = 1
                                         THEN 1
                                      ELSE 0
                                   END AS precio_V,
                                   tpc.dd_tpc_codigo, tco.dd_tco_codigo,
                                   ROW_NUMBER () OVER (PARTITION BY APU.act_id ORDER BY DECODE (tpc.dd_tpc_codigo || tco.dd_tco_codigo, ''0201'', 0, ''0202'', 0, ''0204'', 0, ''0302'', 0, ''0303'', 0, ''0304'', 0, 1)) rn
                              FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                              LEFT JOIN '|| V_ESQUEMA ||'.act_val_valoraciones val ON val.act_id = APU.act_id AND val.borrado = 0
                              LEFT JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO tpc ON tpc.dd_tpc_id = val.dd_tpc_id AND tpc.dd_tpc_codigo = ''02'' AND TPC.BORRADO = 0
                               JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION tco ON tco.dd_tco_id = APU.dd_tco_id AND TCO.BORRADO = 0 AND tco.dd_tco_codigo IN (''01'', ''02'', ''03'', ''04'')
                             WHERE APU.borrado = 0
                              )
                      WHERE rn = 1)VAL2 ON VAL2.ACT_ID = ACT.ACT_ID                          
          LEFT JOIN (SELECT ADO.ACT_ID
                       FROM '|| V_ESQUEMA ||'.ACT_ADO_ADMISION_DOCUMENTO ADO
                       LEFT JOIN '|| V_ESQUEMA ||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID AND CFD.BORRADO = 0 AND CFD.CFD_APLICA_CALIFICACION = 1 AND CFD.CFD_APLICA_F_ETIQUETA = 1
                       LEFT JOIN '|| V_ESQUEMA ||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND CFD.BORRADO = 0 AND TPD.DD_TPD_CODIGO = ''11'' /*CEE (Certificado de eficiencia energética)*/
                       LEFT JOIN '|| V_ESQUEMA ||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = CFD.DD_TPA_ID AND TPA.BORRADO = 0 AND TPA.DD_TPA_CODIGO IN (''02'',''04'') /*Vivienda, Industrial*/ 
                      WHERE ADO.BORRADO = 0) ADO ON ADO.ACT_ID = ACT.ACT_ID 
          LEFT JOIN(SELECT PTA.ACT_ID
                      FROM '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO PTA 
                      JOIN '|| V_ESQUEMA ||'.DD_ADA_ADECUACION_ALQUILER ADA ON ADA.DD_ADA_ID = PTA.DD_ADA_ID AND ADA.BORRADO = 0 AND ADA.DD_ADA_CODIGO IN (''01'',''03'') /*Si,	No aplica*/
                     WHERE PTA.BORRADO = 0)PTA ON PTA.ACT_ID = ACT.ACT_ID 
         WHERE ACT.BORRADO = 0  
         
         )
    GROUP BY AGR_ID
          
      ';

    /*DBMS_OUTPUT.PUT_LINE(V_MSQL);*/
    EXECUTE IMMEDIATE V_MSQL; 
    
    DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR...Creada OK');
  
    -- Creamos comentarios  
    V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR IS ''Vista que se usa en el cálculo del estado de la publicación para agrupaciones restringuidas (SP_CAMBIO_ESTADO_PUBLICACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;  
      
    -- Creamos comentarios     
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.AGR_ID IS ''Identificador único de la agrupación'' ';      
    EXECUTE IMMEDIATE V_MSQL;
 
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TCO_CODIGO IS ''Código del tipo de comercializacion (DD_TCO_TIPO_COMERCIALIZACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;
        
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.CODIGO_ESTADO_A IS ''Código del estado de la publicación del alquiler (DD_EPA_ESTADO_PUB_ALQUILER)'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DESC_ESTADO_A IS ''Descripción del estado de la publicación del alquiler (DD_EPA_ESTADO_PUB_ALQUILER)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_PUBLICAR_A IS ''Check de publicar el alquiler'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_OCULTAR_A IS ''Check ocultado para alquiler'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_CODIGO_A IS ''Código del motivo ocultación del alquiler (DD_MTO_MOTIVOS_OCULTACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_MANUAL_A IS ''Si es manual el motivo ocultación del alquiler (DD_MTO_MOTIVOS_OCULTACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.CODIGO_ESTADO_V IS ''Código del estado de la publicación de la venta (DD_EPV_ESTADO_PUB_VENTA)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DESC_ESTADO_V IS ''Descripción del estado de la publicación de la venta (DD_EPV_ESTADO_PUB_VENTA)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_PUBLICAR_V IS ''Check de publicar la venta'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.CHECK_OCULTAR_V IS ''Check ocultado para venta'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_CODIGO_V IS ''Código del motivo ocultación de la venta (DD_MTO_MOTIVOS_OCULTACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_MTO_MANUAL_V IS ''Si es manual el motivo ocultación de la venta (DD_MTO_MOTIVOS_OCULTACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TPU_CODIGO_A IS ''Código del tipo de publicación alquiler (DD_TPU_TIPO_PUBLICACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TPU_CODIGO_V IS ''Código del tipo de publicación venta (DD_TPU_TIPO_PUBLICACION)'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.DD_TAL_CODIGO IS ''Código del tipo de de alquiler (DD_TAL_TIPO_ALQUILER)'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.ADMISION IS ''Admisión 0/1'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.GESTION IS ''Gestión 0/1'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.INFORME_COMERCIAL IS ''Informe comercial 0/1'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.PRECIO_A IS ''Precio alquiler 0/1'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.PRECIO_V IS ''Precio venta 0/1'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.CEE_VIGENTE IS ''CEE (Certificado de eficiencia energética) 0/1'' ';      
    EXECUTE IMMEDIATE V_MSQL;  
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.ADECUADO IS ''Adecuado 0/1'' ';      
    EXECUTE IMMEDIATE V_MSQL;                         
 
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_CAMBIO_ESTADO_PUBLI_AGR.ES_CONDICIONADO_PUBLI IS ''Campo calculado en la vista V_ACT_ESTADO_DISP'' ';
    EXECUTE IMMEDIATE V_MSQL;        
    
EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;

