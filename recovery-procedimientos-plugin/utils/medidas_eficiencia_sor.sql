-- *************************************************************************** --
-- **    aplicar medidas de eficiencia acordades con SOR					** --
-- *************************************************************************** --

-- eliminar la obligatoriedad de introducir el procurador hasta la tarea de tipo confirmar admisión demanda
UPDATE SOR01.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''
WHERE TAP_CODIGO LIKE '%_ConfirmarEnvioDemanda'; 
-- OK
-- Monitorio / Ordinario / Verbal / Hipotecario
UPDATE SOR01.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''
WHERE TAP_CODIGO IN ('P02_InterposicionDemanda', 'P03_InterposicionDemanda', 'P04_InterposicionDemanda', 'P01_DemandaCertificacionCargas'); 
-- ETNJ / ETJ / Cambiario
UPDATE SOR01.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = 'tieneBienes() &&'||' !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p></div>'' : null'
WHERE TAP_CODIGO IN ('P15_InterposicionDemandaMasBienes', 'P16_InterposicionDemanda', 'P17_InterposicionDemandaMasBienes'); 
-- Monitorio / Ordinario / Verbal / ETNJ / ETJ / Hipotecario / Cambiario
UPDATE SOR01.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null'
WHERE TAP_CODIGO IN ('P02_ConfirmarAdmisionDemanda', 'P03_ConfirmarAdmision', 'P04_ConfirmarAdmisionDemanda', 
					'P15_AutoDespaEjecMasDecretoEmbargo', 'P16_AutoDespachando', 'P01_AutoDespachandoEjecucion', 'P17_CnfAdmiDemaDecretoEmbargo');

-- eliminar la obligatoriedad de introducir la plaza y el juzgado.
-- monitorio
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = '', TFI_VALIDACION = ''
WHERE TFI_NOMBRE = 'plazaJuzgado' AND
	  TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P02_InterposicionDemanda');
	  
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
	TFI_VALIDACION = 'valor != null &&'||' valor != '''' ? true : false'
WHERE TFI_NOMBRE = 'nPlaza' AND
	  TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P02_ConfirmarAdmisionDemanda');

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoMonitorio/confirmarAdmisionDemanda'
WHERE TAP_CODIGO = 'P02_ConfirmarAdmisionDemanda';

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoMonitorio/interposicionDemanda'
WHERE TAP_CODIGO = 'P02_InterposicionDemanda';

-- ordinario
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = '', TFI_VALIDACION = ''
WHERE TFI_NOMBRE = 'plazaJuzgado' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P03_InterposicionDemanda');
	  
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
	TFI_VALIDACION = 'valor != null &&'||' valor != '''' ? true : false'
WHERE TFI_NOMBRE = 'nPlaza' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P03_ConfirmarAdmision');

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoOrdinario/confirmarAdmisionDemanda'
WHERE TAP_CODIGO = 'P03_ConfirmarAdmision';

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoOrdinario/interposicionDemanda'
WHERE TAP_CODIGO = 'P03_InterposicionDemanda';

-- Verbal
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = '', TFI_VALIDACION = ''
WHERE TFI_NOMBRE = 'comboPlaza' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P04_InterposicionDemanda');
	  
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
	TFI_VALIDACION = 'valor != null &&'||' valor != '''' ? true : false'
WHERE TFI_NOMBRE = 'comboPlaza' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P04_ConfirmarAdmisionDemanda');

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoVerbal/confirmarAdmisionDemanda'
WHERE TAP_CODIGO = 'P04_ConfirmarAdmisionDemanda';

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoVerbal/interposicionDemanda'
WHERE TAP_CODIGO = 'P04_InterposicionDemanda';

-- Hipotecario
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = '', TFI_VALIDACION = ''
WHERE TFI_NOMBRE = 'plazaJuzgado' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P01_DemandaCertificacionCargas');
	  
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
	TFI_VALIDACION = 'valor != null &&'||' valor != '''' ? true : false'
WHERE TFI_NOMBRE = 'nPlaza' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P01_AutoDespachandoEjecucion');

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoHipotecario/autoDespachandoEjecucion'
WHERE TAP_CODIGO = 'P01_AutoDespachandoEjecucion';

