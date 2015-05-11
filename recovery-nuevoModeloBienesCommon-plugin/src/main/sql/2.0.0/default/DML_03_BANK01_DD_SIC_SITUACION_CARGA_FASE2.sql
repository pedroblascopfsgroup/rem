--/*

--##########################################

--## Author: DGG

--## Finalidad: DML de DD_SIC_SITUACION_CARGA

--##            A�ade campo ACTIVA

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



DBMS_OUTPUT.PUT_LINE('[START] Modificar tabla DD_SIC_SITUACION_CARGA');



select count(1) into table_count from all_tables where table_name = 'DD_SIC_SITUACION_CARGA';



if table_count = 1 then

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA... Existe');

    

    -- Crear las nuevas columnas de saneamientos

    SELECT COUNT(1) INTO v_column_count FROM DD_SIC_SITUACION_CARGA sic WHERE sic.DD_SIC_CODIGO = 'ACT';

    if v_column_count = 0 then

        execute immediate 'Insert into ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA
        (DD_SIC_ID, DD_SIC_CODIGO, DD_SIC_DESCRIPCION, DD_SIC_DESCRIPCION_LARGA, 
        VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
        Values (3, ''ACT'', ''ACTIVA'', ''ACTIVA'', 0, ''DD'', sysdate, 0)';
        commit;

        
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA... registro a�adido');

    else

        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA... registro ya existe');      

    end if;

    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SIC_SITUACION_CARGA... FIN');

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