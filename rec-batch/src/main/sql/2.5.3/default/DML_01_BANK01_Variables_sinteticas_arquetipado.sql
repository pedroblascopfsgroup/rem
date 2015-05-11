-- ##########################################
-- ## Author: Guillem Pascual
-- ## Finalidad: Configurar las nuevas variables sintéticas
-- ## 
-- ## INSTRUCCIONES:
-- ## VERSIONES:
-- ##        1.0 Version inicial
-- ##########################################

DECLARE
    -- Vble. para validar la existencia de las Secuencias.
    seq_count number(3);
    -- Vble. para validar la existencia de las Tablas.
    table_count number(3);
    -- Vble. para validar la existencia de las Columnas.
    column_count number(3);   
    -- Esquema hijo
    schema_name varchar(50);
    -- Esquema padre
    schema_master_name varchar(50);
    -- Querys
    query_body varchar (30048);
    -- Nzmero de errores
    err_num NUMBER;
    -- Mensaje de error
    err_msg VARCHAR2(2048);
BEGIN
    -- ###########################    
    
    schema_name := 'BANK01';
--     schema_master_name := 'BANKMASTER';

-- ###########################  
-- Insertamos nuevas variables sintéticas necesarias
-- ###########################      

    -- Deuda irregular (total) en hipotecarios
  	select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=182;
	if table_count = 0 then
 		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (182, ''Deuda irregular (total) en hipotecarios'', ''PER_DEUDA_IRREGULAR_HIPO'', ''compare2'', ''number'', ''Riesgo'', ''GUILLEM'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;

	-- Días irregular (máximo) de hipotecarios
 	select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=183;
	if table_count = 0 then
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (183, ''Días irregular (máximo) de hipotecarios'', ''CNT_DIAS_IRREGULAR_HIPO'', ''compare2'', ''number'', ''Contrato'', ''GUILLEM'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;
	
	-- Colectivo singular 0/1
 	select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=184;
	if table_count = 0 then
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (184, ''Colectivo Singular 0/1'', ''COLECTIVO_SINGULAR'', ''compare1'', ''number'', ''Persona'', ''GUILLEM'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;

COMMIT;
    

EXCEPTION  
    WHEN OTHERS THEN
      
      err_num := SQLCODE;
      err_msg := SQLERRM;
    
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(err_num));
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(err_msg);
      
      ROLLBACK;
      RAISE;
END;
/
