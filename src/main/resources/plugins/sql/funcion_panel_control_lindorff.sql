-- nueva funcion para elegir la pestaña de filtros para lindorff
-- los usuarios que tengan esta función verán un panel de filtros diferente que los que no la tengan

insert into linmaster.fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) 
values (linmaster.s_fun_funciones.nextval, 'PANEL_LINDORFF', 'Modificaciones panel de control para Lindorff',0,'AAS',sysdate,0);
