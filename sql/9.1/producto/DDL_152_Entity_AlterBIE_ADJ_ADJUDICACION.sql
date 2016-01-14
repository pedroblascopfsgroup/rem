--/*
--##########################################
--## AUTOR=NACHO ARCOS
--## FECHA_CREACION=20160114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1482
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN
	    
	    	 -- ******** BIE_ADJ_ADJUDICACION - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** BIE_ADJ_ADJUDICACION - Añadir campos *******');
    
    V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''BIE_ADJ_ADJUDICACION'' and owner = '''||V_ESQUEMA||''' and column_name = ''BIE_ADJ_F_CONTABILIDAD''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe el campo lo indicamos sino lo creamos
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... El campo ya existe en la tabla');
    ELSE
        V_MSQL := 'alter table '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION add(BIE_ADJ_F_CONTABILIDAD NUMBER(16))';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Añadido el campo BIE_ADJ_F_CONTABILIDAD');
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