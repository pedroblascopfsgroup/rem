SET DEFINE OFF;


	SET SERVEROUTPUT ON; 

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas

    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	

  VAR_CODIGO_PROCEDIMIENTO VARCHAR2(10 CHAR) := 'P416';

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

-- ROLLBACK básico
-- delete from tfi_TareaS_form_items where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P416'));
-- delete from dd_ptp_plazos_tareas_plazas where tap_id IN (select tap_id from tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P416'));
-- delete from  tap_tarea_procedimiento where dd_tpo_id = (select dd_tpo_id from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P416');
-- delete from dd_tpo_tipo_procedimiento where dd_tpo_codigo = 'P416';

----

dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - CREANDO TRAMITE POSESION...');

Insert into DD_TPO_TIPO_PROCEDIMIENTO
	(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TAC_ID) 
Values
	(S_DD_TPO_TIPO_PROCEDIMIENTO.NEXTVAL, VAR_CODIGO_PROCEDIMIENTO, 'T. de Posesión', 'Trámite de Posesión','tramiteDePosesionV4', 0, 'dd', sysdate, 0, (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AP'));

--tarea 1 P416_RegistrarSolicitudPosesion
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_SCRIPT_DECISION, DTYPE, TAP_VIEW, TAP_SCRIPT_VALIDACION_JBPM, TAP_SCRIPT_VALIDACION) 
	Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_RegistrarSolicitudPosesion', 0, 'Registrar Solicitud de Posesión',null, 0, 'dd', sysdate, 0,
	'valores[''P416_RegistrarSolicitudPosesion''][''comboMoratoria''] == DDSiNo.SI ? ''solicitudMoratoriaLanzamiento'' : (valores[''P416_RegistrarSolicitudPosesion''][''comboOcupado''] == DDSiNo.SI ? ''posesionConOcupantes'' : (valores[''P416_RegistrarSolicitudPosesion''][''comboPosesion''] == DDSiNo.SI ? ''posesionSinOcupantes'' : ''noRequierePosesion''))',
 	'EXTTareaProcedimiento',
	'plugin/procedimientos/tramiteDePosesion/registrarSolicitudPosesion',
	'valores[''P416_RegistrarSolicitudPosesion''][''comboPosesion''] == ''01'' && (valores[''P416_RegistrarSolicitudPosesion''][''fechaSolicitud''] == null || valores[''P416_RegistrarSolicitudPosesion''][''comboOcupado''] == null || valores[''P416_RegistrarSolicitudPosesion''][''comboMoratoria''] == null || valores[''P416_RegistrarSolicitudPosesion''][''comboViviendaHab''] == null) ? ''Los campos <b>Fecha de solicitud de la posesi&oacute;n</b>, <b>Ocupado</b>, <b>Moratoria</b> y <b>Vivienda Habitual</b> son obligatorios'' : null',
	'comprobarBienAsociadoPrc() ? null : ''Debe tener un bien asociado al procedimiento''');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarSolicitudPosesion'),
	'(valores[''P413_ConfirmarTestimonio''] != null && valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''] != null && valores[''P413_ConfirmarTestimonio''][''fechaTestimonio''] != '''') ? damePlazo(valores[''P413_ConfirmarTestimonio''][''fechaTestimonio'']) + 5*24*60*60*1000L : 5*24*60*60*1000L',
	0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarSolicitudPosesion'), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSolicitudPosesion'), 1, 'combo', 'comboPosesion', 'Posible Posesión', 'DDSiNo', 0, 'DD', sysdate, 0, 'valor != null && valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSolicitudPosesion'), 2, 'date', 'fechaSolicitud', 'Fecha de solicitud de la posesión', 0, 'DD', sysdate, 0, NULL, NULL);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSolicitudPosesion'), 3, 'combo', 'comboOcupado', 'Ocupado', 'DDSiNo', 0, 'DD', sysdate, 0, NULL, NULL);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSolicitudPosesion'), 4, 'combo', 'comboMoratoria', 'Moratoria', 'DDSiNo', 0, 'DD', sysdate, 0, NULL, NULL);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSolicitudPosesion'), 5, 'combo', 'comboViviendaHab', 'Vivienda Habitual', 'DDSiNo', 0, 'DD', sysdate, 0, NULL, NULL);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSolicitudPosesion'), 6, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--tarea 2 P416_BPMTramiteMoratoriaLanzamiento
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_BPMTramiteMoratoriaLanzamiento', 0, 'Tramite Moratoria Lanzamiento',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P418'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteMoratoriaLanzamiento'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteMoratoriaLanzamiento'), 0, 'label', 'titulo',  'Trámite de Moratoria de Lanzamiento' , 0, 'DD', SYSDATE, 0);

--tarea 3 P416_RegistrarSenyalamientoPosesion
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_RegistrarSenyalamientoPosesion', 0, 'Registrar Señalamiento de la Posesión',null, 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarSenyalamientoPosesion'), 'damePlazo(valores[''P416_RegistrarSolicitudPosesion''][''fechaSolicitud'']) + 5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarSenyalamientoPosesion'), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSenyalamientoPosesion'), 1, 'date', 'fechaSenyalamiento', 'Fecha señalamiento para posesión', 0, 'DD', sysdate, 0, 'valor != null && valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSenyalamientoPosesion'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

--tarea 4 P416_RegistrarPosesionYLanzamiento
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_SCRIPT_VALIDACION, TAP_SCRIPT_DECISION, DTYPE, TAP_VIEW, TAP_SCRIPT_VALIDACION_JBPM) 
	Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_RegistrarPosesionYLanzamiento', 0, 'Registrar posesión y decisión sobre lanzamiento', null, 0, 'dd', sysdate, 0,
	'comprobarExisteDocumentoDJP() ? null : ''Es necesario adjuntar el documento diligencia judicial de la posesión''',
	'valores[''P416_RegistrarPosesionYLanzamiento''][''comboOcupado''] == DDSiNo.SI ? ''conOcupantes'' : (valores[''P416_RegistrarPosesionYLanzamiento''][''comboLanzamiento''] == DDSiNo.SI ? ''hayLanzamiento'' : ''noHayLanzamiento'')',
  'EXTTareaProcedimiento',
  'plugin/procedimientos/tramiteDePosesion/registrarPosesionYLanzamiento',
  'valores[''P416_RegistrarPosesionYLanzamiento''][''comboOcupado''] == ''02'' && (valores[''P416_RegistrarPosesionYLanzamiento''][''fecha''] == null || valores[''P416_RegistrarPosesionYLanzamiento''][''comboFuerzaPublica''] == null || valores[''P416_RegistrarPosesionYLanzamiento''][''comboLanzamiento''] == null) ? ''Los campos <b>Fecha realizaci&oacute;n de la posesi&oacute;n</b>, <b>Necesario Fuerza P&uacute;blica</b> y <b>Lanzamiento Necesario</b> son obligatorios'' : (valores[''P416_RegistrarPosesionYLanzamiento''][''comboLanzamiento'']  == ''02'' && valores[''P416_RegistrarPosesionYLanzamiento''][''fechaSolLanza''] == null) ? ''El campo <b>Fecha solicitud de lanzamiento</b> es obligatorio'' : null');
	
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarPosesionYLanzamiento'), 'damePlazo(valores[''P416_RegistrarSenyalamientoPosesion''][''fechaSenyalamiento'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarPosesionYLanzamiento'), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarPosesionYLanzamiento'), 1, 'combo', 'comboOcupado', 'Ocupado en la realización de la Diligencia', 'DDSiNo', 0, 'DD', sysdate, 0, 'valor != null && valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarPosesionYLanzamiento'), 2, 'date', 'fecha', 'Fecha realización de la posesión', 0, 'DD', sysdate, 0, NULL, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarPosesionYLanzamiento'), 3, 'combo', 'comboFuerzaPublica', 'Necesario Fuerza Pública', 'DDSiNo', 0, 'DD', sysdate, 0, NULL, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarPosesionYLanzamiento'), 4, 'combo', 'comboLanzamiento', 'Lanzamiento Necesario', 'DDSiNo', 0, 'DD', sysdate, 0, NULL, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarPosesionYLanzamiento'), 5, 'date', 'fechaSolLanza', 'Fecha solicitud del lanzamiento', 0, 'DD', sysdate, 0, NULL, 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarPosesionYLanzamiento'), 6, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 5 P416_BPMTramiteOcupantes
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_BPMTramiteOcupantes', 0, 'Trámite de ocupantes',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P419'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteOcupantes'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteOcupantes'), 0, 'label', 'titulo',  'Trámite de Ocupantes' , 0, 'DD', SYSDATE, 0);

