-- *************************************************************************** --
-- **                  INSERTS EN DD_TPO_TIPO_PROCEDIMIENTO	                ** --
-- *************************************************************************** --

-- Embargo de Salarios
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P09', 'Embargo de Salarios', 'Trámite de Embargo de Salarios', '', 'tramiteEmbargoSalarios', 0, 'DD', SYSDATE, 0);

-- Trámite de Intereses
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P10', 'Trámite de Intereses', 'Trámite de Intereses', '', 'tramiteIntereses', 0, 'DD', SYSDATE, 0);

-- Trámite de Subasta
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P11', 'Trámite de Subasta', 'Trámite de Subasta', '', 'tramiteSubasta', 0, 'DD', SYSDATE, 0);

-- Ejecución Título Judicial
Insert INTO DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values (S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P16', 'Ejecución Título Judicial', 'Procedimiento Ejecución de Título Judicial', '', 'ejecucionTituloJudicial', 0, 'DD', SYSDATE, 0);

-- Trámite de notificación
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P06', 'Trámite de notificación', 'Trámite de notificación', '', 'tramiteNotificacion', 0, 'DD', SYSDATE, 0);

-- Procedimiento hipotecario
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P01', 'Procedimiento hipotecario', 'Procedimiento Hipotecario', '', 'procedimientoHipotecario', 0, 'DD', SYSDATE, 0);

-- Tramite Valoración Bienes Muebles
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P13', 'Tramite Valoración Bienes Muebles', 'Trámite de valoración de bienes muebles', '', 'tramiteValoracionBienesMuebles', 0, 'DD', SYSDATE, 0);

-- Trámite de mejora de embargo
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P14', 'Trámite de mejora de embargo', 'Trámite de embargo / mejora de embargo', '', 'tramiteMejoraEmbargo', 0, 'DD', SYSDATE, 0);

-- Trámite de adjudicación
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P05', 'Trámite de adjudicación', 'Trámite de adjudicación', '', 'tramiteAdjudicacion', 0, 'DD', SYSDATE, 0);

-- Procedimiento verbal
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P04', 'Procedimiento verbal', 'Procedimiento verbal', '', 'procedimientoVerbal', 0, 'DD', SYSDATE, 0);

-- Tramite de valoración de bienes inmuebles
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P12', 'Tramite de valoración de bienes inmuebles', 'Tramite de valoración de bienes inmuebles o avaluodd', '', 'tramiteValoracionBienesInmuebles', 0, 'DD', SYSDATE, 0);

-- Ejecución de título no judicial
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P15', 'Ejecución de título no judicial', 'Procedimiento ejecución de título no judicial', '', 'procedimientoEjecucionTituloNoJudicial', 0, 'DD', SYSDATE, 0);

-- Procedimiento cambiario
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P17', 'Procedimiento cambiario', 'Procedimiento cambiario', '', 'procedimientoCambiario', 0, 'DD', SYSDATE, 0);

-- Trámite de investigación judicial
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P20', 'Trámite de investigación judicial', 'Trámite de investigación judicial', '', 'tramiteInvestigacionJudicial', 0, 'DD', SYSDATE, 0);

-- Trámite de certificación de cargas y revisión
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P08', 'Trámite de certificación de cargas y revisión', 'Trámite de certificación de cargas y revisión', '', 'tramiteCertificacionCargasRevision', 0, 'DD', SYSDATE, 0);

-- Procedimiento ordinario
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P03', 'Procedimiento ordinario', 'Procedimiento ordinario', '', 'procedimientoOrdinario', 0, 'DD', SYSDATE, 0);

-- Trámite de depósito
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P18', 'Trámite de depósito', 'Trámite de depósito', '', 'tramiteDeposito', 0, 'DD', SYSDATE, 0);

-- Trámite de precinto
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P19', 'Trámite de precinto', 'Trámite de precinto', '', 'tramitePrecinto', 0, 'DD', SYSDATE, 0);

-- Procedimiento Monitorio
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P02', 'Procedimiento Monitorio', 'Procedimiento Monitorio', '', 'procedimientoMonitorio', 0, 'DD', SYSDATE, 0);

-- Trámite de costas
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P07', 'Trámite de costas', 'Trámite de costas', '', 'tramiteCostas', 0, 'DD', SYSDATE, 0);

-- Insercion de procedimiento
Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P21', 'Procedimiento Verbal desde Monitorio', 'Procedimiento Verbal desde Monitorio', '', 'procedimientoVerbalDesdeMonitorio', 0, 'DD', SYSDATE, 0);




















