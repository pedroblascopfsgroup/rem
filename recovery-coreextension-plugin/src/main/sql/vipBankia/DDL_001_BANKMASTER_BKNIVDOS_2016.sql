--/*
--##########################################
--## AUTOR=ALBERTO_RAMIREZ
--## Finalidad: Creación de clave primaria en DD_CIC_CODIGO_ISO_CIRBE_BKP 
--## INSTRUCCIONES: Relanzable.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

whenever sqlerror exit sql.sqlcode;


--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
v_schema   VARCHAR(25) := '#ESQUEMA#';
v_schema_MASTER VARCHAR(25) := '#ESQUEMA_MASTER#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN



DBMS_OUTPUT.PUT_LINE('[START]  Tabla DD_CIC_CODIGO_ISO_CIRBE_BKP');

 
EXECUTE IMMEDIATE 'select count(*)
from(
SELECT consa.constraint_name, colsa.table_name table_a,  colsa.column_name column_a,consa.status, consa.owner
                    FROM all_constraints consa
                        inner join all_cons_columns colsa on consa.constraint_name = colsa.constraint_name and consa.owner = colsa.owner
                    WHERE colsa.table_name = ''DD_CIC_CODIGO_ISO_CIRBE_BKP'' 
                    AND consa.constraint_type = ''P''
                    AND consa.owner = '''||v_schema_MASTER||''')' into v_table_count;    
    
 if v_table_count > 0 then
 	DBMS_OUTPUT.PUT_LINE('[INFO] YA existe la clave primaria en DD_CIC_CODIGO_ISO_CIRBE_BKP');
 else
    EXECUTE IMMEDIATE 'ALTER TABLE '||v_schema_MASTER||'.DD_CIC_CODIGO_ISO_CIRBE_BKP ADD CONSTRAINT PK_DD_CIC_CODIGO_ISO_CIRBE_BKP PRIMARY KEY (DD_CIC_ID)';
 	DBMS_OUTPUT.PUT_LINE('[INFO] Clave primaria en DD_CIC_CODIGO_ISO_CIRBE_BKP creada corretamente');
 end if;


EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
          


END;
/

EXIT