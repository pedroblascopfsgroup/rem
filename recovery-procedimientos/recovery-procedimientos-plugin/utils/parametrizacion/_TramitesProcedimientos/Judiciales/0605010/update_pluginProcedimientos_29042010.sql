-- *************************************************************************** --
-- ** Actualización necesaria para requisitos Ciudad Real 06/05/2010   		 * --			  
-- *************************************************************************** --

-- insertar nuevos tipos de bien
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'DEVOLUCIÓN DE IRPF', 'DEVOLUCIÓN DE IRPF', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'CRÉDITOS A TERCEROS', 'CRÉDITOS A TERCEROS', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'SOBRANTES EN OTROS PROC.', 'SOBRANTES EN OTROS PROC.', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'SUBVENCIONES PAC', 'SUBVENCIONES PAC', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'FINCAS CATASTRADAS', 'FINCAS CATASTRADAS', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'SALDOS EN CUENTA, DEPOSITO, IPF, FONDOS ...', 'SALDOS EN CUENTA, DEPOSITO, IPF, FONDOS ...', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'DEVOLUCIONES DE IVA', 'DEVOLUCIONES DE IVA', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'DEVOLUCIONES DE IMPUESTOS SOBRE SOCIEDADES', 'DEVOLUCIONES DE IMPUESTOS SOBRE SOCIEDADES', 0, 'DD', SYSDATE, 0);
INSERT INTO DD_TBI_TIPO_BIEN (DD_TBI_ID, DD_TBI_CODIGO, DD_TBI_DESCRIPCION, DD_TBI_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (S_DD_TBI_TIPO_BIEN.nextval, (SELECT MAX(DD_TBI_CODIGO)+1 FROM DD_TBI_TIPO_BIEN), 'OTRAS SUBVENCIONES', 'OTRAS SUBVENCIONES', 0, 'DD', SYSDATE, 0);


-- *************************************************************************** --
-- **                   Actualizar la tarea Solicitud de subasta             * --
-- ** y la tarea Anuncio subasta para que no exiga en la primera las    	 * --
-- **  mirutas y si en la segunda  + OJO = P11_AnuncioSubasta_new1	   		 * --			  
-- *************************************************************************** --

-- solicitud de subasta

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALIDACION = '', TFI_ERROR_VALIDACION = ''
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_SolicitudSubasta') AND
		TFI_NOMBRE = 'costasLetrado';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALIDACION = '', TFI_ERROR_VALIDACION = ''
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_SolicitudSubasta') AND
		TFI_NOMBRE = 'costasProcurador';

-- Anuncio de subasta

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = 5
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta') AND
		TFI_NOMBRE = 'observaciones';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta'), 3, 'currency', 'costasLetrado', 'Costas letrado', 'valores[''P11_SolicitudSubasta''][''costasLetrado'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta'), 4, 'currency', 'costasProcurador', 'Costas procurador', 'valores[''P11_SolicitudSubasta''][''costasProcurador'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = 6
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1') AND
		TFI_NOMBRE = 'observaciones';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 4, 'currency', 'costasLetrado', 'Costas letrado', 'valores[''P11_SolicitudSubasta''][''costasLetrado'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 5, 'currency', 'costasProcurador', 'Costas procurador', 'valores[''P11_SolicitudSubasta''][''costasProcurador'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


-- Dictar instrucciones

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALOR_INICIAL = ' valores[''P11_AnuncioSubasta''] == null ? (valores[''P11_AnuncioSubasta_new1''][''costasLetrado''] == null ? valores[''P11_SolicitudSubasta''][''costasLetrado''] : valores[''P11_AnuncioSubasta_new1''][''costasLetrado'']) : (valores[''P11_AnuncioSubasta''][''costasLetrado''] == null ? valores[''P11_SolicitudSubasta''][''costasLetrado''] : valores[''P11_AnuncioSubasta''][''costasLetrado'']) '
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones') AND
		TFI_NOMBRE = 'costasLetrado';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALOR_INICIAL = ' valores[''P11_AnuncioSubasta''] == null ? (valores[''P11_AnuncioSubasta_new1''][''costasProcurador''] == null ? valores[''P11_SolicitudSubasta''][''costasProcurador''] : valores[''P11_AnuncioSubasta_new1''][''costasProcurador'']) : (valores[''P11_AnuncioSubasta''][''costasProcurador''] == null ? valores[''P11_SolicitudSubasta''][''costasProcurador''] : valores[''P11_AnuncioSubasta''][''costasProcurador'']) '
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones') AND
		TFI_NOMBRE = 'costasProcurador';
		

-- *************************************************************************** --
-- **                   BPM Vigilancia caducidad anotaciones de embargo     ** --
-- *************************************************************************** --

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P60', 'Vigilancia caducidad anotaciones de embargo', 'Vigilancia caducidad anotaciones de embargo', '', 'vigilanciaCaducidadAnotacion', 0, 'DD', SYSDATE, 0);

--Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 'P60_RegistrarAnotacion', 'isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p></div>o'' : null', 
'valores[''P60_RegistrarAnotacion''][''repetir''] == DDSiNo.SI ? ''repite'' : ''avanzaBPM''', 0, 'Confirmar anotación en el registro', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de consignar la fecha de anotaci&'||'oacute;n de los embargos trabados en el Registro de la Propiedad correspondiente.</p><p style="margin-bottom: 10px">Para el supuesto de la existencia de embargo de varios bienes y que estos se encuentren inscritos en diferentes Registros de la Propiedad, se deber&'||'aacute; consignar en esta pantalla &'||'uacute;nicamente el de la anotaci&'||'oacute;n del primero de ellos. Se deber&'||'aacute; abrir la pestaña de &'||'quot;Bienes&'||'quot; para introducir la fecha de anotaci&'||'oacute;n en el Registro de la Propiedad de cada uno de los bienes embargados.</p><p style="margin-bottom: 10px">El siguiente campo deber&'||'aacute; de mantenerse como afirmativo siempre que existan bienes no apremiados por la entidad, lo que permitir&'||'aacute; que la herramienta nos genere una alerta para solicitar la pr&'||'oacute;rroga de la anotaci&'||'oacute;n de los embargos en el Registro.</p><p style="margin-bottom: 10px">En el caso de que no se haya admitido el registro de alguno de los embargos solicitados, cons&'||'iacute;gnelo en observaciones y si el resultado es, no haber conseguido registrar ning&'||'uacute;n embargo complete el campo de &'||'quot;Activar alerta peri&'||'oacute;dica&'||'quot; como negativo.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 2, 'combo', 'repetir', 'Activar alerta periódica', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RegistrarAnotacion'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 2

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 'P60_RevisarRegistroDeEmbargo', 0, 'Revisar registro de embargo', 
'valores[''P60_RevisarRegistroDeEmbargo''][''repetir''] == DDSiNo.SI ? ''recordatorio'' : ''terminar''', 
0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), '23*7*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para completar esta tarea deber&'||'aacute; acceder a la pesta&'||'ntilde;a &'||'quot;Bienes&'||'quot; de este procedimiento, donde puede encontrar los datos sobre los distintos embargos registrados y que deben ser revisados en este momento.</p><p style="margin-bottom: 10px">Introduzca la fecha en la que se efectua la solicitud de renovaci&'||'oacute;n en el campo &'||'quot;Fecha&'||'quot; y la fecha en la que queda renovado cada bien en el campo correspondiente de la pesta&'||'ntilde;a &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">En caso de no quedar ning&'||'uacute;n embargo anotado tras esta tarea, indique &'||'quot;No&'||'quot; en el campo &'||'quot;Mantener alerta de caducidad&'||'quot; o &'||'quot;Si&'||'quot; en caso contrario.</p><p style="margin-bottom: 10px"><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>', 0, 'DD', SYSDATE, 0); 
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 2, 'combo', 'repetir', 'Mantener alerta de caducidad', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P60_RevisarRegistroDeEmbargo'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);



