--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20210706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10016
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
     V_SQL VARCHAR2(32000 CHAR); 
    V_NUM_TABLAS NUMBER(16);
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'V_CAMBIO_ESTADO_PUBLI_AGR_VM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'V_CAMBIO_ESTADO_PUBLI_AGR_VM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    

    CUENTA NUMBER;
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_VISTA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_VISTA||'... Comprobaciones previas');
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');	
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'MATERIALIZED VIEW';
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe vista materializada '||V_ESQUEMA||'.'||V_TEXT_VISTA||'..');
	SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE = 'VIEW';  
	IF CUENTA>0 THEN
		DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' existe, se procede a eliminarla..');
		EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
		DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
	END IF;
  
  
  	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
  
	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||'..');
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';		
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] Verificamos si existe secuencia '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'..');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	END IF; 

      V_MSQL := 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.V_CAMBIO_ESTADO_PUBLI_AGR_VM  
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
    
    DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ESTADO_PUBLI_AGR_VM ...Creada OK');
  
  EXCEPTION

    WHEN OTHERS THEN

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);

    ROLLBACK;
    RAISE;
        
END;
/

EXIT;
