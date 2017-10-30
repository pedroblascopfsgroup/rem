--/*
--##########################################
--## AUTOR=JUANJO ARBONA
--## FECHA_CREACION=20171030
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2922
--## PRODUCTO=SI
--##
--## Finalidad: Actualizar el ACT_TRA_TRAMITE.
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
    V_SQL2 VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_TABLAS2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAC_TAREAS_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA2 VARCHAR2(2400 CHAR) := 'TAR_TAREAS_NOTIFICACIONES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
BEGIN
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de la tabla '||V_TEXT_TABLA);
		
		V_SQL := 'SELECT COUNT(1) FROM ALL_TABlES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAC_TAREAS_ACTIVOS');
		    
			V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ACT
						USING (SELECT TAC.TAR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TAC
							WHERE TAC.TRA_ID NOT IN (SELECT TRA.TRA_ID FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA 
											INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = TRA.ACT_ID 
											WHERE ACT.ACT_ADMISION = 1)
							AND TAC.BORRADO = 0) AUX
						ON (AUX.TAR_ID = ACT.TAR_ID)
						WHEN MATCHED THEN UPDATE SET
						ACT.BORRADO = 1,
						ACT.USUARIOBORRAR = ''HREOS-2922'',
						ACT.FECHABORRAR = SYSDATE';

		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado '||sql%rowcount||' tareas en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');

		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de la tabla '||V_TEXT_TABLA);

		ELSE
		 
			DBMS_OUTPUT.PUT_LINE('[INICIO] La tabla '||V_TEXT_TABLA||' no existe. No se hace nada');
		  
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' a finalizado correctamente');
		
		V_SQL2 := 'SELECT COUNT(1) FROM ALL_TABlES WHERE TABLE_NAME = '''||V_TEXT_TABLA2||''' AND OWNER = '''||V_ESQUEMA||'''';
        	EXECUTE IMMEDIATE V_SQL2 INTO V_NUM_TABLAS2;
        
		IF V_NUM_TABLAS2 > 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando TAC_TAREAS_NOTIFICACIONES');

			V_MSQL2 := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' TAR
						USING (SELECT TAR2.TAR_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' TAR2
							WHERE TAR2.TRA_ID NOT IN (SELECT TRA.TRA_ID FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, '||V_ESQUEMA||'.ACT_ACTIVO ACT 
											WHERE ACT.ACT_ID = TRA.ACT_ID AND ACT.ACT_ADMISION = 1)
							AND TAR2.BORRADO = 0) AUX
						ON (AUX.TAR_ID = TAR.TAR_ID)
						WHEN MATCHED THEN UPDATE SET
						TAR.BORRADO = 1,
						TAR.USUARIOBORRAR = ''HREOS-2922'',
						TAR.FECHABORRAR = SYSDATE';

		    EXECUTE IMMEDIATE V_MSQL2;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado '||sql%rowcount||' tareas en '||V_ESQUEMA||'.'||V_TEXT_TABLA2||'');
		 ELSE
		 
		DBMS_OUTPUT.PUT_LINE('[INICIO] La tabla '||V_TEXT_TABLA2||' no existe. No se hace nada');
		  
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' a finalizado correctamente');
		
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
