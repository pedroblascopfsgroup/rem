--/*
--##########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20160614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.2.5-bk
--## INCIDENCIA_LINK=PRODUCTO-1451
--## PRODUCTO=SI
--## 
--## Finalidad: Creación de tablas 
--##							MPP_MAPEO_PLANTILLAS_PCO
--##                               
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

	V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
	V_TS_INDEX VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
	ERR_NUM NUMBER;
	ERR_MSG VARCHAR2(2048 CHAR); 
	V_SQL VARCHAR2(8500 CHAR);
	V_MSQL VARCHAR2(8500 CHAR);
	V_NUM_TABLAS NUMBER (1);

	V_TABLA1 VARCHAR(30 CHAR) :='MPP_MAPEO_PLANTILLAS_PCO';

BEGIN 


    DBMS_OUTPUT.PUT_LINE('******** ' || V_TABLA1 || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || V_TABLA1 || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || V_TABLA1 || '... Claves primarias eliminadas');	
    END IF;
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || V_TABLA1 || '... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_' || V_TABLA1 || ''' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_' || V_TABLA1 || '';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_' || V_TABLA1 || '... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Comprobaciones previas FIN'); 


    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] Creación objetos asociados a ' || V_ESQUEMA || '.' || V_TABLA1 || '...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_' || V_TABLA1 || '';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_' || V_TABLA1 || '... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.' || V_TABLA1 || ' (
    MPP_ID NUMBER(16,0) NOT NULL
    ,DD_APO_ID NUMBER(16,0) NOT NULL
    ,DD_PCO_LIQ_ID NUMBER(16,0) 
    ,DD_PCO_BFT_ID NUMBER(16,0) 
    ,VERSION                        INTEGER        DEFAULT 0                     NOT NULL
    ,USUARIOCREAR                   VARCHAR2(50 CHAR) NOT NULL
    ,FECHACREAR                     TIMESTAMP(6)   NOT NULL
    ,USUARIOMODIFICAR               VARCHAR2(50 CHAR)
    ,FECHAMODIFICAR                 TIMESTAMP(6)
    ,USUARIOBORRAR                  VARCHAR2(50 CHAR)
    ,FECHABORRAR                    TIMESTAMP(6)
    ,BORRADO                        NUMBER(1)      DEFAULT 0
					)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Tabla creada');

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_' || V_TABLA1 || ' ON ' || V_ESQUEMA || '.' || V_TABLA1 || '
					(MPP_ID) TABLESPACE ' || V_TS_INDEX;
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_' || V_TABLA1 || '.. Creado índice');	

    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.' || V_TABLA1 || ' ADD (
                CONSTRAINT PK_' || V_TABLA1 || ' PRIMARY KEY (MPP_ID),
				CONSTRAINT FK_MPP_DD_APO_ID FOREIGN KEY (DD_APO_ID) REFERENCES ' || V_ESQUEMA || '.DD_APO_APLICATIVO_ORIGEN (DD_APO_ID),
				CONSTRAINT FK_MPP_DD_PCO_LIQ_ID FOREIGN KEY (DD_PCO_LIQ_ID) REFERENCES ' || V_ESQUEMA || '.DD_PCO_LIQ_TIPO (DD_PCO_LIQ_ID),
				CONSTRAINT FK_MPP_DD_PCO_BFT_ID FOREIGN KEY (DD_PCO_BFT_ID) REFERENCES ' || V_ESQUEMA || '.DD_PCO_BFT_TIPO (DD_PCO_BFT_ID)
                )';						
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '.. Creando PK');	

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... OK');	
    
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
