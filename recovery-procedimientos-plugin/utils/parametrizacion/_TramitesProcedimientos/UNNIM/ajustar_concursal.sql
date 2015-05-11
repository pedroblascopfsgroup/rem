-- modificaciones generales
-------------------------------------------------------------------------------------------------------------
update tap_tarea_procedimiento set tap_script_validacion = replace(tap_script_validacion, '¡Atenci&'||'oacute;n!', '&'||'iexcl;Atenci&'||'oacute;n!') where tap_scripT_validacion like '%¡Atenci&'||'oacute;n!%';

insert into dd_tac_tipo_actuacion (DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_larga, USUARIOCREAR, FECHACREAR)
VALUES (S_dd_tac_tipo_actuacion.nextval, 'EX', 'Extrajudicial', 'Extrajudicial', 'DD', sysdate);

-- modificaciones diccionario
-------------------------------------------------------------------------------------------------------------

INSERT INTO UNMASTER.DD_TPO_CREDITO (CRE_ID, CRE_CODIGO, CRE_DESCRIP, CRE_DESCRIP_LARGA, FECHACREAR, USUARIOCREAR)
VALUES (UNMASTER.S_DD_TPO_CREDITO.nextval, '7', 'Crédito contingente', 'Crédito contingente', sysdate, 'DD');

update DD_ACT_ACTOR set dd_act_descripcion = 'Entidad', dd_act_descripcion_larga = 'Entidad'
where dd_act_codigo = '01';

update UNMASTER.DD_STD_CREDITO set  STD_CRE_CODIGO = '6', STD_CRE_DESCRIP = '5. Pendiente de recurso', STD_CRE_DESCRIP_LARGA = 'Pendiente de recurso'
where STD_CRE_CODIGO = '2';

