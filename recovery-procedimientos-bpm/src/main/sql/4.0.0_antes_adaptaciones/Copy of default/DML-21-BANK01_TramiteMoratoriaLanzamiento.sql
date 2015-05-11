SET DEFINE OFF;


	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	BEGIN
	
--Tipo procedimiento
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID,DTYPE, FLAG_UNICO_BIEN) Values(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, 'P418', 'Trámite de moratoria de lanzamiento', 'Trámite de moratoria de lanzamiento','tramiteMoratoriaLanzamiento', 0, 'DD', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'),'MEJTipoProcedimiento',1);

--Tareas
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_RegistrarSolicitudMoratoria','Registrar solicitud de moratoria',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','comprobarBienAsociadoPrc() ? null : ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>!Atenci&oacute;n! Para dar por completada esta tarea deber&aacute; vincular un bien al procedimiento.</p></div>''','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'));
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID, TAP_VIEW) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_RegistrarAdmisionYEmplazamiento','Registrar admisión y emplazamiento',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'),'plugin/procedimientos/tramiteMoratoria/registrarAdmisionYEmplazamiento');
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_RegistrarInformeMoratoria','Registar informe a moratoria',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'));
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_RevisarInformeLetradoMoratoria','Revisar informe letrado moratoria',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='SUP'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='40'));
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_LecturaInstruccionesMoratoria','Lectura de instrucciones moratoria',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','','valores[''P418_RegistrarAdmisionYEmplazamiento''][''comboVista''] == DDPositivoNegativo.POSITIVO ? ''HayVista'' : valores[''P418_RevisarInformeLetradoMoratoria''][''comboConformidad''] == DDPositivoNegativo.POSITIVO ? ''PresentarConformidad'' : ''NoHayVista''',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'));
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_PresentarConformidadMoratoria','Presentar conformidad a moratoria',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'));
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_CelebracionVista','Celebración vista',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'));
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID, TAP_VIEW) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_RegistrarResolucion','Registrar resolución',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','valores[''P418_RegistrarResolucion''][''comboFavDesf''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable''',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'),'plugin/procedimientos/tramiteMoratoria/registrarResolucion');
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_VIEW,TAP_SCRIPT_VALIDACION,TAP_SCRIPT_VALIDACION_JBPM,TAP_SCRIPT_DECISION,TAP_SUPERVISOR,TAP_ALERT_VUELTA_ATRAS,DD_FAP_ID,TAP_AUTOPRORROGA,TAP_MAX_AUTOP,DD_TGE_ID,DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 'P418_SolicitarInstrucciones','Solicitar instrucciones',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento','','','','',0,'tareaExterna.cancelarTarea',(select DD_FAP_ID from DD_FAP_FASE_PROCESAL where DD_FAP_CODIGO='05'),1,3,(select DD_TGE_ID from BANKMASTER.DD_TGE_TIPO_GESTOR where DD_TGE_CODIGO='GEXT'),(select DD_STA_ID from BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE where DD_STA_CODIGO='39'));

--timer
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SCRIPT_DECISION, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_FAP_ID, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento tpo where tpo.DD_TPO_CODIGO = 'P418'), 'P418_nodoEsperaController', 'estamosADosMeses() ? ''solicita'' : ''espera''', 0, 'Nodo espera 1', 0, 'DD', sysdate, 0, 1, 1, 'EXTTareaProcedimiento', 3, 39);


--Plazos
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarSolicitudMoratoria'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarAdmisionYEmplazamiento'), 'damePlazo(valores[''P418_RegistrarSolicitudMoratoria''][''fechaSolicitud'']) + 5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarInformeMoratoria'), 'damePlazo(valores[''P418_RegistrarAdmisionYEmplazamiento''][''fechaNotificacion'']) + 1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RevisarInformeLetradoMoratoria'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_LecturaInstruccionesMoratoria'), '1*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_PresentarConformidadMoratoria'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_CelebracionVista'), 'damePlazo(valores[''P418_RegistrarAdmisionYEmplazamiento''][''fechaSenyalamiento''])', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarResolucion'), 'damePlazo(valores[''P418_RegistrarAdmisionYEmplazamiento''][''fechaSenyalamiento''])', 0, 'DD', SYSDATE, 0);
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_SolicitarInstrucciones'), '60*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

