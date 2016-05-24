--/*
--##########################################
--## AUTOR=Alberto b
--## FECHA_CREACION=20151222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc35
--## INCIDENCIA_LINK=CMREC-1599
--## PRODUCTO=NO
--##
--## Finalidad: Resolución de incidencia aceptación del asunto
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TAREA VARCHAR(50 CHAR);
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TAP_TAREA_PROCEDIMIENTO');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''PCO_RegistrarAceptacionPost'' AND BORRADO = ''0''';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''PCO_RegistrarAceptacionPost''''][''''conflicto_intereses'''']==DDSiNo.NO && valores[''''PCO_RegistrarAceptacionPost''''][''''fecha_aceptacion''''] == null  ? ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">En caso de indicar Conflicto Intereses NO, para completar la tarea debera rellenar el campo Fecha de Aceptación'''' : null '' WHERE TAP_CODIGO = ''PCO_RegistrarAceptacionPost''';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[FIN] tarea actualizada');
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[FIN] La tarea no existe en la tabla');
	END IF;
	
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