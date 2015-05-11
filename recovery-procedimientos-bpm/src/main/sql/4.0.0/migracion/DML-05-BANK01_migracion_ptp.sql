/*
--##########################################
--## Author: Carlos Pérez
--## Finalidad: Insercción plazos de las tareas
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
  dbms_output.put_line('[INFO] - Insertando plazos de las tareas...');
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      201,
      201,
      '4*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      202,
      202,
      'damePlazo(valores[''P06_NotificacionAveriguacionDomicilio''][''fechaSolicitud'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      203,
      203,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      204,
      204,
      'damePlazo(valores[''P06_NotificacionEdicto''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:15.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      205,
      205,
      'damePlazo(valoresBPMPadre[''P02_ConfirmarOposicionCuantia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      206,
      206,
      'damePlazo(valores[''P21_RegistrarJuicioVerbal''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      207,
      207,
      'damePlazo(valores[''P21_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      208,
      208,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      209,
      209,
      'damePlazo(valores[''P11_SolicitudSubasta''][''fecha'']) + 60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      210,
      210,
      'valores[''P11_AnuncioSubasta''] == null ? ((damePrincipal()<3500000) ? damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) - 15*24*60*60*1000L : damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) - 30*24*60*60*1000L) : ((damePrincipal()<3500000) ? damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta'']) - 15*24*60*60*1000L : damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta'']) - 30*24*60*60*1000L)',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      211,
      211,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      212,
      212,
      'valores[''P11_AnuncioSubasta''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) : damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      213,
      213,
      '20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      214,
      214,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      215,
      215,
      '4*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      216,
      216,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      217,
      217,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      218,
      218,
      '10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      219,
      219,
      '10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      220,
      220,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      221,
      221,
      'damePlazo(valores[''P10_ElaborarLiquidacion''][''fechaLiq'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      222,
      222,
      'damePlazo(valores[''P10_SolicitarLiquidacion''][''fechaPre'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      223,
      223,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      224,
      224,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      225,
      225,
      '((valores[''P10_ConfirmarNotificacion''][''fecha''] !='''') && (valores[''P10_ConfirmarNotificacion''][''fecha''] != null)) ? damePlazo(valores[''P10_ConfirmarNotificacion''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      226,
      226,
      'damePlazo(valores[''P10_RegistrarImpugnacion''][''fechaVista''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      227,
      227,
      'damePlazo(valores[''P10_RegistrarVista''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      228,
      228,
      'damePlazo(valores[''P10_RegistrarResolucionVista''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      229,
      229,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      230,
      230,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      231,
      231,
      'nVecesTareaExterna == 0 ? 30*24*60*60*1000L : 23*7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      232,
      232,
      'valores[''P16_AutoDespachando''] == null ? (damePlazo(valores[''P16_AutoDespachando_new1''][''fecha'']) + 30*24*60*60*1000L) : (damePlazo(valores[''P16_AutoDespachando''][''fecha'']) + 30*24*60*60*1000L)',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      233,
      233,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      234,
      234,
      '((valores[''P16_ConfirmarNotificacion''][''fecha''] !='''') && (valores[''P16_ConfirmarNotificacion''][''fecha''] != null)) ? damePlazo(valores[''P16_ConfirmarNotificacion''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      235,
      235,
      'damePlazo(valores[''P16_RegistrarOposicion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      236,
      236,
      'damePlazo(valores[''P16_ConfirmarPresentacionImpugnacion''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      237,
      237,
      'damePlazo(valores[''P16_HayVista''][''fechaVista''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      238,
      238,
      'valores[''P16_HayVista''][''comboSiNo''] == DDSiNo.SI ? damePlazo(valores[''P16_RegistrarVista''][''fecha'']) + 30*24*60*60*1000L : damePlazo(valores[''P16_ConfirmarPresentacionImpugnacion''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      239,
      239,
      'damePlazo(valores[''P16_RegistrarResolucion''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      240,
      240,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      241,
      241,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      242,
      242,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      243,
      243,
      '((valores[''P01_ConfirmarNotificacionReqPago''][''fecha''] !='''') && (valores[''P01_ConfirmarNotificacionReqPago''][''fecha''] != null)) ? damePlazo(valores[''P01_ConfirmarNotificacionReqPago''][''fecha'']) + 11*24*60*60*1000L : 11*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      244,
      244,
      'damePlazo(valores[''P01_ConfirmarSiExisteOposicion''][''fechaComparecencia''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      245,
      245,
      'damePlazo(valores[''P01_RegistrarComparecencia''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      246,
      246,
      'damePlazo(valores[''P01_RegistrarComparecencia''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      247,
      247,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      248,
      248,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      249,
      249,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      250,
      250,
      'damePlazo(valores[''P13_SolicitarJustiprecio''][''fechaSolicitud'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      251,
      251,
      '4*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      252,
      252,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      253,
      253,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      254,
      254,
      '8*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      255,
      255,
      'damePlazo(valores[''P05_NotificacionDecreContratio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      256,
      256,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      257,
      257,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      258,
      258,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      259,
      259,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      260,
      260,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      261,
      261,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      262,
      262,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      263,
      263,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      264,
      264,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      265,
      265,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      266,
      266,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      267,
      267,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      268,
      268,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      269,
      269,
      '20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      270,
      270,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      271,
      271,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      272,
      272,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      273,
      273,
      'valores[''P15_AutoDespaEjecMasDecretoEmbargo''] == null ? (damePlazo(valores[''P15_AutoDespaEjecMasDecretoEmbargo_new1''][''fecha'']) + 30*24*60*60*1000L) : (damePlazo(valores[''P15_AutoDespaEjecMasDecretoEmbargo''][''fecha'']) + 30*24*60*60*1000L)',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      274,
      274,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2801,
      10000000001405,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2802,
      10000000001406,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      275,
      275,
      '((valores[''P15_ConfirmarNotifiReqPago''][''fecha''] !='''') && (valores[''P15_ConfirmarNotifiReqPago''][''fecha''] != null)) ? damePlazo(valores[''P15_ConfirmarNotifiReqPago''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      276,
      276,
      'damePlazo(valores[''P15_ConfirmarSiExisteOposicion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      277,
      277,
      'damePlazo(valores[''P15_ConfirmarPresentacionImpugnacion''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      278,
      278,
      'damePlazo(valores[''P15_MotivoOposicionImpugVista''][''fechaVista''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      279,
      279,
      'valores[''P15_MotivoOposicionImpugVista''][''comboHayVista''] == DDSiNo.SI ? damePlazo(valores[''P15_RegistrarCelebracionVista''][''fecha'']) + 30*24*60*60*1000L : damePlazo(valores[''P15_ConfirmarPresentacionImpugnacion''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      280,
      280,
      'damePlazo(valores[''P15_RegistrarResolucion''][''fechaResolucion'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      281,
      281,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      282,
      282,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      283,
      283,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      284,
      284,
      'valores[''P17_CnfAdmiDemaDecretoEmbargo''] == null ? (damePlazo(valores[''P17_CnfAdmiDemaDecretoEmbargo_new1''][''fecha'']) + 30*24*60*60*1000L) : (damePlazo(valores[''P17_CnfAdmiDemaDecretoEmbargo''][''fecha'']) + 30*24*60*60*1000L)',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      285,
      285,
      '((valores[''P17_CnfNotifRequerimientoPago''][''fecha''] !='''') && (valores[''P17_CnfNotifRequerimientoPago''][''fecha''] != null)) ? damePlazo(valores[''P17_CnfNotifRequerimientoPago''][''fecha'']) + 10*24*60*60*1000L : 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      286,
      286,
      'damePlazo(valores[''P17_RegistrarDemandaOposicion''][''fechaVista''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      287,
      287,
      'damePlazo(valores[''P17_RegistrarJuicioComparecencia''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      288,
      288,
      'damePlazo(valores[''P17_RegistrarResolucion''][''fechaResolucion'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      289,
      289,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:16.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      290,
      290,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      291,
      291,
      '4*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      292,
      292,
      '90*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      293,
      293,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      294,
      294,
      '4*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      295,
      295,
      'nVecesTareaExterna == 0 ? 30*24*60*60*1000L : 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      296,
      296,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      297,
      297,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      298,
      298,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  COMMIT;
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      299,
      299,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      300,
      300,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      301,
      301,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      302,
      302,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      303,
      303,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      304,
      304,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      305,
      305,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      306,
      306,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      307,
      307,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      308,
      308,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      309,
      309,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      310,
      310,
      '4*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      311,
      311,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      312,
      312,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      313,
      313,
      '10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      314,
      314,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      315,
      315,
      '4*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      316,
      316,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      317,
      317,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      318,
      318,
      'damePlazo(valores[''P02_InterposicionDemanda''][''fechaSolicitud'']) + 90*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      319,
      319,
      'damePlazo(valores[''P02_ConfirmarAdmisionDemanda''][''fecha'']) + 50*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      320,
      320,
      '((valores[''P02_ConfirmarNotificacionReqPago''] != null) && (valores[''P02_ConfirmarNotificacionReqPago''][''fecha''] !='''') && (valores[''P02_ConfirmarNotificacionReqPago''][''fecha''] != null)) ? damePlazo(valores[''P02_ConfirmarNotificacionReqPago''][''fecha'']) + 30*24*60*60*1000L : 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      321,
      321,
      '((valores[''P02_ConfirmarNotificacionReqPago''] != null) && (valores[''P02_ConfirmarNotificacionReqPago''][''fecha''] !='''') && (valores[''P02_ConfirmarNotificacionReqPago''][''fecha''] != null)) ? damePlazo(valores[''P02_ConfirmarNotificacionReqPago''][''fecha'']) + 60*24*60*60*1000L : 60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      322,
      322,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      323,
      323,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      324,
      324,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      325,
      325,
      '20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      326,
      326,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      327,
      327,
      '((valores[''P07_ConfirmarNotificacion''][''fecha''] !='''') && (valores[''P07_ConfirmarNotificacion''][''fecha''] != null)) ? damePlazo(valores[''P07_ConfirmarNotificacion''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      328,
      328,
      'damePlazo(valores[''P07_Impugnacion''][''vistaImpugnacion''])',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      329,
      329,
      'valores[''P07_Impugnacion''][''vistaImpugnacion''] != null &&valores[''P07_Impugnacion''][''vistaImpugnacion''] != '''' ? damePlazo(valores[''P07_RegistrarCelebracionVista''][''fecha'']) + 20*24*60*60*1000L : damePlazo(valores[''P07_Impugnacion''][''fechaImpugnacion'']) + 60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      330,
      330,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      331,
      331,
      '20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      332,
      332,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      333,
      333,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('29/05/2009 16:40:17.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      401,
      401,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      402,
      402,
      'damePlazo(valores[''P22_SolicitudConcursal''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      403,
      403,
      'damePlazo(valores[''P22_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      404,
      404,
      'damePlazo(valores[''P22_ConfirmarNotificacionDemandado''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      405,
      405,
      'damePlazo(valores[''P22_registrarOposicion''][''fechaVista''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      406,
      406,
      'damePlazo(valores[''P22_RegistrarVista''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      407,
      407,
      'damePlazo(valores[''P22_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      408,
      408,
      'valores[''P22_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? damePlazo(valores[''P22_ResolucionFirme''][''fechaResolucion'']) + 5*24*60*60*1000L : damePlazo(valores[''P22_ConfirmarNotificacionDemandado''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      409,
      409,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      410,
      410,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      411,
      411,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      412,
      412,
      'damePlazo(valores[''P23_registrarPublicacionBOE''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      413,
      413,
      'damePlazo(valores[''P23_registrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      414,
      414,
      'damePlazo(valores[''P23_registrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      415,
      415,
      'damePlazo(valores[''P23_registrarPublicacionBOE''][''fecha'']) + 90*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      416,
      416,
      'damePlazo(valores[''P23_registrarPublicacionBOE''][''fechaAuto'']) + 45*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      417,
      417,
      'damePlazo(valores[''P23_informeAdministracionConcursal''][''fecha'']) + 2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      418,
      418,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      419,
      419,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      420,
      420,
      'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      421,
      421,
      'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      422,
      422,
      'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      423,
      423,
      'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 90*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      424,
      424,
      'damePlazo(valores[''P24_registrarPublicacionBOE''][''fechaAuto'']) + 90*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      425,
      425,
      'damePlazo(valores[''P24_informeAdministracionConcursal''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      426,
      426,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      427,
      427,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      428,
      428,
      'damePlazo(valores[''P25_interposicionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      429,
      429,
      'damePlazo(valores[''P25_confirmarAdmisionDemanda''][''fechaProvidencia'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      430,
      430,
      'damePlazo(valores[''P25_admisionOposicionYSeñalamientoVista''][''fechaVista'']) + 2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      431,
      431,
      'valores[''P25_registrarVista''] == null ? 30*24*60*60*1000L : damePlazo(valores[''P25_registrarVista''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      432,
      432,
      'damePlazo(valores[''P25_RegistrarResolucion''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      433,
      433,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      434,
      434,
      'damePlazo(valores[''P26_notificacionDemandaIncidental''][''fecha'']) + 2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      435,
      435,
      'damePlazo(valores[''P26_notificacionDemandaIncidental''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      436,
      436,
      'damePlazo(valores[''P26_registrarOposicion''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      437,
      437,
      'damePlazo(valores[''P26_admisionEscritoOposicion''][''fechaVista''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      438,
      438,
      'valores[''P26_admisionEscritoOposicion''][''comboVista''] == DDSiNo.SI ? damePlazo(valores[''P26_registrarVista''][''fecha'']) + 30*24*60*60*1000L : damePlazo(valores[''P26_admisionEscritoOposicion''][''fecha'']) + 30*24*60*60*1000L ',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      439,
      439,
      'damePlazo(valores[''P26_notificacionDemandaIncidental''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      440,
      440,
      'damePlazo(valores[''P26_registrarAllanamiento''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      441,
      441,
      'damePlazo(valores[''P26_admisionEscritoAllanamiento''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      442,
      442,
      'valores[''P26_dictarInstrucciones''][''comboInstrucciones''] == DDInstrucciones.OPOSICION ? damePlazo(valores[''P26_registrarResolucionOposicion''][''fecha'']) + 20*24*60*60*1000L : damePlazo(valores[''P26_registrarResolucionAllanamiento''][''fecha'']) + 20*24*60*60*1000L ',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      443,
      443,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      444,
      444,
      'damePlazo(valores[''P27_presentarSolicitud''][''fecha'']) + 60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      445,
      445,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      449,
      449,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      450,
      450,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      451,
      451,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      452,
      452,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      453,
      453,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      454,
      454,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      455,
      455,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      456,
      456,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) + 2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:39.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      457,
      457,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      458,
      458,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      459,
      459,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      460,
      460,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      467,
      467,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      468,
      468,
      'damePlazo(valores[''P31_aperturaFase''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      469,
      469,
      'damePlazo(valores[''P31_InformeLiquidacion''][''fechaNotificacion'']) + 3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      470,
      470,
      'damePlazo(valores[''P31_InformeLiquidacion''][''fechaNotificacion'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      471,
      471,
      'damePlazo(valores[''P31_InformeLiquidacion''][''fechaNotificacion'']) + 45*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      472,
      472,
      'damePlazo(valores[''P31_regResolucionAprovacion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      473,
      473,
      'damePlazo(valores[''P31_InformeLiquidacion''][''fechaNotificacion'']) + 90*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      474,
      474,
      'damePlazo(valores[''P31_regInformeTrimestral1''][''fecha'']) + 90*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  COMMIT;
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      475,
      475,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      476,
      476,
      '10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      477,
      477,
      '10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      478,
      478,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      479,
      479,
      'damePlazo(valores[''P34_aperturaLiquidacion''][''fechaPublicacion'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      480,
      480,
      'damePlazo(valores[''P34_aperturaLiquidacion''][''fechaPublicacion'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      481,
      481,
      'damePlazo(valores[''P34_aperturaLiquidacion''][''fechaPublicacion'']) + 25*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      482,
      482,
      'damePlazo(valores[''P34_aperturaLiquidacion''][''fechaPublicacion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      483,
      483,
      'damePlazo(valores[''P34_aperturaLiquidacion''][''fechaPublicacion'']) + 35*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      484,
      484,
      'valores[''P34_registrarOposicion''] == null ?  5*24*60*60*1000L :  (damePlazo(valores[''P34_registrarOposicion''][''fecha'']) + 2*24*60*60*1000L )',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      485,
      485,
      'damePlazo(valores[''P34_registrarResolucion''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      486,
      486,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      487,
      487,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      488,
      488,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      489,
      489,
      'damePlazo(valores[''P32_interposicionDemandaQuerella''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      490,
      490,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      491,
      491,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      492,
      492,
      'damePlazo(valores[''P32_interposicionDemandaQuerella''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      493,
      493,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      494,
      494,
      'damePlazo(valores[''P32_interposicionDemandaQuerella''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      495,
      495,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      496,
      496,
      'damePlazo(valores[''P32_registrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      497,
      497,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      498,
      498,
      'damePlazo(valores[''P33_autoArchivo''][''fecha'']) + 1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      499,
      499,
      'damePlazo(valores[''P33_autoArchivo''][''fecha'']) + 3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      500,
      500,
      'damePlazo(valores[''P33_autoArchivo''][''fecha'']) + 1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      501,
      501,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      502,
      502,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      503,
      503,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      504,
      504,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      505,
      505,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      506,
      506,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      507,
      507,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      508,
      508,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      509,
      509,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      510,
      510,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      511,
      511,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      512,
      512,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      513,
      513,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      514,
      514,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      515,
      515,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      516,
      516,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      517,
      517,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      518,
      518,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      519,
      519,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      520,
      520,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      521,
      521,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      522,
      522,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      523,
      523,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      524,
      524,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      525,
      525,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      526,
      526,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      527,
      527,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      528,
      528,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      529,
      529,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      530,
      530,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      531,
      531,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      532,
      532,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:40.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      533,
      533,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      534,
      534,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      535,
      535,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      536,
      536,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      537,
      537,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      538,
      538,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      539,
      539,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      540,
      540,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      541,
      541,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      542,
      542,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      543,
      543,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      544,
      544,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      545,
      545,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      546,
      546,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      547,
      547,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      548,
      548,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      549,
      549,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      550,
      550,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      551,
      551,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      552,
      552,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      553,
      553,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      554,
      554,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      555,
      555,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      556,
      556,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      557,
      557,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      558,
      558,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      559,
      559,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      560,
      560,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      561,
      561,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      562,
      562,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      563,
      563,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      564,
      564,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      565,
      565,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      566,
      566,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      567,
      567,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      568,
      568,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      569,
      569,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      570,
      570,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      571,
      571,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      572,
      572,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      573,
      573,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2301,
      10000000000900,
      '12*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:52.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  COMMIT;
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      574,
      574,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      575,
      575,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      576,
      576,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      577,
      577,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      578,
      578,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      579,
      579,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      580,
      580,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      581,
      581,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      582,
      582,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      583,
      583,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      584,
      584,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      585,
      585,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      586,
      586,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      587,
      587,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      588,
      588,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      589,
      589,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      590,
      590,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      591,
      591,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      592,
      592,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      593,
      593,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      594,
      594,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      595,
      595,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      596,
      596,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      597,
      597,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      598,
      598,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      599,
      599,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      600,
      600,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      601,
      601,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      602,
      602,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      603,
      603,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      604,
      604,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      605,
      605,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      606,
      606,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      607,
      607,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      608,
      608,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      609,
      609,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      610,
      610,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      611,
      611,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      612,
      612,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      613,
      613,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      614,
      614,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      615,
      615,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      616,
      616,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      617,
      617,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      618,
      618,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      619,
      619,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      620,
      620,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      621,
      621,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      622,
      622,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      623,
      623,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      624,
      624,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      625,
      625,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      626,
      626,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      627,
      627,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      628,
      628,
      'damePlazo(valores[''P03_InterposicionDemanda''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      629,
      629,
      'damePlazo(valores[''P03_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      630,
      630,
      '((valores[''P03_ConfirmarNotDemanda''][''fecha''] !='''') && (valores[''P03_ConfirmarNotDemanda''][''fecha''] != null)) ? damePlazo(valores[''P03_ConfirmarNotDemanda''][''fecha'']) + 20*24*60*60*1000L : 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      631,
      631,
      'damePlazo(valores[''P03_ConfirmarOposicion''][''fechaAudiencia''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      632,
      632,
      'damePlazo(valores[''P03_RegistrarAudienciaPrevia''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      633,
      633,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      634,
      634,
      'damePlazo(valores[''P03_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      635,
      635,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      636,
      636,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      637,
      637,
      'damePlazo(valores[''P04_InterposicionDemanda''][''fechainterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      638,
      638,
      'damePlazo(valores[''P04_ConfirmarAdmisionDemanda''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      639,
      639,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      640,
      640,
      'damePlazo(valores[''P04_ConfirmarNotifiDemanda''][''fechaJuicio''])',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      641,
      641,
      'damePlazo(valores[''P04_RegistrarJuicio''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      642,
      642,
      'damePlazo(valores[''P04_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      643,
      643,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      644,
      644,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      645,
      645,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      646,
      646,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      647,
      647,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      648,
      648,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      649,
      649,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      650,
      650,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      651,
      651,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      652,
      652,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      653,
      653,
      'damePlazo(valores[''P54_registrarLanzamientoEfectivo''][''fechaLanzamiento'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      654,
      654,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/11/2009 19:38:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      901,
      901,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      902,
      902,
      '23*7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      903,
      903,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      904,
      904,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      905,
      905,
      '60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      906,
      906,
      '1275*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      907,
      907,
      'damePlazo(valores[''P15_InterposicionDemandaMasBienes''][''fechaInterposicion'']) + 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      908,
      908,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      909,
      909,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      910,
      910,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/05/2010 21:45:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      801,
      801,
      'damePlazo(valores[''P11_SolicitudSubasta''][''fecha'']) + 60*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('23/04/2010 17:24:01.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1001,
      1001,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:52.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1002,
      1002,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1003,
      1003,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1004,
      1004,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1005,
      1005,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:56.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1006,
      1006,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:56.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1007,
      1007,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1008,
      1008,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  COMMIT;
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1009,
      1009,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1010,
      1010,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1011,
      1011,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:59.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1012,
      1012,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('15/09/2011 18:17:59.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1111,
      1111,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:02.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1112,
      1112,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1113,
      1113,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1114,
      1114,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1115,
      1115,
      'damePlazo(valores[''P30_admisionTramiteConvenio''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:05.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1116,
      1116,
      '30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:07.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1117,
      1117,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1118,
      1118,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:43.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1119,
      1119,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:43.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1120,
      1120,
      '40*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1121,
      1121,
      'damePlazo(valores[''P35_presentarPropuesta''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1122,
      1122,
      'damePlazo(valores[''P35_registrarAdmision''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1123,
      1123,
      'damePlazo(valores[''P35_registrarPresentacionSubsanacion''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1124,
      1124,
      'valores[''P35_registrarResultado''] != null ? damePlazo(valores[''P35_registrarResultado''][''fecha'']) + 10*24*60*60*1000L : damePlazo(valores[''P35_registrarAdmision''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1125,
      1125,
      'damePlazo(valores[''P35_registrarAdmision''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:09:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1126,
      1126,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:07.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1127,
      1127,
      'damePlazo(valores[''P62_registrarCausaConclusion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:08.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1128,
      1128,
      'damePlazo(valores[''P62_registrarInformeAdmConcursal''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1129,
      1129,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:11.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1130,
      1130,
      'damePlazo(valores[''P62_registrarOposicion''][''fechaOposicion'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:11.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1131,
      1131,
      'valores[''P62_registrarOposicion''] == null ? (damePlazo(valores[''P62_registrarInformeAdmConcursal''][''fecha'']) + 20*24*60*60*1000L) : (valores[''P62_registrarOposicion''][''comboOposicion''] == DDSiNo.NO ? (damePlazo(valores[''P62_registrarInformeAdmConcursal''][''fecha'']) + 20*24*60*60*1000L ) : 15*24*60*60*1000L)',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:12.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1132,
      1132,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:26.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1133,
      1133,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1134,
      1134,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:41.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1135,
      1135,
      '((valores[''P64_registrarCumplimiento''] != null) && (valores[''P64_registrarCumplimiento''][''fecha''] !='''') && (valores[''P64_registrarCumplimiento''][''fecha''] != null)) ? damePlazo(valores[''P64_registrarCumplimiento''][''fecha'']) + 90*24*60*60*1000L : damePlazo(valores[''P64_registrarConvenio''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1136,
      1136,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:10:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1301,
      1301,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1302,
      1302,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1303,
      1303,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1304,
      1304,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:50.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1305,
      1305,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:51.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1306,
      1306,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1307,
      1307,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1308,
      1308,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1309,
      1309,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:45:59.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1101,
      1101,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1102,
      1102,
      '180*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1103,
      1103,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1104,
      1104,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:50.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1105,
      1105,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:51.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1106,
      1106,
      '180*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:52.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1107,
      1107,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:54.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1108,
      1108,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:06:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1109,
      1109,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:07:07.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1110,
      1110,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('03/10/2011 11:07:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1310,
      1310,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:42.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1311,
      1311,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:43.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1312,
      1312,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1313,
      1313,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1314,
      1314,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1315,
      1315,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1316,
      1316,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1317,
      1317,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:48.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1318,
      1318,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1319,
      1319,
      '1*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:49.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1320,
      1320,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/03/2012 23:46:50.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1401,
      10000000000000,
      'damePlazo(valores[''P24_presentarEscritoInsinuacionCreditos''][''fecha'']) + 7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1403,
      10000000000002,
      '15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1404,
      10000000000003,
      'damePlazo(valores[''P94_SolicitudConcursal''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1405,
      10000000000004,
      'damePlazo(valores[''P94_ConfirmarAdmision''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1406,
      10000000000005,
      'damePlazo(valores[''P94_ConfirmarNotificacionDemandado''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1407,
      10000000000006,
      'damePlazo(valores[''P94_registrarOposicion''][''fechaVista'']) + 2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1408,
      10000000000007,
      'damePlazo(valores[''P94_RegistrarVista''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1409,
      10000000000008,
      'damePlazo(valores[''P94_RegistrarResolucion''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1410,
      10000000000009,
      'valores[''P94_registrarOposicion''][''comboOposicion''] == DDSiNo.SI ? damePlazo(valores[''P94_ResolucionFirme''][''fechaResolucion'']) + 5*24*60*60*1000L : damePlazo(valores[''P94_ConfirmarNotificacionDemandado''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1411,
      10000000000010,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1412,
      10000000000011,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('22/05/2012 13:12:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1505,
      10000000000104,
      'damePlazo(valores[''P23_presentarEscritoInsinuacionCreditos''][''fecha'']) + 7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:42:35.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1506,
      10000000000105,
      'damePlazo(valores[''P23_registrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:44:47.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1503,
      10000000000102,
      'damePlazo(valores[''P05_SolicitudTramiteAdjudicacion''][''fechaSolicitud'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:41:45.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1504,
      10000000000103,
      'damePlazo(valores[''P05_NotifcacionDecreAdjudicacion''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('24/05/2012 10:41:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1601,
      10000000000200,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('25/05/2012 19:29:20.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1602,
      10000000000201,
      '3*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('25/05/2012 19:29:20.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1802,
      10000000000401,
      'damePlazo(valores[''P25_confirmarAdmisionDemanda''][''fechaProvidencia'']) + 30*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('05/06/2012 9:47:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1803,
      10000000000402,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('05/06/2012 18:12:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1804,
      10000000000403,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 6*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('05/06/2012 18:12:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1701,
      10000000000300,
      '20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/05/2012 9:53:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1702,
      10000000000301,
      '20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/05/2012 9:57:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1703,
      10000000000302,
      'damePlazo(valores[''P24_registrarPublicacionBOE''][''fecha'']) + 15*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('31/05/2012 9:59:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1801,
      10000000000400,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('04/06/2012 16:29:18.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2302,
      10000000000901,
      'damePlazo(valores[''P95_entregaActaRequerimiento''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2303,
      10000000000902,
      'damePlazo(valores[''P95_registrarSolicitudCertCargas''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:53.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2304,
      10000000000903,
      'damePlazo(valores[''P95_registrarRecepcionCertCargas''][''fechaRecepcion'']) + 10*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2305,
      10000000000904,
      'damePlazo(valores[''P95_registrarRequerimientoAdeudor''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:55.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2306,
      10000000000905,
      'damePlazo(valores[''P95_registrarRequerimientoAdeudor''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:56.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2307,
      10000000000906,
      'valores[''P95_registrarRequerimientoAdeudor''] == null ? 45*24*60*60*1000L : damePlazo(valores[''P95_registrarRequerimientoAdeudor''][''fecha'']) + 45*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2308,
      10000000000907,
      'damePlazo(valores[''P95_registrarAnuncioSubasta''][''fechaSubasta'']) - 5*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2309,
      10000000000908,
      '5*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:20:59.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2310,
      10000000000909,
      'damePlazo(valores[''P95_registrarAnuncioSubasta''][''fechaRegistro'']) + 60*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2311,
      10000000000910,
      'valores[''P95_registrarCesionRemate''] != null ? (damePlazo(valores[''P95_registrarCesionRemate''][''fecha'']) + 7*24*60*60*1000L) : (valores[''P95_registrarCelebracion3Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion3Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L) : (valores[''P95_registrarCelebracion2Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion2Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L) : (damePlazo(valores[''P95_registrarCelebracion1Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L)))',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:01.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2312,
      10000000000911,
      'valores[''P95_registrarCesionRemate''] != null ? (damePlazo(valores[''P95_registrarCesionRemate''][''fecha'']) + 7*24*60*60*1000L) : (valores[''P95_registrarCelebracion3Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion3Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L) : (valores[''P95_registrarCelebracion2Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion2Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L) : (damePlazo(valores[''P95_registrarCelebracion1Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L)))',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:02.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2313,
      10000000000912,
      'valores[''P95_registrarCelebracion3Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion3Subasta''][''fechaSubasta'']) + 8*24*60*60*1000L) : (valores[''P95_registrarCelebracion2Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion2Subasta''][''fechaSubasta'']) + 8*24*60*60*1000L) : (damePlazo(valores[''P95_registrarCelebracion1Subasta''][''fechaSubasta'']) + 8*24*60*60*1000L))',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:03.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2314,
      10000000000913,
      '5*24*60*60*1000',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2315,
      10000000000914,
      'valores[''P95_registrarCesionRemate''] != null ? (damePlazo(valores[''P95_registrarCesionRemate''][''fecha'']) + 7*24*60*60*1000L) : (valores[''P95_registrarCelebracion3Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion3Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L) : (valores[''P95_registrarCelebracion2Subasta''] != null ? (damePlazo(valores[''P95_registrarCelebracion2Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L) : (damePlazo(valores[''P95_registrarCelebracion1Subasta''][''fechaSubasta'']) + 15*24*60*60*1000L)))',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:04.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2316,
      10000000000915,
      'damePlazo(valores[''P95_registrarLiquidacionRemate''][''fecha'']) + 21*24*60*60*1000L',
      0,
      'Oscar',
      TO_TIMESTAMP('25/01/2013 22:21:05.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2803,
      10000000001407,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  COMMIT;
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2002,
      10000000000601,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('18/06/2012 18:20:46.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2003,
      10000000000602,
      '5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('18/06/2012 18:21:25.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1901,
      10000000000500,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/06/2012 11:44:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      1902,
      10000000000501,
      '2*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('11/06/2012 11:44:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2401,
      10000000001000,
      'damePlazo(valores[''P29_autoApertura''][''fechaJunta'']) - 20*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('14/02/2013 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2601,
      10000000001200,
      '60*24*60*60*1000L',
      0,
      'UGAS-2279',
      TO_TIMESTAMP('22/03/2013 18:53:44.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2804,
      10000000001408,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:27.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2701,
      10000000001300,
      '1*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:29.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2702,
      10000000001301,
      'damePlazo(valores[''P96_notificacionDemandaIncidental''][''fecha'']) + 2*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:29.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2703,
      10000000001302,
      'damePlazo(valores[''P96_notificacionDemandaIncidental''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2704,
      10000000001303,
      'damePlazo(valores[''P96_registrarOposicion''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:30.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2705,
      10000000001304,
      'damePlazo(valores[''P96_admisionEscritoOposicion''][''fechaVista''])',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2706,
      10000000001305,
      'valores[''P96_admisionEscritoOposicion''][''comboVista''] == DDSiNo.SI ? damePlazo(valores[''P96_registrarVista''][''fecha'']) + 30*24*60*60*1000L : damePlazo(valores[''P96_admisionEscritoOposicion''][''fecha'']) + 30*24*60*60*1000L ',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2707,
      10000000001306,
      '(valores[''P96_dictarInstrucciones''][''comboInstrucciones''] == ''01'' || valores[''P96_dictarInstrucciones''][''comboInstrucciones''] == ''03'')? damePlazo(valores[''P96_registrarResolucionOposicion''][''fecha'']) + 20*24*60*60*1000L : damePlazo(valores[''P96_registrarResolucionAllanamiento''][''fecha'']) + 20*24*60*60*1000L ',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2708,
      10000000001307,
      '10*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2709,
      10000000001308,
      'damePlazo(valores[''P96_notificacionDemandaIncidental''][''fecha'']) + 10*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2710,
      10000000001309,
      'damePlazo(valores[''P96_registrarAllanamiento''][''fecha'']) + 20*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2711,
      10000000001310,
      'damePlazo(valores[''P96_admisionEscritoAllanamiento''][''fecha'']) + 30*24*60*60*1000L',
      0,
      'UGAS-1969',
      TO_TIMESTAMP('05/04/2013 20:25:34.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2001,
      10000000000600,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('18/06/2012 17:42:01.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2101,
      10000000000700,
      'valoresBPMPadre[''P11_AnuncioSubasta''] == null ? ( valoresBPMPadre[''P11_AnuncioSubasta_new1''] == null ? 5*24*60*60*1000L :damePlazo(valoresBPMPadre[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) + 5*24*60*60*1000L ): damePlazo(valoresBPMPadre[''P11_AnuncioSubasta''][''fechaSubasta'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:31.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2102,
      10000000000701,
      'damePlazo(valores[''P65_AperturaPlazo''][''fecha'']) + 20*24*60*60*1000L ',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2103,
      10000000000702,
      'damePlazo(valores[''P65_ReseñarFechaComparecencia''][''fecha'']) + 5*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2104,
      10000000000703,
      'valores[''P11_AnuncioSubasta''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) : damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta''])',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:32.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2105,
      10000000000704,
      '300*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('27/07/2012 17:19:33.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2201,
      10000000000800,
      'valores[''P11_AnuncioSubasta''] == null ? damePlazo(valores[''P11_AnuncioSubasta_new1''][''fechaSubasta'']) : damePlazo(valores[''P11_AnuncioSubasta''][''fechaSubasta''])',
      0,
      'DD',
      TO_TIMESTAMP('13/11/2012 0:00:00.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2805,
      10000000001411,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:57.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2806,
      10000000001412,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:36:58.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2807,
      10000000001413,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:37:08.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2808,
      10000000001414,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:37:08.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  INSERT
  INTO BANK01.DD_PTP_PLAZOS_TAREAS_PLAZAS
    (
      DD_PTP_ID,
      TAP_ID,
      DD_PTP_PLAZO_SCRIPT,
      VERSION,
      USUARIOCREAR,
      FECHACREAR,
      BORRADO
    )
    VALUES
    (
      2809,
      10000000001415,
      '7*24*60*60*1000L',
      0,
      'DD',
      TO_TIMESTAMP('19/07/2013 18:37:09.000000','DD/MM/YYYY fmHH24fm:MI:SS.FF'),
      0
    );
  COMMIT;
  dbms_output.put_line('[INFO] - FIN insercción plazos');
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