Insert into TAP_TAREA_PROCEDIMIENTO(TAP_ID, DD_TPO_ID, TAP_CODIGO, TAP_SUPERVISOR, TAP_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
Values(S_TAP_TAREA_PROCEDIMIENTO.nextval, (select DD_TPO_ID from DD_TPO_TIPO_PROCEDIMIENTO where DD_TPO_CODIGO='P70'), 'P70_PendienteFirmezaFinMonitorio', 0, 'Pte. Firmeza Resolución',
 0, 'DD', SYSDATE, 0, 'EXTTareaProcedimiento');

Insert into DD_PTP_PLAZOS_TAREAS_PLAZAS(DD_PTP_ID, TAP_ID, DD_PTP_PLAZO_SCRIPT, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_PTP_PLAZOS_TAREAS_PLAZAS.nextval, (select TAP_ID from TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO='P70_PendienteFirmezaFinMonitorio'), '20*24*60*60*1000L', 0, 'DD', SYSDATE, 0);


-- cambiamos la configuracion de fin de monitorio para que vaya aquí en vez de a fin

update bpm_tpi_tipo_proc_input set bpm_tpi_nombre_transicion='resol_PteFirmeza'
where bpm_dd_tin_id=(select bpm_dd_tin_id from bpm_dd_tin_tipo_input where bpm_dd_tin_codigo='AUTO_FIN_MON');    


commit;