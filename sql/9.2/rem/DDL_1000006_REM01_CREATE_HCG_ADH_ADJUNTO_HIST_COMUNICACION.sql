--/*
--##########################################
--## AUTOR=ISIDRO SOTOCA
--## FECHA_CREACION=20190124
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=func-rem-GENCAT
--## INCIDENCIA_LINK=HREOS-5051
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla HCG_ADH_ADJ_HIST_COM_GENCAT
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Sergio Nieto HREOS-5213 modificación del campo de adjunto de referencia
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(50 CHAR) := 'HCG_ADH_ADJ_HIST_COM_GENCAT';

    BEGIN

    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
    
    -- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
	END IF; 
    
    -- Creacion tabla HCG_ADH_ADJ_HIST_COM_GENCAT
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
					ADH_ID NUMBER (16,0) NOT NULL ENABLE,
					HCG_ID NUMBER (16,0) NOT NULL ENABLE,
					ADC_ID NUMBER (16,0) NOT NULL ENABLE,
				  	VERSION NUMBER(1,0) DEFAULT 0, 
				  	USUARIOCREAR VARCHAR2 (50 CHAR) NOT NULL ENABLE, 
				  	FECHACREAR TIMESTAMP(6) DEFAULT SYSTIMESTAMP, 
				  	USUARIOMODIFICAR VARCHAR2 (50 CHAR), 
				  	FECHAMODIFICAR TIMESTAMP(6), 
				  	USUARIOBORRAR VARCHAR2 (50 CHAR), 
				  	FECHABORRAR TIMESTAMP(6), 
				  	BORRADO NUMBER(1,0) DEFAULT 0, 
				  	CONSTRAINT PK_ADH_ID PRIMARY KEY(ADH_ID)
		  		)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
	
	-- Creamos foreign key HCG_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_ADH_HCG_ID FOREIGN KEY (HCG_ID) REFERENCES '||V_ESQUEMA||'.ACT_HCG_HIST_COM_GENCAT (HCG_ID) ON DELETE CASCADE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'.FK_HCG_ID... Foreign key creada.');
	
	-- Creamos foreign key ADA_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT FK_ADH_ADC_ID FOREIGN KEY (ADA_ID) REFERENCES '||V_ESQUEMA||'.ADC_ADJUNTO_COMUNICACION (ADC_ID) ON DELETE CASCADE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'.FK_ADA_ID... Foreign key creada.');
	
	-- Creamos la secuencia
  	    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_'||V_TABLA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia creada correctamente.');
	
	-- Asignamos los permisos
	EXECUTE IMMEDIATE 'grant select, insert, delete, update, REFERENCES(ADH_ID) on '||V_ESQUEMA||'.'||V_TABLA||' to '||V_ESQUEMA_M||' ';
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Permisos añadidos');
	
	-- Añadimos comentarios a las columnas
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.ADH_ID      		IS ''Código identificador único del adjunto de la comunicación''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.HCG_ID      		IS ''Código identificador único de la comunicación del historico a la que pertenece el adjunto.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.ADC_ID      		IS ''Código identificador único del adjunto de la comunicación.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.VERSION      		IS ''Indica la version del registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.USUARIOCREAR    	IS ''Indica el usuario que creo el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.FECHACREAR      	IS ''Indica la fecha en la que se creo el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.USUARIOMODIFICAR 	IS ''Indica el usuario que modificó el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.FECHAMODIFICAR   	IS ''Indica la fecha en la que se modificó el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.USUARIOBORRAR   	IS ''Indica el usuario que borró el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.FECHABORRAR    	IS ''Indica la fecha en la que se borró el registro.''  ';
	EXECUTE IMMEDIATE  'COMMENT ON COLUMN '|| V_ESQUEMA ||'.'||V_TABLA||'.BORRADO        	IS ''Indicador de borrado.''  ';
	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Comentarios añadidos');
    
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