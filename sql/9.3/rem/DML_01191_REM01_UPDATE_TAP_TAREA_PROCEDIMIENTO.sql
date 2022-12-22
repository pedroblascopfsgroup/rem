--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12910
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('T017_RespuestaOfertanteCES',
            '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkOfertaConcurrencia() || checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la pol%iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''',
            '-'),
        T_TIPO_DATA('T017_InstruccionesReserva',
            '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkOfertaConcurrencia() || checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''',
            '!esBBVA() ? (checkImporteParticipacion() ? (checkCompradores() ? ( checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkOfertaConcurrencia() || checkComercializable() ? (checkPoliticaCorporativa() ? (!checkBankia()) ? existeAdjuntoUGValidacion("06,E;12,E")  : null : ''''El estado de la poliacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') )  : ''''Los compradores deben sumar el 100%'''')  : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''') : null '),
        T_TIPO_DATA('T017_ObtencionContratoReserva',
            '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : (checkReservaFirmada() || checkBankia() == true )? (checkImporteParticipacion() ?  (checkCompradores() ?  (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkOfertaConcurrencia() || checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''') : ''''La reserva debe estar en estado firmado'''' ',
            '-'),
        T_TIPO_DATA('T017_DefinicionOferta',
            '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : (checkBankia() == true  || checkReservaInformada() == true) ? checkImporteParticipacion() ? checkCamposComprador()  ? checkCompradores()  ? checkVendido() ? ''''El activo est&aacute; vendido'''' : checkOfertaConcurrencia() || checkComercializable() ? compruebaEstadoNoSolicitadoPendiente() ? '''' Hay compradores en los que no se ha realizado el contraste de listas'''' : compruebaEstadoPositivoRealDenegado() ?  ''''Hay compradores con un estado positivo real denegado en el contraste de listas'''' : null : ''''El activo debe ser comercializable''''  : ''''Los compradores deben sumar el 100%''''  : ''''Es necesario cumplimentar todos los campos obligatorios de los compradores para avanzar la tarea.''''  : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''  : ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.''''',
             '-'),
        T_TIPO_DATA('T017_RatificacionComiteCES',
            '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkOfertaConcurrencia() || checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' ' ,
            '-'),
        T_TIPO_DATA('T017_FirmaPropietario',
            'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkOfertaConcurrencia() || checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''',
            '-'),
        T_TIPO_DATA('T017_FirmaContrato',
            '(checkBankia() && valores[''''T017_FirmaContrato''''][''''cambioRiesgo''''] == DDSiNo.SI) ? null :  (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : !tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkOfertaConcurrencia() || checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.'''' ',
            '-')
        );
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	  	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' AND BORRADO = 0'
	  	INTO V_COUNT;
	
	    IF V_COUNT = 1 THEN

	        IF V_TMP_TIPO_DATA(3) = '-' THEN
		  
                DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO] ACTUALIZARLA');
                    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
                        SET TAP_SCRIPT_VALIDACION =  '''||V_TMP_TIPO_DATA(2)||'''
                        ,USUARIOMODIFICAR = ''REMVIP-12910''
                        ,FECHAMODIFICAR = SYSDATE
                        WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';

                DBMS_OUTPUT.PUT_LINE('[FIN]: TAREA '||V_TMP_TIPO_DATA(1)||' ACTUALIZADA VALIDACION');

		    ELSE

                DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO] ACTUALIZARLA');
                EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
                        SET TAP_SCRIPT_VALIDACION =  '''||V_TMP_TIPO_DATA(2)||'''
                        ,TAP_SCRIPT_VALIDACION_JBPM =  '''||V_TMP_TIPO_DATA(3)||'''
                        ,USUARIOMODIFICAR = ''REMVIP-12910''
                        ,FECHAMODIFICAR = SYSDATE
                        WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';

                DBMS_OUTPUT.PUT_LINE('[FIN]: TAREA '||V_TMP_TIPO_DATA(1)||' ACTUALIZADA VALIDACION Y JBPM');

            END IF;
        ELSE

            DBMS_OUTPUT.PUT_LINE('[FIN]: TAREA '||V_TMP_TIPO_DATA(1)||' NO EXISTE ');

	    END IF;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
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

EXIT;