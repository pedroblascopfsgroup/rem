-- borrar las funciones correspondientes a los otros paneles de control

delete from fun_pef fp where fun_id =(select fun_id from linmaster.fun_funciones where fun_descripcion='PANEL-CONTROL-GESTION_JUDICIAL');
delete from fun_pef fp where fun_id =(select fun_id from linmaster.fun_funciones where fun_descripcion='PANEL-CONTROL-GESTION_PRIMARIA');

commit;
