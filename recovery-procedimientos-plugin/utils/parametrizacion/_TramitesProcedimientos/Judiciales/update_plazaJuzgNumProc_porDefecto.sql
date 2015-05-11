-- *************************************************************************** --
-- **                   Se actualizan los campos plaza / juzgado y numero de * -- 
-- ** procedimiento para que cogan valores por defecto en caso de haberlos. ** --
-- *************************************************************************** --

-- verbal
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04') ) 
		AND TFI_NOMBRE = 'comboPlaza';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_ConfirmarAdmisionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04') ) 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P04_ConfirmarAdmisionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P04') ) 
		AND TFI_NOMBRE = 'numProcedimiento';
		
--  Ejecución de titulo judicial
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P16') ) 
		AND TFI_NOMBRE = 'plazaJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P16') ) 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P16_AutoDespachando' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P16') ) 
		AND TFI_NOMBRE = 'nProc';

--  Procedimiento Hipotecario
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_DemandaCertificacionCargas' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P01') ) 
		AND TFI_NOMBRE = 'plazaJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_AutoDespachandoEjecucion' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P01') ) 
		AND TFI_NOMBRE = 'nPlaza';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_AutoDespachandoEjecucion' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P01') ) 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P01_AutoDespachandoEjecucion' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P01') ) 
		AND TFI_NOMBRE = 'numProcedimiento';

--  Ejecución de titulo no judicial
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_InterposicionDemandaMasBienes' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P15') ) 
		AND TFI_NOMBRE = 'nPlaza';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P15') ) 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P15_AutoDespaEjecMasDecretoEmbargo' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P15') ) 
		AND TFI_NOMBRE = 'numProcedimiento';

--  Procedimiento cambiario
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_InterposicionDemandaMasBienes' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P17') ) 
		AND TFI_NOMBRE = 'plazaJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P17') ) 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P17_CnfAdmiDemaDecretoEmbargo' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P17') ) 
		AND TFI_NOMBRE = 'numProcedimiento';		
		
--  Procedimiento ordinario
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03') ) 
		AND TFI_NOMBRE = 'plazaJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_ConfirmarAdmision' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03') ) 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P03_ConfirmarAdmision' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P03') ) 
		AND TFI_NOMBRE = 'numProcedimiento';		
		
--  Procedimiento monitorio
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'damePlaza()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_InterposicionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P02') ) 
		AND TFI_NOMBRE = 'plazaJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumJuzgado()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_ConfirmarAdmisionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P02') ) 
		AND TFI_NOMBRE = 'numJuzgado';
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P02_ConfirmarAdmisionDemanda' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P02') ) 
		AND TFI_NOMBRE = 'numProcedimiento';	

--  Procedimiento Verbal desde Monitorio 
UPDATE TFI_TAREAS_FORM_ITEMS SET TFI_VALOR_INICIAL = 'dameNumAuto()'
WHERE 	TAP_ID = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P21_RegistrarJuicioVerbal' AND DD_TPO_ID = (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P21') ) 
		AND TFI_NOMBRE = 'numProcedimiento';
		
		