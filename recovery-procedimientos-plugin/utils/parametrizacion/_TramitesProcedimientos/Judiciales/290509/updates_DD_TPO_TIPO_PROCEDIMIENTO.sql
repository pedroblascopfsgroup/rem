-- *************************************************************************** --
-- **                   BPM Tramite de embargo de salarios                  ** --
-- *************************************************************************** --

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type:square;margin-left:35px;"><li>Original de la escritura de pr&'||'eacute;stamo con garantía hipotecaria.</li><li>Acta de requerimiento efectuada al demandado por el Notario.</li><li>Acta mercantil de Liquidaci&'||'oacute;n de saldo.</li><li>Certificado expedido por la Entidad acreedora intervenido por Notario.</li><li>Certificado de la variaci&'||'oacute;n del tipo de inter&'||'eacute;s del Pr&'||'eacute;stamo (cuando sea a tipo variable)</li><li>Extracto de certificaci&'||'oacute;n de deuda de Pr&'||'eacute;stamo intervenido por Notario.</li></ul></div>', 
DD_TPO_XML_JBPM='procedimientoHipotecario', DD_TPO_DESCRIPCION='Procedimiento hipotecario', DD_TPO_DESCRIPCION_LARGA='Procedimiento hipotecario'
Where DD_TPO_CODIGO='P01';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>P&'||'oacute;liza de Pr&'||'eacute;stamo Mercantil suscrita por ambas partes.</li><li>Liquidaci&'||'oacute;n practicada por la entidad en la forma pactada por las partes en la P&'||'oacute;liza.</li><li>Informe de cierre del pr&'||'eacute;stamo.</li><li>Certificaci&'||'oacute;n de saldo.</li><li>Copia del requerimiento de pago efectuada a la parte demandada mediante telegrama.</li></ul></div>', 
DD_TPO_XML_JBPM='procedimientoMonitorio', DD_TPO_DESCRIPCION='Procedimiento Monitorio', DD_TPO_DESCRIPCION_LARGA='Procedimiento Monitorio'
Where DD_TPO_CODIGO='P02';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Testimonio Literal sin Finalidad Ejecutiva de la P&'||'oacute;liza de Pr&'||'eacute;stamo Mercantil que sirve de t&'||'iacute;tulo a la presente reclamaci&'||'oacute;n.</li><li>Documento fehaciente de conformidad con el Art. 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por el Banco intervenido por Notario, que acredita haberse practicado la liquidaci&'||'oacute;n en la forma prevista por las partes en la P&'||'oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Informe de Cierre de Préstamo intervenido por Notario.</li><li>Requerimiento de pago a la parte demandada en el domicilio conocido de la cantidad exigible, mediante telegrama.</li></ul></div>', 
DD_TPO_XML_JBPM='procedimientoOrdinario', DD_TPO_DESCRIPCION='Procedimiento ordinario', DD_TPO_DESCRIPCION_LARGA='Procedimiento ordinario'
Where DD_TPO_CODIGO='P03';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Testimonio Literal sin Finalidad Ejecutiva de la P&'||'oacute;liza de Pr&'||'eacute;stamo Mercantil que sirve de t&'||'iacute;tulo a la presente reclamaci&'||'oacute;n.</li><li>Documento fehaciente de conformidad con el Art. 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por el Banco intervenido por Notario, que acredita haberse practicado la liquidaci&'||'oacute;n en la forma prevista por las partes en la P&'||'oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Informe de Cierre de Préstamo intervenido por Notario.</li><li>Requerimiento de pago a la parte demandada en el domicilio conocido de la cantidad exigible, mediante telegrama.</li></ul></div>', 
DD_TPO_XML_JBPM='procedimientoVerbal', DD_TPO_DESCRIPCION='Procedimiento verbal', DD_TPO_DESCRIPCION_LARGA='Procedimiento verbal'
Where DD_TPO_CODIGO='P04';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteAdjudicacion', DD_TPO_DESCRIPCION='Trámite de adjudicación', DD_TPO_DESCRIPCION_LARGA='Trámite de adjudicación'
Where DD_TPO_CODIGO='P05';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteNotificacion', DD_TPO_DESCRIPCION='Trámite de notificación', DD_TPO_DESCRIPCION_LARGA='Trámite de notificación'
Where DD_TPO_CODIGO='P06';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteCostas', DD_TPO_DESCRIPCION='Trámite de costas', DD_TPO_DESCRIPCION_LARGA='Trámite de costas'
Where DD_TPO_CODIGO='P07';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteCertificacionCargasRevision', DD_TPO_DESCRIPCION='Trámite de certificación de cargas y revisión', DD_TPO_DESCRIPCION_LARGA='Trámite de certificación de cargas y revisión'
Where DD_TPO_CODIGO='P08';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteEmbargoSalarios', DD_TPO_DESCRIPCION='Trámite de Embargo de Salarios', DD_TPO_DESCRIPCION_LARGA='Trámite de Embargo de Salarios'
Where DD_TPO_CODIGO='P09';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteIntereses', DD_TPO_DESCRIPCION='Trámite de Intereses', DD_TPO_DESCRIPCION_LARGA='Trámite de Intereses'
Where DD_TPO_CODIGO='P10';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteSubasta', DD_TPO_DESCRIPCION='Trámite de Subasta', DD_TPO_DESCRIPCION_LARGA='Trámite de Subasta'
Where DD_TPO_CODIGO='P11';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteValoracionBienesInmuebles', DD_TPO_DESCRIPCION='Tramite de valoración de bienes inmuebles', DD_TPO_DESCRIPCION_LARGA='Tramite de valoración de bienes inmuebles'
Where DD_TPO_CODIGO='P12';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteValoracionBienesMuebles', DD_TPO_DESCRIPCION='Tramite Valoración Bienes Muebles', DD_TPO_DESCRIPCION_LARGA='Tramite Valoración Bienes Muebles'
Where DD_TPO_CODIGO='P13';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteMejoraEmbargo', DD_TPO_DESCRIPCION='Trámite de mejora de embargo', DD_TPO_DESCRIPCION_LARGA='Trámite de mejora de embargo'
Where DD_TPO_CODIGO='P14';

