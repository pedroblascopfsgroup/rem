-- INSERCIÓN DE CAMPOS EN EL DICCIONARIO DE TIPOS DE CONTROL DE CALIDAD

Insert into BANK01.DD_TCC_TIPO_CONTROL_CALIDAD(DD_TCC_ID, DD_TCC_CODIGO, DD_TCC_DESCRIPCION, DD_TCC_DESCRIPCION_LARGA, DD_TCC_NOMBRE_TABLA, DD_TCC_NOMBRE_ENTIDAD, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(BANK01.S_DD_TCC_TIPO_CONTROL_CALIDAD.nextval, 'PRC_REC', 'Control de Calidad de Procedimiento de Recobro', 'Tipo de Control de Calidad de Procedimeinto', 'CCP_CONTROL_CALIDAD_PROC', 'Procedimiento Recobro', 0, 'DD', SYSDATE, 0);
