-- añadir a la tabla de tap_tarea_procedimiento una nueva columna que indique el tipo de gestor que tiene que realizar la tarea
alter table tap_tarea_procedimiento  ADD (DD_TGE_ID NUMBER(16));

ALTER TABLE tap_tarea_procedimiento ADD (
  CONSTRAINT FK_TAP_DD_TGE_ID 
 FOREIGN KEY (DD_TGE_ID) 
 REFERENCES UNMASTER.DD_TGE_TIPO_GESTOR (DD_TGE_ID));
 
-- insertamos dos nuevos tipos de tareas base -- gestor de confeccion de expediente 
--y supervisor de confeccion de expediente en el master

insert into DD_TGE_TIPO_GESTOR(DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,
USUARIOCREAR,FECHACREAR,BORRADO)
values(S_DD_TGE_TIPO_GESTOR.nextval, 'GECEXP', 'Gestor Confección Expediente', 'Gestor Confección Expediente', 0, 
'DIA',SYSDATE, 0);

insert into DD_TGE_TIPO_GESTOR(DD_TGE_ID,DD_TGE_CODIGO,DD_TGE_DESCRIPCION,DD_TGE_DESCRIPCION_LARGA,VERSION,
USUARIOCREAR,FECHACREAR,BORRADO)
values(S_DD_TGE_TIPO_GESTOR.nextval, 'SUPCEXP', 'Supervisor Confección Expediente', 'Supervisor Confección Expediente', 0, 
'DIA',SYSDATE, 0); 

Insert into DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TGE_ID, DTYPE)
 Values
   (S_DD_STA_SUBTIPO_TAREA_BASE.nextVal, 1, '600', 'Tarea de Gestor Confeccion Expediente', 'Tarea de Gestor Confeccion Expediente', 0, 'DIA', sysdate, 0 
   ,(select dd_tge_id from dd_tge_tipo_gestor where dd_tge_codigo='GECEXP')
   , 'EXTSubtipoTarea');

Insert into DD_STA_SUBTIPO_TAREA_BASE
   (DD_STA_ID, DD_TAR_ID, DD_STA_CODIGO, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO, DD_TGE_ID, DTYPE)
 Values
   (S_DD_STA_SUBTIPO_TAREA_BASE.nextVal, 1, '601', 'Tarea de Supervisor Confeccion Expediente', 'Tarea de Supervisor Confeccion Expediente', 0, 'DIA', sysdate, 0
    ,(select dd_tge_id from dd_tge_tipo_gestor where dd_tge_codigo='SUPCEXP')
   , 'EXTSubtipoTarea');
   
-- DECIR QUIEN SUPERVISA A QUIEN

Insert into DD_SUP_SUPERVISORES
   (DD_SUP_ID, DD_SUP_CODIGO, DD_SUP_DESCRIPCION, DD_SUP_DESCRIPCION_LARGA, DD_TGE_SUP, DD_TGE_GES, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 Values
   (S_DD_SUP_SUPERVISORES.nextval, 'SUPCEXP', 'Supervisor Confeccion Expediente', 'Supervisor Confeccion Expediente', 
   	(select dd_tge_id from dd_tge_tipo_gestor where dd_tge_codigo='SUPCEXP'), 
   	(select dd_tge_id from dd_tge_tipo_gestor where dd_tge_codigo='GECEXP'), 
   	0, 'PFS', sysdate, 0);

   
-- NUEVA FUNCION PARA PERMITIR VER LA TOMA DE DECISIÓN EN EL PROCEDIMIENTO
insert into unmaster.fun_funciones (fun_id,fun_descripcion,fun_descripcion_larga,version,usuariocrear,fechacrear,borrado) values 
(unmaster.s_fun_funciones.nextval, 'ROLE_TOMA_DECISION', 'Permiso para ver la pestaña de toma de decision',0,'AAS',sysdate,0);

   	
   	
   
 