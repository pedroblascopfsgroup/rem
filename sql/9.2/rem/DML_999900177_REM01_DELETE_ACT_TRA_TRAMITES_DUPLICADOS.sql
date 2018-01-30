--/*
--##########################################
--## AUTOR=JOSE NAVARRO
--## FECHA_CREACION=20180125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3680
--## PRODUCTO=SI
--##
--## Finalidad: Borrado de tramites duplicados en ACT_TRA_TRAMITE.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_TRA_TRAMITE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    
BEGIN
	
		DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso de actualización de la tabla '||V_TEXT_TABLA);
		
		V_SQL := 'SELECT COUNT(1) FROM ALL_TABlES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Borrando duplicados de ACT_TRA_TRAMITE');

		    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TRA
				SET tra.borrado = 1, tra.fechaborrar = sysdate, tra.usuarioborrar = ''HREOS-3680''
				WHERE EXISTS  (
						  SELECT 1
						  FROM(
							    SELECT ROW_NUMBER() OVER (PARTITION BY TRA.ACT_ID, TRA.DD_TPO_ID, TRA.DD_EPR_ID ORDER BY TRA.TRA_FECHA_INICIO ASC) AS POSICION, TRA.TRA_ID, TRA.ACT_ID, TRA.TRA_FECHA_INICIO
							    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TRA
							    INNER JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TRA.DD_TPO_ID AND TPO.DD_TPO_CODIGO = ''T011''
							    INNER JOIN '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR ON EPR.DD_EPR_ID = TRA.DD_EPR_ID AND EPR.DD_EPR_CODIGO = ''10''
							    WHERE TRA.ACT_ID IS NOT NULL
							    AND TRA.BORRADO = 0
							) TMP
							WHERE POSICION > 1
							AND TMP.TRA_ID = TRA.TRA_ID
						)';
		    EXECUTE IMMEDIATE V_MSQL;
		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado '||sql%rowcount||' tramites en '||V_ESQUEMA||'.'||V_TEXT_TABLA||'');
		   
		 ELSE
		 
			DBMS_OUTPUT.PUT_LINE('[INICIO] La tabla '||V_TEXT_TABLA||' no existe. No se hace nada');
		  
		END IF;

		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de actualización de la tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' a finalizado correctamente');
		
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
