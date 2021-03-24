--/*
--##########################################
--## AUTOR=Sento Visiedo
--## FECHA_CREACION=20210324
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13408
--## PRODUCTO=NO
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION = '' checkCamposComprador()? esOmega() ? checkReservaInformada() ? null : ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.'''' : checkImporteParticipacion() ? checkCompradores() ? checkVendido() ? ''''El activo est&aacute; vendido'''' : checkComercializable() ? checkBankia() ? checkImpuestos() ? null : ''''Debe indicar el tipo de impuesto y tipo aplicable.'''' : compruebaEstadoNoSolicitadoPendiente()? ''''No se ha realizado el contraste de lista sobre todos los compradores.'''' : compruebaEstadoPositivoRealDenegado()? ''''Hay compradores con un estado positivo real denegado en el contraste de listas.'''' : isOfertaDependiente() ? ''''Para sancionar esta oferta, hay que acceder a su Oferta Agrupada (Principal)'''' : null : ''''El activo debe ser comercializable'''' : ''''Los compradores deben sumar el 100%'''' : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''Es necesario cumplimentar todos los campos obligatorios de los compradores para avanzar la tarea.'''' '',
  USUARIOMODIFICAR = ''HREOS-13408'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T013_DefinicionOferta''';

  DBMS_OUTPUT.PUT_LINE(V_MSQL );

	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
   			

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