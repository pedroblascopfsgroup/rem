insert into bankmaster.dd_tge_tipo_gestor (dd_tge_id, dd_tge_codigo, dd_tge_descripcion, dd_tge_descripcion_larga, usuariocrear, fechacrear)
values (bankmaster.s_dd_tge_tipo_gestor.nextval, 'GAGER', 'Gestor agencia de recobro', 'Gestor de las agencias de recobro', 'SAG', sysdate);

insert into bankmaster.dd_tge_tipo_gestor (dd_tge_id, dd_tge_codigo, dd_tge_descripcion, dd_tge_descripcion_larga, usuariocrear, fechacrear)
values (bankmaster.s_dd_tge_tipo_gestor.nextval, 'SAGER', 'Supervisor agencia de recobro', 'Supervisor de las agencias de recobro', 'SAG', sysdate);

delete from bankmaster.dd_tde_tipo_despacho where dd_tde_descripcion in ('Despacho Gestores Administrativos', 'Despacho Proveedor Solvencia');
