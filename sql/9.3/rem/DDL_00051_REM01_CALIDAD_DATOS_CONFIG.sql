--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20200721
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7742
--## PRODUCTO=NO
--## 
--## Finalidad: DDL Creación de la tabla CDC_CALIDAD_DATOS_CONFIG
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
    V_TABLA VARCHAR2(150 CHAR):= 'CDC_CALIDAD_DATOS_CONFIG'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
   BEGIN

    -- ******** CDC_CALIDAD_DATOS_CONFIG *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 1 THEN                
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';		
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... BORRADA');  
	  END IF;

    -- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 

    IF V_NUM_TABLAS = 1 THEN      
      EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
      DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'...  BORRADA');  

    END IF; 
     
    -- Creamos la tabla
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla '||V_TABLA||'');
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
    			 CDC_ID  				                   	NUMBER(16,0)    				PRIMARY KEY
				,TABLA										VARCHAR2(50 CHAR)		NOT NULL
				,CAMPO										VARCHAR2(50 CHAR)		NOT NULL
				,COD_CAMPO							VARCHAR2(10 CHAR)		NOT NULL 	UNIQUE
				,CAMPO_ID 				            	VARCHAR2(50 CHAR)
				,VALIDACION							VARCHAR2(4 CHAR)
				,TABLA_AUX    							VARCHAR2(50 CHAR)		
				,CAMPO_ID_TABLA_AUX    	VARCHAR2(50 CHAR)				
				,CLAVE_DICCIONARIO		   	VARCHAR2(30 CHAR)
				,VERSION                      				NUMBER(1,0)         			DEFAULT 0
				,USUARIOCREAR                  	VARCHAR2(50 CHAR)		NOT NULL
				,FECHACREAR                    		TIMESTAMP(6)        			DEFAULT SYSTIMESTAMP
				,USUARIOMODIFICAR             VARCHAR2(50 CHAR)
				,FECHAMODIFICAR                	TIMESTAMP(6)
				,USUARIOBORRAR                 	VARCHAR2(50 CHAR)
				,FECHABORRAR                   	TIMESTAMP(6)
				,BORRADO                       			NUMBER(1,0)         			DEFAULT 0					
				,CONSTRAINT CHK_VALIDACION CHECK (VALIDACION IN (''F'',''T'',''N'',''DD''))	
			  )';        	

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada OK');		
		
    -- Creamos la secuencia	
	DBMS_OUTPUT.PUT_LINE('[INFO] Creando secuencia');
	V_SQL:= 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Secuencia creada OK');
    
					
    EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.'||V_TABLA||' IS ''Tabla de configuracion para el proceso masivo de calidad de datos''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CDC_ID IS ''ID único del registro de la tabla''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.TABLA IS ''Tabla que contiene el campo para actualizar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CAMPO IS ''Campo de TABLA que se va a actualizar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.COD_CAMPO IS ''Codigo identificador para CAMPO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CAMPO_ID IS ''Campo que identifica el registro a actualizar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.VALIDACION IS ''Tipo de validacion para el campo. Valores admitidos: F-Fecha, T-Texto, N-Númerico, DD-Diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.TABLA_AUX IS ''Identificador de la tabla auxiliar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CAMPO_ID_TABLA_AUX IS ''Campo que identifica el registro en la tabla auxiliar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.CLAVE_DICCIONARIO IS ''Si la valicacion es DD, identifica la clave para recuperar el diccionario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.VERSION IS ''Indica la versión del registro''';  
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.'||V_TABLA||'.BORRADO IS ''Indicador de borrado''';
  
    DBMS_OUTPUT.PUT_LINE('[INFO] Creados comentarios en '|| V_ESQUEMA ||'.'||V_TABLA||'... OK');
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] Proceso finalizado correctamente');
    
    
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