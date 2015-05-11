/*
 * Inicializa el DD de tipos de acción
 */
 
SET DEFINE OFF;

Insert into BPM_DD_TAC_TIPO_ACCION
   (BPM_DD_TAC_ID, BPM_DD_TAC_CODIGO, BPM_DD_TAC_DESCRIPCION, BPM_DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TAC_TIPO_ACCION.nextval, 'INFO', 'Informar datos del procedimiento', 'Informar datos del procedimiento', 0, 'DD', sysdate, 0);
   

Insert into BPM_DD_TAC_TIPO_ACCION
   (BPM_DD_TAC_ID, BPM_DD_TAC_CODIGO, BPM_DD_TAC_DESCRIPCION, BPM_DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TAC_TIPO_ACCION.nextval, 'ADVANCE', 'Avance del BPM de un procedimiento', 'Avance del BPM de un procedimiento', 0, 'DD', sysdate, 0);
   
Insert into BPM_DD_TAC_TIPO_ACCION
   (BPM_DD_TAC_ID, BPM_DD_TAC_CODIGO, BPM_DD_TAC_DESCRIPCION, BPM_DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TAC_TIPO_ACCION.nextval, 'FORWARD', 'Salto permitido en el BPM de un procedimiento', 'Salto permitido en el BPM de un procedimiento', 0, 'DD', sysdate, 0);
   
Insert into BPM_DD_TAC_TIPO_ACCION
   (BPM_DD_TAC_ID, BPM_DD_TAC_CODIGO, BPM_DD_TAC_DESCRIPCION, BPM_DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_BPM_DD_TAC_TIPO_ACCION.nextval, 'GDOC', '(Re)generación de documentación de un procedimiento', '(Re)generación de documentación de un procedimiento', 0, 'DD', sysdate, 0);


COMMIT;