--TFI
--P418_RegistrarSolicitudMoratoria
SET DEFINE OFF;
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarSolicitudMoratoria'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deber&aacute; de haber un bien vinculado al procedimiento, esto podr&aacute; comprobarlo a trav&eacute;s de la pesta&ntilde;a Bienes del procedimiento, en caso de no haberlo, a trav&eacute;s de esa misma pesta&ntilde;a dispone de la opci&oacute;n  de Agregar por la cual se le permite vincular un bien al procedimiento.</p>
<p>En el campo &ldquo;Fecha solicitud&rdquo; deber&aacute; de consignar la fecha en la que se haya producido la solicitud de la moratoria.</p>
<p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p>Una vez rellene &eacute;sta pantalla la siguiente tarea ser&aacute; &quot;Registrar admisi&oacute;n y emplazamiento&quot;.</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarSolicitudMoratoria'), 1, 'date', 'fechaSolicitud',  
'Fecha de solicitud','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarSolicitudMoratoria'), 2, 'date', 'fechaFinMoratoria',  
'Fecha fin de moratoria','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarSolicitudMoratoria'), 3, 'textarea', 'observaciones',  
'Observaciones', 0, 'DD', SYSDATE, 0);

--REGISTRAR INFORME MORATORIA
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarAdmisionYEmplazamiento'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; consignar la fecha de notificaci&oacute;n de la moratoria, si ha habido admisi&oacute;n o no de la solicitud de moratoria, en caso de haber, indicar si hay vista o no y por &uacute;ltimo la fecha de se&ntilde;alamiento de la misma.</p>
<p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Registrar informe moratoria&rdquo;.</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarAdmisionYEmplazamiento'), 1, 
'date', 'fechaNotificacion', 'Fecha de notificación',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarAdmisionYEmplazamiento'), 2, 
'combo', 'comboAdminEmplaza', 'Admisión y emplazamiento',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarAdmisionYEmplazamiento'), 3, 
'combo', 'comboVista', 'Vista',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarAdmisionYEmplazamiento'), 4, 
'date', 'fechaSenyalamiento', 'Fecha señalamiento',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarAdmisionYEmplazamiento'), 5, 
'textarea', 'observaciones',  
'Observaciones', 0, 'DD', SYSDATE, 0);

--P418_RegistrarInformeMoratoria
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarInformeMoratoria'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta pantalla deber&aacute; dejar constancia si la moratoria solicitada por el deudor es acorde con lo establecido por la ley y por tanto es mejor presentar el escrito de conformidad a la moratoria, o si por el contrario se aprecia disconformidad a la ley y por tanto aconseja presentarse a la vista.</p>
<p>Una vez complete esta pantalla la siguiente tarea ser&aacute; &ldquo;Revisar informe letrado moratoria&rdquo; por la cual se mostrar&aacute; su informe al supervisor de la entidad para que dicte instrucciones.</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarInformeMoratoria'), 1, 
'textarea', 'informeMoratoria', 'Informe moratoria',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

--P418_RevisarInformeLetradoMoratoria
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RevisarInformeLetradoMoratoria'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; revisar el informe realizado por el letrado sobre la moratoria presentada por el demandado. En el campo Instrucciones deber&aacute; introducir las instrucciones a realizar por el letrado respecto a la moratoria. </p>
<p>En el campo &ldquo;Presentar conformidad&rdquo; deber&aacute; indicar si el letrado debe presentar el escrito de conformidad a la moratoria o no.</p>
<p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Lectura instrucciones moratoria&rdquo;.</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RevisarInformeLetradoMoratoria'), 1, 
'textarea', 'informeMoratoria', 'Informe moratoria',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 
'valores[''P418_RegistrarInformeMoratoria''] == null ? '''' : ( valores[''P418_RegistrarInformeMoratoria''][''informeMoratoria''] )', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RevisarInformeLetradoMoratoria'), 2, 
'textarea', 'instruccionesMoratoria', 'Instrucciones moratoria',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RevisarInformeLetradoMoratoria'), 3, 
'combo', 'comboConformidad', 'Presentar conformidad',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0);


--P418_LecturaInstruccionesMoratoria
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_LecturaInstruccionesMoratoria'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A trav&eacute;s de esta tarea deber&aacute; de leer las instrucciones dictadas por la entidad respecto a la moratoria.</p>
<p>Una vez acepte las instrucciones y en funci&oacute;n de los datos introducidos en tareas anteriores, la siguiente tarea ser&aacute; &ldquo;Celebraci&oacute;n de la vista&rdquo;, &ldquo;Registrar resoluci&oacute;n&rdquo; o &ldquo;Presentar escrito de conformidad&rdquo;</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_LecturaInstruccionesMoratoria'), 1, 
'textarea', 'instruccionesMoratoria', 'Instrucciones moratoria',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 
'valores[''P418_RegistrarInformeMoratoria''] == null ? '''' : ( valores[''P418_RevisarInformeLetradoMoratoria''][''instruccionesMoratoria''] )', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_LecturaInstruccionesMoratoria'), 2, 
'textarea', 'presentarAlegaciones', 'Presentar alegaciones',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 
0, 'DD', SYSDATE, 0);

