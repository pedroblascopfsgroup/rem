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
    V_ESQUEMA2 VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas   

    V_MSQL VARCHAR2(4000 CHAR); 

BEGIN



DBMS_OUTPUT.PUT_LINE('[START] Modificar tabla BIE_ADJ_ADJUDICACION');



select count(1) into table_count from all_tables where table_name = 'BIE_ADJ_ADJUDICACION';



if table_count = 1 then

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Existe');

    

    -- elimina FK a personas
    SELECT COUNT(1) INTO v_column_count from user_constraints c where c.CONSTRAINT_NAME = 'FK_BIE_ADJ_PER';

    if v_column_count = 1 then
    
        execute immediate ' 
            ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION
                DROP CONSTRAINT FK_BIE_ADJ_PER';

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... FK_BIE_ADJ_PER Eliminada');

    else

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... FK_BIE_ADJ_PER no existe');      

    end if;


    -- A�ade fk a usu
    
    SELECT COUNT(1) INTO v_column_count from user_constraints c where c.CONSTRAINT_NAME = 'FK_BIE_ADJ_TO_USU';
    if v_column_count = 0 then
    
        execute immediate ' 
            ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION
                ADD CONSTRAINT FK_BIE_ADJ_TO_USU
                FOREIGN KEY (BIE_ADJ_GESTORIA_ADJUDIC)
                REFERENCES ' || V_ESQUEMA2 || '.USU_USUARIOS (USU_ID)';

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... FK_BIE_ADJ_TO_USU A�adida');

    else

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... FK_BIE_ADJ_TO_USU ya existe');      

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