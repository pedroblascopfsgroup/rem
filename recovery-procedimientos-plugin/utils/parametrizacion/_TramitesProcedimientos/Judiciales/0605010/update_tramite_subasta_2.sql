-- *************************************************************************** --
-- **                   Actualizar la tarea Solicitud de subasta             * --
-- ** y la tarea Anuncio subasta para que no exiga en la primera las    	 * --
-- **  mirutas y si en la segunda  + OJO = P11_AnuncioSubasta_new1	   		 * --			  
-- *************************************************************************** --

-- solicitud de subasta

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALIDACION = '', TFI_ERROR_VALIDACION = ''
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_SolicitudSubasta') AND
		TFI_NOMBRE = 'costasLetrado';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALIDACION = '', TFI_ERROR_VALIDACION = ''
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_SolicitudSubasta') AND
		TFI_NOMBRE = 'costasProcurador';

-- Anuncio de subasta

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = 5
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta') AND
		TFI_NOMBRE = 'observaciones';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta'), 3, 'currency', 'costasLetrado', 'Costas letrado', 'valores[''P11_SolicitudSubasta''][''costasLetrado'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta'), 4, 'currency', 'costasProcurador', 'Costas procurador', 'valores[''P11_SolicitudSubasta''][''costasProcurador'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = 6
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1') AND
		TFI_NOMBRE = 'observaciones';

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 4, 'currency', 'costasLetrado', 'Costas letrado', 'valores[''P11_SolicitudSubasta''][''costasLetrado'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL ,TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1'), 5, 'currency', 'costasProcurador', 'Costas procurador', 'valores[''P11_SolicitudSubasta''][''costasProcurador'']', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);


-- Dictar instrucciones

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALOR_INICIAL = ' valores[''P11_AnuncioSubasta''] == null ? (valores[''P11_AnuncioSubasta_new1''][''costasLetrado''] == null ? valores[''P11_SolicitudSubasta''][''costasLetrado''] : valores[''P11_AnuncioSubasta_new1''][''costasLetrado'']) : (valores[''P11_AnuncioSubasta''][''costasLetrado''] == null ? valores[''P11_SolicitudSubasta''][''costasLetrado''] : valores[''P11_AnuncioSubasta''][''costasLetrado'']) '
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones') AND
		TFI_NOMBRE = 'costasLetrado';

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALOR_INICIAL = ' valores[''P11_AnuncioSubasta''] == null ? (valores[''P11_AnuncioSubasta_new1''][''costasProcurador''] == null ? valores[''P11_SolicitudSubasta''][''costasProcurador''] : valores[''P11_AnuncioSubasta_new1''][''costasProcurador'']) : (valores[''P11_AnuncioSubasta''][''costasProcurador''] == null ? valores[''P11_SolicitudSubasta''][''costasProcurador''] : valores[''P11_AnuncioSubasta''][''costasProcurador'']) '
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_DictarInstrucciones') AND
		TFI_NOMBRE = 'costasProcurador';
		
