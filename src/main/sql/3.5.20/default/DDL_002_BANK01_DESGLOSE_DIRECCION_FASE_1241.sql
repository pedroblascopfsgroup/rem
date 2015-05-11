--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150427
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.12
--## INCIDENCIA_LINK=FASE-1241
--## PRODUCTO=SI
--## Finalidad: DDL
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN


	DBMS_OUTPUT.PUT_LINE('[START]  tabla BIE_LOCALIZACION');

    
    	-- ****** CAMPO BIE_LOC_NOMBRE_VIA
    
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_NOMBRE_VIA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_NOMBRE_VIA VARCHAR2(100 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_NOMBRE_VIA');
    END IF;
    
        -- ****** CAMPO BIE_LOC_NUMERO_DOMICILIO
    
    	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_NUMERO_DOMICILIO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_NUMERO_DOMICILIO VARCHAR2(100 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_NUMERO_DOMICILIO');
    END IF;
    
        -- ****** CAMPO BIE_LOC_PORTAL

	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_PORTAL''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
	    V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_PORTAL VARCHAR2(10 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_PORTAL');
    END IF;

		-- ******* CAMPO BIE_LOC_BLOQUE
		
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_BLOQUE''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_BLOQUE VARCHAR2(10 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_BLOQUE');
    END IF;	
	
		-- ******* CAMPO BIE_LOC_ESCALERA
	
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_ESCALERA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_ESCALERA VARCHAR2(10 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_ESCALERA');
    END IF;
	
		-- ******* CAMPO BIE_LOC_PISO
		
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_PISO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_PISO VARCHAR2(10 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_PISO');
    END IF;
	
		-- ******* CAMPO BIE_LOC_PUERTA
		
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_PUERTA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_PUERTA VARCHAR2(10 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_PUERTA');
    END IF;
	
	
		-- ******* CAMPO BIE_LOC_BARRIO 
		
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_BARRIO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_BARRIO VARCHAR2(100 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_BARRIO ');
    END IF;
	
	
		-- ******* BIE_LOC_MUNICIPIO
		
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_MUNICIPIO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_MUNICIPIO VARCHAR2(100 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_MUNICIPIO');
    END IF;
	
	
		-- ******* CAMPO BIE_LOC_PROVINCIA
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_LOC_PROVINCIA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (BIE_LOC_PROVINCIA VARCHAR2(2 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo BIE_LOC_PROVINCIA');
    END IF;
	
	
		-- ******* DD_LOC_ID
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_LOC_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (DD_LOC_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo DD_LOC_ID');
    END IF;	
	
	
		-- ******* CAMPO DD_UPO_ID
		
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_LOCALIZACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_UPO_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... El campo ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION ADD (DD_UPO_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION... Añadido el campo DD_UPO_ID');
    END IF;
    
    
     -- ********** BIE_LOCALIZACION - FK A DD_LOC_LOCALIDAD
     
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_BIE_LOC_FK_BIE_BIEN''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si no existe
    IF V_NUM_TABLAS != 1 THEN 
    
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_LOCALIZACION  ADD (
			CONSTRAINT FK_BIEN_DD_LOC FOREIGN KEY (DD_LOC_ID) 
				 REFERENCES ' || V_ESQUEMA_M || '.DD_LOC_LOCALIDAD (DD_LOC_ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION ... FK_BIEN_DD_LOC Creada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION ... FK_BIEN_DD_LOC  ya existe'); 
   
    END IF;

	    -- ********** BIE_LOCALIZACION - FK A DD_UPO_UNID_POBLACIONAL
	
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''FK_BIE_LOC_UPO_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si no existe
    IF V_NUM_TABLAS != 1 THEN 
    
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_LOCALIZACION  ADD (
			CONSTRAINT FK_BIEN_DD_UPO FOREIGN KEY (DD_UPO_ID) 
				 REFERENCES ' || V_ESQUEMA_M || '.DD_UPO_UNID_POBLACIONAL (DD_UPO_ID))';
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION ... FK_BIEN_DD_UPO Creada'); 
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_LOCALIZACION ... FK_BIEN_DD_UPO  ya existe'); 
	
	END if;


DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| V_ESQUEMA ||'.BIE_LOCALIZACION DESGLOSE DIRECCIONES  ... OK');
    
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