declare
CURSOR c1 is select 'ALTER TABLE '||substr(c.table_name,1,35)|| ' ENABLE CONSTRAINT '||constraint_name AS dropConstraint
                     from user_constraints c, user_tables u
                     where c.table_name = u.table_name
                     and c.constraint_type='P';
rowC1  c1%ROWTYPE;

CURSOR c2 is select 'ALTER TABLE '||substr(c.table_name,1,35)|| ' ENABLE CONSTRAINT '||constraint_name AS dropConstraint
                     from user_constraints c, user_tables u
                     where c.table_name = u.table_name
                     and c.constraint_type<>'P';
rowC2  c2%ROWTYPE;

begin
  dbms_output.put_line('INICIO HABILITADO');
  open c1;
  LOOP
      fetch c1 into rowC1;
      EXIT WHEN c1%NOTFOUND;
      dbms_output.put_line(rowC1.dropConstraint);
      execute immediate rowC1.dropConstraint;
  end loop;
  close c1;
  
  open c2;
  LOOP
      fetch c2 into rowC2;
      EXIT WHEN c2%NOTFOUND;
      dbms_output.put_line(rowC2.dropConstraint);
      execute immediate rowC2.dropConstraint;
  end loop;
  close c2;
end;
/