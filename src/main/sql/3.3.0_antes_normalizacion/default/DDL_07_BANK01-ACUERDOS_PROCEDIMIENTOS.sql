--/*
--##########################################
--## Author: Agustín Mompó
--## Finalidad: DDL de Acuerdos de procedimientos
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


DBMS_OUTPUT.PUT_LINE('[START] Modificar tabla ACU_ACUEDO_PROCEDIMIENTOS');

select count(1) into table_count from all_tables where table_name = 'ACU_ACUERDO_PROCEDIMIENTOS';

if table_count = 1 then
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.ACU_ACUERDO_PROCEDIMIENTOS... Existe');
    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'acu_acuerdo_procedimientos' and LOWER(column_name) = 'acu_fecha_limite';
    if v_column_count = 0 then
    	execute immediate 'ALTER TABLE ' || v_schema_name || '.ACU_ACUERDO_PROCEDIMIENTOS ADD (ACU_FECHA_LIMITE  DATE)';
	    DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.ACU_ACUERDO_PROCEDIMIENTOS... Columna ACU_FECHA_LIMITE Añadida');
	else
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || v_schema_name || '.ACU_ACUERDO_PROCEDIMIENTOS... La Columna ACU_FECHA_LIMITE ya existe');	
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
