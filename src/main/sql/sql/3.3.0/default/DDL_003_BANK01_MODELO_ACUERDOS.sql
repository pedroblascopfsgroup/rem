--/*
--##########################################
--## Author: Oscar Dorado
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DDL modificar modelos de acuerdos
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
    -- ******** ACU_ACUERDO_PROCEDIMIENTOS - Añadir campos *******
    DBMS_OUTPUT.PUT_LINE('******** ACU_ACUERDO_PROCEDIMIENTOS - Añadir campos *******');
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ACU_ACUERDO_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||''' and column_name = ''ACU_FECHA_LIMITE''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_ACUERDO_PROCEDIMIENTOS... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'alter table '||V_ESQUEMA||'.ACU_ACUERDO_PROCEDIMIENTOS add(ACU_FECHA_LIMITE DATE)';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACU_ACUERDO_PROCEDIMIENTOS... Añadido el campo ACU_FECHA_LIMITE');
    END IF;

    -- ******** TEA_TERMINOS_ACUERDO   ********
    DBMS_OUTPUT.PUT_LINE('******** TEA_TERMINOS_ACUERDO   ********');
    -- Comprobamos si existen PK 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Comprobaciones previas');
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''TEA_TERMINOS_ACUERDO'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 then
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO
						DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Claves primarias eliminadas');
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TEA_TERMINOS_ACUERDO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    if V_NUM_TABLAS = 1 then
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Tabla eliminada');      		            
    END IF; 
		-- Comporbamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_TEA_TERMINOS_ACUERDO'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_TEA_TERMINOS_ACUERDO';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TEA_TERMINOS_ACUERDO... Secuencia eliminada');    
		END IF; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Comprobaciones previas fin');  
    -- Instrucciones para crear la tabla 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO...'); 
		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_TEA_TERMINOS_ACUERDO';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TEA_TERMINOS_ACUERDO... Secuencia creada');
		V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO
                (
                  TEA_ID              NUMBER(16),
				  ACU_ID              NUMBER(16)                  NOT NULL,
				  DD_TPA_ID           NUMBER(16)                  NOT NULL,
				  DD_TPR_ID           NUMBER(16)                  NOT NULL,
				  TEA_MODO_DESEMBOLSO VARCHAR2(100),
				  TEA_FORMALIZACION   VARCHAR2(100),
				  TEA_IMPORTE         NUMBER(16,2),
				  TEA_COMISIONES      NUMBER(16,2),
				  TEA_PERIODICIDAD    VARCHAR2(50),
				  TEA_PERIODO_FIJO   VARCHAR2(50),
				  TEA_SISTEMA_AMORTIZACION VARCHAR2(50),
				  TEA_INTERES         NUMBER(7,2),
				  TEA_PERIODO_VARIABLE VARCHAR2(50),
				  TEA_INFORME_LETRADO  VARCHAR2(2000),
				  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
				  USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
				  FECHACREAR                TIMESTAMP(6)        NOT NULL,
				  USUARIOMODIFICAR          VARCHAR2(10 CHAR),
				  FECHAMODIFICAR            TIMESTAMP(6),
				  USUARIOBORRAR             VARCHAR2(10 CHAR),
				  FECHABORRAR               TIMESTAMP(6),
				  BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
				)';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_TEA_TERMINOS_ACUERDO ON ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO
					(TEA_ID)';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Indice creado');
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO ADD (
					 CONSTRAINT PK_TEA_TERMINOS_ACUERDO
					 PRIMARY KEY
					 (TEA_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... creando FKs');
		V_MSQL := 'ALTER TABLE tea_terminos_acuerdo ADD (
					  CONSTRAINT FK_TERMINOS_TPA 
					 FOREIGN KEY (DD_TPA_ID) 
					 REFERENCES DD_TPA_TIPO_ACUERDO (DD_TPA_ID),
					  CONSTRAINT FK_TERMINOS_TPR 
					 FOREIGN KEY (DD_TPR_ID) 
					 REFERENCES DD_TPR_TIPO_PROD (DD_TPR_ID),
					  CONSTRAINT FK_TERMINOS_ACUERDO
					 FOREIGN KEY (ACU_ID) 
					 REFERENCES ACU_ACUERDO_PROCEDIMIENTOS (ACU_ID))';
		EXECUTE IMMEDIATE V_MSQL;		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... FKs Creadas');

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.SUB_SUBASTA... OK');
    
    
    -- ******** TEA_CNT  ********
    DBMS_OUTPUT.PUT_LINE('******** TEA_CNT ********');
    -- Comprobamos si existe la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... Comprobaciones previas');  
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''TEA_CNT'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN  
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TEA_CNT
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... Claves primarias eliminadas');
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TEA_CNT'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TEA_CNT CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... Tabla eliminada');         
    END IF; 
		-- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_TEA_CNT'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		IF V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_TEA_CNT';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TEA_CNT... Secuencia eliminada');    
		END IF;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... Comprobaciones previas fin');
    
    -- Instrucciones para crear la tabla 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT...');
    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_TEA_CNT';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TEA_CNT... Secuencia creada');
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TEA_CNT
					(
            TEA_CNT_ID  NUMBER(16),
            TEA_ID      NUMBER(16)                        NOT NULL,
            CNT_ID      NUMBER(16)                        NOT NULL,
            VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
            USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
            FECHACREAR                TIMESTAMP(6)        NOT NULL,
            USUARIOMODIFICAR          VARCHAR2(10 CHAR),
            FECHAMODIFICAR            TIMESTAMP(6),
            USUARIOBORRAR             VARCHAR2(10 CHAR),
            FECHABORRAR               TIMESTAMP(6),
            BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
          )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... Tabla creada');
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_TEA_CNT ON '||V_ESQUEMA||'.TEA_CNT
                  (TEA_CNT_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... Indice creado');
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TEA_CNT ADD (
					 CONSTRAINT PK_TEA_CNT
					 PRIMARY KEY
					 (TEA_CNT_ID))';					 
		EXECUTE IMMEDIATE V_MSQL;   
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... PK Creada');

		V_MSQL := 'ALTER TABLE tea_cnt ADD (
					  CONSTRAINT FK_TERMINOS_ACUERDOS 
					 FOREIGN KEY (TEA_ID) 
					 REFERENCES TEA_TERMINOS_ACUERDO (TEA_ID),
					  CONSTRAINT FK_TERMINOS_CONTRATO 
					 FOREIGN KEY (CNT_ID) 
					 REFERENCES CNT_CONTRATOS (CNT_ID))';					 
		EXECUTE IMMEDIATE V_MSQL;   
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... FKs Creadas');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TEA_CNT... OK'); 
    
    -- ******** BIE_TEA ********
    DBMS_OUTPUT.PUT_LINE('-- ******** BIE_TEA ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... Comprobaciones previas'); 
    -- Comprobamos si existe PK
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''BIE_TEA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    if V_NUM_TABLAS = 1 then
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_TEA
        			DROP PRIMARY KEY CASCADE';
      EXECUTE IMMEDIATE V_MSQL; 
			DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.BIE_TEA... Claves primarias eliminadas');
    END IF;
    -- Si existe la tabla la borramos
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BIE_TEA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    if V_NUM_TABLAS = 1 then
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.BIE_TEA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... Tabla eliminada');  
    end if;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_BIE_TEA'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 then			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_BIE_TEA';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_TEA... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... Comprobaciones previas fin');
    -- Creando la tabla
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA...');
    V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_BIE_TEA';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_TEA... Secuencia creada');		
		V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.BIE_TEA
                (
                  BIE_TEA_ID        NUMBER(16)                  NOT NULL,
                  TEA_ID            NUMBER(16)                  NOT NULL,
                  BIE_ID            NUMBER(16)                  NOT NULL,
                  VERSION           INTEGER                     DEFAULT 0                     NOT NULL,
                  USUARIOCREAR      VARCHAR2(10 CHAR)           NOT NULL,
                  FECHACREAR        TIMESTAMP(6)                NOT NULL,
                  USUARIOMODIFICAR  VARCHAR2(10 CHAR),
                  FECHAMODIFICAR    TIMESTAMP(6),
                  USUARIOBORRAR     VARCHAR2(10 CHAR),
                  FECHABORRAR       TIMESTAMP(6),
                  BORRADO           NUMBER(1)                   DEFAULT 0                     NOT NULL
                )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... Tabla creada');	
		V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_BIE_TEA ON '||V_ESQUEMA||'.BIE_TEA
					(BIE_TEA_ID)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... Creado indice');	
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_TEA ADD (
					  CONSTRAINT PK_BIE_TEA
					 PRIMARY KEY
					 (BIE_TEA_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... PK Creada');	
		V_MSQL := 'ALTER TABLE BIE_TEA ADD (
                  CONSTRAINT FK_BIE_TEA_TEA
                  FOREIGN KEY (TEA_ID) REFERENCES TEA_TERMINOS_ACUERDO (TEA_ID),
                  CONSTRAINT FK_BIE_TEA_BIE
                  FOREIGN KEY (BIE_ID) REFERENCES BIE_BIEN (BIE_ID))';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... FK Creada');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_TEA... OK'); 
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