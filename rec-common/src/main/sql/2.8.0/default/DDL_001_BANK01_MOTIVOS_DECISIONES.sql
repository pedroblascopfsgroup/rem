--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DDL para incluir motivos en las paralizaciones/finalizaciones
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** Diccionarios previos ********
		-- ******** DD_DFI_DECISION_FINALIZAR *******
    DBMS_OUTPUT.PUT_LINE('******** DD_DFI_DECISION_FINALIZAR ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_DFI_DECISION_FINALIZAR'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_DFI_DECISION_FINALIZAR'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DFI_DECISION_FINALIZAR... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_DFI_DECISION_FINALIZAR'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_DFI_DECISION_FINALIZAR';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DFI_DECISION_FINALIZAR... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_DFI_DECISION_FINALIZAR';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DFI_DECISION_FINALIZAR... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR
                (
                  DD_DFI_ID                 NUMBER(16)          NOT NULL,
                  DD_DFI_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
                  DD_DFI_DESCRIPCION        VARCHAR2(50 CHAR),
                  DD_DFI_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
                  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
                  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
                  FECHACREAR                TIMESTAMP(6)        NOT NULL,
                  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
                  FECHAMODIFICAR            TIMESTAMP(6),
                  USUARIOBORRAR             VARCHAR2(10 CHAR),
                  FECHABORRAR               TIMESTAMP(6),
                  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
                )';
    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DD_DFI_DECISION_FINALIZAR ON ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR
					(DD_DFI_CODIGO)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... Indice creado (1)');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_DFI_DECISION_FINALIZAR ON ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR
					(DD_DFI_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... Indice creado (2)');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR ADD (
                CONSTRAINT PK_DD_DFI_DECISION_FINALIZAR
                PRIMARY KEY (DD_DFI_ID),
                CONSTRAINT UK_DD_DFI_DECISION_FINALIZAR
                UNIQUE (DD_DFI_CODIGO))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... PK creada');
    V_MSQL := 'GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON '
                  || V_ESQUEMA ||' .DD_DFI_DECISION_FINALIZAR TO BANKMASTER';
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... Permisos dados a BANKMASTER');
    V_MSQL := 'GRANT SELECT ON '|| V_ESQUEMA ||' .S_DD_DFI_DECISION_FINALIZAR TO BANKMASTER';
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DFI_DECISION_FINALIZAR... Permisos de Select dados a BANKMASTER');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR... OK');
    
    
    
    -- ******** DD_DPA_DECISION_PARALIZAR *******
    DBMS_OUTPUT.PUT_LINE('******** DD_DPA_DECISION_PARALIZAR ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_DPA_DECISION_PARALIZAR'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_DPA_DECISION_PARALIZAR'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_DPA_DECISION_PARALIZAR... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_DPA_DECISION_PARALIZAR'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_DPA_DECISION_PARALIZAR';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DPA_DECISION_PARALIZAR... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_DPA_DECISION_PARALIZAR';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DPA_DECISION_PARALIZAR... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR
                (
                  DD_DPA_ID                 NUMBER(16)          NOT NULL,
                  DD_DPA_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
                  DD_DPA_DESCRIPCION        VARCHAR2(50 CHAR),
                  DD_DPA_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
                  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
                  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
                  FECHACREAR                TIMESTAMP(6)        NOT NULL,
                  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
                  FECHAMODIFICAR            TIMESTAMP(6),
                  USUARIOBORRAR             VARCHAR2(10 CHAR),
                  FECHABORRAR               TIMESTAMP(6),
                  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
                )';
    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DD_DPA_DECISION_PARALIZAR ON ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR
					(DD_DPA_CODIGO)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Indice creado (1)');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_DPA_DECISION_PARALIZAR ON ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR
					(DD_DPA_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Indice creado (2)');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR ADD (
                CONSTRAINT PK_DD_DPA_DECISION_PARALIZAR
                PRIMARY KEY (DD_DPA_ID),
                CONSTRAINT UK_DD_DPA_DECISION_PARALIZAR
                UNIQUE (DD_DPA_CODIGO))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... PK creada');
    V_MSQL := 'GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON '
                  || V_ESQUEMA ||' .DD_DPA_DECISION_PARALIZAR TO BANKMASTER';
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Permisos dados a BANKMASTER');
    V_MSQL := 'GRANT SELECT ON '|| V_ESQUEMA ||' .S_DD_DPA_DECISION_PARALIZAR TO BANKMASTER';
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_DPA_DECISION_PARALIZAR... Permisos de Select dados a BANKMASTER');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... OK');
    
    -- ******** DPR_DECISIONES_PROCEDIMIENTOS - Añadir campos *******
    DBMS_OUTPUT.PUT_LINE('******** DPR_DECISIONES_PROCEDIMIENTOS - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DPR_DECISIONES_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_DFI_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si no existe la clumna la añadimos
    IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||' .DPR_DECISIONES_PROCEDIMIENTOS ADD DD_DFI_ID NUMBER(16)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Añadido el campo DD_DFI_ID');
    END IF;
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DPR_DECISIONES_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_DPA_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si no existe la clumna la añadimos
    IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||' .DPR_DECISIONES_PROCEDIMIENTOS ADD DD_DPA_ID NUMBER(16)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Añadido el campo DD_DPA_ID');
    END IF;
    
    V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||'.DPR_DECISIONES_PROCEDIMIENTOS ADD (
                CONSTRAINT FK_DD_DFI_ID
                FOREIGN KEY (DD_DFI_ID)
                REFERENCES ' || V_ESQUEMA || '.DD_DFI_DECISION_FINALIZAR (DD_DFI_ID),
                CONSTRAINT FK_DD_DPA_ID
                FOREIGN KEY (DD_DPA_ID)
                REFERENCES ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR (DD_DPA_ID))';
                --DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[FIN] ' || V_ESQUEMA || '.DD_DPA_DECISION_PARALIZAR... Añadida las referencias a los diccionarios');

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