--/*
--##########################################
--## Author: Equipo Fase II - Bankia
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DDL para incluir FLAG_DERIVABLE en DD_TPO_TIPO_PROCEDIMIENTO
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	  
    -- ******** DD_TPO_TIPO_PROCEDIMIENTO - Añadir campos *******
    DBMS_OUTPUT.PUT_LINE('******** DD_TPO_TIPO_PROCEDIMIENTO - Añadir campo *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DD_TPO_TIPO_PROCEDIMIENTO'' and owner = '''||V_ESQUEMA||''' and column_name = ''FLAG_DERIVABLE''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[ALERT] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO 
                    ADD (FLAG_DERIVABLE  NUMBER(1)  DEFAULT 1  NOT NULL)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... Añadido el campo FLAG_DERIVABLE');
    END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DD_TPO_TIPO_PROCEDIMIENTO'' and owner = '''||V_ESQUEMA||''' and column_name = ''FLAG_UNICO_BIEN''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[ALERT] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||'.DD_TPO_TIPO_PROCEDIMIENTO 
                    ADD (FLAG_UNICO_BIEN  NUMBER(1)                     DEFAULT 0                     NOT NULL)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_TPO_TIPO_PROCEDIMIENTO... Añadido el campo FLAG_UNICO_BIEN');
    END IF;
	
    
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