-- *************************************************************************** --
-- **                   Actualizar CAMBIARIO					             * --
-- ** y la tarea Anuncio subasta para que no exiga en la primera las    	 * --
-- **  mirutas y si en la segunda  + OJO = P11_AnuncioSubasta_new1	   		 * --			  
-- *************************************************************************** --

--Pantalla 2

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_VIEW, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P17'), 'P17_CnfAdmiDemaDecretoEmbargo_new1', 0, 'Confirmar admisión + marcado bienes decreto embargo', 
'valores[''P17_CnfAdmiDemaDecretoEmbargo_new1''][''comboAdmisionDemanda''] == DDSiNo.SI ? ( valores[''P17_CnfAdmiDemaDecretoEmbargo_new1''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''', 
'plugin/procedimientos/procedimientoCambiario/confirmarAdmisionDemanda', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 'damePlazo(valores[''P17_InterposicionDemandaMasBienes''][''fechaDemanda'']) + 20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&'||'iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&'||'oacute;n, el juzgado en el que ha reca&'||'iacute;do la demanda y el n&'||'uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pestaña de &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no as&'||'iacute; como indicar si existen bienes registrables o no, lo que supondr&'||'aacute;, seg&'||'uacute;n su contestaci&'||'oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido admitida a tr&'||'aacute;mite la demanda &'||'quot;Confirmar notificaci&'||'oacute;n del requerimiento de pago&'||'quot; al ejecutado y la actuaci&'||'oacute;n &'||'quot;Vigilancia caducidad anotaciones de embargo&'||'quot; si adem&'||'aacute;s indica que existen bienes registrables en el registro. Si no ha sido admitida la demanda se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 2, 'combo', 'comboPlaza', 'Plaza del juzgado', 'TipoPlaza', 'damePlaza()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 3, 'combo', 'numJuzgado', 'Nº Juzgado', 'TipoJuzgado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumJuzgado()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 4, 'textproc', 'numProcedimiento', 'Nº de procedimiento', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumAuto()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 5, 'combo', 'comboAdmisionDemanda', 'Admisión', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 6, 'combo', 'comboBienesRegistrables', 'Existen bienes registrables', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo_new1'), 7, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);


UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'valores[''P17_CnfAdmiDemaDecretoEmbargo''] == null ? (damePlazo(valores[''P17_CnfAdmiDemaDecretoEmbargo_new1''][''fecha'']) + 30*24*60*60*1000L) : (damePlazo(valores[''P17_CnfAdmiDemaDecretoEmbargo''][''fecha'']) + 30*24*60*60*1000L)'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfNotifRequerimientoPago');

-- nueva tarea BPM
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P17'), 'P17_BPMVigilanciaCaducidadAnotacion',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 0, 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_BPMVigilanciaCaducidadAnotacion'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_BPMVigilanciaCaducidadAnotacion'), 0, 'label', 'titulo', 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);

-- *************************************************************************** --
-- **                   Actualizar T ejecución título judicial  		     * --
-- **  nueva opción para decidir si se quiere o no registrar bienes 	   	 * --
-- *************************************************************************** --

--Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P16'), 'P16_AutoDespachando_new1', 0, 'Auto Despachando ejecución + Marcado de bienes decreto embargo', 
'valores[''P16_AutoDespachando_new1''][''comboSiNo''] == DDSiNo.SI ? ( valores[''P16_AutoDespachando_new1''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''', 
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 'damePlazo(valores[''P16_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&'||'iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&'||'oacute;n, el juzgado en el que ha reca&'||'iacute;do la demanda y el n&'||'uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pestaña de &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no as&'||'iacute; como indicar si existen bienes registrables o no, lo que supondr&'||'aacute;, seg&'||'uacute;n su contestaci&'||'oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido admitida a tr&'||'aacute;mite la demanda &'||'quot;Confirmar notificaci&'||'oacute;n del requerimiento de pago&'||'quot; al ejecutado y la actuaci&'||'oacute;n &'||'quot;Vigilancia caducidad anotaciones de embargo&'||'quot; si adem&'||'aacute;s indica que existen bienes registrables en el registro. Si no ha sido admitida la demanda se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 2, 'textproc', 'nProc', 'Nº Procedimiento', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumAuto()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 3, 'combo', 'comboSiNo', 'Admisión', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 4, 'combo', 'comboBienesRegistrables', 'Existen bienes registrables', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 5, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'valores[''P16_AutoDespachando''] == null ? (damePlazo(valores[''P16_AutoDespachando_new1''][''fecha'']) + 30*24*60*60*1000L) : (damePlazo(valores[''P16_AutoDespachando''][''fecha'']) + 30*24*60*60*1000L)'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_ConfirmarNotificacion');

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P16'), 'P16_BPMVigilanciaCaducidadAnotacion',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 0, 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_BPMVigilanciaCaducidadAnotacion'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_BPMVigilanciaCaducidadAnotacion'), 0, 'label', 'titulo', 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);

