--/*
--##########################################
--## AUTOR=Ivan Serrano
--## FECHA_CREACION=20190610
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6666
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar T017_RespuestaOfertanteCES - TAP_SCRIPT_VALIDACION, TAP_SCRIPT_VALIDACION_JBPM 
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
    V_TABLA VARCHAR2(2400 CHAR):= 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USU_MODIFICAR VARCHAR2(1024 CHAR):= 'HREOS-6666';
    V_VALIDACION VARCHAR2(2000 CHAR) := q'[checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''El activo est&aacute; vendido'' : (checkComercializable() ? (checkPoliticaCorporativa() ? null : ''El estado de la pol%iacute;tica corporativa no es el correcto para poder avanzar.'') : ''El activo debe ser comercializable'') ) : ''Los compradores deben sumar el 100%'') : ''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'']';
    V_VALIDACION_JBPM VARCHAR2(2000 CHAR) := q'[valores[''T017_RespuestaOfertanteCES''][''comboRespuesta''] == DDRespuestaOfertante.CODIGO_RECHAZA ? null : respuestaOfertanteCesT017(valores[''T017_RespuestaOfertanteCES''][''importeOfertante''])]';
        
BEGIN
		DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TABLA);
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TAP_CODIGO = ''T017_RespuestaOfertanteCES'' AND BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET TAP_SCRIPT_VALIDACION = '''||V_VALIDACION||''', TAP_SCRIPT_VALIDACION_JBPM = '''||V_VALIDACION_JBPM||''', USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''', FECHAMODIFICAR = SYSDATE WHERE TAP_CODIGO = ''T017_RespuestaOfertanteCES''';
			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tarea ''T017_RespuestaOfertanteCES''.......');
		    DBMS_OUTPUT.PUT_LINE(V_MSQL);
		    EXECUTE IMMEDIATE V_MSQL;
		  
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
