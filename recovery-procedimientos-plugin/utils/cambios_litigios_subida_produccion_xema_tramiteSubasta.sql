--TRÁMITE SUBASTA
update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez solicitada la subasta, en esta pantalla, debe consignar las fechas de anuncio y celebraci&'||'oacute;n de la misma.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p><p style="margin-bottom: 10px">Una vez rellene &'||'eacute;sta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n&'||'quot;</p><p style="margin-bottom: 10px">De acuerdo al Protocolo de Actuaci&'||'oacute;n Judicial de NGB, una vez conocido el resultado positivo de la solicitud de subasta, y en los 5 d&'||'iacute;as 
siguientes, se deber&'||'aacute;:<ul><li style="margin-left: 2em">- Remitir correo electr&'||'oacute;nico a Gesti&'||'oacute;n de Activos (<a href="mailto:gestiondeactivos@org.es">gestiondeactivos@org.es</a>). A dicho correo deber&'||'aacute; adjuntarse el edicto de subasta, la tasaci&'||'oacute;n de la finca, y la certificaci&'||'oacute;n de cargas.</li>
</br>
<li style="margin-left: 2em">- Analizar la necesidad de solicitar Informe Fiscal, y en caso afirmativo remitir correo electr&'||'oacute;nico a la siguiente direcci&'||'oacute;n: <a href="mailto:dfvazquez@novagalicia.es">dfvazquez@novagalicia.es</a>.</li></ul></p>
</br>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute; &'||'quot;Celebraci&'||'oacute;n subasta y adjudicaci&'||'oacute;n&'||'quot;</p></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_AnuncioSubasta_new1') and tfi_orden = 0;

update tfi_tareas_form_items
set tfi_label = '<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 30px;"><p style="margin-bottom: 10px">Una vez se celebre la subasta, en esta pantalla debe introducir quien se ha adjudicado el bien y el importe de adjudicaci&'||'oacute;n.</p><p style="margin-bottom: 10px">En el campo observaciones consignar cualquier aspecto relevante que le interesa quede reflejado en ese punto del procedimiento.</p>
<p style="margin-bottom: 10px">Posterior asimismo a la celebraci&'||'oacute;n de la subasta, y de acuerdo al Protocolo de Actuaci&'||'oacute;n Judicial de NGB se deber&'||'aacute; enviar correo electr&'||'oacute;nico a Gesti&'||'oacute;n de Activos informando del resultado de la subasta</p>
<p style="margin-bottom: 10px">La cesi&'||'oacute;n de remate deber&'||'aacute; realizarse en un plazo de 10 días como m&'||'aacute;ximo desde la fecha de subasta.</p>
<p style="margin-bottom: 10px">Una vez rellene esta pantalla la siguiente tarea ser&'||'aacute;:</p><ul style="list-style-type: square;"><li style="margin-bottom: 10px; margin-left: 35px;">Si el bien se lo han adjudicado terceros: Solicitud mandamiento de pago.</li><li style="margin-bottom: 10px; margin-left: 35px;">Si el bien se lo ha adjudicado la entidad se le abrir&'||'aacute; una tarea en la que propondr&'||'aacute;, seg&'||'uacute;n su criterio, la siguiente actuaci&'||'oacute;n al responsable de la entidad.</li></ul></div>'
where tap_id = (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P11_CelebracionSubasta') and tfi_orden = 0;

