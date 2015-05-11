-- *************************************************************************** --
-- **                   Actualizar la tarea de intereses		             * --
-- ** se quiere dar lña posibilidad de indicar si hay o no impugnación		 * --
-- ** en caso de que la haya la fecha de impugnación será obligatoria		 * --	  
-- *************************************************************************** --

-- Pantalla 6

UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_LABEL = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">En esta pantalla, se ha de consignar si se ha producido impugnaci&'||'oacute;n o no junto a la fecha de celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">Del mismo modo consignar si se va ha producir Vista junto a la fecha de celebraci&'||'oacute;n de la misma. Para el supuesto en el que no vaya haber vista no será obligatorio consignar la fecha de celebración de la misma.</p><p style="margin-bottom: 10px">Para los supuesto en los que se señale que si que va a ver vista, la siguiente tarea sea &'||'quot;Registrar vista&'||'quot;. Para los supuestos en los que no vaya a ver vista la siguiente tarea ser&'||'aacute; toma de decisi&'||'oacute;n sobre la continuidad del procedimiento.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'titulo';
	  
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_VALIDACION = '', TFI_ERROR_VALIDACION = '', TFI_ORDEN = '2', TFI_LABEL = 'Fecha impugnación'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'fecha';
	  
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = '3'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'comboSiNo';
	  
UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = '4'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'fechaVista';

	  UPDATE TFI_TAREAS_FORM_ITEMS
SET TFI_ORDEN = '5'
WHERE TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion') AND
	  TFI_NOMBRE = 'observaciones';
	  
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P10_RegistrarImpugnacion'), 1, 'combo', 'comboImpugnacion', 'Hay impuganción', 'DDSiNo', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 0, 'DD', SYSDATE, 0);	  

UPDATE TAP_TAREA_PROCEDIMIENTO
SET TAP_SCRIPT_VALIDACION_JBPM = '((valores[''P10_RegistrarImpugnacion''][''comboImpugnacion''] == DDSiNo.SI) &&'||' (valores[''P10_RegistrarImpugnacion''][''fecha''] == '''')) ? ''tareaExterna.error.P10_RegistrarImpugnacion.fechaImpugObligatoria'': (((valores[''P10_RegistrarImpugnacion''][''comboSiNo''] == DDSiNo.SI) &&'||' (valores[''P10_RegistrarImpugnacion''][''fechaVista''] == ''''))?''tareaExterna.error.P10_RegistrarImpugnacion.fechasOblgatorias'':null)'
WHERE DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P10') AND
	  TAP_CODIGO = 'P10_RegistrarImpugnacion';


