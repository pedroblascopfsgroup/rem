--/*
--##########################################
--## AUTOR=SONIA GARCIA MOCHALES
--## FECHA_CREACION=20181130
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=func-rem-GENCAT
--## INCIDENCIA_LINK= HREOS-4835
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial 
--##########################################
--*/ 


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CMG_COMUNICACION_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_AUX VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX1 VARCHAR2(2400 CHAR) := 'DD_SAN_SANCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX2 VARCHAR2(2400 CHAR) := 'DD_ECG_ESTADO_COM_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX3 VARCHAR2(2400 CHAR) := 'ACT_RCG_RECLAMACION_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX4 VARCHAR2(2400 CHAR) := 'DD_NOG_NOTIFICACION_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX5 VARCHAR2(2400 CHAR) := 'ACT_HCG_HIST_COM_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX6 VARCHAR2(2400 CHAR) := 'ACT_ADG_ADECUACION_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX7 VARCHAR2(2400 CHAR) := 'ACT_OFG_OFERTA_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX8 VARCHAR2(2400 CHAR) := 'ACT_VIG_VISITA_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TEXT_TABLA_AUX9 VARCHAR2(2400 CHAR) := 'ACT_NOG_NOTIFICACION_GENCAT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.


BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX1|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX1||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía DD_SAN_SANCION
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX1||''' and owner = '''||V_ESQUEMA||'''';
	
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX1||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX1||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia DD_SAN_SANCION
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX1||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX1||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX1||'';
	END IF;


-- Creamos la tabla DD_SAN_SANCION
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX1||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX1||'

   	(		 
		DD_SAN_ID		 NUMBER(16,0) NOT NULL, 
		DD_SAN_CODIGO		 VARCHAR2(25 BYTE), 
		DD_SAN_DESCRIPCION	 VARCHAR2(100 BYTE), 
		DD_SAN_DESCRIPCION_LARGA VARCHAR2(250 BYTE), 		
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  

-- Creamos indice DD_SAN_SANCION	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX1||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX1||'(DD_SAN_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX1||'_PK... Indice creado.');
	
	-- Creamos primary key DD_SAN_SANCION
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX1||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX1||'_PK PRIMARY KEY (DD_SAN_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX1||'_PK... PK creada.');
	
-- Creamos sequence DD_SAN_SANCION
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX1||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX1||'... Secuencia creada');

-----------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX2|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX2||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía DD_ECG_ESTADO_COM_GENCAT 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX2||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX2||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX2||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia DD_ECG_ESTADO_COM_GENCAT
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX2||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX2||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX2||'';
	END IF;


-- Creamos la tabla DD_ECG_ESTADO_COM_GENCAT
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX2||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX2||'

   	(		 
		DD_ECG_ID		 NUMBER(16,0) NOT NULL, 
		DD_ECG_CODIGO		 VARCHAR2(25 BYTE), 
		DD_ECG_DESCRIPCION	 VARCHAR2(100 BYTE), 
		DD_ECG_DESCRIPCION_LARGA VARCHAR2(250 BYTE), 		
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  

-- Creamos indice DD_ECG_ESTADO_COM_GENCAT	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX2||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX2||'(DD_ECG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX2||'_PK... Indice creado.');
	
	-- Creamos primary key DD_ECG_ESTADO_COM_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX2||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX2||'_PK PRIMARY KEY (DD_ECG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX2||'_PK... PK creada.');
	
-- Creamos sequence DD_ECG_ESTADO_COM_GENCAT
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX2||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX2||'... Secuencia creada');

-----------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX4|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía DD_NOG_NOTIFICACION_GENCAT 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX4||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX4||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia DD_NOG_NOTIFICACION_GENCAT 
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX4||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX4||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX4||'';
	END IF;


-- Creamos la tabla  DD_NOG_NOTIFICACION_GENCAT 
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX4||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||'

   	(		 
		DD_NOG_ID		 NUMBER(16,0) NOT NULL, 
		DD_NOG_CODIGO		 VARCHAR2(25 BYTE), 
		DD_NOG_DESCRIPCION	 VARCHAR2(100 BYTE), 
		DD_NOG_DESCRIPCION_LARGA VARCHAR2(250 BYTE), 		
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  

-- Creamos indice DD_NOG_NOTIFICACION_GENCAT 	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX4||'(DD_NOG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||'_PK... Indice creado.');
	
	-- Creamos primary key DD_NOG_NOTIFICACION_GENCAT 
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX4||'_PK PRIMARY KEY (DD_NOG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||'_PK... PK creada.');
	
-- Creamos sequence  DD_NOG_NOTIFICACION_GENCAT 
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX4||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX4||'... Secuencia creada');

-----------------------------------------------------------------------------------------------------


DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía DD_NOG_NOTIFICACION_GENCAT 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia DD_NOG_NOTIFICACION_GENCAT 
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
	END IF;


	-- Creamos la tabla ACT_CMG_COMUNICACION_GENCAT
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'

   	(		 
		CMG_ID 			 NUMBER(16,0) NOT NULL, 
		ACT_ID			 NUMBER(16,0),
		CMG_FECHA_PREBLOQUEO 	 DATE, 
		CMG_FECHA_COMUNICACION 	 DATE,
		CMG_FECHA_PREV_SANCION 	 DATE,
		CMG_FECHA_SANCION 	 DATE,
		DD_SAN_ID 		 NUMBER(16,0),
		CMG_COMPRADOR_NIF	 VARCHAR2(20 CHAR),
		CMG_COMPRADOR_NOMBRE	 VARCHAR2(100 CHAR),
		CMG_COMPRADOR_APELLIDO1	 VARCHAR2(100 CHAR),
		CMG_COMPRADOR_APELLIDO2	 VARCHAR2(100 CHAR),
		DD_ECG_ID 		 NUMBER(16,0),
		CMG_FECHA_ANULACION 	 DATE,
		CMG_CHECK_ANULACION	 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

	-- Creamos indice ACT_CMG_COMUNICACION_GENCAT	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(CMG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	-- Creamos primary key ACT_CMG_COMUNICACION_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (CMG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	
	-- Creamos foreing key ACT_ID->FK ACT_ACTIVO
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ACT_CMG_GENCAT FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA_AUX|| ' (ACT_ID))';
	
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

	-- Creamos foreing key DD_SAN_ID -> FK DD_SAN_SANCION
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ACT_CMG_GENCAT_SAN FOREIGN KEY (DD_SAN_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA_AUX1|| ' (DD_SAN_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

-- Creamos foreing key DD_ECG_ID -> FK DD_ECG_ESTADO_COM_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_ACT_CMG_GENCAT_ECG FOREIGN KEY (DD_ECG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA_AUX2|| ' (DD_ECG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

	-- Creamos sequence ACT_CMG_COMUNICACION_GENCAT
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');


-------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX5|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía ACT_HCG_HIST_COM_GENCAT
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX5||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX5||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia ACT_HCG_HIST_COM_GENCAT
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX5||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX5||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX5||'';
	END IF;


-- Creamos la tabla ACT_HCG_HIST_COM_GENCAT
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX5||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'

   	(		 
		HCG_ID		 	 NUMBER(16,0) NOT NULL, 
		HCG_FECHA_INI	 	 DATE, 
		HCG_FECHA_FIN	 	 DATE,
		ACT_ID			 NUMBER(16,0),
		HCG_FECHA_PREBLOQUEO 	 DATE, 
		HCG_FECHA_COMUNICACION 	 DATE,
		HCG_FECHA_PREV_SANCION 	 DATE,
		HCG_FECHA_SANCION 	 DATE,
		DD_SAN_ID 		 NUMBER(16,0),
		HCG_COMPRADOR_NIF	 VARCHAR2(20 CHAR),
		HCG_COMPRADOR_NOMBRE	 VARCHAR2(100 CHAR),
		HCG_COMPRADOR_APELLIDO1	 VARCHAR2(100 CHAR),
		HCG_COMPRADOR_APELLIDO2	 VARCHAR2(100 CHAR),
		DD_ECG_ID 		 NUMBER(16,0),
		HCG_FECHA_ANULACION 	 DATE,
		HCG_CHECK_ANULACION	 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE,
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  

-- Creamos indice ACT_HCG_HIST_COM_GENCAT 	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX5||'(HCG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'_PK... Indice creado.');
	
	-- Creamos primary key ACT_HCG_HIST_COM_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX5||'_PK PRIMARY KEY (HCG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'_PK... PK creada.');
	
-- Creamos sequence ACT_HCG_HIST_COM_GENCAT
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX5||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX5||'... Secuencia creada');

	-- Creamos foreing key ACT_ID->FK ACT_ACTIVO
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||' ADD (CONSTRAINT FK_ACT_HCG_GENCAT FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA_AUX|| ' (ACT_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'_FK... FK creada.');

	-- Creamos foreing key DD_SAN_ID -> FK DD_SAN_SANCION
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||' ADD (CONSTRAINT FK_ACT_HCG_GENCAT_SAN FOREIGN KEY (DD_SAN_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA_AUX1|| ' (DD_SAN_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'_FK... FK creada.');

-- Creamos foreing key DD_ECG_ID -> FK DD_ECG_ESTADO_COM_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||' ADD (CONSTRAINT FK_ACT_HCG_GENCAT_ECG FOREIGN KEY (DD_ECG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA_AUX2|| ' (DD_ECG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX5||'_FK... FK creada.');


-----------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX6|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía ACT_ADG_ADECUACION_GENCAT 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX6||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX6||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia ACT_ADG_ADECUACION_GENCATT 
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX6||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX6||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX6||'';
	END IF;


-- Creamos la tabla  ACT_ADG_ADECUACION_GENCAT 
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX6||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||'

   	(		 
		ADG_ID		 	 NUMBER(16,0) NOT NULL, 
		CMG_ID 			 NUMBER(16,0),
		ADG_REFORMA		 NUMBER(1,0),
		ADG_IMPORTE		 NUMBER(16,2),
		ADG_FECHA_REVISION 	 DATE,
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  

-- Creamos indice ACT_ADG_ADECUACION_GENCAT	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX6||'(ADG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||'_PK... Indice creado.');
	
	-- Creamos primary key ACT_ADG_ADECUACION_GENCAT 
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX6||'_PK PRIMARY KEY (ADG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||'_PK... PK creada.');
	
-- Creamos sequence  ACT_ADG_ADECUACION_GENCAT 
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX6||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX6||'... Secuencia creada');

-- Creamos foreing key CMG_ID->FK ACT_CMG
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||' ADD (CONSTRAINT FK_ACT_ADG_GENCAT FOREIGN KEY (CMG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA|| ' (CMG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX6||'_FK... FK creada.');


-----------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX7|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía ACT_OFG_OFERTA_GENCAT
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX7||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX7||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia ACT_OFG_OFERTA_GENCAT
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX7||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX7||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX7||'';
	END IF;


-- Creamos la tabla  ACT_OFG_OFERTA_GENCAT 
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX7||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||'

   	(		 
		OFG_ID		 	 NUMBER(16,0) NOT NULL, 
		CMG_ID 			 NUMBER(16,0),
		OFR_ID		 	 NUMBER(16,0),
		OFG_IMPORTE		 NUMBER(16,2),
		DD_TPE_ID		 NUMBER(16,0),
		DD_SIP_ID		 NUMBER(16,0),
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  

-- Creamos indice ACT_OFG_OFERTA_GENCAT	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX7||'(OFG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||'_PK... Indice creado.');
	
	-- Creamos primary key ACT_OFG_OFERTA_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX7||'_PK PRIMARY KEY (OFG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||'_PK... PK creada.');
	
-- Creamos sequence  ACT_OFG_OFERTA_GENCAT
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX7||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX7||'... Secuencia creada');

-- Creamos foreing key CMG_ID->FK ACT_CMG
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||' ADD (CONSTRAINT FK_ACT_OFG_GENCAT FOREIGN KEY (CMG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA|| ' (CMG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

-- Creamos foreing key OFR_ID->FK OFR_OFERTAS
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||' ADD (CONSTRAINT FK_OFR_OFERTAS FOREIGN KEY (OFR_ID) REFERENCES '||V_ESQUEMA|| '.OFR_OFERTAS (OFR_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.OFR_OFERTAS_FK... FK creada.');


-- Creamos foreing key DD_TPE_ID->FK DD_TPE_TIPO_PERSONA
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||' ADD (CONSTRAINT FK_DD_TPE_TIPO_PERSONA FOREIGN KEY (DD_TPE_ID) REFERENCES '||V_ESQUEMA|| '.DD_TPE_TIPO_PERSONA (DD_TPE_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_TPE_TIPO_PERSONA_FK... FK creada.');

-- Creamos foreing key DD_SIP_ID->FK DD_SIP_SITUACION_POSESORIA
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX7||' ADD (CONSTRAINT FK_DD_SIP_SITUACION_POSESORIA FOREIGN KEY (DD_SIP_ID) REFERENCES '||V_ESQUEMA|| '.DD_SIP_SITUACION_POSESORIA (DD_SIP_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_SIP_SITUACION_POSESORIA_FK... FK creada.');

-----------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX8|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía ACT_VIG_VISITA_GENCAT 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX8||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX8||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia ACT_VIG_VISITA_GENCAT
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX8||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX8||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX8||'';
	END IF;


-- Creamos la tabla  ACT_VIG_VISITA_GENCAT
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX8||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||'

   	(		 
		VIG_ID		 	 NUMBER(16,0) NOT NULL, 
		CMG_ID 			 NUMBER(16,0),
		VIS_ID		 	 NUMBER(16,0),
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  

-- Creamos indice ACT_VIG_VISITA_GENCAT	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX8||'(VIG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||'_PK... Indice creado.');
	
	-- Creamos primary key ACT_VIG_VISITA_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX8||'_PK PRIMARY KEY (VIG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||'_PK... PK creada.');
	
-- Creamos sequence  ACT_ADG_ADECUACION_GENCAT 
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX8||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX8||'... Secuencia creada');

-- Creamos foreing key CMG_ID->FK ACT_CMG
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||' ADD (CONSTRAINT FK_ACT_VIG_GENCAT FOREIGN KEY (CMG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA|| ' (CMG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

-- Creamos foreing key VIS_ID->FK VIS_VISITAS
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX8||' ADD (CONSTRAINT FK_VIS_VISITAS FOREIGN KEY (VIS_ID) REFERENCES '||V_ESQUEMA|| '.VIS_VISITAS (VIS_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VIS_VISITAS_FK... FK creada.');


-----------------------------------------------------------------------------------------------------


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX9|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía ACT_NOG_NOTIFICACION_GENCAT 
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX9||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX9||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia ACT_NOG_NOTIFICACION_GENCAT
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX9||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX9||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX9||'';
	END IF;


-- Creamos la tabla  ACT_NOG_NOTIFICACION_GENCAT 
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX9||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||'

   	(		 
		NOG_ID		 	 	NUMBER(16,0) NOT NULL, 
		CMG_ID 			 	NUMBER(16,0),
		NOG_CHECK_NOTIFICATION 	 	NUMBER(1,0),	
		NOG_FECHA_NOTIFICATION		DATE,
		DD_NOG_ID		 	NUMBER(16,0),
		NOG_FECHA_SANCION_NOTIFICATION	DATE,
		NOG_FECHA_CIERRE_NOTIFICATION	DATE,
		VERSION 		 	NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 			VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 			TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 		VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 			TIMESTAMP (6), 
		USUARIOBORRAR 			VARCHAR2(50 CHAR), 
		FECHABORRAR 		 	TIMESTAMP (6), 
		BORRADO 		 	NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  


-- Creamos indice ACT_NOG_NOTIFICACION_GENCAT	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX9||'(NOG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||'_PK... Indice creado.');
	
	-- Creamos primary key ACT_NOG_NOTIFICACION_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX9||'_PK PRIMARY KEY (NOG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||'_PK... PK creada.');
	
-- Creamos sequence  ACT_NOG_NOTIFICACION_GENCAT 
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX9||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX9||'... Secuencia creada');

-- Creamos foreing key CMG_ID->FK ACT_CMG
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||' ADD (CONSTRAINT FK_ACT_NOG_GENCAT_CMG FOREIGN KEY (CMG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA|| ' (CMG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_FK... FK creada.');

-- Creamos foreing key DD_NOG_ID->FK DD_NOG_NOTIFICATION_GENCAT
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX9||' ADD (CONSTRAINT FK_ACT_NOG_GENCAT_NOG FOREIGN KEY (DD_NOG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA_AUX4|| ' (DD_NOG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX4||'_FK... FK creada.');

----------------------------------------------------------------------------------------------------

	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA_AUX3|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe y está vacía ACT_RCG_RECLAMACION_GENCAT
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA_AUX3||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA_AUX3||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia ACT_RCG_RECLAMACION_GENCAT
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA_AUX3||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA_AUX3||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX3||'';
	END IF;


-- Creamos la tabla ACT_RCG_RECLAMACION_GENCAT
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX3||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||'

   	(		 
		RCG_ID		 	 NUMBER(16,0) NOT NULL, 
		CMG_ID 			 NUMBER(16,0),
		RCG_FECHA_AVISO 	 DATE,
		RCG_FECHA_RECLAMACION	 DATE,
		VERSION 		 NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 		 VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		FECHACREAR 		 TIMESTAMP (6) NOT NULL ENABLE, 
		USUARIOMODIFICAR 	 VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 		 TIMESTAMP (6), 
		USUARIOBORRAR 		 VARCHAR2(50 CHAR), 
		FECHABORRAR 		 TIMESTAMP (6), 
		BORRADO 		 NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE 
 	)';

EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_AUX1||'... Tabla creada');  



-- Creamos indice ACT_RCG_RECLAMACION_GENCAT
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA_AUX3||'(RCG_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||'_PK... Indice creado.');
	
	-- Creamos primary key ACT_RCG_RECLAMACION_GENCAT 
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||' ADD (CONSTRAINT '||V_TEXT_TABLA_AUX3||'_PK PRIMARY KEY (RCG_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||'_PK... PK creada.');
	
-- Creamos sequence ACT_RCG_RECLAMACION_GENCAT
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX3||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA_AUX3||'... Secuencia creada');

-- Creamos foreing key CMG_ID->FK ACT_CMG
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||' ADD (CONSTRAINT FK_ACT_RCG_GENCAT_CMG FOREIGN KEY (CMG_ID) REFERENCES '||V_ESQUEMA|| '.' ||V_TEXT_TABLA|| ' (CMG_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_AUX3||'_FK... FK creada.');


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
