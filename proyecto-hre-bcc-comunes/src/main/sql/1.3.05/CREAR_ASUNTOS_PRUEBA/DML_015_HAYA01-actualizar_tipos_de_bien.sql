update bie_bien set DD_TBI_ID=(select DD_TBI_ID from DD_TBI_TIPO_BIEN where dd_tbi_descripcion='INMUEBLE');

commit;

