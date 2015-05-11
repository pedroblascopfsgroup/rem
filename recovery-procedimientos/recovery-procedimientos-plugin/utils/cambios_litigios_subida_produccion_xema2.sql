--TRÁMITE ADJUDICACIÓN

update TFI_TAREAS_FORM_ITEMS
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Consignar fecha de presentaci&'||'oacute;n en el Juzgado del escrito de solicitud de Decreto de Adjudicaci&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_SolicitudTramiteAdjudicacion') and tfi_nombre = 'titulo';


update TFI_TAREAS_FORM_ITEMS
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Se ha de marcar la fecha que el Juzgado hace entrega del Testimonio del Decreto a favor de la Entidad. Se ha de tener en cuenta que desde la fecha que se indique en esta pantalla se inicia el plazo para liquidar los impuestos que correspondan.</p>
<p style="margin-bottom: 10px">Se ha de incluir tambi&'||'eacute;n la cuant&'||'iacute;a definitiva que aparece en el Decreto por el que se ha adjuidado la entidad. Tambi&'||'eacute;n es un dato importante para realizar la liquidaci&'||'oacute;n de impuestos.</p>
<p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P05_RegistrarAutoAdjudicacion') and tfi_nombre = 'titulo';

update tap_tarea_procedimiento
set tap_descripcion = 'Confirmar testimonio decreto adjudicación'
where tap_codigo = 'P05_RegistrarAutoAdjudicacion';
commit;