insert into UNMASTER.DD_STD_CREDITO (STD_CRE_ID, STD_CRE_CODIGO, STD_CRE_DESCRIP, STD_CRE_DESCRIP_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (UNMASTER.S_DD_STD_CREDITO.nextval, '2','6. Definitivo', 'Definitivo', 'DD', sysdate);

insert into UN001.DD_DTR_TIPO_RECURSO (DD_DTR_ID, DD_DTR_CODIGO, DD_DTR_DESCRIPCION, DD_DTR_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (10, '10','Recurso de revisión directa', 'Recurso de revisión directa', 'DD', sysdate);

insert into UN001.DD_TPA_TIPO_ACUERDO (DD_TPA_ID, DD_TPA_CODIGO, DD_TPA_DESCRIPCION, DD_TPA_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (S_DD_TPA_TIPO_ACUERDO.nextval, '10','Compra venta', 'Compra venta', 'DD', sysdate);

insert into UNMASTER.DD_CONVENIO_INICIO (INI_ID, INI_CODIGO, INI_DESCRIP, INI_DESCRIP_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (UNMASTER.S_DD_CONVENIO_INICIO.nextval, '4','Concursado + entidad', 'Concursado + entidad', 'DD', sysdate);
insert into UNMASTER.DD_CONVENIO_INICIO (INI_ID, INI_CODIGO, INI_DESCRIP, INI_DESCRIP_LARGA, USUARIOCREAR, FECHACREAR) 
VALUES (UNMASTER.S_DD_CONVENIO_INICIO.nextval, '5','Concursado + terceros', 'Concursado + terceros', 'DD', sysdate);

--ALTER TABLE RCR_RECURSOS_PROCEDIMIENTOS ADD RCR_SUSPENSIVO NUMBER(1) DEFAULT 1 NOT NULL; 

--ALTER TABLE RCR_RECURSOS_PROCEDIMIENTOS ADD DTYPE VARCHAR2(30) DEFAULT 'MEJRecurso' NOT NULL; 

insert into UN001.DD_TAC_TIPO_ACTUACION (DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) 
VALUES (S_DD_TAC_TIPO_ACTUACION.nextval, 'DEL','Borrado logico', 'Borrado logico', 'DD', sysdate, 1);

UPDATE DD_TPO_TIPO_PROCEDIMIENTO set  DD_TAC_ID = (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO ='DEL') where dd_tpo_codigo = 'P28';

UPDATE DD_TPO_TIPO_PROCEDIMIENTO set  DD_TPO_DESCRIPCION = 'P. solicitud de concurso necesario', DD_TPO_DESCRIPCION_LARGA = 'P. solicitud de concurso necesario'  where dd_tpo_codigo = 'P55';
UPDATE DD_TPO_TIPO_PROCEDIMIENTO set  DD_TPO_DESCRIPCION = 'T. de aceptación y decisión', DD_TPO_DESCRIPCION_LARGA = 'T. de aceptación y decisión'  where dd_tpo_codigo = 'P61';

-- opciones de cancelación
-------------------------------------------------------------------------------------------------------------

update TAP_TAREA_PROCEDIMIENTO SET TAP_ALERT_VUELTA_ATRAS = 'tareaExterna.cancelarTarea' where TAP_CODIGO = 'P29_registrarResolucionOposicion';

-- activar concursal
-------------------------------------------------------------------------------------------------------------

update DD_TAC_TIPO_ACTUACION set borrado = 0 where DD_TAC_CODIGO='CO';

-- modificaciones Fase común abreviado ----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Haya discrepancia o no en los cr&'||'eacute;ditos insinuados, deber&'||'aacute;n cumplimentar los valores finales para la posterior presentaci&'||'oacute;n en el juzgado, por tanto, antes de rellenar esta pantalla deber&'||'aacute; ir a la pestaña &'||'quot;Fase com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a la insinuaci&'||'oacute;n de los cr&'||'eacute;ditos para lo que deber&'||'aacute; introducir cuantías en los campos &'||'quot;Finales&'||'quot;.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados con cuantías en los campos &'||'quot;Finales&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Presentar escrito de insinuaci&'||'oacute;n de cr&'||'eacute;dito&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarInsinuacionCreditosDef');

update TAP_TAREA_PROCEDIMIENTO tap set tap.tap_descripcion = 'Registrar insinuación de créditos a presentar' 
where tap.tap_codigo = 'P23_registrarInsinuacionCreditosDef';

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos en el juzgado, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de cuant&'||'iacute;as en las columnas &'||'quot;Finales&'||'quot; y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar informe administraci&'||'oacute;n concursal&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos');

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de recepci&'||'oacute;n del informe de administraci&'||'oacute;n concursal en respuesta a nuestra presentaci&'||'oacute;n de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que los cr&'||'eacute;ditos insinuados en la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; disponen de cuant&'||'iacute;as finales y que se encuentran en estado &'||'quot;3. Pendiente Revisión IAC&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Revisar resultado informe administraci&'||'oacute;n&'||'quot; a rellenar por parte del supervisor.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_informeAdministracionConcursal');

update TAP_TAREA_PROCEDIMIENTO tap set tap.tap_supervisor = 0 
where tap.tap_codigo = 'P23_revisarResultadoInfAdmon';

update DD_PTP_PLAZOS_TAREAS_PLAZAS set DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P23_registrarPublicacionBOE''][''fecha'']) + 90*24*60*60*1000L'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_presentarEscritoInsinuacionCreditos');

-- Actualizar estado creditos insinuados
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_actualizarEstadoCreditos', 0, 'Actualizar estado de los créditos insinuados', 
'creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos''', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_actualizarEstadoCreditos'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_actualizarEstadoCreditos'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deber&'||'aacute; actualizar el estado de los cr&'||'eacute;ditos insinuados en la pestaña "Fase com&'||'uacute;n" de la ficha del Asunto correspondiente a valor &'||'quot;6. Definitivo&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar resoluci&'||'oacute;n finalizaci&'||'oacute;n fase com&'||'uacute;n&'||'quot;.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_actualizarEstadoCreditos'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Registrar fin fase convenio
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION,  VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_registrarFinFaseComun', 0, 'Registrar resolución finalizacación fase común', 
'valores[''P23_registrarFinFaseComun''][''comboLiquidacion''] == DDSiNo.SI ? ''faseLiquidacion'' : ''faseConvenio''',
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarFinFaseComun'), '180*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarFinFaseComun'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea deber&'||'aacute; completarla en el momento que tenga constancia del fin de la fase com&'||'uacute;n e inicio de la siguiente fase.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute; la Fase de liquidaci&'||'oacute;n en caso de que lo haya indicado as&'||'iacute;, en caso contrario se inciar&'||'aacute; la Fase de convenio.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarFinFaseComun'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarFinFaseComun'), 2, 'combo', 'comboLiquidacion', 'Fase de liquidación', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_registrarFinFaseComun'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- actualizar instrucciones P23_revisarResultadoInfAdmon
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones a nuestra propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que el estado de los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n es, en caso de presentar alegaciones &'||'quot;4. Pendiente de demanda incidental&'||'quot; o en caso contrario &'||'quot;6. Definitivo&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea en caso de no presentar alegaciones ser&'||'aacute; &'||'quot;Registrar resoluci&'||'oacute;n de finalizaci&'||'oacute;n fase comun&'||'quot; y en caso de haberse presentado se inciará el tr&'||'aacute;mite de demanda incidental.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_revisarResultadoInfAdmon');

--BPM Fase convenio
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_BPMTramiteFaseConvenio', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P29'), 0, 'Se inicia la Fase de convenio', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_BPMTramiteFaseConvenio'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_BPMTramiteFaseConvenio'), 0, 'label', 'titulo', 'Se inicia la Fase de convenio', 0, 'DD', SYSDATE, 0);

