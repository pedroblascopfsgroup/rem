
-- Insertar nuevos tipos de registro correspondiente a la edición de los distintos tipos de gestores del asunto

insert into MEJ_DD_TRG_TIPO_REGISTRO (DD_TRG_ID, DD_TRG_CODIGO, DD_TRG_DESCRIPCION, DD_TRG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (S_MEJ_DD_TRG_TIPO_REGISTRO.NEXTVAL, 'CAMBIO_SJUD', 'Cambio de supervisor judicial', 'Cambio de supervisor judicial', 'SAG', sysdate);

insert into MEJ_DD_TRG_TIPO_REGISTRO (DD_TRG_ID, DD_TRG_CODIGO, DD_TRG_DESCRIPCION, DD_TRG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (S_MEJ_DD_TRG_TIPO_REGISTRO.NEXTVAL, 'CAMBIO_GJUD', 'Cambio de gestor judicial', 'Cambio de gestor judicial', 'SAG', sysdate);

insert into MEJ_DD_TRG_TIPO_REGISTRO (DD_TRG_ID, DD_TRG_CODIGO, DD_TRG_DESCRIPCION, DD_TRG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (S_MEJ_DD_TRG_TIPO_REGISTRO.NEXTVAL, 'CAMBIO_PROC', 'Cambio de procurador', 'Cambio de procurador', 'SAG', sysdate);

insert into MEJ_DD_TRG_TIPO_REGISTRO (DD_TRG_ID, DD_TRG_CODIGO, DD_TRG_DESCRIPCION, DD_TRG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (S_MEJ_DD_TRG_TIPO_REGISTRO.NEXTVAL, 'CAMBIO_SCEX', 'Cambio de supervisor de confección de expedientes', 'Cambio de supervisor de confección de expedientes', 'SAG', sysdate);

insert into MEJ_DD_TRG_TIPO_REGISTRO (DD_TRG_ID, DD_TRG_CODIGO, DD_TRG_DESCRIPCION, DD_TRG_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
VALUES (S_MEJ_DD_TRG_TIPO_REGISTRO.NEXTVAL, 'CAMBIO_GCEX', 'Cambio de gestor de confección de expedientes', 'Cambio de gestor de confección de expedientes', 'SAG', sysdate);

