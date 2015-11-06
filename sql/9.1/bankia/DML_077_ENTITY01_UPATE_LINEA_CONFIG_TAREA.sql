--/*
--##########################################
--## AUTOR=MANUEL_MEJIAS
--## FECHA_CREACION=20151026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-master
--## INCIDENCIA_LINK=BKREC-1249
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza los campos de validacion de la tarea  PCO_PreTurnado
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN		
	
    -- Modificar bpm del TPO
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_AdjuntarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AdjuntarDoc CREAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_doc_documentos d where d.pco_prc_id=pco.pco_prc_id and d.pco_doc_pdd_adjunto=0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_AdjuntarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''02'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AdjuntarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_AdjuntarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AdjuntarDoc CANCELAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where not exists (select 1 from pco_doc_documentos d where d.pco_prc_id=pco.pco_prc_id and d.pco_doc_pdd_adjunto=0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_AdjuntarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''02'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AdjuntarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_EnviarBurofax CREAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf left join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null) and exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''''CON'''') and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_EnviarBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_EnviarBurofax CANCELAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where (not exists (select 1 from pco_bur_burofax bf left join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_solicitud is null) or not exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''''CON'''')) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_EnviarBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AcuseReciboBurofax CREAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_acuso is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_AcuseReciboBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AcuseReciboBurofax CANCELAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is not null and bfe.pco_bur_envio_fecha_acuso is not null) and not exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null and bfe.pco_bur_envio_fecha_acuso is null) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_SolicitarDoc CREAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''PS'''' AND d.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_SolicitarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA WHERE PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_SolicitarDoc CANCELAR');
	    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join bankmaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''PS'''' AND d.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_SolicitarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
	END IF;
    
    
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
EXIT;