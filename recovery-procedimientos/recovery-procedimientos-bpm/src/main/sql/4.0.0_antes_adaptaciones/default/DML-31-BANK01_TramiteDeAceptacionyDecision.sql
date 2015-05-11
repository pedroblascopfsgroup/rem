/*
 * Trámite de Fase común Abreviado.
 * 
 * Pruebas:
 * 	- Roles implicados: SUPERVISOR, GESTOR, EDP
 * 	- Se necesita lanzar el script DML-04-BANK01-CrearUsuarioEDP.sql que crea el usuario GESTOREDP (EDP).
 * 
 */
SET SERVEROUTPUT ON; 

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	VAR_CODIGO_PROCEDIMIENTO VARCHAR2(10 CHAR) := 'P420';
	VAR_CODIGO_BPM VARCHAR2(10 CHAR);
	VAR_CODIGO_TAREA VARCHAR2(50 CHAR) := NULL;
	VAR_PLAZO_BPM_DERIVADO VARCHAR2(20 CHAR) := '300*24*60*60*1000L';
	VAR_PLAZO_TAREA VARCHAR2(1000 CHAR) := NULL;
  
BEGIN

dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - ROLLBACK DATOS y TABLAS...');

-- ROLLBACK COMPLETO
DELETE FROM tfi_tareas_form_items
      WHERE tap_id IN (SELECT tap_id
                         FROM tap_tarea_procedimiento
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));


DELETE FROM dd_ptp_plazos_tareas_plazas
      WHERE tap_id IN (SELECT tap_id
                         FROM tap_tarea_procedimiento
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM ter_tarea_externa_recuperacion ter
      WHERE ter.tex_id IN (SELECT tex_id
                             FROM tex_tarea_externa
                            WHERE tap_id IN (SELECT tap_id
                                               FROM tap_tarea_procedimiento
                                              WHERE dd_tpo_id = (SELECT dd_tpo_id
                                                                   FROM dd_tpo_tipo_procedimiento
                                                                  WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO)));

DELETE FROM TEV_TAREA_EXTERNA_VALOR TTV
      WHERE TTV.TEX_ID IN (SELECT tex_id
                             FROM tex_tarea_externa
                            WHERE tap_id IN (SELECT tap_id
                                               FROM tap_tarea_procedimiento
                                              WHERE dd_tpo_id = (SELECT dd_tpo_id
                                                                   FROM dd_tpo_tipo_procedimiento
                                                                  WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO)));

DELETE FROM tex_tarea_externa
      WHERE tap_id IN (SELECT tap_id
                         FROM tap_tarea_procedimiento
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM tap_tarea_procedimiento
      WHERE dd_tpo_id = (SELECT dd_tpo_id
                           FROM dd_tpo_tipo_procedimiento
                          WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO);

DELETE FROM tar_tareas_notificaciones
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO)
                                            );

DELETE FROM CRE_PRC_CEX WHERE CRE_PRC_CEX_PRCID IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));
                                           
DELETE FROM prc_cex
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM hac_historico_accesos
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM prc_per
      WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));


-- Elimina los procedimientos derivados
DELETE FROM prd_procedimientos_derivados WHERE dpr_id IN (
  SELECT DPR_ID FROM DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID  IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO))

);

DELETE FROM prd_procedimientos_derivados WHERE prc_id IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));
                        

/*
SELECT DPR_ID FROM
DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID  IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = 'P413'));                                    
*/                                            
DELETE FROM DPR_DECISIONES_PROCEDIMIENTOS WHERE PRC_ID  IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM PRB_PRC_BIE WHERE PRC_ID IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

-- PARA LIMPIAR DEPENDENCIAS
UPDATE prc_procedimientos SET PRC_PRC_ID=NULL 
  WHERE PRC_PRC_ID IN (SELECT prc_id
                         FROM prc_procedimientos
                        WHERE dd_tpo_id = (SELECT dd_tpo_id
                                             FROM dd_tpo_tipo_procedimiento
                                            WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO));

