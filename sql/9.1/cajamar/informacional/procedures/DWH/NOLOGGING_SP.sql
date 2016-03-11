create or replace PROCEDURE NOLOGGING_SP AS 
BEGIN
begin
for rs in (select table_name from all_tables where UPPER(OWNER) ='RECOVERY_CM_DWH' order by table_name) loop
  EXECUTE IMMEDIATE 'ALTER TABLE ' || rs.table_name || ' NOLOGGING';  
  -- DBMS_OUTPUT.PUT_LINE('ALTER TABLE ' || rs.table_name || ' NOLOGGING');  
  end loop;
end;
END NOLOGGING_SP;