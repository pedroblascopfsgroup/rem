--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20151203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.18-bk
--## INCIDENCIA_LINK=BKREC-601
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
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_COLUMN   NUMBER(16); -- Vble. para validar la existencia de una columna.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar   

BEGIN


    ------------------------------
    --  TMP_REC_CONTRATOS_BAJA  --
    ------------------------------   
    
    --** Comprobamos si existe la tabla   

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_REC_CONTRATOS_BAJA'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
 
    IF V_NUM_TABLAS = 1 THEN 
    
		    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME LIKE ''ID_ENVIO'' AND TABLE_NAME= ''TMP_REC_CONTRATOS_BAJA'' AND OWNER ='''||v_esquema||'''';
			EXECUTE IMMEDIATE v_sql INTO v_num_column;
			
			IF v_num_column = 0 THEN 
					
				   V_MSQL := 'TRUNCATE TABLE '||v_esquema||'.TMP_REC_CONTRATOS_BAJA';
				   EXECUTE IMMEDIATE V_MSQL;
				   V_MSQL := 'ALTER TABLE '||v_esquema||'.TMP_REC_CONTRATOS_BAJA
				   ADD ID_ENVIO NUMBER(24,0) NOT NULL';
				   EXECUTE IMMEDIATE V_MSQL;
				   
	       END IF;
	        
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_REC_CONTRATOS_BAJA... Campo Creado');
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
    
