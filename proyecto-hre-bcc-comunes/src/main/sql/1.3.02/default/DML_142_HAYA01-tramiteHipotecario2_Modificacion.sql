SET DEFINE OFF;

BEGIN
DBMS_OUTPUT.PUT_LINE('**************************************************************************************************');
DBMS_OUTPUT.PUT_LINE('* Incidencia HR-371 Correcciones 2 - P.Hipotecario');
DBMS_OUTPUT.PUT_LINE('**************************************************************************************************');

--1.) Inicidencia 1 - No hay que hacer nada, confirmado por Carlos y Mar

--2.) Incidencia 2 - No hay que hacer nada, se resolverá cuando se aclaren los perfiles que deben recibir cada tarea. Actualmente esta la tiene el GESTOR DEUDA
--    Aclarado en Correcciones 1 - P.Hipotecario      

--3.) 
DBMS_OUTPUT.PUT_LINE('--Incidencia 3/1 - H001_ConfirmarSiExisteOposicion-------------------------------------------------');
-- Incidencia 3 - H001_ConfirmarSiExisteOposicion - Si se indica combo = NO hay oposición, no debe requerir fecha, motivo oposicion ni fecha comparecencia
DBMS_OUTPUT.PUT_LINE('--update tfi_tareas_form_items');
update tfi_tareas_form_items set tfi_error_validacion = null, tfi_validacion = null where tfi_nombre in ('fechaOposicion','motivoOposicion') and tap_id in (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H001_ConfirmarSiExisteOposicion');

DBMS_OUTPUT.PUT_LINE('--update tap_tarea_procedimiento');
update tap_tarea_procedimiento set tap_script_validacion_jbpm = '(valores[''H001_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI && (valores[''H001_ConfirmarSiExisteOposicion''][''fechaOposicion''] == null || valores[''H001_ConfirmarSiExisteOposicion''][''motivoOposicion''] == null)) ? ''Si indica que hay oposici&oacute;n, debe registrar tambi&eacute;n "Fecha Oposici&oacute;n" y "Motivo Oposici&oacute;n"'' : null' where tap_codigo = 'H001_ConfirmarSiExisteOposicion';

DBMS_OUTPUT.PUT_LINE('--Incidencia 3/2 - H001_ConfirmarNotificacionReqPago-----------------------------------------------');
-- Incidencia 3 - H001_ConfirmarNotificacionReqPago - Si se indica en combo = Negativo, no debe requerir fecha notificacion
DBMS_OUTPUT.PUT_LINE('--update tfi_tareas_form_items');
update tfi_tareas_form_items set tfi_error_validacion = null, tfi_validacion = null where tfi_nombre = 'fecha' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H001_ConfirmarNotificacionReqPago');

DBMS_OUTPUT.PUT_LINE('--update tap_tarea_procedimiento');
update tap_tarea_procedimiento set tap_script_validacion_jbpm = '(valores[''H001_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO && valores[''H001_ConfirmarNotificacionReqPago''][''fecha''] == null) ? ''Si indica como resultado de notificacion "Positivo", debe informar la "Fecha de Notificaci&oacute;n"'':null' where tap_codigo = 'H001_ConfirmarNotificacionReqPago';

DBMS_OUTPUT.PUT_LINE('--update dd_ptp_plazos_tareas_plazas');
update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'valores[''H001_ConfirmarNotificacionReqPago''][''fecha''] != null ? damePlazo(valores[''H001_ConfirmarNotificacionReqPago''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L' where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H001_ConfirmarSiExisteOposicion');

--4.)
DBMS_OUTPUT.PUT_LINE('--Incidencia 4 - H001_RegistrarCertificadoCargas-------------------------------------------------');
-- Incidencia 4 - H001_RegistrarCertificadoCargas - Si se indica en combo = SI hay cargas previas, se ha de informar cuantia. Si no hay no hace falta informar
DBMS_OUTPUT.PUT_LINE('--update tap_tarea_procedimiento');
update tap_tarea_procedimiento set tap_script_validacion_jbpm = '(valores[''H001_RegistrarCertificadoCargas''][''cargasPrevias''] == DDSiNo.SI && valores[''H001_RegistrarCertificadoCargas''][''cuantiaCargasPrevias''] == null) ? ''Si indica que existen cargas previas, debe informar el campo "Cuant&iacute;a de cargas previas"'':null' where tap_codigo = 'H001_RegistrarCertificadoCargas';

--5.) Incidencia 5 - H001_RegistrarResolucion - Cambiar el plazo incorrecto
--    Corregido en Correcciones 1 - P.Hipotecario

END;
/
commit;
exit;