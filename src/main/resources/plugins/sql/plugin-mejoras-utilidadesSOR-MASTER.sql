
--NUEVO TIPO DE ENTIDAD DE INFORMACIÓN--	
insert into dd_ein_entidad_informacion	(DD_EIN_ID,DD_EIN_CODIGO,DD_EIN_DESCRIPCION,DD_EIN_DESCRIPCION_LARGA,version,usuariocrear,fechacrear,borrado) values 
(8, '13','Autoprorroga', 'Autoprorroga',0,'AAS',sysdate,0);

--NUEVO SUBTIPO DE TAREA
insert into dd_sta_subtipo_tarea_base	(DD_STA_ID,DD_TAR_ID,DD_STA_CODIGO,DD_STA_DESCRIPCION,DD_STA_DESCRIPCION_LARGA,version,usuariocrear,fechacrear,borrado) values 
(503, 1,'503', 'Prorroga toma decisión','Solicitu de prórroga de la toma de decisión',0,'AAS',sysdate,0);
	
