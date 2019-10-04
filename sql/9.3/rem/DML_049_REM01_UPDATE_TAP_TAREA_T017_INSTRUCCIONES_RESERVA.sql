--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20191003
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5105
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica la columna TAP_SCRIPT_VALIDACION_JBPM para las tareas T017_ObtencionContratoReserva y T017_InstruccionesReserva
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
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET TAP_SCRIPT_VALIDACION_JBPM = NULL,
	USUARIOMODIFICAR = ''REMVIP-5105'',
	FECHAMODIFICAR = SYSDATE
	WHERE TAP_CODIGO = ''T017_ObtencionContratoReserva''';

	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET TAP_SCRIPT_VALIDACION_JBPM = ''checkImporteParticipacion() ? (checkCompradores() ? ( checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? existeAdjuntoUGValidacion("06,E;12,E") : ''''El estado de la poliacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''''',
	USUARIOMODIFICAR = ''REMVIP-5105'',
	FECHAMODIFICAR = SYSDATE
	WHERE TAP_CODIGO = ''T017_InstruccionesReserva''';

	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('	[INFO] REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');

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
