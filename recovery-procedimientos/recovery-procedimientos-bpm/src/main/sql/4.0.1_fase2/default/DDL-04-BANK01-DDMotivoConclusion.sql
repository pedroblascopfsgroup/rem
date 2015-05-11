/*
--##########################################
--## Author: Oscar Dorado
--## Adaptado a BP : 
--## Finalidad: Crear DD Resultados de informe
--## INSTRUCCIONES:  Crear la tabla para guardar los Resultados de informe
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

    VAR_TABLENAME := 'DD_MOC_MOTIVO_CONCLUSION';
    VAR_SEQUENCENAME := 'S_DD_MOC_MOTIVO_CONCLUSION';
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
            DD_MOC_ID                 NUMBER(16)          NOT NULL,
            DD_MOC_CODIGO             VARCHAR2(50 CHAR)   NOT NULL,
            DD_MOC_DESCRIPCION        VARCHAR2(50 CHAR),
            DD_MOC_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
            DD_MOC_PATRON             VARCHAR2(250 CHAR),
            VERSION                   INTEGER             DEFAULT 0 NOT NULL,
            USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
            FECHACREAR                TIMESTAMP(6)        NOT NULL,
            USUARIOMODIFICAR          VARCHAR2(10 CHAR),
            FECHAMODIFICAR            TIMESTAMP(6),
            USUARIOBORRAR             VARCHAR2(10 CHAR),
            FECHABORRAR               TIMESTAMP(6),
            BORRADO                   NUMBER(1)           DEFAULT 0 NOT NULL
					)';
    EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || '... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DD_MOC_MOTIVO_CONCLUSION ON ' || V_ESQUEMA || '.' || VAR_TABLENAME || '
					(DD_MOC_CODIGO)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.UK_DD_MOC_MOTIVO_CONCLUSION... Indice creado');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_MOC_MOTIVO_CONCLUSION ON ' || V_ESQUEMA || '.' || VAR_TABLENAME || '
					(DD_MOC_ID)';
		EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' ADD (
                CONSTRAINT PK_DD_MOC_MOTIVO_CONCLUSION PRIMARY KEY (DD_MOC_ID),
                CONSTRAINT UK_DD_MOC_MOTIVO_CONCLUSION UNIQUE (DD_MOC_CODIGO)
                )';						
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_MOC_MOTIVO_CONCLUSION... Creando PK');	
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