--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151014
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-1099
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
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    

BEGIN
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BI_FACTU'' and owner = '''||v_esquema||'''
             ';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe añadimos el campo
    IF V_NUM_TABLAS = 0
     THEN 
       DBMS_OUTPUT.PUT_LINE('[ERROR] '||v_esquema||'.BI_FACTU. La tabla no existe.');
     ELSE
       --** Comprobamos si existe la columna
       V_NUM_TABLAS := 0;
       V_SQL := 'SELECT COUNT(1) 
                   FROM ALL_TAB_COLUMNS 
                  WHERE TABLE_NAME = ''BI_FACTU'' 
                    AND OWNER = '''||v_esquema||'''
                    AND COLUMN_NAME = ''CPA_ID''
                ';
       EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
       
       IF V_NUM_TABLAS = 1 
        THEN
         DBMS_OUTPUT.PUT_LINE('[WARN] '||v_esquema||'.BI_FACTU. El atributo CPA_ID ya existe.');
        ELSE        								  
			--** Modificamos la tabla
			V_MSQL := 'ALTER TABLE '||v_esquema||'.BI_FACTU 
					   ADD CPA_ID NUMBER(16,0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BI_FACTU... CAMPO CPA_ID CREADO');
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
