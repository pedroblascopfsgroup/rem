SET DEFINE OFF;



delete from tfi_TareaS_form_items where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

delete from dd_ptp_plazos_tareas_plazas where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

delete from ter_Tarea_externa_recuperacion ter where ter.TEX_ID in (select tex_id from TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'))); 

DELETE FROM TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415')));

DELETE FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

DELETE from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415');

delete from tar_tareas_notificaciones where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

delete from prc_cex where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

delete from hac_historico_accesos where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

delete from prc_per where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

delete from prd_procedimientos_derivados where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

DELETE FROM LOB_LOTE_BIEN WHERE LOS_ID IN (SELECT LOS_ID FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'))));

DELETE FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415')));

DELETE FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415'));

delete from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415');

delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P415';





Insert into DD_TPO_TIPO_PROCEDIMIENTO
   (DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID, FLAG_PRORROGA, DTYPE, FLAG_DERIVABLE)
 Values
   (s_dd_tpo_tipo_procedimiento.nextval, 'P415', 'T. de saneamiento de cargas', 'Trámite de saneamiento de cargas', 'tramiteSaneamientoCargas', 0, 'DD', sysdate, 0, 2, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'), 'MEJTipoProcedimiento', 1);

commit;

--tarea 1
/* Formatted on 2014/10/01 18:28 (Formatter Plus v4.8.8) */
INSERT INTO tap_tarea_procedimiento
            (tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion, dd_tpo_id_bpm, VERSION, usuariocrear, fechacrear, borrado, tap_script_decision, 
            tap_script_validacion, dd_sta_id
            )
     VALUES (s_tap_tarea_procedimiento.NEXTVAL, (SELECT dd_tpo_id
                                                   FROM dd_tpo_tipo_procedimiento
                                                  WHERE dd_tpo_codigo = 'P415'), 'P415_RevisarEstadoCargas', 0, 'Revisar el estado de las cargas', NULL, 0, 'dd', SYSDATE, 0, '''ambos''',
                                                  'comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienInscrito() ? ''null'' : ''Para cada una de las cargas, debe especificar el tipo y estado.''): ''Debe tener un bien asociado al procedimiento''',
                                                  101
            );
   
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RevisarEstadoCargas'), '5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RevisarEstadoCargas'), 0, 'label', 'titulo',  'Revisar el estado de las cargas' , 0, 'DD', SYSDATE, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RevisarEstadoCargas'), 1, 'date', 'fechaCargas', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RevisarEstadoCargas'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);
            
--tarea 2 P415_RegistrarPresentacionInscripcion
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_RegistrarPresentacionInscripcion', 0, 'Registrar presentación inscripción',null, 0, 'dd', sysdate, 0, 101);    

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegistrarPresentacionInscripcion'), 'damePlazo(valores[''P415_RevisarEstadoCargas''][''fechaCargas''])+30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
  
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegistrarPresentacionInscripcion'), 0, 'label', 'titulo',  'Registrar presentación inscripción' , 0, 'DD', SYSDATE, 0);


INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegistrarPresentacionInscripcion'), 1, 'date', 'fechaPresentacion', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegistrarPresentacionInscripcion'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--tarea 3

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO,
tap_script_validacion, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_RegInsCancelacionCargasReg', 0, 'Registrar inscripción cancelación de cargas registrales',null, 0, 'dd', sysdate, 0,
'comprobarEstadoCargasCancelacion() ? (comprobarExisteDocumentoEDCINR() ? null : ''Es necesario adjuntar el documento escritura o documento cancelación inscrito y nota registral'') : ''El estado de todas las cargas registrales debe ser estado cancelada''', 101);    

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegInsCancelacionCargasReg'), 'damePlazo(valores[''P415_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegInsCancelacionCargasReg'), 0, 'label', 'titulo',  'Registrar inscripción cancelación de cargas registrales' , 0, 'DD', SYSDATE, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegInsCancelacionCargasReg'), 1, 'date', 'fechaInscripcion', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegInsCancelacionCargasReg'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 4 P415_PropuestaCancelacionCargas
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_SCRIPT_VALIDACION, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_PropuestaCancelacionCargas', 1, 'Tramitar propuesta cancelación de cargas',null, 0, 'dd', sysdate, 0, 'comprobarExisteDocumentoPCC() ? null : ''Es necesario adjuntar el documento propuesta de cancelación de las cargas''', 103);    
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_PropuestaCancelacionCargas'), 'damePlazo(valores[''P415_RevisarEstadoCargas''][''fechaCargas''])+15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_PropuestaCancelacionCargas'), 0, 'label', 'titulo',  'Tramitar propuesta cancelación de cargas' , 0, 'DD', SYSDATE, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_PropuestaCancelacionCargas'), 1, 'date', 'fechaPropuesta', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_PropuestaCancelacionCargas'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 5 P415_RevisarPropuestaCancelacionCargas
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_RevisarPropuestaCancelacionCargas', 1, 'Revisar propuesta de cancelación de cargas',null, 0, 'dd', sysdate, 0, 103);   
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RevisarPropuestaCancelacionCargas'), 'damePlazo(valores[''P415_PropuestaCancelacionCargas''][''fechaPropuesta''])+15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RevisarPropuestaCancelacionCargas'), 0, 'label', 'titulo',  'Revisar propuesta de cancelación de cargas' , 0, 'DD', SYSDATE, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RevisarPropuestaCancelacionCargas'), 1, 'date', 'fechaRevisar', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RevisarPropuestaCancelacionCargas'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 6 P415_LiquidarCargas
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_LiquidarCargas', 0, 'Liquidar las cargas',null, 0, 'dd', sysdate, 0, 101);    
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_LiquidarCargas'), 'damePlazo(valores[''P415_RevisarPropuestaCancelacionCargas''][''fechaRevisar''])+15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_LiquidarCargas'), 0, 'label', 'titulo',  'Liquidar las cargas' , 0, 'DD', SYSDATE, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_LiquidarCargas'), 1, 'date', 'fechaLiquidacion', 'Fecha liquidación', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_LiquidarCargas'), 2, 'date', 'fechaRecepcion', 'Fecha recepción', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
            INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_LiquidarCargas'), 3, 'date', 'fechaCancelacion', 'Fecha cancelación', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_LiquidarCargas'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 7 P415_RegInsCancelacionCargasEconomicas
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, tap_script_validacion, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_RegInsCancelacionCargasEconomicas', 0, 'Registrar inscripción cancelación de cargas económicas',null, 0, 'dd', sysdate, 0, 
'comprobarEstadoCargasPropuesta() ? ''null'' : ''Todas las cargas deben ser informadas en estado cancelada o rechazada''', 101);    
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegInsCancelacionCargasEconomicas'), 'damePlazo(valores[''P415_LiquidarCargas''][''fechaCancelacion''])+15*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegInsCancelacionCargasEconomicas'), 0, 'label', 'titulo',  'Registrar inscripción cancelación de cargas económicas' , 0, 'DD', SYSDATE, 0);

            INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegInsCancelacionCargasEconomicas'), 1, 'date', 'fechaInsEco', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegInsCancelacionCargasEconomicas'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 8 P415_RegistrarPresentacionInscripcionEco

Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_RegistrarPresentacionInscripcionEco', 0, 'Registrar presentación inscripción',null, 0, 'dd', sysdate, 0, 101);    

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegistrarPresentacionInscripcionEco'), 'damePlazo(valores[''P415_RegInsCancelacionCargasEconomicas''][''fechaInsEco''])+30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);    
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegistrarPresentacionInscripcionEco'), 0, 'label', 'titulo',  'Registrar presentación inscripción' , 0, 'DD', SYSDATE, 0);

            INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegistrarPresentacionInscripcionEco'), 1, 'date', 'fechaPresentacion', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegistrarPresentacionInscripcionEco'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 9 P415_RegInsCancelacionCargasRegEco
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_STA_ID) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P415'), 'P415_RegInsCancelacionCargasRegEco', 0, 'Registrar inscripción cancelación de cargas registrales',null, 0, 'dd', sysdate, 0, 101);	

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegInsCancelacionCargasRegEco'), 'damePlazo(valores[''P415_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);	

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P415_RegInsCancelacionCargasRegEco'), 0, 'label', 'titulo',  'Registrar inscripción cancelación de cargas registrales' , 0, 'DD', SYSDATE, 0);

            INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, TFI_ERROR_VALIDACION, TFI_VALIDACION
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegInsCancelacionCargasRegEco'), 1, 'date', 'fechaInsReg', 'Fecha', 0, 'DD', SYSDATE, 0, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false'
            );
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P415_RegInsCancelacionCargasRegEco'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá de revisar las cargas anteriores y posteriores registradas en el bien vinculado al procedimiento. En caso de no haber un bien ya vinculado al procedimiento, antes de dar por completada esta tarea el sistema le obligará a asociarlo a través de la pestaña bienes del procedimiento. Para cada carga deberá indicar si es de tipo Registral, si es de tipo Económico  y en caso de no existir cargas indicarlo expresamente en el campo destinado a tal efecto. En cualquier cado deberá indicar en la ficha de cargas del bien la fecha en que haya realizado la revisión de las mismas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá indicar la fecha en que se le haya entregado el avalúo de cargas..</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla y dependiendo de como hayan quedado las cargas del bien adjudicado se podrán iniciar las siguientes tareas:
	En caso de haber alguna carga registral y no económica se lanzará la tarea "Registrar presentación de inscripción".
	En caso de haber alguna carga económica se lanzará la tarea "Tramitar propuesta de cancelación de cargas".
	En caso de haber quedado el bien en situación "Sin cargas" se lanzará una tarea de tipo decisión por la cual deberá de proponer a la entidad la próxima actuación a realizar.
