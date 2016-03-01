--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20160301
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0-cj-rc37
--## INCIDENCIA_LINK=CMREC-2328
--## PRODUCTO=SI
--## Finalidad: DDL Modificacion de la tabla PCO_PRC_PROCEDIMIENTOS
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
  
    BEGIN
	    
	
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PCO_PRC_PROCEDIMIENTOS'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla procedemos a modificarla
    IF V_NUM_TABLAS = 1 THEN
    		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = ''PCO_PRC_PROCEDIMIENTOS'' AND OWNER = '''||V_ESQUEMA||''' AND COLUMN_NAME = ''PCO_PRC_NOM_EXP_JUD''';
    		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    		--si no existe la columna la creamos
    		IF V_NUM_TABLAS = 0 THEN
	            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS ADD PCO_PRC_NOM_EXP_JUD VARCHAR2(250)';
	            EXECUTE IMMEDIATE V_MSQL;
	            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS columna PCO_PRC_NOM_EXP_JUD añadida');
	        ELSE
	    	    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_PRC_PROCEDIMIENTOS MODIFY PCO_PRC_NOM_EXP_JUD VARCHAR2(250)';
	            EXECUTE IMMEDIATE V_MSQL;
	        	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS columna PCO_PRC_NOM_EXP_JUD modificada');
	        END IF;	
    ELSE	
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PCO_PRC_PROCEDIMIENTOS... La tabla NO existe.');
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