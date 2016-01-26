update CM01.DD_RULE_DEFINITION set rd_column = 'dd_tpe_id', usuariomodificar = 'CPI', fechamodificar = sysdate WHERE rd_column = 'dd_tpe';

update cm01.rule_definition set 
rd_name =  concat(rd_name,'_backup'), 
usuariomodificar = 'CPI', fechamodificar = sysdate;

update cm01.rule_definition set 
usuarioborrar = 'CPI', fechaborrar = sysdate, borrado = 1 where borrado = 0;

update cm01.arq_arquetipos set 
arq_nombre =  concat(arq_nombre,'_backup'), 
usuariomodificar = 'CPI', fechamodificar = sysdate;

update cm01.arq_arquetipos set 
usuarioborrar = 'CPI', fechaborrar = sysdate, borrado = 1 where borrado = 0;


update cm01.iti_itinerarios set 
iti_nombre =  concat(iti_nombre,'_backup'), 
usuariomodificar = 'CPI', fechamodificar = sysdate;

update cm01.iti_itinerarios set 
usuarioborrar = 'CPI', fechaborrar = sysdate, borrado = 1 where borrado = 0;
