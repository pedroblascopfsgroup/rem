-- *************************************************************************** --
-- **  Agregar un nuevo campo en la tarea Trámite de adjudicación			 * -- 
-- *************************************************************************** --


UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = '3'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_RegistrarAutoAdjudicacion') AND
		TFI_NOMBRE = 'observaciones';
		
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Auto de Adjudicaci&'||'oacute;n a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p><p style="margin-bottom: 10px">Se ha de incluir tambi&'||'eacute;n la cuant&'||'iacute;a definitiva que aparece en el Auto de Adjudicaci&'||'oacute;n por el que se ha adjudicado la Entidad. Tambi&'||'eacute;n es un dato importante para realizar la liquidaci&'||'oacute;n de impuestos.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_RegistrarAutoAdjudicacion') AND
		TFI_NOMBRE = 'titulo';

INSERT into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_RegistrarAutoAdjudicacion'), 2, 'currency', 'cuantiaAdjudicacion', 'Cuantía adjudicación', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
		
		