DELETE FROM prc_procedimientos WHERE dd_tpo_id = (SELECT dd_tpo_id
                           FROM dd_tpo_tipo_procedimiento
                          WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO);

                          -- PARA LIMPIAR DEPENDENCIAS
UPDATE TAP_TAREA_PROCEDIMIENTO SET DD_TPO_ID_BPM=NULL WHERE DD_TPO_ID_BPM IN (
	SELECT DD_TPO_ID FROM dd_tpo_tipo_procedimiento
	      WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO
);

DELETE FROM dd_tpo_tipo_procedimiento
      WHERE dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO;

----

dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - CREANDO TRAMITE FASE COMUN ABREVIADO...');

-- CREA EL PROCEDIMIENTO P420
Insert into DD_TPO_TIPO_PROCEDIMIENTO
	(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) 
Values
	(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, VAR_CODIGO_PROCEDIMIENTO, 'T. de aceptación y decisión', 'T. de aceptación y decisión','aceptacionYdecisionV4', 0, 'dd', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='03'));


	
-- P420_registrarAceptacion.
VAR_CODIGO_TAREA := 'P420_registrarAceptacion';
VAR_PLAZO_TAREA := '3*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/aceptacionYdecision/aceptacionV4',
   0, 
   'Registrar aceptación del asunto', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'valores[''P420_registrarAceptacion''][''comboConflicto''] == DDSiNo.SI || valores[''P420_registrarAceptacion''][''comboAceptacion''] == DDSiNo.NO ?  ''noAceptacion'' : ''aceptacion''');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla deberá indicar si acepta el Asunto asignado por la entidad o no.</p><p style="margin-bottom: 10px">En el campo "Conflicto de intereses" deberá consignar la existencia de conflicto o no, que le impida aceptar la dirección de la acción a instar, en caso de que haya conflicto de intereses no se le permitirá la aceptación del Asunto.</p><p style="margin-bottom: 10px">En el campo "Aceptación del asunto " deberá indicar si acepta o no el asunto, si ha marcado con anterioridad que existe conflicto de intereses, deberá marcar, en todo caso, la no aceptación del asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea será "Registrar recepción de la documantación" en caso de que haya aceptado el asunto, en caso de no haber aceptado el asunto se creará una tarea al supervisor para que tenga en cuenta su respuesta a la vez que reasigna el asunto a otro letrado.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'currency','principal','Principal',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'combo','comboConflicto','Conflicto de intereses','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),3,'combo','comboAceptacion','Aceptación del asunto','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),4,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P420_validarNoAceptacion.
VAR_CODIGO_TAREA := 'P420_validarNoAceptacion';
VAR_PLAZO_TAREA := '1*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/aceptacionYdecision/validarNoAceptacionV4',
   1, 
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Validar la no aceptación del Asunto', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">A través de esta pantalla debe validar la no aceptación del asunto por parte del letrado asignado, a continuación se le muestra los datos introducidos por el letrado.</p><p style="margin-bottom: 10px">Para dar por terminada esta tarea primero deberá reasignar el asunto a un nuevo letrado a través del botón "Cambiar gestor/supervisor" en la ficha del Asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez termine esta tarea se lanzará automáticamente un nuevo trámite de aceptación y decisión al letrado que haya reasignado el Asunto.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'currency','principal','Principal',null,null,'procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion()',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'combo','comboConflicto','Conflicto de intereses',null,null,'valores[''P420_registrarAceptacion''][''comboConflicto'']','DDSiNo','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),3,'combo','comboAceptacion','Aceptación del asunto',null,null,'valores[''P420_registrarAceptacion''][''comboAceptacion'']','DDSiNo','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),4,'textarea','observacionesLetrado','Observaciones letrado',null,null,'valores[''P420_registrarAceptacion''][''observaciones'']',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),5,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');

