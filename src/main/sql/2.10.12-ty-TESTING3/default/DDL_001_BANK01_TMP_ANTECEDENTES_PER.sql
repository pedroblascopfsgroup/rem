SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
   
    V_MSQL VARCHAR2(12000 CHAR);
    
BEGIN

   SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES 
    WHERE UPPER(table_name) = 'TMP_ANTECEDENTES_PER' 
      AND OWNER = 'BANK01';
         
    if TABLE_COUNT > 0 then 
    
          DBMS_OUTPUT.PUT_LINE ('[INFO] '||v_esquema||'.TMP_ANTECEDENTES_PER Existe');
          V_MSQL := 'DROP TABLE '||v_esquema||'.TMP_ANTECEDENTES_PER';
          Execute Immediate V_MSQL;
          DBMS_OUTPUT.PUT_LINE ('[INFO] '||v_esquema||'.TMP_ANTECEDENTES_PER Dropped');
          
    else
          DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_ANTECEDENTES_PER No existe');
          
    End if;
    
  V_MSQL := 'CREATE GLOBAL TEMPORARY TABLE '||v_esquema||'.TMP_ANTECEDENTES_PER
            ( PER_ID  NUMBER(16)
            , ANT_ID  NUMBER(16)
            , ANT_REINCIDENCIA_INTERNOS  NUMBER(16) 
            ) ON COMMIT PRESERVE ROWS
            ';                             
  Execute Immediate V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Globa Temporaly table '||v_esquema||'.TMP_ANTECEDENTES_PER Created');
  V_MSQL := 'Create unique index IDX_TMP_ANTECEDENTES_PER_ID on '||v_esquema||'.TMP_ANTECEDENTES_PER(PER_ID)';
  Execute Immediate V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Index IDX_TMP_ANTECEDENTES_PER_ID Created');
  V_MSQL := 'Create unique index IDX_TMP_ANTECEDENTES_ANT_ID on '||v_esquema||'.TMP_ANTECEDENTES_PER(ANT_ID)';
  Execute Immediate V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Index IDX_TMP_ANTECEDENTES_ANT_ID Created');          
          
EXCEPTION

  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci�n:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;

END;