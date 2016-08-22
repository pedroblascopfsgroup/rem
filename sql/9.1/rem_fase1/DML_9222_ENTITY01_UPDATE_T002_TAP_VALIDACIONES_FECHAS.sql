--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160517
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.4
--## INCIDENCIA_LINK=HREOS-379
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza las validaciones de trámites
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --REGISTRO TFI ELEGIDO
    V_TAP_TAP_CODIGOS VARCHAR2(4000 CHAR) := '';

    --CAMPO TFI PARA ACTUALIZAR
    V_TAP_CAMPO VARCHAR2(100 CHAR)  := '';
    V_TAP_VALOR VARCHAR2(1000 CHAR) := '';


/* VALIDACIONES POST ANTIGUAS:
T002_AnalisisPeticion   valores['T002_AnalisisPeticion']['comboTramitar'] == DDSiNo.NO ? (valores['T002_AnalisisPeticion']['motivoDenegacion'] == '' ? 'Si deniega la tramitaci&oacute; debe indicar un motivo' : null) : (valores['T002_AnalisisPeticion']['numTarifa'] == '' ? 'Si acepta la tramitaci&oacute; debe indicar la tarifa aplicable' : null)
T002_SolicitudLPOGestorInterno    
T002_ObtencionLPOGestorInterno    valores['T002_ObtencionLPOGestorInterno']['comboObtencion'] == DDSiNo.NO ? (valores['T002_ObtencionLPOGestorInterno']['motivoNoObtencion'] == '' ? 'Si declina la obtenci&oacute;n del documento, debe indicar un motivo de no obtenci&oacute;n' : null) : existeAdjuntoUGValidacion("","T")
T002_SolicitudDocumentoGestoria   
T002_ObtencionDocumentoGestoria   valores['T002_ObtencionDocumentoGestoria']['comboObtencion'] == DDSiNo.NO ? (valores['T002_ObtencionDocumentoGestoria']['motivoNoObtencion'] == '' ? 'Si declina la obtenci&oacute;n del documento, debe indicar un motivo de no obtenci&oacute;n' : null) : existeAdjuntoUGValidacion("","T")
T002_ValidacionActuacion    (valores['T002_ValidacionActuacion']['comboCorreccion'] == DDSiNo.NO && valores['T002_ValidacionActuacion']['motivoIncorreccion'] == '' ) ? 'Si el documento no corresponde con la petici&oacute;n, debe indicar un motivo de incorrecci&oacute;n' : null
T002_CierreEconomico    esFechaMenor(valores['T002_CierreEconomico']['fechaCierre'], fechaValidacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n' : null
T002_SolicitudExtraordinaria    
T002_AutorizacionPropietario    (valores['T002_AutorizacionPropietario']['comboAmpliacion'] == DDSiNo.SI && valores['T002_AutorizacionPropietario']['numIncremento'] == '' ) ? 'Si el propietario autoriza ampliaci&oacute;n de presupuesto, debe indicar el importe de incremento' : null
*/

BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO VALIDACIONES - TRAMITE OBTENCION DOCUMENTAL: validaciones de fechas y documentos requeridos');


  --ACTUALIZACION DE VALIDACIONE POST 
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION_JBPM';

  -- OBTENCIÓN DOC - ANALISIS PETICION - SIN Validación POST - Tarea sin fechas --------
  V_TAP_TAP_CODIGOS := ' ''T002_AnalisisPeticion'' ';
  V_TAP_VALOR := '';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- OBTENCIÓN DOC - SOLICITUD GESTOR INTERNO - Validación POST fecha mayor a aprobación Trabajo --------
  V_TAP_TAP_CODIGOS := ' ''T002_SolicitudLPOGestorInterno'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_SolicitudLPOGestorInterno''''][''''fechaSolicitud''''], fechaAprobacionTrabajo()) ? ''''Fecha solicitud debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- OBTENCIÓN DOC - OBTENCION GESTOR INTERNO - Validación POST fecha mayor a aprobación Trabajo y de doc. adjunto relacionado por java --
  V_TAP_TAP_CODIGOS := ' ''T002_ObtencionLPOGestorInterno'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_ObtencionLPOGestorInterno''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha obtenci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("","T")';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- OBTENCIÓN DOC - SOLICITUD GESTORIA - Validación POST fecha mayor a aprobación Trabajo --------
  V_TAP_TAP_CODIGOS := ' ''T002_SolicitudDocumentoGestoria'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_SolicitudDocumentoGestoria''''][''''fechaSolicitud''''], fechaAprobacionTrabajo()) ? ''''Fecha solicitud debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- OBTENCIÓN DOC - OBTENCION GESTORIA - Validación POST fecha mayor a aprobación Trabajo y de doc. adjunto relacionado por java --
  V_TAP_TAP_CODIGOS := ' ''T002_ObtencionDocumentoGestoria'' ';
  V_TAP_VALOR := 'valores[''''T002_ObtencionDocumentoGestoria''''][''''comboObtencion''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T002_ObtencionDocumentoGestoria''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha obtenci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("","T")) : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- OBTENCIÓN DOC - VALIDACION ACTUACION - Validación POST fecha mayor a aprobación Trabajo --------
  V_TAP_TAP_CODIGOS := ' ''T002_ValidacionActuacion'' ';
  V_TAP_VALOR := 'valores[''''T002_ValidacionActuacion''''][''''comboCorreccion''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T002_ValidacionActuacion''''][''''fechaValidacion''''], fechaAprobacionTrabajo()) ? ''''Fecha validaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null) : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


-- OBTENCIÓN DOC - CIERRE ECONOMICO - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T002_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


  -- OBTENCIÓN DOC - SOLICITUD EXTRAORDINARIA - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T002_SolicitudExtraordinaria'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_SolicitudExtraordinaria''''][''''fecha''''], fechaAprobacionTrabajo()) ? ''''Fecha solicitud debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


  -- OBTENCIÓN DOC - AUTORIZACION PROPIETARIO - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T002_AutorizacionPropietario'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_AutorizacionPropietario''''][''''fecha''''], fechaAprobacionTrabajo()) ? ''''Fecha autorizaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;




  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