-- *************************************************************************** --
-- **                   Actualizar ejecución título NO judicial	      		   * --
-- **  nueva opción para decidir si se quiere o no registrar bienes 	   	 * --
-- *************************************************************************** --

--Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_VIEW, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval,  (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P15'), 'P15_AutoDespaEjecMasDecretoEmbargo_new1', 0, 'Auto despachando ejecución + Marcado bienes decreto embargo', 
'plugin/procedimientos/ejecucionTituloNoJudicial/autoDespachandoEjecucion',
'valores[''P15_AutoDespaEjecMasDecretoEmbargo_new1''][''comboAdmisionDemanda''] == DDSiNo.SI ? ( valores[''P15_AutoDespaEjecMasDecretoEmbargo_new1''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''',
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 'damePlazo(valores[''P15_InterposicionDemandaMasBienes''][''fechaInterposicion'']) + 20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Ind&'||'iacute;quese la fecha en la que se nos notifica auto por el que se despacha ejecuci&'||'oacute;n, el juzgado en el que ha reca&'||'iacute;do la demanda y el n&'||'uacute;mero de procedimiento.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de decreto de embargo para cada uno de los bienes en los que proceda en la pestaña de &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">Se ha de indicar si la demanda interpuesta ha sido admitida o no as&'||'iacute; como indicar si existen bienes registrables o no, lo que supondr&'||'aacute;, seg&'||'uacute;n su contestaci&'||'oacute;n, que la tarea siguiente sea una u otra de las que se le indica con posterioridad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;, si ha sido admitida a tr&'||'aacute;mite la demanda &'||'quot;Confirmar notificaci&'||'oacute;n del requerimiento de pago&'||'quot; al ejecutado y la actuaci&'||'oacute;n &'||'quot;Vigilancia caducidad anotaciones de embargo&'||'quot; si adem&'||'aacute;s indica que existen bienes registrables en el registro. Si no ha sido admitida la demanda se le abrir&'||'aacute; tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 1, 'date', 'fecha', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 2, 'combo', 'comboPlaza', 'Plaza del juzgado', 'TipoPlaza', 'damePlaza()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 3, 'combo', 'numJuzgado', 'Nº Juzgado', 'TipoJuzgado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumJuzgado()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 4, 'textproc', 'numProcedimiento', 'Nº de procedimiento', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumAuto()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 5, 'combo', 'comboAdmisionDemanda', 'Admisión', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 6, 'combo', 'comboBienesRegistrables', 'Existen bienes registrables', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo_new1'), 7, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS
SET DD_PTP_PLAZO_SCRIPT = 'valores[''P15_AutoDespaEjecMasDecretoEmbargo''] == null ? (damePlazo(valores[''P15_AutoDespaEjecMasDecretoEmbargo_new1''][''fecha'']) + 30*24*60*60*1000L) : (damePlazo(valores[''P15_AutoDespaEjecMasDecretoEmbargo''][''fecha'']) + 30*24*60*60*1000L)'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_ConfirmarNotifiReqPago');

-- incidencia encontrada 
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P15') ) 
		AND TFI_NOMBRE = 'comboPlaza';

-- nueva tarea BPM
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P15'), 'P15_BPMVigilanciaCaducidadAnotacion',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 0, 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_BPMVigilanciaCaducidadAnotacion'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_BPMVigilanciaCaducidadAnotacion'), 0, 'label', 'titulo', 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);


