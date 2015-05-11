-- ##########################################
-- ## Author: Javier Ruiz
-- ## Finalidad: Corregir obtención importe concepto cobro 'capital no vencido'
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

  	select count(1) into table_count from RCF_DD_COC_CONCEPTO_COBRO WHERE RCF_DD_COC_CODIGO = 'NVC';
	if table_count = 1 then
		query_body := 'UPDATE ' || schema_name || '.RCF_DD_COC_CONCEPTO_COBRO SET RCF_DD_COC_CPA_CONCEP_IMPORT = ''CPA_CAPITAL_NO_VENCIDO'' WHERE RCF_DD_COC_CODIGO = ''NVC''';
		EXECUTE IMMEDIATE query_body;
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
