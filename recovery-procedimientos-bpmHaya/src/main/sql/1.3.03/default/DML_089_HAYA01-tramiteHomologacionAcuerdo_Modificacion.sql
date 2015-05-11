BEGIN
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('----VARIOS CAMBIOS T.HOMOLOGACION ACUERDO----------------------------');
DBMS_OUTPUT.PUT_LINE('--                                                                 --');
DBMS_OUTPUT.PUT_LINE('-- HR-385, HR-387, HR-388, HR-389, HR-390                          --');
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');

--HR-388---------------------------------------------------
DBMS_OUTPUT.PUT_LINE('UPDATES cambios nombres campos H027_AceptarPropuestaAcuerdo');
update tfi_tareas_form_items set tfi_label = 'Fecha' where tfi_nombre = 'fecha' and tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_AceptarPropuestaAcuerdo');
update tfi_tareas_form_items set tfi_label = 'Intereses entidad'  where tfi_nombre = 'interesesEntidad' and tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_AceptarPropuestaAcuerdo');
update tfi_tareas_form_items set tfi_label = 'Resultado' where tfi_nombre = 'aceptarPropuestaAcuerdo' and tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_AceptarPropuestaAcuerdo');

--HR-387---------------------------------------------------
DBMS_OUTPUT.PUT_LINE('UPDATES cambios nombres campos H027_RegistrarPropuestaAcuerdo');
update tfi_tareas_form_items set tfi_label = 'Fecha' where tfi_nombre = 'fecha' and tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarPropuestaAcuerdo');
update tfi_tareas_form_items set tfi_label = 'Acuerdo propuesto'  where tfi_nombre = 'acuerdoPropuesto' and tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarPropuestaAcuerdo');
update tfi_tareas_form_items set tfi_label = 'Intereses entidad' where tfi_nombre = 'interesesEntidad' and tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarPropuestaAcuerdo');

--HR-385---------------------------------------------------
DBMS_OUTPUT.PUT_LINE('UPDATES cambios nombre tarea H027_AceptarPropuestaAcuerdo');
update tap_tarea_procedimiento set tap_descripcion = 'Preparar decisión sobre propuesta de acuerdo' where tap_codigo = 'H027_AceptarPropuestaAcuerdo';


--HR-389---------------------------------------------------
DBMS_OUTPUT.PUT_LINE('UPDATES cambios perfiles usuarios gestores ');
update tap_tarea_procedimiento set dd_sta_id = (SELECT DD_STA_ID FROM  HAYAMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '800')
	where tap_codigo = 'H027_AceptarPropuestaAcuerdo';

update tap_tarea_procedimiento set dd_sta_id = (SELECT DD_STA_ID FROM  HAYAMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '805')
	where tap_codigo = 'H027_ConfirmarContabilidad';
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');


--HR-390---------------------------------------------------
--CAMBIOS EN LOS PLAZOS---
DBMS_OUTPUT.PUT_LINE('UPDATES cambios PLAZOS todas las tareas');
update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '2*24*60*60*1000L'
where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarResultadoAcuerdo');	
	--Registrar resultado del acuerdo

--update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H027_RegistrarPropuestaAcuerdo''][''fecha'']) - 15*24*60*60*1000L'
--where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarResHomologacionJudicial');
	--Registrar resolución homologación judicial: Es correcta update no necesario

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '5*24*60*60*1000L'
where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarPublicacionSolArticulo');
	--Registrar solicitud del artículo 5Bis

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '60*24*60*60*1000L'
where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarPropuestaAcuerdo');
	--Registrar propuesta de acuerdo

--update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H027_RegistrarResHomologacionJudicial''][''fecha'']) + 1*24*60*60*1000L'
--where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarEntradaEnVigor');
	--Registrar entrada en vigor del acuerdo: Es correcta update no necesario

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '5*24*60*60*1000L'
where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_RegistrarAperturaNegociaciones');
	--Registrar apertura de negociaciones

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '2*24*60*60*1000L'
where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_LecturaAceptacionInstrucciones');
	--Conformar aceptación del acuerdo

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '10*24*60*60*1000L'
where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_AceptarPropuestaAcuerdo');
	--Decidir sobre propuesta de acuerdo

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '5*24*60*60*1000L'
where tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_ConfirmarContabilidad');
	--Confirmar contabilidad del acuerdo
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');


--CAMBIOS EN EL FLUJO BPM---
DBMS_OUTPUT.PUT_LINE('UPDATES cambios FUJO BPM y diccionario DDAceptadoRechazado');

update tap_tarea_procedimiento set tap_script_decision = NULL where tap_codigo = 'H027_AceptarPropuestaAcuerdo';
	--Se elimina del BPM la decisión posterior de esta tarea

update tfi_tareas_form_items set tfi_business_operation = 'DDAceptadoRechazado' where tfi_nombre = 'aceptarPropuestaAcuerdo' and tap_id = (select ttp1.tap_id from tap_tarea_procedimiento ttp1 where ttp1.tap_codigo = 'H027_AceptarPropuestaAcuerdo');
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');


DBMS_OUTPUT.PUT_LINE('UPDATE T.SANEAMIENTO DE CARGAS - Se rehabilita un requerimiento de documento adjunto.');
-- CAMBIOS EN T. SANEAMIENTO DE CARGAS
--Se rehabilita validacion de doc adjunto
--comprobarExisteDocumentoPCC() ? null : 'Es necesario adjuntar el documento propuesta de cancelación de las cargas'
--Se elimina esta validación de doc. adjunto porque ya se requiere en el t. elevacion Sareb
update tap_tarea_procedimiento set tap_script_validacion = 'comprobarExisteDocumentoPCC() ? null : ''Es necesario adjuntar el documento propuesta de cancelación de las cargas''' where tap_codigo = 'H008_PropuestaCancelacionCargas';
DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------------------');
DBMS_OUTPUT.PUT_LINE('FIN-COMMIT');

COMMIT;

END;