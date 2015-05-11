--HR-459
update tap_tarea_procedimiento
	set tap_script_validacion = 'comprobarBienAsociadoPrc() ? (comprobarTipoCargaBienIns() ? null : ''Para cada una de las cargas, debe especificar el tipo y estado.''): ''Debe tener un bien asociado al procedimiento'''
where
	tap_codigo = 'H008_RevisarEstadoCargas';


commit;