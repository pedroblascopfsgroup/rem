--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20211129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16520
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** TAP_TAREA_PROCEDIMIENTO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO...'); 

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''esOmega() ? checkReserva() ? ''''esOmegaConReserva'''': ''''esOmegaSinReserva'''' : checkFormalizacion() ? valores[''''T013_DefinicionOferta''''][''''comiteSuperior''''] != DDSiNo.SI ? checkAtribuciones() ? checkReserva() == false ? esYubai() ? ''''esYubai''''  :''''ConFormalizacionSinTanteoConAtribucionSinReservaSinTanteo'''' : esYubai() ? ''''esYubai'''' : esTitulizada() ? ''''ConFormalizacionSinTanteoConAtribucionConReservaTitulizada'''' : ''''ConFormalizacionSinTanteoConAtribucionConReserva'''' : ''''ConFormalizacionSinTanteoSinAtribucion'''' : ''''ConFormalizacionSinTanteoSinAtribucion'''' : ''''SinFormalizacion'''''' 
	WHERE TAP_CODIGO = ''T013_DefinicionOferta''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_APRUEBA ? checkReserva() ? esYubai() ? ''''esYubai'''' : esTitulizada() ? ''''ApruebaConReservaTitulizada'''' : ''''ApruebaConReserva'''' : esYubai() ? ''''esYubai'''' : ''''ApruebaSinReservaSinTanteo'''' : valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_RECHAZA ? ''''Rechaza'''' : ''''Contraoferta'''''' 
	WHERE TAP_CODIGO = ''T013_ResolucionComite''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''esOmega() || esTitulizada() ? fechaReservaPBCReserva() ? null : ''''Es necesario cumplimentar el campo fecha de reserva'''' : ''''No es cartera de Omega o Titulizada.'''''' 
	WHERE TAP_CODIGO = ''T013_PBCReserva''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T013_PBCReserva''''][''''comboRespuesta''''] == DDApruebaDeniega.CODIGO_APRUEBA ? esTitulizada() ? ''''ApruebaTitulizada'''' : ''''Aprueba'''' :  ''''Deniega'''''' 
	WHERE TAP_CODIGO = ''T013_PBCReserva''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
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