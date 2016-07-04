--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20160629
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-2095
--## PRODUCTO=SI
--##
--## Finalidad: DDL Addicion columna PCO_DOC_PDD_OBSERVACIONES_EDP a la tabla PCO_DOC_DOCUMENTOS
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
	
		    	 -- ******** PCO_DOC_DOCUMENTOS - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** PCO_DOC_DOCUMENTOS - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''PCO_DOC_DOCUMENTOS'' and owner = '''||V_ESQUEMA||''' and (column_name = ''PCO_DOC_PDD_OBSERVACIONES_EDP'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_DOC_DOCUMENTOS... Los campos ya existen en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_DOC_DOCUMENTOS ADD(PCO_DOC_PDD_OBSERVACIONES_EDP VARCHAR2(250 CHAR))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_DOC_DOCUMENTOS... Añadidos los campos PCO_DOC_PDD_OBSERVACIONES_EDP');
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