set serveroutput on;


declare 
  a_tables dbms_sql.varchar2_table;
  nCount NUMBER;
  v_sql LONG;
  contador NUMBER;
  currentTable VARCHAR2(100 CHAR);
  ERROR_TABLE_NOT_FOUND EXCEPTION;
begin
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('ENTRADA DE DATOS BATCH AGENCIAS (testing)');
  DBMS_OUTPUT.PUT_LINE('   Este script restaura las tablas de entrada del batch.');
  DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
  
  
  /*
   * Relación de tablas que vamos a restaurar
   */ 
  a_tables(1) := 'BATCH_DATOS_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_EXP_MANUAL';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_PER';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_GCL';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_PER_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT_EXP';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CNT_PER';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_CLI';
  a_tables(a_tables.LAST + 1) := 'BATCH_DATOS_EXCEPTUADOS';
  a_tables(a_tables.LAST + 1) := 'BATCH_RCF_ENTRADA';
  
  
  /*
   * Restauramos las tablas
   */
  FOR contador IN 1..a_tables.LAST LOOP
    -- Buscamos si la tabla ya existe, si es así no hacemos nada
    SELECT COUNT(*) INTO NCOUNT FROM ALL_TABLES WHERE TABLE_NAME = a_tables(contador);
    IF ncount > 0 THEN
       DBMS_OUTPUT.PUT_LINE(a_tables(contador)||': tabla encontrada, no se realizará ninguna sustitución.');
    
    ELSE -- Si la tabla no existe
      
      
      -- Buscamos la vista y si existe la eliminamos
      SELECT COUNT(*) INTO NCOUNT FROM ALL_VIEWS WHERE VIEW_NAME = a_tables(contador);
      IF ncount > 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE '||a_tables(contador)||'_TMP AS SELECT * FROM '||a_tables(contador)||' WHERE ROWNUM = 2';
        DBMS_OUTPUT.PUT_LINE(a_tables(contador)||'_TMP: se ha creado la tabla.');
        v_sql:='DROP VIEW '||a_tables(contador);
        execute immediate v_sql;
        DBMS_OUTPUT.PUT_LINE(a_tables(contador)||': se ha eliminado la vista.');
      END IF;
      
      --Restauramos la tabla.
      v_sql:='ALTER TABLE '||a_tables(contador)||'_TMP RENAME TO '||a_tables(contador);
      execute immediate v_sql;
      DBMS_OUTPUT.PUT_LINE(a_tables(contador)||': tabla restaurada.');
    END IF;
  END LOOP;
  
  EXCEPTION 
    WHEN ERROR_TABLE_NOT_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('El programa ha abortado');
      RAISE_APPLICATION_ERROR(-20000, 'PROCESO ABORTADO FALTA UNA TABLA REQUERIDA: '||currentTable) ;
end;