-- ETNJ
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = '', TFI_VALIDACION = ''
WHERE TFI_NOMBRE = 'nPlaza' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P15_InterposicionDemandaMasBienes');
	  
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
	TFI_VALIDACION = 'valor != null &&'||' valor != '''' ? true : false'
WHERE TFI_NOMBRE = 'comboPlaza' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P15_AutoDespaEjecMasDecretoEmbargo_new1');

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoETNJ/autoDespachandoEjecucion'
WHERE TAP_CODIGO = 'P15_AutoDespaEjecMasDecretoEmbargo_new1';

-- ETJ
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = '', TFI_VALIDACION = ''
WHERE (TFI_NOMBRE = 'plazaJuzgado' OR TFI_NOMBRE = 'numJuzgado') AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P16_InterposicionDemanda');

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoETJ/interposicionDemanda'
WHERE TAP_CODIGO = 'P16_InterposicionDemanda';

UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ORDEN = 5 
WHERE TFI_NOMBRE = 'comboSiNo' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P16_AutoDespachando_new1');

UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ORDEN = 6 
WHERE TFI_NOMBRE = 'comboBienesRegistrables' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P16_AutoDespachando_new1');
	  
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ORDEN = 7 
WHERE TFI_NOMBRE = 'observaciones' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P16_AutoDespachando_new1');	

Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 3, 'combo', 'plazaJuzgado', 'Plaza del juzgado', 'TipoPlaza', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'damePlaza()', 0, 'DD', SYSDATE, 0);
Insert into TFI_TAREAS_FORM_ITEMS(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, TFI_VALIDACION, TFI_ERROR_VALIDACION, TFI_VALOR_INICIAL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_TFI_TAREAS_FORM_ITEMS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando_new1'), 4, 'combo', 'numJuzgado', 'Nº de juzgado', 'TipoJuzgado', 'valor != null &&'||' valor != '''' ? true : false', 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 'dameNumJuzgado()', 0, 'DD', SYSDATE, 0);

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoETJ/autoDespachandoEjecucion'
WHERE TAP_CODIGO = 'P16_AutoDespachando_new1';

-- Cambiario
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = '', TFI_VALIDACION = ''
WHERE TFI_NOMBRE = 'plazaJuzgado' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P17_InterposicionDemandaMasBienes');
	  
UPDATE TFI_TAREAS_FORM_ITEMS 
SET TFI_ERROR_VALIDACION = 'tareaExterna.error.PGENERICO_TareaGenerica.campoObligatorio', 
	TFI_VALIDACION = 'valor != null &&'||' valor != '''' ? true : false'
WHERE TFI_NOMBRE = 'comboPlaza' AND
	  TAP_ID IN (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = 'P17_CnfAdmiDemaDecretoEmbargo_new1');

UPDATE TAP_TAREA_PROCEDIMIENTO 
SET TAP_VIEW = 'plugin/procedimientos/SANprocedimientoCambiario/confirmarAdmisionDemanda'
WHERE TAP_CODIGO = 'P17_CnfAdmiDemaDecretoEmbargo_new1';

-- eliminar obligatoriedad en el ETJ de introducir la fecha de recepción de la documentación
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALIDACION = '', TFI_ERROR_VALIDACION = ''
WHERE 	TAP_ID = (select TAP_ID from SOR01.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_ConfirmarEnvioDemanda') AND
		TFI_NOMBRE = 'fechaRecepcion';

-- MODIFICAR PLAZOS
-- Confirmar admisión de la demanda 
	-- MONITORIO
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P02_InterposicionDemanda''][''fechaSolicitud'']) + 50*24*60*60*1000L'
WHERE TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_ConfirmarAdmisionDemanda');
	-- ORDINARIO
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 50*24*60*60*1000L'
WHERE TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_ConfirmarAdmision');
	-- VERBAL
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 50*24*60*60*1000L'
WHERE TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_ConfirmarAdmisionDemanda');
-- Auto despachando ejecución + Marcado de bienes decreto de embargo
	-- ETJ
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P16_InterposicionDemanda''][''fecha'']) + 50*24*60*60*1000L'
WHERE TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando');	
	-- ETNJ
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P15_InterposicionDemandaMasBienes''][''fechaInterposicion'']) + 50*24*60*60*1000L'
WHERE TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo');	
	-- HIPOTECARIO
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P01_DemandaCertificacionCargas''][''fechaSolicitud'']) + 50*24*60*60*1000L'
WHERE TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_AutoDespachandoEjecucion');
-- Registrar Resolución
	-- HIPOTECARIO
UPDATE DD_PTP_PLAZOS_TAREAS_PLAZAS SET DD_PTP_PLAZO_SCRIPT = 'damePlazo(valores[''P01_RegistrarComparecencia''][''fecha'']) + 30*24*60*60*1000L'
WHERE TAP_ID IN (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_RegistrarResolucion');

