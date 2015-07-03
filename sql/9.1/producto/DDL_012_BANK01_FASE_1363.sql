--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150608
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=FASE-1363
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


	DBMS_OUTPUT.PUT_LINE('[START]  tabla BIE_DATOS_REGISTRALES');
	
	-- ******* DD_LOC_ID
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_DATOS_REGISTRALES'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_LOC_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES... El campo DD_LOC_ID ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES ADD (DD_LOC_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES... Añadido el campo DD_LOC_ID');
    END IF;
    
    
    -- ******* DD_PRV_ID
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_DATOS_REGISTRALES'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_PRV_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES... El campo DD_PRV_ID ya existe en la tabla');
    ELSE	
		V_MSQL := 'ALTER TABLE '|| V_ESQUEMA ||'.BIE_DATOS_REGISTRALES ADD (DD_PRV_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES... Añadido el campo DD_PRV_ID');
    END IF;
    
        
     -- ********** BIE_DATOS_REGISTRALES - FK A DD_LOC_LOCALIDAD

    V_SQL := 'SELECT COUNT(1) FROM (    SELECT consa.CONSTRAINT_NAME FROM ALL_CONSTRAINTS CONSA
	INNER JOIN ALL_CONS_COLUMNS COLSA ON CONSA.CONSTRAINT_NAME = COLSA.CONSTRAINT_NAME AND CONSA.OWNER = COLSA.OWNER
	WHERE COLSA.TABLE_NAME = ''BIE_DATOS_REGISTRALES'' AND CONSA.CONSTRAINT_TYPE = ''R''
	AND COLSA.COLUMN_NAME = ''DD_LOC_ID'' AND CONSA.OWNER ='''|| V_ESQUEMA ||''')';   
    
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si no existe
    IF V_NUM_TABLAS != 1 THEN 
    
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES  ADD (
			CONSTRAINT FK_BIEN_DREG_DD_LOC FOREIGN KEY (DD_LOC_ID) 
				 REFERENCES ' || V_ESQUEMA_M || '.DD_LOC_LOCALIDAD (DD_LOC_ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES ... FK_BIEN_DREG_DD_LOC Creada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES ... FK A DD_LOC_ID  ya existe'); 
   
    END IF;
    
        
     -- ********** BIE_DATOS_REGISTRALES - FK A DD_PRV_PROVINCIA
     
    V_SQL := 'SELECT COUNT(1) FROM (    SELECT consa.CONSTRAINT_NAME FROM ALL_CONSTRAINTS CONSA
	INNER JOIN ALL_CONS_COLUMNS COLSA ON CONSA.CONSTRAINT_NAME = COLSA.CONSTRAINT_NAME AND CONSA.OWNER = COLSA.OWNER
	WHERE COLSA.TABLE_NAME = ''BIE_DATOS_REGISTRALES'' AND CONSA.CONSTRAINT_TYPE = ''R''
	AND COLSA.COLUMN_NAME = ''DD_PRV_ID'' AND CONSA.OWNER ='''|| V_ESQUEMA ||''')';   
    
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
    -- Si no existe
    IF V_NUM_TABLAS != 1 THEN 
    
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES  ADD (
			CONSTRAINT FK_BIEN_DREG_DD_PROV FOREIGN KEY (DD_PRV_ID) 
				 REFERENCES ' || V_ESQUEMA_M || '.DD_PRV_PROVINCIA (DD_PRV_ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES ... FK_BIEN_DREG_DD_PROV Creada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES ... FK A DD_PROV_ID  ya existe'); 
   
    END IF;
    

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT