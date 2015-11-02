--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20151001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-58
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
    

    ---------------------------
    --  BATCH_DATOS_CNT_PER  --
    --------------------------- 
    
    --** Comprobamos si existe la tabla   

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BATCH_DATOS_CNT_PER'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.BATCH_DATOS_CNT_PER CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_PER... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_PER... Comprobaciones previas FIN');


    --** Creamos la tabla

    V_MSQL := 'CREATE GLOBAL TEMPORARY TABLE ' ||v_esquema||'.BATCH_DATOS_CNT_PER
               (
		CNT_ID    NUMBER (16)
		,PER_ID    NUMBER (16)
		,CNT_PER_TIN    VARCHAR2 (10 Char)
		,CNT_PER_OIN    INTEGER
		,CNT_PER_ARRASTRE    NUMBER (1)
               ) on commit preserve rows';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_DATOS_CNT_PER... Tabla creada');

    --** Creamos Indices
 
    V_MSQL := 'CREATE INDEX IDX_BATCH_DATOS_CNT_PER_1 ON '||v_esquema||'.BATCH_DATOS_CNT_PER (PER_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_DATOS_CNT_PER_1... Indice creado');
    V_MSQL := 'CREATE INDEX IDX_BATCH_DATOS_CNT_PER_2 ON '||v_esquema||'.BATCH_DATOS_CNT_PER (CNT_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_DATOS_CNT_PER_2... Indice creado');
    V_MSQL := 'CREATE INDEX IDX_BATCH_DATOS_CNT_PER_3 ON '||v_esquema||'.BATCH_DATOS_CNT_PER (CNT_PER_ARRASTRE)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_DATOS_CNT_PER_3... Indice creado');


    
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
    

