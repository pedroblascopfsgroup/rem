--rollback



delete from tfi_TareaS_form_items where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from dd_ptp_plazos_tareas_plazas where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from ter_Tarea_externa_recuperacion ter where ter.TEX_ID in (select tex_id from TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'))); 

DELETE FROM TEV_TAREA_EXTERNA_VALOR WHERE TEX_ID IN (SELECT TEX_ID FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419')));

DELETE FROM TEX_TAREA_EXTERNA where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

DELETE from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419');

delete from tar_tareas_notificaciones where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from prc_cex where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from hac_historico_accesos where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from prc_per where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from prd_procedimientos_derivados where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

DELETE FROM LOB_LOTE_BIEN WHERE LOS_ID IN (SELECT LOS_ID FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'))));

DELETE FROM LOS_LOTE_SUBASTA WHERE SUB_ID IN (SELECT SUB_ID FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419')));

DELETE FROM SUB_SUBASTA WHERE PRC_ID IN (SELECT PRC_ID  from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from dpr_decisiones_procedimientos where prc_id in (select prc_id from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419'));

delete from prc_procedimientos where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419');

delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P419';


--
set define off;

insert into dd_tpo_tipo_procedimiento
   (dd_tpo_id, dd_tpo_codigo, dd_tpo_descripcion, dd_tpo_descripcion_larga, dd_tpo_xml_jbpm, version, usuariocrear, fechacrear, borrado, dd_tac_id, flag_prorroga, dtype, flag_derivable)
 values
   (s_dd_tpo_tipo_procedimiento.nextval, 'P419', 'T. de ocupantes', 'Trámite de ocupantes', 'tramiteOcupantes', 0, 'DD', sysdate, 0, 2, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'), 'MEJTipoProcedimiento', 1);

--tarea 1 p419_trasladodocudeteccionocupantes
/* Formatted on 2014/10/03 13:09 (Formatter Plus v4.8.8) */
INSERT INTO tap_tarea_procedimiento
            (tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion, dd_tpo_id_bpm, VERSION, usuariocrear,
             fechacrear, borrado, tap_script_decision, DTYPE
            )
     VALUES (s_tap_tarea_procedimiento.NEXTVAL, (SELECT dd_tpo_id
                                                   FROM dd_tpo_tipo_procedimiento
                                                  WHERE dd_tpo_codigo = 'P419'), 'P419_TrasladoDocuDeteccionOcupantes', 0, 'Traslado de documentación detección de ocupantes', NULL, 0, 'dd',
             SYSDATE, 0, 'valores[''P419_TrasladoDocuDeteccionOcupantes''][''comboDocumentacion''] == DDSiNo.SI ? ''conDocumentacion'' : ''sinDocumentacion''',
			 'EXTTareaProcedimiento');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_TrasladoDocuDeteccionOcupantes'), '3', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_TrasladoDocuDeteccionOcupantes'), 0, 'label', 'titulo',  'Traslado de documentación detección de ocupantes' , 0, 'DD', sysdate, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 1, 'combo', 'comboOcupado', 'Bien ocupado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label,
             tfi_error_validacion, tfi_validacion, tfi_business_operation, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 2, 'combo', 'comboDocumentacion', 'Documentacion',
             'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label,
             tfi_error_validacion, tfi_validacion, tfi_business_operation, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 3, 'combo', 'comboInquilino', 'Existe algún inquilino',
             'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 4, 'date', 'fechaContrato', 'Fecha contrato arrendamiento', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label,
             tfi_error_validacion, tfi_validacion, tfi_valor_inicial, VERSION, usuariocrear,
             fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 5, 'text', 'nombreArrendatario', 'Nombre arrendatario',
             'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'dameNumAuto()', 0, 'DD',
             sysdate, 0
            );
            
INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 6, 'date', 'fechaVista', 'Fecha vista', 0, 'DD', SYSDATE, 0
            );
            
INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 7, 'date', 'fechaFinAle', 'Fecha fin alegaciones', 0, 'DD', SYSDATE, 0
            );
                     
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes'), 8, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--tarea 2 p419_solicitudrequerimientodococupantes
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, TAP_ALERT_VUELTA_ATRAS,dtype) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_SolicitudRequerimientoDocOcupantes', 0, 'Solicitud de requerimiento documentación de ocupantes',null, 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');    
    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_SolicitudRequerimientoDocOcupantes'), '3*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_SolicitudRequerimientoDocOcupantes'), 0, 'label', 'titulo',  'Solicitud de requerimiento documentación de ocupantes' , 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_SolicitudRequerimientoDocOcupantes'), 1, 'date', 'fechaSolicitud', 'Fecha solicitud', 0, 'DD', SYSDATE, 0
            );
			
