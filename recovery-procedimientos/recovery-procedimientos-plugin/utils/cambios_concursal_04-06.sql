--TRAMITE DEMANDA INCIDENTAL

update tap_tarea_procedimiento
set tap_descripcion = 'Confirmar si existe oposición'
where tap_codigo = 'P25_confirmarOposicionYVista';

UPDATE TFI_TAREAS_FORM_ITEMS  
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">Una vez interpuesta la demanda y admitida, en esta pantalla ha de indicar si se ha producido oposici&'||'oacute;n a la demanda y si se ha producido allanamiento</p>
<p style="margin-bottom: 10px">En el supuesto de que exista oposici&'||'oacute;n o allanamiento de la parte demandada, deber&'||'aacute; consignar su fecha de notificaci&'||'oacute;n correspondiente.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista') and tfi_nombre = 'titulo';

delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista') and tfi_nombre = 'comboVista';

delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista') and tfi_nombre = 'fechaVista';

UPDATE TFI_TAREAS_FORM_ITEMS  
set tfi_orden = 3
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista') and tfi_nombre = 'comboAllanamiento';

UPDATE TFI_TAREAS_FORM_ITEMS  
set tfi_orden = 4
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista') and tfi_nombre = 'fechaAllanamiento';

UPDATE TFI_TAREAS_FORM_ITEMS  
set tfi_orden = 5
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista') and tfi_nombre = 'observaciones';


update tap_tarea_procedimiento
set tap_codigo = 'P25_confirmarOposicion'
where tap_codigo = 'P25_confirmarOposicionYVista';

update tap_tarea_procedimiento
set tap_script_decision = 'valores[''P25_confirmarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : ''NO'' ', tap_script_validacion = null
,tap_script_validacion_jbpm = '( ((valores[''P25_confirmarOposicion''][''comboOposicion''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''fechaOposicion''] == ''''))  || ((valores[''P25_confirmarOposicion''][''comboAllanamiento''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''fechaAllanamiento''] == ''''))) ? ''tareaExterna.error.faltaAlgunaFecha'' : ( (valores[''P25_confirmarOposicion''][''comboOposicion''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''comboAllanamiento''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''observaciones''] == '''') ) ? ''tareaExterna.procedimiento.tramiteDemandaIncidental.confirmarOposicion.campoObservaciones'' : ''null'' '
where tap_codigo = 'P25_confirmarOposicion';

update dd_ptp_plazos_tareas_plazas
set DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P25_admisionOposicionYSeñalamientoVista''][''fechaVista'']) + 2*24*60*60*1000L'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_registrarVista')





Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P25'), 'P25_admisionOposicionYSeñalamientoVista', 0, 'Admisión de oposición y señalamiento de vista',
'valores[''P25_admisionOposicionYSeñalamientoVista''][''comboVista''] == DDSiNo.NO || valores[''P25_admisionOposicionYSeñalamientoVista''][''admisionOp''] == DDSiNo.NO  ? ''NO'' : (valores[''P25_admisionOposicionYSeñalamientoVista''][''comboVista''] == DDSiNo.SI ? ''SI'': ''NO'' ) ', 
'( ((valores[''P25_admisionOposicionYSeñalamientoVista''][''admisionOp''] == DDSiNo.SI) &&'||' (valores[''P25_admisionOposicionYSeñalamientoVista''][''fechaResol''] == '''')) || ((valores[''P25_admisionOposicionYSeñalamientoVista''][''comboVista''] == DDSiNo.SI) &&'||' (valores[''P25_admisionOposicionYSeñalamientoVista''][''fechaVista''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':null', 
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_admisionOposicionYSeñalamientoVista'), 'damePlazo(valores[''P25_confirmarAdmisionDemanda''][''fechaProvidencia'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_admisionOposicionYSeñalamientoVista'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">Se ha de indicar la fecha de admisi&'||'oacute;n de la oposici&'||'oacute;n, y en su caso si ha se&'||'ntilde;alado vista por el juzgado</p>
<p style="margin-bottom: 10px">Para el supuesto de que haya m&'||'aacute;s de un demandado y alguno de ellos se oponga a la demanda y otros se allanen a la misma, se deber&'||'aacute; consignar dicha circustancia en el campo observaciones.</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;:</p>
<ul style="list-style-type: square;">
<li style="margin-bottom: 10px; margin-left: 35px;">Si no hay vista o no hay admisi&'||'oacute;n de la oposici&'||'oacute; &'||'quot;Registrar resoluci&'||'oacute;n&'||'quot; (en caso de no admisi&'||'oacute;n pondr&'||'aacute; la misma fecha que en la presente pantalla)</li>
<li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya se&'||'ntilde;alamiento de vista &'||'quot;Registrar vista&'||'quot;</li>
</ul>
</div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO,TFI_BUSINESS_OPERATION, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_admisionOposicionYSeñalamientoVista'), 1, 'combo', 'admisionOp', 'Admisión oposición', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_admisionOposicionYSeñalamientoVista'), 2, 'date', 'fechaResol', 'Fecha resolución', '', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_admisionOposicionYSeñalamientoVista'), 3, 'combo', 'comboVista', 'Vista', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_admisionOposicionYSeñalamientoVista'), 4, 'date', 'fechaVista', 'Fecha vista', '', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


--TRÁMITE PRESENTACION PROPUESTA CONVENIO

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_VALIDACION_JBPM = ' (convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? (creditosDefinidosEnConvenioPropioAdmitidoNoAdmitido() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioEstadoCorrecto'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido'')',
TAP_SCRIPT_DECISION = '(valores[''P35_registrarAdmision''][''comboAdmision''] == DDSiNo.SI) ?  ''SI'' : ( (valores[''P35_registrarAdmision''][''comboSubsanable''] != '''') && (valores[''P35_registrarAdmision''][''comboSubsanable''] == DDSiNo.NO) ?  ''noSubsanable'' : ''subsanable'')'
WHERE TAP_CODIGO = 'P35_registrarAdmision';


--TRÁMITE FASE CONVENIO

-----tarea elevar a comité la propuesta de instrucciones

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P29'), 'P29_elevarAcomitePropuesta', 0, 'Elevar a comité la propuesta de instrucciones',
null, null, 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_elevarAcomitePropuesta'), 'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_elevarAcomitePropuesta'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">Faltan instrucciones</p>
</div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_elevarAcomitePropuesta'), 1, 'date', 'fechaElevacion', 'Fecha elevación a comité', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_elevarAcomitePropuesta'), 2, 'textarea', 'observaciones', 'Observaciones',  0, 'DD', SYSDATE, 0);



------tara resgistrar el rsultado del comité
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P29'), 'P29_registrarResutladoComite', 0, 'Registrar el resultado del comité',
null, null, 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_registrarResutladoComite'), 'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 6*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_registrarResutladoComite'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">Faltan instrucciones</p>
</div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_registrarResutladoComite'), 1, 'date', 'fechaAprobacion', 'Fecha de obtención de aprobación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_registrarResutladoComite'), 2, 'textarea', 'observaciones', 'Observaciones',  0, 'DD', SYSDATE, 0);