-- *************************************************************************** --
-- **                   Actualizar MEJORA DE EMBARGO					     * --
-- ** descripciones + titulos + nuevo combo en Confirmar registro decreto  	 * --
-- ** embargo																 * --			  
-- *************************************************************************** --

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_DESCRIPCION = 'Confirmar registro decreto embargo'
WHERE 	TAP_CODIGO = 'P14_RegistroDecretoEmbargo' AND
		DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14');


Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14'), 'P14_RegistroDecretoEmbargo_new1', 0, 'Confirmar registro decreto embargo', 
'valores[''P14_RegistroDecretoEmbargo_new1''][''comboResultado''] == DDSiNo.SI ? ''si'' : ''no''', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla se ha de indicar la fecha en la que se nos notifica la  Resoluci&'||'oacute;n que ha dictado el Juzgado por la que se admite nuestra solicitud de mejora de embargo. Por otro lado indicar si existen bienes registrables y por tanto se quiere lanzar la actuaci&'||'oacute;n &'||'quot;Vigilancia caducidad anotaciones de embargo&'||'quot; para proceder a su anotaci&'||'oacute;n en el registro y posterior seguimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, si se ha indicado que existen bienes registrables se iniciar&'||'aacute; la actuaci&'||'oacute;n &'||'quot;Vigilancia caducidad anotaciones de embargo&'||'quot;. Si no hay bienes registrables se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 1, 'date', 'fechaRegistro', 'Fecha', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
INSERT INTO TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 2, 'combo', 'comboResultado', 'Existen bienes registrables', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_RegistroDecretoEmbargo_new1'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- nueva tarea BPM
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, DD_TPO_ID_BPM, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P14'), 'P14_BPMVigilanciaCaducidadAnotacion',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P60'), 0, 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_BPMVigilanciaCaducidadAnotacion'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P14_BPMVigilanciaCaducidadAnotacion'), 0, 'label', 'titulo', 'Ejecución de Vigilancia caducidad anotación de embargo', 0, 'DD', SYSDATE, 0);



-- *************************************************************************** --
-- **                   Actualizar la tarea de intereses		             * --
-- ** se quiere dar lña posibilidad de indicar si hay o no impugnación		 * --
-- ** en caso de que la haya la fecha de impugnación será obligatoria		 * --	  
-- *************************************************************************** --

-- Pantalla 6

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla, se ha de consignar si se ha producido impugnaci&'||'oacute;n o no junto a la fecha de celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">Del mismo modo consignar si se va ha producir Vista junto a la fecha de celebraci&'||'oacute;n de la misma. Para el supuesto en el que no vaya haber vista no será obligatorio consignar la fecha de celebración de la misma.</p><p style="margin-bottom: 10px">Para los supuesto en los que se señale que si que va a ver vista, la siguiente tarea sea &'||'quot;Registrar vista&'||'quot;. Para los supuestos en los que no vaya a ver vista la siguiente tarea ser&'||'aacute; toma de decisi&'||'oacute;n sobre la continuidad del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'titulo';
	  
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALIDACION = '', TFI_ERROR_VALIDACION = '', TFI_ORDEN = '2', TFI_LABEL = 'Fecha impugnación'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'fecha';
	  
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = '3'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'comboSiNo';
	  
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = '4'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'fechaVista';

	  UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = '5'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'observaciones';
	  
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion'), 1, 'combo', 'comboImpugnacion', 'Hay impuganción', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);	  

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_VALIDACION_JBPM = '((valores[''P10_RegistrarImpugnacion''][''comboImpugnacion''] == DDSiNo.SI) &&'||' (valores[''P10_RegistrarImpugnacion''][''fecha''] == '''')) ? ''tareaExterna.error.P10_RegistrarImpugnacion.fechaImpugObligatoria'': (((valores[''P10_RegistrarImpugnacion''][''comboSiNo''] == DDSiNo.SI) &&'||' (valores[''P10_RegistrarImpugnacion''][''fechaVista''] == ''''))?''tareaExterna.error.P10_RegistrarImpugnacion.fechasOblgatorias'':null)'
WHERE DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P10') AND
	  TAP_CODIGO = 'P10_RegistrarImpugnacion';
	  
-- *************************************************************************** --
-- **                   Se actualiza el campo tipo de procedimiento          * -- 
-- *************************************************************************** --

UPDATE DD_TPO_TIPO_PROCEDIMIENTO SET DD_TAC_ID = (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP')
WHERE  DD_TPO_CODIGO='P12';

UPDATE DD_TPO_TIPO_PROCEDIMIENTO SET DD_TAC_ID = (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP')
WHERE  DD_TPO_CODIGO='P13';	  
		