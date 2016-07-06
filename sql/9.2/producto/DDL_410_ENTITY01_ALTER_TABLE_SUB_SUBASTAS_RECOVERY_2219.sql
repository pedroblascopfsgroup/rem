--/*
--##########################################
--## AUTOR=SERGIO NIETO GIL.
--## FECHA_CREACION=20160628
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2219
--## PRODUCTO=SI
--## Finalidad: Amplicación de tabla
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TABLA1 VARCHAR(30 CHAR) :='SUB_SUBASTA';

    BEGIN
	    
	    	 -- ******** SUB_SUBASTA - Añadir campos *******

     -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN 
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''SUB_FECHA_PUBLICACION_BOE'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (SUB_FECHA_PUBLICACION_BOE  TIMESTAMP(6))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Columna agregada');    
			END IF;			
    END IF;
    
     -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''SUB_TRAMITACION'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (SUB_TRAMITACION  NUMBER(1))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Columna agregada');    
			END IF; 			
    END IF;
    
      -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''SUB_TASACION_ELECTRONICA'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (SUB_TASACION_ELECTRONICA  NUMBER(1))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Columna agregada');    
			END IF; 			
    END IF;
    
      -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''DD_RCS_ID'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (DD_RCS_ID  NUMBER(16))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Columna agregada');    
			END IF; 			
    END IF;

	-- Comprobamos si ya existe la FK
    	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''' || V_TABLA1 || ''' AND CONSTRAINT_TYPE=''R'' AND CONSTRAINT_NAME=''FK_SUBASTA_RCS''';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    	
    	IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD CONSTRAINT FK_SUBASTA_RCS FOREIGN KEY ( DD_RCS_ID ) REFERENCES '||V_ESQUEMA||'.DD_RCS_RESULTADO_COMITE_SUB ( DD_RCS_ID ) ENABLE';
    		          	DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
          	DBMS_OUTPUT.PUT_LINE('[INFO] Foreign key '||V_ESQUEMA||'.' || V_TABLA1 || '.FK_SUBASTA_RCS creada OK');
        ELSE
        	DBMS_OUTPUT.PUT_LINE('[INFO] Foreign key '||V_ESQUEMA||'.' || V_TABLA1 || '.FK_SUBASTA_RCS ya existia');
        END IF;	
        
         -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''DD_MSE_ID'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (DD_MSE_ID  NUMBER(16))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Columna agregada');    
			END IF; 			
    END IF;

	-- Comprobamos si ya existe la FK
    	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE OWNER='''||V_ESQUEMA||''' AND TABLE_NAME=''' || V_TABLA1 || ''' AND CONSTRAINT_TYPE=''R'' AND CONSTRAINT_NAME=''FK_SUBASTA_MSE''';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    	
    	IF V_NUM_TABLAS = 0 THEN
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD CONSTRAINT FK_SUBASTA_MSE FOREIGN KEY ( DD_MSE_ID ) REFERENCES '||V_ESQUEMA||'.DD_MSE_MOTIVO_SUSP_ELEC ( DD_MSE_ID ) ENABLE';
    		          	DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
          	DBMS_OUTPUT.PUT_LINE('[INFO] Foreign key '||V_ESQUEMA||'.' || V_TABLA1 || '.FK_SUBASTA_MSE creada OK');
        ELSE
        	DBMS_OUTPUT.PUT_LINE('[INFO] Foreign key '||V_ESQUEMA||'.' || V_TABLA1 || '.FK_SUBASTA_MSE ya existia');
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
