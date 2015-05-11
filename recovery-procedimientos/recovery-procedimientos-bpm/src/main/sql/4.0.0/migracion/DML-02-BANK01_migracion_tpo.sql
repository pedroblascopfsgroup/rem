/*
--##########################################
--## Author: Carlos Pérez
--## Finalidad: Insercción tipos de procedimiento
--## VERSIONES:
--## 0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
  V_MSQL       VARCHAR2(32000 CHAR);         -- Sentencia a ejecutar
  V_ESQUEMA    VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
  V_SQL        VARCHAR2(4000 CHAR);          -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16);                   -- Vble. para validar la existencia de una tabla.
  ERR_NUM      NUMBER(25);                   -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG      VARCHAR2(1024 CHAR);          -- Vble. auxiliar para registrar errores en el script.
BEGIN
  dbms_output.put_line('[INFO] - Insertando tipos de procedimiento...');
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_HTML,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      1,
      'P01',
      'P. hipotecario',
      'Procedimiento hipotecario',
      '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type:square;margin-left:35px;"><li>Original de la escritura de pr&eacute;stamo con garantía hipotecaria.</li><li>Acta de requerimiento efectuada al demandado por el Notario.</li><li>Acta mercantil de Liquidaci&oacute;n de saldo.</li><li>Certificado expedido por la Entidad acreedora intervenido por Notario.</li><li>Certificado de la variaci&oacute;n del tipo de inter&eacute;s del Pr&eacute;stamo (cuando sea a tipo variable)</li><li>Extracto de certificaci&oacute;n de deuda de Pr&eacute;stamo intervenido por Notario.</li></ul></div>',
      'procedimientoHipotecario',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 13:05:23.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      6,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_HTML,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      2,
      'P02',
      'P. Monitorio',
      'Procedimiento Monitorio',
      '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>P&oacute;liza de Pr&eacute;stamo Mercantil suscrita por ambas partes.</li><li>Liquidaci&oacute;n practicada por la entidad en la forma pactada por las partes en la P&oacute;liza.</li><li>Informe de cierre del pr&eacute;stamo.</li><li>Certificaci&oacute;n de saldo.</li><li>Copia del requerimiento de pago efectuada a la parte demandada mediante telegrama.</li></ul></div>',
      'procedimientoMonitorio',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 13:05:23.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      7,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_HTML,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      21,
      'P03',
      'P. ordinario',
      'Procedimiento ordinario',
      '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Testimonio Literal sin Finalidad Ejecutiva de la P&oacute;liza de Pr&eacute;stamo Mercantil que sirve de t&iacute;tulo a la presente reclamaci&oacute;n.</li><li>Documento fehaciente de conformidad con el Art. 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por el Banco intervenido por Notario, que acredita haberse practicado la liquidaci&oacute;n en la forma prevista por las partes en la P&oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Informe de Cierre de Préstamo intervenido por Notario.</li><li>Requerimiento de pago a la parte demandada en el domicilio conocido de la cantidad exigible, mediante telegrama.</li></ul></div>',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      7,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_HTML,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      22,
      'P04',
      'P. verbal',
      'Procedimiento verbal',
      '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Testimonio Literal sin Finalidad Ejecutiva de la P&oacute;liza de Pr&eacute;stamo Mercantil que sirve de t&iacute;tulo a la presente reclamaci&oacute;n.</li><li>Documento fehaciente de conformidad con el Art. 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por el Banco intervenido por Notario, que acredita haberse practicado la liquidaci&oacute;n en la forma prevista por las partes en la P&oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Informe de Cierre de Préstamo intervenido por Notario.</li><li>Requerimiento de pago a la parte demandada en el domicilio conocido de la cantidad exigible, mediante telegrama.</li></ul></div>',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      7,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      23,
      'P05',
      'T. de adjudicación',
      'Trámite de adjudicación',
      'tramiteAdjudicacion',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      8,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      24,
      'P06',
      'T. de notificación',
      'Trámite de notificación',
      'tramiteNotificacion',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      25,
      'P07',
      'T. de costas',
      'Trámite de costas',
      'tramiteCostas',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      26,
      'P08',
      'T. certificación de cargas y revisión',
      'Trámite de certificación de cargas y revisión',
      'tramiteCertificacionCargasRevision',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      8,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      27,
      'P09',
      'T. de Embargo de Salarios',
      'Trámite de Embargo de Salarios',
      'tramiteEmbargoSalarios',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      28,
      'P10',
      'T. de Intereses',
      'Trámite de Intereses',
      'tramiteIntereses',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      29,
      'P11',
      'T. de Subasta',
      'Trámite de Subasta',
      'tramiteSubastaUgas',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      8,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      30,
      'P12',
      'T. Valoración de bienes inmuebles',
      'Tramite de valoración de bienes inmuebles',
      'tramiteValoracionBienesInmuebles',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      8,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      31,
      'P13',
      'T. Valoración Bienes Muebles',
      'Tramite Valoración Bienes Muebles',
      'tramiteValoracionBienesMuebles',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      8,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      32,
      'P14',
      'T. de mejora de embargo',
      'Trámite de mejora de embargo',
      'tramiteMejoraEmbargo',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_HTML,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      33,
      'P15',
      'P. Ej. de título no judicial',
      'Procedimiento ejecución de título no judicial',
      '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;margin-left:35px;"><ol><li><b>Ejecuci&oacute;n de P&oacute;liza Pr&eacute;stamo Mercantil al Consumo</b></li><ul style="list-style-type:square;margin-left:35px;"><li>Original de la P&oacute;liza que sirve de título a la reclamaci&oacute;n.</li><li>Certificado Notarial de la conformidad de la p&oacute;liza con el asiento.</li><li>Documento fehaciente de conformidad con el artículo 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por la Entidad intervenido por Notario, que acredita haberse practicado la liquidaci&oacute;n en la forma prevista por las partes en la P&oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Informe de cierre del pr&eacute;stamo intervenido por Notario.</li><li>Requerimiento de pago al demandado en el domicilio conocido.</li><li>Informes de solvencia:</li><li style="list-style-type: none; border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li>Notas simples de bienes inmuebles</li><li>Bienes muebles conocidos</li><li>Vehículos</li><li>Derechos</li></ul></li></ul><li><b>Ejecuci&oacute;n de P&oacute;liza Cr&eacute;dito Personal</b></li><ul style="list-style-type:square;margin-left:35px;"><li>P&oacute;liza de Cr&eacute;dito Personal que sirve de título a la presente reclamaci&oacute;n.</li><li>Documento Fehaciente de conformidad con el art. 218 del Reglamento Notarial.</li><li>Certificado de saldo expedido por la Entidad.</li><li>Cierre de cuenta de la p&oacute;liza de cr&eacute;dito personal documentos intervenidos por Notario.</li><li>Extracto de cuentas de cr&eacute;dito del que resultan las diferentes partidas de cargo y abono intervenido por Notario.</li><li>Comunicaci&oacute;n de vencimiento y requerimiento de pago a la parte demandada de la cantidad exigible.</li><li>Informes de solvencia:</li><li style="list-style-type: none; border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li>Notas simples de bienes inmuebles</li><li>Bienes muebles conocidos</li><li>Vehículos</li><li>Derechos</li></ul></li></ul><li><b>Ejecuci&oacute;n de P&oacute;liza Descuento</b></li><ul style="list-style-type:square;margin-left:35px;"><li>Original de la P&oacute;liza de la operaci&oacute;n que sirve de título a la presente reclamaci&oacute;n.</li><li>Certificaci&oacute;n del Notario acreditativo de la conformidad  de la P&oacute;liza con los asientos de su Libro Registro y la fecha de &eacute;stos.</li><li>Extracto de la cuenta especial del que resultan las diferentes partidas de cargo y abono.</li><li>Certificado de saldo expedido por el Banco intervenido por Notario, que acredita haberse practicado la liquidaci&oacute;n en la forma prevista por las partes en la P&oacute;liza que se ejecuta y que el saldo resultante coincide con el que aparece deudor en la cuenta abierta al ejecutado.</li><li>Documento fehaciente de conformidad con el artículo 218 del Reglamento Notarial.</li><li>Los efectos impagados con la devoluci&oacute;n realizada por la Entidad.</li><li>Notificaci&oacute;n del vencimiento de la cuenta especial y saldo que presenta tras su cierre y liquidaci&oacute;n, y requiriendo de pago a la parte demandada por la cantidad exigible mediante telegrama.</li><li>Informes de solvencia de los titulares de la p&oacute;liza y de los obligados al pago que se demandan vía cambiaria:</li><li style="list-style-type: none; border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li>Notas simples de bienes inmuebles</li><li>Bienes muebles conocidos</li><li>Vehículos</li><li>Derechos</li></ul></li></ul></ol></div>'
      ,
      'procedimientoEjecucionTituloNoJudicial',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      6,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_HTML,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      34,
      'P16',
      'P. Ej. de Título Judicial',
      'Procedimiento Ejecución de Título Judicial',
      '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type: square; margin-left: 35px;"><li>Sentencia/Auto dictado en el procedimiento.</li><li>Providencia en laque se declare la firmeza del titulo judicial ejecutado.</li><li>Notas simples en el caso de encontrarse inmuebles susceptibles embargo.</li></ul></div>',
      'ejecucionTituloJudicial',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      6,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_HTML,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      35,
      'P17',
      'P. cambiario',
      'Procedimiento cambiario',
      '<div align="justify" style="font-size:8pt;font-family:Arial;margin-bottom:30px;margin-top:1em;"><ul style="list-style-type:square;margin-left:35px;"><li>Documento original del efecto o pagar&eacute;.</li><li>Documento acreditativo de la devoluci&oacute;n del efecto o pagar&eacute; impagado.</li><li>Certificado de Deuda de la entidad por el principal m&aacute; los gastos (a comentar con la Entidad).</li><li>Informes de solvencia:</li><li style="list-style-type:none;border:solid transparent 1px"><ul style="list-style-type:disc;margin-bottom:1em;padding-top:0px; margin-top:0px;margin-left:35px;"><li>Trabajo/Actividad</li><li >Notas simples de bienes inmuebles</li><li >Bienes muebles conocidos</li><li >Veh&iacute;culos</li><li >Derechos</li></ul></li></ul></div>',
      'procedimientoCambiario',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      6,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      36,
      'P18',
      'T. de depósito',
      'Trámite de depósito',
      'tramiteDeposito',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      37,
      'P19',
      'T. de precinto',
      'Trámite de precinto',
      'tramitePrecinto',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      38,
      'P20',
      'T. de investigación judicial',
      'Trámite de investigación judicial',
      'tramiteInvestigacionJudicial',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      39,
      'P23',
      'Actuación Amistosa',
      'Actuación Amistosa',
      'procedimientoActuacionAmistosa',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 18:15:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      40,
      'P22',
      'Contratos ADJUNTOS bloqueados',
      'Contratos ADJUNTOS bloqueados',
      'procedimientoContratosBloqueado',
      0,
      'DD',
      TO_TIMESTAMP('08/03/2009 13:05:23.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      22,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      41,
      'P21',
      'P. Verbal desde Monitorio',
      'Procedimiento Verbal desde Monitorio',
      'procedimientoVerbalDesdeMonitorio',
      0,
      'DD',
      TO_TIMESTAMP('08/05/2009 18:32:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      7,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      241,
      'P60',
      'Anotación y vigilancia de embargos en registro',
      'Anotación y vigilancia de embargos en registro',
      'vigilanciaCaducidadAnotacion',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      2,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      141,
      'P55',
      'P. solicitud de concurso necesario',
      'P. solicitud de concurso necesario',
      'procedimientoSolicitudConcursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      142,
      'P56',
      'T. fase común abreviado',
      'T. fase común abreviado',
      'tramiteFaseComunAbreviado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      143,
      'P24',
      'T. fase común ordinario',
      'T. fase común ordinario',
      'tramiteFaseComunOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      144,
      'P25',
      'T. demanda incidental',
      'T. demanda incidental',
      'tramiteDemandaIncidental',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      145,
      'P26',
      'T. demandado en incidente',
      'T. demandado en incidente',
      'tramiteDemandadoEnIncidente',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      146,
      'P27',
      'T. de solicitud de actuaciones o pronunciamientos',
      'Trámite de solicitud de actuaciones o pronunciamientos',
      'tramiteSolicitudActuacionesReintegracionContra3',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      147,
      'P28',
      'T. Registrar resolución de interés',
      'T. registrar resolución de interés',
      'tramiteRegistrarResolucionDeInteres',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      148,
      'P29',
      'T. fase convenio',
      'T. fase convenio',
      'tramiteFaseConvenio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      149,
      'P30',
      'T. Propuesta anticipada convenio',
      'T. propuesta anticipada convenio',
      'tramitePropuestaAnticipadaConvenio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      150,
      'P31',
      'T. fase de liquidación',
      'T. fase de liquidación',
      'tramiteFaseLiquidacion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      151,
      'P34',
      'T. de calificación',
      'T. de calificación',
      'tramiteCalificacion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      152,
      'P35',
      'T. de presentación propuesta convenio',
      'T. de presentación propuesta convenio',
      'tramitePresentacionPropConvenio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      153,
      'P32',
      'P. abreviado',
      'P. abreviado',
      'procedimientoAbreviado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      4,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      154,
      'P33',
      'T. de archivo',
      'T. de archivo',
      'tramiteArchivo',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      4,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      155,
      'P36',
      'P. ordinario de deslinde o amojonamiento',
      'P. ordinario de deslinde o amojonamiento',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      156,
      'P37',
      'P. verbal de deslinde o amojonamiento',
      'P. verbal de deslinde o amojonamiento',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      157,
      'P38',
      'P. ordinario de acción de dominio',
      'P. ordinario de acción de dominio',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      158,
      'P39',
      'P. verbal de acción de dominio',
      'P. verbal de acción de dominio',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      159,
      'P40',
      'P. ordinario de acción pauliana',
      'P. ordinario de acción pauliana',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      160,
      'P41',
      'P. verbal de acción pauliana',
      'P. verbal de acción pauliana',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      161,
      'P42',
      'T. de registro',
      'T. de registro',
      'tramiteDeRegistro',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      162,
      'P43',
      'P. ord. de acción en negatorias de servidumbre',
      'P. ordinario Acción en negatorias de servidumbre',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      163,
      'P44',
      'P. ver. de acción en negatorias de servidumbre',
      'P. verbal de acción en negatorias de servidumbre',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      164,
      'P45',
      'P. ord. de acción confirmatoria de servidumbre',
      'P. ordinario de acción confirmatoria de servidumbre',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      165,
      'P46',
      'P. ver. de acción confirmatoria de servidumbre',
      'P. verbal de acción confirmatoria de servidumbre',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      166,
      'P47',
      'P. ordinario de división de cosa común',
      'P. ordinario de división de cosa común',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      167,
      'P48',
      'P. verbal de división de cosa común',
      'P. verbal de división de cosa común',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      168,
      'P49',
      'P. ord. de nulidad de contrato de arrendamiento',
      'P. ordinario de nulidad de contrato de arrendamiento',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      169,
      'P50',
      'P. ver. de nulidad de contrato de arrendamiento',
      'P. verbal de nulidad de contrato de arrendamiento',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      170,
      'P51',
      'P. verbal de desaucio',
      'P. verbal de desaucio',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      171,
      'P52',
      'P. ord. de interdicto de recobro posesorio',
      'P. ordinario de interdicto de recobro posesorio',
      'procedimientoOrdinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      172,
      'P53',
      'P. ver. de interdicto de recobro posesorio',
      'P. verbal de interdicto de recobro posesorio',
      'procedimientoVerbal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      5,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      173,
      'P54',
      'T. de posesión',
      'T. de posesión',
      'tramiteDePosesion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      8,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      341,
      'P61',
      'T. de aceptación y decisión',
      'T. de aceptación y decisión',
      'aceptacionYdecision',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:52.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      21,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      441,
      'P1000',
      'Contratos sin gestión',
      'Contratos sin gestión',
      'procedimientoContratosBloqueado',
      0,
      'DD',
      TO_TIMESTAMP('20/09/2011 20:03:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      22,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      541,
      'P62',
      'T. conclusión de concurso',
      'T. conclusión de concurso',
      'tramiteConclusionConcurso',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:06.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      542,
      'P63',
      'T. adhesión a convenio',
      'T. adhesión a convenio',
      'tramiteAdhesionConvenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      543,
      'P64',
      'T. seguimiento cumplimiento de convenio',
      'T. seguimiento cumplimiento de convenio',
      'tramiteSeguimientoConvenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      641,
      'P92',
      'T. de confección de expedientes Tipo 1',
      'T. de confección de expedientes Sabadell',
      'confeccionExpedienteSabadell',
      0,
      'DD',
      TO_TIMESTAMP('22/02/2012 10:49:02.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      21,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      643,
      'P93',
      'T. de recobro amistoso',
      'T. de recobro amistoso',
      'tramiteRecobro',
      0,
      'DD',
      TO_TIMESTAMP('22/02/2012 10:49:43.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      23,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      642,
      'P91',
      'T. de confección de expedientes Tipo 2',
      'T. de confección de expedientes UNNIM',
      'confeccionExpedienteUnnim',
      0,
      'DD',
      TO_TIMESTAMP('22/02/2012 10:49:23.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      21,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      841,
      'P94',
      'P. reapertura de concurso',
      'P. reapertura de concurso',
      'tramiteReaperturaConcurso',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      941,
      'P65',
      'T. de cesión de remate',
      'T. de cesión de remate',
      'tramiteCesionRemate',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      8,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      1241,
      'P199',
      'Gestión de anticipación',
      'Gestión de anticipación',
      'anticipacion',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:24.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      301,
      0,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      1041,
      'P95',
      'T. de ejecución notarial',
      'T. de ejecución notarial',
      'tramiteEjecucionNotarialUGAS',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:51.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      201,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      1141,
      'P96',
      'T. demandado en incidente',
      'T. demandado en incidente',
      'tramiteDemandadoEnIncidenteUGAS',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'MEJTipoProcedimiento'
    );
  INSERT
  INTO BANK01.DD_TPO_TIPO_PROCEDIMIENTO
    (
      DD_TPO_ID,
      DD_TPO_CODIGO,
      DD_TPO_DESCRIPCION,
      DD_TPO_DESCRIPCION_LARGA,
      DD_TPO_XML_JBPM,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_TAC_ID,
      FLAG_PRORROGA,
      DTYPE
    )
    VALUES
    (
      1242,
      'P198',
      'Gestión de impagado',
      'Gestión de impagado',
      'impagado',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      301,
      0,
      'MEJTipoProcedimiento'
    );
  COMMIT;
  dbms_output.put_line('[INFO] - FIN Insercción tipos de procedimiento');
EXCEPTION
WHEN OTHERS THEN
  ERR_NUM := SQLCODE;
  ERR_MSG := SQLERRM;
  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
  DBMS_OUTPUT.put_line('-----------------------------------------------------------');
  DBMS_OUTPUT.put_line(ERR_MSG);
  ROLLBACK;
  RAISE;
END;
/

EXIT;