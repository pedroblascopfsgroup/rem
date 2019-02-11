--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20190105
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-5353
--## PRODUCTO=NO
--## Finalidad: Actualizar validación de la tarea.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.



BEGIN

	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET tap_script_validacion =''checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''''', usuariomodificar=''HREOS-5353'', fechamodificar=sysdate WHERE TAP_CODIGO = ''T013_InformeJuridico''';
	
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');

  V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET tap_script_validacion =''checkImporteParticipacion() ? (checkCompradores() ? checkProvinciaCompradores() ? checkNifConyugueLBB() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''El NIF del cónyugue debe estar informado si el comprador está casado'''' : ''''Todos los compradores tienen que tener provincia informada'''' : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''' '', usuariomodificar=''HREOS-5353'', fechamodificar=sysdate WHERE TAP_CODIGO = ''T013_InstruccionesReserva''';
  
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');

  V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET tap_script_validacion =''checkReservaFirmada() ? (checkImporteParticipacion() ?  (checkCompradores() ?  (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''') : ''''La reserva debe estar en estado firmado'''' '', usuariomodificar=''HREOS-5353'', fechamodificar=sysdate WHERE TAP_CODIGO = ''T013_ObtencionContratoReserva''';
  
  DBMS_OUTPUT.PUT_LINE(V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');



COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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