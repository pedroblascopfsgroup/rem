--/*
--##########################################
--## Author: Carlos Perez
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DDL modificar modelos de subastas
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
		-- ******** DD_ESU_ESTADO_SUBASTA *******
    DBMS_OUTPUT.PUT_LINE('******** DD_ESU_ESTADO_SUBASTA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_ESU_ESTADO_SUBASTA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA... Claves primarias eliminadas');	
    END IF;
		-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_ESU_ESTADO_SUBASTA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_ESU_ESTADO_SUBASTA... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_ESU_ESTADO_SUBASTA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_ESU_ESTADO_SUBASTA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA... Comprobaciones previas FIN'); 
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_ESU_ESTADO_SUBASTA';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_ESU_ESTADO_SUBASTA... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA
					(
					  DD_ESU_ID                 NUMBER(16)          NOT NULL,
					  DD_ESU_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
					  DD_ESU_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
					  DD_ESU_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_ESU_ESTADO_SUBASTA ON ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA
					(DD_ESU_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA... Indice creado');
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA ADD (
		  CONSTRAINT PK_DD_ESU_ESTADO_SUBASTA
		 PRIMARY KEY
		 (DD_ESU_ID))';
		EXECUTE IMMEDIATE V_MSQL;              
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA... PK creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ESU_ESTADO_SUBASTA... OK');
    -- ******** DD_MCS_MOT_CANCEL_SUBASTA ********
    DBMS_OUTPUT.PUT_LINE('******** DD_MCS_MOT_CANCEL_SUBASTA ********'); 
		-- Comprobamos si existe la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA... Comprobaciones previas');  
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_MCS_MOT_CANCEL_SUBASTA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA... Claves primarias eliminadas');	
    END IF;
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_MCS_MOT_CANCEL_SUBASTA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    if V_NUM_TABLAS = 1 then
      V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA CASCADE CONSTRAINTS';
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_MCS_MOT_CANCEL_SUBASTA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 then			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_MCS_MOT_CANCEL_SUBASTA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_MCS_MOT_CANCEL_SUBASTA... Secuencia eliminada');    
		end if;  
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA...');
		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_MCS_MOT_CANCEL_SUBASTA';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_MCS_MOT_CANCEL_SUBASTA... Creando secuencia');
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA
					(
					  DD_MCS_ID                 NUMBER(16)          NOT NULL,
					  DD_MCS_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
					  DD_MCS_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
					  DD_MCS_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA... Creando tabla');
    V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_DD_MCS_MOT_CANCEL_SUBASTA ON '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA
					(DD_MCS_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA... Creando indices');
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_MCS_MOT_CANCEL_SUBASTA ADD (
					 CONSTRAINT PK_DD_MCS_MOT_CANCEL_SUBASTA
					 PRIMARY KEY
					 (DD_MCS_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA... Creando PK');	
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MCS_MOT_CANCEL_SUBASTA... OK');
    
    -- ******** DD_MSS_MOT_SUSP_SUBASTA ********
    DBMS_OUTPUT.PUT_LINE('******** DD_MSS_MOT_SUSP_SUBASTA ********');
		-- Comprobamos si existe la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Comprobaciones previas');
     --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_MSS_MOT_SUSP_SUBASTA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK la borramos
    IF V_NUM_TABLAS = 1 THEN
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_MSS_MOT_SUSP_SUBASTA
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Claves primarias eliminadas');		
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_MSS_MOT_SUSP_SUBASTA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 then
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_MSS_MOT_SUSP_SUBASTA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Tabla borrada');  
    END IF; 
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_MSS_MOT_SUSP_SUBASTA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 then			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_MSS_MOT_SUSP_SUBASTA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_MSS_MOT_SUSP_SUBASTA... Secuencia eliminada');    
		END IF; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Fin comprobaciones previas');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA...');
		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_MSS_MOT_SUSP_SUBASTA';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_MSS_MOT_SUSP_SUBASTA... Creando secuencia');
    V_MSQL := 'CREATE TABLE BANK01.DD_MSS_MOT_SUSP_SUBASTA
					(
					  DD_MSS_ID                 NUMBER(16)          NOT NULL,
					  DD_MSS_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
					  DD_MSS_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
					  DD_MSS_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX BANK01.PK_DD_MSS_MOT_SUSP_SUBASTA ON BANK01.DD_MSS_MOT_SUSP_SUBASTA
					(DD_MSS_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Indice creado');
    V_MSQL := 'ALTER TABLE BANK01.DD_MSS_MOT_SUSP_SUBASTA ADD (
               CONSTRAINT PK_DD_MSS_MOT_SUSP_SUBASTA
               PRIMARY KEY
               (DD_MSS_ID))';						
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... Creando PK');	
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_MSS_MOT_SUSP_SUBASTA... OK');	
    
    -- ******** DD_REC_RESULTADO_COMITE ********
    DBMS_OUTPUT.PUT_LINE('******** DD_REC_RESULTADO_COMITE ********'); 
		-- Comprobamos si existe la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Comprobaciones previas');  
     --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_REC_RESULTADO_COMITE'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK la borramos
    IF V_NUM_TABLAS = 1 THEN
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_REC_RESULTADO_COMITE
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Claves primarias eliminadas');		
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_REC_RESULTADO_COMITE'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_REC_RESULTADO_COMITE CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Tabla borrada');  
    END IF; 
		-- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_REC_RESULTADO_COMITE'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 then			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_REC_RESULTADO_COMITE';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_REC_RESULTADO_COMITE... Secuencia eliminada');    
		end if; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Comprobaciones previas terminadas');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE...');
		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_REC_RESULTADO_COMITE';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_REC_RESULTADO_COMITE... Creando secuencia');
    V_MSQL := 'CREATE TABLE BANK01.DD_REC_RESULTADO_COMITE
					(
					  DD_REC_ID                 NUMBER(16)          NOT NULL,
					  DD_REC_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
					  DD_REC_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
					  DD_REC_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX BANK01.PK_DD_REC_RESULTADO_COMITE ON BANK01.DD_REC_RESULTADO_COMITE
					(DD_REC_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Indice creado');
    V_MSQL := 'ALTER TABLE BANK01.DD_REC_RESULTADO_COMITE ADD (
				  CONSTRAINT PK_DD_REC_RESULTADO_COMITE
				 PRIMARY KEY
				 (DD_REC_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... Creando PK');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_REC_RESULTADO_COMITE... OK');
    
    
    -- ******** DD_TSU_TIPO_SUBASTA ********
    DBMS_OUTPUT.PUT_LINE('******** DD_TSU_TIPO_SUBASTA ********');
		-- Comprobamos si existe la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Comprobaciones previas'); 
     --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TSU_TIPO_SUBASTA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK la borramos
    IF V_NUM_TABLAS = 1 THEN
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TSU_TIPO_SUBASTA
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Claves primarias eliminadas');		
    END IF;
    -- Si exuste la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TSU_TIPO_SUBASTA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN
      V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_TSU_TIPO_SUBASTA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Tabla borrada');  
    END IF; 
		-- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_TSU_TIPO_SUBASTA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 then			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_TSU_TIPO_SUBASTA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_TSU_TIPO_SUBASTA... Secuencia eliminada');    
		end if; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Comprobaciones previas fin');  
    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA...');
		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_TSU_TIPO_SUBASTA';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_TSU_TIPO_SUBASTA... Secuencia creada');
		V_MSQL := 'CREATE TABLE BANK01.DD_TSU_TIPO_SUBASTA
					(
					  DD_TSU_ID                 NUMBER(16)          NOT NULL,
					  DD_TSU_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
					  DD_TSU_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
					  DD_TSU_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
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
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX BANK01.PK_DD_TSU_TIPO_SUBASTA ON BANK01.DD_TSU_TIPO_SUBASTA
					(DD_TSU_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Creando indices');
		V_MSQL := 'ALTER TABLE BANK01.DD_TSU_TIPO_SUBASTA ADD (
					 CONSTRAINT PK_DD_TSU_TIPO_SUBASTA
					 PRIMARY KEY
					 (DD_TSU_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... Creando PK');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TSU_TIPO_SUBASTA... OK');
    
    
    -- ******** SUB_SUBASTA ********
    DBMS_OUTPUT.PUT_LINE('******** SUB_SUBASTA ********');
    -- Comprobamos si existen PK 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... Comprobaciones previas');
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''SUB_SUBASTA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 then
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.SUB_SUBASTA
						DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... Claves primarias eliminadas');
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''SUB_SUBASTA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    if V_NUM_TABLAS = 1 then
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.SUB_SUBASTA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... Tabla eliminada');      		            
    END IF; 
		-- Comporbamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_SUB_SUBASTA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_SUB_SUBASTA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_SUB_SUBASTA... Secuencia eliminada');    
		END IF; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... Comprobaciones previas fin');  
    -- Instrucciones para crear la tabla 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA...'); 
		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_SUB_SUBASTA';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_SUB_SUBASTA... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.SUB_SUBASTA
					(
					 SUB_ID                   NUMBER(16)           NOT NULL,
					 ASU_ID                   NUMBER(16)           NOT NULL,
					 PRC_ID                   NUMBER(16)           NOT NULL,
					 SUB_NUM_AUTOS            VARCHAR2(10 CHAR),
					 DD_TSU_ID                NUMBER(16)           DEFAULT 1                     NOT NULL,
					 SUB_FECHA_SOLICITUD      TIMESTAMP(6),
					 SUB_FECHA_ANUNCIO        TIMESTAMP(6),
					 SUB_FECHA_SENYALAMIENTO  TIMESTAMP(6),
					 DD_ESU_ID                NUMBER(16)           DEFAULT 4                     NOT NULL,
					 DD_REC_ID                NUMBER(16),
					 DD_MSS_ID                NUMBER(16),
					 DD_MCS_ID                NUMBER(16),
					 SUB_TASACION             NUMBER(1)            DEFAULT 0                     NOT NULL,
					 SUB_INFO_LETRADO         NUMBER(1)            DEFAULT 0                     NOT NULL,
					 SUB_INSTRUCCIONES        NUMBER(1)            DEFAULT 0                     NOT NULL,
					 SUB_SUBASTA_REVISADA     NUMBER(1)            DEFAULT 0                     NOT NULL,
					 VERSION                  INTEGER              DEFAULT 0                     NOT NULL,
					 USUARIOCREAR             VARCHAR2(10 CHAR)    NOT NULL,
					 FECHACREAR               TIMESTAMP(6)         NOT NULL,
					 USUARIOMODIFICAR         VARCHAR2(10 CHAR),
					 FECHAMODIFICAR           TIMESTAMP(6),
					 USUARIOBORRAR            VARCHAR2(10 CHAR),
					 FECHABORRAR              TIMESTAMP(6),
					 BORRADO                  NUMBER(1)            DEFAULT 0                     NOT NULL,
					 SUB_COSTAS_LETRADO       NUMBER(16,2)
		)';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_SUB_SUBASTA ON ' || V_ESQUEMA || '.SUB_SUBASTA
					(SUB_ID)';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... Indice creado');
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.SUB_SUBASTA ADD (
					 CONSTRAINT PK_SUB_SUBASTA
					 PRIMARY KEY
					 (SUB_ID))';
		EXECUTE IMMEDIATE V_MSQL;             
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... PK Creada');
		 V_MSQL := 'ALTER TABLE SUB_SUBASTA ADD (
			  CONSTRAINT FK_SUBASTA_ASUNTO 
			 FOREIGN KEY (ASU_ID) 
			 REFERENCES ASU_ASUNTOS (ASU_ID),
			  CONSTRAINT FK_SUBASTA_PRC 
			 FOREIGN KEY (PRC_ID) 
			 REFERENCES PRC_PROCEDIMIENTOS (PRC_ID),
			  CONSTRAINT FK_SUBASTA_TSU 
			 FOREIGN KEY (DD_TSU_ID) 
			 REFERENCES DD_TSU_TIPO_SUBASTA (DD_TSU_ID),
			  CONSTRAINT FK_SUBASTA_ESU 
			 FOREIGN KEY (DD_ESU_ID) 
			 REFERENCES DD_ESU_ESTADO_SUBASTA (DD_ESU_ID),
			  CONSTRAINT FK_SUBASTA_RES 
			 FOREIGN KEY (DD_REC_ID) 
			 REFERENCES DD_REC_RESULTADO_COMITE (DD_REC_ID),
			  CONSTRAINT FK_SUBASTA_MSS 
			 FOREIGN KEY (DD_MSS_ID) 
			 REFERENCES DD_MSS_MOT_SUSP_SUBASTA (DD_MSS_ID),
			  CONSTRAINT FK_SUBASTA_MSC 
			 FOREIGN KEY (DD_MCS_ID) 
			 REFERENCES DD_MCS_MOT_CANCEL_SUBASTA (DD_MCS_ID))';
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... FK Creada');		 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... OK');
    
    
    -- ******** LOS_LOTE_SUBASTA ********
    DBMS_OUTPUT.PUT_LINE('******** LOS_LOTE_SUBASTA ********');
    -- Comprobamos si existe la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... Comprobaciones previas');  
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''LOS_LOTE_SUBASTA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN  
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... Claves primarias eliminadas');
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''LOS_LOTE_SUBASTA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... Tabla eliminada');
    END IF; 
		-- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_LOS_LOTE_SUBASTA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_LOS_LOTE_SUBASTA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_LOS_LOTE_SUBASTA... Secuencia eliminada');    
		END IF;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... Comprobaciones previas fin');
    
    -- Instrucciones para crear la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA...');
    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_LOS_LOTE_SUBASTA';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_LOS_LOTE_SUBASTA... Secuencia creada');
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA
					(
					  LOS_ID            NUMBER(16),
					  SUB_ID            NUMBER(16)                  NOT NULL,
					  LOS_PUJA_SIN_POSTORES    NUMBER(16,2),
					  LOS_PUJA_POSTORES_DESDE  NUMBER(16,2),
					  LOS_PUJA_POSTORES_HASTA  NUMBER(16,2),
					  LOS_VALOR_SUBASTA        NUMBER(16,2),
					  LOS_50_DEL_TIPO_SUBASTA  NUMBER(16,2),
					  LOS_60_DEL_TIPO_SUBASTA  NUMBER(16,2),
					  LOS_70_DEL_TIPO_SUBASTA  NUMBER(16,2),
					  LOS_OBSERVACIONES        VARCHAR2(2000 CHAR),
					  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
					  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
					  FECHACREAR        TIMESTAMP(6)                DEFAULT sysdate               NOT NULL,
					  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
					  FECHAMODIFICAR    TIMESTAMP(6),
					  USUARIOBORRAR     VARCHAR2(10 CHAR),
					  FECHABORRAR       TIMESTAMP(6),
					  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
					)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_LOS_LOTE_SUBASTA ON '||V_ESQUEMA||'.LOS_LOTE_SUBASTA
                  (LOS_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... Indice creado');
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOS_LOTE_SUBASTA ADD (
					 CONSTRAINT PK_LOS_LOTE_SUBASTA
					 PRIMARY KEY
					 (LOS_ID))';
		EXECUTE IMMEDIATE V_MSQL;   
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... PK (1) Creada');
		V_MSQL := 'ALTER TABLE LOS_LOTE_SUBASTA ADD CONSTRAINT FK_LOS_LOTE_SUBASTA
      				  FOREIGN KEY (SUB_ID) REFERENCES SUB_SUBASTA (SUB_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... FK (2) Creada');
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOS_LOTE_SUBASTA... OK'); 
    
    -- ******** LOB_LOTE_BIEN ********
    DBMS_OUTPUT.PUT_LINE('-- ******** LOB_LOTE_BIEN ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... Comprobaciones previas'); 
    -- Comprobamos si existe PK
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''LOB_LOTE_BIEN'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    if V_NUM_TABLAS = 1 then
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOB_LOTE_BIEN
        			DROP PRIMARY KEY CASCADE';
      EXECUTE IMMEDIATE V_MSQL; 
			DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.LOB_LOTE_BIEN... Claves primarias eliminadas');
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''LOB_LOTE_BIEN'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    if V_NUM_TABLAS = 1 then
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.LOB_LOTE_BIEN CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... Tabla eliminada');  
    end if;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_LOB_LOTE_BIEN'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 then			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_LOB_LOTE_BIEN';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_LOB_LOTE_BIEN... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... Comprobaciones previas fin');
    -- Creando la tabla
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN...');
    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_LOB_LOTE_BIEN';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_LOB_LOTE_BIEN... Secuencia creada');		
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.LOB_LOTE_BIEN
					(
						LOS_ID  NUMBER(16),
						BIE_ID  NUMBER(16),
						VERSION           INTEGER                     DEFAULT 0                     NOT NULL
					)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... Tabla creada');	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_LOB_LOTE_BIEN ON '||V_ESQUEMA||'.LOB_LOTE_BIEN
					(LOS_ID, BIE_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... Creado indices');	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.LOB_LOTE_BIEN ADD (
					  CONSTRAINT PK_LOB_LOTE_BIEN
					 PRIMARY KEY
					 (LOS_ID, BIE_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... PK Creada');	
		V_MSQL := 'ALTER TABLE LOB_LOTE_BIEN ADD CONSTRAINT LOB_LOS_FK
					FOREIGN KEY (LOS_ID) REFERENCES LOS_LOTE_SUBASTA (LOS_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... FK (1) Creada');
		V_MSQL := 'ALTER TABLE LOB_LOTE_BIEN ADD CONSTRAINT LOB_BIE_FK
					FOREIGN KEY (BIE_ID) REFERENCES BIE_BIEN (BIE_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... FK (2) Creada');		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LOB_LOTE_BIEN... OK'); 
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