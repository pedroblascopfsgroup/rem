--/*
--##########################################
--## Author: Carlos Pérez
--## Finalidad: DDL para modificar el tamaño de la columna N_CASO
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
    -- ******** LIN_ASUNTOS_NUEVOS - Añadir campos *******
    DBMS_OUTPUT.PUT_LINE('******** LIN_ASUNTOS_NUEVOS - Modificar campo N_CASO *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''LIN_ASUNTOS_NUEVOS'' and owner = '''||V_ESQUEMA||''' and column_name = ''N_CASO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LIN_ASUNTOS_NUEVOS... El campo ''N_CASO'' ya existe en la tabla');
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||'.LIN_ASUNTOS_NUEVOS MODIFY N_CASO VARCHAR2(50 BYTE)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LIN_ASUNTOS_NUEVOS... Modificado el campo N_CASO');
    ELSE
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||'.LIN_ASUNTOS_NUEVOS ADD (N_CASO VARCHAR2(50 BYTE)  NOT NULL)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LIN_ASUNTOS_NUEVOS... Añadido el campo N_CASO');
    END IF;
	
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.LIN_ASUNTOS_NUEVOS... Script finalizado correctamente');
	
    
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