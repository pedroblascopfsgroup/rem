SET DEFINE OFF;
Insert into UNMASTER.FUN_FUNCIONES
   (FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (s_fun_funciones.nextval, 'Búsqueda carterizada de clientes', 'BUSCADOR_CLIENTES_CARTERIZADO',0 , 'XEMA', SYSDATE, 0);
COMMIT;


SET DEFINE OFF;
Insert into FUN_PEF
 Values
   ((select fun_id from unmaster.fun_funciones where fun_descripcion = 'BUSCADOR_CLIENTES_CARTERIZADO'), (select pef_id from pef_perfiles where pef_descripcion = 'GESTOR_EMPRESAS_CARTERIZADAS'),s_fun_pef.nextval,0 , 'XEMA', SYSDATE,null,null,null,null, 0);
COMMIT;
SET DEFINE OFF;
Insert into FUN_PEF
 Values
   ((select fun_id from unmaster.fun_funciones where fun_descripcion = 'BUSCADOR_CLIENTES_CARTERIZADO'), (select pef_id from pef_perfiles where pef_descripcion = 'JEFE_EMPRESAS_CARTERIZADAS'),s_fun_pef.nextval,0 , 'XEMA', SYSDATE,null,null,null,null, 0);
COMMIT;