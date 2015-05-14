--/*
--##########################################
--## AUTOR=ALBERTO RAMIREZ
--## FECHA_CREACION=20150513
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=
--## INCIDENCIA_LINK=BKNIVDOS-2016
--## PRODUCTO=SI
--##
--## Finalidad: Eliminar clave ajena en BIE_LOCALIZACION que apunta a la tabla DD_CIC_CODIGO_ISO_CIRBE
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



DBMS_OUTPUT.PUT_LINE('[START] Tabla BIE_LOCALIZACION');

EXECUTE IMMEDIATE 'select count(*)
from(
SELECT consa.constraint_name, colsa.table_name table_a,  colsa.column_name column_a, consb.table_name table_b, colsb.column_name column_b, consa.status, consa.owner
                    FROM all_constraints consa
                        inner join all_constraints consb on consa.r_constraint_name = consb.constraint_name
                        inner join all_cons_columns colsa on consa.constraint_name = colsa.constraint_name and consa.owner = colsa.owner
                        inner join all_cons_columns colsb on consa.r_constraint_name = colsb.constraint_name and consb.owner = colsb.owner
                    WHERE colsa.table_name = ''BIE_LOCALIZACION'' 
                    AND consa.constraint_type = ''R''
                    AND consa.owner = '''||v_schema||''' 
                    AND consb.owner = '''||v_schema_MASTER||'''
                    AND consa.constraint_name = ''FK_CIC_ID_BIE_LOC'')' into v_table_count;

if v_table_count = 0 then
    DBMS_OUTPUT.PUT_LINE('[INFO] FK_CIC_ID_BIE_LOC... No existe');
else 

    EXECUTE IMMEDIATE 'ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION DROP CONSTRAINT FK_CIC_ID_BIE_LOC';

    DBMS_OUTPUT.PUT_LINE('ALTER TABLE '|| v_schema ||'.BIE_LOCALIZACION DROP CONSTRAINT FK_CIC_ID_BIE_LOC ... OK');

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