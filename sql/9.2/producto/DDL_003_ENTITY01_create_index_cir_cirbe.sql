--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0
--## INCIDENCIA_LINK=-
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
    V_ENTIDAD_ID NUMBER(16);
    --Insertando valores en FUN_FUNCIONES
    

BEGIN	
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] USER_INDEXES...Comprobaciones previas');
    
    V_SQL := 'SELECT COUNT (1) FROM ALL_IND_COLUMNS WHERE TABLE_NAME = UPPER(''CIR_CIRBE'') AND COLUMN_NAME = UPPER(''PER_ID'')';
    
    DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	    
		DBMS_OUTPUT.PUT_LINE('[FIN] USER_INDEXES...  indice ya existe');
	ELSE
	
		V_SQL := 'SELECT COUNT(*) FROM USER_INDEXES WHERE INDEX_NAME = ''PER_ID_IDX''';
		 DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.  YA EXISTENTE');
		ELSE
			V_MSQL := 'CREATE INDEX PER_ID_IDX ON '||V_ESQUEMA||'.CIR_CIRBE(PER_ID)';
		    EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.USER_INDEXES...  incide creado');
		END IF;
		
  	END IF;
  	
  	DBMS_OUTPUT.PUT_LINE('[INICIO] USER_INDEXES...Comprobaciones previas');
  	
  	V_SQL := 'SELECT COUNT (1) FROM ALL_IND_COLUMNS WHERE TABLE_NAME = UPPER(''CIR_CIRBE'') AND COLUMN_NAME = UPPER(''CIR_FECHA_EXTRACCION'')';
  	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	    
		DBMS_OUTPUT.PUT_LINE('[FIN] USER_INDEXES...  indice ya existe');
	ELSE
		V_SQL := 'SELECT COUNT(*) FROM USER_INDEXES WHERE INDEX_NAME = ''PER_ID_FECHA_IDX''';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.  YA EXISTENTE');
		ELSE
		
			V_MSQL := 'CREATE INDEX PER_ID_FECHA_IDX ON '||V_ESQUEMA||'.CIR_CIRBE(PER_ID,CIR_FECHA_EXTRACCION)';
	    	EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[FIN] USER_INDEXES...  incide creado');
		
		END IF;
		
  	END IF;
  	
    COMMIT;
    

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
  	