--/*
--##########################################
--## Author: Pedro Blasco
--## Adaptado a BP : Pedro Blasco
--## Finalidad: DDL de creación de la tabla de mapeo entre tipo de documento y numero de orden de documento en IPLUS
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
    -- ******** MTO_MAPEO_TDOC_ORDEN *******
    DBMS_OUTPUT.PUT_LINE('******** MTO_MAPEO_TDOC_ORDEN ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTO_MAPEO_TDOC_ORDEN... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''MTO_MAPEO_TDOC_ORDEN'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.MTO_MAPEO_TDOC_ORDEN 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTO_MAPEO_TDOC_ORDEN... Claves primarias eliminadas');	
    END IF;
	-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''MTO_MAPEO_TDOC_ORDEN'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.MTO_MAPEO_TDOC_ORDEN CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MTO_MAPEO_TDOC_ORDEN... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
--	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_MTO_MAPEO_TDOC_ORDEN'' and sequence_owner = '''||V_ESQUEMA||'''';
--	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
--	if V_NUM_TABLAS = 1 THEN			
--		V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_MTO_MAPEO_TDOC_ORDEN';
--		EXECUTE IMMEDIATE V_MSQL;
--		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN... Secuencia eliminada');    
--	END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN...');
--    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_MTO_MAPEO_TDOC_ORDEN';
--	EXECUTE IMMEDIATE V_MSQL; 
--	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_MTO_MAPEO_TDOC_ORDEN... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN
					(
					  MTO_ID                    NUMBER(16)          NOT NULL,
					  DD_TFA_ID                 NUMBER(16)          NOT NULL,
					  MTO_NUM_ORDEN             INTEGER             DEFAULT 0                     NOT NULL,
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
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_MTO_MAPEO_TDOC_ORDEN ON ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN
					(MTO_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN... Indice creado');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN ADD (
		  CONSTRAINT PK_MTO_MAPEO_TDOC_ORDEN
		 PRIMARY KEY
		 (MTO_ID))';
	EXECUTE IMMEDIATE V_MSQL;              
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN... PK creada');
	V_MSQL := 'ALTER TABLE MTO_MAPEO_TDOC_ORDEN ADD (
			 CONSTRAINT FK_TIPO_FICHERO_ADJUNTO
			 FOREIGN KEY (DD_TFA_ID) 
			 REFERENCES DD_TFA_FICHERO_ADJUNTO (DD_TFA_ID)
			)';
	EXECUTE IMMEDIATE V_MSQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN... FK Creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MTO_MAPEO_TDOC_ORDEN... OK');
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