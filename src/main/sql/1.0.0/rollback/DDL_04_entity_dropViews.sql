declare 
  a_tables dbms_sql.varchar2_table;
  nCount NUMBER;
  v_sql LONG;
  contador NUMBER;
  currentTable VARCHAR2(100 CHAR);
  ERROR_TABLE_NOT_FOUND EXCEPTION;
begin

  
  --
  -- Relación de tablas/vistas que vamos a borrar
  -- 
  a_tables(1) := 'BATCH_DATOS_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_EXP_MANUAL';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT_INFO';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_PER';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_GCL';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_PER_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT_PER';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CLI';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_EXCEPTUADOS';
  a_tables(a_tables.LAST + 1) := 'BATCH_RCF_ENTRADA';
  
  
  
  FOR contador IN 1..a_tables.LAST LOOP
    -- Buscamos si la tabla ya existe
    SELECT COUNT(*) INTO NCOUNT FROM ALL_TABLES WHERE TABLE_NAME = a_tables(contador);
    IF ncount > 0 THEN
       EXECUTE IMMEDIATE 'DROP TABLE '||a_tables(contador)||' PURGE';
    
    ELSE -- Si la tabla no existe
      -- Buscamos la tala backup
      SELECT COUNT(*) INTO NCOUNT FROM ALL_TABLES WHERE TABLE_NAME = a_tables(contador)||'_RNMD';
      IF ncount > 0 THEN
         EXECUTE IMMEDIATE 'DROP TABLE '||a_tables(contador)||'_RNMD PURGE';
      END IF;
      
      -- Buscamos la vista y si existe la eliminamos
      SELECT COUNT(*) INTO NCOUNT FROM ALL_VIEWS WHERE VIEW_NAME = a_tables(contador);
      IF ncount > 0 THEN
        v_sql:='DROP VIEW '||a_tables(contador);
        execute immediate v_sql;
      END IF;
    END IF;
  END LOOP;
end;