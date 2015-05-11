-- Se ejecuta en el esquema MASTER
insert into fun_funciones values(s_fun_funciones.nextval, 'Ocultar Gestión del Clientes del Panel de Tareas', 'ROLE_OCULTAR_ARBOL_GESTION_CLIENTES', 
   0, 'DD', sysdate, 
   null, null, null,null, 0);

insert into fun_funciones values(s_fun_funciones.nextval, 'Ocultar Objetivos Pendientes del Panel de Tareas', 'ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES', 
   0, 'DD', sysdate, 
   null, null, null,null, 0);