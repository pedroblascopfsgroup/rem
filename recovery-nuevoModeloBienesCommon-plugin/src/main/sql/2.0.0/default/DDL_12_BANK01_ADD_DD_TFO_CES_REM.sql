--/*
--##########################################
--## Author: Carlos
--## Añade el campo DD_TFO_CES_REM
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

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE UPPER(table_name) = 'DD_TFO_TIPO_FONDO' and UPPER(column_name) = 'DD_TFO_CES_REM';

    if v_column_count = 1 then
        DBMS_OUTPUT.PUT_LINE('[INFO] DD_TFO_CES_REM ya existe');
    else
        execute immediate 'alter table bank01.DD_TFO_TIPO_FONDO add (DD_TFO_CES_REM  NUMBER(1,0))';
        commit;  
    end if;

  	SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE UPPER(table_name) = 'DD_TFO_TIPO_FONDO' and UPPER(column_name) = 'DD_TFO_CODIGO_NAL';

    if v_column_count = 1 then
        DBMS_OUTPUT.PUT_LINE('[INFO] DD_TFO_CODIGO_NAL ya existe');
    else
        execute immediate 'alter table bank01.DD_TFO_TIPO_FONDO add (DD_TFO_CODIGO_NAL  VARCHAR2(20 BYTE))';
        commit;
    end if;
    
    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE UPPER(table_name) = 'DD_TFO_TIPO_FONDO' and UPPER(column_name) = 'DD_TFO_CODIGO_APROV';

    if v_column_count = 1 then
        DBMS_OUTPUT.PUT_LINE('[INFO] DD_TFO_CODIGO_APROV ya existe');
    else
        execute immediate 'alter table bank01.DD_TFO_TIPO_FONDO add (DD_TFO_CODIGO_APROV  VARCHAR2(20 BYTE))';
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

