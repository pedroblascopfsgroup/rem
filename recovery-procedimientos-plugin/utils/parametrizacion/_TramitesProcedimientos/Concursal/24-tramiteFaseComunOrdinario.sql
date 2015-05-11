-- *************************************************************************** --
-- **                   BPM Trámite fase comun ordinario                    ** --
-- *************************************************************************** --

-- Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_VIEW, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_registrarPublicacionBOE', 0, 'Registrar publicación en el BOE', 
'pfsgroup/tramiteFaseComunOrdinario/regPublicacionBOE', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), '3*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 0, 'label', 'titulo' 
--,'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de publicaci&'||'oacute;n en el BOE y fecha del auto declarando concurso. Ind&'||'iacute;quese la plaza, n&'||'uacute;mero de  juzgado y el n&'||'uacute;mero de procedimiento en juzgado, estos tres valores podr&'||'iacute;an venir rellenados si el procedimiento es derivado de otro donde ya se hayan introducido.</p><p style="margin-bottom: 10px">Tambien debe introducir el n&'||'uacute;mero de registro en el Bolet&'||'iacute;n ofical del estado, opcionalmente puede consignar los datos de contacto de los administradores concursales designados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;dito por parte del supervisor&'||'quot;.</p></div>'
--, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 0, 'label', 'titulo' 
,'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de publicaci&'||'oacute;n en el BOE y fecha del auto declarando concurso. Ind&'||'iacute;quese la plaza, n&'||'uacute;mero de  juzgado y el n&'||'uacute;mero de procedimiento en juzgado, estos tres valores podr&'||'iacute;an venir rellenados si el procedimiento es derivado de otro donde ya se hayan introducido.</p><p style="margin-bottom: 10px">Tambien debe introducir el n&'||'uacute;mero de registro en el Bolet&'||'iacute;n ofical del estado, deber&'||'aacute;n consignar los datos de contacto de los administradores concursales designados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;dito por parte del supervisor&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 1, 'date', 'fecha', 'Fecha de publicación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 2, 'date', 'fechaAuto', 'Fecha auto declarando concurso', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 3, 'combo', 'plazaJuzgado', 'Plaza del juzgado', 'TipoPlaza', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'damePlaza()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 4, 'combo', 'numJuzgado', 'Nº de juzgado', 'TipoJuzgado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumJuzgado()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 5, 'textproc', 'nProc', 'Nº Procedimiento', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumAuto()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 6, 'currency', 'numBoe', 'Nº BOE', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 17, 'text', 'procurador', 'Procurador', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 7, 'text', 'admNombre', 'Adm.1 Nombre', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 8, 'text', 'admDireccion', 'Adm.1 dirección', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 9, 'text', 'admTelefono', 'Adm.1 teléfono', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 10, 'text', 'admNombre2', 'Adm.2 Nombre', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 11, 'text', 'admDireccion2', 'Adm.2 dirección', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 12, 'text', 'admTelefono2', 'Adm.2 teléfono', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 13, 'text', 'admNombre3', 'Adm.3 Nombre', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 14, 'text', 'admDireccion3', 'Adm.3 dirección', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 15, 'text', 'admTelefono3', 'Adm.3 teléfono', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 16, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 18, 'text', 'admEmail', 'Adm.3 email', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 19, 'text', 'admEmail2', 'Adm.3 email', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 20, 'text', 'admEmail3', 'Adm.3 email', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarPublicacionBOE'), 21, 'date', 'fechaAceptacion', 'Fecha de aceptación del cargo de la administración concursal',  'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',0, 'DD', SYSDATE, 0);



