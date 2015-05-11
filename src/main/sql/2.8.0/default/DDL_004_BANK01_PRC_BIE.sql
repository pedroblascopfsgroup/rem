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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** Diccionarios previos ********
		-- ******** PRB_PRC_BIE *******
    DBMS_OUTPUT.PUT_LINE('******** PRB_PRC_BIE ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PRB_PRC_BIE... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''PRB_PRC_BIE'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PRB_PRC_BIE 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PRB_PRC_BIE... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PRB_PRC_BIE'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.PRB_PRC_BIE CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.PRB_PRC_BIE... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_PRB_PRC_BIE'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_PRB_PRC_BIE';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PRB_PRC_BIE... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRB_PRC_BIE... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRB_PRC_BIE...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_PRB_PRC_BIE';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PRB_PRC_BIE... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.PRB_PRC_BIE
                (
                  PRB_ID            NUMBER(16,0),
                  PRC_ID            NUMBER(16,0), 
                  BIE_ID            NUMBER(16,0),
                  DD_SGB_ID         NUMBER(16,0),
                  VERSION           INTEGER DEFAULT 0 NOT NULL ENABLE, 
                  USUARIOCREAR      VARCHAR2(10 CHAR) NOT NULL ENABLE, 
                  FECHACREAR        TIMESTAMP (6) NOT NULL ENABLE, 
                  USUARIOMODIFICAR  VARCHAR2(10 CHAR), 
                  FECHAMODIFICAR    TIMESTAMP (6), 
                  USUARIOBORRAR     VARCHAR2(10 CHAR), 
                  FECHABORRAR       TIMESTAMP (6), 
                  BORRADO           NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
                )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_PRB_PRC_BIE... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_PRB_PRC_BIE ON ' || V_ESQUEMA || '.PRB_PRC_BIE
					(PRB_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRB_PRC_BIE... Indice creado');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.PRB_PRC_BIE ADD (
                CONSTRAINT PK_PRB_PRC_BIE
                PRIMARY KEY (PRB_ID))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRB_PRC_BIE... PK creada');
    
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.PRB_PRC_BIE ADD (
                CONSTRAINT FK_DD_PRC_BIE_SGB FOREIGN KEY (DD_SGB_ID)
                REFERENCES ' || V_ESQUEMA_M || '.DD_SGB_SOLVENCIA_GARANTIA_BIEN (DD_SGB_ID) ENABLE,
                CONSTRAINT FK_PRC_BIE_REFERENCE_BIE_BIEN FOREIGN KEY (BIE_ID)
                REFERENCES ' || V_ESQUEMA || '.BIE_BIEN (BIE_ID) ENABLE,
                CONSTRAINT FK_PRC_BIE_REFERENCE_PRC_PROC FOREIGN KEY (PRC_ID)
                REFERENCES ' || V_ESQUEMA || '.PRC_PROCEDIMIENTOS (PRC_ID) ENABLE )';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRB_PRC_BIE... FK creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PRB_PRC_BIE... OK');

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