--P418_PresentarConformidadMoratoria
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_PresentarConformidadMoratoria'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que la entidad ha decidido presentar el escrito de conformidad a la moratoria, a trav&eacute;s de esta tarea deber&aacute; de consignar la fecha de presentaci&oacute;n de dicho escrito.</p>
<p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p>Una vez rellene esta pantalla la siguiente tarea ser&aacute; &rdquo;Registrar resoluci&oacute;n&rdquo;. </p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_PresentarConformidadMoratoria'), 1, 
'date', 'fechaPresentacion', 'Fecha presentación',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_PresentarConformidadMoratoria'), 2, 'textarea', 'observaciones',  
'Observaciones', 0, 'DD', SYSDATE, 0);

--P418_CelebracionVista
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_CelebracionVista'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; dejar indicada la fecha de celebraci&oacute;n de la vista, en caso de que no se hubiere celebrado deber&aacute; dejar en blanco la fecha de celebraci&oacute;n.</p>
<p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p>Una vez rellene &eacute;sta pantalla se lanzar&aacute; la tarea &ldquo;Registrar resoluci&oacute;n&rdquo;.</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_CelebracionVista'), 1, 
'date', 'fechaCelebracion', 'Fecha celebración',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

--P418_RegistrarResolucion
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarResolucion'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deber&aacute; consignar el resultado que se haya dado, ya sea favorable para los intereses de la entidad o no, y solo en caso de haber sido desfavorable la fecha de fin de la moratoria.</p>
<p>Para el supuesto de que la resoluci&oacute;n no fuere favorable para la entidad, deber&aacute; comunicar dicha circunstancia al responsable interno de la misma a trav&eacute;s del bot&oacute;n &quot;Comunicaci&oacute;n&quot;. Una vez reciba la aceptaci&oacute;n del supervisor deber&aacute; gestionar el recurso por medio de la pesta&ntilde;a &quot;Recursos&quot;.</p>
<p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p>Una vez rellene &eacute;sta pantalla en caso de resoluci&oacute;n favorable para los intereses de la entidad se dar&aacute; por terminada esta actuaci&oacute;n continuando as&iacute; con la actuaci&oacute;n anterior, en caso contrario el sistema esperar&aacute; hasta 2 meses antes del fin de la moratoria para lanzar la tarea &ldquo;Solicitar instrucciones&rdquo;.</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarResolucion'), 1, 
'date', 'fechaResolucion', 'Fecha resolución',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarResolucion'), 2, 
'combo', 'comboFavDesf', 'Resultado',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDFavorable', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarResolucion'), 3, 
'date', 'fechaFinMoratoria', 'Fecha fin de moratoria',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_RegistrarResolucion'), 4, 
'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);

--P418_SolicitarInstrucciones
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_SolicitarInstrucciones'), 0, 'label', 'titulo',  '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que restan dos meses para que expire la fecha de moratoria dictaminada, a trav&eacute;s de esta tarea se le informa de que debe obtener instrucciones por parte de la entidad a este respecto.</p>
<p>En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p>Una vez termine esta tarea se lanzara una toma de decisi&oacute;n por la cual debe indicar la siguiente actuaci&oacute;n a realiza</p></div>' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_SolicitarInstrucciones'), 1, 
'date', 'fechaInstrucciones', 'Fecha instrucciones',
'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P418_SolicitarInstrucciones'), 2, 
'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0);



  
  
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