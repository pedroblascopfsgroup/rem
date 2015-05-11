-- *************************************************************************** --
-- **    Actualizar las vistas de los procedimientos según especificaciones ** --
-- **	para los plugins	                								** --
-- *************************************************************************** --

UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = replace(TAP_VIEW, 'pfsgroup/', 'plugin/procedimientos/') WHERE TAP_VIEW <> 'null';

-- INCIDENCIAS + combo paginado
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_TIPO = 'textproc' WHERE TFI_ORDEN = 4 AND TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P32_confAdmisionDemanda');

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_AutoDespachandoEjecucion' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P01') ) 
		AND TFI_NOMBRE = 'nPlaza';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P17') ) 
		AND TFI_NOMBRE = 'comboPlaza';

UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = 'tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p></div>'' : null'
WHERE  TAP_CODIGO = 'P17_CnfAdmiDemaDecretoEmbargo';

-- todos los verbales
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_ConfirmarAdmisionDemanda')  
		AND TFI_NOMBRE = 'comboPlaza';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P15') ) 
		AND TFI_NOMBRE = 'comboPlaza';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P32_confAdmisionDemanda') 
		AND TFI_NOMBRE = 'comboPlaza';
		
-- todos los verbales
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_ConfirmarAdmision')  
		AND TFI_NOMBRE = 'nPlaza';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_ConfirmarAdmisionDemanda') 
		AND TFI_NOMBRE = 'nPlaza';

UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P32_autoJuzgadoPenal') 
		AND TFI_NOMBRE = 'plazaJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P32_autoJuzgadoPenal') 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P32_autoJuzgadoPenal') 
		AND TFI_NOMBRE = 'procedimiento';
		
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P22_ConfirmarAdmision') 
		AND TFI_NOMBRE = 'nPlaza';
		
-- nuevo combo
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P15_InterposicionDemandaMasBienes';
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P01_DemandaCertificacionCargas';
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P17_InterposicionDemandaMasBienes';
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P04_InterposicionDemanda'; -- todos los verbales
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P42_PagoDeImpuestos';
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P32_interposicionDemandaQuerella' OR TAP_CODIGO = 'P32_autoJuzgadoPenal';
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P03_InterposicionDemanda'; -- todos los ordinarios
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P02_InterposicionDemanda'; 
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda' WHERE TAP_CODIGO = 'P22_SolicitudConcursal'; 
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = 'plugin/procedimientos/ejecucionTituloJudicial/interposicionDemanda' WHERE TAP_CODIGO = 'P26_notificacionDemandaIncidental';
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW = '' WHERE TAP_CODIGO = 'P25_confirmarAdmisionDemanda';
