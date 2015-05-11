-- nuevo valor para el diccionario de datos de tipos de gestión cartera
insert into BANK01.RCF_DD_TGC_TIPO_GESTION_CART (DD_TGC_ID, DD_TGC_CODIGO, DD_TGC_DESCRIPCION, DD_TGC_DESCRIPCION_LARGA,
version, USUARIOCREAR, FECHACREAR, BORRADO)
values (BANK01.S_RCF_DD_TGC_TIPO_GESTION_CART.nextval, 'SG', 'Sin gestión', 'Cartera sin gestión',
0, 'DD', sysdate, 0);
