--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=202205136
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-17754
--## PRODUCTO=SI
--##
--## Finalidad: 
--## VERSIONES:
--##        0.1 Versión inicial Vicente Martinez HREOS-17749
--##        0.2 Agregar validacion decision T017_RespuestaOfertanteCES y T017_RatificacionComiteCES
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
	SET TAP_SCRIPT_DECISION = ''(esBBVA() == true || checkBankia() == true) ? valores[''''T017_ResolucionCES''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva() ? ''''AceptaConReservaBbva'''' : ''''AceptaSinReservaBbva'''' :  valores[''''T017_ResolucionCES''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Deniega'''' : ''''Contraoferta'''' : valores[''''T017_ResolucionCES''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva()  ? saltaPBCReserva() ? ''''AceptaSaltaPbc'''' : ''''AceptaConReserva'''' : ''''AceptaSinReserva'''' :  valores[''''T017_ResolucionCES''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_RECHAZA  ? ''''Deniega''''  : ''''Contraoferta'''''',
	USUARIOMODIFICAR = ''HREOS-17749'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T017_ResolucionCES''';

	EXECUTE IMMEDIATE V_MSQL;
	      
  	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
  	
  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET TAP_SCRIPT_DECISION = ''esBBVA() ? valores[''''T017_RespuestaOfertanteCES''''][''''comboRespuesta''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Deniega'''' : ''''Contraoferta'''' : valores[''''T017_RespuestaOfertanteCES''''][''''comboRespuesta''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva() ?  saltaPBCReserva() ? ''''AceptaSaltaPbc'''' : ''''AceptaConReserva'''' :  ''''AceptaSinReserva'''' : valores[''''T017_RespuestaOfertanteCES''''][''''comboRespuesta''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Deniega'''' : ''''Contraoferta'''''',
	USUARIOMODIFICAR = ''HREOS-17754'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T017_RespuestaOfertanteCES''';

	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]:'||SQL%ROWCOUNT||' REGISTROS MODIFICADOS CORRECTAMENTE');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		SET TAP_SCRIPT_DECISION = ''esBBVA() ? valores[''''T017_RatificacionComiteCES''''][''''comboRatificacion''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva() ? saltaPBCReserva() ? ''''AceptaSaltaPbc'''' : ''''AceptaConReservaBbva'''' : ''''AceptaSinReservaBbva'''' : valores[''''T017_RatificacionComiteCES''''][''''comboRatificacion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Deniega'''' : ''''Contraoferta'''' : valores[''''T017_RatificacionComiteCES''''][''''comboRatificacion''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva() ? saltaPBCReserva() ? ''''AceptaSaltaPbc'''' :  ''''AceptaConReserva'''' : ''''AceptaSinReserva'''' :  valores[''''T017_RatificacionComiteCES''''][''''comboRatificacion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Deniega'''' : ''''Contraoferta'''''',
		USUARIOMODIFICAR = ''HREOS-17754'', 
		FECHAMODIFICAR = SYSDATE 
		WHERE TAP_CODIGO = ''T017_RatificacionComiteCES''';

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
