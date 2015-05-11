declare
CURSOR c1 is  select 'DROP SEQUENCE '||SEQUENCE_OWNER||'.'||SEQUENCE_NAME as dropSequence 
              from ALL_SEQUENCES 
              where (SEQUENCE_OWNER like '%PFS01'
              or SEQUENCE_OWNER like '%PFS02'
              or SEQUENCE_OWNER like '%PFSMASTER');
rowC1  c1%ROWTYPE;
CURSOR c2 is  select 'DROP TABLE '||OWNER||'.'||TABLE_NAME||' CASCADE CONSTRAINTS' as dropTable 
              from ALL_TABLES 
              where (OWNER like '%PFS01'
              or OWNER like '%PFS02'
              or OWNER like '%PFSMASTER');
rowC2  c2%ROWTYPE;
begin 
  dbms_output.put_line('INICIO BORRADO');
  open c1;
  LOOP
      fetch c1 into rowC1;
      EXIT WHEN c1%NOTFOUND;
      dbms_output.put_line(rowC1.dropSequence);
      execute immediate rowC1.dropSequence;      
  end loop;
  close c1;
  open c2;
  LOOP
      fetch c2 into rowC2;
      EXIT WHEN c2%NOTFOUND;
      dbms_output.put_line(rowC2.dropTable);
      execute immediate rowC2.dropTable;      
  end loop;
  close c2;
end;
