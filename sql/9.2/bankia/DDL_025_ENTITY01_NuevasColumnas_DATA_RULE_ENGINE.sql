--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.4
--## INCIDENCIA_LINK=PRODUCTO-1442
--## PRODUCTO=SI
--## Finalidad: DDL
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN
	    
	    	 -- ******** DATA_RULE_ENGINE - Añadir campos para personas*******
	 
    DBMS_OUTPUT.PUT_LINE('******** DATA_RULE_ENGINE - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DATA_RULE_ENGINE'' and owner = '''||V_ESQUEMA||''' and (column_name = ''TAF_PER_SIN_ACCION'' OR column_name = ''TAF_PER_NO_LOCALIZADO'' OR column_name = ''TAF_PER_CNTDO_NEG'' OR column_name = ''TAF_PER_COM_PGO'' OR column_name = ''TAF_PER_ADECUACION'' OR column_name = ''TAF_PER_DACION'' OR column_name = ''TAF_PER_CNCL_QUITA'' OR column_name = ''TAF_PER_PASE_LIT'' OR column_name = ''TAF_PER_PRE_FAIL''OR column_name = ''TAF_PER_LOCALIZABLE'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS > 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DATA_RULE_ENGINE... El campo ASU_ID_ORIGEN ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE ADD(TAF_PER_SIN_ACCION NUMBER(1),TAF_PER_NO_LOCALIZADO NUMBER(1),TAF_PER_CNTDO_NEG NUMBER(1),TAF_PER_COM_PGO NUMBER(1),TAF_PER_ADECUACION NUMBER(1),TAF_PER_DACION NUMBER(1),TAF_PER_CNCL_QUITA NUMBER(1),TAF_PER_PASE_LIT NUMBER(1),TAF_PER_PRE_FAIL NUMBER(1),TAF_PER_LOCALIZABLE NUMBER(1))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DATA_RULE_ENGINE... Añadido los campos para persona');
    END IF;
    
    	    	 -- ******** DATA_RULE_ENGINE - Añadir campos para contratos*******
	 
    DBMS_OUTPUT.PUT_LINE('******** DATA_RULE_ENGINE - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''DATA_RULE_ENGINE'' and owner = '''||V_ESQUEMA||''' and (column_name = ''TAF_CNT_SIN_ACCION'' OR column_name = ''TAF_CNT_NO_LOCALIZADO'' OR column_name = ''TAF_CNT_CNTDO_NEG'' OR column_name = ''TAF_CNT_COM_PGO'' OR column_name = ''TAF_CNT_ADECUACION'' OR column_name = ''TAF_CNT_DACION'' OR column_name = ''TAF_CNT_CNCL_QUITA'' OR column_name = ''TAF_CNT_PASE_LIT'' OR column_name = ''TAF_CNT_PRE_FAIL''OR column_name = ''TAF_CNT_LOCALIZABLE'') ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS > 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DATA_RULE_ENGINE... El campo ASU_ID_ORIGEN ya existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE ADD(TAF_CNT_SIN_ACCION NUMBER(1),TAF_CNT_NO_LOCALIZADO NUMBER(1),TAF_CNT_CNTDO_NEG NUMBER(1),TAF_CNT_COM_PGO NUMBER(1),TAF_CNT_ADECUACION NUMBER(1),TAF_CNT_DACION NUMBER(1),TAF_CNT_CNCL_QUITA NUMBER(1),TAF_CNT_PASE_LIT NUMBER(1),TAF_CNT_PRE_FAIL NUMBER(1),TAF_CNT_LOCALIZABLE NUMBER(1))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DATA_RULE_ENGINE... Añadido los campos para contratos');
    END IF;


DBMS_OUTPUT.PUT_LINE('[INFO] Fin script.');

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
