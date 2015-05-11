declare
CURSOR c1 is select 'ALTER TABLE '||substr(c.table_name,1,35)|| ' DISABLE CONSTRAINT '||constraint_name||' CASCADE' AS dropConstraint
                     from user_constraints c, user_tables u
                     where c.table_name = u.table_name;
rowC1  c1%ROWTYPE;

begin
  dbms_output.put_line('INICIO DESAHABILITADO');
  open c1;
  LOOP
      fetch c1 into rowC1;
      EXIT WHEN c1%NOTFOUND;
      dbms_output.put_line(rowC1.dropConstraint);
      execute immediate rowC1.dropConstraint;
  end loop;
  close c1;
end;
/