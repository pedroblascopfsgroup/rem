--despachos procuradores
INSERT INTO HAYA02.des_despacho_externo des (des_id,des_despacho,dd_tde_id,zon_id,usuariocrear,fechacrear)  VALUES(HAYA02.s_des_despacho_externo.nextval,'Despacho Procuradores',(SELECT dd_tde_id FROM hayamaster.dd_tde_tipo_despacho WHERE dd_tde_codigo = '2'),(SELECT MAX(zon_id) FROM HAYA02.zon_zonificacion WHERE zon_cod = '01'),'JSV',sysdate);
