--/*
--##########################################
--## AUTOR=JOSE MANUEL PEREZ BARBERA
--## FECHA_CREACION=20160614
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2196
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Modificar tamaño campo BATCH_JOB_VALIDATION.JOB_VAL_VALUE
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
	    
	    	 -- ******** ASU_ASUNTOS - Añadir campos *******
	 
    DBMS_OUTPUT.PUT_LINE('******** BATCH_JOB_VALIDATION - modificar campo *******');
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''JOB_VAL_VALUE'' AND TABLE_NAME = ''BATCH_JOB_VALIDATION'' AND OWNER = '''||V_ESQUEMA_M||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existen los campos lo indicamos sino los creamos
    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.BATCH_JOB_VALIDATION... El campo no existe en la tabla');
    ELSE
        V_MSQL := 'ALTER TABLE '||V_ESQUEMA_M||'.BATCH_JOB_VALIDATION MODIFY JOB_VAL_VALUE VARCHAR2(4000CHAR)';        
        DBMS_OUTPUT.PUT_LINE(V_MSQL);
        EXECUTE IMMEDIATE V_MSQL; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.BATCH_JOB_VALIDATION... Ampliado el campo JOB_VAL_VALUE a 4000CHAR');
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
