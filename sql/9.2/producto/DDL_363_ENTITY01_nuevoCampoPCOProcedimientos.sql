--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160502
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1089
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Añadir campo provincia en tabla ASU_ASUNTOS con FK a DD_PRV_PROVINCIA
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN
	    
	    	 -- ******** PCO_PRC_PROCEDIMIENTOS - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** PCO_PRC_PROCEDIMIENTOS - Añadir campos *******');
    DBMS_OUTPUT.PUT_LINE('******** PCO_PRC_PROCEDIMIENTOS - Campo prioridad *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''PCO_PRC_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||''' and column_name = ''DD_PRI_ID''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS... El campo ya existe en la tabla');
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS MODIFY(DD_PRI_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS... Modificado el campo DD_PRI_ID');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS ADD(DD_PRI_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS... Añadido el campo DD_PRI_ID');
    END IF;

    -- ******** PRC_PROCEDIMIENTOS - FKs
   V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_NAME = ''FK_DD_PRI_ID''';
   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
   -- Si existe la PK
   IF V_NUM_TABLAS = 1 THEN
           DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS ... FK ya existe');
   ELSE
           V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS  ADD (
                       CONSTRAINT FK_DD_PRI_ID FOREIGN KEY (DD_PRI_ID) 
                                REFERENCES ' || V_ESQUEMA|| '.DD_PRI_PRIORIDAD (DD_PRI_ID))';
               EXECUTE IMMEDIATE V_MSQL;     
               DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS ... FK Creada');
       END IF;

DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');
    
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

