--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20150515
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.10.13
--## INCIDENCIA_LINK=BCFI-614/613
--## PRODUCTO=SI
--## Finalidad: DML
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
BEGIN

     --** Agregamos nuevo atributo:  PER_PRECALCULO_ARQ.DD_TCN_ID
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''PER_PRECALCULO_ARQ'' and (UPPER(column_name) = ''DD_TCN_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
         
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.PER_PRECALCULO_ARQ
                              ADD (DD_TCN_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] PER_PRECALCULO_ARQ... Modificada - Añadida columna DD_TCN_ID');  
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] PER_PRECALCULO_ARQ... Columna DD_TCN_ID ya existe.');                 
    end if;
    
     
     --** Agregamos nuevo atributo:  CNT_PRECALCULO_ARQ.DD_MRF_ID
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''CNT_PRECALCULO_ARQ'' and (UPPER(column_name) = ''DD_MRF_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
         
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.CNT_PRECALCULO_ARQ
                              ADD (DD_MRF_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] CNT_PRECALCULO_ARQ... Modificada - Añadida columna DD_MRF_ID');   
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] CNT_PRECALCULO_ARQ... Columna DD_MRF_ID ya existe.');                
    end if;
    
    
    --** Agregamos nuevo atributo:  CNT_PRECALCULO_ARQ.DD_MOM_ID
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''CNT_PRECALCULO_ARQ'' and (UPPER(column_name) = ''DD_MOM_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
         
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.CNT_PRECALCULO_ARQ
                              ADD (DD_MOM_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] CNT_PRECALCULO_ARQ... Modificada - Añadida columna DD_MOM_ID');   
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] CNT_PRECALCULO_ARQ... Columna DD_MOM_ID ya existe.');                
    end if;
    
    
    --** Agregamos nuevo atributo:  CNT_PRECALCULO_ARQ.DD_IDN_ID
    
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''CNT_PRECALCULO_ARQ'' and (UPPER(column_name) = ''DD_IDN_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
            
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.CNT_PRECALCULO_ARQ
                              ADD (DD_IDN_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] CNT_PRECALCULO_ARQ... Modificada - Añadida columna DD_IDN_ID'); 
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] CNT_PRECALCULO_ARQ... Columna DD_IDN_ID ya existe.');                  
    end if;
    
     --** Agregamos nuevo atributo:  DATA_RULE_ENGINE.DD_TCN_ID
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''DATA_RULE_ENGINE'' and (UPPER(column_name) = ''DD_TCN_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
         
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE
                              ADD (DD_TCN_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Modificada - Añadida columna DD_TCN_ID');                   
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Columna DD_TCN_ID ya existe.');  
    end if;
    
     
     --** Agregamos nuevo atributo:  DATA_RULE_ENGINE.DD_MRF_ID
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''DATA_RULE_ENGINE'' and (UPPER(column_name) = ''DD_MRF_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
         
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE
                              ADD (DD_MRF_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Modificada - Añadida columna DD_MRF_ID');   
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Columna DD_MRF_ID ya existe.');
    end if;
    
    
    --** Agregamos nuevo atributo:  DATA_RULE_ENGINE.DD_MOM_ID
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''DATA_RULE_ENGINE'' and (UPPER(column_name) = ''DD_MOM_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
         
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE
                              ADD (DD_MOM_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Modificada - Añadida columna DD_MOM_ID');   
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Columna DD_MOM_ID ya existe.');
    end if;
    
    
    --** Agregamos nuevo atributo:  DATA_RULE_ENGINE.DD_IDN_ID
    
     V_NUM_TABLAS := 0;
     EXECUTE IMMEDIATE 'SELECT COUNT(1)  
                        FROM all_tab_cols 
                        WHERE UPPER(table_name) = ''DATA_RULE_ENGINE'' and (UPPER(column_name) = ''DD_IDN_ID'')
                        AND OWNER = '''||V_ESQUEMA||'''' 
     INTO V_NUM_TABLAS;
            
     if V_NUM_TABLAS = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE
                              ADD (DD_IDN_ID NUMBER (16))';
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Modificada - Añadida columna DD_IDN_ID');    
    else 
        DBMS_OUTPUT.PUT_LINE('[INFO] DATA_RULE_ENGINE... Columna DD_IDN_ID ya existe.');
    end if;

    
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