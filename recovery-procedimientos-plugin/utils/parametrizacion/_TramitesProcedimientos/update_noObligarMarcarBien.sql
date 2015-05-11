-- *************************************************************************** --
-- **    Actualizar la primera tarea de los procedimientos que obligan a    ** --
-- **	marcar los bienes 	                								** --
-- *************************************************************************** --

UPDATE TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = replace(TAP_SCRIPT_VALIDACION, 
'<p>¡Atenci&'||'oacute;n! Debe marcar los bienes sobre los que solicita embargo.</p>', 
'<div id="permiteGuardar"><p>¡Atenci&'||'oacute;n! En  caso de que haya bienes a embargar, deber&'||'iacute;a de marcarlos a trav&'||'eacute;s de la pestaña Bienes dentro de la ficha de la propia actuaci&'||'oacute;n.</p></div>');
