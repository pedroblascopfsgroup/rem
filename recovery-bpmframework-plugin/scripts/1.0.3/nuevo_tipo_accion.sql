Insert into BPM_DD_TAC_TIPO_ACCION
   (BPM_DD_TAC_ID, BPM_DD_TAC_CODIGO, BPM_DD_TAC_DESCRIPCION, BPM_DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TAC_TIPO_ACCION.nextval, 'CHAIN_BO', 'Ejecucion BO antes y después del input', 'Ejecucion operaciones BO antes y después del input', 0, 'manuel', sysdate, 0);