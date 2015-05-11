/*
* SCRIPT PARA GENERACIÓN DE DATOS BPM: Trámite de gestion de llaves
* BPM: P417 tramiteDeGestionDeLlaves
* FECHA: 20141013
* PARTES: 1/2
*/


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
	

--Inserción del código con el nuevo procedimiento P417 - Trámite de gestión de llaves
	Insert into BANK01.DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TAC_ID,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) values (S_DD_TPO_TIPO_PROCEDIMIENTO.nextval,'P417'
,'Gestion de llaves',null,null,'tramiteDeGestionDeLlaves','0','DD',SYSDATE,null,null,null,null,'0',(select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'),'1','MEJTipoProcedimiento','1','0');


--P417_RegistrarCambioCerradura:

	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P417'), 'P417_RegistrarCambioCerradura', 0, 'Registrar cambio de cerradura', NULL,'comprobarBienAsociadoPrc() ? null : ''Debe seleccionar un BIEN para poder realizar el tramite de gestion de llaves.''', '0', 'DD', sysdate, 0, 'tareaExterna.cancelarTarea', '1', 'EXTTareaProcedimiento', '3', 39);

	Insert into BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarCambioCerradura'), '5*24*60*60*1000L', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarCambioCerradura'), 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deber'||chr(38)||'aacute; de haber un bien vinculado al procedimiento, esto podr'||chr(38)||'aacute; comprobarlo a trav'||chr(38)||'eacute;s de la pestaña Bienes del procedimiento, en caso de no haberlo, a trav'||chr(38)||'eacute;s de esa misma pestaña dispone de la opci'||chr(38)||'oacute;n de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">Para dar por completada esta tarea deber'||chr(38)||'aacute; de consignar la fecha de cambio de cerradura.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar'||chr(38)||'aacute; la tarea "Registrar env'||chr(38)||'iacute;o de llaves"'||chr(38)||'quot;</p></div>' , '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarCambioCerradura')
,'1','date','fecha','Fecha cambio cerradura','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');



--P417_RegistrarEnvioLlaves:

	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P417'), 'P417_RegistrarEnvioLlaves', 0, 'Registrar envio de llaves',null, null,'0', 'DD', sysdate, 0, 'tareaExterna.cancelarTarea', '1', 'EXTTareaProcedimiento', '3', 39);

	Insert into BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlaves'), 'damePlazo(valores[''P417_RegistrarCambioCerradura''][''fecha'']) + 5*24*60*60*1000L', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlaves'), 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber'||chr(38)||'aacute; de consignar los campos “Nombre del primer depositario” y “Fecha env'||chr(38)||'iacute;o de llaves letrado”.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser'||chr(38)||'aacute; "Registrar recepci'||chr(38)||'oacute;n 1er depositario"'||chr(38)||'quot;</p></div>', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlaves')
,'1','text','nombre','Nombre del 1er depositario','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||''||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlaves')
,'2','date','fecha','Fecha envio de llaves letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||''||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlaves')
,'3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD',SYSDATE,null,null,null,null,'0');


--P417_RegistrarRecepcionLlaves:

   Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P417'), 'P417_RegistrarRecepcionLlaves', 0, 'Registrar recepcion de llaves',null, null,'0', 'DD', sysdate, 0, 'tareaExterna.cancelarTarea', '1', 'EXTTareaProcedimiento', '3', 104);

	Insert into BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlaves'), 'damePlazo(valores[''P417_RegistrarEnvioLlaves''][''fecha'']) + 5*24*60*60*1000L', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlaves'), 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber'||chr(38)||'aacute; de consignar el campo “Fecha recepci'||chr(38)||'oacute;n 1er depositario”.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar'||chr(38)||'aacute; la tarea " Registrar env'||chr(38)||'iacute;o de llaves a depositario final”'||chr(38)||'quot;</p></div>', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlaves')
,'1','date','fecha','Fecha recepcion 1er depositario','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlaves')
,'2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD',SYSDATE,null,null,null,null,'0');


--P417_RegistrarEnvioLlavesDepFinal:

	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P417'), 'P417_RegistrarEnvioLlavesDepFinal', 0, 'Registrar envio de llaves a Dep. final',null, null,'0', 'DD', sysdate, 0, 'tareaExterna.cancelarTarea', '1', 'EXTTareaProcedimiento', '3', 104);

	Insert into BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlavesDepFinal'), 'damePlazo(valores[''P417_RegistrarRecepcionLlaves''][''fecha'']) + 3*24*60*60*1000L', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlavesDepFinal'), 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber'||chr(38)||'aacute; de consignar el nombre del depositario final de las llaves as'||chr(38)||'iacute; como la fecha de env'||chr(38)||'iacute;o de llaves a '||chr(38)||'eacute;ste.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzar'||chr(38)||'aacute; la tarea “Registrar recepci'||chr(38)||'oacute;n de las llaves por el depositario final”'||chr(38)||'quot;</p></div>', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlavesDepFinal')
,'1','text','nombre','Nombre depositario final','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlavesDepFinal')
,'2','date','fecha','Fecha envio depositario final','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarEnvioLlavesDepFinal')
,'3','textarea','observaciones','Observaciones',null,null,null,null,'0','DD',SYSDATE,null,null,null,null,'0');



--P417_RegistrarRecepcionLlavesDepFinal:

	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P417'), 'P417_RegistrarRecepcionLlavesDepFinal', 0, 'Registrar envio de llaves a Dep. final',null, null,'0', 'DD', sysdate, 0, 'tareaExterna.cancelarTarea', '1', 'EXTTareaProcedimiento', '3', 105);

	Insert into BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlavesDepFinal'), 'damePlazo(valores[''P417_RegistrarEnvioLlavesDepFinal''][''fecha'']) + 4*24*60*60*1000L', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlavesDepFinal'), 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deber'||chr(38)||'aacute; de consignar el campo “Fecha recepci'||chr(38)||'oacute;n depositario final”.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, se le abrir'||chr(38)||'aacute; una tarea en la que propondr'||chr(38)||'aacute;, seg'||chr(38)||'uacute;n su criterio, la siguiente actuaci'||chr(38)||'oacute;n al responsable de la entidad'||chr(38)||'quot;</p></div>', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlavesDepFinal')
,'1','date','fecha','Fecha recepcion','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||''||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P417_RegistrarRecepcionLlavesDepFinal')
,'2','textarea','observaciones','Observaciones',null,null,null,null,'0','DD',SYSDATE,null,null,null,null,'0');



  
  
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