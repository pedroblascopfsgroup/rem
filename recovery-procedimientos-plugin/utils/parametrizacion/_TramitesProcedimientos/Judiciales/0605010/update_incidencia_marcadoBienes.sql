-- *************************************************************************** --
-- **                   											   		 * --			  
-- *************************************************************************** --

-- Ejecucion titulo judicial
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p></div>'' : null) '
WHERE TAP_CODIGO = 'P16_InterposicionDemanda';

-- Ejecucion titulo No judicial
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p></div>'' : null) '
WHERE TAP_CODIGO = 'P15_InterposicionDemandaMasBienes';

-- procedimiento cambiario
UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p></div>'' : null) '
WHERE TAP_CODIGO = 'P17_InterposicionDemandaMasBienes';
