--/*
--##########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20220711
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18268
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

    /*Decision para T018_CalculoRiesgo*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_CalculoRiesgo''''][''''comboRiesgo''''] == DDRiesgoOperacion.CODIGO_ROP_ALTO ? ''''aceptaConRiesgo''''  : esAlquilerSocial() ? ''''aceptaSinRiesgoAlquilerSocial'''' : esSubrogacionHipoteca() ? ''''aceptaSinRiesgoSubrogacionHipoteca'''' : esSubrogacionCompraVenta() ? ''''aceptaSinRiesgoSubrogacionCompraVenta'''' : esRenovacion() ? ''''aceptaSinRiesgoRenovacion'''' : ''''null'''''' 
	WHERE TAP_CODIGO = ''T018_CalculoRiesgo''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_AprobacionAlquilerSocial*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_AprobacionAlquilerSocial''''][''''comboResultado''''] == DDSiNo.NO ? ''''rechaza'''' : ''''acepta'''''' 
	WHERE TAP_CODIGO = ''T018_AprobacionAlquilerSocial''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_RespuestaContraofertaBC*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_RespuestaContraofertaBC''''][''''comboResultado''''] == DDSiNo.NO ? esRenovacion() ? ''''rechazaRenovacion'''' : ''''rechazaAlquilerSocial'''' :  esRenovacion() ? ''''aceptaRenovacion'''' : ''''aceptaAlquilerSocial'''''' 
	WHERE TAP_CODIGO = ''T018_RespuestaContraofertaBC''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_EntregaFianzas*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_EntregaFianzas''''][''''comboResultado''''] == DDSiNo.SI ? ''''acepta'''' :  esRenovacion() ? rechazaMenosDosVeces() ? ''''rechazaMenosDosVecesRenovacion'''' : ''''rechazaRenovacion'''' : ''''rechazaAlquilerSocial'''''' 
	WHERE TAP_CODIGO = ''T018_EntregaFianzas''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_AprobacionOferta*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_AprobacionOferta''''][''''comboResultado''''] == DDSiNo.SI ?  esRenovacion() ? ''''aceptaRenovacion'''' : ''''aceptaSubrogacionDacion'''' : esRenovacion() ? ''''rechazaRenovacion'''' : ''''rechazaSubrogacionDacion'''''' 
	WHERE TAP_CODIGO = ''T018_AprobacionOferta''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_ComunicarSubrogacion*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_ComunicarSubrogacion''''][''''comboResultado''''] == DDSiNo.SI ?  esSubrogacionHipoteca() ? ''''aceptaSubrogacionHipotecaria'''' : ''''aceptaSubrogacionDacion'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_ComunicarSubrogacion''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_AltaContratoAlquiler*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_AltaContratoAlquiler''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_AltaContratoAlquiler''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_AprobacionContrato*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_AprobacionContrato''''][''''comboResultado''''] == DDSiNo.SI ?  conAdenda() ? ''''aceptaConAdenda'''' : ''''aceptaSinAdenda'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_AprobacionContrato''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_AgendarFirmaAdenda*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_AgendarFirmaAdenda''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_AgendarFirmaAdenda''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_RespuestaReagendacionBC*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_RespuestaReagendacionBC''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_RespuestaReagendacionBC''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_FirmaAdenda*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_FirmaAdenda''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_FirmaAdenda''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_AltaContratoAlquilerAdenda*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_AltaContratoAlquilerAdenda''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_AltaContratoAlquilerAdenda''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_ProponerRescisionCliente*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_ProponerRescisionCliente''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : esCarteraConcertada() ? ''''rechazaCarteraConcertadaResidencial'''' : ''''rechazaNoCarteraConcertadaResidencial'''''' 
	WHERE TAP_CODIGO = ''T018_ProponerRescisionCliente''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_RespuestaOfertaBC*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_RespuestaOfertaBC''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_RespuestaOfertaBC''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_FirmaRescisionContrato*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_FirmaRescisionContrato''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_FirmaRescisionContrato''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_PbcAlquiler*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_PbcAlquiler''''][''''comboRiesgo''''] == DDSiNo.NO ? ''''rechaza''''  : esAlquilerSocial() ? ''''aceptaAlquilerSocial'''' : esSubrogacionHipoteca() ? ''''aceptaSubrogacionHipoteca'''' : esSubrogacionCompraVenta() ? ''''aceptaSubrogacionCompraVenta'''' : esRenovacion() ? ''''aceptaRenovacion'''' : ''''null'''''' 
	WHERE TAP_CODIGO = ''T018_PbcAlquiler''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
	/*Decision para T018_FirmaContrato*/
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_DECISION = ''valores[''''T018_FirmaContrato''''][''''comboResultado''''] == DDSiNo.SI ?  ''''acepta'''' : ''''rechaza'''''' 
	WHERE TAP_CODIGO = ''T018_FirmaContrato''';
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
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