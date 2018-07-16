--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=2018016
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1331
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar script validacion en tarea Instrucciones reserva y Resultado PBC (comercial venta)
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
	 V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'REMVIP-1331';
    
    
    
BEGIN
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_InstruccionesReserva'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET
				TAP_SCRIPT_VALIDACION = ''checkImporteParticipacion() ? (checkCompradores() ? checkProvinciaCompradores() ? checkNifConyugueLBB() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''El NIF del cónyuge debe estar informado si el comprador está casado'''' : ''''Todos los compradores tienen que tener provincia informada'''' : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''''',
				USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
				FECHAMODIFICAR = SYSDATE
				WHERE TAP_CODIGO = ''T013_InstruccionesReserva''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando validación tarea T013_InstruccionesReserva.......');

		    EXECUTE IMMEDIATE V_MSQL;
		  
		END IF;

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T013_ResultadoPBC'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET
				TAP_SCRIPT_VALIDACION = ''checkImporteParticipacion() ? (checkCompradores() ? checkProvinciaCompradores() ? checkNifConyugueLBB() ? (checkVendido() ? ''''El activo está vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ? (checkCompradoresTienenNumeroUrsus() ? null : ''''No todos los compradores tienen numero URSUS'''' ) : ''''El estado de la política corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''El NIF del cónyuge debe estar informado si el comprador está casado'''' : ''''Todos los compradores tienen que tener provincia informada'''' : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participación de los activos ha de ser el mismo que el importe total del expediente'''''',
				USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''',
				FECHAMODIFICAR = SYSDATE
				WHERE TAP_CODIGO = ''T013_ResultadoPBC''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando validación tarea T013_ResultadoPBC.......');

		    EXECUTE IMMEDIATE V_MSQL;
		  
		END IF;
		
    COMMIT;
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE(V_MSQL);
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;