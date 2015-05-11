/*
 * Vaciar tablas de bienes.
 * 
 */

delete from bie_cnt where bie_id in (select bie_id from bie_bien where dd_origen_id = 2);
delete from bie_datos_registrales where bie_id in (select bie_id from bie_bien where dd_origen_id = 2);
delete from bie_localizacion where bie_id in (select bie_id from bie_bien where dd_origen_id = 2);
delete from bie_per where bie_id in (select bie_id from bie_bien where dd_origen_id = 2);
delete from bie_valoraciones where bie_id in (select bie_id from bie_bien where dd_origen_id = 2);
delete from bie_bien where dd_origen_id = 2;