-- P420_registrarDecisionProcedimiento.
VAR_CODIGO_TAREA := 'P420_registrarProcedimiento';
VAR_PLAZO_TAREA := '2*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_SCRIPT_VALIDACION_JBPM)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/aceptacionYdecision/decisionV4',
   0, 
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='39'),
   'Registrar toma de decisión', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'valores[''P420_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.NO ? ''requiereSubsanacion'' :
((valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad'']==null || valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad'']=='''' || valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad'']) ? 
((valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P01'')?''hipotecario'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P02'')?''monitorio'':(
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P03'')?''ordinario'':(
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P17'')?''cambiario'':(
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P32'')?''abreviado'':(
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P16'')?''etj'':(
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P15'')?''etnj'':(
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P04'')?''verbal'': 
 valores[''P420_registrarProcedimiento''][''tipoProcedimiento''])))))))):''cambioDocumento'')',
 'valores[''P420_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.NO && (valores[''P420_registrarProcedimiento''][''fechaEnvio'']==null || valores[''P420_registrarProcedimiento''][''observaciones'']==null) ? ''Debe indicar la fecha de env&iacute;o de la documentaci&oacute;n y el problema en el campo observaciones'' : (valores[''P420_registrarProcedimiento''][''comboDocCompleta'']==DDSiNo.SI && valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==null ? ''Debe indicar el tipo de procedimiento a iniciar'' : null)');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla deberá consignar la fecha en la que recibe la documentación, en el campo “Documentación completa y correcta” deberá indicar si la documentación del expediente efectivamente es completa y correcta o no. En caso de no ser completa deberá indicar el problema en el campo Observaciones y la fecha en la que haya devuelto el expediente a la EDP. Es muy importante que revise la documentación e indique el problema encontrado en caso de error.</p><p style="margin-bottom: 10px">En el campo "Procedimiento propuesto por la entidad" se le indica el tipo de procedimiento propuesto por la entidad. En caso de estar de acuerdo con dicha propuesta de actuación, deberá consignar en el campo "Procedimiento a iniciar" el mismo tipo de procedimiento, en caso contrario, deberá seleccionar otro procedimiento según su criterio, el cual será propuesto al supervisor asignado a este asunto.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla, en caso de haber encontrado un problema en la documentación se iniciará la tarea “Subsanar error en documentación” a realizar por la empresa de preparación documental. En caso de no haber encontrado error en la documentación y de haber seleccionado el mismo tipo de procedimiento que el comité se iniciará dicho procedimiento, en caso de haber seleccionado un procedimiento distinto al propuesto por la entidad, se iniciará una tarea en la que el supervisor deberá validar el cambio de procedimiento que haya propuesto.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'date','fecha','Fecha recepción documentación','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2, 'combo','comboDocCompleta','Documentación completa y correcta','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,'DDSiNo','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),3,'date','fechaEnvio','Fecha envío documentación para subsanación',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),4,'combo','tipoPropuestoEntidad','Procedimiento propuesto por la entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'dameTipoProcedimientoOriginal()','TipoProcedimiento','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),5,'combo','tipoProcedimiento','Procedimiento a iniciar','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,null,'TipoProcedimiento','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),6,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');



-- P420_validarCambioProcedimiento
VAR_CODIGO_TAREA := 'P420_validarCambioProcedimiento';
VAR_PLAZO_TAREA := '2*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_SCRIPT_DECISION, TAP_ALERT_VUELTA_ATRAS)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/aceptacionYdecision/validacionTipoProcedimientoPropuestoLetradoV4',
   1, 
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='40'),
   'Validar cambio de procedimiento', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'valores[''P420_validarCambioProcedimiento''][''comboValidacion''] == DDSiNo.NO ? ''No'' : ( 
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P01'') ? ''hipotecario'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P02'') ? ''monitorio'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P03'') ? ''ordinario'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P17'') ? ''cambiario'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P32'') ? ''abreviado'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P16'') ? ''etj'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P15'') ? ''etnj'' : (
 (valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']==''P04'') ? ''verbal'' : valores[''P420_registrarProcedimiento''][''tipoProcedimiento'']))))))))',
 'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá validar el cambio del tipo de actuación propuesto por el letrado respecto a la decisión de la entidad.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">En caso de validar el cambio de actuación se iniciará la actuación seleccionada, en caso contrario se lanzará de nuevo la tarea "Registrar decisión" al letrado.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),1,'combo','tipoProcedimiento','Tipo procedimiento propuesto por el letrado','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'valores[''P420_registrarProcedimiento''] == null ? '''' : (valores[''P420_registrarProcedimiento''][''tipoProcedimiento''])',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),2,'combo','tipoPropuestoEntidad','Tipo procedimiento propuesto por la entidad','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',null,'valores[''P420_registrarProcedimiento''] == null ? '''' : (valores[''P420_registrarProcedimiento''][''tipoPropuestoEntidad''])',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),3,'combo','comboValidacion','Solicitud aceptada','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != ''''? true : false',null,'DDSiNo','0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA),4,'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');


