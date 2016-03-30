--/*
--##########################################
--## AUTOR=LUIS CABALLERO
--## FECHA_CREACION=20160322
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-953
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Añadir campos tipo Entrega y Concepto en tabla CPA_COBROS_PAGOS con FK a DD_ATE_ADJ_TPO_ENTREGA y DD_ACE_ADJ_CONCEPTO_ENTREGA
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
	    
	    	 -- ******** ASU_ASUNTOS - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** CPA_COBROS_PAGOS - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''CPA_COBROS_PAGOS'' and owner = '''||V_ESQUEMA||''' and (column_name = ''DD_ATE_ID'' or column_name = ''DD_ACE_ID'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS >= 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CPA_COBROS_PAGOS... Los campos ya existen en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.CPA_COBROS_PAGOS ADD(DD_ATE_ID NUMBER(16), DD_ACE_ID NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CPA_COBROS_PAGOS... Añadidos los campos DD_ATE_ID y DD_ACE_ID');
    END IF;

		-- ********** ASU_ASUNTOS - FKs
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''CPA_COBROS_PAGOS'' and owner = '''||V_ESQUEMA||''' and (CONSTRAINT_NAME = ''FK_CPA_DD_ATE'' or CONSTRAINT_NAME = ''FK_CPA_DD_ACE'')';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS >= 1 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CPA_COBROS_PAGOS ... FK ya existen');
    ELSE
	    V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.CPA_COBROS_PAGOS  ADD (
			CONSTRAINT FK_CPA_DD_ATE FOREIGN KEY (DD_ATE_ID) 
				 REFERENCES ' || V_ESQUEMA || '.DD_ATE_ADJ_TPO_ENTREGA (DD_ATE_ID),
			CONSTRAINT FK_CPA_DD_ACE FOREIGN KEY (DD_ACE_ID) 
				 REFERENCES ' || V_ESQUEMA || '.DD_ACE_ADJ_CONCEPTO_ENTREGA (DD_ACE_ID))';
			
		EXECUTE IMMEDIATE V_MSQL;     
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CPA_COBROS_PAGOS ... FKs Creadas');
	END IF;

DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

    ROLLBACK;
    
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
