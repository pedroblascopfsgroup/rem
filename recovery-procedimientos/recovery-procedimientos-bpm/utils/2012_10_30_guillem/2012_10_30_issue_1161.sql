-- Borrado de la validación campo requerido de la fecha de acptación
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALIDACION = '' WHERE TAP_ID = 419 AND TFI_NOMBRE = 'fechaAceptacion';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ERROR_VALIDACION = '' WHERE TAP_ID = 419 AND TFI_NOMBRE = 'fechaAceptacion';