-- *************************************************************************** --
-- **                  INSERTS EN DD_TPO_TIPO_PROCEDIMIENTO	                ** --
-- *************************************************************************** --

-- Procedimiento abreviado
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P99', 'P. Historico 0', 'P. Historico 0', '', 'procedimientoHistorico_0', 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P98', 'P. Historico 15', 'P. Historico 15', '', 'procedimientoHistorico_15', 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P97', 'P. Historico 30', 'P. Historico 30', '', 'procedimientoHistorico_30', 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P96', 'P. Historico 45', 'P. Historico 45', '', 'procedimientoHistorico_45', 0, 'DD', SYSDATE, 0);

-- insertar la correspondiente tarea a cada uno de los tramites

--P98
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P98'), 'P98_espera', 0, 'Tarea de espera', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P98_espera'), '15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P98_espera'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea le otorga 15 d&'||'iacute;as desde la implantaci&'||'oacute;n de la herramienta para indicar la actuaci&'||'oacute;n en la que se encuentra este procedimiento. Recuerde utilizar la pestaña &'||'quot;Decisi&'||'oacute;n&'||'quot; para introducir el tipo de actuaci&'||'oacute;n, procedimiento o tr&'||'aacute;mite en el que se encuentra en este momento y propon&'||'eacute;rselo a su supervisor. En caso de duda, por favor p&'||'oacute;ngase en contacto con &'||'eacute;l.  Cuando el supervisor acepte su propuesta recibir&'||'aacute; la primera tarea del grupo de tareas que componen la actuaci&'||'oacute;n. Tendr&'||'aacute; que rellenar las tareas previas al punto exacto en el que se encuentra.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P98_espera'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--P97
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P97'), 'P97_espera', 0, 'Tarea de espera', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P97_espera'), '30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P97_espera'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea le otorga 30 d&'||'iacute;as desde la implantaci&'||'oacute;n de la herramienta para indicar la actuaci&'||'oacute;n en la que se encuentra este procedimiento. Recuerde utilizar la pestaña &'||'quot;Decisi&'||'oacute;n&'||'quot; para introducir el tipo de actuaci&'||'oacute;n, procedimiento o tr&'||'aacute;mite en el que se encuentra en este momento y propon&'||'eacute;rselo a su supervisor. En caso de duda, por favor p&'||'oacute;ngase en contacto con &'||'eacute;l.  Cuando el supervisor acepte su propuesta recibir&'||'aacute; la primera tarea del grupo de tareas que componen la actuaci&'||'oacute;n. Tendr&'||'aacute; que rellenar las tareas previas al punto exacto en el que se encuentra.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P97_espera'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--P96
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P96'), 'P96_espera', 0, 'Tarea de espera', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P96_espera'), '45*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P96_espera'), 0, 'label', 'titulo', 
'<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Esta tarea le otorga 45 d&'||'iacute;as desde la implantaci&'||'oacute;n de la herramienta para indicar la actuaci&'||'oacute;n en la que se encuentra este procedimiento. Recuerde utilizar la pestaña &'||'quot;Decisi&'||'oacute;n&'||'quot; para introducir el tipo de actuaci&'||'oacute;n, procedimiento o tr&'||'aacute;mite en el que se encuentra en este momento y propon&'||'eacute;rselo a su supervisor. En caso de duda, por favor p&'||'oacute;ngase en contacto con &'||'eacute;l.  Cuando el supervisor acepte su propuesta recibir&'||'aacute; la primera tarea del grupo de tareas que componen la actuaci&'||'oacute;n. Tendr&'||'aacute; que rellenar las tareas previas al punto exacto en el que se encuentra.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto del procedimiento.</p></div>'
, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P96_espera'), 1, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);
