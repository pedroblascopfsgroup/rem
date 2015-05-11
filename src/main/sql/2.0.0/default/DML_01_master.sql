Insert into FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_FUN_FUNCIONES.nextVal, 'Pestaña de recibos/disposiciones/efectos del Contrato', 'TAB_CONTRATO_RECIBOS', 0, 'CARLOS', sysdate, 0);
   
   
COMMIT;