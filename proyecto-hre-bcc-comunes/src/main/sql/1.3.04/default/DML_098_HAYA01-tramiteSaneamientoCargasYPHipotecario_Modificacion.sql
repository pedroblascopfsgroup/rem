SET DEFINE OFF;
------------------------------------------------------
-- MODIFICACIONES T. SANEAMIENTO DE CARGAS
------------------------------------------------------

--HR-461 y HR-462 - Un error en la asignación de un plazo en tarea "Reg. Inscripcion cancelacion cargas economicas" provoca un fallo al guardar en tarea Liquidar Cargas
-- Se corrigen los plazos de las 3 últimas tareas para reasignar los correctos
update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegInsCancelacionCargasReg');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_LiquidarCargas''][''fechaCancelacion''])+10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegInsCancelacionCargasEconomicas');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RegInsCancelacionCargasEconomicas''][''fechaInsEco''])+10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegistrarPresentacionInscripcionEco');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RegistrarPresentacionInscripcionEco''][''fechaPresentacion''])+30*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegInsCancelacionCargasRegEco');


--HR-476 - Corrección de perfiles gestor en T. saneamiento de cargas - todas las tareas
-- Se asigna gestor a todas las tareas y luego se asigna perfil gestor de administración a las 2 únicas tareas que lo tienen

--Nacho corregirá este error en la tarea HR-478
/*
UPDATE TAP_TAREA_PROCEDIMIENTO 
SET DD_STA_ID = (SELECT DD_STA_ID FROM HAYAMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '800') 
WHERE TAP_CODIGO LIKE 'H008%';
--Todas las tareas con gestor

UPDATE TAP_TAREA_PROCEDIMIENTO
SET DD_STA_ID = (SELECT DD_STA_ID FROM HAYAMASTER.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = '811')
WHERE TAP_CODIGO = 'H008_RevisarPropuestaCancelacionCargas';
-- Se reasigna Gestor de administracion a las 2 tareas que tienen otro tipo
*/



--HR-460 - Se rehabilita el requerimiento del documento adjunto "Propuesta de cancelación de las cargas (Saneamiento de cargas)" en la tarea 4 "Tramitar propuesta de cancelación de cargas"
update tap_tarea_procedimiento set tap_script_validacion = 'comprobarExisteDocumentoPCC() ? null : ''Es necesario adjuntar el documento propuesta de cancelación de las cargas''' where tap_codigo = 'H008_PropuestaCancelacionCargas';


------------------------------------------------------
-- MODIFICACIONES P.HIPOTECARIO
------------------------------------------------------

--HR-450 - Confirmar si existe oposición: Si se indica combo = SI, la fecha de comparecencia tambien es requerida
update haya01.tap_tarea_procedimiento
set tap_script_validacion_jbpm =
'(valores[''H001_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI && (valores[''H001_ConfirmarSiExisteOposicion''][''fechaOposicion''] == null || valores[''H001_ConfirmarSiExisteOposicion''][''motivoOposicion''] == null || valores[''H001_ConfirmarSiExisteOposicion''][''fechaComparecencia''] == null)) ? ''Si indica que hay oposici&oacute;n, debe registrar tambi&eacute;n "Fecha Oposici&oacute;n", "Motivo Oposici&oacute;n" y "Fecha Comparecencia"'' : null'
where tap_codigo = 'H001_ConfirmarSiExisteOposicion';



commit;

