--/*
--##########################################
--## Author: Roberto
--## Adaptado a BP : Gonzalo Estellés
--## Finalidad: DDL crear tabla de gestorías
--## INSTRUCCIONES:  Crear la tabla de gestorías.
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

    DBMS_OUTPUT.PUT_LINE('******** DD_GES_GESTORIA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_GES_GESTORIA... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_GES_GESTORIA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_GES_GESTORIA 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_GES_GESTORIA... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_GES_GESTORIA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_GES_GESTORIA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_GES_GESTORIA... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_GES_GESTORIA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_GES_GESTORIA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_GES_GESTORIA... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_GES_GESTORIA... Comprobaciones previas FIN'); 


    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_GES_GESTORIA...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_GES_GESTORIA';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_GES_GESTORIA... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_GES_GESTORIA
					(
            DD_GES_ID NUMBER(16,0) NOT NULL ENABLE, 
            DD_GES_CODIGO VARCHAR2(20 CHAR) NOT NULL ENABLE, 
            DD_GES_DESCRIPCION VARCHAR2(50 CHAR), 
            DD_GES_DESCRIPCION_LARGA VARCHAR2(250 CHAR), 
            VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
            USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
            FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
            USUARIOMODIFICAR VARCHAR2(10 CHAR), 
            FECHAMODIFICAR TIMESTAMP (6), 
            USUARIOBORRAR VARCHAR2(10 CHAR), 
            FECHABORRAR TIMESTAMP (6), 
            BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
					)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_GES_GESTORIA... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DD_GES_GESTORIA ON ' || V_ESQUEMA || '.DD_GES_GESTORIA
					(DD_GES_CODIGO)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.UK_DD_GES_GESTORIA... Indice creado');
    
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_GES_GESTORIA ON ' || V_ESQUEMA || '.DD_GES_GESTORIA
					(DD_GES_ID)';
		EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_GES_GESTORIA ADD (
                CONSTRAINT PK_DD_GES_GESTORIA PRIMARY KEY (DD_GES_ID),
                CONSTRAINT UK_DD_GES_GESTORIA UNIQUE (DD_GES_CODIGO)
                )';						
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_GES_GESTORIA... Creando PK');	
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_GES_GESTORIA... OK');	


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