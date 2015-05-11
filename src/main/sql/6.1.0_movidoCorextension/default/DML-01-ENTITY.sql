insert into BANKMASTER.FUN_FUNCIONES (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(BANKMASTER.S_FUN_FUNCIONES.NEXTVAL, 'TAB_CONTRATO_DOCUMENTOS', 'Ver pestaña documentos del contrato',0,'DD',sysdate,0);

insert into BANKMASTER.FUN_FUNCIONES (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(BANKMASTER.S_FUN_FUNCIONES.NEXTVAL, 'INITIAL_TAB_BUS_EXP', 'Pestaña de inicio búsqueda de expedientes',0,'DD',sysdate,0);

COMMIT;