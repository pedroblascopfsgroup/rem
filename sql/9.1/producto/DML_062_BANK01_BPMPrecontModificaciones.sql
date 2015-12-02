/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150915
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-130
--## PRODUCTO=SI
--##
--## Finalidad: Modificaciones Trámite de ejemplo BPM Precontencioso
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    
BEGIN	


    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_RegistrarTomaDec nueva_preparacion');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL=''valores[''''PCO_RegistrarTomaDec''''][''''correcto'''']'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_RegistrarTomaDec'')) AND TFI_NOMBRE = ''nueva_preparacion''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... DELETE DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp fecha_envio');
    V_SQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_SubsanarIncidenciaExp'')) AND TFI_NOMBRE = ''fecha_envio''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... DELETE  DE TABLA TFI_TAREAS_FORM_ITEMS ');

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || 
    	'.tap_tarea_procedimiento WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'') and TFI_NOMBRE = ''tipo_problema''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Ya existe el campo tipo_problema en PCO_SubsanarIncidenciaExp ');
    ELSE
	    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... INSERT DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp tipo_problema');
	    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' || 
	      '(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' || 
	      'VALUES (' || V_ESQUEMA || '.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo=''PCO_SubsanarIncidenciaExp''), ' || 
	      '2, ''combo'', ''tipo_problema'', ''Tipo de problema en expediente'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', ''valor != null && valor != '''' ? true : false'', 0, ''DD'', sysdate, 0)';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... DELETE DEL CAMPO TFI_TIPO,  TFI_BUSINESS_OPERATIONDE TFI_TAREAS_FORM_ITEMS');
	END IF;
	
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM ' || V_ESQUEMA || 
    	'.tap_tarea_procedimiento WHERE TAP_CODIGO = ''PCO_SubsanarIncidenciaExp'') and TFI_NOMBRE = ''fecha_exp_sub''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;  
    IF V_NUM_TABLAS > 0 THEN				
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||VAR_TABLENAME||'... Ya existe el campo fecha_exp_sub en PCO_SubsanarIncidenciaExp ');
    ELSE
	    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... INSERT DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp fecha_exp_sub');
	    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' || 
	      '(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' || 
	      'VALUES (' || V_ESQUEMA || '.s_tfi_tareas_form_items.nextval, (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo=''PCO_SubsanarIncidenciaExp''), ' || 
	      '	3, ''date'', ''fecha_exp_sub'', ''Fecha expediente subsanado'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', ''valor != null && valor != '''' ? true : false'', 0, ''DD'', sysdate, 0)';
	    EXECUTE IMMEDIATE V_SQL;
	    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... DELETE DEL CAMPO TFI_TIPO,  TFI_BUSINESS_OPERATIONDE TFI_TAREAS_FORM_ITEMS');
	END IF;

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp observaciones');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN=''4'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_SubsanarIncidenciaExp'')) AND TFI_NOMBRE = ''observaciones''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE TAP_TAREA_PROCEDIMIENTO TAP_VIEW PCO_ValidarCambioProc');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/precontencioso/tramite/validarCambioProc'' WHERE ' || 
      'TAP_CODIGO=''PCO_ValidarCambioProc''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE TAP_TAREA_PROCEDIMIENTO TAP_VIEW PCO_RevisarNoAceptacion');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/precontencioso/tramite/revisarNoAceptacion'' WHERE ' || 
      'TAP_CODIGO=''PCO_RevisarNoAceptacion''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE TAP_TAREA_PROCEDIMIENTO TAP_VIEW PCO_SubsanarIncidenciaExp');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/precontencioso/tramite/subsanarIncidenciaExp'' WHERE ' || 
      'TAP_CODIGO=''PCO_SubsanarIncidenciaExp''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp tipo_problema');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL=''valores[''''PCO_RegistrarTomaDec''''][''''tipo_problema'''']'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_SubsanarIncidenciaExp'')) AND TFI_NOMBRE = ''tipo_problema''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp tipo_problema');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL=''valores[''''PCO_RegistrarTomaDec''''][''''tipo_problema'''']'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_SubsanarIncidenciaExp'')) AND TFI_NOMBRE = ''tipo_problema''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS ValidarCambioProc');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '''', TFI_VALIDACION = '''' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_ValidarCambioProc'')) AND TFI_VALOR_INICIAL IS NOT NULL';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS ValidarCambioProc cambio_aceptado');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = ''4'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_ValidarCambioProc'')) AND TFI_NOMBRE = ''cambio_aceptado''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS ValidarCambioProc nueva_preparacion');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = ''3'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_ValidarCambioProc'')) AND TFI_NOMBRE = ''nueva_preparacion''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_SCRIPT_DECISION PCO_RevisarSubsanacion');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''PCO_RevisarSubsanacion''''][''''subsanar''''] == DDSiNo.SI ? ''''subsanar'''' : ''''devolver'''' '' WHERE  TAP_CODIGO = ''PCO_RevisarSubsanacion''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_ValidarCambioProc tipo_proc_entidad');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''dameProcedimientoPropuesto()'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_ValidarCambioProc'')) AND TFI_NOMBRE = ''tipo_proc_entidad''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_ValidarCambioProc tipo_proc_letrado');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = ''valores[''''PCO_RegistrarTomaDec''''][''''proc_propuesto'''']'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_ValidarCambioProc'')) AND TFI_NOMBRE = ''tipo_proc_letrado''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
       
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TAP_SCRIPT_DECISION PCO_PrepararExpediente');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''PCO_RegistrarAceptacion''''] != null ? ''''preturnado'''' : ''''manual'''''' WHERE  TAP_CODIGO = ''PCO_PrepararExpediente''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegResultadoDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegResultadoDoc'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id AND tactor2.dd_pco_dsa_trat_exp =0)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegResultadoDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );    
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_SolicitarDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join hayamaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''PS'''' AND d.borrado = 0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_SolicitarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_SolicitarDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join hayamaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''PS'''' AND d.borrado = 0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_SolicitarDoc'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_SolicitarDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegEnvioDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' AND tactor.dd_pco_dsa_trat_exp=0 and tactor.dd_pco_dsa_acceso_recovery=1 and s.pco_doc_dso_fecha_envio is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegEnvioDoc'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_trat_exp=0 and tactor2.dd_pco_dsa_acceso_recovery=1)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegEnvioDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RegEnvioDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''''SO'''' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_envio is null) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RegEnvioDoc'''' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_trat_exp=0)) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RegEnvioDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE TAP_TAREA_PROCEDIMIENTO TAP_VIEW PCO_PrepararExpediente');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=''plugin/precontencioso/tramite/preparacion'' WHERE ' || 
      'TAP_CODIGO=''PCO_PrepararExpediente''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TAP_TAREA_PROCEDIMIENTO ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_RegistrarAceptacion titulo');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_LABEL=''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p><p style="margin-bottom: 10px">En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto.</p><p style="margin-bottom: 10px">En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Revisar expediente" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento.</p></div>'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_RegistrarAceptacion'')) AND TFI_NOMBRE = ''titulo''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RecepcionDoc CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id = d.pco_doc_pdd_id INNER JOIN dd_pco_doc_solicit_tipoactor tactor ON tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id AND tactor.dd_pco_dsa_acceso_recovery = 0 AND s.pco_doc_dso_fecha_recepcion is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RecepcionDoc'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RecepcionDoc'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_RecepcionDoc CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id INNER JOIN pco_doc_solicitudes s ON s.pco_doc_pdd_id = d.pco_doc_pdd_id where d.pco_prc_id=pco.pco_prc_id AND s.pco_doc_dso_fecha_recepcion is null) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_RecepcionDoc'''' and tex.borrado=0) and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_RecepcionDoc'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_EnviarBurofax CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join hayamaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf left join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null) and exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''''CON'''') and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_EnviarBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_EnviarBurofax CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join hayamaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where (not exists (select 1 from pco_bur_burofax bf left join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_solicitud is null) or not exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''''CON'''')) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_EnviarBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_EnviarBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AcuseReciboBurofax CREAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join hayamaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_acuso is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''''PCO_AcuseReciboBurofax'''' and tex.borrado=0) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CREAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO PCO_LCT_HQL PCO_AcuseReciboBurofax CANCELAR');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.PCO_LCT_LINEA_CONFIG_TAREA SET PCO_LCT_HQL = ''select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join hayamaster.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is not null and bfe.pco_bur_envio_fecha_acuso is not null) and not exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null and bfe.pco_bur_envio_fecha_acuso is null) and ta.dd_tas_codigo=''''01'''' and pco.prc_id=?'' WHERE  PCO_LCT_CODIGO_TAREA = ''PCO_AcuseReciboBurofax'' AND PCO_LCT_CODIGO_ACCION = ''CANCELAR'' ';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA PCO_LCT_LINEA_CONFIG_TAREA ' );
    
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
