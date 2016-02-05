--/*
--##########################################
--## AUTOR=Óscar
--## FECHA_CREACION=20151217
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.19-bk
--## INCIDENCIA_LINK=BKREC-1586
--## PRODUCTO=SI
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
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
    --  REA_ID_REDUCIDO  --
    ------------------------------   
    
    --** Comprobamos si existe la tabla   

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''PRF_PROCESO_FACTURACION'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
 
    IF V_NUM_TABLAS = 1 THEN 
    
		    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME LIKE ''REA_ID_REDUCIDO'' AND TABLE_NAME= ''PRF_PROCESO_FACTURACION'' AND OWNER ='''||v_esquema||'''';
			EXECUTE IMMEDIATE v_sql INTO v_num_column;
			
			IF v_num_column = 0 THEN 
					
				   V_MSQL := 'ALTER TABLE '||v_esquema||'.PRF_PROCESO_FACTURACION ADD (REA_ID_REDUCIDO  NUMBER(16))';
				   EXECUTE IMMEDIATE V_MSQL;				  
				   DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.REA_ID_REDUCIDO... Campo Creado');
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