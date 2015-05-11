-- *************************************************************************** --
-- **                   BPM Tramite de embargo de salarios                  ** --
-- *************************************************************************** --

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='procedimientoHipotecario'
Where DD_TPO_CODIGO='P01';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='procedimientoMonitorio'
Where DD_TPO_CODIGO='P02';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='procedimientoOrdinario'
Where DD_TPO_CODIGO='P03';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='procedimientoVerbal'
Where DD_TPO_CODIGO='P04';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteAdjudicacion'
Where DD_TPO_CODIGO='P05';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteNotificacion'
Where DD_TPO_CODIGO='P06';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteCostas'
Where DD_TPO_CODIGO='P07';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteCertificacionCargasRevision'
Where DD_TPO_CODIGO='P08';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteEmbargoSalarios'
Where DD_TPO_CODIGO='P09';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteIntereses'
Where DD_TPO_CODIGO='P10';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteSubasta'
Where DD_TPO_CODIGO='P11';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteValoracionBienesInmuebles'
Where DD_TPO_CODIGO='P12';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteValoracionBienesMuebles'
Where DD_TPO_CODIGO='P13';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteMejoraEmbargo'
Where DD_TPO_CODIGO='P14';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='procedimientoEjecucionTituloNoJudicial'
Where DD_TPO_CODIGO='P15';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='ejecucionTituloJudicial'
Where DD_TPO_CODIGO='P16';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='procedimientoCambiario'
Where DD_TPO_CODIGO='P17';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteDeposito'
Where DD_TPO_CODIGO='P18';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramitePrecinto'
Where DD_TPO_CODIGO='P19';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteInvestigacionJudicial'
Where DD_TPO_CODIGO='P20';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_CODIGO='P23'
Where DD_TPO_CODIGO='P21';

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P21', 'Procedimiento Verbal desde Monitorio', 'Procedimiento Verbal desde Monitorio', '', 'procedimientoVerbalDesdeMonitorio', 0, 'DD', SYSDATE, 0);





















