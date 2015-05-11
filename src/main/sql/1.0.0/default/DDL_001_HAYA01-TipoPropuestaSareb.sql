--/*
--##########################################
--## Author: Roberto
--## Finalidad: DDL crear diccionario de datos de Tipo de Propuesta de Elevación a Sareb (Subasta)
--## INSTRUCCIONES:  Configurar variables marcadas con [PARAMETRO]
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** DD_TIP_TIPOPROPUESTASAREB ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TIP_TIPOPROPUESTASAREB... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TIP_TIPOPROPUESTASAREB'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TIP_TIPOPROPUESTASAREB 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TIP_TIPOPROPUESTASAREB... Claves primarias eliminadas');	
    END IF;
		
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TIP_TIPOPROPUESTASAREB'' and owner = '''||V_ESQUEMA||'''';

    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DD_TIP_TIPOPROPUESTASAREB CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TIP_TIPOPROPUESTASAREB... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_TIP_TIPOPROPUESTASAREB'' and sequence_owner = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
		if V_NUM_TABLAS = 1 THEN			
			V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_TIP_TIPOPROPUESTASAREB';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_TIP_TIPOPROPUESTASAREB... Secuencia eliminada');    
		END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB... Comprobaciones previas FIN'); 


    --Creamos la tabla y secuencias
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB...');
    V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_TIP_TIPOPROPUESTASAREB';
		EXECUTE IMMEDIATE V_MSQL; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_TIP_TIPOPROPUESTASAREB... Secuencia creada');
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB
					(
            DD_TIP_ID NUMBER(16,0) NOT NULL ENABLE, 
            DD_TIP_CODIGO VARCHAR2(20 CHAR) NOT NULL ENABLE, 
            DD_TIP_DESCRIPCION VARCHAR2(50 CHAR), 
            DD_TIP_DESCRIPCION_LARGA VARCHAR2(250 CHAR), 
            VERSION NUMBER(*,0) DEFAULT 0 NOT NULL ENABLE, 
            USUARIOCREAR VARCHAR2(10 CHAR) NOT NULL ENABLE, 
            FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
            USUARIOMODIFICAR VARCHAR2(10 CHAR), 
            FECHAMODIFICAR TIMESTAMP (6), 
            USUARIOBORRAR VARCHAR2(10 CHAR), 
            FECHABORRAR TIMESTAMP (6), 
            BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL ENABLE
					)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB... Tabla creada');
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.UK_DD_TIP_TIPOPROPUESTASAREB ON ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB
					(DD_TIP_CODIGO)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.UK_DD_TIP_TIPOPROPUESTASAREB... Indice creado');
    
    V_MSQL := 'CREATE UNIQUE INDEX ' || V_ESQUEMA || '.PK_DD_TIP_TIPOPROPUESTASAREB ON ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB
					(DD_TIP_ID)';
		EXECUTE IMMEDIATE V_MSQL;
    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB ADD (
                CONSTRAINT PK_DD_TIP_TIPOPROPUESTASAREB PRIMARY KEY (DD_TIP_ID),
                CONSTRAINT UK_DD_TIP_TIPOPROPUESTASAREB UNIQUE (DD_TIP_CODIGO)
                )';						
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DD_TIP_TIPOPROPUESTASAREB... Creando PK');	
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TIP_TIPOPROPUESTASAREB... OK');	


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
