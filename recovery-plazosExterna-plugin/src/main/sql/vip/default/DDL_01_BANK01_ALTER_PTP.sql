--/*
--##########################################
--## Author: Carlos Perez
--## Finalidad: DDL para incluir campos en PTP para el plugin de configurador de plazos
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
    DBMS_OUTPUT.PUT_LINE('[INICIO] DD_PTP_PLAZOS_TAREAS_PLAZAS - Añadir campos');
        
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DD_PTP_PLAZOS_TAREAS_PLAZAS'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_PTP_ABSOLUTO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||' .DD_PTP_PLAZOS_TAREAS_PLAZAS ADD DD_PTP_ABSOLUTO  NUMBER(1) DEFAULT 0';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Añadido el campo DD_PTP_ABSOLUTO');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo DD_PTP_ABSOLUTO');
    END IF;
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DD_PTP_PLAZOS_TAREAS_PLAZAS'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_PTP_OBSERVACIONES''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 0 THEN
        V_MSQL := 'ALTER TABLE  '|| V_ESQUEMA ||' .DD_PTP_PLAZOS_TAREAS_PLAZAS ADD DD_PTP_OBSERVACIONES VARCHAR2(250 CHAR)';
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS... Añadido el campo DD_PTP_OBSERVACIONES');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el campo DD_PTP_OBSERVACIONES');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('[END] Tabla DD_PTP_PLAZOS_TAREAS_PLAZAS alterada correctamente');  
        
  
    
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