--BPM Fase liquidacion
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 'P23_BPMTramiteFaseLiquidacion', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P31'), 0, 'Se inicia la Fase de liquidación', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_BPMTramiteFaseLiquidacion'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P23_BPMTramiteFaseLiquidacion'), 0, 'label', 'titulo', 'Se inicia la Fase de liquidación', 0, 'DD', SYSDATE, 0);


-- modificaciones Fase común ordinario  ----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Haya discrepancia o no en los cr&'||'eacute;ditos insinuados, deber&'||'aacute;n cumplimentar los valores finales para la posterior presentaci&'||'oacute;n en el juzgado, por tanto, antes de rellenar esta pantalla deber&'||'aacute; ir a la pestaña &'||'quot;Fase com&'||'uacute;n&'||'quot; de la ficha del asunto correspondiente y proceder a la insinuaci&'||'oacute;n de los cr&'||'eacute;ditos para lo que deber&'||'aacute; introducir cuantías en los campos &'||'quot;Finales&'||'quot;.</p><p style="margin-bottom: 10px">En la presente pantalla debe indicar el n&'||'uacute;mero de cr&'||'eacute;ditos insinuados con cuantías en los campos &'||'quot;Finales&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Presentar escrito de insinuaci&'||'oacute;n de cr&'||'eacute;dito&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarInsinuacionCreditosDef');

update TAP_TAREA_PROCEDIMIENTO tap set tap.tap_descripcion = 'Registrar insinuación de créditos a presentar' 
where tap.tap_codigo = 'P24_registrarInsinuacionCreditosDef';

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de presentaci&'||'oacute;n de la propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos en el juzgado, al pulsar Aceptar el sistema comprobar&'||'aacute; que todos los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n disponen de cuant&'||'iacute;as en las columnas &'||'quot;Finales&'||'quot; y que se encuentran en estado &'||'quot;2. insinuado&'||'quot;.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar informe administraci&'||'oacute;n concursal&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos');

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar la fecha de recepci&'||'oacute;n del informe de administraci&'||'oacute;n concursal en respuesta a nuestra presentaci&'||'oacute;n de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que los cr&'||'eacute;ditos insinuados en la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; disponen de cuant&'||'iacute;as finales y que se encuentran en estado &'||'quot;3. Pendiente Revisión IAC&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Revisar resultado informe administraci&'||'oacute;n&'||'quot; a rellenar por parte del supervisor.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_informeAdministracionConcursal');

