-- *************************************************************************** --
-- **    Insertar descpacho y procuradores para canarias	                ** --
-- *************************************************************************** --

SELECT S_DD_TAC_TIPO_ACTUACION.nextval FROM DUAL;
SELECT S_DD_TAC_TIPO_ACTUACION.nextval FROM DUAL;

-- Actuaci�n concursal
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'CO', 'Concursal', 'Tipo de Actuaci�n Concursal', 0, 'DD', SYSDATE, 1);

-- Actuaci�n Penal
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'PE', 'Penal', 'Tipo de Actuaci�n Penal', 0, 'DD', SYSDATE, 1);

-- Actuaci�n Adjudicados
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'AD', 'Adjudicados', 'Tipo de Actuaci�n Adjudicados', 0, 'DD', SYSDATE, 1);

-- Ejecutivo
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'EJ', 'Ejecutivo', 'Tipo de Actuaci�n Ejecutivo', 0, 'DD', SYSDATE, 0);

-- Declarativo
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'DE', 'Declarativo', 'Tipo de Actuaci�n Declarativo', 0, 'DD', SYSDATE, 0);

-- Apremio
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'AP', 'Apremio', 'Tipo de Actuaci�n Apremio', 0, 'DD', SYSDATE, 0);

-- Tr�mites
UPDATE DD_TAC_TIPO_ACTUACION SET DD_TAC_CODIGO = 'TR', DD_TAC_DESCRIPCION = 'Tr�mites', DD_TAC_DESCRIPCION_LARGA ='Tipo de Actuaci�n Tr�mites' WHERE DD_TAC_CODIGO = 'CJ';

-- parametrizaci�n desde 0
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'TR', 'Tr�mites', 'Tipo de Actuaci�n Tr�mites', 0, 'DD', SYSDATE, 0);
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'CA', 'Amistosa', 'Tipo de Actuaci�n Amistosa', 0, 'DD', SYSDATE, 0);
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, '03', 'Otros tr�mites', 'Tipo de Actuaci�n Otros tr�mites', 0, 'DD', SYSDATE, 0);
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, '04', 'Contratos bloqueados', 'Tipo de Actuaci�n Contratos bloqueados', 0, 'DD', SYSDATE, 0);
