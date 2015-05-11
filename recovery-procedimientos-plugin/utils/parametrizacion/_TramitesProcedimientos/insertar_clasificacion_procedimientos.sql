-- *************************************************************************** --
-- **    Insertar descpacho y procuradores para canarias	                ** --
-- *************************************************************************** --

SELECT S_DD_TAC_TIPO_ACTUACION.nextval FROM DUAL;
SELECT S_DD_TAC_TIPO_ACTUACION.nextval FROM DUAL;

-- Actuación concursal
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'CO', 'Concursal', 'Tipo de Actuación Concursal', 0, 'DD', SYSDATE, 1);

-- Actuación Penal
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'PE', 'Penal', 'Tipo de Actuación Penal', 0, 'DD', SYSDATE, 1);

-- Actuación Adjudicados
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'AD', 'Adjudicados', 'Tipo de Actuación Adjudicados', 0, 'DD', SYSDATE, 1);

-- Ejecutivo
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'EJ', 'Ejecutivo', 'Tipo de Actuación Ejecutivo', 0, 'DD', SYSDATE, 0);

-- Declarativo
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'DE', 'Declarativo', 'Tipo de Actuación Declarativo', 0, 'DD', SYSDATE, 0);

-- Apremio
Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'AP', 'Apremio', 'Tipo de Actuación Apremio', 0, 'DD', SYSDATE, 0);

-- Trámites
UPDATE DD_TAC_TIPO_ACTUACION SET DD_TAC_CODIGO = 'TR', DD_TAC_DESCRIPCION = 'Trámites', DD_TAC_DESCRIPCION_LARGA ='Tipo de Actuación Trámites' WHERE DD_TAC_CODIGO = 'CJ';

-- parametrización desde 0
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'TR', 'Trámites', 'Tipo de Actuación Trámites', 0, 'DD', SYSDATE, 0);
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, 'CA', 'Amistosa', 'Tipo de Actuación Amistosa', 0, 'DD', SYSDATE, 0);
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, '03', 'Otros trámites', 'Tipo de Actuación Otros trámites', 0, 'DD', SYSDATE, 0);
--Insert into DD_TAC_TIPO_ACTUACION(DD_TAC_ID, DD_TAC_CODIGO, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TAC_TIPO_ACTUACION.nextval, '04', 'Contratos bloqueados', 'Tipo de Actuación Contratos bloqueados', 0, 'DD', SYSDATE, 0);
