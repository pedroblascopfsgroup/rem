/*
--##########################################
--## AUTOR=CARLOS GIL GIMENO
--## FECHA_CREACION=20151222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-529
--## PRODUCTO=SI
--## Finalidad: DDL Para agregar la columna PER_MANUAL_ID y ES_PERSONA_MANUAL en la tabla PCO_BUR_BUROFAX 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
*/

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
    
BEGIN

    -- Comprobamos si existe la tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME = ''PCO_BUR_BUROFAX''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
         
    IF V_NUM_TABLAS > 0 THEN
        
    	-- Comprobamos si la tabla ya tiene creada la columna
    	V_SQL :='SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''PCO_BUR_BUROFAX'' AND COLUMN_NAME=''PER_ID''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN	
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.PCO_BUR_BUROFAX.PER_MANUAL_ID No existe.');
    	ELSE
    		V_SQL :='SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''PCO_BUR_BUROFAX'' AND COLUMN_NAME=''PER_ID'' AND NULLABLE=''N'' ';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			IF V_NUM_TABLAS = 0 THEN
				DBMS_OUTPUT.PUT_LINE('[INFO]La columna '||V_ESQUEMA||'.PCO_BUR_BUROFAX.PER_ID ya es nullable');
			ELSE
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_BUR_BUROFAX MODIFY (PER_ID NUMBER(16, 0) NULL)';
	    		EXECUTE IMMEDIATE V_MSQL;
	    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.PCO_BUR_BUROFAX.PER_ID modificada OK');
    		END IF;
    	END IF;
    
    
    	-- Comprobamos si la tabla ya tiene creada la columna
    	V_SQL :='SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''PCO_BUR_BUROFAX'' AND COLUMN_NAME=''PEM_ID''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_BUR_BUROFAX ADD (PEM_ID NUMBER(16, 0) )';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.PCO_BUR_BUROFAX.PEM_ID creada OK');
    		
    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_BUR_BUROFAX ADD (
						CONSTRAINT FK_PERSONA_MANUAL FOREIGN KEY (PEM_ID) REFERENCES '||V_ESQUEMA||'.PEM_PERSONAS_MANUALES (PEM_ID) ON DELETE SET NULL
						)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_PERSONA_MANUAL... Creando FK');
    	ELSE
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.PCO_BUR_BUROFAX.PER_MANUAL_ID ya existia.');
    	END IF;
    	
    	-- Comprobamos si la tabla ya tiene creada la columna DTYPE
    	V_SQL :='SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''PCO_BUR_BUROFAX'' AND COLUMN_NAME=''ES_PERSONA_MANUAL''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
    		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_BUR_BUROFAX ADD (ES_PERSONA_MANUAL NUMBER(1, 0) DEFAULT 0)';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.PCO_BUR_BUROFAX.ES_PERSONA_MANUAL creada OK');
    	ELSE
    		DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.PCO_BUR_BUROFAX.ES_PERSONA_MANUAL ya existia.');
    	END IF;
    	
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[ERROR] No existe la tabla '||V_ESQUEMA||'.PCO_BUR_BUROFAX ');
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
