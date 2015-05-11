/*
* SCRIPT PARA GENERACIÓN DE DATOS BPM: Trámite de aceptacion de concurso (por letrado)
* BPM: P404 tramiteAceptacionConcurso
* FECHA: 20141014
* PARTES: 1/1
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

--Inserción del código con el nuevo procedimiento P404 - Trámite de gestión de llaves
	Insert into BANK01.DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID,DD_TPO_CODIGO,DD_TPO_DESCRIPCION,DD_TPO_DESCRIPCION_LARGA,DD_TPO_HTML,DD_TPO_XML_JBPM,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DD_TAC_ID,FLAG_PRORROGA,DTYPE,FLAG_DERIVABLE,FLAG_UNICO_BIEN) values (S_DD_TPO_TIPO_PROCEDIMIENTO.nextval,'P404'
,'Aceptacion concursal del letrado',null,null,'tramiteAceptacionConcurso','0','DD',SYSDATE,null,null,null,null,'0','2','1','MEJTipoProcedimiento','1','0');



--P404_NodoEsperaController
	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P404'), 'P404_NodoEsperaController', 0, 'Estado oculto para consulta y evaluacion saldo principal',null, null,'(damePrincipal() >= 1000000)? ''SI'' : ''NO''', '0', 'DD', sysdate, 0, null, '1', 'EXTTareaProcedimiento', '3', 39);




--P404_ValidarAsignacionLetrado:

	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION,VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P404'), 'P404_ValidarAsignacionLetrado',
	1, 'Validar letrado y procurador asignados', NULL, NULL, '0', 'DD', sysdate, 0, null, '1', 'EXTTareaProcedimiento', '3', 40);

	Insert into BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values
(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_ValidarAsignacionLetrado'), '2*24*60*60*1000L', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_ValidarAsignacionLetrado')
, 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav'||chr(38)||'eacute;s de esta tarea debe validar que el letrado y procurador asignados son correctos para el concurso. En caso de no serlo, por favor, reasigne convenientemente.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interese que quede reflejado en este punto del procedimiento'||chr(38)||'quot;</p></div>' , '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_ValidarAsignacionLetrado')
,'1','date','fechaValidacion','Fecha validacion del letrado y procurador','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||chr(38)||' valor != '''' ? true : false',null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_ValidarAsignacionLetrado')
,'2','combo','decisionAsignacion','Asignacion correcta del letrado y procurador','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||chr(38)||' valor != '''' ? true : false',null,'DDSiNo','0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_ValidarAsignacionLetrado')
,'3','textarea','observacionesAsignacion','Observaciones de asignacion del letrado y procurador',null,null,null,null,'0','DD',SYSDATE,null,null,null,null,'0');



--P404_RegistrarAceptacionAsunto

	Insert into BANK01.TAP_TAREA_PROCEDIMIENTO
(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, TAP_SCRIPT_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_ALERT_VUELTA_ATRAS, TAP_AUTOPRORROGA, DTYPE, TAP_MAX_AUTOP, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from BANK01.DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P404'), 'P404_RegistrarAceptacionAsunto','plugin/procedimientos/tramiteAceptacionConcurso/aceptacionConcurso', 0, 'Registro de aceptacion del asunto asignado por la entidad',null, null,'0', 'DD', sysdate, 0, null, '1', 'EXTTareaProcedimiento', '3', 39);

	Insert into BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values
(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_RegistrarAceptacionAsunto'), '5*24*60*60*1000L', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS
(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_RegistrarAceptacionAsunto'),
 0, 'label', 'titulo',  '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A trav'||chr(38)||'eacute;s de esta pantalla deber'||chr(38)||'aacute; indicar si acepta el Asunto asignado por la entidad o no. En el campo "Conflicto de intereses" deber'||chr(38)||'aacute; consignar la existencia de conflicto o no, que le impida aceptar la direcci'||chr(38)||'oacute;n de la acci'||chr(38)||'oacute;n a instar, en caso de que haya conflicto de intereses no se le permitir'||chr(38)||'aacute; la aceptaci'||chr(38)||'oacute;n del Asunto. En el campo "Aceptaci'||chr(38)||'oacute;n del asunto" deber'||chr(38)||'aacute; indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deber'||chr(38)||'aacute; marcar, en todo caso, la no aceptaci'||chr(38)||'oacute;n del asunto'||chr(38)||'quot;</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto'||chr(38)||'quot;</p></div>', '0', 'DD', SYSDATE, 0);

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_RegistrarAceptacionAsunto')
,'1','combo','decisionIntereses','Existe un conflicto de intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null '||chr(38)||''||chr(38)||' valor != '''' ? true : false',null,'DDSiNo','0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_RegistrarAceptacionAsunto')
,'2','combo','decisionAceptacion','Aceptacion del asunto', null,null,null,'DDSiNo','0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_RegistrarAceptacionAsunto')
,'3','date','fechaAceptacion','Fecha de aceptacion',null,null,null,null,'0','DD',SYSDATE,null,null,null,null,'0');

	Insert into BANK01.TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) values (S_TFI_TAREAS_FORM_ITEMS.nextval,(select TAP_ID from BANK01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P404_RegistrarAceptacionAsunto')
,'4','textarea','observaciones','Observaciones',null,null,null,null,'0','DD',SYSDATE,null,null,null,null,'0');



  
  
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