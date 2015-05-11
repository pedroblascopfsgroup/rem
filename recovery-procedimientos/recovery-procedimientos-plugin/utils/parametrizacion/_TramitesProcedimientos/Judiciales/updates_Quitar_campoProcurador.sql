-- ********************************************************************************** --
-- **      Actualizar Judiciales, campos de las tareas que tienen procurador 	   ** --
-- ** para que no tengan en cuenta el campo procurador							   ** --
-- ********************************************************************************** --

-- Hipotecario
-- validación de la tarea
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO = 'P01_DemandaCertificacionCargas';
-- modificacion de la descripción
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda con solicitud de certificaci&'||'oacute;n de cargas e ind&'||'iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Auto despachando ejecuci&'||'oacute;n&'||'quot;. </p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas') AND TFI_NOMBRE = 'titulo';
-- actualñización del orden de los campos en la tarea
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas') AND TFI_NOMBRE = 'observaciones';
-- eliminación del campo procurador de la tarea
DELETE FROM TFI_TAREAS_FORM_ITEMS 
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas') AND TFI_NOMBRE = 'procurador';

-- Ejecucion titulo judicial
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO = 'P16_InterposicionDemanda';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda. Ind&'||'iacute;quese la plaza y n&'||'uacute;mero de  juzgado.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Confirmar admisi&'||'oacute;n de la demanda + marcado de bienes decreto embargo&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_InterposicionDemanda') AND TFI_NOMBRE = 'titulo';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 4
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_InterposicionDemanda') AND TFI_NOMBRE = 'observaciones';

DELETE FROM TFI_TAREAS_FORM_ITEMS 
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_InterposicionDemanda') AND TFI_NOMBRE = 'procurador';

-- Verbal
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO = 'P04_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04');

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda e ind&'||'iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Confirmar admisi&'||'oacute;n de la demanda&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04')) AND TFI_NOMBRE = 'titulo';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04')) AND TFI_NOMBRE = 'observaciones';

DELETE FROM TFI_TAREAS_FORM_ITEMS 
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04')) AND TFI_NOMBRE = 'procurador';

-- Ejecucion titulo No judicial
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO = 'P15_InterposicionDemandaMasBienes';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda e ind&'||'iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Auto despachando ejecuci&'||'oacute;n + marcado de bienes decreto embargo&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_InterposicionDemandaMasBienes') AND TFI_NOMBRE = 'titulo';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_InterposicionDemandaMasBienes') AND TFI_NOMBRE = 'observaciones';

DELETE FROM TFI_TAREAS_FORM_ITEMS 
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_InterposicionDemandaMasBienes') AND TFI_NOMBRE = 'procurador';

-- procedimiento cambiario
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO = 'P17_InterposicionDemandaMasBienes';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda e ind&'||'iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">Usted debe introducir la fecha de solicitud de embargo para cada uno de los bienes en la pestaña de &'||'quot;Bienes&'||'quot;.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Auto despachando ejecuci&'||'oacute;n + marcado de bienes decreto embargo&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_InterposicionDemandaMasBienes') AND TFI_NOMBRE = 'titulo';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_InterposicionDemandaMasBienes') AND TFI_NOMBRE = 'observaciones';

DELETE FROM TFI_TAREAS_FORM_ITEMS 
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_InterposicionDemandaMasBienes') AND TFI_NOMBRE = 'procurador';

-- procedimiento ordinario
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO = 'P03_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03');

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda e ind&'||'iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Confirmar admisi&'||'oacute;n de la demanda&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03')) AND TFI_NOMBRE = 'titulo';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03')) AND TFI_NOMBRE = 'observaciones';

DELETE FROM TFI_TAREAS_FORM_ITEMS 
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03')) AND TFI_NOMBRE = 'procurador';

-- procedimiento monitorio
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO = 'P02_InterposicionDemanda';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n de la demanda e ind&'||'iacute;quese la plaza del juzgado.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Confirmar admisi&'||'oacute;n de la demanda&'||'quot;.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_InterposicionDemanda') AND TFI_NOMBRE = 'titulo';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN = 3
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_InterposicionDemanda') AND TFI_NOMBRE = 'observaciones';

DELETE FROM TFI_TAREAS_FORM_ITEMS 
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_InterposicionDemanda') AND TFI_NOMBRE = 'procurador';