update TAP_TAREA_PROCEDIMIENTO tap set tap.tap_supervisor = 0 
where tap.tap_codigo = 'P24_revisarResultadoInfAdmon';

update DD_PTP_PLAZOS_TAREAS_PLAZAS set DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 90*24*60*60*1000L'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_presentarEscritoInsinuacionCreditos');

-- Actualizar estado creditos insinuados
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_actualizarEstadoCreditos', 0, 'Actualizar estado de los créditos insinuados', 
'creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos''', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_actualizarEstadoCreditos'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_actualizarEstadoCreditos'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deber&'||'aacute; actualizar el estado de los cr&'||'eacute;ditos insinuados en la pestaña "Fase com&'||'uacute;n" de la ficha del Asunto correspondiente a valor &'||'quot;6. Definitivo&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Registrar resoluci&'||'oacute;n finalizaci&'||'oacute;n fase com&'||'uacute;n&'||'quot;.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_actualizarEstadoCreditos'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Registrar fin fase convenio
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_registrarFinFaseComun', 0, 'Registrar resolución finalizacación fase común', 
'valores[''P24_registrarFinFaseComun''][''comboLiquidacion''] == DDSiNo.SI ? ''faseLiquidacion'' : ''faseConvenio''',
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarFinFaseComun'), '180*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarFinFaseComun'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea deber&'||'aacute; completarla en el momento que tenga constancia del fin de la fase com&'||'uacute;n e inicio de la siguiente fase.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute; la Fase de liquidaci&'||'oacute;n en caso de que lo haya indicado as&'||'iacute;, en caso contrario se inciar&'||'aacute; la Fase de convenio.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarFinFaseComun'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarFinFaseComun'), 2, 'combo', 'comboLiquidacion', 'Fase de liquidación', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_registrarFinFaseComun'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- actualizar instrucciones P24_revisarResultadoInfAdmon
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debe indicar si se presentan alegaciones a nuestra propuesta de insinuaci&'||'oacute;n de cr&'||'eacute;ditos, al pulsar Aceptar el sistema comprobar&'||'aacute; que el estado de los cr&'||'eacute;ditos insinuados en la pestaña Fase Com&'||'uacute;n es, en caso de presentar alegaciones &'||'quot;4. Pendiente de demanda incidental&'||'quot; o en caso contrario &'||'quot;6. Definitivo&'||'quot;. Para ello debe abrir el asunto correspondiente, ir a la pestaña &'||'quot;Fase Com&'||'uacute;n&'||'quot; y abrir la ficha de cada uno de los cr&'||'eacute;ditos insinuados y cambiar su estado.<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea en caso de no presentar alegaciones ser&'||'aacute; &'||'quot;Registrar resoluci&'||'oacute;n de finalizaci&'||'oacute;n fase comun&'||'quot; y en caso de haberse presentado se inciará el tr&'||'aacute;mite de demanda incidental.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_revisarResultadoInfAdmon');

--BPM Fase convenio
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_BPMTramiteFaseConvenio', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P29'), 0, 'Se inicia la Fase de convenio', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_BPMTramiteFaseConvenio'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_BPMTramiteFaseConvenio'), 0, 'label', 'titulo', 'Se inicia la Fase de convenio', 0, 'DD', SYSDATE, 0);

--BPM Fase liquidacion
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 'P24_BPMTramiteFaseLiquidacion', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P31'), 0, 'Se inicia la Fase de liquidación', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_BPMTramiteFaseLiquidacion'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P24_BPMTramiteFaseLiquidacion'), 0, 'label', 'titulo', 'Se inicia la Fase de liquidación', 0, 'DD', SYSDATE, 0);

