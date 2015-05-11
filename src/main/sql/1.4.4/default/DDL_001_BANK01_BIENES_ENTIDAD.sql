--/*
--##########################################
--## Author: Recovery
--## Adaptado a BP : Teresa Alonso
--## Finalidad: DDL creacion BIE_BIEN_ENTIDAD
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

    -- Vble. auxiliar para registrar errores en el script.
    ERR_NUM NUMBER(25);  

    -- Vble. auxiliar para registrar mensajes de errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); 

BEGIN	
    
    -- ******** BIE_BIEN_ENTIDAD *******
    DBMS_OUTPUT.PUT_LINE('Creacion de la Tabla BIE_BIEN_ENTIDAD en el Esquema: ' || V_ESQUEMA);
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD... Comprobaciones previas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''BIE_BIEN_ENTIDAD'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK, se realiza el borrado de la clave primaria
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD... Claves primarias eliminadas');	
                       
    END IF;

    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BIE_BIEN_ENTIDAD'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD... Tabla borrada');  

    END IF;


    -- Comprobamos si existe la secuencia
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_BIE_BIEN_ENTIDAD'' and sequence_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 

    -- Si existe secuencia la borramos
    if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_BIE_BIEN_ENTIDAD';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_BIEN_ENTIDAD... Secuencia eliminada');    
		END IF; 

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD... Comprobaciones previas FIN'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    --Creamos la tabla y secuencias
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD... Creacion de tablas'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_BIE_BIEN_ENTIDAD';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_BIE_BIEN_ENTIDAD... Secuencia creada');

    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD
				      (
 					BIE_ID                    	NUMBER(16)       		NOT NULL,
					DD_TBI_ID                    	NUMBER(16),
  					BIE_PARTICIPACION            	NUMBER(3),
  					BIE_VALOR_ACTUAL             	NUMBER(16,2),
  					BIE_IMPORTE_CARGAS           	NUMBER(16,2),
  					BIE_SUPERFICIE               	NUMBER(16,2),
  					BIE_POBLACION                	VARCHAR2(50 CHAR),
  					BIE_DATOS_REGISTRALES        	VARCHAR2(50 CHAR),
  					BIE_REFERENCIA_CATASTRAL     	VARCHAR2(50 CHAR),
  					BIE_DESCRIPCION              	VARCHAR2(250 CHAR),
  					BIE_FECHA_VERIFICACION       	DATE,
  					DD_ORIGEN_ID                 	NUMBER(16)       DEFAULT 1,
  					BIE_MARCA_EXTERNOS           	NUMBER(1)        DEFAULT 0,
  					DD_TPO_CARGA_ID              	NUMBER(16),
  					BIE_CODIGO_INTERNO           	NUMBER(16),
  					BIE_SOLVENCIA_NO_ENCONTRADA  	NUMBER(1)        DEFAULT 0 	NOT NULL,
  					BIE_OBSERVACIONES            	VARCHAR2(2000 CHAR),
  					BIE_LOC_ID         	       	NUMBER(16)                 	NOT NULL,
  					BIE_LOC_POBLACION  	       	VARCHAR2(250 CHAR),
  					BIE_LOC_DIRECCION  		VARCHAR2(250 CHAR),
  					bIE_LOC_COD_POST   		VARCHAR2(250 CHAR),
  					DD_PRV_ID          		NUMBER(16),
  					BIE_DREG_ID                     NUMBER(16)    			NOT NULL,
  					BIE_DREG_REFERENCIA_CATASTRAL   VARCHAR2(50 CHAR),
  					BIE_DREG_SUPERFICIE             NUMBER(16,2),
  					BIE_DREG_SUPERFICIE_CONSTRUIDA  NUMBER(16,2),
  					BIE_DREG_TOMO                   VARCHAR2(50 CHAR),
  					BIE_DREG_LIBRO                  VARCHAR2(50 CHAR),
  					BIE_DREG_FOLIO                  VARCHAR2(50 CHAR),
  					BIE_DREG_INSCRIPCION            VARCHAR2(50 CHAR),
  					BIE_DREG_FECHA_INSCRIPCION      TIMESTAMP(6),
  					BIE_DREG_NUM_REGISTRO           VARCHAR2(50 CHAR),
  					BIE_DREG_MUNICIPIO_LIBRO        VARCHAR2(50 CHAR),
  					BIE_DREG_CODIGO_REGISTRO        VARCHAR2(50 CHAR),
  					BIE_DREG_NUM_FINCA              VARCHAR2(50 BYTE),
  					BIE_ADI_ID              	NUMBER(16)            		NOT NULL,
  					BIE_ADI_NOM_EMPRESA     	VARCHAR2(150 CHAR),
  					BIE_ADI_CIF_EMPRESA     	VARCHAR2(20 CHAR),
  					BIE_ADI_COD_IAE         	VARCHAR2(50 CHAR),
  					BIE_ADI_DES_IAE         	VARCHAR2(150 CHAR),
  					DD_TPB_ID               	NUMBER(16),
  					DD_TPN_ID               	NUMBER(16),
  					BIE_ADI_VALORACION      	NUMBER(16,2),
  					BIE_ADI_ENTIDAD         	VARCHAR2(150 CHAR),
  					BIE_ADI_NUM_CUENTA      	VARCHAR2(150 CHAR),
  					BIE_ADI_MATRICULA       	VARCHAR2(50 CHAR),
  					BIE_ADI_BASTIDOR        	VARCHAR2(50 CHAR),
  					BIE_ADI_MODELO          	VARCHAR2(50 CHAR),
  					BIE_ADI_MARCA           	VARCHAR2(50 CHAR),
  					BIE_ADI_FECHAMATRICULA  	TIMESTAMP(6),
  					BIE_VAL_ID                     	NUMBER(16)     			NOT NULL,
  					BIE_FECHA_VALOR_SUBJETIVO      	TIMESTAMP(6),
  					BIE_IMPORTE_VALOR_SUBJETIVO    	NUMBER(16,2),
  					BIE_FECHA_VALOR_APRECIACION    	TIMESTAMP(6),
  					BIE_IMPORTE_VALOR_APRECIACION  	NUMBER(16,2),
  					BIE_FECHA_VALOR_TASACION       	TIMESTAMP(6),
  					BIE_IMPORTE_VALOR_TASACION     	NUMBER(16,2),
  					VERSION                      	INTEGER     	DEFAULT 0 	NOT NULL,
  					USUARIOCREAR                 	VARCHAR2(10 CHAR) 		NOT NULL,
  					FECHACREAR                   	TIMESTAMP(6)     		NOT NULL,
  					USUARIOMODIFICAR             	VARCHAR2(10 CHAR),
  					FECHAMODIFICAR               	TIMESTAMP(6),
  					USUARIOBORRAR                	VARCHAR2(10 CHAR),
  					FECHABORRAR                  	TIMESTAMP(6),
  					BORRADO                      	NUMBER(1) 	DEFAULT 0 	NOT NULL
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD... Tabla creada');

    --Creamos indices
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN_ENTIDAD... Creacion de indices'); 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 

    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_BIE_BIEN_ENTIDAD ON ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD
					(BIE_ID)
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
   DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_BIE_BIEN_ENTIDAD... Indice creado');

   --Constraint tabla BIE_BIEN_ENTIDAD con indices
  V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD ADD (
		 CONSTRAINT PK_BIE_BIEN_ENTIDAD
		 PRIMARY KEY
		 (BIE_ID)
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
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD... CONSTRAINT PRIMARY KEY PK_BIE_BIEN_ENTIDAD');

    --Constraint tabla BIE_BIEN_ENTIDAD con indices ajenos
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD ADD (
 
  		CONSTRAINT FK_BBE_FK_DD_ORIGEN_BIEN 
 		FOREIGN KEY (DD_ORIGEN_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_ORIGEN_BIEN (DD_ORIGEN_ID),

 		CONSTRAINT FK_BIEE_PRV_ID 
 		FOREIGN KEY (DD_PRV_ID) 
 		REFERENCES ' || V_ESQUEMA_MASTER || '.DD_PRV_PROVINCIA (DD_PRV_ID),

  		CONSTRAINT BIE_BIEN_ENT_IBFK_1 
 		FOREIGN KEY (DD_TBI_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_TBI_TIPO_BIEN (DD_TBI_ID),

  		CONSTRAINT FK_BBE_FK_DD_CARGA_BIEN 
 		FOREIGN KEY (DD_TPO_CARGA_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_TPO_CARGA_BIEN (DD_TPO_CARGA_ID)
		)';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD... CONSTRAINT FOREIGN KEY');

   --Constraint tabla BIE_BIEN_ENTIDAD con resto indices ajenos
   V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD ADD (

  		CONSTRAINT FK_BIEE_DD_TPB 
 		FOREIGN KEY (DD_TPB_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_TPB_TIPO_PROD_BANCARIO (DD_TPB_ID),

  		CONSTRAINT FK_BIEE_DD_TPN 
 		FOREIGN KEY (DD_TPN_ID) 
 		REFERENCES ' || V_ESQUEMA || '.DD_TPN_TIPO_INMUEBLE (DD_TPN_ID)
		)';
    EXECUTE IMMEDIATE V_MSQL; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN_ENTIDAD... CONSTRAINT RESTO FOREIGN KEY');

   DBMS_OUTPUT.PUT_LINE('Fin creacion correcta de la Tabla BIE_BIEN_ENTIDAD en el Esquema: ' || V_ESQUEMA);
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