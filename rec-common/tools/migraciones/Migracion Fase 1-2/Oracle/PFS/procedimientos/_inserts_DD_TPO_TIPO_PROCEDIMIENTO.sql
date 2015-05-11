-- *************************************************************************** --
-- **                  INSERTS EN DD_TPO_TIPO_PROCEDIMIENTO	                ** --
-- *************************************************************************** --

-- Embargo de Salarios
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P09', 'Embargo de Salarios', 'Tr�mite de Embargo de Salarios', '', 'tramiteEmbargoSalarios', 0, 'DD', SYSDATE, 0);

-- Tr�mite de Intereses
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P10', 'Tr�mite de Intereses', 'Tr�mite de Intereses', '', 'tramiteIntereses', 0, 'DD', SYSDATE, 0);

-- Tr�mite de Subasta
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P11', 'Tr�mite de Subasta', 'Tr�mite de Subasta', '', 'tramiteSubasta', 0, 'DD', SYSDATE, 0);

-- Ejecuci�n T�tulo Judicial
Insert INTO DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P16', 'Ejecuci�n T�tulo Judicial', 'Procedimiento Ejecuci�n de T�tulo Judicial', '', 'ejecucionTituloJudicial', 0, 'DD', SYSDATE, 0);

-- Tr�mite de notificaci�n
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P06', 'Tr�mite de notificaci�n', 'Tr�mite de notificaci�n', '', 'tramiteNotificacion', 0, 'DD', SYSDATE, 0);

-- Procedimiento hipotecario
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P01', 'Procedimiento hipotecario', 'Procedimiento Hipotecario', '', 'procedimientoHipotecario', 0, 'DD', SYSDATE, 0);

-- Tramite Valoraci�n Bienes Muebles
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P13', 'Tramite Valoraci�n Bienes Muebles', 'Tr�mite de valoraci�n de bienes muebles', '', 'tramiteValoracionBienesMuebles', 0, 'DD', SYSDATE, 0);

-- Tr�mite de mejora de embargo
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P14', 'Tr�mite de mejora de embargo', 'Tr�mite de embargo / mejora de embargo', '', 'tramiteMejoraEmbargo', 0, 'DD', SYSDATE, 0);

-- Tr�mite de adjudicaci�n
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P05', 'Tr�mite de adjudicaci�n', 'Tr�mite de adjudicaci�n', '', 'tramiteAdjudicacion', 0, 'DD', SYSDATE, 0);

-- Procedimiento verbal
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P04', 'Procedimiento verbal', 'Procedimiento verbal', '', 'procedimientoVerbal', 0, 'DD', SYSDATE, 0);

-- Tramite de valoraci�n de bienes inmuebles
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P12', 'Tramite de valoraci�n de bienes inmuebles', 'Tramite de valoraci�n de bienes inmuebles o avaluodd', '', 'tramiteValoracionBienesInmuebles', 0, 'DD', SYSDATE, 0);

-- Ejecuci�n de t�tulo no judicial
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P15', 'Ejecuci�n de t�tulo no judicial', 'Procedimiento ejecuci�n de t�tulo no judicial', '', 'procedimientoEjecucionTituloNoJudicial', 0, 'DD', SYSDATE, 0);

-- Procedimiento cambiario
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P17', 'Procedimiento cambiario', 'Procedimiento cambiario', '', 'procedimientoCambiario', 0, 'DD', SYSDATE, 0);

-- Tr�mite de investigaci�n judicial
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P20', 'Tr�mite de investigaci�n judicial', 'Tr�mite de investigaci�n judicial', '', 'tramiteInvestigacionJudicial', 0, 'DD', SYSDATE, 0);

-- Tr�mite de certificaci�n de cargas y revisi�n
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P08', 'Tr�mite de certificaci�n de cargas y revisi�n', 'Tr�mite de certificaci�n de cargas y revisi�n', '', 'tramiteCertificacionCargasRevision', 0, 'DD', SYSDATE, 0);

-- Procedimiento ordinario
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P03', 'Procedimiento ordinario', 'Procedimiento ordinario', '', 'procedimientoOrdinario', 0, 'DD', SYSDATE, 0);

-- Tr�mite de dep�sito
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P18', 'Tr�mite de dep�sito', 'Tr�mite de dep�sito', '', 'tramiteDeposito', 0, 'DD', SYSDATE, 0);

-- Tr�mite de precinto
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P19', 'Tr�mite de precinto', 'Tr�mite de precinto', '', 'tramitePrecinto', 0, 'DD', SYSDATE, 0);

-- Procedimiento Monitorio
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P02', 'Procedimiento Monitorio', 'Procedimiento Monitorio', '', 'procedimientoMonitorio', 0, 'DD', SYSDATE, 0);

-- Tr�mite de costas
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P07', 'Tr�mite de costas', 'Tr�mite de costas', '', 'tramiteCostas', 0, 'DD', SYSDATE, 0);

-- Insercion de procedimiento
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P21', 'Procedimiento Verbal desde Monitorio', 'Procedimiento Verbal desde Monitorio', '', 'procedimientoVerbalDesdeMonitorio', 0, 'DD', SYSDATE, 0);




