-- modificaciones Solicitud concursal  ----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

update DD_PTP_PLAZOS_TAREAS_PLAZAS set DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P22_registrarOposicion''][''fechaVista''])'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P22_RegistrarVista');

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se deber&'||'aacute; de consignar la fecha de notificaci&'||'oacute;n de la Resoluci&'||'oacute;n que hubiere reca&'||'iacute;do como consecuencia de la vista celebrada.</p><p style="margin-bottom: 10px">Se indicar&'||'aacute; si el resultado de dicha resoluci&'||'oacute;n ha sido favorable para los intereses de la entidad o no.</p><p style="margin-bottom: 10px">Para el supuesto de que la resoluci&'||'oacute;n no fuere favorable para la entidad, deber&'||'aacute; comunicar dicha circunstancia al responsable interno de la misma a traves del bot&'||'oacute;n &'||'quot;Comunicaci&'||'oacute;n&'||'quot;. Una vez reciba la aceptación del supervisor deber&'||'aacute; gestionar el recurso por medio de la pestaña &'||'quot;Recursos&'||'quot; donde deber&'||'aacute; indicar a trav&'||'eacute;s del campo &'||'quot;Suspensivo&'||'quot; si tiene efectos suspensivos o no el recurso, en caso de ser suspensivo se paralizar&'||'aacute; el procedimiento y en caso contrario no.</p><p style="margin-bottom: 10px">Para el supuesto de anuncio del recurso por la parte contraria se deber&'||'aacute; gestionar directamente a trav&'||'eacute;s de la pestaña &'||'quot;Recursos&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Resoluci&'||'oacute;n firme&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P22_RegistrarResolucion');

-- modificaciones Demanda incidental  ----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

update TAP_TAREA_PROCEDIMIENTO tap set tap.TAP_ALERT_VUELTA_ATRAS = 'tareaExterna.cancelarTarea'
where tap.tap_codigo = 'P25_registrarVista';

update DD_PTP_PLAZOS_TAREAS_PLAZAS set DD_PTP_PLAZO_SCRIPT = 'valores[''P25_registrarVista''] == null ? 30*24*60*60*1000L : damePlazo(valores[''P25_registrarVista''][''fecha'']) + 30*24*60*60*1000L'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_RegistrarResolucion');

update DD_PTP_PLAZOS_TAREAS_PLAZAS set DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P25_RegistrarResolucion''][''fecha'']) + 10*24*60*60*1000L'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_resolucionFirme');