--OBSERVACIONES			
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_SolicitudRequerimientoDocOcupantes'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);



--tarea 3 P419_RegistrarRecepcionDoc
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, tap_alert_vuelta_atras,dtype) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_RegistrarRecepcionDoc', 0, 'Registrar recepción de la documentación',null, 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarRecepcionDoc'), 'damePlazo(valores[''P419_SolicitudRequerimientoDocOcupantes''][''fechaSolicitud''])+20*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarRecepcionDoc'), 0, 'label', 'titulo',  'Registrar recepción de la documentación' , 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarRecepcionDoc'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarRecepcionDoc'), 2, 'date', 'fechaVista', 'Fecha vista', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarRecepcionDoc'), 3, 'date', 'fechaFinAle', 'Fecha fin alegaciones', 0, 'DD', SYSDATE, 0
            );

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarRecepcionDoc'), 4, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);




--tarea 4 p419_registrarinformesituacion
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, dtype, tap_script_validacion) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_RegistrarInformeSituacion', 0, 'Registrar informe de situación',null, 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento', 'comprobarExisteDocumentoISP() ? null : ''Es necesario adjuntar el documento informe de situación de la posesión''');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarInformeSituacion'), 'valores[''P419_RegistrarRecepcionDoc''] == null ? (5*24*60*60*1000L): (valores[''P419_RegistrarRecepcionDoc''][''FechaRecepcion''] == null ? (5*24*60*60*1000L) : (damePlazo(valores[''P419_RegistrarRecepcionDoc ''][''fechaRecepcion''])+20*24*60*60*1000L))', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarInformeSituacion'), 0, 'label', 'titulo',  'Registrar informe de situación' , 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P419_RegistrarInformeSituacion'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, tfi_error_validacion,
             tfi_validacion, tfi_business_operation, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarInformeSituacion'), 2, 'combo', 'comboResultado', 'Resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
             'valor != null && valor != '''' ? true : false', 'DDPositivoNegativo', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P419_RegistrarInformeSituacion'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0
            );    

--tarea 5 p419_RevisarInformeLetrado
/* Formatted on 2014/10/06 10:35 (Formatter Plus v4.8.8) */
INSERT INTO tap_tarea_procedimiento
            (tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion, dd_tpo_id_bpm, VERSION, usuariocrear, fechacrear, borrado, tap_script_decision, tap_alert_vuelta_atras, dtype, dd_sta_id)
     VALUES (s_tap_tarea_procedimiento.NEXTVAL, (SELECT dd_tpo_id
                                                   FROM dd_tpo_tipo_procedimiento
                                                  WHERE dd_tpo_codigo = 'P419'), 'P419_RevisarInformeLetrado', 1, 'Revisar informe de letrado', NULL, 0, 'dd', SYSDATE, 0,
                                                  'valores[''P419_RevisarInformeLetrado''][''comboResultado''] == ''MOD'' ? ''requiereModificacion'' : (valores[''P419_RevisarInformeLetrado''][''comboResultado''] == ''HA'' ? ''siHayAleg'' : (valores[''P419_RevisarInformeLetrado''][''comboResultado''] == ''NHASHV'' ? ''noHayAlegSiHayVista'' : ''noHayAlegNoHayVista''))', 'tareaExterna.cancelarTarea',
                                                  'EXTTareaProcedimiento',
                                                  40
            );   
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RevisarInformeLetrado'), '5*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RevisarInformeLetrado'), 0, 'label', 'titulo',  'Revisar informe de letrado' , 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P419_RevisarInformeLetrado'), 1, 'date', 'fecha', 'Fecha', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, tfi_error_validacion,
             tfi_validacion, tfi_business_operation, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RevisarInformeLetrado'), 2, 'combo', 'comboResultado', 'Resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio',
             'valor != null && valor != '''' ? true : false', 'DDResultadoInforme', 0, 'DD', SYSDATE, 0
            );

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                                 FROM tap_tarea_procedimiento
                                                WHERE tap_codigo = 'P419_RevisarInformeLetrado'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', SYSDATE, 0
            );   


--tarea 6 p419_presentarescritoalegaciones
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, tap_alert_vuelta_atras,dtype) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_PresentarEscritoAlegaciones', 0, 'Presentar escrito de alegaciones',null, 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea','EXTTareaProcedimiento');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_PresentarEscritoAlegaciones'), '5*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_PresentarEscritoAlegaciones'), 0, 'label', 'titulo',  'Presentar escrito de alegaciones' , 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_PresentarEscritoAlegaciones'), 1, 'date', 'fechaPresentacion', 'Fecha presentación', 0, 'DD', SYSDATE, 0
            );
            
INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, tfi_valor_inicial
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_PresentarEscritoAlegaciones'), 2, 'date', 'fechaVista', 'Fecha vista', 0, 'DD', SYSDATE, 0, 'valores[''P419_RegistrarRecepcionDoc''][''fechaVista''] == null ? (valores[''P419_TrasladoDocuDeteccionOcupantes''][''fechaVista'']) : valores[''P419_RegistrarRecepcionDoc''][''fechaVista'']' 
            );
					
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_PresentarEscritoAlegaciones'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);




--tarea 7 p419_confirmarvista
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, tap_script_decision, dtype) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_ConfirmarVista', 0, 'Confirmar vista',null, 0, 'dd', sysdate, 0,
'valores[''P419_ConfirmarVista''][''comboVista''] == DDSiNo.SI ? ''hayVista'' : ''noHayVista''','EXTTareaProcedimiento');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_ConfirmarVista'), '1*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_ConfirmarVista'), 0, 'label', 'titulo',  'Confirmar vista' , 0, 'DD', sysdate, 0);

										
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento WHERE tap_codigo = 'P419_ConfirmarVista'), 1, 'combo', 'comboVista', 'Vista', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);


INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado, tfi_valor_inicial
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_ConfirmarVista'), 2, 'date', 'fechaVista', 'Fecha vista', 0, 'DD', SYSDATE, 0, 'valores[''P419_RegistrarRecepcionDoc''][''fechaVista''] == null ? (valores[''P419_TrasladoDocuDeteccionOcupantes''][''fechaVista'']) : valores[''P419_RegistrarRecepcionDoc''][''fechaVista'']'
            );
					
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_ConfirmarVista'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);




--tarea 8 p419_registrarcelebracionvista
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, dtype) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_RegistrarCelebracionVista', 0, 'Registrar celebración vista',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarCelebracionVista'), '1*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarCelebracionVista'), 0, 'label', 'titulo',  'Registrar celebración vista' , 0, 'DD', sysdate, 0);


--date
INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarCelebracionVista'), 1, 'date', 'fechaResolucion', 'Fecha resolucion', 0, 'DD', SYSDATE, 0
            );
					
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarCelebracionVista'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);




--tarea 9 p419_registrarresolucion
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, dtype) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_RegistrarResolucion', 0, 'Registrar resolución',null, 0, 'dd', sysdate, 0,'EXTTareaProcedimiento');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarResolucion'), 'damePlazo(valores[''P419_ConfirmarVista''][''fechaVista''])+20*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_RegistrarResolucion'), 0, 'label', 'titulo',  'Registrar resolución' , 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarResolucion'), 1, 'date', 'fechaResolucion', 'Fecha resolucion', 0, 'DD', SYSDATE, 0
            );

--COMBO												
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento WHERE tap_codigo = 'P419_RegistrarResolucion'), 2, 'combo', 'comboResultado', 'Resultado', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDPositivoNegativo', 0, 'DD', sysdate, 0);

					
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_RegistrarResolucion'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);





--tarea 10 p419_resolucionfirme
insert into tap_tarea_procedimiento(tap_id, dd_tpo_id, tap_codigo, tap_supervisor, tap_descripcion,dd_tpo_id_bpm, version, usuariocrear, fechacrear, borrado, tap_alert_vuelta_atras,tap_script_decision,dtype) values(s_tap_tarea_procedimiento.nextval, (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo='P419'), 'P419_ResolucionFirme', 0, 'Resolución firme',null, 0, 'dd', sysdate, 0, 'tareaExterna.cancelarTarea','valores[''P419_RegistrarResolucion''][''comboResultado''] == DDPositivoNegativo.NEGATIVO ? ( vieneDeTramitePosesion() ? ''desfavorableTP'' : ''desfavorable'') : ''favorable''','EXTTareaProcedimiento');    
insert into dd_ptp_plazos_tareas_plazas(dd_ptp_id, tap_id, dd_ptp_plazo_script, version, usuariocrear, fechacrear, borrado) values(s_dd_ptp_plazos_tareas_plazas.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_ResolucionFirme'), 'damePlazo(valores[''P419_RegistrarCelebracionVista''][''fechaResolucion''])+5*24*60*60*1000L', 0, 'DD', sysdate, 0);    
insert into tfi_tareas_form_items(tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, version, usuariocrear, fechacrear, borrado) values(s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo='P419_ResolucionFirme'), 0, 'label', 'titulo',  'Resolución firme' , 0, 'DD', sysdate, 0);

