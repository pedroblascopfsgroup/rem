--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20211004
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15056
--## PRODUCTO=SI
--##
--## Finalidad: 
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('T015_DefinicionOferta',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : checkInquilinos()  ? (checkBankia() == true && isMetodoActualizacionRelleno() == false)  ? ''''El campo "Metodo de actualizacion" debe estar relleno'''' : null : ''''Falta completar algunos datos obligatorios del inquilino''''  '),
        T_TIPO_DATA('T015_VerificarScoring',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_AceptacionCliente',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_ResolucionPBC','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_Posicionamiento',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_CierreContrato',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_DefinicionOferta',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : (checkBankia() == true  || checkReservaInformada() == true) ? checkImporteParticipacion() ? checkCamposComprador()  ? checkCompradores()  ? checkVendido() ? ''''El activo est&aacute; vendido'''' : checkComercializable()  ? null  : ''''El activo debe ser comercializable''''  : ''''Los compradores deben sumar el 100%''''  : ''''Es necesario cumplimentar todos los campos obligatorios de los compradores para avanzar la tarea.''''  : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''  : ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.'''''),
        T_TIPO_DATA('T017_AnalisisPM',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_ResolucionCES',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkReservaInformada() == false ? ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.'''' : checkImporteParticipacion()  ? (checkCompradores() ? (checkVendido()  ? ''''El activo est&aacute; vendido''''  : (checkComercializable() ? (checkPoliticaCorporativa()  ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.''''): ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''  '),
        T_TIPO_DATA('T017_RespuestaOfertantePM',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' :  checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''': (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''''),
        T_TIPO_DATA('T017_RespuestaOfertanteCES',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la pol%iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''''),
        T_TIPO_DATA('T017_InformeJuridico',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : !tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.'''' '),
        T_TIPO_DATA('T017_AdvisoryNote',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_RecomendCES',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_ResolucionPROManzana',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' :null'),
        T_TIPO_DATA('T017_InstruccionesReserva',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''''),
        T_TIPO_DATA('T017_ObtencionContratoReserva',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : (checkReservaFirmada() || checkBankia() == true )? (checkImporteParticipacion() ?  (checkCompradores() ?  (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''') : ''''La reserva debe estar en estado firmado''''  '),
        T_TIPO_DATA('T017_PosicionamientoYFirma',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : !tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.'''' '),
        T_TIPO_DATA('T017_DocsPosVenta',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''''),
        T_TIPO_DATA('T017_CierreEconomico',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkFechaVenta() ?( checkImporteParticipacion() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''):''''La fecha de ingreso cheque ha de estar informada'''' '),
        T_TIPO_DATA('T017_ResolucionDivarian',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_RatificacionComiteCES',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''  '),
        T_TIPO_DATA('T017_PBC_CN',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' :null'),
        T_TIPO_DATA('T017_AgendarFechaFirmaArras',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_ConfirmarFechaFirmaArras','  (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : (checkAprobadoRechazadoBC() || userHasPermisoParaAvanzarTareas()) ? null : ''''El estado de Validaci&oacute;n BC de la fecha arras tiene que ser Aceptado o Rechazado'''' '),
        T_TIPO_DATA('T017_AgendarPosicionamiento',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_ConfirmarFechaEscritura',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true)  ? '''' El expediente est&aacute; bloqueado '''' : (checkBankia() == true && (checkAprobadoRechazadoBCPosicionamiento() == false && userHasPermisoParaAvanzarTareas() == false )) ? ''''El estado de Validaci&oacute;n BC de la fecha arras tiene que ser Aceptado o Rechazado'''' : !tieneTramiteGENCATVigenteByIdActivo()  ? checkImporteParticipacion()  ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''')  : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.'''''),
        T_TIPO_DATA('T017_FirmaContrato',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : !tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.'''' '),
        T_TIPO_DATA('T017_PBCReserva',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T017_ResolucionArrow',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''  '),
        T_TIPO_DATA('T017_PBCVenta',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : !tieneTramiteGENCATVigenteByIdActivo() ? null : ''''El activo tiene un tr&aacute;mite GENCAT en curso.'''' '),
        T_TIPO_DATA('T015_SolicitarGarantiasAdicionales',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_ScoringBC',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_SancionBC',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_PBC',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_EnvioContrato',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_SancionPatrimonio',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_AgendarFechaFirma',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  '),
        T_TIPO_DATA('T015_Firma',' (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : null  ')


    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--INSERT TAP_TAREA_PROCEDIMIENTO ----------------------------
 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	  	EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ' INTO V_COUNT;
	
	    IF V_COUNT = 1 THEN
		  
	        DBMS_OUTPUT.PUT_LINE(' LA FILA YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO] ACTUALIZARLA');
	        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		    		SET TAP_SCRIPT_VALIDACION =  '''||V_TMP_TIPO_DATA(2)||''' 
					,USUARIOMODIFICAR = ''HREOS-15056''
		            ,FECHAMODIFICAR = SYSDATE
		            WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' 
		        ';
			EXECUTE IMMEDIATE V_MSQL;
	    END IF;
	
	
	
	
	    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
	END LOOP;
	COMMIT;
	
DBMS_OUTPUT.PUT_LINE('[FIN] ');
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
