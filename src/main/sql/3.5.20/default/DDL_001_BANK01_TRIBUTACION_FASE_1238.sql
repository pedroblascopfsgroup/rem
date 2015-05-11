--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20150427
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.12
--## INCIDENCIA_LINK=FASE-1238
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

	-- ******** DD_QCI_QCIVAC *******
    DBMS_OUTPUT.PUT_LINE('******** DD_QCI_QCIVAC ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_QCI_QCIVAC... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_QCI_QCIVAC'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_QCI_QCIVAC
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_QCI_QCIVAC... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_QCI_QCIVAC'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_QCI_QCIVAC CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_QCI_QCIVAC... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_QCI_QCIVAC'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_QCI_QCIVAC';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_QCI_QCIVAC... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_QCI_QCIVAC... Comprobaciones previas FIN'); 
    
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_QCI_QCIVAC...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_QCI_QCIVAC';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_QCI_QCIVAC... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_QCI_QCIVAC
					(
					  DD_QCI_ID                 NUMBER(16)          NOT NULL,
					  DD_QCI_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
					  DD_QCI_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
					  DD_QCI_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_QCI_QCIVAC... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_QCI_QCIVAC ON ' || V_ESQUEMA || '.DD_QCI_QCIVAC
					(DD_QCI_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_QCI_QCIVAC... Indice creado');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_QCI_QCIVAC ADD (
		  CONSTRAINT PK_DD_QCI_QCIVAC PRIMARY KEY (DD_QCI_ID),
         CONSTRAINT UK_DD_QCI_CODIGO UNIQUE (DD_QCI_CODIGO))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_QCI_QCIVAC... PK creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_QCI_QCIVAC... OK');
    
	
	 -- ******** BIE_BIEN - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** BIE_BIEN - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_PORCT_IMP_COMPRA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'alter table '||V_ESQUEMA||'.BIE_BIEN add(BIE_PORCT_IMP_COMPRA NUMBER(5,2))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... Añadido el campo BIE_PORCT_IMP_COMPRA');
    END IF;
    
        V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_QCI_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'alter table '||V_ESQUEMA||'.BIE_BIEN add(DD_QCI_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... Añadido el campo DD_QCI_ID');
    END IF;
    
    -- ********** BIE_BIEN - FK A DD_QCI_QCIVAC
    
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_BIEN  ADD (
		CONSTRAINT FK_BIEN_DD_QCI FOREIGN KEY (DD_QCI_ID) 
			 REFERENCES DD_QCI_QCIVAC (DD_QCI_ID))';
		
	EXECUTE IMMEDIATE V_MSQL;     
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN ... FK Creada');
    
    
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