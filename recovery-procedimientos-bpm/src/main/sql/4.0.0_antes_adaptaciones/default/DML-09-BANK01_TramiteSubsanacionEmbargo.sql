
--ROLLBACK




delete from tfi_TareaS_form_items where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

delete from dd_ptp_plazos_tareas_plazas where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

delete from ter_Tarea_externa_recuperacion ter where ter.TEX_ID in (select tex_id from TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'))); 

DELETE FROM TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414')));

DELETE FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

DELETE from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414');

delete from tar_tareas_notificaciones where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

delete from prc_cex where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

delete from hac_historico_accesos where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

delete from prc_per where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

delete from prd_procedimientos_derivados where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

DELETE FROM LOB_LOTE_BIEN WHERE LOS_ID IN (SELECT LOS_ID FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'))));

DELETE FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414')));

DELETE FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414'));

delete from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414');

delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P414';

SET DEFINE OFF;

Insert into DD_TPO_TIPO_PROCEDIMIENTO
   (DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE)
 Values
   (s_dd_tpo_tipo_procedimiento.nextval, 'P414', 'T. de subsanación de decreto de embargo', 'Trámite de subsanación de decreto de embargo', 'tramiteSubsanacionEmbargo', 0, 'DD', sysdate, 0, 2, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'), 'MEJTipoProcedimiento', 1);

--commit;


--tarea 1
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P414'), 'P414_RegistrarPresentacionEscritoSub', 0, 'Registrar presentación de escrito de subsanación',null, 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');    
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P414_RegistrarPresentacionEscritoSub'), '10*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P414_RegistrarPresentacionEscritoSub'), 0, 'label', 'titulo',  'Registrar presentación de escrito de subsanación' , 0, 'DD', SYSDATE, 0);


INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P414_RegistrarPresentacionEscritoSub'), 1, 'date', 'fechaPresentacion', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P414_RegistrarPresentacionEscritoSub'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P414'), 'P414_EntregarNuevoDecreto', 0, 'Entregar nuevo decreto/testimonio decreto de adjudicación',null, 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');    
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P414_EntregarNuevoDecreto'), 'damePlazo(valores[''P414_RegistrarPresentacionEscritoSub''][''fechaPresentacion''])+60*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P414_EntregarNuevoDecreto'), 0, 'label', 'titulo',  'Entregar nuevo decreto/testimonio decreto de adjudicación' , 0, 'DD', SYSDATE, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado,  TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P414_EntregarNuevoDecreto'), 1, 'date', 'fechaEnvio', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P414_EntregarNuevoDecreto'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea deberá de consignar la fecha de presentación en el Juzgado del escrito de subsanación.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Entregar nuevo testimonio decreto de adjudicación".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P414_RegistrarPresentacionEscritoSub')	;

update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Solo en el supuesto que este trámite se haya lanzado para la subsanación del testimonio de adjudicación, deberá informar de la fecha en que procede al envío del nuevo testimonio a la gestoría que corresponda.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se dará por terminado este trámite retomando así el trámite de adjudicación.</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P414_EntregarNuevoDecreto');

commit;