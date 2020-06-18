--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20200618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7293
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    PL_OUTPUT VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-7293';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN
	
	V_MSQL := 'UPDATE TAP_TAREA_PROCEDIMIENTO 
				SET TAP_SCRIPT_VALIDACION = ''checkImporteParticipacion() ? checkPoliticaCorporativa() ?  checkCajamar() ? checkFechaVenta() ? null : ''''La fecha de ingreso cheque ha de estar informada'''' : null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''' : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' ''
				WHERE TAP_CODIGO = ''T013_DocumentosPostVenta''';
    EXECUTE IMMEDIATE V_MSQL;
    
	COMMIT;
	DBMS_OUTPUT.put_line('[OK] TAP_SCRIPT_VALIDACION para la tarea T013_DocumentosPostVenta actualizado con éxito');
 
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