--tarea 6 P416_BPMTramiteOcupantes2
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_BPMTramiteOcupantes2', 0, 'Trámite de ocupantes',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P419'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteOcupantes2'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteOcupantes2'), 0, 'label', 'titulo',  'Trámite de Ocupantes' , 0, 'DD', SYSDATE, 0);


--tarea 7 P416_RegistrarSenyalamientoLanzamiento
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE, TAP_ALERT_VUELTA_ATRAS) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_RegistrarSenyalamientoLanzamiento', 0, 'Registrar Señalamiento del Lanzamiento', null, 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento', 'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarSenyalamientoLanzamiento'), 'damePlazo(valores[''P416_RegistrarPosesionYLanzamiento''][''fecha'']) + 5*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarSenyalamientoLanzamiento'), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSenyalamientoLanzamiento'), 1, 'date', 'fecha', 'Fecha señalamiento para el lanzamiento', 0, 'DD', sysdate, 0, 'valor != null && valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarSenyalamientoLanzamiento'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);

   
--tarea 8 P416_RegistrarLanzamientoEfectuado
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_SCRIPT_VALIDACION, DTYPE, TAP_ALERT_VUELTA_ATRAS) 
  Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_RegistrarLanzamientoEfectuado', 0, 'Registrar lanzamiento efectuado',null, 0, 'dd', sysdate, 0,
  'comprobarExisteDocumentoDJL() ? null : ''Es necesario adjuntar el documento diligencia judicial del lanzamiento''',
  'EXTTareaProcedimiento',
  'tareaExterna.cancelarTarea');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarLanzamientoEfectuado'), 'damePlazo(valores[''P416_RegistrarSenyalamientoLanzamiento''][''fecha'']) + 30*24*60*60*1000L', 0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarLanzamientoEfectuado'), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarLanzamientoEfectuado'), 1, 'date', 'fecha', 'Fecha lanzamiento efectivo', 0, 'DD', sysdate, 0, 'valor != null && valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarLanzamientoEfectuado'), 2, 'combo', 'comboFuerzaPublica', 'Necesario Fuerza Pública', 'DDSiNo', 0, 'DD', sysdate, 0, 'valor != null && valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarLanzamientoEfectuado'), 3, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 9 P416_RegistrarDecisionLlaves
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TAP_SCRIPT_DECISION, DTYPE)
  Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_RegistrarDecisionLlaves', 0, 'Registrar decisión sobre llaves',null, 0, 'dd', sysdate, 0, 
  'valores[''P416_RegistrarDecisionLlaves''][''comboLlaves''] == DDSiNo.SI ? ''requiereLlaves'' : ''noRequiereLlaves''',
  'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
	Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarDecisionLlaves'), 
	'((valores[''P416_RegistrarLanzamientoEfectuado''][''fecha''] !='''') && (valores[''P416_RegistrarLanzamientoEfectuado''][''fecha''] != null)) ? damePlazo(valores[''P416_RegistrarLanzamientoEfectuado''][''fecha'']) + 24*60*60*1000L : damePlazo(valores[''P416_RegistrarPosesionYLanzamiento''][''fecha'']) + 24*60*60*1000L',
	0, 'DD', SYSDATE, 0);

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarDecisionLlaves'), 0, 'label', 'titulo',  '' , 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, TFI_VALIDACION, TFI_ERROR_VALIDACION)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarDecisionLlaves'), 1, 'combo', 'comboLlaves', 'Gestión de Llaves', 'DDSiNo', 0, 'DD', sysdate, 0, 'valor != null && valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio');
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_tfi_tareas_form_items.nextval, (select tap_id from tap_tarea_procedimiento where tap_codigo = 'P416_RegistrarDecisionLlaves'), 2, 'textarea', 'observaciones', 'Observaciones', 0, 'DD', sysdate, 0);


--tarea 10
Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION,DD_TPO_ID_BPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE) Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO=VAR_CODIGO_PROCEDIMIENTO), 'P416_BPMTramiteGestionLlaves', 0, 'Tramite de Gestión de llaves',(select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P417'), 0, 'dd', sysdate, 0, 'EXTTareaProcedimiento');
Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteGestionLlaves'), '300*24*60*60*1000L', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_BPMTramiteGestionLlaves'), 0, 'label', 'titulo',  'Trámite de Gestión de llaves' , 0, 'DD', SYSDATE, 0);

dbms_output.put_line(VAR_CODIGO_PROCEDIMIENTO || ' - FIN');

update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Antes de dar por completada esta tarea deberá de haber un bien vinculado al procedimiento, esto podrá comprobarlo a través de la pestaña Bienes del procedimiento, en caso de no haberlo, a través de esa misma pestaña dispone de la opción de Agregar por la cual se le permite vincular un bien al procedimiento.</p><p style="margin-bottom: 10px">A través de esta tarea deberá de informar si hay una posible posesión o no, en caso de que proceda, la fecha de solicitud de la posesión, si el bien se encuentra ocupado o no, si se ha producido una petición de moratoria y en cualquier caso se deberá informar la condición del bien respecto a si es vivienda habitual o no.</p><p style="margin-bottom: 10px">En caso de que no haya ningún bien vinculado al procedimiento, deberá vincularlo a través de la pestaña Bienes del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y dependiendo de la información registrada se lanzará:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber solicitud de moratoria de posesión se iniciará el trámite para tal efecto.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien con ocupantes, se lanzará el trámite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de encontrarse el bien sin ocupantes, se lanzará la tarea "Registrar posesión"</li><li style="margin-bottom: 10px; margin-left: 35px;">En el caso de que el bien no esté en ninguna de las situaciones expuestas y no haya una posible posesión, se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad.</li></ul></div>' where tfi_tipo='label' and tfi_nombre='titulo' and tap_id=	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P416_RegistrarSolicitudPosesion')	;
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de consignar la fecha de señalamiento para la posesión.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzará la tarea "Registrar alzamiento efectivo".</p></div>' where tap_id=	(SELECT tap_id FROM tap_tarea_procedimiento WHERE tap_codigo = 'P416_RegistrarSenyalamientoPosesion')	and tfi_tipo='label' and tfi_nombre='titulo';
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá consignar en primer lugar si el bien se encuentra ocupado, y en caso negativo indicar la fecha de realización de la posesión, necesario fuerza pública y si el lanzamiento es necesario o no.</p><p style="margin-bottom: 10px">En caso de haberse producido la posesión deberá de adjuntar al procedimiento el documento "Diligencia judicial de la posesión"</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez completada esta tarea se lanzará:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">En caso de haber marcado el bien como ocupado, se lanzará el trámite de ocupantes.</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de Lanzamiento necesario se lanzará la tarea "Registrar señalamiento del lanzamiento".</li><li style="margin-bottom: 10px; margin-left: 35px;">En caso de no ser necesario el lanzamiento se lanzará la tarea "Registrar decisión sobre llaves".</li></ul></div>' where tap_id=	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarPosesionYLanzamiento') and tfi_tipo='label' and tfi_nombre='titulo'	;
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de consignar la fecha de señalamiento para el lanzamiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar lanzamiento efectivo".</p></div>' where tap_id=	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarSenyalamientoLanzamiento') and tfi_tipo='label' and tfi_nombre='titulo';
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá de consignar la fecha de lanzamiento efectivo así como dejar indicado si ha sido necesario el uso de la fuerza pública o no.</p><p style="margin-bottom: 10px">En caso de haberse producido el lanzamiento deberá de adjuntar al procedimiento el documento "Diligencia judicial del lanzamiento"</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla se lanzará la tarea "Registrar decisión sobre llaves".</p></div>' where tap_id=	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarLanzamientoEfectuado')	and tfi_tipo='label' and tfi_nombre='titulo';
update tfi_tareas_form_items set tfi_label='<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Para dar por completada esta tarea deberá dejar constancia de si es necesario realizar una gestión de las llaves por cambio de cerradura, o no.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla y en el caso de ser necesaria una gestión de las llaves se iniciará el trámite para la gestión de llaves, en caso contrario se le abrirá una tarea en la que propondrá, según su criterio, la siguiente actuación al responsable de la entidad. </p></div>' where tap_id=	(select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P416_RegistrarDecisionLlaves') and tfi_tipo='label' and tfi_nombre='titulo';


  
  
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