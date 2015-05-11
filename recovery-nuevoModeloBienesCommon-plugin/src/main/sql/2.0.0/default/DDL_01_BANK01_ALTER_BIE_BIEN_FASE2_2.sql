--/*

--##########################################

--## Author: DGG

--## Finalidad: DDL de Bienes adjudicados

--##            Alter para ampliar los adjudicados de un bien con los campos que faltan de los bpm

--##            

--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE

--## VERSIONES:

--##        0.1 Versi�n inicial

--##########################################

--*/

--Para permitir la visualizaci�n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE

    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.

    table_count number(3); -- Vble. para validar la existencia de las Tablas.

    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    

    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.

    err_num NUMBER; -- N�mero de errores

    err_msg VARCHAR2(2048); -- Mensaje de error    

    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas    

    V_MSQL VARCHAR2(4000 CHAR); 

BEGIN



DBMS_OUTPUT.PUT_LINE('[START] Modificar tabla BIE_ADJ_ADJUDICACION');



select count(1) into table_count from all_tables where table_name = 'BIE_ADJ_ADJUDICACION';



if table_count = 1 then

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Existe');

    

    -- Crear la nueva columna BIE_ADJ_REQ_SUBSANACION

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_adj_adjudicacion' and UPPER(column_name) = 'BIE_ADJ_REQ_SUBSANACION';

    if v_column_count = 0 then

        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_REQ_SUBSANACION  NUMBER(1))';

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_REQ_SUBSANACION A�adida');

    else

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... La Columna BIE_ADJ_REQ_SUBSANACION ya existe');      

    end if;

    

    -- Crear la nueva columna BIE_ADJ_NOTIF_DEMANDADOS

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_adj_adjudicacion' and UPPER(column_name) = 'BIE_ADJ_NOTIF_DEMANDADOS';

    if v_column_count = 0 then

        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_NOTIF_DEMANDADOS   NUMBER(1))';

            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_NOTIF_DEMANDADOS A�adida');

    else

                DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... La Columna BIE_ADJ_NOTIF_DEMANDADOS ya existe');      

    end if;

    

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... FIN');

end if;

              

EXCEPTION

     WHEN OTHERS THEN

          err_num := SQLCODE;

          err_msg := SQLERRM;

        

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci�n:'||TO_CHAR(err_num));

          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 

          DBMS_OUTPUT.put_line(err_msg);

          

          ROLLBACK;

          RAISE;

           

END;

/

EXIT;