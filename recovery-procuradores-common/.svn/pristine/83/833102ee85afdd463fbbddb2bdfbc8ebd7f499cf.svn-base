--/*
--##########################################
--## Author: #AUTOR#
--## Añade el campo BIE_ADI_CAN_CARGAS_RESUMEN a la tabla BIE_ADICIONAL
--## Añade el campo BIE_ADI_CAN_CARGAS_PROPUESTA a la tabla BIE_ADICIONAL
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 


DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

BEGIN

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE UPPER(table_name) = 'BIE_ADICIONAL' and UPPER(column_name) = 'BIE_ADI_CAN_CARGAS_RESUMEN';

    if v_column_count = 1 then
        DBMS_OUTPUT.PUT_LINE('[INFO] BIE_ADI_CAN_CARGAS_RESUMEN ya existe');
    else
        execute immediate 'alter table ' || V_ESQUEMA || '.BIE_ADICIONAL add (BIE_ADI_CAN_CARGAS_RESUMEN  VARCHAR2(500 CHAR))';
        commit;  
    end if;

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE UPPER(table_name) = 'BIE_ADICIONAL' and UPPER(column_name) = 'BIE_ADI_CAN_CARGAS_PROPUESTA';

    if v_column_count = 1 then
        DBMS_OUTPUT.PUT_LINE('[INFO] BIE_ADI_CAN_CARGAS_PROPUESTA ya existe');
    else
        execute immediate 'alter table ' || V_ESQUEMA || '.BIE_ADICIONAL add (BIE_ADI_CAN_CARGAS_PROPUESTA  VARCHAR2(500 CHAR))';
        commit;
    end if;

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

EXIT;
