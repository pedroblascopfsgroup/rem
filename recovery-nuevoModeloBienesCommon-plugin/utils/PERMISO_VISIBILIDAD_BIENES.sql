insert into fun_funciones 
values (s_fun_funciones.nextval,'Permiso que limita la visibilidad de los bienes','VISIBILIDAD_LIMITADA_BIENES',0,'xema',SYSDATE,NULL,NULL,NULL,NULL,0);
commit;

DECLARE
  CURSOR perfiles_cursor IS
  SELECT pef_id FROM pef_perfiles where borrado = 0;
  pefid NUMBER(16);
BEGIN
 
 OPEN perfiles_cursor;
 
 LOOP
   
    FETCH perfiles_cursor INTO pefid;
   
    EXIT WHEN perfiles_cursor%NOTFOUND;
   
    
    insert into fun_pef (fun_id,pef_id,fp_id,version,usuariocrear,fechacrear,usuariomodificar,fechamodificar,usuarioborrar,fechaborrar,borrado)
    values ((select fun_id from unmaster.fun_funciones where fun_descripcion = 'VISIBILIDAD_LIMITADA_BIENES'),pefid,s_fun_pef.nextval,0,'xema',sysdate,null,null,null,null,0);


  END LOOP;
  
  CLOSE perfiles_cursor;
END;
commit;