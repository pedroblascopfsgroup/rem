DECLARE

   TABLE_COUNT NUMBER:=0;

BEGIN

    SELECT COUNT(1) INTO TABLE_COUNT FROM all_tab_cols 
         WHERE UPPER(table_name) = 'SUB_SUBASTA' and (UPPER(column_name) = 'DEUDA_JUDICIAL_MIG')
         AND OWNER = 'BANK01';
         
     if TABLE_COUNT = 0 then 
        EXECUTE IMMEDIATE 'ALTER TABLE BANK01.SUB_SUBASTA 
                              ADD (DEUDA_JUDICIAL_MIG  NUMBER(16,2)) ' ;

    DBMS_OUTPUT.PUT_LINE('[INFO] SUB_SUBASTA... Modificada - Anyadida columna DEUDA_JUDICIAL_MIG  ');                
    end if;    

END;
/
