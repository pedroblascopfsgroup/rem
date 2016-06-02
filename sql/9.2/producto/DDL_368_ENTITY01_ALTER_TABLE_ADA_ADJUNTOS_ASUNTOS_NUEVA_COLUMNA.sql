--/*
--##########################################
--## AUTOR=Enrique Badenes
--## FECHA_CREACION=20160512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1082
--## PRODUCTO=SI
--## Finalidad: DDL insert RES_ID en la tabla ADA_ADJUNTOS_ASUNTOS
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
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	
		    	 -- ******** ADA_ADJUNTOS_ASUNTOS - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** ADA_ADJUNTOS_ASUNTOS - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ADA_ADJUNTOS_ASUNTOS'' and owner = '''||V_ESQUEMA||''' and column_name = ''RES_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS ADD(RES_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS... Añadido el campo RES_ID');
    END IF;

		-- ********** ASU_ASUNTOS - FKs
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''ADA_ADJUNTOS_ASUNTOS'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_NAME = ''FK_ADA_RES_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS ... FK ya existe');
    ELSE
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS  ADD (
			CONSTRAINT FK_ADA_RES_ID FOREIGN KEY (RES_ID) 
				 REFERENCES ' || V_ESQUEMA || '.RES_RESOLUCIONES_MASIVO (RES_ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS ... FK Creada');
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
