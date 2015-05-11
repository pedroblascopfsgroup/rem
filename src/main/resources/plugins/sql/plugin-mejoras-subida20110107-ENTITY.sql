-- NUEVOS PLAZOS PARA LOS ACUERDOS

insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id,
		31536000000,'ANY','Periodo anual',0,'AAS',sysdate,0  
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%acuerdo anual%'); 
		
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id ,2592000000,'MES','Un mes',0,'AAS',sysdate,0
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%acuerdo mensual%'); 
		
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id ,15552000000,'SEI','Seis meses',0,'AAS',sysdate,0
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%acuerdo semestral%'); 
		
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id ,7776000000,'TRI','Tres meses',0,'AAS',sysdate,0
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%acuerdo trimestral%'); 
	
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id ,604800000,'BI','Dos meses',0,'AAS',sysdate,0
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%acuerdo bimestral%'); 
	
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id ,5184000000,'SEM','Una semana',0,'AAS',sysdate,0
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%acuerdo semanal%'); 

		
-- PLAZO MÁXIMO PARA LA AUTOPRORROGA
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id ,604800000,'UNI','Plazo único',0,'AAS',sysdate,0
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%acuerdo unico%'); 
		
insert into pla_plazos_default (pla_id,dd_sta_id,pla_plazo,pla_codigo,pla_descripcion,version,usuariocrear,fechacrear,borrado) 
	(select s_pla_plazos_default.nextval,dd_sta_id ,2592000000,'MAXAUTOP','Plazo maximo autoprorroga',0,'AAS',sysdate,0
		from pfsmaster.dd_sta_subtipo_tarea_base where dd_sta_descripcion like '%plazo máximo autoprorroga%');
		
-- NUMERO MÁXIMO DE AUTOPRORROGAS

ALTER TABLE TAP_TAREA_PROCEDIMIENTO ADD (TAP_MAX_AUTOP NUMBER(2) DEFAULT 3 NOT NULL);
ALTER TABLE TEX_TAREA_EXTERNA ADD (TEX_NUM_AUTOP NUMBER(2)DEFAULT 0 NOT NULL);
ALTER TABLE TEX_TAREA_EXTERNA ADD (DTYPE VARCHAR2 (30 CHAR) DEFAULT 'EXTTareaExterna' NOT NULL);
UPDATE TAP_TAREA_PROCEDIMIENTO SET DTYPE = 'EXTTareaProcedimiento';


-- para registros de tipo cumplimiento de acuerdo
INSERT INTO MEJ_DD_TRG_TIPO_REGISTRO (DD_TRG_ID,DD_TRG_CODIGO,DD_TRG_DESCRIPCION,DD_TRG_DESCRIPCION_LARGA,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
	VALUES(S_MEJ_DD_TRG_TIPO_REGISTRO.nextval,'ACU','Cumplimiento acuerdo','Cumplimiento acuerdo',0,'MEJ',SYSDATE,0);





