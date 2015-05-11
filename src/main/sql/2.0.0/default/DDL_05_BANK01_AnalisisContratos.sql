--/*
--##########################################
--## Author: Óscar Dorado
--## Adaptado a BP : Gonzalo Estellés 
--## Finalidad: DDL modificar modelo ANALISIS DE CONTRATOS
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
    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    
BEGIN    
     
	-- ******** ANC_ANALISIS_CONTRATOS ********
    VAR_TABLENAME := 'ANC_ANALISIS_CONTRATOS';
    VAR_SEQUENCENAME := 'S_ANC_ANALISIS_CONTRATOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''' || VAR_TABLENAME || ''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || VAR_TABLENAME || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''' || VAR_SEQUENCENAME || ''' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.' || VAR_SEQUENCENAME;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME || '... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Comprobaciones previas FIN'); 

    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME;
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME || '... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.' || VAR_TABLENAME || '
					(
                     ANC_ID                   NUMBER(16)           NOT NULL,
                     CNT_ID                   NUMBER(16)           NOT NULL,
                     ASU_ID                   NUMBER(16),
                     ANC_REVISADO_A           NUMBER(1),
                     ANC_PROPUESTA_EJECUCION  NUMBER(1),
                     ANC_INICIAR_EJECUCION    NUMBER(1),
                     ANC_REVISADO_B           NUMBER(1),
                     ANC_SOLICITAR_SOLVENCIA  NUMBER(1),                    
                     ANC_F_SOLICITAR_SOLVENCIA TIMESTAMP(6),                    
                     ANC_F_RECEPCION          TIMESTAMP(6),            
                     ANC_RESULTADO            NUMBER(1),                    
                     ANC_DECISION_B           NUMBER(1),                    
                     ANC_REVISADO_C           NUMBER(1),                    
                     ANC_DECISION_C           NUMBER(1),                    
                     ANC_F_PROX_REVISION      TIMESTAMP(6),                    
                     ANC_DECISION_REV         NUMBER(1),
                     VERSION                  INTEGER             DEFAULT 0   NOT NULL,
                     USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
                     FECHACREAR               TIMESTAMP(6)        NOT NULL,
                     USUARIOMODIFICAR         VARCHAR2(10 CHAR),
                     FECHAMODIFICAR           TIMESTAMP(6),
                     USUARIOBORRAR            VARCHAR2(10 CHAR),
                     FECHABORRAR              TIMESTAMP(6),
                     BORRADO                  NUMBER(1)           DEFAULT 0   NOT NULL
					)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_ANC_ANALISIS_CONTRATOS ON ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' (ANC_ID)';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Indice creado');
     V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' ADD (
		  CONSTRAINT PK_ANC_ANALISIS_CONTRATOS PRIMARY KEY (ANC_ID),
          CONSTRAINT FK_ANC_ASU FOREIGN KEY (ASU_ID) REFERENCES ' || V_ESQUEMA || '.ASU_ASUNTOS (ASU_ID),
          CONSTRAINT FK_ANC_CNT FOREIGN KEY (CNT_ID) REFERENCES ' || V_ESQUEMA || '.CNT_CONTRATOS (CNT_ID))';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... PK y FK Creada');         
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... OK');
    

    
	-- ******** BIE_ANC_ANALISIS_CONTRATOS ********
    VAR_TABLENAME := 'BIE_ANC_ANALISIS_CONTRATOS';
    VAR_SEQUENCENAME := 'S_BIE_ANC_ANALISIS_CONTRATOS';
    DBMS_OUTPUT.PUT_LINE('******** ' || VAR_TABLENAME || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Comprobaciones previas'); 
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''' || VAR_TABLENAME || ''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || VAR_TABLENAME || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.' || VAR_TABLENAME || ' CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''' || VAR_SEQUENCENAME || ''' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.' || VAR_SEQUENCENAME;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME || '... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Comprobaciones previas FIN'); 

    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME;
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_SEQUENCENAME || '... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.' || VAR_TABLENAME || '
					(
                     BIE_ANC_ID               NUMBER(16)           NOT NULL,
                     BIE_ID                   NUMBER(16)           NOT NULL,
                     ANC_ID                   NUMBER(16)           NOT NULL,
                     BIE_ANC_SOLICITAR_NO_AFE          NUMBER(1),
                     BIE_ANC_F_SOLICITAR_NO_AFE           TIMESTAMP(6),
                     BIE_ANC_RESOLUCION       NUMBER(1),
                     BIE_ANC_F_RESOLUCION     TIMESTAMP(6),
                     VERSION                  INTEGER             DEFAULT 0 NOT NULL,
                     USUARIOCREAR             VARCHAR2(10 CHAR)   NOT NULL,
                     FECHACREAR               TIMESTAMP(6)        NOT NULL,
                     USUARIOMODIFICAR         VARCHAR2(10 CHAR),
                     FECHAMODIFICAR           TIMESTAMP(6),
                     USUARIOBORRAR            VARCHAR2(10 CHAR),
                     FECHABORRAR              TIMESTAMP(6),
                     BORRADO                  NUMBER(1)           DEFAULT 0 NOT NULL
					)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_BIE_ANC_ANALISIS_CONTRATOS ON ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' (BIE_ANC_ID)';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Indice creado');
     V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' ADD (
		  CONSTRAINT PK_BIE_ANC_ANALISIS_CONTRATOS PRIMARY KEY (BIE_ANC_ID),
          CONSTRAINT FK_BIE_ANC_BIE FOREIGN KEY (BIE_ID) REFERENCES ' || V_ESQUEMA || '.BIE_BIEN (BIE_ID),
          CONSTRAINT FK_BIE_ANC_ANC FOREIGN KEY (ANC_ID) REFERENCES ' || V_ESQUEMA || '.ANC_ANALISIS_CONTRATOS (ANC_ID))';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... PK y FK Creada');         
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... OK');
    
  
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