</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">
En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en este punto.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene esta pantalla se lanzará la tarea "Señalamiento de subasta" a realizar por el letrado.</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_RevisarEstadoCargas')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá consignar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Registrar cancelación de cargas".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_RegistrarPresentacionInscripcion')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de consignar en esta tarea la fecha de inscripción de la cancelación de las cargas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla se lanzará un atarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_RegInsCancelacionCargasReg')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá adjuntar al procedimiento el documento con  la propuesta de cancelación de cargas según el formato establecido por la entidad. Desde la pestaña "Cargas" del bien asociado a este trámite, puede generar la propuesta de cancelación de cargas en formato Word, de forma que en caso de ser necesario pueda modificar el documento antes de adjuntarlo al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en que de por concluida la propuesta de cancelación de cargas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Revisar propuesta de cancelación de cargas".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_PropuestaCancelacionCargas')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Dado que se han adjuntado al procedimiento la propuesta de cancelación de cargas económicas, para dar por finalizada esta tarea deberá revisar dicha propuesta e informar de la fecha en que queda aprobada. En caso de necesitar comunicarse con el usuario responsable de la propuesta, recuerde que dispone de la opción de crear anotaciones a través de Recovery.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Liquidar las cargas".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_RevisarPropuestaCancelacionCargas')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por finalizada esta tarea deberá de solicitar a Administración el importe total aprobado para cancelar el total de las cargas registradas del bien asociado y consignar la fecha de solicitud en el campo Fecha solicitud importe. En el campo Fecha recepción importe deberá consignar la fecha en que haya recibido de Administración el importe solicitado. Por último, en el campo "Fecha cancelación de las cargas" consigne la fecha en que haya procedido a la liquidación del total de las cargas aprobadas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Registrar inscripción de las cargas".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_LiquidarCargas')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien asociado al procedimiento y marcar en las cargas económicas  el estado en que haya quedado cada una ya sea cancelada o rechazada. Una vez hecho esto deberá de consignar la fecha de inscripción de la cancelación de las cargas, en caso de haberse producido esta.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla en caso de que las cargas económicas también sean registrales se lanzará la tarea "Registrar presentación de inscripción", en caso de no haberlas se lanzará una tarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_RegInsCancelacionCargasEconomicas')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá consignar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será "Registrar cancelación de cargas".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_RegistrarPresentacionInscripcion')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por terminada esta tarea deberá acceder a la ficha del bien afecto y marcar en las cargas registrales que haya procedido a su cancelación dicha situación en el campo estado de la carga. Una vez hecho esto deberá de consignar en esta tarea la fecha de inscripción de la cancelación de las cargas.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Recuerde que en caso de haber cancelado alguna carga deberá de enviar al archivo la escritura de cancelación inscrita de la misma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla se lanzará un atarea por la cual deberá proponer a la entidad la siguiente actuación a realizar.</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P415_RegInsCancelacionCargasRegEco')	;


COMMIT;