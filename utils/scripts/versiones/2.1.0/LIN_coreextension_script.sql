UPDATE linmaster.dd_sta_subtipo_tarea_base
   SET dd_sta_descripcion = 'Acuerdo Cerrado por Gestor',
       dd_sta_descripcion_larga = 'Acuerdo Cerrado por Gestor'
 WHERE dd_sta_codigo = '52';
 
 
INSERT into linmaster.DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_STA_GESTOR, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DTYPE)
 Values
   (56, 3, '56', 'Acuerdo Cerrado por Supervisor', 'Acuerdo Cerrado por Supervisor', 1, 0, 'DD', TO_TIMESTAMP('08/05/2009 18:04:07.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'), 0, 'EXTSubtipoTarea');
   
COMMIT;
