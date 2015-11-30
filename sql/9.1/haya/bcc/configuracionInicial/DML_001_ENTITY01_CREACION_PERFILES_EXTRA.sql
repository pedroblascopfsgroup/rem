-- FUNCIONES
INSERT INTO HAYA02.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) values (HAYA02.S_FUN_PEF.nextval,(select pef.pef_id from HAYA02.PEF_PERFILES pef where pef.borrado = 0 and pef.PEF_CODIGO = 'HAYASUPVISOR'),(select  fun.fun_id from HAYAMASTER.FUN_FUNCIONES fun  where fun.borrado = 0 and fun.FUN_DESCRIPCION = 'VER_TAB_GESTORES'),'JSV',sysdate);

--despachos procuradores
INSERT INTO HAYA02.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(HAYA02.s_des_despacho_externo.nextval,'Despacho Procuradores',(SELECT dd_tde_id FROM hayamaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = '2'),(SELECT MAX(zon_id) FROM HAYA02.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);

-- Limpiamos la función ENVIO_CIERRE_DEUDA de los perfiles
delete
from Fun_Pef 
where fun_id in (select fun_id from HAYAMASTER.Fun_Funciones where fun_descripcion='ENVIO_CIERRE_DEUDA');