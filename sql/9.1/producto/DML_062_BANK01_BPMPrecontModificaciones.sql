/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150914
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
      '(SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_RegistrarTomaDec'')) AND TFI_NOMBRE = ''nueva_preparacion''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
      EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... DELETE DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp fecha_envio');
    V_SQL := 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_SubsanarIncidenciaExp'')) AND TFI_NOMBRE = ''fecha_envio''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... DELETE  DE TABLA TFI_TAREAS_FORM_ITEMS ');

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... INSERT DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp tipo_problema');
    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' || 
      '(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' || 
      'VALUES (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=''PCO_SubsanarIncidenciaExp''), ' || 
      '2, ''combo'', ''tipo_problema'', ''Tipo de problema en expediente'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', ''valor != null && valor != '''' ? true : false'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... DELETE DEL CAMPO TFI_TIPO,  TFI_BUSINESS_OPERATIONDE TFI_TAREAS_FORM_ITEMS');

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... INSERT DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp fecha_exp_sub');
    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' || 
      '(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) ' || 
      'VALUES (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=''PCO_SubsanarIncidenciaExp''), ' || 
      '	3, ''date'', ''fecha_exp_sub'', ''Fecha expediente subsanado'', ''tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'', ''valor != null && valor != '''' ? true : false'', 0, ''DD'', sysdate, 0)';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... DELETE DEL CAMPO TFI_TIPO,  TFI_BUSINESS_OPERATIONDE TFI_TAREAS_FORM_ITEMS');

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL CAMPO TFI_TAREAS_FORM_ITEMS PCO_SubsanarIncidenciaExp observaciones');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN=''4'' WHERE  TAP_ID IN  ' || 
      '(SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_SubsanarIncidenciaExp'')) AND TFI_NOMBRE = ''observaciones''';
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
      '(SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''PCO_SubsanarIncidenciaExp'')) AND TFI_NOMBRE = ''tipo_problema''';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE TABLA TFI_TAREAS_FORM_ITEMS ' );

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
