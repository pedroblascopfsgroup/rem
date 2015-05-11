--/*
--##########################################
--## Author: Pedro Blasco
--## Adaptado a BP : Pedro Blasco
--## Finalidad: DDL de creación de la tabla de envío de emails de acuerdos
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
SET SERVEROUTPUT ON; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	
    -- ******** AEM_ACUERDOS_ENV_MAIL *******
    DBMS_OUTPUT.PUT_LINE('******** AEM_ACUERDOS_ENV_MAIL (ROLLBACK) ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] ROLLBACK '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL... Comprobaciones previas'); 
    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''AEM_ACUERDOS_ENV_MAIL'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN	
      V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL 
                  DROP PRIMARY KEY CASCADE';		
			EXECUTE IMMEDIATE V_MSQL;  
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL... Claves primarias eliminadas');	
    END IF;
	-- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AEM_ACUERDOS_ENV_MAIL'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL CASCADE CONSTRAINTS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.AEM_ACUERDOS_ENV_MAIL... Tabla borrada');  
    END IF;
    -- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_AEM_ACUERDOS_ENV_MAIL'' and sequence_owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	if V_NUM_TABLAS = 1 THEN			
		V_MSQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_AEM_ACUERDOS_ENV_MAIL';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... Secuencia eliminada');    
	END IF; 
    DBMS_OUTPUT.PUT_LINE('[INFO] ROLLBACK ' || V_ESQUEMA || '.AEM_ACUERDOS_ENV_MAIL... OK');
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