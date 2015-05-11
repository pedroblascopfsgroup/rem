--/*
--##########################################
--## Author: David Gilsanz
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DDL para incluir el diccionario de Tipo de asunto
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** Diccionarios previos ********
		-- ******** DD_TAS_TIPOS_ASUNTO *******
    DBMS_OUTPUT.PUT_LINE('******** DD_TAS_TIPOS_ASUNTO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TAS_TIPOS_ASUNTO'' and owner = '''||V_ESQUEMA_M||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TAS_TIPOS_ASUNTO'' and owner = '''||V_ESQUEMA_M||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_M||'.DD_TAS_TIPOS_ASUNTO... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_TAS_TIPOS_ASUNTO'' and sequence_owner = '''||V_ESQUEMA_M||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA_M||'.S_DD_TAS_TIPOS_ASUNTO';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_TAS_TIPOS_ASUNTO... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA_M || '.S_DD_TAS_TIPOS_ASUNTO';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_TAS_TIPOS_ASUNTO... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO
                (
                  DD_TAS_ID                 NUMBER(16)          NOT NULL,
                  DD_TAS_CODIGO             VARCHAR2(50 BYTE)   NOT NULL,
                  DD_TAS_DESCRIPCION        VARCHAR2(100 BYTE)  NOT NULL,
                  DD_TAS_DESCRIPCION_LARGA  VARCHAR2(250 BYTE),
                  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
                  USUARIOCREAR              VARCHAR2(10 BYTE)   NOT NULL,
                  FECHACREAR                TIMESTAMP(6)        NOT NULL,
                  USUARIOMODIFICAR          VARCHAR2(10 BYTE),
                  FECHAMODIFICAR            TIMESTAMP(6),
                  USUARIOBORRAR             VARCHAR2(10 BYTE),
                  FECHABORRAR               TIMESTAMP(6),
                  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
                )';
    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO... Tabla creada');
    
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA_M || '.PK_DD_TAS_TIPOS_ASUNTO ON ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO
					(DD_TAS_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO... Indice creado');
   
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO ADD (
                CONSTRAINT PK_DD_TAS_TIPOS_ASUNTO
                PRIMARY KEY (DD_TAS_ID))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO... PK creada');
    
    V_MSQL := 'GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON '
                  || V_ESQUEMA_M ||' .DD_TAS_TIPOS_ASUNTO TO '|| V_ESQUEMA;
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO... Permisos dados a '|| V_ESQUEMA);
    
    V_MSQL := 'GRANT SELECT ON '|| V_ESQUEMA_M ||' .S_DD_TAS_TIPOS_ASUNTO TO '|| V_ESQUEMA;
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.S_DD_TAS_TIPOS_ASUNTO... Permisos dados a '|| V_ESQUEMA);
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_TAS_TIPOS_ASUNTO... OK');

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