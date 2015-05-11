--/*
--##########################################
--## Author: Recovery
--## Adaptado a BP : Teresa Alonso
--## Finalidad: DDL creacion DD_TPC_TIPO_CARGA
--##                         DD_SIC_SITUACION_CARGA
--##                         BIE_CAR_CARGAS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    -- Sentencia a ejecutar 
    V_MSQL VARCHAR2(32000 CHAR);  

    -- Configuracion Esquemas
    V_ESQUEMA        VARCHAR2(25 CHAR):= 'BANK01'; 
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'BANKMASTER'; 	

    -- Vble. para consulta que valida la existencia de una tabla.
    V_SQL VARCHAR2(4000 CHAR); 

    -- Vble. para validar la existencia de una tabla.   
    V_NUM_TABLAS NUMBER(16); 
    V_NUM_COLUMS NUMBER(16); 

    -- Vble. auxiliar para registrar errores en el script.
    ERR_NUM NUMBER(25);  

    -- Vble. auxiliar para registrar mensajes de errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); 


BEGIN	
    
    -- ******** DD_TPC_TIPO_CARGA *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla DD_TPC_TIPO_CARGA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TPC_TIPO_CARGA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA 
                  DROP PRIMARY KEY CASCADE';		
		  EXECUTE IMMEDIATE V_MSQL;  
		  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA... Claves primarias eliminadas');	
                       
    END IF;


    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TPC_TIPO_CARGA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA... Tabla borrada');  

    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPC_TIPO_CARGA... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Creamos la tabla 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_TPC_TIPO_CARGA
				      (
					DD_TPC_ID                 	NUMBER(16)          		NOT NULL,
  					DD_TPC_CODIGO             	VARCHAR2(10 CHAR)   		NOT NULL,
  					DD_TPC_DESCRIPCION        	VARCHAR2(50 CHAR)   		NOT NULL,
  					DD_TPC_DESCRIPCION_LARGA  	VARCHAR2(200 CHAR)  		NOT NULL,
  					VERSION                   	INTEGER		DEFAULT 0 	NOT NULL,
  					USUARIOCREAR              	VARCHAR2(10 CHAR)   		NOT NULL,
  					FECHACREAR                	TIMESTAMP(6)        		NOT NULL,
  					USUARIOMODIFICAR          	VARCHAR2(10 CHAR),
  					FECHAMODIFICAR            	TIMESTAMP(6),
  					USUARIOBORRAR             	VARCHAR2(10 CHAR),
  					FECHABORRAR               	TIMESTAMP(6),
  					BORRADO                   	NUMBER(1) 	DEFAULT 0 	NOT NULL
				      )
					TABLESPACE '|| V_ESQUEMA ||'
					PCTUSED    0
					PCTFREE    10
					INITRANS   1
					MAXTRANS   255
					STORAGE    (
					            INITIAL          64K
					            NEXT             1M
					            MINEXTENTS       1
					            MAXEXTENTS       UNLIMITED
					            PCTINCREASE      0
					            BUFFER_POOL      DEFAULT
					           )
					LOGGING 
					NOCOMPRESS 
					NOCACHE
					NOPARALLEL
					MONITORING';		

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPC_TIPO_CARGA... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TPC_TIPO_CARGA... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_TPC_TIPO_CARGA ON ' || V_ESQUEMA || '.DD_TPC_TIPO_CARGA
				(DD_TPC_ID)
				LOGGING
				TABLESPACE '|| V_ESQUEMA ||'
				PCTFREE    10
				INITRANS   2
				MAXTRANS   255
				STORAGE 	(
            					INITIAL          64K
            					NEXT             1M
            					MINEXTENTS       1
            					MAXEXTENTS       UNLIMITED
            					PCTINCREASE      0
            					BUFFER_POOL      DEFAULT
           				 	)
				NOPARALLEL';		
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_TPC_TIPO_CARGA... Indice creado');
 
  --Constraint tabla DD_TPC_TIPO_CARGA con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_TPC_TIPO_CARGA ADD (
		 CONSTRAINT PK_DD_TPC_TIPO_CARGA
		 PRIMARY KEY
		 (DD_TPC_ID)
    			USING INDEX 
    			TABLESPACE '|| V_ESQUEMA ||'
   			PCTFREE    10
    			INITRANS   2
    			MAXTRANS   255
    			STORAGE    	(
        				INITIAL          64K
                			NEXT             1M
                			MINEXTENTS       1
                			MAXEXTENTS       UNLIMITED
                			PCTINCREASE      0
               				))';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPC_TIPO_CARGA... CONSTRAINT PRIMARY KEY PK_DD_TPC_TIPO_CARGA');

    DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla DD_TPC_TIPO_CARGA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
 

    
    -- ******** DD_SIC_SITUACION_CARGA *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla DD_SIC_SITUACION_CARGA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_SIC_SITUACION_CARGA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA 
                  DROP PRIMARY KEY CASCADE';		
		  EXECUTE IMMEDIATE V_MSQL;  
		  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA... Claves primarias eliminadas');	
                       
    END IF;


    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_SIC_SITUACION_CARGA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA... Tabla borrada');  

    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

  --Creamos la tabla 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA
				      (
  					DD_SIC_ID                 NUMBER(16)          			NOT NULL,
  					DD_SIC_CODIGO             VARCHAR2(10 CHAR)   			NOT NULL,
  					DD_SIC_DESCRIPCION        VARCHAR2(50 CHAR)   			NOT NULL,
  					DD_SIC_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  			NOT NULL,
  					VERSION                   INTEGER             DEFAULT 0  	NOT NULL,
  					USUARIOCREAR              VARCHAR2(10 CHAR)   			NOT NULL,
  					FECHACREAR                TIMESTAMP(6)        			NOT NULL,
  					USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  					FECHAMODIFICAR            TIMESTAMP(6),
  					USUARIOBORRAR             VARCHAR2(10 CHAR),
  					FECHABORRAR               TIMESTAMP(6),
  					BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL

				      )
					TABLESPACE '|| V_ESQUEMA ||'
					PCTUSED    0
					PCTFREE    10
					INITRANS   1
					MAXTRANS   255
					STORAGE    (
					            INITIAL          64K
					            NEXT             1M
					            MINEXTENTS       1
					            MAXEXTENTS       UNLIMITED
					            PCTINCREASE      0
					            BUFFER_POOL      DEFAULT
					           )
					LOGGING 
					NOCOMPRESS 
					NOCACHE
					NOPARALLEL
					MONITORING';		

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_SIC_SITUACION_CARGA ON ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA
				(DD_SIC_ID)
				LOGGING
				TABLESPACE '|| V_ESQUEMA ||'
				PCTFREE    10
				INITRANS   2
				MAXTRANS   255
				STORAGE 	(
            					INITIAL          64K
            					NEXT             1M
            					MINEXTENTS       1
            					MAXEXTENTS       UNLIMITED
            					PCTINCREASE      0
            					BUFFER_POOL      DEFAULT
           				 	)
				NOPARALLEL';		
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_SIC_SITUACION_CARGA... Indice creado');

   --Constraint tabla DD_SIC_SITUACION_CARGA con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA ADD (
		 CONSTRAINT PK_DD_SIC_SITUACION_CARGA
		 PRIMARY KEY
		 (DD_SIC_ID)
    			USING INDEX 
    			TABLESPACE '|| V_ESQUEMA ||'
   			PCTFREE    10
    			INITRANS   2
    			MAXTRANS   255
    			STORAGE    	(
        				INITIAL          64K
                			NEXT             1M
                			MINEXTENTS       1
                			MAXEXTENTS       UNLIMITED
                			PCTINCREASE      0
               				))';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA... CONSTRAINT PRIMARY KEY PK_DD_SIC_SITUACION_CARGA');

    DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla DD_SIC_SITUACION_CARGA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
 
    -- ******** BIE_CAR_CARGAS *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla BIE_CAR_CARGAS en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_CAR_CARGAS... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    -- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_BIE_CAR_CARGAS'' and sequence_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 

    -- Si existe secuencia la borramos
    if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_BIE_CAR_CARGAS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_CAR_CARGAS... Secuencia eliminada');    
		END IF; 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''BIE_CAR_CARGAS'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_CAR_CARGAS 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_CAR_CARGAS... Claves primarias eliminadas');	
                       
    END IF;

    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BIE_CAR_CARGAS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.BIE_CAR_CARGAS CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_CAR_CARGAS... Tabla borrada');  

    END IF;



    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

   --Creamos la tabla y secuencias
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_CAR_CARGAS... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_BIE_CAR_CARGAS';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_CAR_CARGAS... Secuencia creada');

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.BIE_CAR_CARGAS
				      (
 					BIE_ID                       	NUMBER(16)       		NOT NULL, 
  					BIE_CAR_ID                   	NUMBER(16)       		NOT NULL,
  					DD_TPC_ID                    	NUMBER(16)       		NOT NULL,
  					BIE_CAR_LETRA                	VARCHAR2(50 CHAR), 
  					BIE_CAR_TITULAR              	VARCHAR2(50 CHAR),
  					BIE_CAR_IMPORTE_REGISTRAL    	NUMBER(16),
  					BIE_CAR_IMPORTE_ECONOMICO    	NUMBER(16),
  					BIE_CAR_REGISTRAL            	NUMBER(1),
  					DD_SIC_ID                    	NUMBER(16)       		NOT NULL,
  					BIE_CAR_FECHA_PRESENTACION   	DATE,
  					BIE_CAR_FECHA_INSCRIPCION    	DATE,
  					BIE_CAR_FECHA_CANCELACION    	DATE,
  					BIE_CAR_ECONOMICA            	NUMBER(1),
  					VERSION                      	INTEGER 	DEFAULT 0 	NOT NULL,
  					USUARIOCREAR                 	VARCHAR2(10 CHAR) 		NOT NULL,
  					FECHACREAR                   	TIMESTAMP(6)     		NOT NULL,
  					USUARIOMODIFICAR             	VARCHAR2(10 CHAR),
  					FECHAMODIFICAR               	TIMESTAMP(6),
  					USUARIOBORRAR                	VARCHAR2(10 CHAR),
  					FECHABORRAR                  	TIMESTAMP(6),
  					BORRADO                      	NUMBER(1)   	DEFAULT 0 	NOT NULL

				      )

					TABLESPACE '|| V_ESQUEMA ||'
					PCTUSED    0
					PCTFREE    10
					INITRANS   1
					MAXTRANS   255
					STORAGE    (
					            INITIAL          64K
					            NEXT             1M
					            MINEXTENTS       1
					            MAXEXTENTS       UNLIMITED
					            PCTINCREASE      0
					            BUFFER_POOL      DEFAULT
					           )
					LOGGING 
					NOCOMPRESS 
					NOCACHE
					NOPARALLEL
					MONITORING';	

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_CAR_CARGAS... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_BIE_CAR_CARGAS ON ' || V_ESQUEMA || '.BIE_CAR_CARGAS
					(BIE_CAR_ID)
				LOGGING
				TABLESPACE '|| V_ESQUEMA ||'
				PCTFREE    10
				INITRANS   2
				MAXTRANS   255
				STORAGE 	(
            					INITIAL          64K
            					NEXT             1M
            					MINEXTENTS       1
            					MAXEXTENTS       UNLIMITED
            					PCTINCREASE      0
            					BUFFER_POOL      DEFAULT
           				 	)
				NOPARALLEL';		
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_BIE_CAR_CARGAS... Indice creado');

  --Constraint tabla BIE_CAR_CARGAS con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_CAR_CARGAS ADD (
		 CONSTRAINT PK_BIE_CAR_CARGAS
		 PRIMARY KEY
		 (BIE_CAR_ID)
    			USING INDEX 
    			TABLESPACE '|| V_ESQUEMA ||'
   			PCTFREE    10
    			INITRANS   2
    			MAXTRANS   255
    			STORAGE    	(
        				INITIAL          64K
                			NEXT             1M
                			MINEXTENTS       1
                			MAXEXTENTS       UNLIMITED
                			PCTINCREASE      0
               				))';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... CONSTRAINT PRIMARY KEY PK_BIE_CAR_CARGAS');


    --Constraint tabla BIE_CAR_CARGAS con indices ajenos
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_CAR_CARGAS ADD (
 		CONSTRAINT FK_BIE_CAR 
 		FOREIGN KEY (BIE_ID) 
 		REFERENCES ' || V_ESQUEMA || '.BIE_BIEN (BIE_ID),
 		CONSTRAINT FK_BIE_DD_TPC 
 		FOREIGN KEY (DD_TPC_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_TPC_TIPO_CARGA (DD_TPC_ID),
  		CONSTRAINT FK_BIE_DD_SIC 
 		FOREIGN KEY (DD_SIC_ID) 
		REFERENCES ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA (DD_SIC_ID)
		)';
    
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... CONSTRAINT FOREIGN KEY');

    DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla BIE_CAR_CARGAS en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 


    -- ******** DD_TPC_TIPO_CARGA *******
    DBMS_OUTPUT.PUT_LINE('Añadir columnas a la Tabla BIE_ADICIONAL en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADICIONAL... Añadir columnas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

     -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BIE_ADICIONAL'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la tabla ir verificando si existe cada una de las columnas
    IF V_NUM_TABLAS = 1 THEN 
       	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL... Tabla para incorporar nuevos campos');

        -- Añadir la columna BIE_ADI_FFIN_REV_CARGA
--       	V_SQL := 'SELECT COUNT(1) FROM USER_TAB_COLS WHERE LOWER(table_name) = ''BIE_ADICIONAL'' and LOWER(column_name) = ''BIE_ADI_FFIN_REV_CARGA''';
        V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''BIE_ADI_FFIN_REV_CARGA'' AND TABLE_NAME=''BIE_ADICIONAL'' AND OWNER=''' || V_ESQUEMA || '''';
      	EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMS;
        
  
       	IF  V_NUM_COLUMS = 1 then
          	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL...la Columna BIE_ADI_FFIN_REV_CARGA ya existe, no se añade'); 

       	else  
                V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADICIONAL ADD (BIE_ADI_FFIN_REV_CARGA 	DATE)';
                EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
           	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL... Columna BIE_ADI_FFIN_REV_CARGA Añadida');
        end if;

        -- Añadir la columna BIE_ADI_SIN_CARGA
--       	V_SQL := 'SELECT COUNT(1) FROM USER_TAB_COLS WHERE LOWER(table_name) = ''BIE_ADICIONAL'' and LOWER(column_name) = ''BIE_ADI_SIN_CARGA''';
        V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''BIE_ADI_SIN_CARGA'' AND TABLE_NAME=''BIE_ADICIONAL'' AND OWNER=''' || V_ESQUEMA || '''';
       	EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMS;
  
       	IF  V_NUM_COLUMS = 1 then
          	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL...la Columna BIE_ADI_SIN_CARGA ya existe, no se añade'); 

       	else  
                V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADICIONAL ADD (BIE_ADI_SIN_CARGA NUMBER(1))';
                EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
           	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL... Columna BIE_ADI_SIN_CARGA Añadida');
        end if;

        -- Añadir la columna BIE_ADI_OBS_CARGA
--       	V_SQL := 'SELECT COUNT(1) FROM USER_TAB_COLS WHERE LOWER(table_name) = ''BIE_ADICIONAL'' and LOWER(column_name) = ''BIE_ADI_OBS_CARGA''';
        V_SQL := 'SELECT COUNT(1) FROM SYS.ALL_TAB_COLUMNS WHERE COLUMN_NAME=''BIE_ADI_OBS_CARGA'' AND TABLE_NAME=''BIE_ADICIONAL'' AND OWNER=''' || V_ESQUEMA || '''';
       	EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLUMS;
  
       	IF  V_NUM_COLUMS = 1 then
          	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL...la Columna BIE_ADI_OBS_CARGA ya existe, no se añade'); 

       	else  
                V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADICIONAL ADD (BIE_ADI_OBS_CARGA VARCHAR2(250 CHAR))';
                EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
           	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL... Columna BIE_ADI_OBS_CARGA Añadida');
        end if;


     ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADICIONAL ERROR tabla para incorporar nuevos campos no existe');
     END IF;

   DBMS_OUTPUT.PUT_LINE('FIN Añadir columnas a la Tabla BIE_ADICIONAL en el Esquema: ' || V_ESQUEMA);
   DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

 -- Control de errores
  EXCEPTION  
	WHEN OTHERS THEN
	  
	  err_num := SQLCODE;
	  err_msg := SQLERRM;
	
	  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	  DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	  DBMS_OUTPUT.put_line(err_msg);
	  
	  ROLLBACK;
	  RAISE;
END;
/

EXIT;