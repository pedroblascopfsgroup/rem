--Asocio un bien al último procedimiento
insert into prb_prc_bie (
prb_id,
prc_id,
bie_id,
dd_sgb_id,
version,
usuariocrear,
fechacrear,
usuariomodificar,
fechamodificar,
usuarioborrar,
fechaborrar,
borrado
) 
values (
s_prb_prc_bie.nextval,
(select max(prc_id) from prc_procedimientos),
1,
1,
0,
'DD',
sysdate,
null,
null,
null,
null,
0
);
