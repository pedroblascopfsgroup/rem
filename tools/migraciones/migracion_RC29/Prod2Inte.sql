update pfsmaster.entidadconfig set datavalue = 'jdbc:oracle:thin:PFS01/admin@//localhost:1521/integracion' where entidad_id=1 and datakey='url';
update pfsmaster.entidadconfig set datavalue = 'jdbc:oracle:thin:PFS02/admin@//localhost:1521/integracion' where entidad_id=2 and datakey='url';
update pfsmaster.entidadconfig set datavalue = 'jdbc:oracle:thin:PFS03/admin@//localhost:1521/integracion' where entidad_id=3 and datakey='url';
update pfsmaster.entidadconfig set datavalue = 'jdbc:oracle:thin:PFS04/admin@//localhost:1521/integracion' where entidad_id=4 and datakey='url';

update pfsmaster.usu_usuarios
set usu_mail = null;

quit;