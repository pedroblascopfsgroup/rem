--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ
--## FECHA_CREACION=20160215
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1714
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
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
    ITABLE_SPACE   VARCHAR(25) := '#TABLESPACE_INDEX#';
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_EXISTE   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
    
    ---------------------
    --  CTRO_INFOR_CALCULO_KPIS_CONVIV   --
    --------------------- 
    
    SELECT COUNT(*) INTO V_EXISTE FROM ALL_TAB_COLUMNS
	WHERE TABLE_NAME = 'CTRO_INFOR_CALCULO_KPIS_CONVIV'
	AND COLUMN_NAME = 'NUMDIASAPLAZAMIENTO';
    
    IF V_EXISTE > 0 THEN
		--** Modificamos el tipo de campo NUMDIASAPLAZAMIENTO
		V_MSQL := 'ALTER TABLE '||v_esquema||'.CTRO_INFOR_CALCULO_KPIS_CONVIV
								  MODIFY NUMDIASAPLAZAMIENTO NUMBER(5,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.CTRO_INFOR_CALCULO_KPIS_CONVIV cambiado tipo de campo NUMDIASAPLAZAMIENTO a number(5,0)');	    
    ELSE
		--** Creamos la columna NUMDIASAPLAZAMIENTO
		V_MSQL := 'ALTER TABLE '||v_esquema||'.CTRO_INFOR_CALCULO_KPIS_CONVIV
								  ADD NUMDIASAPLAZAMIENTO NUMBER(5,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.CTRO_INFOR_CALCULO_KPIS_CONVIV creada columna NUMDIASAPLAZAMIENTO number(5,0)');	     
    END IF;
    
    ---------------------
    --  TMP_CNT_CALCULO_KPIS_CONVIV   --
    --------------------- 
    
    SELECT COUNT(*) INTO V_EXISTE FROM ALL_TAB_COLUMNS
	WHERE TABLE_NAME = 'TMP_CNT_CALCULO_KPIS_CONVIV'
	AND COLUMN_NAME = 'NUMDIASAPLAZAMIENTO';
    
    IF V_EXISTE > 0 THEN
		--** Modificamos el tipo de campo NUMDIASAPLAZAMIENTO
		V_MSQL := 'ALTER TABLE '||v_esquema||'.TMP_CNT_CALCULO_KPIS_CONVIV
								  MODIFY NUMDIASAPLAZAMIENTO NUMBER(5,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_CNT_CALCULO_KPIS_CONVIV cambiado tipo de campo NUMDIASAPLAZAMIENTO a number(5,0)');	    
    ELSE
		--** Creamos la columna NUMDIASAPLAZAMIENTO
		V_MSQL := 'ALTER TABLE '||v_esquema||'.TMP_CNT_CALCULO_KPIS_CONVIV
								  ADD NUMDIASAPLAZAMIENTO NUMBER(5,0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_CNT_CALCULO_KPIS_CONVIV creada columna NUMDIASAPLAZAMIENTO number(5,0)');	     
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
