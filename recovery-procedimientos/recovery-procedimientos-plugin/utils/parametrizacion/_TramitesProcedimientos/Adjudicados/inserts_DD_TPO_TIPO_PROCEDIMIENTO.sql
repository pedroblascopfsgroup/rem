-- *************************************************************************** --
-- **                  INSERTS EN DD_TPO_TIPO_PROCEDIMIENTO	                ** --
-- *************************************************************************** --

-- deslinde o amojonamiento
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P36', 'P. ordinario de deslinde o amojonamiento', 'P. ordinario de deslinde o amojonamiento', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- deslinde o amojonamiento
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P37', 'P. verbal de deslinde o amojonamiento', 'P. verbal de deslinde o amojonamiento', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- Accion de dominio
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P38', 'P. ordinario de acci�n de dominio', 'P. ordinario de acci�n de dominio', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- Accion de dominio
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P39', 'P. verbal de acci�n de dominio', 'P. verbal de acci�n de dominio', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- Accion pauliana
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P40', 'P. ordinario de acci�n pauliana', 'P. ordinario de acci�n pauliana', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- Accion pauliana
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P41', 'P. verbal de acci�n pauliana', 'P. verbal de acci�n pauliana', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- T. de registro
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P42', 'T. de registro', 'T. de registro', '', 'tramiteDeRegistro', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- PO Acci�n en negatorias de servidumbre
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P43', 'P. ord. de acci�n en negatorias de servidumbre', 'P. ordinario Acci�n en negatorias de servidumbre', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- JV Acci�n en negatorias de servidumbre
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P44', 'P. ver. de acci�n en negatorias de servidumbre', 'P. verbal de acci�n en negatorias de servidumbre', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- PO Acci�n confirmatoria de servidumbre
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P45', 'P. ord. de acci�n confirmatoria de servidumbre', 'P. ordinario de acci�n confirmatoria de servidumbre', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- JV Acci�n confirmatoria de servidumbre
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P46', 'P. ver. de acci�n confirmatoria de servidumbre', 'P. verbal de acci�n confirmatoria de servidumbre', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- PO Divisi�n de cosa com�n
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P47', 'P. ordinario de divisi�n de cosa com�n', 'P. ordinario de divisi�n de cosa com�n', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- JV Divisi�n de cosa com�n
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P48', 'P. verbal de divisi�n de cosa com�n', 'P. verbal de divisi�n de cosa com�n', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- PO Nulidad de contrato de arrendamiento
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P49', 'P. ord. de nulidad de contrato de arrendamiento', 'P. ordinario de nulidad de contrato de arrendamiento', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- JV Nulidad de contrato de arrendamiento
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P50', 'P. ver. de nulidad de contrato de arrendamiento', 'P. verbal de nulidad de contrato de arrendamiento', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- JV Desaucio
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P51', 'P. verbal de desaucio', 'P. verbal de desaucio', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- PO Interdicto de recobro posesorio
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P52', 'P. ord. de interdicto de recobro posesorio', 'P. ordinario de interdicto de recobro posesorio', '', 'procedimientoOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- JV Interdicto de recobro posesorio
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P53', 'P. ver. de interdicto de recobro posesorio', 'P. verbal de interdicto de recobro posesorio', '', 'procedimientoVerbal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

-- tr�mite de posesi�n
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P54', 'T. de posesi�n', 'T. de posesi�n', '', 'tramiteDePosesion', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='AD'), 0, 'DD', SYSDATE, 0);

