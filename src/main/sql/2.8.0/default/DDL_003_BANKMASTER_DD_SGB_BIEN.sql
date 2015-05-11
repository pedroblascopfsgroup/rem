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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_ESQUEMA_P VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas para permisos
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** Diccionarios previos ********
		-- ******** DD_SGB_SOLVENCIA_GARANTIA_BIEN *******
    DBMS_OUTPUT.PUT_LINE('******** DD_SGB_SOLVENCIA_GARANTIA_BIEN ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_SGB_SOLVENCIA_GARANTIA_BIEN'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_SGB_SOLVENCIA_GARANTIA_BIEN'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_SGB_BIEN'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_SGB_BIEN';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_SGB_BIEN... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_SGB_BIEN';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_SGB_BIEN... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN
                (
                  DD_SGB_ID NUMBER(16,0) NOT NULL ENABLE, 
                  DD_SGB_CODIGO VARCHAR2(20 CHAR) NOT NULL ENABLE, 
                  DD_SGB_DESCRIPCION VARCHAR2(50 CHAR), 
                  DD_SGB_DESCRIPCION_LARGA VARCHAR2(250 CHAR), 
                  VERSION   INTEGER   DEFAULT 0   NOT NULL ENABLE, 
                  USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
                  FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
                  USUARIOMODIFICAR VARCHAR2(10 CHAR), 
                  FECHAMODIFICAR TIMESTAMP (6), 
                  USUARIOBORRAR VARCHAR2(10 CHAR), 
                  FECHABORRAR TIMESTAMP (6), 
                  BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
                )';
    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DD_SGB_BIEN ON ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN
					(DD_SGB_CODIGO)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Indice creado (1)');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_SGB_BIEN ON ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN
					(DD_SGB_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN... Indice creado (2)');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN ADD (
                CONSTRAINT PK_DD_SGB_BIEN
                PRIMARY KEY (DD_SGB_ID),
                CONSTRAINT UK_DD_SGB_BIEN
                UNIQUE (DD_SGB_CODIGO))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN... PK creada');

    EXECUTE IMMEDIATE 'GRANT REFERENCES, SELECT ON '|| V_ESQUEMA ||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN TO '|| V_ESQUEMA_P ||'';
    DBMS_OUTPUT.PUT_LINE('[INFO] GRANT '|| V_ESQUEMA ||'.DD_SGB_SOLVENCIA_GARANTIA_BIEN');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN... OK');
    

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