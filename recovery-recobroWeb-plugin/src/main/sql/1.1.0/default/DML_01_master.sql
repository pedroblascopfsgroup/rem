-- función para visualizar la pestaña de acuerdos del expediente
Insert into FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_FUN_FUNCIONES.nextVal, 'Pestaña de ciclo de recobro expediente', 'TAB_ACUERDO_EXPEDIENTE', 0, 'DIANA', sysdate, 0);

commit;   