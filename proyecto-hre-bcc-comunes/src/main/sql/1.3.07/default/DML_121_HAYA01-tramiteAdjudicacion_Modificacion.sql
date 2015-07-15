SET DEFINE OFF;

--HR-523
update tap_tarea_procedimiento set tap_script_validacion_jbpm = 'comprobarInformadoComboTributacion ? null : ''Es necesario informar el tipo de tributación''' where tap_codigo =  'H005_notificacionDecretoAdjudicacionAEntidad';

--HR-537
update tfi_tareas_form_items set tfi_error_validacion = 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio'
	, tfi_validacion = 'valor != null && valor != '''' ? true : false'  where tfi_nombre = 'fecha' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H066_validarMinuta');

--HR-575
update tap_tarea_procedimiento 
	set tap_script_validacion_jbpm = 'comprobarGestoriaAsignadaAlSaneamientoDeCargasDeBienes() ? null : ''Debe asignar la Gestor&iacute;a encargada del saneamiento de cargas del bien.'''
where tap_codigo = 'H005_RegistrarInscripcionDelTitulo';
-- Se elimina validación de doc adjunto: comprobarAdjuntoDocumentoTestimonioInscritoEnRegistro() ? null : 'Debe adjuntar el Documento de Testimonio inscrito en el Registro.'

update tfi_tareas_form_items set tfi_error_validacion = null
	, tfi_validacion = null where tfi_nombre = 'fechaInscripcion' and tap_id = (select tap_id from tap_tarea_procedimiento where tap_codigo = 'H005_RegistrarInscripcionDelTitulo');

update tap_tarea_procedimiento set tap_script_validacion_jbpm = '((valores[''H005_RegistrarInscripcionDelTitulo''][''comboSituacionTitulo''] == DDSituacionTitulo.PEN))?  null : ''Para la situación de titulo escogida, es necesario indicar la fecha de inscripción''' 
	where tap_codigo = 'H005_RegistrarInscripcionDelTitulo'; 
-- Se hace la fecha inscripcion obligatoria segun los valores del combo (2 updates)

commit;