--Corrección de decisiones para verificar dependiendo de los tipos de cargas activas
update tap_tarea_procedimiento set tap_script_decision = 'obtenerTipoCargaBien() == ''noCargas'' ? ''noCargas'' : (obtenerTipoCargaBien() == ''registrales'' ? ''soloRegistrales'' : ''conEconomicas'')' where tap_codigo = 'H008_RevisarEstadoCargas';
update tap_tarea_procedimiento set tap_script_decision = 'obtenerTipoCargaBien() == ''economicas'' ? ''soloEconomicas'' : ''conRegistrales''' where tap_codigo = 'H008_RegInsCancelacionCargasEconomicas';

--Corrección de plazos de tareas:
update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = '5*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RevisarEstadoCargas');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RevisarEstadoCargas''][''fechaCargas''])+10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegistrarPresentacionInscripcion');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RegistrarPresentacionInscripcion''][''fechaPresentacion''])+30*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegInsCancelacionCargasReg');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RevisarEstadoCargas''][''fechaCargas''])+10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_PropuestaCancelacionCargas');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_PropuestaCancelacionCargas''][''fechaPropuesta''])+5*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RevisarPropuestaCancelacionCargas');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RevisarPropuestaCancelacionCargas''][''fechaRevisar''])+10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_LiquidarCargas');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_LiquidarCargas''][''fechaCancelacion''])+10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegInsCancelacionCargasRegEco');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RegInsCancelacionCargasRegEco''][''fechaInsReg''])+10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegistrarPresentacionInscripcionEco');

update dd_ptp_plazos_tareas_plazas set dd_ptp_plazo_script = 'damePlazo(valores[''H008_RegistrarPresentacionInscripcionEco''][''fechaPresentacion''])+30*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegInsCancelacionCargasEconomicas');


--Título de tarea sin texto, solo aparece nombre de la tarea como titulo.:
update tfi_tareas_form_items set tfi_label = '<div style="FONT-SIZE: 8pt; MARGIN-BOTTOM: 30px; FONT-FAMILY: Arial" align="justify"><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Para dar por terminada esta tarea deberá informar de registrar la fecha en que haya presentado la cancelación para la inscripción de todas las cargas marcadas en la ficha de los bienes subastados de tipo “Registral” cargas. Cargas registrales no económicas que hayan quedado marcadas en la tarea anterior.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">En el campo observaciones informar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="font-family: Arial; text-align: justify; margin-bottom: 10px; ">Una vez complete esta pantalla la siguiente tarea será “Registrar cancelación de cargas registrales”.</p></div>'
where tfi_nombre = 'titulo' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H008_RegistrarPresentacionInscripcionEco');

--Quitar validacion de doc adjunto
--comprobarExisteDocumentoPCC() ? null : 'Es necesario adjuntar el documento propuesta de cancelación de las cargas'
--Se elimina esta validación de doc. adjunto porque ya se requiere en el t. elevacion Sareb
update tap_tarea_procedimiento set tap_script_validacion = null where tap_codigo = 'H008_PropuestaCancelacionCargas';


commit;