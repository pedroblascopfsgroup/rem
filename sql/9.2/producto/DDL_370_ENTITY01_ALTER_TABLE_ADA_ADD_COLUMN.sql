--/*
--##########################################
--## AUTOR=ENRIQUE BADENES
--## FECHA_CREACION=20160527
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1630
--## PRODUCTO=SI
--##
--## Finalidad: DDL Addicion columna BPM_IPT_ID a la tabla ADA_ADJUNTOS_ASUNTOS para el modulo de procuradores
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
	
		    	 -- ******** ADA_ADJUNTOS_ASUNTOS - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** ADA_ADJUNTOS_ASUNTOS - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ADA_ADJUNTOS_ASUNTOS'' and owner = '''||V_ESQUEMA||''' and (column_name = ''BPM_IPT_ID'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS... Los campos ya existen en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ADA_ADJUNTOS_ASUNTOS ADD(BPM_IPT_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS... Añadidos los campos BPM_IPT_ID');
			-- ********** ADA_ADJUNTOS_ASUNTOS - FKs
	    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''ADA_ADJUNTOS_ASUNTOS'' and owner = '''||V_ESQUEMA||''' and (CONSTRAINT_NAME = ''FK_ADA_BPM_IPT_ID'')';
	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	    -- Si existe la PK
	    IF V_NUM_TABLAS >= 1 THEN
	    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS ... FK ya existen');
	    ELSE
		    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS  ADD (
				CONSTRAINT FK_ADA_BPM_IPT_ID FOREIGN KEY (BPM_IPT_ID) 
					 REFERENCES ' || V_ESQUEMA || '.BPM_IPT_INPUT (BPM_IPT_ID)
					 ON DELETE SET NULL)';
			EXECUTE IMMEDIATE V_MSQL;     
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ADA_ADJUNTOS_ASUNTOS ... FKs Creadas');
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