--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy
--## INCIDENCIA_LINK=PRODUCTO-416
--## PRODUCTO=NO
--##
--## Finalidad: -- Modificaciones BPM Precontencioso Haya
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

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoDocG CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null and d.borrado = 0 and s.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDocG'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_trat_exp=0 and tactor2.dd_pco_dsa_acceso_recovery=1 and d.borrado = 0 and s.borrado = 0)) and pco.prc_id=? '' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoDocG CANCELAR');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null and d.borrado = 0 and s.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDocG'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id AND tactor2.dd_pco_dsa_trat_exp =0 and tactor2.dd_pco_dsa_acceso_recovery=1 and d.borrado = 0 and s.borrado = 0)) and pco.prc_id=? '' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
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
