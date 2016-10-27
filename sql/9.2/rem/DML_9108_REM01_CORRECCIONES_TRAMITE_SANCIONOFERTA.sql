--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20161014
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para el trámite de sanción de ofertas.
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
    /* ################################################################################
     ## MODIFICACIONES: Se cambian las decisiones del trámite de sanción de ofertas.
     ## de la obtención de documentos.
     ##
     */
    
BEGIN
	
	/*VALIDACIONES DE DOCUMENTO */
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("10","E")'' '||
			  ' WHERE TAP_CODIGO = ''T013_InformeJuridico'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''checkVPO() ? existeAdjuntoUGValidacion("21","E") : null'' '||
			  ' WHERE TAP_CODIGO = ''T013_InstruccionesReserva'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("11,E;12,E")'' '||
			  ' WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("13,E;14,E")'' '||
			  ' WHERE TAP_CODIGO = ''T013_ResolucionTanteo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("07,E")'' '||
			  ' WHERE TAP_CODIGO = ''T013_ResultadoPBC'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? (existeAdjuntoUGValidacion("07,E")) : null  '' '||
			  ' WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("19,E;20,E")'' '||
			  ' WHERE TAP_CODIGO = ''T013_DocumentosPostVenta'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    /*TÍTULOS DE LAS TAREAS*/
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Ha aceptado una oferta y se ha creado un expediente comercial asociado a la misma. A continuación '||
    		  ' deberá rellenar todos los campos necesarios para definir la oferta, pudiendo darse la siguiente casuística para finalizar la tarea </p> '||
    		  ' <p style="margin-bottom: 10px">A) Si tiene atribuciones para sancionar la oferta:<br /> '||
    		  ' i) Si el activo está dentro del perímetro de formalizaciónm al pulsar el botón Aceptar finalizará esta tarea y se le lanzará a la gestoría de '||
    		  ' formalización una nueva tarea para la realización del "Informe jurídico".<br /> '||
    		  ' ii) Si el activo no se encuentra dentro del perímetro de formalización, la siguiente tarea que se lanzará es "Firma por el propietario".</p> '||
    		  '	<p style="margin-bottom: 10px"> B) Si no tiene atribuciones para sancionar la oferta, deberá preparar la propuesta y remitirla al comité sancionador, indicando '||
    		  ' abajo la fecha de envío.</p>'||
    		  ' <p style="margin-bottom: 10px"> C) El presente expediente tiene origen en el ejercicio del derecho de tanteo y retracto administrativo, por lo que la oferta'||
    		  ' ya fue aprobada en su momento. De ser así, marque el check dispuesto al efecto, identificando el nº de expediente origen, para que el trámite vaya directamente a'||
    		  ' la tarea de "Posicionamiento y firma".</p>'||
    		  ' <p style="margin-bottom: 10px"> En cualquier caso, para poder finalizar la tarea, tiene que reflejar si existe riesgo reputacional y/o conflicto de intereses'||
    		  ' en la Ficha del expediente. </p>'||
    		  ' <p style="margin-bottom: 10px"> En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este'||
    		  ' punto del trámite </p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DefinicionOferta'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere'||
			  ' que debe quedar reflejado en este punto del trámite.</p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_FirmaPropietario'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Ha elevado un expediente comercial al comité sancionador de la cartera. Para completar esta '||
    		  ' tarea es necesario esperar a la respuesta del comité, subiendo el documento de respuesta por parte del comité en la pestaña "documentos". Además:</p>'||
    		  '	<p style="margin-bottom: 10px">A) Si el comité ha <b>rechazado</b> la oferta, seleccione en el campo "Resolución comité" la opción "Rechazada". '||
    		  ' Con esto finalizará el trámite, quedando el expediente rechazado.</p>'||
			  ' <p style="margin-bottom: 10px">B) Si el comité ha <b>propuesto</b> una contraoferta, suba el documento justificativo en la pestaña "documentos" del expediente.'||
			  ' Seleccione la opción "contraoferta" e introduzca el importe propuesto en el campo "importe contraoferta". La siguiente tarea que se lanzará es '||
			  ' "Respuesta contraoferta".</p>'||
			  ' <p style="margin-bottom: 10px">C) Si el comité ha <b>aprobado</b> la oferta, suba el documento justificativo en la pestaña "documentos" del expediente'||
			  ' y seleccione la opción "aprobado" en el campo "Resolución comité". La siguiente tarea se le lanzará a la gestoría para la realización del informe'||
			  ' jurídico.</p>'||
			  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado'||
			  ' en este punto del trámite.</p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_ResolucionComite'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
        
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Se ha aprobado una propuesta de contraoferta. Para finalizar la tarea, compruebe que el importe'||
    		  ' introducido en el campo ""Importe contraoferta"" coincide con el que figura en el documento remitido por el comité, que podrá encontrar en la pestaña '||
    		  ' "documentos" del expediente comercial.</p>'||
    		  ' <p style="margin-bottom: 10px">Si no coincide, seleccione "No" en el campo "tecleo correcto" y teclee el importe correcto en el campo habilitado al efecto.</p>'||
    		  ' <p style="margin-bottom: 10px">Si el importe es el correcto, seleccione "Si" en el campo "tecleo correcto".</p>'||
    		  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado'||
    		  ' en este punto del trámite</p>'' '||    		  
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DobleFirma'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">La resolución del comité sancionador ha sido porponer nuevo importe como contraoferta.'||
    		  ' Para finalizar esta tarea, debe reflejar la decisión del comprador con respecto a la misma.</p>'||
			  ' <p style="margin-bottom: 10px">Si el ofertante ha rechazado la propuesta de contraoferta, seleccione la opción "Rechaza contraoferta"'||
			  ' en el campo "Respuesta ofertante". Con esto se dará por concluido el trámite y el expediente quedará rechazado.</p>'||
			  ' <p style="margin-bottom: 10px">Si el ofertante ha aceptado la propuesta de contraoferta, seleccione la opción "Acepta contraoferta".'||
			  ' Si es así, se lanzará la tarea "Informe jurídico" a la gestoría de formalización.</p>'||
			  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado'||
			  ' en este punto del trámite.</p>'' '||  
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_RespuestaOfertante'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Para dar por completada esta tarea deberá subir una copia del informe emitido a la pestaña'||
    		  ' "documentos" del expediente comercial. En el campo Resultado deberá consignar el resultado del informe, seleccionado "Favorable" si todo es'||
    		  ' correcto o "Desfavorable" si hay alguna incidencia. De ser así, marque los checks correspondientes en el listado de bloqueos; el gestor comercial'||
    		  ' rebirá una notificación de estos bloqueos.</p>'||
    		  ' <p style="margin-bottom: 10px">Si el expediente lleva asociada una reserva, la siguiente tarea se le lanzará al gestor comercial para que prepare'||
    		  ' las "Instrucciones de reserva".</p>'||
    		  ' <p style="margin-bottom: 10px">Si no lleva reserva asociada, la siguiente tarea será "Resultado PBC", para el gestor de formalización.'||
    		  ' En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_InformeJuridico'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Para finalizar esta tarea, recopile la información necesaria para remitirla a la oficina y'||
    		  ' anote en el campo "fecha de envío" en día efectivo en que lo ha hecho. La siguiente tarea que se le lanzará a la gestoría de formalización es'||
    		  ' "Obtención contrato reserva".</p>'||
    		  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado'||
    		  ' en este punto del trámite.</p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_InstruccionesReserva'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Para dar por completada esta tarea deberá subir una copia del contrato de reserva a la pestaña'||
    		  ' "documentos" del expediente comercial. La siguiente tarea, que se lanzará al gestor de formalización, será "Resultado PBC".</p>'||
    		  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado'||
    		  ' en este punto del trámite.</p>'' '||    		  
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Para finalizar esta tarea, consigne la respuesta remitida por la Administración, informando'||
    		  ' si ejerce o renuncia al derecho de tanteo y retracto.</p>'||
    		  ' <p style="margin-bottom: 10px">Si selecciona ejerce, el presente expediente comercial se anulará, finalizando el trámite. Deberá dar de alta'||
    		  ' una nueva oferta para generar un nuevo expediente, donde deberá reflejar el número del presente expediente.</p>'||
    		  ' <p style="margin-bottom: 10px">Si selecciona renuncia, se le lanzará al gestor de formalización la siguiente tarea "Resultado PBC".</p>'||
    		  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar'||
    		  ' reflejado en este punto del trámite.</p>'' '||    		  
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_ResolucionTanteo'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">En la presente tarea deberá reflejar si se ha aprobado el proceso de PBC.</p>'||
    		  ' <p style="margin-bottom: 10px">Si no se ha aprobado, el expediente quedará anulado, finalizándose el trámite</p>'||
    		  ' <p style="margin-bottom: 10px"> Si se ha aprobado, se lanzará a la gestoría de formalización la tarea de "Posicionamiento y firma"</p>'||
    		  ' <p style="margin-bottom: 10px"> En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar'||
    		  ' reflejado en este punto del trámite</p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_ResultadoPBC'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">La operación ya está lista para su firma. Contacte con los intervientes del expediente'||
    		  ' para acordar una fecha para la firma del contrato de compraventa. Asimismo, recopile todos los juegos de llaves del activo y la documentación'||
    		  ' necesaria para la firma.</p>'||
    		  ' <p style="margin-bottom: 10px">Para finalizar esta tarea, indique si la firma se ha llevado a término, y en su caso, la fecha efectiva de'||
    		  ' escritura y el número de protocolo. La siguiente tarea que se lanzará es "Documentos postventa".</p>'||
			  ' <p style="margin-bottom: 10px">Si la firma se ha cancelado, anule el expediente indicando el motivo, finalizando así el trámite. Se le enviará'||
			  ' una notificación a los gestores comercial y de formalización.</p>'||
			  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar'||
			  ' reflejado en este punto del trámite.</p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">La operación se ha anulado. Envíe de vuelta las llaves al gestor correspondiente, indicando a'||
    		  ' a continuación la fecha de envío</p>'||
    		  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado'||
    		  ' en este punto del trámite.</p>'' '||		  
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DevolucionLlaves'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Se ha otorgado la escritura del expediente asociado. Para finalizar esta tarea, suba'||
    		  ' los documentos oportunos en la pestaña Documentos.</p>'||
    		  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar'||
    		  ' reflejado en este punto del trámite</p>'' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DocumentosPostVenta'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
    		  ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Se ha otorgado la escritura del expediente asociado. Verifique los honorarios asignados'||
    		  ' en la pestaña Cierre económico, seleccionando el check de Honorarios ratificados</p>'||
    		  ' <p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe'||
    		  ' quedar reflejado en este punto del trámite.</p>'' '||    		  
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_CierreEconomico'') '||
			  ' AND TFI_NOMBRE = ''titulo'' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el tipo del campo de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
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