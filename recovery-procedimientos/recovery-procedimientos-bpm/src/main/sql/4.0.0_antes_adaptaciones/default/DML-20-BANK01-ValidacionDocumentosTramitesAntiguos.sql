UPDATE tap_tarea_procedimiento
   SET tap_script_validacion =
          '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (comprobarExisteDocumentoDSCC() ? null : ''Es necesario adjuntar el documento demanda sellada + certificación de cargas (cuando se obtenga)'')'
 WHERE tap_codigo = 'P01_DemandaCertificacionCargas';
 
update tap_tarea_procedimiento
    set tap_script_validacion = 
        '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (comprobarExisteDocumentoDSO() ? null : ''Es necesario adjuntar el documento demanda sellada'')'
 WHERE TAP_CODIGO = 'P03_InterposicionDemanda';
 
 
update tap_tarea_procedimiento
    set tap_script_validacion = 
        '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (comprobarExisteDocumentoDSV() ? null : ''Es necesario adjuntar el documento demansa sellada'')'
 WHERE TAP_CODIGO = 'P04_InterposicionDemanda';
 
 update tap_tarea_procedimiento
    set tap_script_validacion = 
        'comprobarExisteDocumentoESI() ? null : ''Es necesario adjuntar el documento escrito de insinuación'''
 WHERE TAP_CODIGO = 'P412_regInsinuacionCreditosSup';
 

--Pendiente saber si F común abreviado se implementa en BANKIA
--  update tap_tarea_procedimiento
--    set tap_script_validacion = 
--        'comprobarExisteDocumentoESI() ? null : ''Es necesario adjuntar el documento escrito de insinuación'''
-- WHERE TAP_CODIGO = 'P24_regInsinuacionCreditosSup';
 
 
 