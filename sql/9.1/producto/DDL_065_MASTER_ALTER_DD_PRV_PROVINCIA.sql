--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151013
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=HR-970
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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
	    
    DBMS_OUTPUT.PUT_LINE('******** DD_PRV_PROVINCIA - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DD_PRV_PROVINCIA'' and owner = '''||V_ESQUEMA_M||''' and column_name = ''DD_CCA_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_PRV_PROVINCIA... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'alter table '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA add(DD_CCA_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_PRV_PROVINCIA... Añadido el campo DD_CCA_ID');
    END IF;
    
    -- ********** DD_PRV_PROVINCIA - FKs
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_PRV_PROVINCIA'' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_NAME = ''FK_PRV_CCA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la FK
    IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_PRV_PROVINCIA ... FK ya existe');
    ELSE
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_M || '.DD_PRV_PROVINCIA  ADD (
			CONSTRAINT FK_PRV_CCA FOREIGN KEY (DD_CCA_ID) 
				 REFERENCES ' || V_ESQUEMA_M || '.DD_CCA_COMUNIDAD (DD_CCA_ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_PRV_PROVINCIA ... FK Creada');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

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