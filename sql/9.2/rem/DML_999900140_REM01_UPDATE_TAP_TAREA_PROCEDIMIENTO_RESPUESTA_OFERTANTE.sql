--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20171109
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3098
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar las comprobaciones de validacion en la tarea de Instrucciones reserva
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(8000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.  
    
BEGIN	
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_RespuestaOfertante'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN
		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            		SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_RECHAZA ? null : respuestaOfertanteT013(valores[''''T013_RespuestaOfertante''''][''''importeOfertante''''])''
			, USUARIOMODIFICAR = ''HREOS-3098'', FECHAMODIFICAR = SYSDATE WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_RespuestaOfertante'')';
            
			EXECUTE IMMEDIATE V_MSQL;
			
			DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '''||V_ESQUEMA||'''.'''||V_TEXT_TABLA||''' a finalizado correctamente');
			

		ELSE			
			DBMS_OUTPUT.PUT_LINE('[WARNING] NO SE HACE NADA, NO SE HA ENCONTRADO LA TAREA T013_RespuestaOfertante EN LA TABLA'''||V_ESQUEMA||'''.'''||V_TEXT_TABLA||'''');
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
