--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151202
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.18-bk
--## INCIDENCIA_LINK=BKREC-525
--## PRODUCTO=SI
--## Finalidad: DDL añadir columna DPR_NUM_DIA a la tabla ACN_ANTECED_CONTRATOS
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

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_VIEW     NUMBER(16); -- Vble. para validar la existencia de una vista.
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
    
    --------------------------------
    --   ACN_ANTECED_CONTRATOS   --
    --------------------------------   
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACN_ANTECED_CONTRATOS'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe comprobamos si existe la columna
    IF V_NUM_TABLAS = 1 THEN 
    
			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME =''ACN_ANTECED_CONTRATOS'' and owner = '''||v_esquema||''' 
			AND COLUMN_NAME =''DPR_NUM_DIA''';
			EXECUTE IMMEDIATE v_sql INTO v_num_column;	
			
			IF V_NUM_COLUMN = 0	THEN			  
			--** Modificamos la tabla
			V_MSQL := 'ALTER TABLE '||v_esquema||'.ACN_ANTECED_CONTRATOS 
					   ADD DPR_NUM_DIA NUMBER';
					   
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.ACN_ANTECED_CONTRATOS... CAMPO DPR_NUM_DIA AÑADIDO');
		    END IF;
		    			
   END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.ACN_ANTECED_CONTRATOS... Alter table FIN'); 
  	
     
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
