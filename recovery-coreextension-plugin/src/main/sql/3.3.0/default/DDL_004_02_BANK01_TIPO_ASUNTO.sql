--/*
--##########################################
--## Author: David Gilsanz
--## Adaptado a BP : Joaquin Arnal
--## Finalidad: DDL para incluir el campo DD_TAS_ID en ASU_ASUNTO
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
    -- ******** ASU_ASUNTOS - Añadir campos *******
    DBMS_OUTPUT.PUT_LINE('******** ASU_ASUNTOS - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ASU_ASUNTOS'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_TAS_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||' .ASU_ASUNTOS ADD DD_TAS_ID NUMBER(16)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ASU_ASUNTOS... Añadido el campo DD_TAS_ID');
    END IF;
        
    V_SQL := 'SELECT count(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''ASU_ASUNTOS'' and CONSTRAINT_TYPE = ''R'' and R_CONSTRAINT_NAME = ''PK_DD_TAS_TIPOS_ASUNTO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 0 THEN 
      V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||' .ASU_ASUNTOS ADD (
                  CONSTRAINT FK_ASU_TAS_ID_FK_DD_TAS_ID
                  FOREIGN KEY (DD_TAS_ID)
                  REFERENCES BANKMASTER.DD_TAS_TIPOS_ASUNTO (DD_TAS_ID))';
      EXECUTE IMMEDIATE V_MSQL; 
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ASU_ASUNTOS... Añadido la FK al campo DD_TAS_ID');
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