INSERT INTO tfi_tareas_form_items
            (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, VERSION, usuariocrear, fechacrear, borrado
            )
     VALUES (s_tfi_tareas_form_items.NEXTVAL, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_ResolucionFirme'), 1, 'date', 'fechaResolucion', 'Fecha resolucion', 0, 'DD', SYSDATE, 0
            );
					
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (SELECT tap_id
                                         FROM tap_tarea_procedimiento
                                        WHERE tap_codigo = 'P419_ResolucionFirme'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deber� confirmar si el bien se encuentra ocupado o no, si dispone de la documentación de detección de ocupantes, en caso afirmativo, deberá indicar si existe o no inquilino y en tal caso la fecha del contrato de arrendamiento y el nombre del arrendatario. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de consignarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla en caso de no disponer de la documentación de detección se lanzará la tarea "Solicitud de requerimiento documentación a ocupantes", en caso contrario se lanzará la tarea "Realizar alegaciones".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_TrasladoDocuDeteccionOcupantes')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea deberá consignar la fecha en que haya solicitado el requerimiento de documentación a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar recepción de la documentación".</p></div>' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_SolicitudRequerimientoDocOcupantes')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá de consignar la fecha en que haya recibido la documentación solicitada a los ocupantes.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Los campos Fecha vista y Fecha fin para alegaciones deberá de consignarlos en caso de ya disponer de dicha información.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar informe de situación".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_RegistrarRecepcionDoc')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por completada esta tarea deberá adjuntar al procedimiento el informe de situación de los ocupantes según el formato establecido por la entidad. Una vez adjuntado el informe deberá consignar el resultado de dicho informe, ya sea positivo o no para los intereses de la entidad y la fecha en que haya dado por finalizada la preparación del informe.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Revisar informe de letrado".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_RegistrarInformeSituacion')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea se le informa de que dispone en la pestaña adjuntos del procedimiento, del informe de situación de la posesión propuesta por el letrado respecto al bien afecto. En el campo Resultado deberá indicar su aprobación o no de dicho informe.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo Fecha deberá consignar la fecha en que da por finalizada la revisión del informe propuesto por el letrado. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla y dependiendo de los datos introducidos se podrán lanzar las siguientes tareas:
	En caso de haber indicado que el informe requiere de modificaciones se lanzará la tarea "Registrar informe de situación" al letrado.
	En caso de no requerir modificación el informe propuesto por el letrado y de que se haya indicado anteriormente que se deben presentar alegaciones, se lanzará la tarea "Presentar escrito de alegaciones" al letrado.
	En caso de no requerir modificación el informe propuesto por el letrado y de que se haya indicado anteriormente que hay vista señalada, se lanzará la tarea "Registrar celebración de la vista".
	En caso de no requerir modificación el informe propuesto por el letrado, de que no haya que presentar alegaciones y que no se haya fijado fecha para la vista, se lanzará la tarea "Confirmar vista" al letrado.</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_RevisarInformeLetrado')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá de consignar la fecha en que haya presentado las alegaciones en el juzgado. En el campo fecha vista deberá consignar, si procede, la fecha en que ha quedado señalada la vista.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Confirmar vista".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_PresentarEscritoAlegaciones')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta tarea debe confirmar si hay vista o no, en caso de haberla deberá de consignar la fecha de celebración de la misma.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea, en caso de haber vista "Registrar vista" y en caso contrario "Registrar resolución".</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_ConfirmarVista')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Después de celebrada la vista, en esta pantalla debemos de consignar la fecha en la que se ha celebrado. </p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; "> En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla se lanzará la tarea "Registrar resolución"</p></div>' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_RegistrarCelebracionVista')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En ésta pantalla se deberá de consignar la fecha de notificación de la Resolución que hubiere recaído como consecuencia del juicio celebrado. Se indicará si el resultado de dicha resolución ha sido favorable para los intereses de la entidad o no.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para el supuesto de que la resolución no fuere favorable para la entidad, deberá comunicar dicha circunstancia al responsable interno de la misma a través del botón "Comunicación". Una vez reciba la aceptación del supervisor deberá gestionar el recurso por medio de la pestaña "Recursos".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para el supuesto de anuncio del recurso por la parte contraria se deberá gestionar directamente a través de la pestaña "Recursos".</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla la siguiente tarea será "Resolución firme"</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_RegistrarResolucion')	;
update tfi_tareas_form_items set tfi_label='	<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">A través de esta pantalla deberá consignar la fecha en la que la Resolución adquiere firmeza.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez rellene ésta pantalla y en caso de haber obtenido una resolución desfavorable y no venir de un trámite de posesión se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. En caso contrario se dará por terminada la actuación.</p></div>	 ' where tfi_nombre = 'titulo' and tap_id = 	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P419_ResolucionFirme')	;



commit;