create or replace PROCEDURE NOLOGGING_SP AS 
begin
declare
  V_SQL VARCHAR2(1000);
  O_ERROR_STATUS number;
  
begin
  for rs in (select table_name from all_tables where UPPER(OWNER) ='RECOVERY_BANKIA_DWH' order by table_name) loop
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''ALTER'', ''' || rs.table_name || ''', ''NOLOGGING'', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;  
    -- DBMS_OUTPUT.PUT_LINE('ALTER TABLE ' || rs.table_name || ' NOLOGGING');  
  end loop;
  
end;
end NOLOGGING_SP;