whenever sqlerror exit sql.sqlcode;

--/*
--##########################################
--## Author: #AUTOR#
--## Finalidad: UPDATE BIE_CAR_CARGAS.
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--##########################################
--*/



--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
SET SERVEROUTPUT ON; 

DECLARE
v_seq_count number(3);
v_table_count number(3);
v_schema varchar(30) := '#ESQUEMA#';
v_constraint_count number(3);
v_sql varchar2(4000);

BEGIN





DBMS_OUTPUT.PUT_LINE('[START]  tabla BIE_CAR_CARGAS');

EXECUTE IMMEDIATE 'UPDATE '|| v_schema ||'.bie_car_cargas set dd_tpc_id = 2, usuariomodificar = ''SAG'', fechamodificar = sysdate where dd_tpc_id = 5';
EXECUTE IMMEDIATE 'UPDATE '|| v_schema ||'.bie_car_cargas set dd_tpc_id = 1, usuariomodificar = ''SAG'', fechamodificar = sysdate where dd_tpc_id = 4';
EXECUTE IMMEDIATE 'UPDATE '|| v_schema ||'.bie_car_cargas set dd_tpc_id = 1, usuariomodificar = ''SAG'', fechamodificar = sysdate where dd_tpc_id in (7,6,3)';



	DBMS_OUTPUT.PUT_LINE('UPDATE  '|| v_schema ||'.bie_car_cargas ... OK');




EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;



END;
/

EXIT
