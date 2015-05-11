--/*
--##########################################
--## Author: Agustín Mompó
--## Finalidad: DDL de Bienes adjudicados
--##            Alter para cambiar el campo BIED_ADJ_FONDO que es un String por el 
--##            campo DD_TFO_ID	que hace referencia a un diccionario de datos
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
    -- Vble. para validar la existencia de las Secuencias.
    seq_count number(3);
    -- Vble. para validar la existencia de las Tablas.    
    table_count number(3);
    -- Vble. para validar la existencia de las Columnas.    
    v_column_count number(3);
    -- Vble. para validar la existencia de las Constraints.    
    v_constraint_count number(3);
    -- Esquema hijo
    v_schema_name string(50);
    -- Número de errores
    err_num NUMBER;
    -- Mensaje de error
    err_msg VARCHAR2(2048);    

BEGIN

seq_count := 0;
table_count := 0;
v_column_count := 0;
v_schema_name := 'BANK01';

DBMS_OUTPUT.PUT_LINE('[START] Modificar tabla BIE_ADJ_ADJUDICACION');

select count(1) into table_count from all_tables where table_name = 'BIE_ADJ_ADJUDICACION';

if table_count = 1 then
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.BIE_ADJ_ADJUDICACION... Existe');
    
    -- Borrar la columna BIE_ADJ_FONDO
    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_adj_adjudicacion' and LOWER(column_name) = 'bie_adj_fondo';
    if v_column_count = 1 then
    	execute immediate 'ALTER TABLE ' || v_schema_name || '.BIE_ADJ_ADJUDICACION DROP COLUMN BIE_ADJ_FONDO';
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_FONDO Borrada');
	else
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.BIE_ADJ_ADJUDICACION... La Columna BIE_ADJ_FONDO no existe');	
	end if;
	
	-- Crear la nueva columna DD_TFO_ID
    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_adj_adjudiciacion' and LOWER(column_name) = 'dd_tfo_id';
    if v_column_count = 0 then
    	execute immediate 'ALTER TABLE ' || v_schema_name || '.BIE_ADJ_ADJUDICACION ADD (DD_TFO_ID NUMBER(16))';
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.BIE_ADJ_ADJUDICACION... Columna DD_TFO_ID Añadida');
	    
	    -- Crear la FK de dicha columna
		select count(1) into v_constraint_count from all_constraints where constraint_name = 'FK_BIE_ADJ_TFO_ID' and owner='BANK01';
		if v_constraint_count = 0 then
	  		execute immediate 'ALTER TABLE '||v_schema_name||'.BIE_ADJ_ADJUDICACION ADD CONSTRAINT FK_BIE_ADJ_TFO_ID FOREIGN KEY (DD_TFO_ID) REFERENCES '||v_schema_name||'.DD_TFO_TIPO_FONDO (DD_TFO_ID)';
	  		DBMS_OUTPUT.PUT_LINE('Foreing Key FK_BIE_ADJ_TFO_ID Creada');
		end if;
	else
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.BIE_ADJ_ADJUDICACION... La Columna BIE_ADJ_FONDO no existe');	
	end if;

end if;

COMMIT;
              
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;
        
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          
          ROLLBACK;
          RAISE;
           
END;
/
