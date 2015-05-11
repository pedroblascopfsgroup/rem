--CORRECCIONES CONCURSAL

--TRÁMITE DE SOLICITUD DE ACTUACIONES O PRONUNCIONAMIENTO

UPDATE DD_TPO_TIPO_PROCEDIMIENTO
SET DD_TPO_DESCRIPCION = 'T. de solicitud de actuaciones o pronunciamientos', dd_tpo_descripcion_larga = 'Trámite de solicitud de actuaciones o pronunciamientos'
WHERE DD_TPO_CODIGO = 'P27';

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n en el Juzgado del escrito de declaraci&'||'oacute;n de no afecci&'||'oacute;n o del requerimiento dirigido a la Administraci&'||'oacute;n Concursal para solicitud de actuaciones de reintegraci&'||'oacute;n, o de otro tipo, contra terceros as&'||'iacute; como el nombre de la persona o entidad implicada.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P27_presentarSolicitud') and tfi_orden = 0;

commit;

--TRÁMITE REGISTRAR RESOLUCIÓN DE INTERÉS

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; de consignar la fecha de notificaci&'||'oacute;n de la Resoluci&'||'oacute;n que hubiere reca&'||'iacute;do.</p><p style="margin-bottom: 10px">Se indicar&'||'aacute; si el resultado de dicha resoluci&'||'oacute;n ha sido favorable para los intereses de la entidad o no.</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea le propondr&'||'aacute;, seg&'||'uacute;n su criterio, que indique la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P28_registrarResolucion') and tfi_orden = 0;

commit;


--TRÁMITE DE SEGUIMIENTO DE CUMPLIMIENTO DE CONVENIO

update tfi_tareas_form_items
set tfi_orden = 5
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarConvenio') and tfi_nombre= 'espera';
update tfi_tareas_form_items
set tfi_orden = 6
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarConvenio') and tfi_nombre= 'comboAdhesion';
update tfi_tareas_form_items
set tfi_orden = 7
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarConvenio') and tfi_nombre= 'observaciones';


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarConvenio'), 4, 'currency', 'carencia', 'Carencia', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


