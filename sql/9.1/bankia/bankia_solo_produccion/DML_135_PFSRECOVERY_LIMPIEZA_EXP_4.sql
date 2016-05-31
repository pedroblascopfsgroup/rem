update BANK01.EXP_EXPEDIENTES set dd_eex_id = 4 where usuariomodificar = 'BKREC-1831' and to_char(fechamodificar,'DD/MM/RRRR') = '10/02/2016' and DD_EEX_ID = 6;
commit;

