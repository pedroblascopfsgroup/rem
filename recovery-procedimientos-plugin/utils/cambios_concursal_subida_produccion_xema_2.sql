--TRÁMITE DEMANDADO EN INCIDENTE

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_DECISION = 'valores[''P26_registrarResolucionOposicion''][''resultado''] == DDFavorable.FAVORABLE ? ''FAVORABLE'' : ''NO FAVORABLE'' '
WHERE TAP_CODIGO = 'P26_registrarResolucionOposicion';

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_DECISION = 'valores[''P26_registrarResolucionAllanamiento''][''resultado''] == DDFavorable.FAVORABLE ? ''FAVORABLE'' : ''NO FAVORABLE'' '
WHERE TAP_CODIGO = 'P26_registrarResolucionAllanamiento';

COMMIT;

--TRÁMITE FASE COMÚN ABREVIADO



update tfi_tareas_form_items 
set TFI_ORDEN = 4
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_orden = 2;
update tfi_tareas_form_items 
set TFI_ORDEN = 3
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_orden = 1;


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 1, 'date', 'fechaComunicacion', 'Fecha de comunicación del proyecto', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 2, 'combo', 'comFavorable', 'Favorable', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n o env&'||'iacute;o por correo electr&'||'oacute;nico de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos a la administraci&'||'oacute;n concursal, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de valores definitivos y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; , si hemos comunicado nuestros cr&'||'eacute;ditos  a la Administraci&'||'oacute;n concursal mediante correo electr&'||'oacute;nico , &'||'quot;Registrar comunicaci&'||'oacute;n proyecto inventario &'||'quot;.</p><p style="margin-bottom: 10px">Se deber&'||'aacute; consignar la fecha con la que se nos comunica mediante correo electr&'||'oacute;nico por la Administraci&'||'oacute;n Concursal el proyecto de inventario</p>
<p style="margin-bottom: 10px">Igualmente, dberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&'||'oacute;n Concursal. En el caso de que sea favorable, se deber&'||'aacute; esperar a la siguente tarea, sobre el informe presentado por la Administraci&'||'aacute;n Concursal ante el juez</p>
<p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&'||'aacute; informar al supervisor mediante comunicado o notificaci&'||'oacute;n para recibir instrucciones. En ese caso, deber&'||'aacute; presentar escrito solicitando la rectificaci&'||'oacute;n de cualquier error o simplemente los datos comunicados</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') AND TFI_TIPO = 'label';



update TAP_TAREA_PROCEDIMIENTO
set tap_script_decision = 'valores[''P23_presentarEscritoInsinuacionCreditos''][''comFavorable''] == DDSiNo.SI ? ''SI'' : ''NO'' '
where tap_codigo = 'P23_presentarEscritoInsinuacionCreditos';
commit;


Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_presentarRectificacion', 0, 'Presentar solicitud de rectificación o complemento de datos', 
null,
0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarRectificacion'), 'damePlazo(valores[''P23_presentarEscritoInsinuacionCreditos''][''fecha'']) + 7*24*60*60*1000L', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarRectificacion'), 0, 'label', 'titulo' 
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez recibidas las instrucciones del supervisor, en esta pantalla se deber&'||'aacute; consignar la fecha del env&'||'iacute;o por correo electr&'||'oacute;nico del escrito solicitando la rectificaci&'||'oacute;n de errores o el complemento de datos en el proyecto de inventario y de la lista de acreedores notificadas por la Administraci&'||'oacute;n Concursal</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarRectificacion'), 1, 'date', 'fecha', 'Fecha presentación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarRectificacion'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);
commit;	


--TRÁMITE CONCLUSIÓN

delete from tar_tareas_notificaciones where tar_id IN  (select tar_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal'));
delete from tev_tarea_externa_valor where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal'));
delete from ter_tarea_externa_recuperacion where tex_id IN (select tex_id from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal'));
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal');
delete from tex_tarea_externa where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal');
delete from TFI_TAREAS_FORM_ITEMS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal');
delete from DD_PTP_PLAZOS_TAREAS_PLAZAS where tap_id IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal');
delete from TAP_TAREA_PROCEDIMIENTO where tap_codigo = 'P62_registrarResolucionConcursal';

update tap_tarea_procedimiento
set tap_view = null
where tap_codigo = 'P62_registrarOposicion';

delete from tfi_tareas_form_items where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_nombre = 'resResolucionConcursal';

update tfi_tareas_form_items 
set TFI_ORDEN = 1
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_nombre = 'comboOposicion';


update tfi_tareas_form_items 
set TFI_ORDEN = 2
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_nombre = 'fechaOposicion';

update tfi_tareas_form_items 
set TFI_ORDEN = 3
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_nombre = 'fechaAlegaciones';

update tfi_tareas_form_items 
set TFI_ORDEN = 4
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_nombre = 'comboActor';


update tfi_tareas_form_items 
set TFI_ORDEN = 5
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarOposicion') and tfi_nombre = 'observaciones';

update tfi_tareas_form_items 
set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">En esta tarea, deber&'||'aacute; consignar la fecha de conclusi&'||'oacute;n del concurso en el caso de que la causa se encuentre entre las establecidas en el art&'||'iacute;culo 176.1.1 y 2 de la Ley Concursal. En este supuesto, se dar&'||'aacute; por concluido el concurso.</p>
<p style="margin-bottom: 10px">En otro caso, deber&'||'aacute; consignar la fecha de solicitud de conclusi&'||'oacute;n del concurso.</p>
<p style="margin-bottom: 10px">En todo caso, ha de consignar la causa de conclusi&'||'oacute;n del concurso seg&'||'uacute;n los motivos recogidos en el artículo 176.1 de la Ley Concursal</p>
<p style="margin-bottom: 10px">En los supuestos distintos a los recogidos en el primer p&'||'aacute;rrafo de estas instrucciones, la siguiente tarea ser&'||'aacute; &'||'quot;Registrar informe/solicitud de la Administraci&'||'oacute;n Concursal&'||'quot;.</p>
</div>' 
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarCausaConclusion') and tfi_nombre = 'titulo';


update TAP_TAREA_PROCEDIMIENTO
set tap_descripcion = 'Registrar informe/solicitud de la Administración Concursal'
where tap_codigo = 'P62_registrarInformeAdmConcursal';

update tfi_tareas_form_items 
set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">En esta tarea, deber&'||'aacute; consignar la fecha de la puesta de manifiesto y entrega del informe/solicitud de la Administraci&'||'oacute;n concursal. Indicando si es favorable o desfavorable.</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será &'||'quot;Registrar oposición&'||'quot;</p></div>' 
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarInformeAdmConcursal') and tfi_nombre = 'titulo';


update DD_PTP_PLAZOS_TAREAS_PLAZAS
set dd_ptp_plazo_script = 'valores[''P62_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? (damePlazo(valores[''P62_registrarInformeAdmConcursal''][''fecha'']) + 20*24*60*60*1000L ) : 15*24*60*60*1000L'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P62_registrarConclusionConcurso');

commit;

