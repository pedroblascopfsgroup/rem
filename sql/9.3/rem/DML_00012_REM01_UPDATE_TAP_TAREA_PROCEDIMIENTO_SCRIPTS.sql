--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20190321
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3593
--## PRODUCTO=NO
--##
--## Finalidad: update TAP_TAREA_PROCEDIMIENTO scripts groovy
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

    --DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN');
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO SET BORRADO = 1, USUARIOBORRAR = ''REMVIP-3593'', FECHABORRAR = SYSDATE WHERE DD_TPD_CODIGO = ''115'' AND DD_TPD_CODIGO = ''116''';
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''esFechaMenor(valores[''''T002_AutorizacionPropietario''''][''''fecha''''], fechaAprobacionTrabajo()) ? ''''Fecha autorizaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("107","T")'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T002_AutorizacionPropietario''';   
 	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T003_EmisionCertificado''''][''''comboEmision''''] == DDSiNo.SI ? esFechaMenor(valores[''''T003_EmisionCertificado''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha emisi&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("92","T") : null '', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T003_EmisionCertificado''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''esFechaMenor(valores[''''T003_SolicitudEtiqueta''''][''''fechaPresentacion''''], fechaAprobacionTrabajo()) ? ''''Fecha presentaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("85","T")'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T003_SolicitudEtiqueta''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T008_ObtencionDocumento''''][''''comboObtencion''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T008_ObtencionDocumento''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha emisi&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("90","T")) : (valores[''''T008_ObtencionDocumento''''][''''motivoNoObtencion''''] == DDMotivoNoObtencion.NO_CUMPLE_REQUISITOS ? null : null)'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T008_ObtencionDocumento''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION = ''existeAdjuntoUGValidacion("96","T")'', TAP_SCRIPT_VALIDACION_JBPM = ''esFechaMenor(valores[''''T005_EmisionTasacion''''][''''fechaEmision''''], fechaAprobacionTrabajo()) ? ''''Fecha emisi&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("96","T")'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T005_EmisionTasacion''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T006_ValidacionInforme''''][''''comboCorreccion''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T006_ValidacionInforme''''][''''fechaValidacion''''], fechaAprobacionTrabajo()) ? ''''Fecha validaci&oacute;n debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : existeAdjuntoUGValidacion("01","T")) : null'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T006_ValidacionInforme''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_ResolucionComite''''][''''comboResolucion''''] != DDResolucionComite.CODIGO_APRUEBA ? (valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_CONTRAOFERTA ? ((checkBankia() || checkLiberbank() || checkGiants()) ? null : existeAdjuntoUGValidacion("22","E")) : null) : resolucionComiteT013()'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_ResolucionComite''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''checkFechaEmisionInformeJuridico() ? mismoNumeroAdjuntosComoActivosExpedienteUGValidacion("10", "E") : "No todos los activos tienen fecha de emisión de informe en el listado de activos del expediente comercial." '', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_InformeJuridico''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? (checkCompradoresTienenNumeroUrsus() ?  (!esCajamar() ? (esLiberBank() ?  (mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion("37", "E", "01") == "" ? existeAdjuntoUGValidacion("06,E;12,E") : mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion("37", "E", "01")) : mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion("37", "E", "01")) : null) : ''''No todos los compradores tienen NºURSUS'''') : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''''', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_InstruccionesReserva''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''!esLiberBank() ? existeAdjuntoUGValidacion("06,E;12,E") : null'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("13,E") == "" ? valores[''''T013_ResolucionTanteo''''][''''comboEjerce''''] == DDSiNo.SI ? (checkEjercidoTanteo() ? null : ''''No existe ningún activo del expediente con tanteo Ejercido'''') : (checkRenunciaTanteo() ? null : ''''Existe algún activo del expediente sin tanteo Renuncia'''') : existeAdjuntoUGValidacion("13,E")'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_ResolucionTanteo''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''checkExpedienteBloqueado() ? (valores[''''T013_PosicionamientoYFirma''''][''''comboFirma''''] == DDSiNo.SI ? (checkPosicionamiento() ? existeAdjuntoUGValidacion("15,E") : ''''El expediente debe tener algún posicionamiento'''') : null) : ''''El expediente no está bloqueado'''''', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_PosicionamientoYFirma''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGValidacion("19,E;17,E")'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T013_DocumentosPostVenta''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T014_ResolucionComiteExterno''''][''''comboResAprobada''''] == DDSiNo.SI ? (existeAdjuntoUGValidacion("08","E") == null ? existeAdjuntoUGCarteraValidacion("36", "E", "01") : existeAdjuntoUGValidacion("08","E")) : existeAdjuntoUGCarteraValidacion("36", "E", "01")'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T014_ResolucionComiteExterno''';    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T014_PosicionamientoFirma''''][''''comboFirma''''] == DDSiNo.SI ? existeAdjuntoUGValidacion("09","E") : null'', USUARIOMODIFICAR = ''REMVIP-3593'', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T014_PosicionamientoFirma''';    

    COMMIT;

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
