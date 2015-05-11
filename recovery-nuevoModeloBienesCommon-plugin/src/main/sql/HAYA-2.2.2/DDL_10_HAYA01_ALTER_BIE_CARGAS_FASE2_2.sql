--/*

--##########################################

--## Author: DGG

--## Finalidad: DDL de Bienes 

--##            Alter para ampliar los bienes con el campo tipo_subasta numerico

--##            

--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE

--## VERSIONES:

--##        0.1 Versi?n inicial

--##########################################

--*/

--Para permitir la visualizaci?n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 



DECLARE

    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.

    table_count number(3); -- Vble. para validar la existencia de las Tablas.

    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    

    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.

    err_num NUMBER; -- N?mero de errores

    err_msg VARCHAR2(2048); -- Mensaje de error    

    V_ESQUEMA VARCHAR2(25 CHAR):= 'HAYA01'; -- Configuracion Esquemas    

    V_MSQL VARCHAR2(4000 CHAR); 

BEGIN



DBMS_OUTPUT.PUT_LINE('[START] Modificar tabla BIE_CAR_CARGAS');



select count(1) into table_count from all_tables where table_name = 'BIE_CAR_CARGAS';



if table_count = 1 then

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... Existe');


    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_car_cargas' and UPPER(column_name) = 'DD_SIC_ID'
    and nullable ='N';

    if v_column_count = 1 then

        
        execute immediate 'ALTER TABLE BIE_CAR_CARGAS MODIFY ( dd_sic_id  null,dd_sic_id2 null)';
        
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... Columnas not null añadidas');

    else

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... Columnas ya nullables');      

    end if;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_CAR_CARGAS... FIN');

end if;

              

EXCEPTION

     WHEN OTHERS THEN

          err_num := SQLCODE;

          err_msg := SQLERRM;

        

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci?n:'||TO_CHAR(err_num));

          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 

          DBMS_OUTPUT.put_line(err_msg);

          

          ROLLBACK;

          RAISE;

           

END;
/

EXIT;
