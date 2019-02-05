--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20180807
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4335
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar script validacion JBPM Cierre Economico
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
	
	V_USUSARIO_MOD VARCHAR2(50 CHAR) := 'HREOS-4335';
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    

BEGIN
		
	DBMS_OUTPUT.PUT_LINE('[INICIO] Actualizar datos de '||V_TEXT_TABLA);
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE TAP_CODIGO = ''T004_CierreEconomico'' AND BORRADO = 0';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
	    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' SET TAP_SCRIPT_VALIDACION_JBPM = ''activoEnTramite() ? ''''No se puede avanzar la tarea ya que el activo se encuentra en estado "En tr&#225;mite"'''' : esFechaMenor(valores[''''T004_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n del trabajo'''' : null'','|| 
	    'USUARIOMODIFICAR= '''||V_USUSARIO_MOD||''' ,'||
		'FECHAMODIFICAR= SYSDATE '||
	    'WHERE TAP_CODIGO = ''T004_CierreEconomico'' ';
		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando tap script validacion JBPM de la tarea T004_CierreEconomico.......');
	    EXECUTE IMMEDIATE V_MSQL;
	  	DBMS_OUTPUT.PUT_LINE('	[INFO]: Actualización finalizada');
	    DBMS_OUTPUT.PUT_LINE('	[INFO]: Actualización de '||SQL%ROWCOUNT||' fila');
	
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