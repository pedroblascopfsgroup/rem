--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=HR-2198
--## PRODUCTO=SI
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
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN	

    V_MSQL:= 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''SELECT COUNT(1) FROM pco_prc_procedimientos pco INNER JOIN prc_procedimientos p ON p.prc_id=pco.prc_id WHERE EXISTS (SELECT 1 FROM pco_doc_documentos d INNER JOIN dd_pco_doc_estado e ON e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id=d.pco_doc_pdd_id INNER JOIN dd_pco_doc_solicit_tipoactor tactor ON tactor.dd_pco_dsa_id            =s.dd_pco_dsa_id WHERE d.pco_prc_id                 =pco.pco_prc_id AND e.dd_pco_ded_codigo            =''''SO'''' AND tactor.dd_pco_dsa_trat_exp     =0 AND tactor.dd_pco_dsa_acceso_recovery=1 AND s.pco_doc_dso_fecha_resultado IS NULL AND d.borrado                      = 0 AND s.borrado                      = 0 ) AND NOT EXISTS (SELECT 1 FROM tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id=tar.tar_id INNER JOIN tap_tarea_procedimiento tap ON tap.tap_id     = tex.tap_id WHERE tar.prc_id  =p.prc_id AND tap.tap_codigo=''''PCO_RegResultadoDocG'''' AND tex.borrado   =0) AND pco.prc_id=?'' WHERE PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION  = ''CREAR''';
    DBMS_OUTPUT.PUT_LINE('Se lanza la actualización ' || V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''SELECT COUNT(1) FROM pco_prc_procedimientos pco INNER JOIN prc_procedimientos p ON p.prc_id=pco.prc_id WHERE NOT EXISTS (SELECT 1 FROM pco_doc_documentos d INNER JOIN dd_pco_doc_estado e ON e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id=d.pco_doc_pdd_id INNER JOIN dd_pco_doc_solicit_tipoactor tactor ON tactor.dd_pco_dsa_id            =s.dd_pco_dsa_id WHERE d.pco_prc_id                 =pco.pco_prc_id AND e.dd_pco_ded_codigo            =''''SO'''' AND tactor.dd_pco_dsa_trat_exp     =0 AND tactor.dd_pco_dsa_acceso_recovery=1 AND s.pco_doc_dso_fecha_resultado IS NULL AND d.borrado                      = 0 AND s.borrado                      = 0 ) AND EXISTS (SELECT 1 FROM tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id=tar.tar_id INNER JOIN tap_tarea_procedimiento tap ON tap.tap_id     = tex.tap_id WHERE tar.prc_id  =p.prc_id AND tap.tap_codigo=''''PCO_RegResultadoDocG'''' AND tex.borrado   =0) AND pco.prc_id=?'' WHERE PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR''';
    DBMS_OUTPUT.PUT_LINE('Se lanza la actualización ' || V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''SELECT COUNT(1) FROM pco_prc_procedimientos pco INNER JOIN prc_procedimientos p ON p.prc_id=pco.prc_id WHERE EXISTS (SELECT 1 FROM pco_doc_documentos d INNER JOIN dd_pco_doc_estado e ON e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id=d.pco_doc_pdd_id INNER JOIN dd_pco_doc_solicit_tipoactor tactor ON tactor.dd_pco_dsa_id            =s.dd_pco_dsa_id WHERE d.pco_prc_id                 =pco.pco_prc_id AND e.dd_pco_ded_codigo            =''''SO'''' AND tactor.dd_pco_dsa_trat_exp     =0 AND tactor.dd_pco_dsa_codigo       =''''PREDOC'''' AND s.pco_doc_dso_fecha_resultado IS NULL AND d.borrado                      = 0 AND s.borrado                      = 0 ) AND NOT EXISTS (SELECT 1 FROM tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id=tar.tar_id INNER JOIN tap_tarea_procedimiento tap ON tap.tap_id     = tex.tap_id WHERE tar.prc_id  =p.prc_id AND tap.tap_codigo=''''PCO_RegResultadoDoc'''' AND tex.borrado   =0 ) AND pco.prc_id=?'' WHERE PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDoc'' AND PCO_LCT_CODIGO_ACCION  = ''CREAR''';
    DBMS_OUTPUT.PUT_LINE('Se lanza la actualización ' || V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''SELECT COUNT(1) FROM pco_prc_procedimientos pco INNER JOIN prc_procedimientos p ON p.prc_id=pco.prc_id WHERE NOT EXISTS (SELECT 1 FROM pco_doc_documentos d INNER JOIN dd_pco_doc_estado e ON e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id=d.pco_doc_pdd_id INNER JOIN dd_pco_doc_solicit_tipoactor tactor ON tactor.dd_pco_dsa_id            =s.dd_pco_dsa_id WHERE d.pco_prc_id                 =pco.pco_prc_id AND e.dd_pco_ded_codigo            =''''SO'''' AND tactor.dd_pco_dsa_trat_exp     =0 AND s.pco_doc_dso_fecha_resultado IS NULL AND d.borrado                      = 0 AND s.borrado                      = 0 ) AND EXISTS (SELECT 1 FROM tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id=tar.tar_id INNER JOIN tap_tarea_procedimiento tap ON tap.tap_id     = tex.tap_id WHERE tar.prc_id  =p.prc_id AND tap.tap_codigo=''''PCO_RegResultadoDoc'''' AND tex.borrado   =0 ) AND pco.prc_id=?'' WHERE PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR''';
    DBMS_OUTPUT.PUT_LINE('Se lanza la actualización ' || V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	COMMIT;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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

EXIT;
  	