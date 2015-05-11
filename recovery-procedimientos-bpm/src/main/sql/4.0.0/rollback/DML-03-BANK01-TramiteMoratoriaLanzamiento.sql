DELETE
FROM tfi_tareas_form_items
WHERE tfi_id IN
  (SELECT tfi.tfi_id
  FROM tfi_tareas_form_items tfi
  INNER JOIN tap_tarea_procedimiento tap
  ON tap.tap_id       = tfi.tap_id
  WHERE tap.dd_tpo_id =
    (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P418'
    )
  );

 DELETE FROM DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE 
  DD_PTP_id IN
  (SELECT PTP.DD_PTP_ID
  FROM DD_PTP_PLAZOS_TAREAS_PLAZAS PTP
  INNER JOIN tap_tarea_procedimiento tap
  ON tap.tap_id       = PTP.tap_id
  WHERE tap.dd_tpo_id =
    (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P418'
    )
 );
  
  
DELETE
FROM tap_tarea_procedimiento
WHERE dd_tpo_id =
  (SELECT DD_TPO_ID FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO='P418'
  );
  
  
DELETE FROM DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO = 'P418';

commit;