update TAP_TAREA_PROCEDIMIENTO set TAP_SCRIPT_VALIDACION_JBPM = '( ((valores[''P25_confirmarOposicionYVista''][''comboOposicion''] == DDSiNo.SI) &&'||' (valores[''P25_confirmarOposicionYVista''][''fechaOposicion''] == '''')) || ((valores[''P25_confirmarOposicionYVista''][''comboVista''] == DDSiNo.SI) &&'||' (valores[''P25_confirmarOposicionYVista''][''fechaVista''] == '''')) || ((valores[''P25_confirmarOposicionYVista''][''comboAllanamiento''] == DDSiNo.SI) &&'||' (valores[''P25_confirmarOposicionYVista''][''fechaAllanamiento''] == '''')))?''tareaExterna.error.faltaAlgunaFecha'':null'
where TAP_CODIGO = 'P25_confirmarOposicionYVista';
update TFI_TAREAS_FORM_ITEMS set tfi_orden = 7 where tfi_orden = 5 and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista');
update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez interpuesta la demanda y admitida, en esta pantalla ha de indicar si se ha producido oposici&'||'oacute;n a la demanda, si se ha señalado vista y si se ha producido allanamiento.</p><p style="margin-bottom: 10px">En el supuesto de que exista oposici&'||'oacute;n, vista o allanmiento de la parte demandada, deber&'||'aacute; consignar su fecha de notificaci&'||'oacute;n correspondiente.</p><p style="margin-bottom: 10px">Para el supuesto de que haya mas de un demandado y alguno de ellos se oponga a la demanda y otros se allanen a la misma, se deberá consignar dicha circunstancia en el campo observaciones.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si no hay vista &'||'quot;Registrar resoluci&'||'oacute;n&'||'quot;.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de que haya señalamiento de vista &'||'quot;Registrar vista&'||'quot;.</li></ul></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista');
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista'), 5, 'combo', 'comboAllanamiento', 'Allanamiento', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P25_confirmarOposicionYVista'), 6, 'date', 'fechaAllanamiento', 'Fecha allanamiento', '', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

-- modificaciones Fase convenio  ----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

update TFI_TAREAS_FORM_ITEMS set TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En el primer campo ind&'||'iacute;quese si se quiere que el gestor registre una propuesta de convenio de la propia entidad, en el segundo campo ind&'||'iacute;quese si se quiere realizar un seguimiento de los convenios propuestos por terceros que puedan surgir durante la fase convenio. Si ya hubiere Convenio propio de la entidad registrado o adhesión a otro convenio propio o presentado por otros, no se deberán registrar mas convenio.</p><p style="margin-bottom: 10px">En caso de que no quiera registrar un convenio propio en estos momentos, puede hacerlo cuando quiera hasta la fecha h&'||'aacute;bil por medio del &'||'quot;Tr&'||'aacute;mite de presentaci&'||'oacute;n propuesta de convenio&'||'quot; que le guiar&'||'aacute; para dar de alta el convenio propio en la pestaña &'||'quot;Convenios&'||'quot; de la ficha del asunto correspondiente.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se iniciar&'||'aacute; una tarea por cada una de las decisiones tomadas, en el caso de querer registrar un convenio propio se iniciar&'||'aacute; un &'||'quot;Tr&'||'aacute;mite presentaci&'||'oacute;n de propuesta de convenio propia&'||'quot; y en el caso de querer hacer un seguimiento sobre otras propuestas se crear&'||'aacute; la tarea &'||'quot;Dictar instrucciones junta acreedores&'||'quot;.</p></div>'
where TFI_TIPO = 'label' and TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_decidirSobreFaseComun');

update DD_PTP_PLAZOS_TAREAS_PLAZAS set DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 5*24*60*60*1000L'
where TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P29_dictarInstrucciones');


-- modificaciones Aceptación y Decisión ---------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------

-- actualizar tarea decision
update TAP_TAREA_PROCEDIMIENTO set 
TAP_SCRIPT_DECISION = '(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P01'') ? ''hipotecario'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P02'') ? ''monitorio'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P03'') ? ''ordinario'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P17'') ? ''cambiario'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P32'') ? ''abreviado'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P16'') ? ''etj'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P15'') ? ''etnj'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P04'') ? ''verbal'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P24'') ? ''fcOrdinario'' : (
 (valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P56'') ? ''fcAbreviado'' :null)))))))))'
where TAP_CODIGO = 'P61_registrarDecisionProcedimiento';

-- BPM FAse común ordinario
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P61'), 'P61_BPMFaseComunOrdinario', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P24'), 0, 'Se inicia Fase común ordinario', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P61_BPMFaseComunOrdinario'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P61_BPMFaseComunOrdinario'), 0, 'label', 'titulo', 'Se inicia Fase común ordinario', 0, 'DD', SYSDATE, 0);


-- BPM Fase común abreviado
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P61'), 'P61_BPMFaseComunAbreviado', (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P56'), 0, 'Se inicia Fase común abreviado', 0, 'DD', SYSDATE, 0, (select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='01'), 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P61_BPMFaseComunAbreviado'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P61_BPMFaseComunAbreviado'), 0, 'label', 'titulo', 'Se inicia Fase común abreviado', 0, 'DD', SYSDATE, 0);


