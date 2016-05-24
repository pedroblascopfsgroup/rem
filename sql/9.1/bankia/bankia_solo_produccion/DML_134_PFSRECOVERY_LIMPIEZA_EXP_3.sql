update BANK01.EXP_EXPEDIENTES set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
update BANK01.PEX_PERSONAS_EXPEDIENTE set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
update BANK01.CEX_CONTRATOS_EXPEDIENTE set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
update BANK01.CRE_CICLO_RECOBRO_EXP set borrado = 0 where usuarioborrar = 'BKREC-1831' and borrado = 1;
commit;

update BANK01.EXP_EXPEDIENTES 
set DD_TPX_ID = (SELECT DD_TPX_ID FROM BANK01.DD_TPX_TIPO_EXPEDIENTE WHERE DD_TPX_CODIGO = 'RECU'), USUARIOMODIFICAR = 'BKREC-1831', FECHAMODIFICAR = SYSDATE 
where USUARIOCREAR = 'CONVIVE_F2';
COMMIT;
