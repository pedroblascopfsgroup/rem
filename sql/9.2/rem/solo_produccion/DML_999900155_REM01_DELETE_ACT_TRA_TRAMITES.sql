--/*
--##########################################
--## AUTOR=JUANJO ARBONA
--## FECHA_CREACION=20171025
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2922
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar el ACT_GESTION.
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
    V_MSQL2 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_SQL2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA2 VARCHAR2(2400 CHAR) := 'TAC_TAREAS_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA3 VARCHAR2(2400 CHAR) := 'TAR_TAREAS_NOTIFICACIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA4 VARCHAR2(2400 CHAR) := 'TEX_TAREA_EXTERNA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA5 VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA6 VARCHAR2(2400 CHAR) := 'DD_TPO_TIPO_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
BEGIN
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de la tabla '||V_TEXT_TABLA2);
		
		V_SQL := 'SELECT COUNT(1) FROM ALL_TABlES WHERE TABLE_NAME = '''||V_TEXT_TABLA2||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAC_TAREAS_ACTIVOS');

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' tac 
				set tac.borrado = 1, tac.fechaborrar = sysdate, tac.usuarioborrar = ''HREOS-2922'' 
				where tac.tar_id in (SELECT tar.tar_id
						     FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' tac join REM01.ACT_ACTIVO act on tac.act_id = act.act_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA3||' tar on tar.tar_id = tac.tar_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA4||' tex on tex.tar_id = tar.tar_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA5||' tap on tap.tap_id = tex.tap_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA6||' ddtpo on ddtpo.dd_tpo_id = tap.dd_tpo_id 
							WHERE act.ACT_ADMISION = 1 and tar.borrado = 0 
							AND ddtpo.DD_TPO_CODIGO = ''T001'')';
		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||sql%rowcount||' tareas en '||V_ESQUEMA||'.'||V_TEXT_TABLA2||'');
		   
		 ELSE
		 
			DBMS_OUTPUT.PUT_LINE('[INICIO] La tabla '||V_TEXT_TABLA2||' no existe. No se hace nada');
		  
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' a finalizado correctamente');

		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de la tabla '||V_TEXT_TABLA2);
		
		V_SQL2 := 'SELECT COUNT(1) FROM ALL_TABlES WHERE TABLE_NAME = '''||V_TEXT_TABLA2||''' AND OWNER = '''||V_ESQUEMA||'''';
       		 EXECUTE IMMEDIATE V_SQL2 INTO V_NUM_TABLAS2;
        
		IF V_NUM_TABLAS2 > 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAC_TAREAS_NOTIFICACIONES');

		    V_MSQL2 := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA3||' tar 
				set tar.borrado = 1, tar.fechaborrar = sysdate, tar.usuarioborrar = ''HREOS-2922'' 
				where tar.tar_id in (SELECT tar.tar_id
						     FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' tac join REM01.ACT_ACTIVO act on tac.act_id = act.act_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA3||' tar on tar.tar_id = tac.tar_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA4||' tex on tex.tar_id = tar.tar_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA5||' tap on tap.tap_id = tex.tap_id
							JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA6||' ddtpo on ddtpo.dd_tpo_id = tap.dd_tpo_id 
							WHERE act.ACT_ADMISION = 1 and tar.borrado = 0 
							AND ddtpo.DD_TPO_CODIGO = ''T001'')';
		    EXECUTE IMMEDIATE V_MSQL2;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado '||sql%rowcount||' tareas en '||V_ESQUEMA||'.'||V_TEXT_TABLA3||'');
		   
		 ELSE
		 
			DBMS_OUTPUT.PUT_LINE('[INICIO] La tabla '||V_TEXT_TABLA3||' no existe. No se hace nada');
		  
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA3||' a finalizado correctamente');
		
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