-- restricción de tamaño de update en SQL
Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;margin-left:35px;"><ol><li><b>Ejecuci&'||'oacute;n de P&'||'oacute;liza Pr&'||'eacute;stamo Mercantil al Consumo</b></li><ul style="list-style-type:square;margin-left:35px;"><li>Original de la P&'||'oacute;liza que sirve de título a la reclamaci&'||'oacute;n.</li><li>Certificado Notarial de la conformidad de la p&'||'oacute;liza con el asiento.</li><li>Documento fehaciente de conformidad con el artículo 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por la Entidad intervenido por Notario, que acredita haberse practicado la liquidaci&'||'oacute;n en la forma prevista por las partes en la P&'||'oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Informe de cierre del pr&'||'eacute;stamo intervenido por Notario.</li><li>Requerimiento de pago al demandado en el domicilio conocido.</li><li>Informes de solvencia:</li><li style="list-style-type: none; border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li>Notas simples de bienes inmuebles</li><li>Bienes muebles conocidos</li><li>Vehículos</li><li>Derechos</li></ul></li></ul><li><b>Ejecuci&'||'oacute;n de P&'||'oacute;liza Cr&'||'eacute;dito Personal</b></li><ul style="list-style-type:square;margin-left:35px;"><li>P&'||'oacute;liza de Cr&'||'eacute;dito Personal que sirve de título a la presente reclamaci&'||'oacute;n.</li><li>Documento Fehaciente de conformidad con el art. 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por la Entidad.</li><li>Cierre de cuenta de la p&'||'oacute;liza de cr&'||'eacute;dito personal documentos intervenidos por Notario.</li><li>Extracto de cuentas de cr&'||'eacute;dito del que resultan las diferentes partidas de cargo y abono intervenido por Notario.</li>', 
DD_TPO_XML_JBPM='procedimientoEjecucionTituloNoJudicial', DD_TPO_DESCRIPCION='Procedimiento ejecución de título no judicial', DD_TPO_DESCRIPCION_LARGA='Procedimiento ejecución de título no judicial'
Where DD_TPO_CODIGO='P15';
Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML = DD_TPO_HTML || '<li>Comunicaci&'||'oacute;n de vencimiento y requerimiento de pago a la parte demandada de la cantidad exigible.</li><li>Informes de solvencia:</li><li style="list-style-type: none; border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li>Notas simples de bienes inmuebles</li><li>Bienes muebles conocidos</li><li>Vehículos</li><li>Derechos</li></ul></li></ul><li><b>Ejecuci&'||'oacute;n de P&'||'oacute;liza Descuento</b></li><ul style="list-style-type:square;margin-left:35px;"><li>Original de la P&'||'oacute;liza de la operaci&'||'oacute;n que sirve de título a la presente reclamaci&'||'oacute;n.</li><li>Certificaci&'||'oacute;n del Notario acreditativo de la conformidad  de la P&'||'oacute;liza con los asientos de su Libro Registro y la fecha de &'||'eacute;stos.</li><li>Extracto de la cuenta especial del que resultan las diferentes partidas de cargo y abono.</li><li>Certificado de saldo expedido por el Banco intervenido por Notario, que acredita haberse practicado la liquidaci&'||'oacute;n en la forma prevista por las partes en la P&'||'oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Documento fehaciente de conformidad con el artículo 218 del Reglamento Notarial.</li><li>Los efectos impagados con la devoluci&'||'oacute;n realizada por la Entidad.</li><li>Notificaci&'||'oacute;n del vencimiento de la cuenta especial y saldo que presenta tras su cierre y liquidaci&'||'oacute;n, y requiriendo de pago a la parte demandada por la cantidad exigible mediante telegrama.</li><li>Informes de solvencia de los titulares de la p&'||'oacute;liza y de los obligados al pago que se demandan vía cambiaria:</li><li style="list-style-type: none; border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li>Notas simples de bienes inmuebles</li><li>Bienes muebles conocidos</li><li>Vehículos</li><li>Derechos</li></ul></li></ul></ol></div>' 
Where DD_TPO_CODIGO='P15';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Sentencia/Auto dictado en el procedimiento.</li><li>Providencia en laque se declare la firmeza del titulo judicial ejecutado.</li><li>Notas simples en el caso de encontrarse inmuebles susceptibles embargo.</li></ul></div>', 
DD_TPO_XML_JBPM='ejecucionTituloJudicial', DD_TPO_DESCRIPCION='Procedimiento Ejecución de Título Judicial', DD_TPO_DESCRIPCION_LARGA='Procedimiento Ejecución de Título Judicial'
Where DD_TPO_CODIGO='P16';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type:square;margin-left:35px;"><li>Documento original del efecto o pagar&'||'eacute;.</li><li>Documento acreditativo de la devoluci&'||'oacute;n del efecto o pagar&'||'eacute; impagado.</li><li>Certificado de Deuda de la entidad por el principal m&'||'aacute; los gastos (a comentar con la Entidad).</li><li>Informes de solvencia:</li><li style="list-style-type:none;border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li >Notas simples de bienes inmuebles</li><li >Bienes muebles conocidos</li><li >Veh&'||'iacute;culos</li><li >Derechos</li></ul></li></ul></div>', 
DD_TPO_XML_JBPM='procedimientoCambiario', DD_TPO_DESCRIPCION='Procedimiento cambiario', DD_TPO_DESCRIPCION_LARGA='Procedimiento cambiario'
Where DD_TPO_CODIGO='P17';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteDeposito', DD_TPO_DESCRIPCION='Trámite de depósito', DD_TPO_DESCRIPCION_LARGA='Trámite de depósito'
Where DD_TPO_CODIGO='P18';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramitePrecinto', DD_TPO_DESCRIPCION='Trámite de precinto', DD_TPO_DESCRIPCION_LARGA='Trámite de precinto'
Where DD_TPO_CODIGO='P19';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', DD_TPO_XML_JBPM='tramiteInvestigacionJudicial', DD_TPO_DESCRIPCION='Trámite de investigación judicial', DD_TPO_DESCRIPCION_LARGA='Trámite de investigación judicial'
Where DD_TPO_CODIGO='P20';

Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_HTML='', 
DD_TPO_XML_JBPM='procedimientoVerbalDesdeMonitorio', DD_TPO_DESCRIPCION='Procedimiento Verbal desde Monitorio', DD_TPO_DESCRIPCION_LARGA='Procedimiento Verbal desde Monitorio'
Where DD_TPO_CODIGO='P21';

--Update DD_TPO_TIPO_PROCEDIMIENTO Set DD_TPO_CODIGO='P23'
--Where DD_TPO_CODIGO='P21';

--Insert into DD_TPO_TIPO_PROCEDIMIENTO(DD_TPO_ID, DD_TPO_CODIGO, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TPO_HTML, DD_TPO_XML_JBPM, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
--Values(S_DD_TPO_TIPO_PROCEDIMIENTO.nextval, 'P21', 'Procedimiento Verbal desde Monitorio', 'Procedimiento Verbal desde Monitorio', '', 'procedimientoVerbalDesdeMonitorio', 0, 'DD', SYSDATE, 0);





















