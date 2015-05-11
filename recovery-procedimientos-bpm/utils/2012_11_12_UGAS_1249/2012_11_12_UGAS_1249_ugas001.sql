SET DEFINE OFF;


Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID, TAP_EVITAR_REORG)
 Values
   (s_tap_tarea_procedimiento.nextval, 29, 'P11_CelebracionSubasta_new1', '(valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion''] == DDTerceros.NOSOTROS) ? ''nosotros'' :  ((valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion''] == ''04'' && valores[''P11_CelebracionSubasta_new1''][''comboMotivoSuspension''] == ''02'' ) ? ''faltaNotificacion'' : ((valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion''] == ''04'' ) ? ''nosotros'' : ((valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion''] == DDTerceros.TERCEROS) ? ''terceros'' : ''adjudicacionConCesionRemate'' )))', 0, 'Celebraci�n subasta y adjudicaci�n', 0, 'Oscar', TO_TIMESTAMP('12/11/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0, 1, 1, 'EXTTareaProcedimiento', 5, 39, 0);



Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS
   (DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select max(tap_id) from tap_tarea_procedimiento), 'valores[''P11_AnuncioSubasta''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) : damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta''])', 0, 'DD', TO_TIMESTAMP('13/11/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);


Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select max(tap_id) from tap_tarea_procedimiento), 0, 'label', 'titulo', '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify">
Una&nbsp;<span style="font-family: Arial; ">vez se celebre la subasta, en esta pantalla debe introducir quien se ha adjudicado el bien y el importe de adjudicación.</span><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Posterior asimismo a la celebración de la subasta, y de acuerdo al Protocolo de Actuación Judicial de NGB se deberá enviar correo electrónico a Gestión de Activos informando del resultado de la subasta</p>Hará gestiones con el juzgado para que se abra el plazo de cesión de remate nada más celebrarse la subasta.<br><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dentro de 5 días a partir de la fecha de celebración de subasta, dispondrá de 10 días para la realización de la cesión de remate.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla la siguiente tarea será:</p><ul style="font-family: Arial; text-align: justify; list-style-type: square; "><li style="margin-bottom: 10px; margin-left: 35px; ">Si el bien se lo han adjudicado terceros: Solicitud mandamiento de pago.</li><li style="margin-bottom: 10px; margin-left: 35px; ">Si el bien se lo ha adjudicado la entidad se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</li></ul></div>', 0, 'DD', TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);


Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select max(tap_id) from tap_tarea_procedimiento), 1, 'currency', 'limite', 'Importe adjudicación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);


Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select max(tap_id) from tap_tarea_procedimiento), 2, 'combo', 'comboAdjudicacion', 'Adjudicación', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDTerceros', 0, 'DD', TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);


Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select max(tap_id) from tap_tarea_procedimiento), 3, 'combo', 'comboMotivoSuspension', 'Motivo de suspensión', '', '', 'DDMotivoSuspension', 0, 'DD', TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);


Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select max(tap_id) from tap_tarea_procedimiento), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0);

commit;