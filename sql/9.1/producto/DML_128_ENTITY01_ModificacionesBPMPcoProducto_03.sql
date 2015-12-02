--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy
--## INCIDENCIA_LINK=PRODUCTO-347
--## PRODUCTO=SI
--##
--## Finalidad: Modificaciones BPM Precontencioso Producto
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_SolicitarDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''SELECT COUNT(1) FROM pco_prc_procedimientos pco INNER JOIN prc_procedimientos p ON p.prc_id=pco.prc_id INNER JOIN asu_asuntos a ON a.asu_id=p.asu_id INNER JOIN '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta ON ta.dd_tas_id=a.dd_tas_id WHERE EXISTS (SELECT 1 FROM pco_doc_documentos d INNER JOIN dd_pco_doc_estado e ON e.dd_pco_ded_id = d.dd_pco_ded_id INNER JOIN PCO_PRC_PROCEDIMIENTOS p ON d.PCO_PRC_ID = p.PCO_PRC_ID WHERE d.pco_prc_id = pco.pco_prc_id AND e.dd_pco_ded_codigo=''''PS'''' AND d.borrado = 0 AND (NOT EXISTS (SELECT 1 FROM PCO_CDE_CONF_TFA_TIPOENTIDAD cde WHERE d.DD_PCO_DTD_ID = cde.DD_PCO_DTD_ID AND p.PCO_PRC_TIPO_PRC_INICIADO = cde.DD_TPO_ID AND d.DD_TFA_ID = cde.DD_TFA_ID ) OR EXISTS (SELECT 1  FROM PCO_CDE_CONF_TFA_TIPOENTIDAD cde WHERE d.DD_PCO_DTD_ID = cde.DD_PCO_DTD_ID AND p.PCO_PRC_TIPO_PRC_INICIADO = cde.DD_TPO_ID AND d.DD_TFA_ID = cde.DD_TFA_ID AND (cde.PCO_REQ_LIQUIDA IS NULL OR cde.PCO_REQ_LIQUIDA = 0 OR EXISTS (SELECT 1 FROM pco_liq_liquidaciones liq INNER JOIN dd_pco_liq_estado el ON el.dd_pco_liq_id     =liq.dd_pco_liq_id WHERE liq.pco_prc_id    = p.pco_prc_id AND el.dd_pco_liq_codigo=''''CAL'''' AND liq.borrado = 0 ))))) AND NOT EXISTS (SELECT 1 FROM tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id=tar.tar_id INNER JOIN tap_tarea_procedimiento tap ON tap.tap_id     = tex.tap_id WHERE tar.prc_id  =p.prc_id AND tap.tap_codigo=''''PCO_SolicitarDoc'''' AND tex.borrado = 0 ) AND ta.dd_tas_codigo=''''01'''' AND pco.prc_id = ?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_SolicitarDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''SELECT COUNT(1) FROM pco_prc_procedimientos pco INNER JOIN prc_procedimientos p ON p.prc_id=pco.prc_id INNER JOIN asu_asuntos a ON a.asu_id=p.asu_id INNER JOIN '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta ON ta.dd_tas_id=a.dd_tas_id WHERE NOT EXISTS (SELECT 1 FROM pco_doc_documentos d INNER JOIN dd_pco_doc_estado e ON e.dd_pco_ded_id = d.dd_pco_ded_id INNER JOIN PCO_PRC_PROCEDIMIENTOS p ON d.PCO_PRC_ID = p.PCO_PRC_ID WHERE d.pco_prc_id = pco.pco_prc_id AND e.dd_pco_ded_codigo=''''PS'''' AND d.borrado  = 0 AND (NOT EXISTS (SELECT 1 FROM PCO_CDE_CONF_TFA_TIPOENTIDAD cde WHERE d.DD_PCO_DTD_ID = cde.DD_PCO_DTD_ID AND p.PCO_PRC_TIPO_PRC_INICIADO = cde.DD_TPO_ID AND d.DD_TFA_ID = cde.DD_TFA_ID ) OR EXISTS (SELECT 1 FROM PCO_CDE_CONF_TFA_TIPOENTIDAD cde WHERE d.DD_PCO_DTD_ID = cde.DD_PCO_DTD_ID AND p.PCO_PRC_TIPO_PRC_INICIADO = cde.DD_TPO_ID AND d.DD_TFA_ID = cde.DD_TFA_ID AND (cde.PCO_REQ_LIQUIDA IS NULL OR cde.PCO_REQ_LIQUIDA = 0 OR EXISTS (SELECT 1 FROM pco_liq_liquidaciones liq INNER JOIN dd_pco_liq_estado el ON el.dd_pco_liq_id = liq.dd_pco_liq_id WHERE liq.pco_prc_id = p.pco_prc_id AND el.dd_pco_liq_codigo=''''CAL'''' AND liq.borrado = 0 ))))) AND EXISTS (SELECT 1 FROM tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id = tar.tar_id INNER JOIN tap_tarea_procedimiento tap ON tap.tap_id = tex.tap_id WHERE tar.prc_id  =p.prc_id AND tap.tap_codigo=''''PCO_SolicitarDoc'''' AND tex.borrado = 0 ) AND ta.dd_tas_codigo=''''01'''' AND pco.prc_id = ?'' WHERE PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    COMMIT;
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT
