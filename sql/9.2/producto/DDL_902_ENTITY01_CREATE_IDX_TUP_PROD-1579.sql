--/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20160524
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1579
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquema idx
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TUP_EPT_ESQUEMA_PLAZAS_TPO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe creamos el indice
	    IF V_NUM_TABLAS = 1 THEN
	    	 V_SQL := 'SELECT count(1) FROM (
            SELECT index_name, To_Char(WM_CONCAT(column_name))  columnas
            FROM ALL_IND_COLUMNS
            WHERE table_name = ''TUP_EPT_ESQUEMA_PLAZAS_TPO'' and index_owner=''' || V_ESQUEMA_IDX || '''
            GROUP BY index_name) sqli
	        WHERE sqli.columnas = ''DD_PLA_ID,DD_TPO_ID''';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    	IF V_NUM_TABLAS = 0 THEN
	    	V_MSQL := 'CREATE INDEX ' || V_ESQUEMA || '.IDX_TUP_EPT_ESQUEMA_PLAZAS_TPO ON ' || V_ESQUEMA || '.TUP_EPT_ESQUEMA_PLAZAS_TPO (DD_PLA_ID,DD_TPO_ID)  TABLESPACE ' || V_ESQUEMA_IDX;
		    EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] IDX_TUP_EPT_ESQUEMA_PLAZAS_TPO Indice creado'); 
		END IF;
    END IF;
    
   
    	
   
    DBMS_OUTPUT.PUT_LINE('[INFO] Fin script creacion de indices');

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