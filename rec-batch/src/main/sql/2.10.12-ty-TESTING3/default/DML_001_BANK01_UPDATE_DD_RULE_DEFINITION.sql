SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
   
    V_MSQL VARCHAR2(12000 CHAR);
    
BEGIN
    
  V_MSQL := 'Update '||v_esquema||'.DD_RULE_DEFINITION
             Set rd_column = ''ant_reincidencia_internos''
             where rd_title in
            (''Reincidencia de los Antecedentes Internos de la Persona (1 valor)''
            ,''Reincidencia de los Antecedentes Internos de la Persona (2 valores)'')
            ';                             
  Execute Immediate V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||v_esquema||'.DD_RULE_DEFINITION actualizada');
  COMMIT;
         
          
EXCEPTION

  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci�n:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;

END;