-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_regInsinuacionCreditosSup', 1, 'Registrar insinuación de créditos - supervisor', 
'valores[''P24_regInsinuacionCreditosSup''][''comProcede''] == DDSiNo.SI ? ''SI'' : ''NO''', 
'(valores[''P24_regInsinuacionCreditosSup''][''comboPropuesta''] == DDSiNo.SI) ? (((valores[''P24_regInsinuacionCreditosSup''][''numCreditos''] == '''') || (valores[''P24_regInsinuacionCreditosSup''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : ((cuentaCreditosInsinuadosSup()!=valores[''P24_regInsinuacionCreditosSup''][''numCreditos'']) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)) : null', 
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');
-- pendiente validación de que verdaderamente se an insinuado los créditos correspondientes.
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup'), 'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 10*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup'), 0, 'label', 'titulo'
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de rellenar esta pantalla, para el supuesto que quiera insinuar alg&'||'uacute;n cr&'||'eacute;dito, deber&'||'aacute; ir a la pestaña &'||'quot;Fase com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a su insinuaci&'||'oacute;n para lo que deber&'||'aacute; introducir valores en los campos supervisor.</p><p style="margin-bottom: 10px">En la presente pantalla y para el caso del supuesto anterior debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados.</p><p style="margin-bottom: 10px">En el campo &'||'quot;Procede insinuaci&'||'oacute;n de cr&'||'eacute;ditos por parte del externo&'||'quot; debe consignar si el externo debe insinuar los cr&'||'eacute;ditos.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si se ha indicado que el externo debe introducir propuesta &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;ditos  - gestor&'||'quot;, o &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;ditos definitiva&'||'quot;, si se ha indicado que el gestor no debe insinuar los cr&'||'eacute;ditos.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup'), 1, 'combo', 'comboPropuesta', 'Introduce propuesta', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup'), 2, 'currency', 'numCreditos', 'Nº de créditos insinuados', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup'), 3, 'combo', 'comProcede', 'Procede insinuación de créditos por parte del externo', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_regInsinuacionCreditosSup'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_registrarInsinuacionCreditosExt', 0, 'Registrar insinuación de créditos - gestor', 
'((valores[''P24_registrarInsinuacionCreditosExt''][''numCreditos''] == '''') || (valores[''P24_registrarInsinuacionCreditosExt''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : ((cuentaCreditosInsinuadosExt()!=valores[''P24_registrarInsinuacionCreditosExt''][''numCreditos'']) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'': null)',
0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosExt'), 'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosExt'), 0, 'label', 'titulo' 
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de rellenar esta pantalla deber&'||'aacute; ir a la pestaña &'||'quot;Fase com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a la insinuaci&'||'oacute;n de los cr&'||'eacute;ditos para lo que deber&'||'aacute; introducir valores en los campos gestor.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar insinuaci&'||'oacute;n de cr&'||'eacute;ditos definitiva&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosExt'), 1, 'currency', 'numCreditos', 'Nº de créditos insinuados', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosExt'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 4
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_registrarInsinuacionCreditosDef', 0, 'Registrar insinuación de créditos definitiva', 
'((valores[''P24_registrarInsinuacionCreditosDef''][''numCreditos''] == '''') || (valores[''P24_registrarInsinuacionCreditosDef''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : ((cuentaCreditosInsinuadosDef()!=valores[''P24_registrarInsinuacionCreditosDef''][''numCreditos'']) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'': null)',
0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef'), 'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef'), 0, 'label', 'titulo' 
--, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Aya discrepancia o no en los cr&'||'eacute;ditos insinuados, deber&'||'aacute;n cumplimentar los valores definitivos para la posterior presentaci&'||'oacute;n en el juzgado, por tanto, antes de rellenar esta pantalla deber&'||'aacute; ir a la pestaña &'||'quot;Fase com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a la insinuaci&'||'oacute;n de los cr&'||'eacute;ditos para lo que deber&'||'aacute; introducir valores en los campos definitivos.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados con valores definitivos.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Presentar escrito de insinuaci&'||'oacute;n de cr&'||'eacute;dito&'||'quot;.</p></div>'
--, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef'), 0, 'label', 'titulo' 
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Aya discrepancia o no en los cr&'||'eacute;ditos insinuados, deber&'||'aacute;n cumplimentar los valores definitivos para la posterior presentaci&'||'oacute;n ante la administraci&'||'oacute;n concursal, por tanto, antes de rellenar esta pantalla deber&'||'aacute; ir a la pestaña &'||'quot;Fase com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a la insinuaci&'||'oacute;n de los cr&'||'eacute;ditos para lo que deber&'||'aacute; introducir valores en los campos definitivos.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados con valores definitivos.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Presentar escrito de insinuaci&'||'oacute;n de cr&'||'eacute;dito&'||'quot;.</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef'), 1, 'currency', 'numCreditos', 'Nº de créditos insinuados', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 5
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,tap_script_decision)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_presentarEscritoInsinuacionCreditos', 0, 'Presentar escrito de insinuación de créditos', 
'creditosDefinitivosDefinidosEInsinuados() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosNoInsinuados''',
0, 'DD', SYSDATE, 0,'valores[''P24_presentarEscritoInsinuacionCreditos''][''comFavorable''] == DDSiNo.SI ? ''SI'' : ''NO'' ');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

--Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 0, 'label', 'titulo' 
--, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos en el juzgado, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de valores definitivos y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar informe administraci&'||'oacute;n concursal&'||'quot;.</p></div>'
--, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 0, 'label', 'titulo' 
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n o env&'||'iacute;o por correo electr&'||'oacute;nico de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos a la administraci&'||'oacute;n concursal, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de valores definitivos y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; , si hemos comunicado nuestros cr&'||'eacute;ditos  a la Administraci&'||'oacute;n concursal mediante correo electr&'||'oacute;nico , &'||'quot;Registrar comunicaci&'||'oacute;n proyecto inventario &'||'quot;.</p><p style="margin-bottom: 10px">Se deber&'||'aacute; consignar la fecha con la que se nos comunica mediante correo electr&'||'oacute;nico por la Administraci&'||'oacute;n Concursal el proyecto de inventario</p>
<p style="margin-bottom: 10px">Igualmente, dberemos informar si es favorable o desfavorable a los intereses de la Entidad el proyecto remitido por la Administraci&'||'oacute;n Concursal. En el caso de que sea favorable, se deber&'||'aacute; esperar a la siguente tarea, sobre el informe presentado por la Administraci&'||'aacute;n Concursal ante el juez</p>
<p style="margin-bottom: 10px">En el caso de que sea desfavorable, deber&'||'aacute; informar al supervisor mediante comunicado o notificaci&'||'oacute;n para recibir instrucciones. En ese caso, deber&'||'aacute; presentar escrito solicitando la rectificaci&'||'oacute;n de cualquier error o simplemente los datos comunicados</p></div>'
, 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 1, 'date', 'fechaComunicacion', 'Fecha de comunicación del proyecto', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 2, 'combo', 'comFavorable', 'Favorable', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 3, 'date', 'fecha', 'Fecha presentación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

	--NUEVA TAREA PRESENTAR SOLICITUD RECTIFICACION O COMPLEMENTO DE DATOS
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_presentarSolicitudRectificacion', 0, 'Presentar solicitud de rectificación o complemento de datos', 
null,
0, 'DD', SYSDATE, 0,'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 'damePlazo(valores[''P24_presentarEscritoInsinuacionCreditos''][''fecha'']) + 7*24*60*60*1000L', 0, 'DD', SYSDATE, 0);


Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 0, 'label', 'titulo' 
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez recibidas las instrucciones del supervisor, en esta pantalla se deber&'||'aacute; consignar la fecha del env&'||'iacute;o por correo electr&'||'oacute;nico del escrito solicitando la rectificaci&'||'oacute;n de errores o el complemento de datos en el proyecto de inventario y de la lista de acreedores notificadas por la Administraci&'||'oacute;n Concursal</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 1, 'date', 'fecha', 'Fecha presentación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarSolicitudRectificacion'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);
		

-- Pantalla 6
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_informeAdministracionConcursal', 0, 'Registrar informe administración concursal', 
'creditosDefinitivosPendientes() ? ''tareaExterna.procedimiento.tramiteFaseComun.creditosDefinitivosPendientes'': null',
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_informeAdministracionConcursal'), 'damePlazo(valores[''P24_registrarPublicacionBOE''][''fechaAuto'']) + 90*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_informeAdministracionConcursal'), 0, 'label', 'titulo'
, '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de recepci&'||'oacute;n del informe de administraci&'||'oacute;n concursal en respuesta a nuestra presentaci&'||'oacute;n de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que los cr&'||'eacute;ditos insinuados en la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; disponen de valores definitivos y que se encuentran en estado &'||'quot;3. Pendiente Revisión IAC&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Revisar resultado informe administraci&'||'oacute;n&'||'quot; a rellenar por parte del supervisor.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_informeAdministracionConcursal'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_informeAdministracionConcursal'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


-- Pantalla 7
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_revisarResultadoInfAdmon', 1, 'Revisar resultado informe administración concursal', 
'valores[''P24_revisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ''SI'' : ''NO''',
'valores[''P24_revisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ( creditosDespuesDeIACConDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACDemandaMalDefinidos'' ) : ( creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos'')',
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_revisarResultadoInfAdmon'), 'damePlazo(valores[''P24_informeAdministracionConcursal''][''fecha'']) + 5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_revisarResultadoInfAdmon'), 0, 'label', 'titulo' 
,'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones a nuestra propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que el estado de los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n es, en caso de presentar alegaciones &'||'quot;4. Pendiente de demanda incidental&'||'quot; o en caso contrario &'||'quot;5. Definitivo&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_revisarResultadoInfAdmon'), 1, 'combo', 'comAlegaciones', 'Presentar alegaciones', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_revisarResultadoInfAdmon'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--Pantalla 8
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_BPMTramiteDemandaIncidental',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P25'), 0, 'Ejecución del Trámite demanda incidental', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_BPMTramiteDemandaIncidental'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_BPMTramiteDemandaIncidental'), 0, 'label', 'titulo', 'Ejecución del Trámite demanda incidental', 0, 'DD', SYSDATE, 0);

