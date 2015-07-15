update tap_tarea_procedimiento set tap_script_validacion='comprobarAdjuntoDecretoFirmeAdjudicacion() ? comprobarExisteDocumentoMP()? null : ''Debe adjuntar el Mandamiento de Pago'' : ''Debe adjuntar el Decreto Firme de Adjudicacion.'' ' where tap_codigo='H005_ConfirmarTestimonio';

commit;