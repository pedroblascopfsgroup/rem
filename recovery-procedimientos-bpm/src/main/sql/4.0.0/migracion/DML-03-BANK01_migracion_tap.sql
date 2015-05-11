/*
--##########################################
--## Author: Carlos Pérez
--## Finalidad: Insercción tareas del procedimiento
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
  dbms_output.put_line('[INFO] - Insertando tareas del procedimiento...');
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      273,
      33,
      'P15_ConfirmarNotifiReqPago',
      '((valores[''P15_ConfirmarNotifiReqPago''][''comboConfirmacionReqPago''] == DDPositivoNegativo.POSITIVO) && (valores[''P15_ConfirmarNotifiReqPago''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P15_ConfirmarNotifiReqPago''][''comboConfirmacionReqPago''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación requerimiento de pago',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      275,
      33,
      'P15_ConfirmarSiExisteOposicion',
      'plugin/procedimientos/ejecucionTituloNoJudicial/confirmarSiExisteOposicion',
      '((valores[''P15_ConfirmarSiExisteOposicion''][''comboConfirmacion''] == DDSiNo.SI) && ((valores[''P15_ConfirmarSiExisteOposicion''][''fecha''] == '''')))?''tareaExterna.error.P15_ConfirmarSiExisteOposicion.fechasOblgatorias'':null',
      'valores[''P15_ConfirmarSiExisteOposicion''][''comboConfirmacion''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      277,
      33,
      'P15_MotivoOposicionImpugVista',
      '((valores[''P15_MotivoOposicionImpugVista''][''comboHayVista''] == DDSiNo.SI) && ((valores[''P15_MotivoOposicionImpugVista''][''fechaVista''] == '''')))?''tareaExterna.error.P15_MotivoOposicionImpugVista.fechasOblgatorias'':null',
      'valores[''P15_MotivoOposicionImpugVista''][''comboHayVista''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar si hay vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      278,
      33,
      'P15_RegistrarCelebracionVista',
      0,
      'Registrar celebración vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      279,
      33,
      'P15_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      282,
      35,
      'P17_CnfAdmiDemaDecretoEmbargo',
      'plugin/procedimientos/procedimientoCambiario/confirmarAdmisionDemanda',
      'tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pestaña Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null',
      'valores[''P17_CnfAdmiDemaDecretoEmbargo''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión + marcado bienes decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      283,
      35,
      'P17_RegistrarAnotacionRegistro',
      'valores[''P17_RegistrarAnotacionRegistro''][''repetir''] == DDSiNo.SI ? ''repite'' : ''avanzaBPM''',
      0,
      'Confirmar anotación en el registro',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      284,
      35,
      'P17_CnfNotifRequerimientoPago',
      '((valores[''P17_CnfNotifRequerimientoPago''][''comboConfirmar''] == DDPositivoNegativo.POSITIVO) && (valores[''P17_CnfNotifRequerimientoPago''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P17_CnfNotifRequerimientoPago''][''comboConfirmar''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación requerimiento de pago',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      285,
      35,
      'P17_RegistrarDemandaOposicion',
      '((valores[''P17_RegistrarDemandaOposicion''][''comboRegistro''] == DDSiNo.SI) && ((valores[''P17_RegistrarDemandaOposicion''][''fecha''] == '''') || (valores[''P17_RegistrarDemandaOposicion''][''fechaVista''] == '''')))?''tareaExterna.error.P17_RegistrarDemandaOposicion.fechasOblgatorias'':null',
      'valores[''P17_RegistrarDemandaOposicion''][''comboRegistro''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar demanda de oposición',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      286,
      35,
      'P17_RegistrarJuicioComparecencia',
      0,
      'Registrar celebración vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      287,
      35,
      'P17_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      288,
      35,
      'P17_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      289,
      35,
      'P17_RegistrarAutoEjecucion',
      0,
      'Registrar auto despachando ejecución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      290,
      35,
      'P17_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      291,
      38,
      'P20_SolicitudInvestigacionJudicial',
      0,
      'Escrito de solicitud investigación judicial',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      292,
      38,
      'P20_RegistrarResultadoInvestigacion',
      '((valores[''P20_RegistrarResultadoInvestigacion''][''comboRegistro''] == DDPositivoNegativo.POSITIVO) && (valores[''P20_RegistrarResultadoInvestigacion''][''comboAgTribut''] == '''') && (valores[''P20_RegistrarResultadoInvestigacion''][''comboSegSocial''] == '''') && (valores[''P20_RegistrarResultadoInvestigacion''][''comboCatastro''] == '''') && (valores[''P20_RegistrarResultadoInvestigacion''][''comboAyto''] == '''') && (valores[''P20_RegistrarResultadoInvestigacion''][''comboOtros''] == '''') )?''tareaExterna.error.P20_RegistrarImpugnacion.algunComboObligatorio'':null',
      'valores[''P20_RegistrarResultadoInvestigacion''][''comboRegistro''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Registrar resultado de investigación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      293,
      38,
      'P20_RevisarInvestigacionYActualizacionDatos',
      'plugin/procedimientos/investigacionJudicial/revisarInvestigacion',
      0,
      'Revisar resultado investigación y actualización de datos',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      295,
      26,
      'P08_RegistrarCertificacion',
      '((valores[''P08_RegistrarCertificacion''][''comboResultado''] == DDSiNo.SI) && (valores[''P08_RegistrarCertificacion''][''fecha''] == ''''))?''tareaExterna.error.P08_RegistrarCertificacion.fechaOblgatoria'':null',
      'valores[''P08_RegistrarCertificacion''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar certificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      296,
      26,
      'P08_SolicitarInformacionCargas',
      '((valores[''P08_SolicitarInformacionCargas''][''comboResultado''] == DDSiNo.SI) && (valores[''P08_SolicitarInformacionCargas''][''fecha''] == ''''))?''tareaExterna.error.P08_SolicitarInformacionCargas.fechaOblgatoria'':null',
      'valores[''P08_SolicitarInformacionCargas''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Solicitar información de cargas anteriores',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      297,
      26,
      'P08_ActualizaDatosAnteriores',
      0,
      'Actualizar datos anteriores',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      298,
      26,
      'P08_ActualizarDatos',
      0,
      'Actualizar datos y estudiar tercería mejor derecho',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      301,
      21,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      302,
      21,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      306,
      21,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      307,
      21,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      303,
      21,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      304,
      21,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      305,
      21,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      308,
      21,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      309,
      21,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      310,
      36,
      'P18_SolicitarNombramiento',
      0,
      'Solicitar nombramiento de depositario',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      311,
      36,
      'P18_NombramientoDepositario',
      0,
      'Nombramiento de depositario',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      312,
      36,
      'P18_AceptacionCargoDepositario',
      0,
      'Aceptación cargo de depositário',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      313,
      36,
      'P18_SolicitarRemocion',
      0,
      'Solicitar remoción de depósito',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      314,
      36,
      'P18_AcuerdoEntrega',
      0,
      'Acuerdo de entrega a depositario',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      315,
      37,
      'P19_SolicitarPrecinto',
      0,
      'Solicitar precinto',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      316,
      37,
      'P19_AcuerdoPrecinto',
      0,
      'Acuerdo de precinto',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      318,
      2,
      'P02_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/confirmarAdmisionDemanda',
      'valores[''P02_ConfirmarAdmisionDemanda''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      319,
      2,
      'P02_ConfirmarNotificacionReqPago',
      '((valores[''P02_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P02_ConfirmarNotificacionReqPago''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P02_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación requerimiento de pago',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      321,
      2,
      'P02_RegAutodespachandoEjecucion',
      0,
      'Auto despachando ejecución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      322,
      2,
      'P02_JBPMProcedimientoVerbalDesdeMonitorio',
      41,
      0,
      'Se inicia Procedimiento verbal desde monitorio',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      323,
      2,
      'P02_JBPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      324,
      25,
      'P07_SolicitudTasacion',
      0,
      'Solicitud de tasación de costas',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      325,
      25,
      'P07_TasacionCostas',
      0,
      'Tasación de costas',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      326,
      25,
      'P07_ConfirmarNotificacion',
      '((valores[''P07_ConfirmarNotificacion''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P07_ConfirmarNotificacion''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P07_ConfirmarNotificacion''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      327,
      25,
      'P07_Impugnacion',
      '((valores[''P07_Impugnacion''][''comboImpugnacion''] == DDSiNo.SI) && ((valores[''P07_Impugnacion''][''fechaImpugnacion''] == '''')))?''tareaExterna.error.P07_Impugnacion.fechasOblgatorias'':null',
      'valores[''P07_Impugnacion''][''comboImpugnacion''] == DDSiNo.NO ? ''NO'' : (valores[''P07_Impugnacion''][''vistaImpugnacion''] != null &&valores[''P07_Impugnacion''][''vistaImpugnacion''] != '''' ? ''SI'' : ''SI_NOVISTA'')',
      0,
      'Impugnación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      328,
      25,
      'P07_RegistrarCelebracionVista',
      0,
      'Registrar celebración vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      329,
      25,
      'P07_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      330,
      25,
      'P07_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      331,
      25,
      'P07_AutoAprobacionCostas',
      0,
      'Auto aprobación costas',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      332,
      25,
      'P07_AutoFirme',
      0,
      'Auto firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      333,
      25,
      'P07_JBPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      201,
      24,
      'P06_NotificacionAveriguacionDomicilio',
      0,
      'Solicitar notificación otros domicilios o averiguación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      202,
      24,
      'P06_ResultadoDomicilio',
      'valores[''P06_ResultadoDomicilio''][''comboNotificacion''] == DDImpugnacion2.NOTIF_POSITIVA ? ''NotificacionPositiva'' :(valores[''P06_ResultadoDomicilio''][''comboNotificacion''] == DDImpugnacion2.AV_POSITIVA ? ''AveriguacionPositiva'' : ''NotificacionAveriguacionNegativa'')',
      0,
      'Registrar resultado',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      203,
      24,
      'P06_NotificacionEdicto',
      0,
      'Solicitud notificación por edictos',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      204,
      24,
      'P06_ResultadoEdicto',
      0,
      'Registrar resultado notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      206,
      41,
      'P21_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      207,
      41,
      'P21_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      208,
      29,
      'P11_SolicitudSubasta',
      0,
      'Solicitud de subasta',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      209,
      29,
      'P11_AnuncioSubasta',
      0,
      'Anuncio de Subasta',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      211,
      29,
      'P11_LeerInstrucciones',
      'plugin/ugas/procedimientos/tramiteSubasta/leerInstruccionesUGAS',
      0,
      'Lectura y aceptacion de instrucciones',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      212,
      29,
      'P11_CelebracionSubasta',
      'valores[''P11_CelebracionSubasta''][''comboAdjudicacion''] == DDTerceros.NOSOTROS ? ''nosotros'' : ( valores[''P11_CelebracionSubasta''][''comboAdjudicacion''] == DDTerceros.TERCEROS ? ''terceros'' : ''adjudicacionConCesionRemate'' ) ',
      0,
      'Celebración subasta y adjudicación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      5,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      213,
      29,
      'P11_SolicitudPago',
      0,
      'Solicitud mandamiento de pago',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      214,
      29,
      'P11_Cobro',
      0,
      'Confirmación recepción mandamiento de pago',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      215,
      27,
      'P09_SolicitarNotificacion',
      0,
      'Solicitud requerimiento retención al pagador',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      216,
      27,
      'P09_ConfirmarRequerimientoResultado',
      '((valores[''P09_ConfirmarRequerimientoResultado''][''comboRequerido''] == DDSiNo.SI) && ((valores[''P09_ConfirmarRequerimientoResultado''][''comboResultado''] == '''')||(valores[''P09_ConfirmarRequerimientoResultado''][''comboResultado''] == null)||(valores[''P09_ConfirmarRequerimientoResultado''][''importeNom''] == '''')||(valores[''P09_ConfirmarRequerimientoResultado''][''importeRet''] == '''')) )?''tareaExterna.error.P09_ConfirmarRequerimientoResultado.importesYresultado'':null',
      'valores[''P09_ConfirmarRequerimientoResultado''][''comboRequerido''] == DDSiNo.NO ? ''ConfirmadoNo'' : valores[''P09_ConfirmarRequerimientoResultado''][''comboResultado''] == DDPositivoNegativo.NEGATIVO ? ''ConfirmadoNo'' : ''ConfirmadoSi''',
      0,
      'Confirmar requerimiento y resultado',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      217,
      27,
      'P09_ConfirmarRetenciones',
      'valores[''P09_ConfirmarRetenciones''][''comboCorr''] == DDCorrectoCobro.CORRECTO_COBROS_PENDIENTES ? ''CorrectoCobros'' : valores[''P09_ConfirmarRetenciones''][''comboCorr''] == DDCorrectoCobro.INCORRECTO_COBROS_PENDIENTES ? ''IncorrectoCobros'' : ''CorrectoFin''',
      0,
      'Confirmar retención practicada',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      218,
      27,
      'P09_GestionarProblemas',
      'valores[''P09_GestionarProblemas''][''comboCorr''] == DDPositivoNegativo.POSITIVO ? ''Correcto'' : ''Incorrecto''',
      0,
      'Gestionar problemas de retención',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      219,
      27,
      'P09_ActualizarDatos',
      1,
      'Actualizar datos solvencia cliente',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'UGAS-2222',
      TO_TIMESTAMP('19/04/2013 20:41:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      220,
      28,
      'P10_ElaborarLiquidacion',
      0,
      'Elaborar, enviar Liquidación de intereses',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      221,
      28,
      'P10_SolicitarLiquidacion',
      0,
      'Solicitar Liquidación de Intereses',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      222,
      28,
      'P10_RegistrarResolucion',
      0,
      'Registrar Resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      223,
      28,
      'P10_ConfirmarNotificacion',
      '((valores[''P10_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO) && (valores[''P10_ConfirmarNotificacion''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P10_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar Notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      224,
      28,
      'P10_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de Notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      225,
      28,
      'P10_RegistrarImpugnacion',
      '((valores[''P10_RegistrarImpugnacion''][''comboImpugnacion''] == DDSiNo.SI) && (valores[''P10_RegistrarImpugnacion''][''fecha''] == '''')) ? ''tareaExterna.error.P10_RegistrarImpugnacion.fechaImpugObligatoria'': (((valores[''P10_RegistrarImpugnacion''][''comboSiNo''] == DDSiNo.SI) && (valores[''P10_RegistrarImpugnacion''][''fechaVista''] == ''''))?''tareaExterna.error.P10_RegistrarImpugnacion.fechasOblgatorias'':null)',
      'valores[''P10_RegistrarImpugnacion''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar Impugnación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      226,
      28,
      'P10_RegistrarVista',
      0,
      'Registrar Vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      227,
      28,
      'P10_RegistrarResolucionVista',
      0,
      'Registrar Resolución de la Vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      228,
      28,
      'P10_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      229,
      34,
      'P16_InterposicionDemanda',
      'plugin/procedimientos/ejecucionTituloJudicial/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pestaña Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null)',
      0,
      'Interposición de la demanda de título judicial + Marcado de bienes',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      232,
      34,
      'P16_ConfirmarNotificacion',
      '((valores[''P16_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO) && (valores[''P16_ConfirmarNotificacion''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P16_ConfirmarNotificacion''][''comboSiNo''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificacion',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      233,
      34,
      'P16_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de Notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      234,
      34,
      'P16_RegistrarOposicion',
      '((valores[''P16_RegistrarOposicion''][''comboSiNo''] == DDSiNo.SI) && ((valores[''P16_RegistrarOposicion''][''fecha''] == '''')))?''tareaExterna.error.P15_ConfirmarSiExisteOposicion.fechasOblgatorias'':null',
      'valores[''P16_RegistrarOposicion''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar oposición vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      235,
      34,
      'P16_ConfirmarPresentacionImpugnacion',
      0,
      'Confirmar presentación impugnación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      236,
      34,
      'P16_HayVista',
      '((valores[''P16_HayVista''][''comboSiNo''] == DDSiNo.SI) && ((valores[''P16_HayVista''][''fechaVista''] == '''')))?''tareaExterna.error.P16_HayVista.fechasOblgatorias'':null',
      'valores[''P16_HayVista''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar si hay vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      237,
      34,
      'P16_RegistrarVista',
      0,
      'Registrar celebración vista',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      238,
      34,
      'P16_RegistrarResolucion',
      0,
      'Registrar Resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      239,
      34,
      'P16_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      240,
      1,
      'P01_DemandaCertificacionCargas',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'UGAS-2279',
      TO_TIMESTAMP('22/03/2013 18:53:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      242,
      1,
      'P01_ConfirmarNotificacionReqPago',
      '((valores[''P01_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P01_ConfirmarNotificacionReqPago''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P01_ConfirmarNotificacionReqPago''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación del auto despachando ejecución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      243,
      1,
      'P01_ConfirmarSiExisteOposicion',
      'plugin/procedimientos/procedimientoHipotecario/confirmarSiExisteOposicion',
      '((valores[''P01_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P01_ConfirmarSiExisteOposicion''][''fechaOposicion''] == '''') || (valores[''P01_ConfirmarSiExisteOposicion''][''fechaComparecencia''] == '''')))?''tareaExterna.error.P01_ConfirmarSiExisteOposicion.fechasOblgatorias'':null',
      'valores[''P01_ConfirmarSiExisteOposicion''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      244,
      1,
      'P01_RegistrarComparecencia',
      0,
      'Registrar comparecencia',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      245,
      1,
      'P01_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      246,
      1,
      'P01_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      247,
      1,
      'P01_BPMTramiteSubasta',
      29,
      0,
      'Se inicia Trámite de subastas',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      248,
      1,
      'P01_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      249,
      31,
      'P13_SolicitarJustiprecio',
      0,
      'Solicitar justiprecio',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      250,
      31,
      'P13_RegistrarJustiprecio',
      0,
      'Registrar justiprecio',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      251,
      32,
      'P14_SolicitudMejoraEmbargo',
      0,
      'Solicitud de mejora de embargo',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      252,
      32,
      'P14_RegistroDecretoEmbargo',
      0,
      'Confirmar registro decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      253,
      32,
      'P14_RegistrarAnotacionEnRegistro',
      'isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''Antes de realizar la tarea es necesario marcar los bienes con fecha de registro de embargo'' : null',
      'valores[''P14_RegistrarAnotacionEnRegistro''][''repetir''] == DDSiNo.SI ? ''repite'' : ''avanzaBPM''',
      0,
      'Registrar anotación en registro',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  COMMIT;
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      254,
      23,
      'P05_SolicitudTramiteAdjudicacion',
      0,
      'Solicitud Decreto Adjudicación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      255,
      23,
      'P05_RegistrarAutoAdjudicacion',
      0,
      'Confirmar testimonio decreto adjudicación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      5,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      256,
      22,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      257,
      22,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      258,
      22,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      259,
      22,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      260,
      22,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      261,
      22,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      262,
      22,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      263,
      30,
      'P12_SolicitarAvaluo',
      0,
      'Solicitud avalúo',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      264,
      30,
      'P12_ObtencionAvaluo',
      0,
      'Obtención avalúo',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      265,
      30,
      'P12_SolitarTasacionInterna',
      '((valores[''P12_SolitarTasacionInterna''][''combo''] == DDSiNo.SI) && (valores[''P12_SolitarTasacionInterna''][''fecha''] == ''''))?''tareaExterna.error.P08_RegistrarCertificacion.fechaOblgatoria'':null',
      'valores[''P12_SolitarTasacionInterna''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI''',
      1,
      'Solicitar tasación interna',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      266,
      30,
      'P12_ObtencionTasacionInterna',
      1,
      'Obtención tasación interna',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      267,
      30,
      'P12_EstConformidadOAlegacion',
      'valores[''P12_EstConformidadOAlegacion''][''combo''] == DDSiNo.NO ? ''alegaciones'' : ''conforme''',
      0,
      'Estudiar conformidad o alegación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1312,
      642,
      'P91_MarcarAgenda9514',
      0,
      'Marcar agenda de mora + 9514',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      268,
      30,
      'P12_PresentarAlegaciones',
      0,
      'Presentar alegaciones',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      269,
      30,
      'P12_RegistrarResultado',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      270,
      33,
      'P15_InterposicionDemandaMasBienes',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pestaña Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null)',
      0,
      'Interposición de la demanda + Marcado de bienes',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      271,
      33,
      'P15_AutoDespaEjecMasDecretoEmbargo',
      'plugin/procedimientos/ejecucionTituloNoJudicial/autoDespachandoEjecucion',
      'valores[''P15_AutoDespaEjecMasDecretoEmbargo''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Auto despachando ejecución + Marcado bienes decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      272,
      33,
      'P15_RegistrarAnotacionRegistro',
      'valores[''P15_RegistrarAnotacionRegistro''][''repetir''] == DDSiNo.SI ? ''repite'' : ''avanzaBPM''',
      0,
      'Confirmar anotación en el registro',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      274,
      33,
      'P15_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de Notificación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      276,
      33,
      'P15_ConfirmarPresentacionImpugnacion',
      0,
      'Confirmar presentación impugnación',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      280,
      33,
      'P15_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      401,
      141,
      'P22_SolicitudConcursal',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Presentar solicitud concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      402,
      141,
      'P22_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoSolicitudConcursal/confirmarAdmision',
      0,
      'Confirmar admisión',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      403,
      141,
      'P22_ConfirmarNotificacionDemandado',
      0,
      'Confirmar notificación demandado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      404,
      141,
      'P22_registrarOposicion',
      '( (valores[''P22_registrarOposicion''][''comboOposicion''] == DDSiNo.SI) && ((valores[''P22_registrarOposicion''][''fechaOposicion''] == '''') || (valores[''P22_registrarOposicion''][''fechaVista''] == '''')) ) ? ''tareaExterna.error.faltaAlgunaFecha'':null',
      'valores[''P22_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : (valores[''P22_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? ''NO'':''ALLANAMIENTO'')',
      0,
      'Registrar oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      405,
      141,
      'P22_RegistrarVista',
      0,
      'Registrar vista',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      406,
      141,
      'P22_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      407,
      141,
      'P22_ResolucionFirme',
      'valores[''P22_RegistrarResolucion''][''comboResultado''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable''',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      408,
      141,
      'P22_AutoDeclarandoConcurso',
      'valores[''P22_AutoDeclarandoConcurso''][''comboEligeTramite''] == DDAccionAuto.ORDINARIO ? ''NO'' : ''SI''',
      0,
      'Auto declarando concurso',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      409,
      141,
      'P22_BPMtramiteFaseComunOrdinario',
      143,
      0,
      'Se inicia Trámite fase común ordinario',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      410,
      141,
      'P22_BPMtramiteFaseComunAbreviado',
      142,
      0,
      'Se inicia Trámite fase común abreviado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      411,
      142,
      'P23_registrarPublicacionBOE',
      'plugin/procedimientos/tramiteFaseComunOrdinario/regPublicacionBOE',
      0,
      'Registrar publicación en el BOE',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      601
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      412,
      142,
      'P23_regInsinuacionCreditosSup',
      '(valores[''P23_regInsinuacionCreditosSup''][''comboPropuesta''] == DDSiNo.SI) ? (((valores[''P23_regInsinuacionCreditosSup''][''numCreditos''] == '''') || (valores[''P23_regInsinuacionCreditosSup''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : ((cuentaCreditosInsinuadosSupUGAS()!=valores[''P23_regInsinuacionCreditosSup''][''numCreditos'']) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)) : null',
      0,
      'Registrar insinuación de créditos inicial',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      601
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      413,
      142,
      'P23_registrarInsinuacionCreditosExt',
      '((valores[''P23_registrarInsinuacionCreditosExt''][''numCreditos''] == '''') || (valores[''P23_registrarInsinuacionCreditosExt''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : ((cuentaCreditosInsinuadosExtUGAS()!=valores[''P23_registrarInsinuacionCreditosExt''][''numCreditos'']) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'': null)',
      0,
      'Registrar insinuación de créditos - gestor',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      414,
      142,
      'P23_registrarInsinuacionCreditosDef',
      '((valores[''P23_registrarInsinuacionCreditosDef''][''numCreditos''] == '''') || (valores[''P23_registrarInsinuacionCreditosDef''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : cuentaCreditosInsinuadosExtUGAS()!=valores[''P23_registrarInsinuacionCreditosDef''][''numCreditos'']? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'': null',
      0,
      'Registrar insinuación de créditos gestor Letrado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      415,
      142,
      'P23_presentarEscritoInsinuacionCreditos',
      'plugin/procedimientos/tramiteFaseComunAbreviado/presentarEscritoInsinuacionCreditos',
      'creditosDefinitivosDefinidosEInsinuadosUGAS() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosNoInsinuados''',
      0,
      'Presentar escrito de insinuación de créditos',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      416,
      142,
      'P23_informeAdministracionConcursal',
      'creditosDefinitivosPendientesUGAS() ? ''tareaExterna.procedimiento.tramiteFaseComun.creditosDefinitivosPendientes'': null',
      0,
      'Registrar informe administración concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      417,
      142,
      'P23_revisarResultadoInfAdmon',
      'valores[''P23_revisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ( creditosDespuesDeIACConDemandaUGAS() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACDemandaMalDefinidos'' ) : ( creditosDespuesDeIACSinDemandaUGAS() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos'')',
      'valores[''P23_revisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Revisar resultado informe administración concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      418,
      142,
      'P23_BPMTramiteDemandaIncidental',
      144,
      0,
      'Se inicia Trámite demanda incidental',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      419,
      143,
      'P24_registrarPublicacionBOE',
      'plugin/procedimientos/tramiteFaseComunOrdinario/regPublicacionBOE',
      0,
      'Registrar publicación en el BOE',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      601
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      420,
      143,
      'P24_regInsinuacionCreditosSup',
      '(valores[''P24_regInsinuacionCreditosSup''][''comboPropuesta''] == DDSiNo.SI) ? (((valores[''P24_regInsinuacionCreditosSup''][''numCreditos''] == '''') || (valores[''P24_regInsinuacionCreditosSup''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : ((cuentaCreditosInsinuadosSupUGAS()!=valores[''P24_regInsinuacionCreditosSup''][''numCreditos'']) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'' : null)) : null',
      0,
      'Registrar insinuación de créditos inicial',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      601
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      421,
      143,
      'P24_registrarInsinuacionCreditosExt',
      '((valores[''P24_registrarInsinuacionCreditosExt''][''numCreditos''] == '''') || (valores[''P24_registrarInsinuacionCreditosExt''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : ((cuentaCreditosInsinuadosExtUGAS()!=valores[''P24_registrarInsinuacionCreditosExt''][''numCreditos'']) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'': null)',
      0,
      'Registrar insinuación de créditos - gestor',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      422,
      143,
      'P24_registrarInsinuacionCreditosDef',
      '((valores[''P24_registrarInsinuacionCreditosDef''][''numCreditos''] == '''') || (valores[''P24_registrarInsinuacionCreditosDef''][''numCreditos''] == ''0'')) ? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditos'' : cuentaCreditosInsinuadosExtUGAS()!=valores[''P24_registrarInsinuacionCreditosDef''][''numCreditos'']? ''tareaExterna.procedimiento.tramiteFaseComun.numCreditosInsinuados'': null',
      0,
      'Registrar insinuación de créditos gestor Letrado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      423,
      143,
      'P24_presentarEscritoInsinuacionCreditos',
      'plugin/procedimientos/tramiteFaseComunAbreviado/presentarEscritoInsinuacionCreditos',
      'creditosDefinitivosDefinidosEInsinuadosUGAS() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosNoInsinuados''',
      'valores[''P24_presentarEscritoInsinuacionCreditos''][''comFavorable''] == DDSiNo.SI ? ''SI'' : ''NO'' ',
      0,
      'Presentar escrito de insinuación de créditos',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      424,
      143,
      'P24_informeAdministracionConcursal',
      'creditosDefinitivosPendientesUGAS() ? ''tareaExterna.procedimiento.tramiteFaseComun.creditosDefinitivosPendientes'': null',
      0,
      'Registrar informe administración concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      425,
      143,
      'P24_revisarResultadoInfAdmon',
      'valores[''P24_revisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ( creditosDespuesDeIACConDemandaUGAS() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACDemandaMalDefinidos'' ) : ( creditosDespuesDeIACSinDemandaUGAS() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos'')',
      'valores[''P24_revisarResultadoInfAdmon''][''comAlegaciones''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Revisar resultado informe administración concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      426,
      143,
      'P24_BPMTramiteDemandaIncidental',
      144,
      0,
      'Se inicia Trámite demanda incidental',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      427,
      144,
      'P25_interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      428,
      144,
      'P25_confirmarAdmisionDemanda',
      'valores[''P25_confirmarAdmisionDemanda''][''comboAdmision''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      429,
      144,
      'P25_confirmarOposicion',
      '( ((valores[''P25_confirmarOposicion''][''comboOposicion''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''fechaOposicion''] == ''''))  || ((valores[''P25_confirmarOposicion''][''comboAllanamiento''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''fechaAllanamiento''] == ''''))) ? ''tareaExterna.error.faltaAlgunaFecha'' : ( (valores[''P25_confirmarOposicion''][''comboOposicion''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''comboAllanamiento''] == DDSiNo.SI) && (valores[''P25_confirmarOposicion''][''observaciones''] == '''') ) ? ''tareaExterna.procedimiento.tramiteDemandaIncidental.confirmarOposicion.campoObservaciones'' : ''null'' ',
      'valores[''P25_confirmarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : ''NO'' ',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      430,
      144,
      'P25_registrarVista',
      0,
      'Registrar vista',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      431,
      144,
      'P25_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      432,
      144,
      'P25_resolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      433,
      145,
      'P26_notificacionDemandaIncidental',
      'plugin/procedimientos/ejecucionTituloJudicial/interposicionDemanda',
      0,
      'Notificación demanda incidental',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      434,
      145,
      'P26_dictarInstrucciones',
      'valores[''P26_dictarInstrucciones''][''comboInstrucciones''] == DDInstrucciones.OPOSICION ? ''SI'' : ''NO''',
      1,
      'Dictar instrucciones',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      435,
      145,
      'P26_registrarOposicion',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Registrar oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      436,
      145,
      'P26_admisionEscritoOposicion',
      '(valores[''P26_admisionEscritoOposicion''][''comboVista''] == DDSiNo.SI && valores[''P26_admisionEscritoOposicion''][''fechaVista''] == '''') ? ''tareaExterna.error.P10_RegistrarImpugnacion.fechasOblgatorias'' : null',
      'valores[''P26_admisionEscritoOposicion''][''comboVista''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Admisión escrito oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      437,
      145,
      'P26_registrarVista',
      0,
      'Registrar vista',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      438,
      145,
      'P26_registrarResolucionOposicion',
      'valores[''P26_registrarResolucionOposicion''][''resultado''] == DDFavorable.FAVORABLE ? ''FAVORABLE'' : ''NO FAVORABLE'' ',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      439,
      145,
      'P26_registrarAllanamiento',
      0,
      'Registrar allanamiento',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      440,
      145,
      'P26_admisionEscritoAllanamiento',
      0,
      'Admisión escrito allanamiento',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      441,
      145,
      'P26_registrarResolucionAllanamiento',
      'valores[''P26_registrarResolucionAllanamiento''][''resultado''] == DDFavorable.FAVORABLE ? ''FAVORABLE'' : ''NO FAVORABLE'' ',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      442,
      145,
      'P26_resolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      443,
      146,
      'P27_presentarSolicitud',
      0,
      'Presentar solicitud',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      444,
      146,
      'P27_RegistrarResultadoSolicitud',
      0,
      'Registrar resultado solicitud',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      445,
      147,
      'P28_registrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1315,
      642,
      'P91_certificacionNotarial',
      0,
      'Registrar certificación notarial',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1316,
      642,
      'P91_mandarBurofax',
      0,
      'Mandar burofax',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1317,
      642,
      'P91_registrarAcuseRecibo',
      0,
      'Registrar acuse de recibo',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      449,
      148,
      'P29_autoApertura',
      0,
      'Auto apertura',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      450,
      148,
      'P29_decidirSobreFaseComun',
      'valores[''P29_decidirSobreFaseComun''][''comboPropio''] == DDSiNo.NO ? (valores[''P29_decidirSobreFaseComun''][''comboSeguimiento''] == DDSiNo.NO ? ''terminar'' : ''soloSeguimiento'') : (valores[''P29_decidirSobreFaseComun''][''comboSeguimiento''] == DDSiNo.NO ? ''soloPropia'' : ''propiaSeguimiento'')',
      1,
      'Decidir sobre fase convenio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      451,
      148,
      'P29_actPropuestaConvenio',
      'valores[''P29_actPropuestaConvenio''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI'' ',
      0,
      'Actualizar propuestas de convenio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      452,
      148,
      'P29_aceptarFinSeguimiento',
      'valores[''P29_aceptarFinSeguimiento''][''combo''] == DDSiNo.NO ? ''NO'' : ''SI'' ',
      1,
      'Aceptar fin de seguimiento',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      453,
      148,
      'P29_BPMtramitePresentacionPropConvenio',
      152,
      0,
      'Se inicia Trámite de presentación propuesta de convenio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      454,
      148,
      'P29_dictarInstrucciones',
      ' checkPosturaEnConveniosDeTercerosOConcursadoUGAS() ?  null  : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura'' ',
      1,
      'Dictar instrucciones junta acreedores',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      455,
      148,
      'P29_lecturaAceptacionInstrucciones',
      'plugin/procedimientos/tramiteFaseConvenio/lecturaYaceptacion',
      ' checkPosturaEnConveniosDeTercerosOConcursadoUGAS() ?  null  : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura'' ',
      'valores[''P29_lecturaAceptacionInstrucciones''][''comboAceptacion''] == DDSiNo.SI ? ''SI'' : ''NO'' ',
      0,
      'Lectura y aceptación instrucciones junta acreedores',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      456,
      148,
      'P29_registrarResultado',
      'plugin/procedimientos/tramiteFaseConvenio/registrarResultadoConvenio',
      ' existeNumeroAuto() ? ( checkPosturaEnConveniosDeTercerosOConcursadoUGAS() ? ((valores[''P29_registrarResultado''][''algunConvenio''] == DDSiNo.SI) ? ( unConvenioAprovadoEnJunta() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noHayConvenioAprovado'' ) : (todosLosConveniosNoAdmitidos() ? null : ''tareaExterna.procedimiento.tramiteFaseConvenio.todosLosConvenioDebenEstarNoAdmitidos'')) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioSinPostura'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto'' ',
      'valores[''P29_registrarResultado''][''algunConvenio''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar resultado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      581,
      165,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      582,
      165,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      583,
      165,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      584,
      165,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      585,
      165,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      586,
      165,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      587,
      165,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      588,
      166,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      589,
      166,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1318,
      642,
      'P91_mandarExpediente',
      0,
      'Enviar expediente',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1319,
      642,
      'P91_marcarAgenda9515',
      0,
      'Marcar agenda de mora + 9515',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1320,
      642,
      'P91_BPMAceptacionYdecision',
      341,
      0,
      'Se inicia el trámite de Aceptación y Decisión',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:50.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1313,
      642,
      'P91_bloquearCuentas',
      0,
      'Bloquear cuentas',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1314,
      642,
      'P91_generarCertificadoDeuda',
      0,
      'Generar certificación de la deuda',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      590,
      166,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      591,
      166,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      592,
      166,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      593,
      166,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      594,
      166,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      595,
      166,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      596,
      166,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  COMMIT;
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      597,
      167,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      598,
      167,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      600,
      167,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      601,
      167,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      603,
      167,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      604,
      168,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      605,
      168,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      606,
      168,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      607,
      168,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      608,
      168,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      609,
      168,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      610,
      168,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      611,
      168,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      612,
      168,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      613,
      169,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      614,
      169,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      615,
      169,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      616,
      169,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      617,
      169,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      618,
      169,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      619,
      169,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      620,
      170,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      621,
      170,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      622,
      170,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      623,
      170,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      624,
      170,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      625,
      170,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      626,
      170,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      628,
      171,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      629,
      171,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      630,
      171,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      631,
      171,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      632,
      171,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      633,
      171,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      634,
      171,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      635,
      171,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      636,
      172,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      637,
      172,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      638,
      172,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      639,
      172,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      640,
      172,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      641,
      172,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      642,
      172,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      643,
      173,
      'P54_regPorcentajePropiedadAdjudicada',
      0,
      'Registrar porcentaje de propiedad adjudicada',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      644,
      173,
      'P54_regSolicitudPosesion',
      'valores[''P54_regSolicitudPosesion''][''ocupado''] == DDSiNo.SI ? ''Ocupada'' : ''NoOcupada''',
      0,
      'Registrar solicitud de posesión',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      645,
      173,
      'P54_solicitarLanzamiento',
      0,
      'Solicitar lanzamiento',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      646,
      173,
      'P54_confirmarAdmisionLanzamiento',
      0,
      'Confirmar admisión lanzamiento',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      647,
      173,
      'P54_notificarAOcupantes',
      '(valores[''P54_notificarAOcupantes''][''notificacion''] == DDSiNo.SI)&&(valores[''P54_notificarAOcupantes''][''fecha''] == '''') ? ''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'' : null ',
      'valores[''P54_notificarAOcupantes''][''notificacion''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Notificar a ocupantes',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      648,
      173,
      'P54_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de Notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      649,
      173,
      'P54_registrarVista',
      0,
      'Registrar vista',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      650,
      173,
      'P54_registrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      651,
      173,
      'P54_registrarPosesion',
      0,
      'Registrar posesión',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      652,
      173,
      'P54_registrarLanzamientoEfectivo',
      0,
      'Registrar lanzamiento efectivo',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      653,
      173,
      'P54_registrarCambioCerradura',
      0,
      'Registrar cambio cerradura',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      654,
      173,
      'P54_registrarPersonaDepLlaves',
      0,
      'Registrar persona depositaria de las llaves',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1310,
      642,
      'P91_recopilarDocumentacion',
      0,
      'Recopilar documentación',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      801,
      29,
      'P11_AnuncioSubasta_new1',
      '( ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaAnuncio''] == '''')) || ((valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI) && (valores[''P11_AnuncioSubasta_new1''][''fechaSubasta''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':null',
      'valores[''P11_AnuncioSubasta_new1''][''comboResultado''] == DDSiNo.SI ? ''si'' : ''no''',
      0,
      'Anuncio de Subasta',
      0,
      'DD',
      TO_TIMESTAMP('23/04/2010 17:24:01.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      901,
      241,
      'P60_RegistrarAnotacion',
      'isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pestaña Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>o'' : null',
      0,
      'Confirmar anotación en el registro',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      902,
      241,
      'P60_RevisarRegistroDeEmbargo',
      'valores[''P60_RevisarRegistroDeEmbargo''][''repetir''] == DDSiNo.SI ? ''recordatorio'' : ''terminar''',
      0,
      'Revisar registro de embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      903,
      35,
      'P17_CnfAdmiDemaDecretoEmbargo_new1',
      'plugin/procedimientos/procedimientoCambiario/confirmarAdmisionDemanda',
      'valores[''P17_CnfAdmiDemaDecretoEmbargo_new1''][''comboAdmisionDemanda''] == DDSiNo.SI ? ( valores[''P17_CnfAdmiDemaDecretoEmbargo_new1''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''',
      0,
      'Confirmar admisión + marcado bienes decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      904,
      35,
      'P17_BPMVigilanciaCaducidadAnotacion',
      241,
      0,
      'Ejecución de Vigilancia caducidad anotación de embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      905,
      34,
      'P16_AutoDespachando_new1',
      'valores[''P16_AutoDespachando_new1''][''comboSiNo''] == DDSiNo.SI ? ( valores[''P16_AutoDespachando_new1''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''',
      0,
      'Auto Despachando ejecución + Marcado de bienes decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      906,
      34,
      'P16_BPMVigilanciaCaducidadAnotacion',
      241,
      0,
      'Ejecución de Vigilancia caducidad anotación de embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      907,
      33,
      'P15_AutoDespaEjecMasDecretoEmbargo_new1',
      'plugin/ugas/procedimientos/ejecucionTituloNoJudicial/autoDespachandoEjecucionUGAS',
      'valores[''P15_AutoDespaEjecMasDecretoEmbargo_new1''][''comboAdmisionDemanda''] == DDSiNo.SI ? ( valores[''P15_AutoDespaEjecMasDecretoEmbargo_new1''][''comboBienesRegistrables''] == DDSiNo.SI ? ''AdmitidoYBienesRegistrables'' : ''Admitido'') : ''NoAdmitido''',
      0,
      'Auto despachando ejecución + Marcado bienes decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      908,
      33,
      'P15_BPMVigilanciaCaducidadAnotacion',
      241,
      0,
      'Ejecución de Vigilancia caducidad anotación de embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      909,
      32,
      'P14_RegistroDecretoEmbargo_new1',
      'valores[''P14_RegistroDecretoEmbargo_new1''][''comboResultado''] == DDSiNo.SI ? ''si'' : ''no''',
      0,
      'Confirmar registro decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      910,
      32,
      'P14_BPMVigilanciaCaducidadAnotacion',
      241,
      0,
      'Ejecución de Vigilancia caducidad anotación de embargo',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      281,
      35,
      'P17_InterposicionDemandaMasBienes',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : (tieneBienes() && !isBienesConFechaSolicitud() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pestaña Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>'' : null)',
      0,
      'Interposición de la demanda + Marcado de bienes',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      457,
      148,
      'P29_RegistrarOposicionAdmon',
      '(((valores[''P29_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI) && (valores[''P29_RegistrarOposicionAdmon''][''fechaOposicion''] == '''')) || ((valores[''P29_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.SI) && (valores[''P29_RegistrarOposicionAdmon''][''fechaAdmision''] == '''')) ) ? ''tareaExterna.error.faltaAlgunaFecha'': ((valores[''P29_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO) && (valores[''P29_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI) ? ''tareaExterna.error.combinacionIncoherente'' : (((valores[''P29_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.SI) && (NoExisteConvenioAdmitidoTrasAprovacion()))? ''tareaExterna.procedimiento.tramiteFaseComun.faltaConvAdmitidoTA'':(((valores[''P29_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO)&&(valores[''P29_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.NO)&&(NoExisteConvenioNoAdmitidoTrasAprovacion()))?''tareaExterna.procedimiento.tramiteFaseComun.faltaConvenioNoAdmitidoTrasAprovacion'': null)))'
      ,
      'valores[''P29_RegistrarOposicionAdmon''][''comboAdmision''] == DDSiNo.NO ? ''NOADMISION'' : valores[''P29_RegistrarOposicionAdmon''][''comboOposicion''] == DDSiNo.SI ? ''SIOPOSICION'' : ''ADMSIOPONO''',
      0,
      'Registrar oposición y admisión judicial',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1311,
      642,
      'P91_recepcionDocumentos',
      0,
      'Registrar documentación',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:43.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      458,
      148,
      'P29_registrarResolucionOposicion',
      'todosLosConvenioEnEstadoFinal() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal'' ',
      0,
      'Registrar resolución oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      459,
      148,
      'P29_registrarResultadoSubsana',
      'todosLosConvenioEnEstadoFinal() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noTodosLosConvneiosEstanEnEstadoFinal'' ',
      'valores[''P29_registrarResultadoSubsana''][''comboSubsana''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar resultado subsanación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      460,
      148,
      'P29_BPMTramiteFaseLiquidacion',
      150,
      0,
      'Se inicia Trámite fase de liquidación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1117,
      152,
      'P35_determinarConfeccionDeConvenio',
      '((valores[''P35_determinarConfeccionDeConvenio''][''comboConvenioSup''] == DDSiNo.SI)) ?  ''supervisor'' : ''gestor''',
      1,
      'Determinar confección del convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      467,
      150,
      'P31_aperturaFase',
      0,
      'Registrar resolución de apertura fase liquidación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      468,
      150,
      'P31_InformeLiquidacion',
      0,
      'Registrar Plan de liquidación de la Administración Concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      469,
      150,
      'P31_decidirPresentarObs',
      'valores[''P31_decidirPresentarObs''][''comboObservaciones''] == DDSiNo.SI ? ''SI'' : ''NO''',
      1,
      'Decisión sobre presentación de observaciones al plan liquidación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      470,
      150,
      'P31_presentarObs',
      0,
      'Presentar observaciones al plan de liquidación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      471,
      150,
      'P31_regResolucionAprovacion',
      0,
      'Registrar resolución de aprobación de liquidación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      472,
      150,
      'P31_regDecisionSeguimiento',
      'valores[''P31_regDecisionSeguimiento''][''comboSeguimiento''] == DDSiNo.SI ? ''SI'' : ''NO''',
      1,
      'Registrar decisión seguimiento fase de liquidación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      473,
      150,
      'P31_regInformeTrimestral1',
      0,
      'Registrar inf. trimestral administración concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      474,
      150,
      'P31_regInformeTrimestral2',
      'valores[''P31_regInformeTrimestral2''][''comboCierre''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar inf. trimestral administración concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      475,
      150,
      'P31_separacionAdministradores',
      'valores[''P31_separacionAdministradores''][''comboSeparacion''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Tomar decisión sobre separación de los administradores concursales',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      476,
      150,
      'P31_presentarSeparacion',
      0,
      'Presentar solicitud separación de los administradores',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      477,
      150,
      'P31_registrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      478,
      151,
      'P34_aperturaLiquidacion',
      0,
      'Apertura fase de calificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      479,
      151,
      'P34_personacionFaseLiquidacion',
      'valores[''P34_personacionFaseLiquidacion''][''comboPersonarse''] == DDSiNo.SI ? ''SI'' : ''NO''',
      1,
      'Personación fase de calificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      480,
      151,
      'P34_escritoPersonacion',
      0,
      'Escrito personación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      481,
      151,
      'P34_registrarCalificacionConcursal',
      0,
      'Registrar calificación administración concursal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      482,
      151,
      'P34_registrarCalificacionFiscal',
      0,
      'Registrar calificación ministerio fiscal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      483,
      151,
      'P34_registrarOposicion',
      'valores[''P34_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Registrar oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      484,
      151,
      'P34_registrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      485,
      151,
      'P34_resolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      486,
      151,
      'P34_BPMtramiteDemandaIncidental',
      144,
      0,
      'Se inicia Trámite Demanda incidental',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1111,
      149,
      'P30_resgistrarNumProcedimiento',
      0,
      'Confirmar solicitud',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:02.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1112,
      149,
      'P30_registrarPropAnticipadaConvenio',
      'existeConvenioAnticipado() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipado''',
      0,
      'Registrar propuesta anticipada convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1113,
      149,
      'P30_BPMTramiteAdhesionConvenio',
      0,
      'Se inicia el trámite de adhesión a convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1114,
      149,
      'P30_admisionTramiteConvenio',
      'existeConvenioAnticipado() ? ( valores[''P30_admisionTramiteConvenio''][''comboAdmitido''] == DDSiNo.SI ? (existeConvenioAnticipadoAdmitido() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoAdmitido'') : (existeConvenioAnticipadoNoAdmitido() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoNoAdmitido'')) : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipado''',
      'valores[''P30_admisionTramiteConvenio''][''comboAdmitido''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Admisión a tramite propuesta de convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1115,
      149,
      'P30_informeAdmonConcursal',
      'existeConvenioAnticipado() ? ( valores[''P30_informeAdmonConcursal''][''comboRatificacion''] == ''1'' ? null : (    
(valores[''P30_informeAdmonConcursal''][''comboRatificacion''] == ''2'' ?        
(existeConvenioAnticipadoNoAdmitidoTrasAprobacion() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoNoAdmitidoTrasAprobacion'')     
: (valores[''P30_informeAdmonConcursal''][''comboRatificacion''] == ''3'' ?           
(existeConvenioAnticipadoAdmitidoTrasAprobacion() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoAdmitidoTrasAprobacion'')          
: null )    
))) : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipado''',
      'valores[''P30_informeAdmonConcursal''][''comboRatificacion''] == ''2'' ? ''noDescartar'' : ''favOContinuar''',
      0,
      'Registrar inf. admon. concursal sobre convenio  anticipado',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:05.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1116,
      149,
      'P30_RegResolucionConvenio',
      'existeConvenioAnticipadoAdmitido() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.noHayConvenioAnticipadoAdmitido''',
      0,
      'Registrar resolución de convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:07.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  COMMIT;
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      487,
      153,
      'P32_instruccionesProcedimiento',
      '((valores[''P32_instruccionesProcedimiento''][''comboEstafa''] == DDSiNo.NO) && (valores[''P32_instruccionesProcedimiento''][''comboApropiacion''] == DDSiNo.NO) && (valores[''P32_instruccionesProcedimiento''][''comboAlzamiento''] == DDSiNo.NO) && (valores[''P32_instruccionesProcedimiento''][''comboSocietario''] == DDSiNo.NO) && (valores[''P32_instruccionesProcedimiento''][''comboDocumental''] == DDSiNo.NO) ) ? ''tareaExterna.error.P32_instruccionesProcedimiento.unDelito'':null',
      1,
      'Instrucciones procedimiento penal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      488,
      153,
      'P32_interposicionDemandaQuerella',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda o querella',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      489,
      153,
      'P32_confAdmisionDemanda',
      'plugin/procedimientos/procedimientoAbreviado/confAdmisionDemanda',
      'valores[''P32_confAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      490,
      153,
      'P32_declaracionImputados',
      0,
      'Declaración imputados',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      491,
      153,
      'P32_autoAperturaOral',
      0,
      'Auto apertura oral',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      492,
      153,
      'P32_escritoCalificacionProvisional',
      'plugin/procedimientos/procedimientoAbreviado/escritoCalificacionProvisional',
      0,
      'Escrito calificación provisional',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      493,
      153,
      'P32_autoJuzgadoPenal',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      0,
      'Auto juzgado de lo penal',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      494,
      153,
      'P32_registrarJuicio',
      0,
      'Registrar juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      495,
      153,
      'P32_registrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      496,
      153,
      'P32_resolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      497,
      154,
      'P33_autoArchivo',
      0,
      'Auto de archivo',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      498,
      154,
      'P33_dictarInstrucciones',
      'valores[''P33_dictarInstrucciones''][''comboRecurrir''] == DDSiNo.SI ? ''SI'' : ''NO''',
      1,
      'Dictar instrucciones',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      499,
      154,
      'P33_presentarRecurso',
      0,
      'Presentar recurso',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      500,
      154,
      'P33_registrarAuto',
      'valores[''P33_registrarAuto''][''comboResultado''] == DDFavorable.FAVORABLE ? ''FAVORABLE'' : ''DESFAVORABLE''',
      0,
      'Registrar auto',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      501,
      154,
      'P33_recurrirAudiencia',
      0,
      'Recurrir audiencia provisional',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      502,
      154,
      'P33_registrarResultado',
      0,
      'Recurrir resultado',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      503,
      155,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      504,
      155,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      505,
      155,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      506,
      155,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      507,
      155,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      509,
      155,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      510,
      155,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      511,
      155,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      512,
      156,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      513,
      156,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      515,
      156,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      516,
      156,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      517,
      156,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      518,
      156,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      519,
      157,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      520,
      157,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      521,
      157,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      522,
      157,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      523,
      157,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      524,
      157,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      525,
      157,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      526,
      157,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      527,
      157,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      528,
      158,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      529,
      158,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      530,
      158,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      531,
      158,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      532,
      158,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      533,
      158,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      534,
      158,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      536,
      159,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      537,
      159,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      538,
      159,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      539,
      159,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      540,
      159,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      541,
      159,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      542,
      159,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      543,
      159,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      544,
      160,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      545,
      160,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      546,
      160,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      547,
      160,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      548,
      160,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      549,
      160,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      550,
      160,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      551,
      161,
      'P42_PagoDeImpuestos',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      0,
      'Pago de impuestos / tasas',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      552,
      161,
      'P42_InscribirEnRegistroPropiedad',
      0,
      'Inscribir en registro de propiedad',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      553,
      161,
      'P42_RegistrarEnCatastro',
      0,
      'Registrar en Catastro',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      554,
      161,
      'P42_CambiarNombre',
      0,
      'Cambio de nombre',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      555,
      161,
      'P42_InformarCambioPropiedad',
      0,
      'Informar a la comunidad',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      556,
      162,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      557,
      162,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      558,
      162,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      559,
      162,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      560,
      162,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      561,
      162,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      562,
      162,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      563,
      162,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      564,
      162,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      565,
      163,
      'P04_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      566,
      163,
      'P04_ConfirmarAdmisionDemanda',
      'plugin/procedimientos/procedimientoVerbal/confirmarAdmisionDemanda',
      'valores[''P04_ConfirmarAdmisionDemanda''][''comboAdmisionDemanda''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      567,
      163,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      568,
      163,
      'P04_BPMtramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      569,
      163,
      'P04_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      570,
      163,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      571,
      163,
      'P04_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      572,
      164,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      573,
      164,
      'P03_ConfirmarAdmision',
      'plugin/procedimientos/procedimientoOrdinario/confirmarAdmisionDemanda',
      'valores[''P03_ConfirmarAdmision''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Confirmar admisión de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      574,
      164,
      'P03_ConfirmarNotDemanda',
      '((valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P03_ConfirmarNotDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P03_ConfirmarNotDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      575,
      164,
      'P03_ConfirmarOposicion',
      '((valores[''P03_ConfirmarOposicion''][''comboResultado''] == DDSiNo.SI) && ((valores[''P03_ConfirmarOposicion''][''fechaOposicion''] == '''')))?''tareaExterna.error.P03_ConfirmarOposicion.fechasOblgatorias'':null',
      0,
      'Confirmar si existe oposición',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      576,
      164,
      'P03_RegistrarAudienciaPrevia',
      '((valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO) && (valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''] == ''''))?''tareaExterna.error.P03_RegistrarAudienciaPrevia.fechaOblgatoria'':null',
      'valores[''P03_RegistrarAudienciaPrevia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar audiencia prévia',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      579,
      164,
      'P03_ResolucionFirme',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      580,
      164,
      'P03_BPMTramiteNotificacion',
      24,
      0,
      'Se inicia Trámite de notificación',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      294,
      26,
      'P08_SolicitudCertificacion',
      0,
      'Solicitud de certificación de dominios y cargas',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      300,
      26,
      'P08_RequerirMasInfo',
      0,
      'Requerir información que falta',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      317,
      2,
      'P02_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      205,
      41,
      'P21_RegistrarJuicioVerbal',
      0,
      'Confirmar celebración del juicio verbal',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      210,
      29,
      'P11_DictarInstrucciones',
      'plugin/ugas/procedimientos/tramiteSubasta/dictarInstruccionesUGAS',
      1,
      'Dictar Instrucciones',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      230,
      34,
      'P16_AutoDespachando',
      'valores[''P16_AutoDespachando''][''comboSiNo''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Auto Despachando ejecución + Marcado de bienes decreto embargo',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      241,
      1,
      'P01_AutoDespachandoEjecucion',
      'plugin/procedimientos/procedimientoHipotecario/autoDespachandoEjecucion',
      'valores[''P01_AutoDespachandoEjecucion''][''comboResultado''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Auto despachando ejecución',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      602,
      167,
      'P04_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      627,
      171,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      508,
      155,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      514,
      156,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  COMMIT;
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      535,
      159,
      'P03_InterposicionDemanda',
      'plugin/procedimientos/procedimientoMonitorio/interposicionDemanda',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Interposición de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      578,
      164,
      'P03_RegistrarResolucion',
      0,
      'Registrar resolucion',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      320,
      2,
      'P02_ConfirmarOposicionCuantia',
      'plugin/procedimientos/procedimientoMonitorio/confirmarOposicionCuantia',
      '((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) && (valores[''P02_ConfirmarOposicionCuantia''][''fechaOposicion''] == ''''))?''El campo Fecha de oposici&oacute;n es obligatorio'':(((valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.SI) && (valores[''P02_ConfirmarOposicionCuantia''][''fechaJuicio''] == '''')  && (damePrincipal()<6000))?''El campo Fecha de juicio es obligatorio'':null)',
      'valores[''P02_ConfirmarOposicionCuantia''][''comboResultado''] == DDSiNo.NO ? ''NO'' : (procedimientoManager.getProcedimiento(idProcedimiento).getSaldoRecuperacion() > 6000 ? ''SI > 3000'' : ''SI < 3000'')',
      0,
      'Confirmar oposición y cuantía',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      231,
      34,
      'P16_RegistrarAnotacion',
      'isBienesConFechaDecreto() && !isBienesConFechaRegistro() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><div id="permiteGuardar"><p>&iexcl;Atenci&oacute;n! En  caso de que haya bienes a embargar, deber&iacute;a de marcarlos a trav&eacute;s de la pestaña Bienes dentro de la ficha de la propia actuaci&oacute;n.</p></div></div>o'' : null',
      'valores[''P16_RegistrarAnotacion''][''repetir''] == DDSiNo.SI ? ''repite'' : ''avanzaBPM''',
      0,
      'Confirmar anotación en el registro',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      299,
      26,
      'P08_RegistrarInformacionCargas',
      'valores[''P08_RegistrarInformacionCargas''][''comboCompletitud''] == DDCompletitud.COMPLETO ? ''Completo'' : ''Incompleto''',
      0,
      'Registrar recepción información cargas anteriores',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      599,
      167,
      'P04_ConfirmarNotifiDemanda',
      '((valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO) && (valores[''P04_ConfirmarNotifiDemanda''][''fecha''] == ''''))?''tareaExterna.error.PGENERICO_ConfirmarNotificacion.fechaOblgatoria'':null',
      'valores[''P04_ConfirmarNotifiDemanda''][''comboResultado''] == DDPositivoNegativo.POSITIVO ? ''SI'' : ''NO''',
      0,
      'Confirmar notificación de la demanda',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      577,
      164,
      'P03_RegistrarJuicio',
      0,
      'Confirmar celebración juicio',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1001,
      341,
      'P61_registrarAceptacion',
      'plugin/procedimientos/aceptacionYdecision/aceptacion',
      '((valores[''P61_registrarAceptacion''][''comboAceptacion''] == DDSiNo.SI) && (valores[''P61_registrarAceptacion''][''comboConflicto''] == DDSiNo.NO)) ?  ''NO'' : ''SI''',
      0,
      'Recogida de documentación y aceptación',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:52.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1002,
      341,
      'P61_validarNoAceptacion',
      'plugin/procedimientos/aceptacionYdecision/validarNoAceptacion',
      1,
      'Validar no aceptación del Asunto',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1003,
      341,
      'P61_BPMAceptacionYdecision',
      341,
      0,
      'Se inicia el trámite de Aceptación y Decisión',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:54.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1004,
      341,
      'P61_registrarDecisionProcedimiento',
      'plugin/procedimientos/aceptacionYdecision/decision',
      '(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P01'') ? ''hipotecario'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P02'') ? ''monitorio'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P03'') ? ''ordinario'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P17'') ? ''cambiario'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P32'') ? ''abreviado'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P16'') ? ''etj'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P15'') ? ''etnj'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P04'') ? ''verbal'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P24'') ? ''fcOrdinario'' : ( 
(valores[''P61_registrarDecisionProcedimiento''][''tipoProcedimiento''] == ''P56'') ? ''fcAbreviado'' :null)))))))))'
      ,
      0,
      'Registrar toma de decisión',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1005,
      341,
      'P61_BPMHipotecario',
      1,
      0,
      'Se inicia el procedimiento Hipotecario',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:56.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1006,
      341,
      'P61_BPMMonitorio',
      2,
      0,
      'Se inicia el procedimiento Monitorio',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:56.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1007,
      341,
      'P61_BPMOrdinario',
      21,
      0,
      'Se inicia el procedimiento Ordinario',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1008,
      341,
      'P61_BPMCambiario',
      35,
      0,
      'Se inicia el procedimiento Cambiario',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1009,
      341,
      'P61_BPMAbreviado',
      153,
      0,
      'Se inicia el procedimiento Abreviado',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1010,
      341,
      'P61_BPMETJ',
      34,
      0,
      'Se inicia el procedimiento Ejecución de título judicial',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1011,
      341,
      'P61_BPMETNJ',
      33,
      0,
      'Se inicia el procedimiento Ejecución de título no judicial',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1012,
      341,
      'P61_BPMVerbal',
      22,
      0,
      'Se inicia el procedimiento Verbal',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:59.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1301,
      641,
      'P92_marcajeLitigio',
      0,
      'Marcar litigio',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1302,
      641,
      'P92_recopilarDocumentacion',
      0,
      'Recopilar documentación',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1303,
      641,
      'P92_recepcionDocumentos',
      0,
      'Registrar documentación',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1304,
      641,
      'P92_generarCertificadoDeuda',
      0,
      'Generar certificación de la deuda',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1305,
      641,
      'P92_certificacionNotarial',
      0,
      'Registrar certificación notarial',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:50.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1306,
      641,
      'P92_mandarBurofax',
      0,
      'Mandar burofax',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1307,
      641,
      'P92_registrarAcuseRecibo',
      0,
      'Registrar acuse de recibo',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_TGE_ID,
      DD_STA_ID
    )
    VALUES
    (
      1308,
      641,
      'P92_mandarExpediente',
      0,
      'Enviar expediente',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      21,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1309,
      641,
      'P92_BPMAceptacionYdecision',
      341,
      0,
      'Se inicia el trámite de Aceptación y Decisión',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:59.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1101,
      142,
      'P23_actualizarEstadoCreditos',
      'creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos''',
      0,
      'Actualizar estado de los créditos insinuados',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1102,
      142,
      'P23_registrarFinFaseComun',
      'valores[''P23_registrarFinFaseComun''][''comboLiquidacion''] == DDSiNo.SI ? ''faseLiquidacion'' : ''faseConvenio''',
      0,
      'Registrar resolución finalización fase común',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1103,
      142,
      'P23_BPMTramiteFaseConvenio',
      148,
      0,
      'Se inicia la Fase de convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1104,
      142,
      'P23_BPMTramiteFaseLiquidacion',
      150,
      0,
      'Se inicia la Fase de liquidación',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1105,
      143,
      'P24_actualizarEstadoCreditos',
      'creditosDespuesDeIACSinDemanda() ? null : ''tareaExterna.procedimiento.tramiteFaseComun.creditosDespuesDeIACMalDefinidos''',
      0,
      'Actualizar estado de los créditos insinuados',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:51.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1106,
      143,
      'P24_registrarFinFaseComun',
      'valores[''P24_registrarFinFaseComun''][''comboLiquidacion''] == DDSiNo.SI ? ''faseLiquidacion'' : ''faseConvenio''',
      0,
      'Registrar resolución finalización fase común',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:52.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1107,
      143,
      'P24_BPMTramiteFaseConvenio',
      148,
      0,
      'Se inicia la Fase de convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1108,
      143,
      'P24_BPMTramiteFaseLiquidacion',
      150,
      0,
      'Se inicia la Fase de liquidación',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:54.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1109,
      341,
      'P61_BPMFaseComunOrdinario',
      143,
      0,
      'Se inicia Fase común ordinario',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:07:06.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1110,
      341,
      'P61_BPMFaseComunAbreviado',
      142,
      0,
      'Se inicia Fase común abreviado',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:07:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1118,
      152,
      'P35_registrarConvenioPropio',
      'existeNumeroAuto() ? ( convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto'' ',
      1,
      'Registrar convenio propio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:43.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1119,
      152,
      'P35_registrarConvenioPropioGestor',
      'existeNumeroAuto() ? ( convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.noExisteNumeroAuto'' ',
      0,
      'Registrar convenio propio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:43.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1120,
      152,
      'P35_presentarPropuesta',
      0,
      'Presentar propuesta',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1121,
      152,
      'P35_registrarAdmision',
      '((valores[''P35_registrarAdmision''][''comboAdmision''] == DDSiNo.SI) && (valores[''P35_registrarAdmision''][''comboSubsanable''] == '''')) ?  ''tareaExterna.error.faltaSubsanable'' : (convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? (creditosDefinidosEnConvenioPropioAdmitidoNoAdmitido() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioEstadoCorrecto'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido'')',
      '(valores[''P35_registrarAdmision''][''comboAdmision''] == DDSiNo.SI) ?  ''SI'' : ( (valores[''P35_registrarAdmision''][''comboSubsanable''] == DDSiNo.SI) ?  ''subsanable'' : ''noSubsanable'')',
      0,
      'Registrar admisión',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1122,
      152,
      'P35_registrarPresentacionSubsanacion',
      0,
      'Registrar presentación de subsanación',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1123,
      152,
      'P35_registrarResultado',
      'valores[''P35_registrarResultado''][''resultado''] == DDFavorable.FAVORABLE ? ''favorable'' : ''desfavorable'' ',
      0,
      'Registrar resultado subsanación',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1124,
      152,
      'P35_registrarInformeAdmConcursal',
      'existeConvenioAdmitido() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.existeConvenioAdmitido''',
      0,
      'Registrar escrito evaluación Administración Concursal',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1125,
      152,
      'P35_registrarAdhesiones',
      'convenioPropioDefinido() ? (creditosDefinidosEnConvenioPropioCompletados() ? (creditosDefinidosEnConvenioPropioAdmitidoNoAdmitido() ? (convenioPropioDefinidoConDescripAdhesiones() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioConDescripAdhesion'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioEstadoCorrecto'' ) : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.creditoConvenioPropioNoCompleto'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.convenioPropioNoDefinido''',
      0,
      'Registrar adhesiones',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1126,
      541,
      'P62_registrarCausaConclusion',
      0,
      'Registrar causa de conclusión',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:07.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1127,
      541,
      'P62_registrarInformeAdmConcursal',
      0,
      'Registrar informe/solicitud de la Administración Concursal',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:08.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1128,
      541,
      'P62_registrarOposicion',
      '((valores[''P62_registrarOposicion''][''comboOposicion''] == DDSiNo.SI) && ((valores[''P62_registrarOposicion''][''fechaOposicion''] == '''') || (valores[''P62_registrarOposicion''][''comboActor''] == '''')) ) ? ''tareaExterna.error.faltaFechaYparteOpositora'': ( ((valores[''P62_registrarOposicion''][''comboOposicion''] == DDSiNo.NO) && (valores[''P62_registrarOposicion''][''fechaAlegaciones''] == '''')) ? ''tareaExterna.error.faltaFechaAlegaciones'' : null ) ',
      'valores[''P62_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? ''sinOposicion'' : (valores[''P62_registrarOposicion''][''comboActor''] == ''01'' ? ''entidad'' : ''otros'')',
      0,
      'Registrar oposición',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1129,
      541,
      'P62_BPMTramiteDemandaIncidental',
      144,
      0,
      'Se inicia el trámite de Demanda incidental',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:11.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1130,
      541,
      'P62_registrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:11.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1131,
      541,
      'P62_registrarConclusionConcurso',
      'valores[''P62_registrarConclusionConcurso''][''conclusion''] == DDSiNo.NO ? ''noConcluye'' : ''concluye''',
      0,
      'Registrar conclusión del concurso',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:12.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1132,
      542,
      'P63_registrarDecisionAdhesion',
      'existeConvenioDeTercerosOConcursado() ? (todosLosConveniosNoNuestrosConAdhesionUGAS() ? (unConveniosNoNuestrosConAdhesionUGAS() ? null : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.unConveniosNoNuestrosConAdhesion''): ''tareaExterna.procedimiento.tramitePresentacionPropuesta.todosLosConveniosNoNuestrosConAdhesion'') : ''tareaExterna.procedimiento.tramitePresentacionPropuesta.existeConvenioDeTercerosOConcursado''',
      'valores[''P63_registrarDecisionAdhesion''][''comboAdhesion''] == DDSiNo.SI ? ''SI'' :''NO''',
      1,
      'Registrar decisión sobre adhesión',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1133,
      542,
      'P63_formalizarAdhesion',
      0,
      'Formalizar adhesión',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1134,
      543,
      'P64_registrarConvenio',
      0,
      'Registrar convenio aprobado',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1135,
      543,
      'P64_registrarCumplimiento',
      'valores[''P64_registrarCumplimiento''][''comboCumplimiento''] == DDSiNo.NO ? ''incumple'' : (valores[''P64_registrarCumplimiento''][''comboFinalizar''] == DDSiNo.SI ? ''cumpleTerminar'' : ''cumpleSeguir'')',
      0,
      'Registrar cumplimiento de convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      1136,
      543,
      'P64_validarFinSeguimiento',
      'valores[''P64_validarFinSeguimiento''][''comboValidar''] == DDSiNo.SI ? ''Aprovado'' : ''noAprovado''',
      1,
      'Validar fin de seguimiento de convenio',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000000,
      143,
      'P24_presentarSolicitudRectificacion',
      0,
      'Presentar solicitud de rectificación o complemento de datos',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000002,
      841,
      'P94_SolicitudConcursal',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>¡Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Presentar solicitud reapertura concurso',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000003,
      841,
      'P94_ConfirmarAdmision',
      'plugin/procedimientos/tramiteReaperturaConcurso/confirmarAdmision',
      0,
      'Confirmar admisión',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000004,
      841,
      'P94_ConfirmarNotificacionDemandado',
      0,
      'Confirmar notificación al concursado',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'Oscar',
      TO_TIMESTAMP('18/11/2013 12:48:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000005,
      841,
      'P94_registrarOposicion',
      '( (valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.SI) && ((valores[''P94_registrarOposicion''][''fechaOposicion''] == '''') || (valores[''P94_registrarOposicion''][''fechaVista''] == '''')) ) ? ''tareaExterna.error.faltaAlgunaFecha'':null',
      'valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? ''SI'' : (valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? ''NO'':''ALLANAMIENTO'')',
      0,
      'Registrar oposición',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000006,
      841,
      'P94_RegistrarVista',
      0,
      'Registrar vista',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000007,
      841,
      'P94_RegistrarResolucion',
      0,
      'Registrar resolución',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000008,
      841,
      'P94_ResolucionFirme',
      'valores[''P94_RegistrarResolucion''][''comboResultado''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable''',
      0,
      'Resolución firme',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000009,
      841,
      'P94_AutoDeclarandoConcurso',
      'valores[''P94_AutoDeclarandoConcurso''][''comboEligeTramite''] == DDAccionAuto.ORDINARIO ? ''NO'' : ''SI''',
      0,
      'Auto declarando reapertura de concurso',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000010,
      841,
      'P94_BPMtramiteFaseComunOrdinario',
      143,
      0,
      'Ejecución del Trámite fase común ordinario',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000011,
      841,
      'P94_BPMtramiteFaseComunAbreviado',
      142,
      0,
      'Ejecución del Trámite fase común abreviado',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000102,
      23,
      'P05_NotifcacionDecreAdjudicacion',
      0,
      'Notificación Decreto Adjudicación a la Entidad',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:41:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000103,
      23,
      'P05_NotificacionDecreContratio',
      0,
      'Notificación Decreto Adjudicación al Contrario',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:41:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000105,
      142,
      'P23_regComProyectoInventario',
      'valores[''P23_regComProyectoInventario''][''comFavorable''] == ''03'' ? ''null'' : ((valores[''P23_regComProyectoInventario''][''fechaComunicacion''] == '''' || valores[''P23_regComProyectoInventario''][''fechaComunicacion''] == null) ? ''tareaExterna.error.regComProyectoInventario.campoFechaObligatorio'' : ''null'')',
      'valores[''P23_regComProyectoInventario''][''comFavorable''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar comunicación proyecto inventario',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000104,
      142,
      'P23_presentarRectificacion',
      0,
      'Presentar solicitud de rectificación o complemento de datos',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:42:35.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000200,
      341,
      'P61_registrarDecisionProcedimiento_UNNIM',
      'plugin/procedimientos/aceptacionYdecision/decisionUNNIM',
      '((valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento'']==valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcPropuesto''])||(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcPropuesto'']==null)||(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcPropuesto'']==''''))?((valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P01'') ? ''hipotecario'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento'']==''P02'')?''monitorio'':( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento'']==''P03'')?''ordinario'':( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento'']==''P17'')?''cambiario'':( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P32'')?''abreviado'':( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P16'')?''etj'':( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P15'')?''etnj'':( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P04'')?''verbal'': valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''])))))))):''No'''
      ,
      0,
      'Registrar toma de decisión',
      0,
      'DD',
      TO_TIMESTAMP('25/05/2012 19:29:19.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000911,
      1041,
      'P95_registrarCelebracion3Subasta',
      'plugin/ugas/procedimientos/ejecucionNotarial/celebracionSubasta',
      'valores[''P95_registrarCelebracion3Subasta''][''comboCelebrada''] == DDSiNo.NO ? ''adjTercero3'' : (valores[''P95_registrarCelebracion3Subasta''][''adjudicacionTercero''] == DDSiNo.SI ? ''adjTercero3'' :  ''adjEntidad3'')',
      0,
      'Registrar celebración de tercera subasta',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:02.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000912,
      1041,
      'P95_registrarCesionRemate',
      0,
      'Registrar cesión de remate',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000913,
      1041,
      'P95_CorreoGestionActivos',
      'valores[''P95_CorreoGestionActivos''][''enviado''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Correo a gestión de activos',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000201,
      341,
      'P61_validarCambioActuacion',
      'plugin/procedimientos/aceptacionYdecision/validacionTipoProcedimientoPropuestoLetrado',
      '(valores[''P61_validarCambioActuacion''][''comboValidacion''] == DDSiNo.SI )? (  
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P01'') ? ''hipotecario'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P02'') ? ''monitorio'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P03'') ? ''ordinario'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P17'') ? ''cambiario'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P32'') ? ''abreviado'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P16'') ? ''etj'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P15'') ? ''etnj'' : ( 
(valores[''P61_registrarDecisionProcedimiento_UNNIM''][''tipoProcedimiento''] == ''P04'') ? ''verbal'' : null)))))))):''No''',
      1,
      'Validar cambio de actuacion',
      0,
      'DD',
      TO_TIMESTAMP('25/05/2012 19:29:20.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      40,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000300,
      142,
      'P23_asignarGestorLetradoSup',
      'tieneGestorYSupervisor() ? ''null'' : ''tareaExterna.procedimiento.tramiteFaseComun.sinGestorNiSupervisor'' ',
      0,
      'Preasignar Gestor Letrado y Supervisor',
      0,
      'DD',
      TO_TIMESTAMP('31/05/2012 9:53:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      601
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000301,
      143,
      'P24_asignarGestorLetradoSup',
      'tieneGestorYSupervisor() ? ''null'' : ''tareaExterna.procedimiento.tramiteFaseComun.sinGestorNiSupervisor'' ',
      0,
      'Preasignar Gestor Letrado y Supervisor',
      0,
      'DD',
      TO_TIMESTAMP('31/05/2012 9:57:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      601
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000302,
      143,
      'P24_regComProyectoInventario',
      'valores[''P24_regComProyectoInventario''][''comFavorable''] == ''03'' ? ''null'' : ((valores[''P24_regComProyectoInventario''][''fechaComunicacion''] == '''' || valores[''P24_regComProyectoInventario''][''fechaComunicacion''] == null) ? ''tareaExterna.error.regComProyectoInventario.campoFechaObligatorio'' : ''null'')',
      'valores[''P24_regComProyectoInventario''][''comFavorable''] == DDSiNo.NO ? ''NO'' : ''SI''',
      0,
      'Registrar comunicación proyecto inventario',
      0,
      'DD',
      TO_TIMESTAMP('31/05/2012 9:59:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000400,
      341,
      'P61_BPMSolicitudConcurso',
      141,
      0,
      'Se inicia el procedimiento Solicitud concurso necesario',
      0,
      'DD',
      TO_TIMESTAMP('04/06/2012 16:29:18.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000401,
      144,
      'P25_admisionOposicionYSeñalamientoVista',
      '( ((valores[''P25_admisionOposicionYSeñalamientoVista''][''admisionOp''] == DDSiNo.SI) && (valores[''P25_admisionOposicionYSeñalamientoVista''][''fechaResol''] == '''')) || ((valores[''P25_admisionOposicionYSeñalamientoVista''][''comboVista''] == DDSiNo.SI) && (valores[''P25_admisionOposicionYSeñalamientoVista''][''fechaVista''] == '''')) )?''tareaExterna.error.faltaAlgunaFecha'':null',
      'valores[''P25_admisionOposicionYSeñalamientoVista''][''comboVista''] == DDSiNo.NO || valores[''P25_admisionOposicionYSeñalamientoVista''][''admisionOp''] == DDSiNo.NO  ? ''NO'' : (valores[''P25_admisionOposicionYSeñalamientoVista''][''comboVista''] == DDSiNo.SI ? ''SI'': ''NO'' )',
      0,
      'Admisión de oposición y señalamiento de vista',
      0,
      'DD',
      TO_TIMESTAMP('05/06/2012 9:46:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000402,
      148,
      'P29_elevarAcomitePropuesta',
      0,
      'Elevar a comité la propuesta de instrucciones',
      0,
      'DD',
      TO_TIMESTAMP('05/06/2012 18:12:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000403,
      148,
      'P29_registrarResutladoComite',
      0,
      'Registrar el resultado del comité',
      0,
      'DD',
      TO_TIMESTAMP('05/06/2012 18:12:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000500,
      143,
      'P24_registrarAceptacion',
      'plugin/procedimientos/aceptacionYdecision/aceptacion',
      '((valores[''P24_registrarAceptacion''][''comboAceptacion''] == DDSiNo.SI) && (valores[''P24_registrarAceptacion''][''comboConflicto''] == DDSiNo.NO)) ?  ''SI'' : ''NO''',
      0,
      'Registrar aceptación de asunto',
      0,
      'DD',
      TO_TIMESTAMP('11/06/2012 11:44:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000501,
      142,
      'P23_registrarAceptacion',
      'plugin/procedimientos/aceptacionYdecision/aceptacion',
      '((valores[''P23_registrarAceptacion''][''comboAceptacion''] == DDSiNo.SI) && (valores[''P23_registrarAceptacion''][''comboConflicto''] == DDSiNo.NO)) ?  ''SI'' : ''NO''',
      0,
      'Registrar aceptación de asunto',
      0,
      'DD',
      TO_TIMESTAMP('11/06/2012 11:44:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000600,
      142,
      'P23_BPMAceptacionYdecision',
      144,
      0,
      'Se inicia Trámite demanda incidental',
      0,
      'DD',
      TO_TIMESTAMP('18/06/2012 17:42:01.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000601,
      143,
      'P24_validarAsignacion',
      'plugin/procedimientos/tramiteFaseComunOrdinario/validarAsignacionSupGest',
      0,
      'Validar asignacion gestor y supervisor',
      0,
      'DD',
      TO_TIMESTAMP('18/06/2012 18:20:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      621
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000602,
      142,
      'P23_validarAsignacion',
      'plugin/procedimientos/tramiteFaseComunAbreviado/validarAsignacionSupGest',
      0,
      'Validar asignacion gestor y supervisor',
      0,
      'DD',
      TO_TIMESTAMP('18/06/2012 18:21:23.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      621
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOBORRAR,
      FECHABORRAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000550,
      441,
      'P1000_tareaFicticia',
      0,
      'Tarea ficticia para litigios sin gestión',
      0,
      'DIEGO',
      TO_TIMESTAMP('12/07/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'SINNODO',
      TO_TIMESTAMP('26/07/2012 16:08:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      1,
      0,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000700,
      941,
      'P65_AperturaPlazo',
      '( valores[''P65_AperturaPlazo''][''comboFinaliza''] == DDSiNo.SI ? ''SI'':''NO'')',
      0,
      'Apertura plazo cesión de remate',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000701,
      941,
      'P65_ReseñarFechaComparecencia',
      0,
      'Reseñar fecha de comparecencia',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000702,
      941,
      'P65_RealizacionCesionRemate',
      0,
      'Realización de la cesión de remate',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000703,
      29,
      'P11_CorreoGestionActivos',
      '( valores[''P11_CorreoGestionActivos''][''enviadoCorreo''] == DDSiNo.SI  ? ''SI'':''NO'')',
      0,
      'Correo a gestión de activos',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000704,
      29,
      'P11_BPMCesionRemate',
      941,
      0,
      'Se inicia el trámite de cesión de remate',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      3,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      DD_TPO_ID_BPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000000705,
      941,
      'Decision2',
      441,
      0,
      'Toma decisión cesión de remate',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 18:10:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000800,
      29,
      'P11_CelebracionSubasta_new1',
      'plugin/ugas/procedimientos/tramiteSubasta/celebracionSubastaUGAS',
      '(valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion_new1''] == ''02'') ? ''nosotros'' :  ((valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion_new1''] == ''04'') ? ''faltaNotificacion'' : ((valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion_new1''] == ''05'' ||  valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion_new1''] == ''04'') ? ''nosotros'' : ((valores[''P11_CelebracionSubasta_new1''][''comboAdjudicacion_new1''] == ''01'') ? ''terceros'' : ''adjudicacionConCesionRemate'' )))',
      0,
      'Celebración subasta y adjudicación',
      0,
      'Oscar',
      TO_TIMESTAMP('12/11/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      5,
      39,
      0
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000900,
      1041,
      'P95_entregaActaRequerimiento',
      'plugin/ugas/procedimientos/ejecucionNotarial/entregaActaRequerimientoUGAS',
      0,
      'Registrar entrega del acta de requerimiento a notario',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:51.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000901,
      1041,
      'P95_registrarSolicitudCertCargas',
      0,
      'Registrar solicitud de certificación registral',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:52.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000902,
      1041,
      'P95_registrarRecepcionCertCargas',
      'valores[''P95_registrarRecepcionCertCargas''][''comboCorrecto''] == DDSiNo.SI ? ''correcto'' : ''incorrecto''',
      0,
      'Registrar recepción de la certificación registral',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  COMMIT;
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000903,
      1041,
      'P95_registrarRequerimientoAdeudor',
      'valores[''P95_registrarRequerimientoAdeudor''][''comboResultado''] == DDSiNo.SI ? ''positivo'' : ''negativo''',
      0,
      'Registrar requerimiento al deudor',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:54.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000904,
      1041,
      'P95_registrarPagoDelDeudor',
      'valores[''P95_registrarPagoDelDeudor''][''comboPagoEnPlazo''] == DDSiNo.SI ? ''positivo'' : ''negativo''',
      0,
      'Registrar pago del deudor',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000905,
      1041,
      'P95_registrarNotificacion',
      'valores[''P95_registrarNotificacion''][''comboNotificado''] == DDSiNo.SI ? ''Positivo'' : ''Negativo''',
      0,
      'Registrar notificación de inicio de actuaciones',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:56.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000906,
      1041,
      'P95_registrarAnuncioSubasta',
      'plugin/ugas/procedimientos/ejecucionNotarial/registrarAnuncioSubastaUGAS',
      '! tieneBienes() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; registrar al menos un bien, para ello debe acceder a la pesta&ntilde;a Solvencias de la ficha del Deudor asociado al Procedimiento correspondiente.</p></div>'' : ( ! tieneAlgunBienConFichaSubasta() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea, deber&aacute; dictar instrucciones para subasta en al menos un bien, para ello debe acceder a la pesta&ntilde;a Bienes de la ficha del Procedimiento correspondiente y proceder a dictar instrucciones.</p></div>'' : null)',
      0,
      'Registrar anuncio de subasta',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000907,
      1041,
      'P95_dictarInstrucciones',
      'plugin/ugas/procedimientos/tramiteSubasta/dictarInstruccionesUGAS',
      1,
      'Dictar instrucciones',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      40,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000908,
      1041,
      'P95_leerInstrucciones',
      'plugin/ugas/procedimientos/tramiteSubasta/leerInstruccionesUGAS',
      0,
      'Lectura y aceptación de instrucciones',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:59.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000909,
      1041,
      'P95_registrarCelebracion1Subasta',
      'plugin/ugas/procedimientos/ejecucionNotarial/celebracionSubasta',
      'valores[''P95_registrarCelebracion1Subasta''][''comboCelebrada''] == DDSiNo.NO ? ''noAdjudicado1'' : (valores[''P95_registrarCelebracion1Subasta''][''adjudicacionTercero''] == DDSiNo.SI ? ''adjTercero1'' : (valores[''P95_registrarCelebracion1Subasta''][''adjudicacionEntidad''] == DDSiNo.SI ? ''adjEntidad1'' : ''noAdjudicado1''))',
      0,
      'Registrar celebración de primera subasta',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      USUARIOMODIFICAR,
      FECHAMODIFICAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000910,
      1041,
      'P95_registrarCelebracion2Subasta',
      'plugin/ugas/procedimientos/ejecucionNotarial/celebracionSubasta',
      'valores[''P95_registrarCelebracion2Subasta''][''comboCelebrada''] == DDSiNo.NO ? ''noAdjudicado2'' : (valores[''P95_registrarCelebracion2Subasta''][''adjudicacionTercero''] == DDSiNo.SI ? ''adjTercero2'' : (valores[''P95_registrarCelebracion2Subasta''][''adjudicacionEntidad''] == DDSiNo.SI ? ''adjEntidad2'' : ''noAdjudicado2''))',
      0,
      'Registrar celebración de segunda subasta',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:01.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      'CPEREZ',
      TO_TIMESTAMP('08/03/2013 20:13:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001409,
      1242,
      'P198_nodoInicioPorSQL',
      0,
      'Nodo inicio SQL',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001410,
      1242,
      'P198_nodoEsperaController',
      'inicioIrregular() ? ''inicioIrregular'' :  
(cobroDeCuotas() ? ''cobroDeCuotas'' :  
(cambioDeFase() ? ''cambioDeFase'' :    
(fasePrecontencioso() ? ''fasePrecontencioso'' :    
''espera''   
)  
) 
) 
',
      0,
      'Nodo espera 1',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001411,
      1242,
      'P198_inicioIrregular',
      'valores[''P198_inicioIrregular''][''comboSolucion''] == ''08'' || 
valores[''P198_inicioIrregular''][''comboSolucion''] == ''09'' || 
valores[''P198_inicioIrregular''][''comboSolucion''] == ''10'' || 
valores[''P198_inicioIrregular''][''comboSolucion''] == ''11'' || 
valores[''P198_inicioIrregular''][''comboSolucion''] == ''12'' ? ''noSolucion'' : ''solucion''',
      0,
      'Inicio fase irregular',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001412,
      1242,
      'P198_cambioDeFase',
      'valores[''P198_cambioDeFase''][''comboSolucion''] == ''08'' || 
valores[''P198_cambioDeFase''][''comboSolucion''] == ''09'' || 
valores[''P198_cambioDeFase''][''comboSolucion''] == ''10'' || 
valores[''P198_cambioDeFase''][''comboSolucion''] == ''11'' || 
valores[''P198_cambioDeFase''][''comboSolucion''] == ''12'' ? ''noSolucion'' : ''solucion''',
      0,
      'Cambio de fase',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001413,
      1242,
      'P198_cobroDeCuotas',
      'valores[''P198_cobroDeCuotas''][''comboSolucion''] == ''08'' || 
valores[''P198_cobroDeCuotas''][''comboSolucion''] == ''09'' || 
valores[''P198_cobroDeCuotas''][''comboSolucion''] == ''10'' || 
valores[''P198_cobroDeCuotas''][''comboSolucion''] == ''11'' || 
valores[''P198_cobroDeCuotas''][''comboSolucion''] == ''12'' ? ''noSolucion'' : ''solucion''',
      0,
      'Permanencia de un periodo recurrente en una misma fase',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:37:08.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001414,
      1241,
      'P198_fasePrecontenciosa',
      'valores[''P198_fasePrecontenciosa''][''comboSolucion''] == ''08'' || 
valores[''P198_fasePrecontenciosa''][''comboSolucion''] == ''09'' || 
valores[''P198_fasePrecontenciosa''][''comboSolucion''] == ''10'' || 
valores[''P198_fasePrecontenciosa''][''comboSolucion''] == ''11'' || 
valores[''P198_fasePrecontenciosa''][''comboSolucion''] == ''12'' ? ''noSolucion'' : ''solucion''',
      0,
      'Envío a fase precontenciosa',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:37:08.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001415,
      1242,
      'P198_propuestaSolucionSupervisor',
      1,
      'Realizar propuesta de solución por el Supervisor',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:37:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001400,
      1241,
      'P199_nodoInicioPorSQL',
      0,
      'Nodo inicio SQL',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001401,
      1241,
      'P199_nodoEspera1controller',
      'getDiasParaVencimiento() > 90 ?     
''mas1'' :     
(getDiasParaVencimiento() < 83 ?         
''avanzarNodo'' :         
(propuestaYaRealizada() ?             
''avanzarNodo'' :             
''activarTareaAvanzar''         
)    
) 
',
      0,
      'Nodo espera 1',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001402,
      1241,
      'P199_nodoEspera2controller',
      'getDiasParaVencimiento() > 90 ? ''mas1'' :  
(getDiasParaVencimiento() > 60 ? ''mas2'' :   
(getDiasParaVencimiento() < 53 ?    
''avanzarNodo'' :    
(propuestaYaRealizada() ?     
''avanzarNodo'' :     
''activarTareaAvanzar''   
)   
)  
)
',
      0,
      'Nodo espera 2',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001403,
      1241,
      'P199_nodoEspera3controller',
      'getDiasParaVencimiento() > 90 ? ''mas1'' :  
(getDiasParaVencimiento() > 60 ? ''mas2'' :  
(getDiasParaVencimiento() > 30 ? ''mas3'' :    
(getDiasParaVencimiento() < 23 ?     
''avanzarNodo'' :     
(propuestaYaRealizada() ?      
''vencido'' :      
''activarTareaAvanzar''     
)    
)   
) 
)
',
      0,
      'Nodo espera 3',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001404,
      1241,
      'P199_nodoEsperaVencidoController',
      'getDiasParaVencimiento() > 90 ? ''mas1'' :  
(getDiasParaVencimiento() > 60 ? ''mas2'' :  
(getDiasParaVencimiento() > 30 ? ''mas3'' :    
''sigueVencido''  
) 
) 
',
      0,
      'Nodo espera vencido',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001405,
      1241,
      'P199_propuestaSolucion1',
      'valores[''P199_propuestaSolucion1''][''comboSolucion''] == ''08'' || 
valores[''P199_propuestaSolucion1''][''comboSolucion''] == ''09'' || 
valores[''P199_propuestaSolucion1''][''comboSolucion''] == ''10'' || 
valores[''P199_propuestaSolucion1''][''comboSolucion''] == ''11'' || 
valores[''P199_propuestaSolucion1''][''comboSolucion''] == ''12'' ? ''noSolucion'' : ''solucion''',
      0,
      'Realizar propuesta de solución a 90 días de vencimiento',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001406,
      1241,
      'P199_propuestaSolucion2',
      'valores[''P199_propuestaSolucion2''][''comboSolucion''] == ''08'' || 
valores[''P199_propuestaSolucion2''][''comboSolucion''] == ''09'' || 
valores[''P199_propuestaSolucion2''][''comboSolucion''] == ''10'' || 
valores[''P199_propuestaSolucion2''][''comboSolucion''] == ''11'' || 
valores[''P199_propuestaSolucion2''][''comboSolucion''] == ''12'' ? ''noSolucion'' : ''solucion''',
      0,
      'Realizar propuesta de solución a 60 días de vencimiento',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001407,
      1241,
      'P199_propuestaSolucion3',
      'valores[''P199_propuestaSolucion3''][''comboSolucion''] == ''08'' || 
valores[''P199_propuestaSolucion3''][''comboSolucion''] == ''09'' || 
valores[''P199_propuestaSolucion3''][''comboSolucion''] == ''10'' || 
valores[''P199_propuestaSolucion3''][''comboSolucion''] == ''11'' || 
valores[''P199_propuestaSolucion3''][''comboSolucion''] == ''12'' ? ''noSolucion'' : ''solucion''',
      0,
      'Realizar propuesta de solución a 30 días de vencimiento',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP
    )
    VALUES
    (
      10000000001408,
      1241,
      'P199_propuestaSolucionSupervisor',
      1,
      'Realizar propuesta de solución por el Supervisor',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001200,
      1,
      'P01_CertificacionCargas',
      0,
      'Certificación de cargas',
      0,
      'UGAS-2279',
      TO_TIMESTAMP('22/03/2013 18:53:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001300,
      1141,
      'P96_notificacionDemandaIncidental',
      'plugin/ugas/procedimientos/tramiteDemandadoEnIncidente/interposicionDemanda',
      0,
      'Notificación demanda incidental',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:28.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001301,
      1141,
      'P96_dictarInstrucciones',
      '(valores[''P96_dictarInstrucciones''][''comboInstrucciones''] == ''01'' || valores[''P96_dictarInstrucciones''][''comboInstrucciones''] == ''03'') ? ''SI'' : ''ALLANAMIENTO TOTAL''',
      1,
      'Dictar instrucciones',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:29.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      40
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001302,
      1141,
      'P96_registrarOposicion',
      '!asuntoConProcurador() ? ''<div align="justify" style="font-size: 8pt; font-family: Arial; margin-bottom: 10px;"><p>&iexcl;Atenci&oacute;n! Para dar por terminada esta tarea debe registrar el procurador que representa a la entidad en la ficha del asunto correspondiente.</p></div>'' : null',
      0,
      'Registrar oposición',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001303,
      1141,
      'P96_admisionEscritoOposicion',
      '(valores[''P96_admisionEscritoOposicion''][''comboVista''] == DDSiNo.SI && valores[''P96_admisionEscritoOposicion''][''fechaVista''] == '''') ? ''tareaExterna.error.P10_RegistrarImpugnacion.fechasOblgatorias'' : null',
      'valores[''P96_admisionEscritoOposicion''][''comboVista''] == DDSiNo.SI ? ''SI'' : ''NO''',
      0,
      'Admisión escrito oposición',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001304,
      1141,
      'P96_registrarVista',
      0,
      'Registrar vista',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_VIEW,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001305,
      1141,
      'P96_registrarResolucionOposicion',
      'plugin/ugas/procedimientos/tramiteDemandadoEnIncidente/registrarResolucion',
      0,
      'Registrar resolución',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001306,
      1141,
      'P96_resolucionFirme',
      '(valores[''P96_resolucionFirme''][''resultadoRecurso''] == ''02'' || valores[''P96_resolucionFirme''][''resultadoRecurso''] == ''02'') ? ''NO FAVORABLE'' : ''FAVORABLE''',
      0,
      'Resolución firme',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_VALIDACION_JBPM,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001307,
      1141,
      'P96_registrarImporteCostas',
      '(valores[''P96_resolucionFirme''][''condenado1''] == DDSiNo.SI && valores[''P96_resolucionFirme''][''condenado2''] == DDSiNo.SI) ?  ((valores[''P96_registrarImporteCostas''][''importe1letrado'']==null || valores[''P96_registrarImporteCostas''][''importe1procurador'']==null || valores[''P96_registrarImporteCostas''][''importe2letrado'']==null || valores[''P96_registrarImporteCostas''][''importe2procurador'']==null) ? ''tareaExterna.error.P96_condenado1y2estancia.camposObligatorios'': null) : ((valores[''P96_resolucionFirme''][''condenado1''] == DDSiNo.SI && (valores[''P96_registrarImporteCostas''][''importe1letrado'']==null || valores[''P96_registrarImporteCostas''][''importe1procurador'']==null)) ? ''tareaExterna.error.P96_condenado1estancia.camposObligatorios'': (valores[''P96_resolucionFirme''][''condenado2''] == DDSiNo.SI && (valores[''P96_registrarImporteCostas''][''importe2letrado'']==null || valores[''P96_registrarImporteCostas''][''importe2procurador'']==null)) ? ''tareaExterna.error.P96_condenado2estancia.camposObligatorios'': null)'
      ,
      0,
      'Registrar el importe de las costas a abonar',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001308,
      1141,
      'P96_registrarAllanamiento',
      0,
      'Registrar allanamiento',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001309,
      1141,
      'P96_admisionEscritoAllanamiento',
      0,
      'Admisión escrito allanamiento',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001310,
      1141,
      'P96_registrarResolucionAllanamiento',
      0,
      'Registrar resolución',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      1,
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SCRIPT_DECISION,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID
    )
    VALUES
    (
      10000000001000,
      148,
      'P29_elevarAcomitePropuesta_new1',
      '(valores[''P29_elevarAcomitePropuesta_new1''][''comboResultado''] != null && valores[''P29_elevarAcomitePropuesta_new1''][''comboResultado''] != '''') ? (valores[''P29_elevarAcomitePropuesta_new1''][''comboResultado''] == DDFavorable.FAVORABLE ? ''Favorable'' : ''Desfavorable'') : ''Favorable''',
      0,
      'Elevar a comité la propuesta de instrucciones',
      0,
      'DD',
      TO_TIMESTAMP('14/02/2013 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      1,
      'EXTTareaProcedimiento',
      3,
      39
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000914,
      1041,
      'P95_registrarLiquidacionRemate',
      0,
      'Registrar liquidación del precio de remate',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  INSERT
  INTO BANK01.TAP_TAREA_PROCEDIMIENTO
    (
      TAP_ID,
      DD_TPO_ID,
      TAP_CODIGO,
      TAP_SUPERVISOR,
      TAP_DESCRIPCION,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO,
      TAP_ALERT_VUELTA_ATRAS,
      DD_FAP_ID,
      TAP_AUTOPRORROGA,
      DTYPE,
      TAP_MAX_AUTOP,
      DD_STA_ID,
      TAP_EVITAR_REORG
    )
    VALUES
    (
      10000000000915,
      1041,
      'P95_registrarEscritura',
      0,
      'Registrar recepción de escritura',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:05.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0,
      'tareaExterna.cancelarTarea',
      9,
      1,
      'EXTTareaProcedimiento',
      3,
      39,
      1
    );
  COMMIT;
  dbms_output.put_line('[INFO] - FIN Insercción tareas del procedimiento');
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