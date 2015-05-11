-- ##########################################
-- ## Author: Pepe Company
-- ## Finalidad: Inserta 'RULES' en varios perfiles
-- ## 
-- ## INSTRUCCIONES:
-- ## VERSIONES:
-- ##        0.1 Version inicial
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
-- Insertamos nuevas variables necesarias
-- ###########################      

  	select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=177;
	if table_count = 0 then
 		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (177, ''Toda la Deuda irregular del cliente es de domiciliación externa (0/1)'', ''PER_DOMICI_EXT'', ''compare1'', ''number'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;

 	select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=178;
	if table_count = 0 then
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (178, ''Toda la Deuda irregular del cliente es de descubiertos (0/1)'', ''PER_DEUDA_DESC'', ''compare1'', ''number'', ''Persona'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;

    select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=179;
	if table_count = 0 then
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (179, ''Scoring'', ''mov_scoring'', ''compare1'', ''text'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;

    select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=180;
	if table_count = 0 then
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (180, ''Entidad Propietaria Contrato'', ''ent_propie'', ''compare1'', ''text'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;
	
	select count(1) into table_count from DD_RULE_DEFINITION WHERE RD_ID=181;
	if table_count = 0 then
		query_body := 'Insert into '||schema_name||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_TAB, USUARIOCREAR, FECHACREAR, BORRADO) Values  (181, ''Segmento Cartera'', ''segmento_cartera'', ''compare1'', ''number'', ''Contrato'', ''PCOMPANY'', SYSDATE, 0)';  EXECUTE IMMEDIATE query_body;
	end if;

COMMIT;
    


-- ##################################################  
-- Reactivamos la variable de PER_DEUDA_IRREGULAR_DIR
-- ##################################################  

	select count(1) into table_count from DD_RULE_DEFINITION WHERE rd_column= 'PER_DEUDA_IRREGULAR_DIR' and borrado=1;
	if table_count > 0 then
		query_body := 'update '||schema_name||'.DD_RULE_DEFINITION set rd_tab=''Riesgo'', borrado=0, usuarioborrar=null, fechaborrar=null where rd_column= ''PER_DEUDA_IRREGULAR_DIR'''; EXECUTE IMMEDIATE query_body;
		query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Deuda irregular de la persona (1 valor)'' WHERE RD_ID=132'; EXECUTE IMMEDIATE query_body; 
		query_body := 'UPDATE '||schema_name||'.DD_RULE_DEFINITION SET RD_TITLE=''Deuda irregular de la persona (2 valores)'' WHERE RD_ID=133'; EXECUTE IMMEDIATE query_body;
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
