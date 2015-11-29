--/*
--##########################################
--## AUTOR=VICENTE LOZANO
--## FECHA_CREACION=02-10-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-288
--## PRODUCTO=SI
--## Finalidad: DDL Modificacion de las tabla PCO_BUR_ENVIO_INTEGRACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN
	    
	
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_BUR_ENVIO_INTEGRACION'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla procedemos a modificarla
    IF V_NUM_TABLAS = 1 THEN
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''PCO_BUR_ENVIO_INTEGRACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''PCO_BUR_FICHERO_DOC''';
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    		--si no existe la columna la creamos
    		IF V_NUM_TABLAS = 0 THEN
	            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_BUR_ENVIO_INTEGRACION ADD PCO_BUR_FICHERO_DOC VARCHAR2(30 CHAR)';
	            EXECUTE IMMEDIATE V_MSQL;
	            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION columna PCO_BUR_FICHERO_DOC modificada');
	        ELSE
	        	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION columna PCO_BUR_FICHERO_DOC ya existe');
	        END IF;	

    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''PCO_BUR_ENVIO_INTEGRACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''ID_ASUNTO_RCV''';
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    		--si no existe la columna la creamos
    		IF V_NUM_TABLAS = 0 THEN
	            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_BUR_ENVIO_INTEGRACION ADD ID_ASUNTO_RCV NUMBER(16)';
	            EXECUTE IMMEDIATE V_MSQL;
	            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION columna ID_ASUNTO_RCV modificada');
	        ELSE
	        	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION columna ID_ASUNTO_RCV ya existe');
	        END IF;	

    ELSE	
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_BUR_ENVIO_INTEGRACION... La tabla NO existe.');
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
