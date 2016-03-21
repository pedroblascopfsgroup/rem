--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150515
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.0.1-rc03-hy
--## INCIDENCIA_LINK=HR-889
--## PRODUCTO=NO
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'HAYAMASTER'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe informar las fechas de anuncio y celebraci&oacute;n de la misma as&iacute; como las costas del letrado y procurador.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &eacute;sta pantalla se lanzar&aacute;n las siguientes tareas:<br>- Se lanzar&aacute; el "Tr&aacute;mite de Tributaci&oacute;n".<br>- "Celebración subasta"" a realizar por el letrado.<br>- "Adjuntar informe de subasta" a realizar por el letrado.<br>- "Contactar con el deudor y preparar informe previo de subasta/fiscal" a realizar por el gestor de deuda.<br>- "Cumplimentar parte econ&oacute;mica de la propuesta de subasta" a realizar por soporte deuda.<br>- "Preparar propuesta de Subasta" a realizar por el gestor de litigios.</p></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H002_SenyalamientoSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;

				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;

	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pesta&ntilde;a Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podr&aacute; generar desde la pesta&ntilde;a Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Validar propuesta de instrucciones" a realizar por el gestor de litigios.</p></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H002_PrepararPropuestaSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;

				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoPSFDUL() ? null : ''''Es necesario adjuntar la Propuesta de Subasta firmada por el Director de la Unidad de Litigios.'''''' '
				|| ' WHERE TAP_CODIGO = ''H002_ValidarPropuesta'' '
				;
				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez comunicada la subasta, en esta pantalla, el gestor de concurso y litigio debe informar de la fecha de notificación y de la fecha de celebración de la subasta&nbsp;<span style="font-size: 10.6666669845581px;">e indicar el letrado asignado a esta subasta y el procurador si procede.</span><span style="font-size: 8pt;">&nbsp;</span></p>Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o mas bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta, deberá indicar a través de la ficha del bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria.<br><p class="MsoNormal"><span style="font-size: 8pt;">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</span></p><p style="margin-bottom: 10px">Una vez rellene ésta pantalla se lanzarán las siguientes tareas:<br>- "Celebración subasta" a realizar por el letrado.<br>- "Adjuntar informe de subasta" a realizar por el letrado.<br>- "Preparar propuesta de subasta" a realizar por el gestor de litigios.<br>- "Preparar informe previo de subasta/fiscal" por parte del gestor de deuda.<br>- "Cumplimentar la parte economica del propuesta de subasta" por parte del Soporte Deuda.<br>- Se lanzará el "Trámite de tributación".</p></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H004_SenyalamientoSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;

				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podrá generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deberá adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deberá informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Validar propuesta informe de subasta " a realizar por el Supervisor de Litigios.</p></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H004_PrepararPropuestaSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;
				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoPSFDUL() ? null : ''''Es necesario adjuntar la Propuesta de Subasta firmada por el Director de la Unidad de Litigios.'''''' '
				|| ' WHERE TAP_CODIGO = ''H004_ValidarPropuesta'' '
				;
				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Una vez comunicada la subasta, en esta pantalla, el letrado debe informar de la fecha de notificación y de la fecha de celebración de la subasta así como el núm. de auto de la misma.</p><br><span style="font-size: 10.6666669845581px;">Para dar por terminada esta tarea, deberá acceder a la pestaña Subastas del asunto correspondiente y asociar uno o mas bienes a la subasta que corresponda. Una vez agregados los bienes a la subasta, deberá indicar a través de la ficha del bien las cargas anteriores y posteriores, si es vivienda habitual o no y la situación posesoria.</span><br><br><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene ésta pantalla se lanzarán las siguientes tareas:<br>- "Celebración subasta" a realizar por el letrado.<br>- "Adjuntar informe de subasta" a realizar por el letrado.<br>- "Preparar propuesta de subasta" a realizar por el gestor de litigios.<br>- "Preparar informe previo de subasta/fiscal" por parte del gestor de deuda.<br>- "Cumplimentar la parte económica del propuesta de subasta" por parte del Soporte Deuda.<br>- Se lanzará el "Trámite de tributación".</p></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H003_SenyalamientoSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;

				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pesta&ntilde;a Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podr&aacute; generar desde la pesta&ntilde;a Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe para la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Validar propuesta informe subasta" a realizar por el supervisor de litigios.</p></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H003_PrepararPropuestaSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;
				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoPSFDUL() ? null : ''''Es necesario adjuntar la Propuesta de Subasta firmada por el Director de la Unidad de Litigios.'''''' '
				|| ' WHERE TAP_CODIGO = ''H003_ValidarPropuesta'' '
				;
				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">A través de esta pantalla deberá informar, por un lado, fecha de auto declarando subasta, fecha de registro, la fecha de la subasta y fecha BOP o DG C.A. También deberá informar si es vivienda Habitual en el campo correspondiente.</p><br><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>	<div align="justify" style="font-size: 8pt; margin-bottom: 30px;">	Una vez rellene esta pantalla las siguientes tareas serán:</div><div align="justify" style="font-size: 8pt; margin-bottom: 30px;"><div align="justify" style="font-size: 8pt; margin-bottom: 30px;"><span style="font-size: 8pt;">* Se lanzará la tarea de "Registrar solicitud de tasación" a realizar por el gestor de subasta.</span></div><div align="justify" style="font-size: 8pt; margin-bottom: 30px;">* Se lanzará la tarea de " Preparar informe de la  propuesta de subasta" a realizar por el gestor de litigios.</div><div align="justify" style="font-size: 8pt; margin-bottom: 30px;">* Se lanzará la tarea de "Registrar envío comunicación al titular del dominio" a realizar por el letrado.</div></div></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H036_registrarAnuncioSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;

				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '
				|| ' SET TFI_LABEL = ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber&aacute; acceder desde la pestaña Subastas del asunto correspondiente a cada uno de los bienes afectos a la subasta e indicar los importes para la puja sin postores, puja con postores desde y puja con postores hasta. Una vez hecho esto podr&aacute; generar desde la pestaña Subastas el informe con la propuesta de instrucciones para la subasta en formato Word, de forma que en caso de ser necesario pueda modificarlo.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar el informe con la propuesta de instrucciones para la subasta al procedimiento correspondiente.</p><p style="margin-bottom: 10px">En el campo Fecha deber&aacute; informar la fecha en la que haya adjuntado el informe con las instrucciones para la subasta.</p><p style="margin-bottom: 10px">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar&aacute; la tarea "Validar propuesta de instrucciones" a realizar por el supervisor de  litigios.</p></div>'' '
				|| ' WHERE TAP_ID = (select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where tap_codigo = ''H036_PrepararInformeSubasta'') '
				|| ' AND TFI_NOMBRE = ''titulo'' '
				;
				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET TAP_SCRIPT_VALIDACION = ''comprobarExisteDocumentoPSUDUL() ? null : ''''Es necesario adjuntar el documento Propuesta Subasta firmada por Director de la Unidad de Litigios'''''' '
				|| ' WHERE TAP_CODIGO = ''H036_ValidarPropuesta'' '
				;
				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;	
	
	
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;