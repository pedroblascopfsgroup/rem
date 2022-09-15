--/*
--##########################################
--## AUTOR=Adrian Molina
--## FECHA_CREACION=20220915
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18717
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

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
          	SET TFI_NOMBRE = ''llamadaRealizada'',
			TFI_ORDEN = 6,
			TFI_TIPO = ''combobox'',
			TFI_LABEL = ''Llamada realizada'',
			TFI_ERROR_VALIDACION = null,
			TFI_VALIDACION = null,
			TFI_BUSINESS_OPERATION = ''DDSiNo'',
          	USUARIOMODIFICAR = ''HREOS-18717'', 
		  	FECHAMODIFICAR = SYSDATE 
          	WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_AprobacionOferta'') 
          	AND TFI_NOMBRE = ''comboResultado''';

  	EXECUTE IMMEDIATE V_MSQL;

  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
          	SET TFI_NOMBRE = ''burofaxEnviado'',
			TFI_ORDEN = 8,
			TFI_TIPO = ''combobox'',
			TFI_LABEL = ''Burofax enviado'',
			TFI_ERROR_VALIDACION = null,
			TFI_VALIDACION = null,
			TFI_BUSINESS_OPERATION = ''DDSiNo'',
          	USUARIOMODIFICAR = ''HREOS-18717'', 
		  	FECHAMODIFICAR = SYSDATE 
          	WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_AprobacionOferta'') 
          	AND TFI_NOMBRE = ''comboAprobadoApi	''';

  	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
          	SET TFI_NOMBRE = ''fechaLlamada'',
			TFI_ORDEN = 7,
			TFI_TIPO = ''datefield'',
			TFI_LABEL = ''Fecha de llamada'',
			TFI_ERROR_VALIDACION = null,
			TFI_VALIDACION = null,
			TFI_BUSINESS_OPERATION = null,
          	USUARIOMODIFICAR = ''HREOS-18717'', 
		  	FECHAMODIFICAR = SYSDATE 
          	WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_AprobacionOferta'') 
          	AND TFI_NOMBRE = ''comboBorradorContratoApi''';

  	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
          	SET TFI_ORDEN = 1,
          	USUARIOMODIFICAR = ''HREOS-18717'', 
		  	FECHAMODIFICAR = SYSDATE 
          	WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_AprobacionOferta'') 
          	AND TFI_NOMBRE = ''comboClienteAcepBorr''';

  	EXECUTE IMMEDIATE V_MSQL;

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
          	SET TFI_ORDEN = 10,
          	USUARIOMODIFICAR = ''HREOS-18717'', 
		  	FECHAMODIFICAR = SYSDATE 
          	WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_AprobacionOferta'') 
          	AND TFI_NOMBRE = ''fecha''';

  	EXECUTE IMMEDIATE V_MSQL;

  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
          	SET TFI_NOMBRE = ''fechaBurofax'',
			TFI_ORDEN = 9,
			TFI_TIPO = ''datefield'',
			TFI_LABEL = ''Fecha de burofax'',
			TFI_ERROR_VALIDACION = null,
			TFI_VALIDACION = null,
			TFI_BUSINESS_OPERATION = null,
          	USUARIOMODIFICAR = ''HREOS-18717'', 
		  	FECHAMODIFICAR = SYSDATE 
          	WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_AprobacionOferta'') 
          	AND TFI_NOMBRE = ''justificacion''';

  	EXECUTE IMMEDIATE V_MSQL;

  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
          	SET TFI_ORDEN = 12,
          	USUARIOMODIFICAR = ''HREOS-18717'', 
		  	FECHAMODIFICAR = SYSDATE 
          	WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_AprobacionOferta'') 
          	AND TFI_NOMBRE = ''observaciones''';

  	EXECUTE IMMEDIATE V_MSQL;
    
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