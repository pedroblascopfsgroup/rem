-- *************************************************************************** --
-- **                  INSERTS EN DD_TPO_TIPO_PROCEDIMIENTO	                ** --
-- *************************************************************************** --

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P55', 'P. solicitud concursal', 'P. solicitud concursal', '', 'procedimientoSolicitudConcursal', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P56', 'T. fase común abreviado', 'T. fase común abreviado', '', 'tramiteFaseComunAbreviado', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P24', 'T. fase común ordinario', 'T. fase común ordinario', '', 'tramiteFaseComunOrdinario', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P25', 'T. demanda incidental', 'T. demanda incidental', '', 'tramiteDemandaIncidental', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P26', 'T. demandado en incidente', 'T. demandado en incidente', '', 'tramiteDemandadoEnIncidente', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P27', 'T. solicitud de actuaciones contra tercero', 'T. solicitud de actuaciones contra tercero', '', 'tramiteSolicitudActuacionesReintegracionContra3', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P28', 'T. Registrar resolución de interés', 'T. registrar resolución de interés', '', 'tramiteRegistrarResolucionDeInteres', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P29', 'T. fase convenio', 'T. fase convenio', '', 'tramiteFaseConvenio', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P30', 'T. Propuesta anticipada convenio', 'T. propuesta anticipada convenio', '', 'tramitePropuestaAnticipadaConvenio', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P31', 'T. fase de liquidación', 'T. fase de liquidación', '', 'tramiteFaseLiquidacion', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P34', 'T. de calificación', 'T. de calificación', '', 'tramiteCalificacion', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);

Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, DD_TAC_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P35', 'T. de presentación propuesta convenio', 'T. de presentación propuesta convenio', '', 'tramitePresentacionPropConvenio', (select DD_TAC_ID from DD_TAC_TIPO_ACTUACION where DD_TAC_CODIGO='CO'), 0, 'DD', SYSDATE, 0);