-- P420_SubsanarErrDocumentacion.
VAR_CODIGO_TAREA := 'P420_SubsanarErrDocumentacion';
VAR_PLAZO_TAREA := 'damePlazo(valores[''P420_registrarProcedimiento''][''fechaEnvio''])+10*24*60*60*1000L';
Insert into TAP_TAREA_PROCEDIMIENTO
   (TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_VIEW, TAP_SUPERVISOR, DD_STA_ID, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS)
 Values
   (s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = VAR_CODIGO_PROCEDIMIENTO),
   VAR_CODIGO_TAREA,
   'plugin/procedimientos/aceptacionYdecision/subsanacionErrorDocV4',
   0, 
   (SELECT DD_STA_ID FROM BANKMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO='600'),
   'Subsanar error en documentación', 0, 'DD', sysdate, 0, 
   'EXTTareaProcedimiento',
   'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Dado que el letrado ha indicado que existe un problema en la documentación del expediente, antes de dar por finalizada esta tarea deberá resolver el problema informado.</p><p style="margin-bottom: 10px">Una vez enviada la documentación ya completa al letrado, deberá informar la fecha de envío de dicha documentación.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="margin-bottom: 10px">Una vez complete esta tarea se lanzará la tarea “Registrar toma de decisión” al letrado asignado al expediente.</p></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo=VAR_CODIGO_TAREA);

Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA), 1, 'textarea','observacionesLetrado','Observaciones letrado',null,null,'valores[''P420_registrarProcedimiento''][''observaciones'']',null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA), 2, 'date','fechaEnvio','Fecha envío','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '''' ? true : false',null,null,'0','DD',sysdate,null,null,null,null,'0');
Insert into TFI_TAREAS_FORM_ITEMS (TFI_ID,TAP_ID,TFI_ORDEN,TFI_TIPO,TFI_NOMBRE,TFI_LABEL,TFI_ERROR_VALIDACION,TFI_VALIDACION,TFI_VALOR_INICIAL,TFI_BUSINESS_OPERATION,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
values (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo=VAR_CODIGO_TAREA), 3, 'textarea','observaciones','Observaciones',null,null,null,null,'0','DD',sysdate,null,null,null,null,'0');



--------------------------
---- BPM TRAMITE DE ACEPTACION Y DECISIOM
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMAceptacionYdecision';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P420';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite de Aceptación y decisión',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite de Aceptación y decisión P420' , 0, 'DD', SYSDATE, 0);
   
--------------------------
---- BPM TRAMITE HIPOTECARIO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMHipotecario';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P01';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Hipotecario',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite hipotecario P01' , 0, 'DD', SYSDATE, 0);
   
	
--------------------------
---- BPM TRAMITE MONITORIO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMMonitorio';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P02';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite monitorio',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite monitorio P02' , 0, 'DD', SYSDATE, 0);
	

	
--------------------------
---- BPM TRAMITE ORDINARIO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMOrdinario';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P03';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Ordinario',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite ordinario P03' , 0, 'DD', SYSDATE, 0);

	
--------------------------
---- BPM TRAMITE CAMBIARIO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMCambiario';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P17';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Cambiario',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite cambiario P17' , 0, 'DD', SYSDATE, 0);

--------------------------
---- BPM TRAMITE ABREVIADO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMAbreviado';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P32';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Abreviado',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Abreviado P32' , 0, 'DD', SYSDATE, 0);

	
--------------------------
---- BPM TRAMITE EJ. TITULO JUDICIAL
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMETJ';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P16';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Ej. de Título Judicial',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Ej. de Título Judicial P16' , 0, 'DD', SYSDATE, 0);
	

--------------------------
---- BPM TRAMITE EJ. TITULO NO JUDICIAL
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMETNJ';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P15';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Ej. de Título No Judicial',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Ej. de Título No Judicial P15' , 0, 'DD', SYSDATE, 0);

--------------------------
---- BPM TRAMITE EJ. VERBAL
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMVerbal';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P04';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Verbal',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Verbal P04' , 0, 'DD', SYSDATE, 0);


--------------------------
---- BPM TRAMITE FASE COMUN ORDINARIO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMFaseComunOrdinario';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P24';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Fase Común Ordinario',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Fase Común Ordinario P24' , 0, 'DD', SYSDATE, 0);
	
--------------------------
---- BPM TRAMITE FASE COMUN ABREVIADO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMFaseComunAbreviado';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P412';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Fase Común Abreviado',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Fase Común Abreviado P412' , 0, 'DD', SYSDATE, 0);
	
--------------------------
---- BPM TRAMITE SOLICITUD CONCURSO NECESARIO
--------------------------
VAR_CODIGO_TAREA := 'P420_BPMSolicitudConcurso';
VAR_PLAZO_TAREA := VAR_PLAZO_BPM_DERIVADO;
VAR_CODIGO_BPM := 'P55';
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, 
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO),
	VAR_CODIGO_TAREA, 0,
	'Tramite Solicitud Concurso Necesario',
	(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_BPM), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), VAR_PLAZO_TAREA, 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval,
	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=VAR_CODIGO_TAREA), 0, 'label', 'titulo',  
	'Se inicia el trámite Solicitud Concurso Necesario P55' , 0, 'DD', SYSDATE, 0);
	
/*	
P420_BPMAceptacionYdecision P420	
P420_BPMHipotecario P01
P420_BPMMonitorio	P02
P420_BPMOrdinario	P03
P420_BPMCambiario	P17
P420_BPMAbreviado	P32
P420_BPMETJ			P16
P420_BPMETNJ			P15
P420_BPMVerbal		P04	
P420_BPMFaseComunOrdinario	P24
P420_BPMFaseComunAbreviado	P412
P420_BPMSolicitudConcurso  141

---
en BD (where DD_TAC_ID=3)

P26	T. demandado en incidente
P27	T. de solicitud de actuaciones o pronunciamientos
P28	T. Registrar resolución de interés
P29	T. fase convenio
P30	T. Propuesta anticipada convenio
P31	T. fase de liquidación
P34	T. de calificación
P35	T. de presentación propuesta convenio
P62	T. conclusión de concurso
P63	T. adhesión a convenio
P64	T. seguimiento cumplimiento de convenio
P94	P. reapertura de concurso
P85	Procedimiento concursal
P55	P. solicitud de concurso necesario
P56	T. fase común abreviado
P24	T. fase común ordinario
P25	T. demanda incidental
P408	T. fase convenio
P412	T. fase común abreviado

*/

dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - FIN');

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