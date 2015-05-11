--/*
--##########################################
--## Author: Pedro Blasco
--## Adaptado a BP : Pedro Blasco
--## Finalidad: DDL de creación de la tabla de envío de envío de emails de acuerdos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** AEM_ACUERDOS_ENV_MAIL *******
    DBMS_OUTPUT.PUT_LINE('******** AEM_ACUERDOS_ENV_MAIL ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''AEM_ACUERDOS_ENV_MAIL'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL... Claves primarias eliminadas');	
    END IF;
	-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AEM_ACUERDOS_ENV_MAIL'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_AEM_ACUERDOS_ENV_MAIL'' and sequence_owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	if V_NUM_TABLAS = 1 THEN			
		V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_AEM_ACUERDOS_ENV_MAIL';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... Secuencia eliminada');    
	END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_AEM_ACUERDOS_ENV_MAIL';
	EXECUTE IMMEDIATE V_MSQL; 
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_AEM_ACUERDOS_ENV_MAIL... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL
					(
					  AEM_ID                    NUMBER(16)          NOT NULL,
					  ACU_ID                    NUMBER(16)          NOT NULL,
					  OFI_ID                    NUMBER(16)          NOT NULL,
					  AEM_ENVIADO               INTEGER             DEFAULT 0                     NOT NULL,
					  AEM_FECHA_PROP            TIMESTAMP(6)        NOT NULL,
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
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_AEM_ACUERDOS_ENV_MAIL ON ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL
					(AEM_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... Indice creado');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL ADD (
		  CONSTRAINT PK_AEM_ACUERDOS_ENV_MAIL
		 PRIMARY KEY
		 (AEM_ID))';
	EXECUTE IMMEDIATE V_MSQL;              
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... PK creada');
	V_MSQL := 'ALTER TABLE AEM_ACUERDOS_ENV_MAIL ADD (
			  CONSTRAINT FK_ACUERDOS_PROCEDIMIENTO
			 FOREIGN KEY (ACU_ID) 
			 REFERENCES ACU_ACUERDO_PROCEDIMIENTOS (ACU_ID),
			  CONSTRAINT FK_OFI_OFICINAS
			 FOREIGN KEY (OFI_ID) 
			 REFERENCES OFI_OFICINAS (OFI_ID))';
	EXECUTE IMMEDIATE V_MSQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... FK Creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... OK');
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