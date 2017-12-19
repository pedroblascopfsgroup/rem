--/*
--##########################################
--## AUTOR=JOSE NAVARRO
--## FECHA_CREACION=20171102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1865
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
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_InstruccionesReserva'' AND BORRADO = 0';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN
		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
            SET TAP_SCRIPT_VALIDACION_JBPM = ''checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? (checkCompradoresTienenNumeroUrsus() ?  mismoNumeroAdjuntosComoCompradoresExpedienteUGValidacion("37", "E", "01"): ''''No todos los compradores tienen NºURSUS'''') : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente''''''
			WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_InstruccionesReserva'')';
            
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			COMMIT;
			
			DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '''||V_ESQUEMA||'''.'''||V_TEXT_TABLA||''' a finalizado correctamente');
		
		END IF;
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
