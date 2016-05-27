--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160509
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3316
--## PRODUCTO=NO
--## 
--## Finalidad: CREA INDICE EN CIR_CIRBE
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
    ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
    
    ---------------------
    --  TMP_CNT_PER   --
    --------------------- 
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'select count(1) from ALL_CONSTRAINTS where constraint_name = ''PK_TMP_CNT_PER'' and owner = upper('''||v_esquema||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
    V_MSQL := 'ALTER TABLE '||v_esquema||'.TMP_CNT_PER
						DROP CONSTRAINT PK_TMP_CNT_PER';        
    EXECUTE IMMEDIATE V_MSQL;
    	END IF;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_CNT_PER PK BORRADA...');
    
        --** Comprobamos si existe la tabla   
    V_SQL := 'select count(1) from ALL_indexes where index_name = ''PK_TMP_CNT_PER''  and owner = upper('''||v_esquema||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
    V_MSQL := 'DROP index '||v_esquema||'.PK_TMP_CNT_PER';        
    EXECUTE IMMEDIATE V_MSQL;
    END IF;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_CNT_PER INDICE PK BORRADO...');
    

    V_MSQL := 'ALTER TABLE '||v_esquema||'.TMP_CNT_PER
    ADD CONSTRAINT PK_TMP_CNT_PER PRIMARY KEY (
    TMP_CNT_PER_COD_PERSONA,
    TMP_CNT_PER_NUM_CONTRATO,
    TMP_CNT_PER_TIPO_INTERVENCION)';        
    EXECUTE IMMEDIATE V_MSQL;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_CNT_PER NUEVA PK BORRADA...');



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