update DD_PTP_PLAZOS_TAREAS_PLAZAS
set DD_PTP_PLAZO_SCRIPT = '((valores[''P64_registrarCumplimiento''] != null) && (valores[''P64_registrarCumplimiento''][''fecha''] !='''') && (valores[''P64_registrarCumplimiento''][''fecha''] != null)) ? damePlazo(valores[''P64_registrarCumplimiento''][''fecha'']) + 90*24*60*60*1000L : damePlazo(valores[''P64_registrarConvenio''][''fecha'']) + 5*24*60*60*1000L'
where tap_id =  (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P64_registrarCumplimiento');

commit;

--TRÁMITE FASE DE LIQUIDACIÓN

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; de consignar la fecha de Resoluci&'||'oacute;n que hubiere reca&'||'iacute;do.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar plan de liquidaci&'||'oacute;n de la Adm. Concursal&'||'quot;.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P31_aperturaFase') and tfi_orden = 0;

update TAP_TAREA_PROCEDIMIENTO 
set tap_descripcion = 'Registrar Plan de liquidación de la Administración Concursal'
where tap_codigo = 'P31_InformeLiquidacion';

commit;

--TRÁMITE DE PRESENTACIÓN CONVENIO

update tfi_tareas_form_items
set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha en la que se dicta la admisi&'||'oacute;n o no de la propuesta del convenio propio. En caso de que no haya admisi&'||'oacute;n deber&'||'aacute; indicar si es subsanable o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute;, en caso de que haya admisi&'||'oacute;n &'||'quot;Registrar escrito de evaluaci&'||'oacute;n de la  administraci&'||'oacute;n concursal&'||'quot;, en caso de que no se haya producido la admisi&'||'oacute;n pero sea subsanable &'||'quot;Registrar presentaci&'||'oacute;n de subsanaci&'||'oacute;n&'||'quot; y en caso de que no sea subsanable se iniciar&'||'aacute;n una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P35_registrarAdmision') and tfi_tipo = 'label';

update tfi_tareas_form_items
set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha en la que se nos notifica la resoluci&'||'oacute;n sobre la subsanaci&'||'oacute;n presentada as&'||'iacute; como el resultado de la misma</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de que la resoluci&'||'oacute;n nos haya sido favorable se lanzar&'||'aacute; la tarea &'||'quot;Registrar escrito evaluaci&'||'oacute;n de la Administraci&'||'oacute;n concursal&'||'quot; y en caso de que nos haya sido desfavorable se iniciar&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P35_registrarResultado') and tfi_tipo = 'label';

update TAP_TAREA_PROCEDIMIENTO 
set tap_descripcion = 'Registrar escrito evaluación Administración Concursal'
where tap_codigo = 'P35_registrarInformeAdmConcursal';

ALTER TABLE COV_CONVENIOS_CREDITOS
 ADD (COVCRE_CARENCIA  NUMBER(16,2));

update TAP_TAREA_PROCEDIMIENTO 
set tap_script_validacion_jbpm = 'existeNumeroAuto() ? ( convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto'' ' 
where tap_codigo = 'P35_registrarConvenioPropio';

update TAP_TAREA_PROCEDIMIENTO 
set tap_script_validacion_jbpm = 'existeNumeroAuto() ? ( convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto'' ' 
where tap_codigo = 'P35_registrarConvenioPropioGestor';
 
commit;

--TRÁMITE FASE COMÚN ABREVIADO

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n o env&'||'iacute;o por correo electr&'||'oacute;nico de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos a la administraci&'||'oacute;n concursal, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de valores definitivos y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En esta tarea, aparecer&'||'aacute;n acumulados los importes de los cr&'||'eacute;ditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; , si hemos comunicado nuestros cr&'||'eacute;ditos  a la Administraci&'||'oacute;n concursal mediante correo electr&'||'oacute;nico , &'||'quot;Registrar comunicaci&'||'oacute;n proyecto inventario &'||'quot;.</p>
</div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') AND TFI_TIPO = 'label';

delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre = 'fechaComunicacion';

delete from tfi_tareas_form_items
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre = 'comFavorable';

update tfi_tareas_form_items 
set TFI_ORDEN = 1
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre = 'fecha';

update tfi_tareas_form_items 
set TFI_ORDEN = 8
where  tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos') and tfi_nombre = 'observaciones';

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_DECISION = NULL, TAP_VIEW = 'plugin/procedimientos/tramiteFaseComunAbreviado/presentarEscritoInsinuacionCreditos'
WHERE TAP_CODIGO = 'P23_presentarEscritoInsinuacionCreditos';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 2, 'currency', 'tCredMasa', 'Total créditos contra la masa', 'dameTotalCreditosContraLaMasa()', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 3, 'currency', 'tCredPrivEsp', 'Total créditos con privilegio especial', 'dameTotalCreditosConPrivilegioEspecial()', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 4, 'currency', 'tCredPrivGen', 'Total créditos con privilegio general', 'dameTotalCreditosConPrivilegioGeneral()', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 5, 'currency', 'tCredOrd', 'Total créditos ordinarios', 'dameTotalCreditosOrdinarios()', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 6, 'currency', 'tCredSub', 'Total créditos subordinados', 'dameTotalCreditosSubordinados()', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos'), 7, 'currency', 'tCredContigentes', 'Total créditos contigentes', 'dameTotalCreditosContingentes()', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


--TAREA REGISTRAR COMUNICACIÓN PROYECTO INVENTARIO
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_regComProyectoInventario', 0, 'Registrar comunicación proyecto inventario', 
'valores[''P23_regComProyectoInventario''][''comFavorable''] == DDSiNo.SI ? ''SI'' : ''NO'' ',
0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_regComProyectoInventario'), 'damePlazo(valores[''P23_registrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_regComProyectoInventario'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; consignar la fecha con la que se nos comunica mediante correo electr&'||'oacute;nico por la Administraci&'||'oacute;n Concursal el proyecto de inventario</p>
<p style="margin-bottom: 10px">Igualmente, dberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&'||'oacute;n Concursal. En el caso de que sea favorable, se deber&'||'aacute; esperar a la siguente tarea, sobre el informe presentado por la Administraci&'||'aacute;n Concursal ante el juez</p>
<p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&'||'aacute; informar al supervisor mediante comunicado o notificaci&'||'oacute;n para recibir instrucciones. En ese caso, deber&'||'aacute; presentar escrito solicitando la rectificaci&'||'oacute;n de cualquier error o simplemente los datos comunicados</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_regComProyectoInventario'), 1, 'date', 'fechaComunicacion', 'Fecha de comunicación del proyecto', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_regComProyectoInventario'), 2, 'combo', 'comFavorable', 'Favorable', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

commit;


--TRÁMITE FASE CONVENIO

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;">
<p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla el supervisor indica las instrucciones a seguir por parte del gestor de cara a la junta de acreedores.</p>
<p style="margin-bottom: 10px">En el caso de no aceptar el Gestor Externo las instrucciones que se relacionen en la presente pantalla, al supervisor le volver&'||'aacute; a salir esta misma Tarea, debiendo ratificar las instrucciones dadas o bien modificarlas en el sentido expuesto por el gestor externo.</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute; la tarea "Lectura y aceptaci&'||'oacute;n de instrucciones".</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_dictarInstrucciones') AND TFI_TIPO = 'label';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav&'||'eacute;s de esta pantalla el gestor atiende las instrucciones propuestas por el supervisor para la junta de acreedores.</p>
<p style="margin-bottom: 10px">Para el caso que se entienda que en las instrucciones dadas por el supervisor de la entidad existe alg&'||'uacute;n error, no deber&'||'aacute; aceptar las mismas, explicando el motivo en el campo  de observaciones o enviando un comunicado al supervisor. En este caso, deber&'||'aacute; esperar a recibir, por parte del supervisor, las instrucciones que procedan</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute; la tarea &'||'quot;Registrar resultado&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_lecturaAceptacionInstrucciones') AND TFI_TIPO = 'label';


update TAP_TAREA_PROCEDIMIENTO 
set tap_script_validacion_jbpm = 'existeNumeroAuto() ? ( checkPosturaEnConveniosDeTercerosOConcursado() ? ((valores[''P29_registrarResultado''][''algunConvenio''] == DDSiNo.SI) ? ( unConvenioAprovadoEnJunta() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noHayConvenioAprovado'' ) : (todosLosConveniosNoAdmitidos() ? null : ''tareaExterna.procedimiento.tramiteFaseConvenio.todosLosConvenioDebenEstarNoAdmitidos'')) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto''' 
where tap_codigo = 'P29_registrarResultado';
 

commit;

