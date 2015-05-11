SET DEFINE OFF;

--HR-535
update tap_tarea_procedimiento set tap_script_decision = '(obtenerTipoCargaBien() == ''registrales'' || obtenerTipoCargaBien() == ''ambos'') ?  ''conRegistrales'' : ''soloEconomicas''' 
where tap_codigo = 'H008_RegInsCancelacionCargasEconomicas';


--HR-570
update tap_tarea_procedimiento
set tap_script_validacion_jbpm = '(valores[''H021_registrarOposicion''][''comboOposicion''] == DDSiNo.SI) ? (((valores[''H021_registrarOposicion''][''fechaOposicion''] == null) || (valores[''H021_registrarOposicion''][''fechaVista''] == null)) ? ''tareaExterna.error.faltaAlgunaFecha'' : comprobarExisteDocumentoEOSC() ? null : ''Es necesario adjuntar el Escrito de Oposici&oacute;n (Solicitud concursal).'' ) : null'
where tap_codigo = 'H021_registrarOposicion';

--HR-542
update tfi_tareas_form_items 
set tfi_error_validacion = null
, tfi_validacion = null
where 
tfi_nombre = 'fecha'
and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H035_registrarOposicion');


--HR-391
update dd_ptp_plazos_tareas_plazas
set dd_ptp_plazo_script = 'valoresBPMPadre[''H012_RespuestaSareb''][''fecha''] + 2*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H031_ValidarInstrucciones');


--HR-523
update tap_tarea_procedimiento set tap_script_validacion_jbpm = 'comprobarInformadoComboTributacion() ? null : ''Es necesario informar el tipo de tributaci&oacute;n''' 
	where tap_codigo =  'H005_notificacionDecretoAdjudicacionAEntidad';

--HR-535
update tap_tarea_procedimiento 
set tap_script_decision = '(obtenerTipoCargaBien() == ''economicas'' || obtenerTipoCargaBien() == ''noCargas'') ?  ''soloEconomicas'' : ''conRegistrales'''
where tap_codigo = 'H008_RegInsCancelacionCargasEconomicas';


--HR-575
update tfi_tareas_form_items set tfi_error_validacion = null
	, tfi_validacion = null where tfi_nombre = 'fechaInscripcion' and tap_id = (select tap_id from tap_tarea_procedimiento 
where tap_codigo = 'H005_RegistrarInscripcionDelTitulo');

update tfi_tareas_form_items set tfi_error_validacion = null
	, tfi_validacion = null where tfi_nombre = 'fechaEnvioDecretoAdicion' and tap_id = (select tap_id from tap_tarea_procedimiento 
where tap_codigo = 'H005_RegistrarInscripcionDelTitulo');


update tap_tarea_procedimiento
set tap_script_validacion_jbpm = '(valores[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''INS'') ? ((valores[''H005_RegistrarInscripcionDelTitulo''][''fechaInscripcion''] == null || valores[''H005_RegistrarInscripcionDelTitulo''][''fechaInscripcion''] == '''') ? ''Si el t&iacute;tulo se ha inscrito, es necesario indicar la fecha de inscripci&oacute;n'' : null ) : ((valores[''H005_RegistrarInscripcionDelTitulo''][''fechaEnvioDecretoAdicion''] == null || valores[''H005_RegistrarInscripcionDelTitulo''][''fechaEnvioDecretoAdicion''] == '''') ?  ''Si el t&iacute;tulo est&aacute; pde. subsanacion, es necesario indicar la fecha env&iacute;o decreto adici&oacute;n'' : null )'
where tap_codigo = 'H005_RegistrarInscripcionDelTitulo'; 

update dd_ptp_plazos_tareas_plazas
set dd_ptp_plazo_script = 'valoresBPMPadre[''H005_RegistrarInscripcionDelTitulo''] != null ? (valoresBPMPadre[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == ''PEN'' ? (damePlazo(valoresBPMPadre[''H005_ConfirmarTestimonio''][''fechaEnvioGestoria'']) + 5*24*60*60*1000L ) : 10*24*60*60*1000L ) : 10*24*60*60*1000L'
where tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H052_RegistrarPresentacionEscritoSub');


--HR-596


--HR-600
update dd_sit_situacion_titulo
set borrado = 1
where dd_sit_codigo in ('0','1','2','3','4');


commit;

