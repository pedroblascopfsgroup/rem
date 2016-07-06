--/*
--##########################################
--## AUTOR=SERGIO NIETO GIL.
--## FECHA_CREACION=20160705
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-1840
--## PRODUCTO=SI
--## Finalidad: Amplicación de tabla
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_TABLA1 VARCHAR(30 CHAR) :='DPR_DECISIONES_PROCEDIMIENTOS';

    BEGIN
	    
	    	 -- ******** DPR_DECISIONES_PROCEDIMIENTOS - Añadir campos *******

   V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 1 THEN 
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''' || V_TABLA1 || ''' and owner = '''||V_ESQUEMA||''' and (column_name = ''DPR_NUM_OPERACION'')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
			if V_NUM_TABLAS = 0 THEN			
				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.' || V_TABLA1 || ' ADD (DPR_NUM_OPERACION  VARCHAR2(255 CHAR))';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_TABLA1 || '... Columna agregada');    
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
