--/*
--##########################################
--## Author: Recovery
--## Adaptado a BP : Teresa Alonso
--## Finalidad: DDL creacion DD_RMO_RESOL_MORATORIA
--##                         DD_SIT_SITUACION_TITULO
--##                         DD_EAD_ENTIDAD_ADJUDICA
--##                         BIE_ADJ_ADJUDICACION
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
    
    -- ******** DD_RMO_RESOL_MORATORIA *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla DD_RMO_RESOL_MORATORIA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_RMO_RESOL_MORATORIA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA 
                  DROP PRIMARY KEY CASCADE';		
		  EXECUTE IMMEDIATE V_MSQL;  
		  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA... Claves primarias eliminadas');	
                       
    END IF;


    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_RMO_RESOL_MORATORIA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA... Tabla borrada');  

    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_RMO_RESOL_MORATORIA... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Creamos la tabla 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_RMO_RESOL_MORATORIA
				      (

  					DD_RMO_ID                 NUMBER(16)          			NOT NULL,
  					DD_RMO_CODIGO             VARCHAR2(10 CHAR)   			NOT NULL,
  					DD_RMO_DESCRIPCION        VARCHAR2(50 CHAR)   			NOT NULL,
  					DD_RMO_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  			NOT NULL,
  					VERSION                   INTEGER             DEFAULT 0		NOT NULL,
  					USUARIOCREAR              VARCHAR2(10 CHAR)   			NOT NULL,
  					FECHACREAR                TIMESTAMP(6)        			NOT NULL,
  					USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  					FECHAMODIFICAR            TIMESTAMP(6),
 					USUARIOBORRAR             VARCHAR2(10 CHAR),
  					FECHABORRAR               TIMESTAMP(6),
  					BORRADO                   NUMBER(1)           DEFAULT 0 	NOT NULL
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_RMO_RESOL_MORATORIA... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_RMO_RESOL_MORATORIA... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_RMO_RESOL_MORATORIA ON ' || V_ESQUEMA || '.DD_RMO_RESOL_MORATORIA
				(DD_RMO_ID)
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
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_RMO_RESOL_MORATORIA... Indice creado');
 
  --Constraint tabla DD_RMO_RESOL_MORATORIA con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_RMO_RESOL_MORATORIA ADD (
		 CONSTRAINT PK_DD_RMO_RESOL_MORATORIA
		 PRIMARY KEY
		 (DD_RMO_ID)
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

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_RMO_RESOL_MORATORIA... CONSTRAINT PRIMARY KEY PK_DD_RMO_RESOL_MORATORIA');

    DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla DD_RMO_RESOL_MORATORIA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
 

    
    -- ******** DD_SIT_SITUACION_TITULO *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla DD_SIT_SITUACION_TITULO en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_SIT_SITUACION_TITULO'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO 
                  DROP PRIMARY KEY CASCADE';		
		  EXECUTE IMMEDIATE V_MSQL;  
		  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO... Claves primarias eliminadas');	
                       
    END IF;


    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_SIT_SITUACION_TITULO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO... Tabla borrada');  

    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIT_SITUACION_TITULO... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

  --Creamos la tabla 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_SIT_SITUACION_TITULO
				      (

  					DD_SIT_ID                 NUMBER(16)          			NOT NULL,
  					DD_SIT_CODIGO             VARCHAR2(10 CHAR)   			NOT NULL,
  					DD_SIT_DESCRIPCION        VARCHAR2(50 CHAR)   			NOT NULL,
  					DD_SIT_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  			NOT NULL,
  					VERSION                   INTEGER             DEFAULT 0 	NOT NULL,
  					USUARIOCREAR              VARCHAR2(10 CHAR)   			NOT NULL,
  					FECHACREAR                TIMESTAMP(6)        			NOT NULL,
  					USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  					FECHAMODIFICAR            TIMESTAMP(6),
  					USUARIOBORRAR             VARCHAR2(10 CHAR),
  					FECHABORRAR               TIMESTAMP(6),
					BORRADO                   NUMBER(1)           DEFAULT 0 	NOT NULL
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIT_SITUACION_TITULO... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SIT_SITUACION_TITULO... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_SIT_SITUACION_TITULO ON ' || V_ESQUEMA || '.DD_SIT_SITUACION_TITULO
				(DD_SIT_ID)
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
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_SIT_SITUACION_TITULO... Indice creado');

   --Constraint tabla DD_SIT_SITUACION_TITULO con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_SIT_SITUACION_TITULO ADD (
		 CONSTRAINT PK_DD_SIT_SITUACION_TITULO
		 PRIMARY KEY
		 (DD_SIT_ID)
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIT_SITUACION_TITULO... CONSTRAINT PRIMARY KEY PK_DD_SIT_SITUACION_TITULO');

    DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla DD_SIT_SITUACION_TITULO en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
 


    -- ******** DD_EAD_ENTIDAD_ADJUDICA *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla DD_EAD_ENTIDAD_ADJUDICA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_EAD_ENTIDAD_ADJUDICA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA 
                  DROP PRIMARY KEY CASCADE';		
		  EXECUTE IMMEDIATE V_MSQL;  
		  DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA... Claves primarias eliminadas');	
                       
    END IF;


    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_EAD_ENTIDAD_ADJUDICA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA... Tabla borrada');  

    END IF;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_EAD_ENTIDAD_ADJUDICA... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

  --Creamos la tabla 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_EAD_ENTIDAD_ADJUDICA
				      (
  					DD_EAD_ID                 NUMBER(16)          			NOT NULL,
  					DD_EAD_CODIGO             VARCHAR2(10 CHAR)   			NOT NULL,
  					DD_EAD_DESCRIPCION        VARCHAR2(50 CHAR)   			NOT NULL,
  					DD_EAD_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  			NOT NULL,
  					VERSION                   INTEGER             DEFAULT 0 	NOT NULL,
  					USUARIOCREAR              VARCHAR2(10 CHAR)   			NOT NULL,
  					FECHACREAR                TIMESTAMP(6)        			NOT NULL,
  					USUARIOMODIFICAR          VARCHAR2(10 CHAR),
  					FECHAMODIFICAR            TIMESTAMP(6),
  					USUARIOBORRAR             VARCHAR2(10 CHAR),
  					FECHABORRAR               TIMESTAMP(6),
  					BORRADO                   NUMBER(1)           DEFAULT 0  	NOT NULL

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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_EAD_ENTIDAD_ADJUDICA... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_EAD_ENTIDAD_ADJUDICA... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_EAD_ENTIDAD_ADJUDICA ON ' || V_ESQUEMA || '.DD_EAD_ENTIDAD_ADJUDICA
				(DD_EAD_ID)
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
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_EAD_ENTIDAD_ADJUDICA... Indice creado');

   --Constraint tabla DD_EAD_ENTIDAD_ADJUDICA con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_EAD_ENTIDAD_ADJUDICA ADD (
		 CONSTRAINT PK_DD_EAD_ENTIDAD_ADJUDICA
		 PRIMARY KEY
		 (DD_EAD_ID)
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_EAD_ENTIDAD_ADJUDICA... CONSTRAINT PRIMARY KEY PK_DD_EAD_ENTIDAD_ADJUDICA');

    DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla DD_EAD_ENTIDAD_ADJUDICA en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 


    -- ******** BIE_ADJ_ADJUDICACION *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla BIE_ADJ_ADJUDICACION en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    -- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_BIE_ADJ_ADJUDICACION'' and sequence_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 

    -- Si existe secuencia la borramos
    if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_BIE_ADJ_ADJUDICACION';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_ADJ_ADJUDICACION... Secuencia eliminada');    
		END IF; 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''BIE_ADJ_ADJUDICACION'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Claves primarias eliminadas');	
                       
    END IF;

    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BIE_ADJ_ADJUDICACION'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Tabla borrada');  

    END IF;



    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

   --Creamos la tabla y secuencias
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_BIE_ADJ_ADJUDICACION';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_ADJ_ADJUDICACION... Secuencia creada');

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION
				      (

  					BIE_ID                       	NUMBER(16)       			NOT NULL,
  					BIE_ADJ_ID                   	NUMBER(16)      			NOT NULL, 
  					BIE_ADJ_F_DECRETO_N_FIRME    	DATE,
  					BIE_ADJ_F_DECRETO_FIRME      	DATE,
  					BIE_ADJ_F_ENTREGA_GESTOR     	DATE,
  					BIE_ADJ_F_PRESEN_HACIENDA    	DATE,
  					BIE_ADJ_F_SEGUNDA_PRESEN     	DATE,
  					BIE_ADJ_F_RECPCION_TITULO    	DATE,
  					BIE_ADJ_F_INSCRIP_TITULO     	DATE,
  					BIE_ADJ_F_ENVIO_ADICION      	DATE,
  					BIE_ADJ_F_PRESENT_REGISTRO   	DATE,
  					BIE_ADJ_F_SOL_POSESION       	DATE,
  					BIE_ADJ_F_SEN_POSESION       	DATE,
  					BIE_ADJ_F_REA_POSESION       	DATE,
  					BIE_ADJ_F_SOL_LANZAMIENTO    	DATE,
  					BIE_ADJ_F_SEN_LANZAMIENTO    	DATE,
  					BIE_ADJ_F_REA_LANZAMIENTO    	DATE,
  					BIE_ADJ_F_SOL_MORATORIA      	DATE,
  					BIE_ADJ_F_RES_MORATORIA      	DATE,
  					BIE_ADJ_F_CONTRATO_ARREN     	DATE,
  					BIE_ADJ_F_CAMBIO_CERRADURA   	DATE,
  					BIE_ADJ_F_ENVIO_LLAVES       	DATE,
  					BIE_ADJ_F_RECEP_DEPOSITARIO  	DATE,
  					BIE_ADJ_F_ENVIO_DEPOSITARIO  	DATE,
  					BIE_ADJ_OCUPADO              	NUMBER(1),
  					BIE_ADJ_POSIBLE_POSESION     	NUMBER(1),
  					BIE_ADJ_OCUPANTES_DILIGENCIA 	NUMBER(1),
  					BIE_ADJ_LANZAMIENTO_NECES    	NUMBER(1),
  					BIE_ADJ_ENTREGA_VOLUNTARIA   	NUMBER(1),
  					BIE_ADJ_NECESARIA_FUERA_PUB  	NUMBER(1),
  					BIE_ADJ_EXISTE_INQUILINO     	NUMBER(1),
  					BIE_ADJ_LLAVES_NECESARIAS    	NUMBER(1),
  					BIE_ADJ_GESTORIA_ADJUDIC     	NUMBER(16),
  					BIE_ADJ_NOMBRE_ARRENDATARIO  	VARCHAR2(50 CHAR),
  					BIE_ADJ_NOMBRE_DEPOSITARIO   	VARCHAR2(50 CHAR),
  					BIE_ADJ_NOMBRE_DEPOSITARIO_F 	VARCHAR2(50 CHAR),
  					BIE_ADJ_FONDO                	VARCHAR2(50 CHAR),
  					DD_EAD_ID                    	NUMBER(16),
  					DD_SIT_ID                    	NUMBER(16),
  					DD_RMO_ID                    	NUMBER(16),
  					VERSION                      	INTEGER          DEFAULT 0          	NOT NULL,
  					USUARIOCREAR                 	VARCHAR2(10 CHAR) 			NOT NULL,
  					FECHACREAR                   	TIMESTAMP(6)     			NOT NULL,
  					USUARIOMODIFICAR             	VARCHAR2(10 CHAR),
  					FECHAMODIFICAR               	TIMESTAMP(6),
  					USUARIOBORRAR                	VARCHAR2(10 CHAR),
  					FECHABORRAR                  	TIMESTAMP(6),
  					BORRADO                      	NUMBER(1)        DEFAULT 0  		NOT NULL,
					BIE_ADJ_F_RECEP_DEPOSITARIO_F 	DATE
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_BIE_ADJ_ADJUDICACION ON ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION
					(BIE_ADJ_ID)
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
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_BIE_ADJ_ADJUDICACION... Indice creado');

  --Constraint tabla BIE_ADJ_ADJUDICACION con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (
		 CONSTRAINT PK_BIE_ADJ_ADJUDICACION
		 PRIMARY KEY
		 (BIE_ADJ_ID)
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... CONSTRAINT PRIMARY KEY PK_BIE_ADJ_ADJUDICACION');


    --Constraint tabla BIE_ADJ_ADJUDICACION con indices ajenos
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (

 		CONSTRAINT FK_BIE_ADJ 
 		FOREIGN KEY (BIE_ID) 
 		REFERENCES ' || V_ESQUEMA || '.BIE_BIEN (BIE_ID),

 		CONSTRAINT FK_BIE_ADJ_EAD 
 		FOREIGN KEY (DD_EAD_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_EAD_ENTIDAD_ADJUDICA (DD_EAD_ID),

 		CONSTRAINT FK_BIE_ADJ_SIT 
 		FOREIGN KEY (DD_SIT_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_SIT_SITUACION_TITULO (DD_SIT_ID),

 		CONSTRAINT FK_BIE_ADJ_RMO 
 		FOREIGN KEY (DD_RMO_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_RMO_RESOL_MORATORIA (DD_RMO_ID),

 		CONSTRAINT FK_BIE_ADJ_PER 
 		FOREIGN KEY (BIE_ADJ_GESTORIA_ADJUDIC) 
 		REFERENCES ' || V_ESQUEMA || '.PER_PERSONAS (PER_ID) 
 
		)';

    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... CONSTRAINT FOREIGN KEY');

    DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla BIE_ADJ_ADJUDICACION en el Esquema: ' || V_ESQUEMA);
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