declare 
  a_tables dbms_sql.varchar2_table;
  nCount NUMBER;
  v_sql LONG;
  contador NUMBER;
  ERROR_TABLE_NOT_FOUND EXCEPTION;
begin
  a_tables(1) := 'CEX_CONTRATO_EXPEDIENTE_REC';
  a_tables(a_tables.LAST + 1) := 'PEX_PERSONAS_EXPEDIENTE_REC';
  a_tables(a_tables.LAST + 1) := 'CDE_CICLO_DEUDA_EXP';
  a_tables(a_tables.LAST + 1) := 'CDC_CICLO_DEUDA_CEX';
  a_tables(a_tables.LAST + 1) := 'CDP_CICLO_DEUDA_PEX';
  
  
  FOR contador IN 1..a_tables.LAST LOOP
    -- Buscamos si la tabla ya existe, si es así no hacemos nada
    SELECT COUNT(*) INTO NCOUNT FROM ALL_TABLES WHERE TABLE_NAME = a_tables(contador);
    IF ncount > 0 THEN
       execute immediate 'DROP TABLE '||a_tables(contador)||' cascade constraints';
       DBMS_OUTPUT.PUT_LINE(a_tables(contador)||' : tabla borrada');
    END IF;
  END LOOP;
end;