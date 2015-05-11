SET DEFINE OFF;
Insert into UNMASTER.DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 Values
   (587, 3, '587', 'Comunicación de Gestor en el expediente', 'Notificación de Comunicación sin Respuesta enviada por Gestor en el cliente', 0, 0, 'DD', TO_TIMESTAMP('29/02/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0, 'EXTSubtipoTarea');
Insert into UNMASTER.DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 Values
   (588, 3, '588', 'Comunicación de Supervisor en el expediente', 'Notificación de Comunicación sin Respuesta enviada por Supervisor en el expediente', 1, 0, 'DD', TO_TIMESTAMP('29/02/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0, 'EXTSubtipoTarea');
COMMIT;
