--/*
--##########################################
--## AUTOR=CARLOS LOPEZ
--## FECHA_CREACION=20160330
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2916
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
	WHERE TABLE_NAME = 'SALIDAS_ONLINE_CNT'
	AND COLUMN_NAME = 'OBSERVACIONES';
    
    IF V_EXISTE = 0 THEN
		--** Creamos la columna NUMDIASAPLAZAMIENTO
		V_MSQL := 'ALTER TABLE '||v_esquema||'.SALIDAS_ONLINE_CNT ADD OBSERVACIONES VARCHAR2(2000 CHAR)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.SALIDAS_ONLINE_CNT creada columna OBSERVACIONES VARCHAR2(2000 CHAR)');	     
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
