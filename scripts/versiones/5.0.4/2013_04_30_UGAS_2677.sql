--1+1 registros
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, tfi_error_validacion,tfi_validacion, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_TFI_tareas_FORM_ITEMS.nextval, 240, 5, 'number', 'principalDemanda', 'Principal de la demanda','tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio','valor != null && valor != '' ? true : false', 0, 'Oscar', sysdate, 0);

update tfi_tareas_form_items set tfi_orden = 6 where tfi_nombre='observaciones' and tfi_tipo='textarea' and tap_id=240;