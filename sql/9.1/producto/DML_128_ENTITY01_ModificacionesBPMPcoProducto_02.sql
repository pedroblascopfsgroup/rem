--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy
--## INCIDENCIA_LINK=PRODUCTO-416
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
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''PS'''' AND d.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_SolicitarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_SolicitarDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''PS'''' AND d.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_SolicitarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoExped CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=1 and d.borrado = 0 and s.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoExped'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoExped'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoExped CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=1 and d.borrado = 0 and s.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoExped'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoExped'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RecepcionExped CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''EN'''' and tactor.dd_pco_dsa_trat_exp=1 and d.borrado = 0 and s.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RecepcionExped'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RecepcionExped'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RecepcionExped CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''EN'''' and tactor.dd_pco_dsa_trat_exp=1 and d.borrado = 0 and s.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RecepcionExped'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RecepcionExped'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null and d.borrado = 0 and s.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDoc'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_codigo=''''PREDOC'''' and d.borrado = 0 and s.borrado = 0)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null and d.borrado = 0 and s.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDoc'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id AND tactor2.dd_pco_dsa_trat_exp =0 and d.borrado = 0 and s.borrado = 0)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';      
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegEnvioDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' AND tactor.dd_pco_dsa_trat_exp=0 and tactor.dd_pco_dsa_acceso_recovery=1 and s.pco_doc_dso_fecha_envio is null and d.borrado = 0 and s.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegEnvioDoc'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_trat_exp=0 and tactor2.dd_pco_dsa_acceso_recovery=1 and d.borrado = 0 and s.borrado = 0)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegEnvioDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegEnvioDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_envio is null and d.borrado = 0 and s.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegEnvioDoc'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_trat_exp=0 and d.borrado = 0 and s.borrado = 0)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegEnvioDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RecepcionDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id = d.pco_doc_pdd_id INNER JOIN dd_pco_doc_solicit_tipoactor tactor ON tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id AND tactor.dd_pco_dsa_acceso_recovery = 0 AND s.pco_doc_dso_fecha_recepcion is null and d.borrado = 0 and s.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RecepcionDoc'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RecepcionDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RecepcionDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id = d.pco_doc_pdd_id where d.pco_prc_id=pco.pco_prc_id AND s.pco_doc_dso_fecha_recepcion is null and d.borrado = 0 and s.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RecepcionDoc'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RecepcionDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AdjuntarDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_doc_documentos d where d.pco_prc_id=pco.pco_prc_id and d.pco_doc_pdd_adjunto=0 and d.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_AdjuntarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''02'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AdjuntarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AdjuntarDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where not exists (select 1 from pco_doc_documentos d where d.pco_prc_id=pco.pco_prc_id and d.pco_doc_pdd_adjunto=0 and d.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_AdjuntarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''02'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AdjuntarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_GenerarLiq CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''''PEN'''' and liq.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_GenerarLiq'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_GenerarLiq'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_GenerarLiq CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''''PEN'''' and liq.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_GenerarLiq'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_GenerarLiq'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_ConfirmarLiq CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''''CAL'''' and liq.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_ConfirmarLiq'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_ConfirmarLiq'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_ConfirmarLiq CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''''CAL'''' and liq.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_ConfirmarLiq'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_ConfirmarLiq'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_EnviarBurofax CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf left join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null and bf.borrado = 0) and exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''''CON'''' and lq.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_EnviarBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_EnviarBurofax CANCELAR');
	V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where (not exists (select 1 from pco_bur_burofax bf left join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_solicitud is null and bf.borrado = 0) or not exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''''CON'''' and lq.borrado = 0)) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_EnviarBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AcuseReciboBurofax CANCELAR');
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AcuseReciboBurofax CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_acuso is null and bf.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_AcuseReciboBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AcuseReciboBurofax CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join '||V_ESQUEMA_M||'.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is not null and bfe.pco_bur_envio_fecha_acuso is not null and bf.borrado = 0) and not exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null and bfe.pco_bur_envio_fecha_acuso is null and bf.borrado = 0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
	EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoDocG CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null and d.borrado = 0 and s.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDocG'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_trat_exp=0 and tactor2.dd_pco_dsa_acceso_recovery=1 and d.borrado = 0 and s.borrado = 0)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDocG'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
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
