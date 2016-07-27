--/*
--##########################################
--## AUTOR=Óscar Dorado
--## FECHA_CREACION=20160621
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=v9.2.7
--## INCIDENCIA_LINK=RECOVERY-2
--## PRODUCTO=SI
--## 
--## Finalidad: Amplicación de tabla 
--##							
--##                               
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;


DECLARE

	V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master
	V_TS_INDEX VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
	ERR_NUM NUMBER;
	ERR_MSG VARCHAR2(2048 CHAR); 
	V_SQL VARCHAR2(8500 CHAR);
	V_MSQL VARCHAR2(8500 CHAR);
	V_NUM_TABLAS NUMBER (1);

	V_TABLA1 VARCHAR(30 CHAR) :='TUP_TMP_CALCULOS_TURN_PROCU';

BEGIN 

    DBMS_OUTPUT.PUT_LINE('******** ' || V_TABLA1 || ' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.' || V_TABLA1 || '... Comprobaciones previas'); 
       
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''DD_PLA_ID'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (DD_PLA_ID  NUMBER(16))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_' || V_TABLA1 || '... Columna agregada');    
			END IF; 			
    END IF;
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''DD_TPO_ID'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (DD_TPO_ID  NUMBER(16))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_' || V_TABLA1 || '... Columna agregada');    
			END IF; 			
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
