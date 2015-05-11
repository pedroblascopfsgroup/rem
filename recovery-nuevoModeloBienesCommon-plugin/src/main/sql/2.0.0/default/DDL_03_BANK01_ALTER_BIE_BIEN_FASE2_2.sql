--/*

--##########################################

--## Author: DGG

--## Finalidad: DDL de Bienes adjudicados

--##            Alter para ampliar los adjudicados de un bien con los campos que faltan del bpm de saneamiento

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

    

    -- Crear las nuevas columnas de saneamientos

    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_adj_adjudicacion' and UPPER(column_name) = 'BIE_ADJ_F_REV_PROP_CAN';

    if v_column_count = 0 then

        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_REV_PROP_CAN DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_PROP_CAN DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_REV_CARGAS DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_PRES_INS_ECO DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_PRES_INS DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_CAN_REG_ECO DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_CAN_REG DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_CAN_ECO DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_LIQUIDACION DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_RECEPCION DATE )';
        execute immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_F_CANCELACION DATE )';
        
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columnas de saneamiento a�adidas');

    else

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columnas de saneamiento ya existen');      

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