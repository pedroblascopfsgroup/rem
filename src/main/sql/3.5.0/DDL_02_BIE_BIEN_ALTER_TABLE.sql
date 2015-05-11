--/*
--##########################################
--## Author: Nacho
--## Finalidad: DDL crear columnas nuevas para la tabla BIE_BIEN
--## INSTRUCCIONES:  Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** BIE_BIEN ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and COLUMN_NAME = ''DD_TRI_ID''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la columna
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD
                  (DD_TRI_ID NUMBER(16,0))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columna DD_TRI_ID creada');
			
	  V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD CONSTRAINT
                  FK_BIE_BIEN_FK_DD_TRIBUTACION foreign key(DD_TRI_ID) references DD_TRI_TRIBUTACION(DD_TRI_ID)';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... FK sobre columna DD_TRI_ID creada');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and COLUMN_NAME = ''BIE_FECHA_DUE_D''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la columna
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD
                  (BIE_FECHA_DUE_D TIMESTAMP(6))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columna BIE_FECHA_DUE_D creada');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and COLUMN_NAME = ''BIE_FECHA_SOLICITUD_DUE_D''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la columna
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD
                  (BIE_FECHA_SOLICITUD_DUE_D TIMESTAMP(6))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columna BIE_FECHA_SOLICITUD_DUE_D creada');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and COLUMN_NAME = ''BIE_USO_PROMOTOR_MAYOR2''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la columna
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD
                  (BIE_USO_PROMOTOR_MAYOR2 VARCHAR2(50BYTE))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columna BIE_USO_PROMOTOR_MAYOR2 creada');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and COLUMN_NAME = ''BIE_TRANSMITENTE_PROMOTOR''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la columna
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD
                  (BIE_TRANSMITENTE_PROMOTOR VARCHAR2(50BYTE))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columna BIE_TRANSMITENTE_PROMOTOR creada');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and COLUMN_NAME = ''BIE_ARRENDADO_SIN_OPC_COMPRA''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la columna
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD
                  (BIE_ARRENDADO_SIN_OPC_COMPRA VARCHAR2(50BYTE))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columna BIE_ARRENDADO_SIN_OPC_COMPRA creada');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and COLUMN_NAME = ''BIE_DUE_DILLIGENCE''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si no existe la columna
    IF V_NUM_TABLAS = 0 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD
                  (BIE_DUE_DILLIGENCE NUMBER(1,0))';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columna BIE_DUE_DILLIGENCE creada');
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
