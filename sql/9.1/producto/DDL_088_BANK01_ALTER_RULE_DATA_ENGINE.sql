--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151110
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=BKREC-1420
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
    
    --------------------------
    --   DATA_RULE_ENGINE   --
    --------------------------   
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DATA_RULE_ENGINE'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe comprobamos si existe la columna
    IF V_NUM_TABLAS = 1 THEN 
    
			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE TABLE_NAME =''DATA_RULE_ENGINE'' and owner = '''||v_esquema||''' AND COLUMN_NAME =''CAC_ACTUACION_EN_CURSO''';
			EXECUTE IMMEDIATE v_sql INTO v_num_column;	
			
			IF V_NUM_COLUMN = 0	THEN			  
			--** Modificamos la tabla
			V_MSQL := 'ALTER TABLE '||v_esquema||'.DATA_RULE_ENGINE 
					   ADD CAC_ACTUACION_EN_CURSO NUMBER(1,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.DATA_RULE_ENGINE... CAMPO CAC_ACTUACION_EN_CURSO CREADO');
		    END IF;			
   END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.DATA_RULE_ENGINE... Alter table FIN');  
    
    --Refrescamos la vista TMP_REC_PER_DATA_RULE_ENGINE
     V_SQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = ''TMP_REC_PER_DATA_RULE_ENGINE'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_view;
    --Comprobamos si existe la vista
    IF V_NUM_VIEW = 1 THEN 
          V_MSQL := 'DROP VIEW '||v_esquema||'.TMP_REC_PER_DATA_RULE_ENGINE';
		  EXECUTE IMMEDIATE V_MSQL;
		  DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_REC_PER_DATA_RULE_ENGINE... Vista borrada');
     END IF;
     V_MSQL := 'CREATE VIEW '||v_esquema||'.TMP_REC_PER_DATA_RULE_ENGINE 
					   AS SELECT * FROM '||v_esquema||'.DATA_RULE_ENGINE
					   WHERE PER_ID IN(SELECT DISTINCT (PER_ID) FROM '||v_esquema||'.TMP_REC_EXP_DESNORMALIZADO)';
	 EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_REC_PER_DATA_RULE_ENGINE... Vista creada');  	
     
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
