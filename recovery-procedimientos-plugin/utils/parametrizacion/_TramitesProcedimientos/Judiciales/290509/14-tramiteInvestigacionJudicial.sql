-- *************************************************************************** --
-- **                  BPM Trámite de investigación judicial                ** --
-- *************************************************************************** --

-- Pantalla 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P20'), 'P20_SolicitudInvestigacionJudicial', 0, 'Escrito de solicitud investigación judicial', 0, 'DD', SYSDATE, 0);

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_SolicitudInvestigacionJudicial'), '2*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_SolicitudInvestigacionJudicial'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla debemos de consignar la fecha que se presenta en el Juzgado escrito solicitando averiguaci&'||'oacute;n de la solvencia de los ejecutados, con su identificaci&'||'oacute;n y oficios que se han de enviar para la averiguaci&'||'oacute;n de los bienes que se interese.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_SolicitudInvestigacionJudicial'), 1, 'date', 'fechaSolicitud', 'Fecha solicitud', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_SolicitudInvestigacionJudicial'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P20'), 'P20_RegistrarResultadoInvestigacion', 0, 'Registrar resultado de investigación',
'valores[''P20_RegistrarResultadoInvestigacion''][''comboRegistro''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
'((valores[''P20_RegistrarResultadoInvestigacion''][''comboRegistro''] == DDPositivoNegativo.POSITIVO) &&'||' (valores[''P20_RegistrarResultadoInvestigacion''][''comboAgTribut''] == '''') &&'||' (valores[''P20_RegistrarResultadoInvestigacion''][''comboSegSocial''] == '''') &&'||' (valores[''P20_RegistrarResultadoInvestigacion''][''comboCatastro''] == '''') &&'||' (valores[''P20_RegistrarResultadoInvestigacion''][''comboAyto''] == '''') &&'||' (valores[''P20_RegistrarResultadoInvestigacion''][''comboOtros''] == '''') )?''tareaExterna.error.P20_RegistrarImpugnacion.algunComboObligatorio'':null',
0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), '90*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que hemos solicitado anteriormente la averiguaci&'||'oacute;n de la solvencia del ejecutado, en esta pantalla se persigue la identificaci&'||'oacute;n del resultado de la misma, debi&'||'eacute;ndose consignar en cada campo lo que proceda en virtud del resultado obtenido en funci&'||'oacute;n de la contestaci&'||'oacute;n de cada uno de los organismos que se señalan en los diferentes campos que se ofrecen, o bien indicar en el campo de &'||'quot;otros&'||'quot; el resultado de la meritada gesti&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento. En el presente caso en el campo observaciones se deber&'||'aacute; identificar el resultado positivo si se hubiere marcado alguno de ellos, ya sean bienes inmuebles,muebles,salarios,etc.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', SYSDATE, 0, 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 2, 'combo', 'comboRegistro', 'Resultado', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0, 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 3, 'combo', 'comboAgTribut', 'Agencia tributaria', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 4, 'combo', 'comboSegSocial', 'Seg. social', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 5, 'combo', 'comboCatastro', 'Catastro', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 6, 'combo', 'comboAyto', 'Ayuntamiento', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 7, 'combo', 'comboOtros', 'Otros', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 8, 'currency', 'solvencia', 'Solvencia encontrada', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 9, 'currency', 'impuestos', 'Ingresos encontrados', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RegistrarResultadoInvestigacion'), 10, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

-- Pantalla 3
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, TAP_VIEW, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P20'), 'P20_RevisarInvestigacionYActualizacionDatos', 1, 'Revisar resultado investigación y actualización de datos',
'pfsgroup/investigacionJudicial/revisarInvestigacion', 0, 'DD', SYSDATE, 0, 'tareaExterna.cancelarTarea');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), '2*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 0, 'label', 'titulo', '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla el gestor externo nos ha marcado el resultado positivo de la averiguaci&'||'oacute;n de bienes solicitada al Juzgado, se deber&'||'aacute; marcar &'||'uacute;nicamente la fecha de recepci&'||'oacute;n de dicha infomaci&'||'oacute;n, respecto de la cual el gestor interno deber&'||'aacute; actualizar solvencia y adoptar la decisi&'||'oacute;n pertinente.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 2, 'combo', 'comboRegistro', 'Resultado', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 3, 'combo', 'comboAgTribut', 'Agencia tributaria', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 4, 'combo', 'comboSegSocial', 'Seg. social', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 5, 'combo', 'comboCatastro', 'Catastro', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 6, 'combo', 'comboAyto', 'Ayuntamiento', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 7, 'combo', 'comboOtros', 'Otros', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 8, 'currency', 'solvencia', 'Solvencia encontrada', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 9, 'currency', 'impuestos', 'Ingresos encontrados', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P20_RevisarInvestigacionYActualizacionDatos'), 10, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);