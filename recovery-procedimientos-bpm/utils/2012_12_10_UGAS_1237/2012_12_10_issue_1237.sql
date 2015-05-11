-- Se añade un campo nuevo al P60_RegistrarAnotacion del procedimiento de vigilancia caducacion anotacion 
SET DEFINE OFF;
Update TFI_TAREAS_FORM_ITEMS set TFI_ORDEN = 3 where TFI_ID = 2408;
COMMIT;
Insert into TFI_TAREAS_FORM_ITEMS
   (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (2407, 901, 2, 'combo', 'repetir', 'Activar alerta periódica', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'valor != null && valor != '''' ? true : false', 'DDSiNo', 0, 'DD', sysdate, 0);
COMMIT;