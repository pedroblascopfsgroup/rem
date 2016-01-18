delete from cm01.GAA_GESTOR_ADICIONAL_ASUNTO;

delete from cm01.GAH_GESTOR_ADICIONAL_HISTORICO;

delete from cm01.usd_usuarios_despachos;

delete from cmmaster.gru_grupos_usuarios;

delete from cm01.zon_pef_usu;

delete from cm01.gee_gestor_entidad;

delete from cm01.hac_historico_accesos;

delete from cm01.tar_tareas_notificaciones where TAR_ID_DEST in (select usu_id from cmmaster.usu_usuarios);

delete from cm01.aco_asistentes_comite where usu_id in (select usu_id from cmmaster.usu_usuarios);

delete from cm01.mej_irg_info_registro where REG_ID in (select REG_ID from cm01.mej_reg_registro where usu_id in (select usu_id from cmmaster.usu_usuarios));

delete from cm01.mej_reg_registro where usu_id in (select usu_id from cmmaster.usu_usuarios);

delete from cm01.obj_objetivo where pol_id in (select pol_id from cm01.pol_politica where usu_id in (select usu_id from cmmaster.usu_usuarios));

delete from cm01.pol_politica where usu_id in (select usu_id from cmmaster.usu_usuarios);

--delete from cmmaster.usu_usuarios;
update cmmaster.usu_usuarios set borrado = 1, fechaborrar = sysdate, usuarioborrar = 'SAG', usu_username = '--'||usu_username;

delete from cm01.fun_pef;

--delete from cm01.pef_perfiles where usuariocrear != 'SAG';

update cm01.pef_perfiles set pef_codigo = '--' || pef_codigo, usuarioborrar = 'SAG', fechaborrar = sysdate, borrado = 1;

update cm01.iti_itinerarios set borrado = 1, fechaborrar = sysdate, usuarioborrar = 'SAG'
where iti_id in (select iti_id from cm01.iti_itinerarios where iti_nombre in (
'Persona fisica Hipotecario_copia',
'Persona fisica Hipotecario',
'Generico'));

update cm01.lia_lista_arquetipos set borrado = 1, fechaborrar = sysdate, usuarioborrar = 'SAG'
where lia_nombre in (
'Persona fisica Hipotecario', 'Clientes sin dudoso y mas de 1 millon dispuesto','Hipotecario con mas de 500Mil de dudoso'
);


update cm01.des_despacho_externo set dd_tde_id = (select dd_tde_id from cmmaster.dd_tde_tipo_despacho where dd_tde_codigo = 'D-SUADMCON')
where des_despacho = 'Despacho Supervisor administracion contable';

insert into CMMASTER.dd_tde_tipo_despacho tde (tde.DD_TDE_ID, tde.DD_TDE_CODIGO, tde.DD_TDE_DESCRIPCION, tde.DD_TDE_DESCRIPCION_LARGA, tde.FECHACREAR, tde.usuariocrear)
values (CMMASTER.s_dd_tde_tipo_despacho.nextval, 'SUP_PCO', 'Supervisor expediente judicial', 'Supervisor expediente judicial', sysdate, 'SAG');

insert into CM01.TGP_TIPO_GESTOR_PROPIEDAD tgp (tgp.TGP_ID, dd_tge_id, tgp_clave, tgp_valor, usuariocrear, fechacrear)
values 
(CM01.s_TGP_TIPO_GESTOR_PROPIEDAD.nextval, (select dd_tge_id from CMMASTER.DD_TGE_TIPO_GESTOR where dd_tge_codigo = 'SUP_PCO'),
 'DES_VALIDOS', (select tde.dd_tde_codigo from CMMASTER.dd_tde_tipo_despacho tde where tde.dd_tde_codigo = 'SUP_PCO'),
 'SAG', sysdate);
 
insert into CM01.des_despacho_externo des (des_id, des_despacho, fechacrear, usuariocrear, dd_tde_id, zon_id) values (CM01.s_des_despacho_externo.nextval, 'Precontencioso - Gestor de liquidacion', sysdate, 'SAG', (select dd_tde_id from cmmaster.dd_tde_tipo_despacho where dd_tde_codigo = 'CM_GL_PCO'), (select max(zon_id) from CM01.zon_zonificacion where zon_cod = '01'));
insert into CM01.des_despacho_externo des (des_id, des_despacho, fechacrear, usuariocrear, dd_tde_id, zon_id) values (CM01.s_des_despacho_externo.nextval, 'Precontencioso - Gestor de documentacion', sysdate, 'SAG', (select dd_tde_id from cmmaster.dd_tde_tipo_despacho where dd_tde_codigo = 'CM_GD_PCO'), (select max(zon_id) from CM01.zon_zonificacion where zon_cod = '01'));
insert into CM01.des_despacho_externo des (des_id, des_despacho, fechacrear, usuariocrear, dd_tde_id, zon_id) values (CM01.s_des_despacho_externo.nextval, 'Supervisor expedientes judiciales', sysdate, 'SAG', (select dd_tde_id from cmmaster.dd_tde_tipo_despacho where dd_tde_codigo = 'SUP_PCO'), (select max(zon_id) from CM01.zon_zonificacion where zon_cod = '01'));


/*
perfiles
*/

INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a toda la operativa de configuracion','Administrador','SAG',sysdate,'ADM_ADMINISTRADOR',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades de oficina','Oficina','SAG',sysdate,'OFI_OFICINA',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades de Gestor de riesgos','Gestor de riesgos','SAG',sysdate,'GES_RIESGOS',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades de Director de riesgos','Director de riesgos','SAG',sysdate,'DIR_RIESGOS',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades de Servicios centrales','Servicios centrales','SAG',sysdate,'SER_CENTRALES',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades de supervision de los asuntos judiciales','Supervisor','SAG',sysdate,'SUP_SUPERVISOR',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades propias de los gestores internos judiciales','Gestor Interno','SAG',sysdate,'GEST_INTERNO',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades propias de los gestores externos judiciales','Gestor Externo','SAG',sysdate,'GEST_EXTERNO',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades de BI','Acceso BI','SAG',sysdate,'ACC_BI',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades de consulta de toda la herramienta','Consulta','SAG',sysdate,'CON_CONSULTA',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades propias del precontencioso','Precontencioso','SAG',sysdate,'PRECONTENCIOSO',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades propias de la direccion territorial de riesgos','Director territorial riesgos','SAG',sysdate,'DIR_TERRITORIAL_RIESGOS',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades propias de la direccion territorial','Director territorial','SAG',sysdate,'DIR_TERRITORIAL',0,'EXTPerfil');
INSERT INTO CM01.PEF_PERFILES( PEF_ID,PEF_DESCRIPCION_LARGA,PEF_DESCRIPCION,USUARIOCREAR,FECHACREAR,PEF_CODIGO,PEF_ES_CARTERIZADO,DTYPE) VALUES (CM01.S_PEF_PERFILES.nextval,'Acceso a las funcionalidades propias de recursos humanos','RRHH','SAG',sysdate,'RRHH',0,'EXTPerfil');

--'Oficina'
INSERT INTO CM01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cmmaster.S_FUN_FUNCIONES.nextval,
      (SELECT PEF_ID from CM01.PEF_PERFILES  WHERE PEF_CODIGO = 'OFI_OFICINA') pef_id,
      fun_id,
      'SYS',
      sysdate
from     
    (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
        WHERE fun.FUN_DESCRIPCION IN ( 'MENU-LIST-PROPRE','MENU-LIST-CLI', 'MENU-LIST-EXP', 'MENU-LIST-ASU', 'BUSQUEDA', 'EDITAR_TITULOS', 'EDITAR_GYA', 'NUEVO_TITULO', 'BORRA_TITULO', 'SOLICITAR_PRORROGA', 'SOLICITAR_EXP_MANUAL', 'EXCLUIR_CLIENTES', 'MENU-LIST-CNT', 'EDITAR_GYA_REV', 'TAB-CNT-EXP-ASU', 'SOLICITAR_EXP_MANUAL_SEG', 'VER-OBSERVACIONES-ASUNTO', 'BUSCAR-TAREAS', 'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO', 'TAB_CLIENTE_HISTORICOS', 'CREAR_ANOTACIONES', 'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 'TAB_CLIENTE_CIRBE', 'EXPORTAR_PDF_EXPEDIENTE', 'BUSCAR-SUBASTAS', 'TAB_TITULOS_EXPEDIENTE' )
    );
   
--  'Gestor de riesgos' 
INSERT INTO CM01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cmmaster.S_FUN_FUNCIONES.nextval,
      (SELECT PEF_ID from CM01.PEF_PERFILES  WHERE PEF_CODIGO = 'GES_RIESGOS') pef_id,
      fun_id,
      'SYS',
      sysdate
from     
    (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
        WHERE fun.FUN_DESCRIPCION IN ('MENU-LIST-PROPRE', 'MENU-LIST-CLI', 'MENU-LIST-EXP', 'MENU-LIST-ASU', 'BUSQUEDA', 'EDITAR_TITULOS', 'EDITAR_GYA', 'NUEVO_TITULO', 'BORRA_TITULO', 'SOLICITAR_PRORROGA', 'SOLICITAR_EXP_MANUAL', 'EXCLUIR_CLIENTES', 'MENU-LIST-CNT', 'EDITAR_GYA_REV', 'TAB-CNT-EXP-ASU', 'SOLICITAR_EXP_MANUAL_SEG', 'VER-OBSERVACIONES-ASUNTO', 'BUSCAR-TAREAS', 'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO', 'TAB_CLIENTE_HISTORICOS', 'CREAR_ANOTACIONES', 'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 'TAB_CLIENTE_CIRBE', 'EXPORTAR_PDF_EXPEDIENTE', 'BUSCAR-SUBASTAS', 'TAB_TITULOS_EXPEDIENTE' )
    );

-- 'Director de riesgos'  
INSERT INTO CM01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cmmaster.S_FUN_FUNCIONES.nextval,
      (SELECT PEF_ID from CM01.PEF_PERFILES  WHERE PEF_CODIGO = 'DIR_RIESGOS') pef_id,
      fun_id,
      'SYS',
      sysdate
from     
    (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
        WHERE fun.FUN_DESCRIPCION IN ('MENU-LIST-PROPRE', 'MENU-LIST-CLI', 'MENU-LIST-EXP', 'MENU-LIST-ASU', 'BUSQUEDA', 'EDITAR_TITULOS', 'EDITAR_GYA', 'NUEVO_TITULO', 'BORRA_TITULO', 'SOLICITAR_PRORROGA', 'SOLICITAR_EXP_MANUAL', 'EXCLUIR_CLIENTES', 'MENU-LIST-CNT', 'EDITAR_GYA_REV', 'TAB-CNT-EXP-ASU', 'SOLICITAR_EXP_MANUAL_SEG', 'VER-OBSERVACIONES-ASUNTO', 'BUSCAR-TAREAS', 'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO', 'TAB_CLIENTE_HISTORICOS', 'CREAR_ANOTACIONES', 'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 'TAB_CLIENTE_CIRBE', 'EXPORTAR_PDF_EXPEDIENTE', 'BUSCAR-SUBASTAS', 'TAB_TITULOS_EXPEDIENTE' )
    );
 
-- 'Servicios centrales'   
INSERT INTO CM01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cmmaster.S_FUN_FUNCIONES.nextval,
      (SELECT PEF_ID from CM01.PEF_PERFILES  WHERE PEF_CODIGO = 'SER_CENTRALES') pef_id,
      fun_id,
      'SYS',
      sysdate
from     
    (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
        WHERE fun.FUN_DESCRIPCION IN ('MENU-LIST-PROPRE', 'MENU-LIST-CLI', 'MENU-LIST-EXP', 'MENU-LIST-ASU', 'BUSQUEDA', 'EDITAR_TITULOS', 'EDITAR_GYA', 'NUEVO_TITULO', 'BORRA_TITULO', 'SOLICITAR_PRORROGA', 'SOLICITAR_EXP_MANUAL', 'EXCLUIR_CLIENTES', 'MENU-LIST-CNT', 'EDITAR_GYA_REV', 'TAB-CNT-EXP-ASU', 'SOLICITAR_EXP_MANUAL_SEG', 'VER-OBSERVACIONES-ASUNTO', 'BUSCAR-TAREAS', 'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO', 'TAB_CLIENTE_HISTORICOS', 'CREAR_ANOTACIONES', 'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 'TAB_CLIENTE_CIRBE', 'EXPORTAR_PDF_EXPEDIENTE', 'BUSCAR-SUBASTAS', 'TAB_TITULOS_EXPEDIENTE' )
    );

--Administrador
INSERT INTO cm01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cm01.S_FUN_PEF.nextval,
     (SELECT PEF_ID from cm01.PEF_PERFILES  WHERE PEF_CODIGO = 'ADM_ADMINISTRADOR') pef_id,
     fun_id,
     'SYS',
     sysdate
from     
   (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
       WHERE fun.FUN_DESCRIPCION IN ( 
		'MENU-LIST-PROPRE','MENU-LIST-CLI','MENU-LIST-EXP','MENU-LIST-ASU','ROLE_ADMIN','BUSQUEDA','RESPONDER','MENU-LIST-CNT','EXPORTAR_ANALISIS_PDF','TAB-CNT-EXP-ASU','MOSTRAR_VR_TAREAS','VER-CONFIGURACION','VER-OBSERVACIONES-ASUNTO','ROLE_MENUARQ','BUSCAR-TAREAS',
		'VISIBILIDAD-TAREAS-NOPROPIAS','ROLE_CONFPLAZASYJUZ','BOTON_INF_AGREGADO_CONTRATO','ESTRUCTURA_COMPLETA_BIENES','SECCION_BIENES_EN_CONTRATO','BUSCAR-BIENES','FINALIZAR-ASUNTO','TAB_CLIENTE_CONTRATOS','TAB_CLIENTE_CABECERA',
		'TAB_CLIENTE_DATOS','TAB_CLIENTE_GRUPO','TAB_CLIENTE_HISTORICOS','VER_TAB_GESTORES','EDIT_GESTORES','ROLE_CONF_INSTRUCC_EXT','ROLE_EDITINSTRUCCIONESEXT','CREAR_ANOTACIONES','OPTIMIZACION_BUZON_TAREAS','ROLE_OCULTAR_ARBOL_GESTION_CLIENTES',
		'TAB_CONTRATO_RECIBOS','MENU_BUSQUEDAS_GENERAL','TAB_COBROS_PAGOS_EXP','TAB_CLIENTE_CIRBE','ROLE_RECOVERY_BI','MENU-DIRECCION-ASUNTO','TAB-NOTIFICACION-DEMANDADOS-v4','BUSCAR-SUBASTAS','ROLE_CONFPLAZOSEXT',
		'ROLE_ADDPLAZOSEXT','ROLE_BORRAPLAZOSEXT','ROLE_EDITPLAZOSEXT','BIEN_ADJUDICACION_EDITAR','ACC_MAN_SERVICIOS_UVEM','TAB_ADJUDICADOS','PUEDE_VER_TRIBUTACION','PUEDE_VER_PROVISIONES','VER_DOC_ADJUDICACION','PERSONALIZACION-HY',
		'ENVIO_CIERRE_DEUDA','EDITAR_PROCEDIMIENTO','EDITAR_GYA','CERRAR_DECISION','SOLICITAR_PRORROGA','SOLICITAR_EXP_MANUAL','EXCLUIR_CLIENTES','EDITAR_UMBRAL','EDITAR_GYA_REV','VER_UMBRAL','INCLUIR_EXCLUIR_CONTRATOS','ROLE_ADDJUZGADO','ROLE_EDITPLAZA',
    'ROLE_EDITJUZGADO','EXPORTAR_COMUNICACIONES','EXPORTAR_HISTORICO','ROLE_REANUDAR_PROC','MENU-SCORING-ALERTAS','VER-SCORING-CLIENTE','POLITICA_SUPER','VER-POLITICA','CAMBIAR-SUPERVISOR-ASUNTO','ROLE_CONFMODELOS','ROLE_CONFARQ','ROLE_EDIT_CABECERA_ASUNTO',
    'ROLE_EDIT_CABECERA_PROCEDIMIENTO','ROLE_CONFCOMITE','ROLE_ADDCOMITE','ROLE_EDITCOMITE','ROLE_EDIT_COM_ITI','ROLE_COMITE_BORRAPUESTO','ROLE_COMITE_ALTAPUESTO','ROLE_COMITE_EDITPUESTO','ROLE_BORRACOMITE','ROLE_CONFITI','BORRAR_ADJ_OTROS_USU','SOLVENCIA_NUEVO',
    'SOLVENCIA_BORRAR','SOLVENCIA_EDITAR','INGRESOS_EDITAR','ROLE_INCLUIR_CONTRATO_PROCEDIMIENTO','TAB_CLIENTE_ANTECEDENTES','ROLE_TOMA_DECISION','CAMBIAR-ESTADO-ASUNTO','MUESTRA-MENU-GESTORES-ASUNTO','PROPONER-ACUERDO','TAB_PRECONTENCIOSO','BUSQUEDA_PRECONTENCIOSO',
    'TAB_PRECONTENCIOSO_DOCUMENTOS','TAB_PRECONTENCIOSO_LIQUIDACIONES','TAB_PRECONTENCIOSO_BUROFAXES','EXPORTAR_FICHAGLOBAL'
	   )
   );
   
--Supervisor
INSERT INTO cm01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cm01.S_FUN_PEF.nextval,
     (SELECT PEF_ID from cm01.PEF_PERFILES  WHERE PEF_CODIGO = 'SUP_SUPERVISOR') pef_id,
     fun_id,
     'SYS',
     sysdate
from     
   (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
       WHERE fun.FUN_DESCRIPCION IN ( 
		'MENU-LIST-CLI','MENU-LIST-ASU','BUSQUEDA','EDITAR_TITULOS','EDITAR_PROCEDIMIENTO','NUEVO_CONTRATO','BORRA_CONTRATO','RESPONDER','EDITAR_SOLVENCIA','SOLICITAR_PRORROGA','MENU-LIST-CNT','MOSTRAR_VR_TAREAS','VIGENCIA_SOLVENCIA','VER-OBSERVACIONES-ASUNTO',
		'BUSCAR-TAREAS','ROLE_REANUDAR_PROC','ROLE_EDIT_CABECERA_ASUNTO','ROLE_EDIT_CABECERA_PROCEDIMIENTO','SECCION_BIENES_EN_CONTRATO','BORRAR_ADJ_OTROS_USU','BUSCAR-BIENES','SOLVENCIA_NUEVO','SOLVENCIA_BORRAR','SOLVENCIA_EDITAR','INGRESOS_EDITAR',
		'ROLE_INCLUIR_CONTRATO_PROCEDIMIENTO','TAB_CLIENTE_CONTRATOS','TAB_CLIENTE_CABECERA','TAB_CLIENTE_DATOS','TAB_CLIENTE_GRUPO','TAB_CLIENTE_HISTORICOS','EDIT_GESTORES','CREAR_ANOTACIONES','OPTIMIZACION_BUZON_TAREAS','TAB_CONTRATO_RECIBOS',
		'MENU_BUSQUEDAS_GENERAL','TAB_CLIENTE_CIRBE','MENU-DIRECCION-ASUNTO','TAB-NOTIFICACION-DEMANDADOS-v4','BUSCAR-SUBASTAS','BIEN_ADJUDICACION_EDITAR','ACC_MAN_SERVICIOS_UVEM','TAB_ADJUDICADOS','PUEDE_VER_TRIBUTACION','PUEDE_VER_PROVISIONES',
		'VER_DOC_ADJUDICACION','PERSONALIZACION-HY','ENVIO_CIERRE_DEUDA','ASU_MULTIGESTOR_SUPERVISOR','TAB_PRECONTENCIOSO','ACCIONES_PRECONTENCIOSO','BUSQUEDA_PRECONTENCIOSO','TAB_PRECONTENCIOSO_DOCUMENTOS','TAB_PRECONTENCIOSO_LIQUIDACIONES','TAB_PRECONTENCIOSO_BUROFAXES','PROPONER-ACUERDO'
	   )
   );
   
--Gestor
INSERT INTO cm01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cm01.S_FUN_PEF.nextval,
     (SELECT PEF_ID from cm01.PEF_PERFILES  WHERE PEF_CODIGO = 'GEST_INTERNO') pef_id,
     fun_id,
     'SYS',
     sysdate
from     
   (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
       WHERE fun.FUN_DESCRIPCION IN ( 
		'MENU-LIST-CLI','MENU-LIST-ASU','BUSQUEDA','EDITAR_TITULOS','NUEVO_CONTRATO','BORRA_CONTRATO','RESPONDER','EDITAR_SOLVENCIA','BORRA_TITULO','SOLICITAR_PRORROGA','MENU-LIST-CNT','TAB-CNT-EXP-ASU','MOSTRAR_VR_TAREAS','VIGENCIA_SOLVENCIA',
		'VER-OBSERVACIONES-ASUNTO','BUSCAR-TAREAS','ROLE_EDIT_CABECERA_ASUNTO','ROLE_EDIT_CABECERA_PROCEDIMIENTO','ESTRUCTURA_COMPLETA_BIENES','SECCION_BIENES_EN_CONTRATO','BORRAR_ADJ_OTROS_USU','EXPORTAR_COMUNICACIONES','EXPORTAR_HISTORICO',
		'BUSCAR-BIENES','SOLVENCIA_NUEVO','SOLVENCIA_BORRAR','SOLVENCIA_EDITAR','INGRESOS_EDITAR','ROLE_INCLUIR_CONTRATO_PROCEDIMIENTO','TAB_CLIENTE_CONTRATOS','TAB_CLIENTE_CABECERA','TAB_CLIENTE_DATOS','TAB_CLIENTE_GRUPO','TAB_CLIENTE_HISTORICOS',
		'VER_TAB_GESTORES','EDIT_GESTORES','CREAR_ANOTACIONES','OPTIMIZACION_BUZON_TAREAS','ROLE_OCULTAR_ARBOL_GESTION_CLIENTES','ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES','TAB_CONTRATO_RECIBOS','MENU_BUSQUEDAS_GENERAL','MENU-DIRECCION-ASUNTO',
		'TAB-NOTIFICACION-DEMANDADOS-v4','BUSCAR-SUBASTAS','BIEN_ADJUDICACION_EDITAR','ASU_GESTOR_SOLOPROPIAS','ACC_MAN_SERVICIOS_UVEM','TAB_ADJUDICADOS','PUEDE_VER_TRIBUTACION','PUEDE_VER_PROVISIONES','VER_DOC_ADJUDICACION',
		'PERSONALIZACION-HY','ENVIO_CIERRE_DEUDA','TAB_PRECONTENCIOSO','ACCIONES_PRECONTENCIOSO','BUSQUEDA_PRECONTENCIOSO','TAB_PRECONTENCIOSO_DOCUMENTOS','TAB_PRECONTENCIOSO_LIQUIDACIONES','TAB_PRECONTENCIOSO_BUROFAXES'
	   )
   );
   
--Gestor Externo
INSERT INTO cm01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cm01.S_FUN_PEF.nextval,
     (SELECT PEF_ID from cm01.PEF_PERFILES  WHERE PEF_CODIGO = 'GEST_EXTERNO') pef_id,
     fun_id,
     'SYS',
     sysdate
from     
   (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
       WHERE fun.FUN_DESCRIPCION IN ( 
		'MENU-LIST-ASU','BUSQUEDA','RESPONDER','EDITAR_SOLVENCIA','SOLICITAR_PRORROGA','TAB-CNT-EXP-ASU','MOSTRAR_VR_TAREAS','VIGENCIA_SOLVENCIA','VER-OBSERVACIONES-ASUNTO','ROLE_EDIT_CABECERA_ASUNTO','ROLE_EDIT_CABECERA_PROCEDIMIENTO','ESTRUCTURA_COMPLETA_BIENES',
		'SECCION_BIENES_EN_CONTRATO','EXPORTAR_COMUNICACIONES','EXPORTAR_HISTORICO','BUSCAR-BIENES','SOLVENCIA_NUEVO','SOLVENCIA_EDITAR','INGRESOS_EDITAR','TAB_CLIENTE_CONTRATOS','TAB_CLIENTE_CABECERA','TAB_CLIENTE_DATOS','TAB_CLIENTE_GRUPO',
		'TAB_CLIENTE_HISTORICOS','VER_TAB_GESTORES','EDIT_GESTORES','CREAR_ANOTACIONES','OPTIMIZACION_BUZON_TAREAS','ROLE_OCULTAR_ARBOL_GESTION_CLIENTES','ROLE_OCULTAR_ARBOL_OBJETIVOS_PENDIENTES','TAB_CONTRATO_RECIBOS','MENU_BUSQUEDAS_GENERAL',
		'MENU-DIRECCION-ASUNTO','TAB-NOTIFICACION-DEMANDADOS-v4','BUSCAR-SUBASTAS','BIEN_ADJUDICACION_EDITAR','ASU_GESTOR_SOLOPROPIAS','ASU_GESTOR_SOLOPROPIAS_ADIC','ACC_MAN_SERVICIOS_UVEM','TAB_ADJUDICADOS','ASU_PROCURADOR_SOLOPROPIAS_ADIC',
		'PUEDE_VER_TRIBUTACION','PUEDE_VER_PROVISIONES','VER_DOC_ADJUDICACION','PERSONALIZACION-HY','ENVIO_CIERRE_DEUDA','PROPONER-ACUERDO'
	   )
   );
   
--Acceso BI
INSERT INTO cm01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cm01.S_FUN_PEF.nextval,
     (SELECT PEF_ID from cm01.PEF_PERFILES  WHERE PEF_CODIGO = 'ACC_BI') pef_id,
     fun_id,
     'SYS',
     sysdate
from     
   (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
       WHERE fun.FUN_DESCRIPCION IN ( 
		'MENU-LIST-ASU','ROLE_RECOVERY_BI','PUEDE_VER_TRIBUTACION','PUEDE_VER_PROVISIONES','VER_DOC_ADJUDICACION','PERSONALIZACION-HY','ENVIO_CIERRE_DEUDA'
	   )
   );
--Consulta
INSERT INTO cm01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cm01.S_FUN_PEF.nextval,
     (SELECT PEF_ID from cm01.PEF_PERFILES  WHERE PEF_CODIGO = 'CON_CONSULTA') pef_id,
     fun_id,
     'SYS',
     sysdate
from     
   (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
       WHERE fun.FUN_DESCRIPCION IN ( 
		'MENU-LIST-PROPRE','MENU-LIST-CLI','MENU-LIST-ASU','BUSQUEDA','MENU-LIST-CNT','TAB-CNT-EXP-ASU','VER-OBSERVACIONES-ASUNTO','BUSCAR-TAREAS','SECCION_BIENES_EN_CONTRATO','BUSCAR-BIENES','TAB_CLIENTE_CONTRATOS','TAB_CLIENTE_CABECERA','TAB_CLIENTE_DATOS',
		'TAB_CLIENTE_ANTECEDENTES','TAB_CLIENTE_GRUPO','TAB_CLIENTE_HISTORICOS','OPTIMIZACION_BUZON_TAREAS','TAB_CONTRATO_RECIBOS','MENU_BUSQUEDAS_GENERAL','TAB_COBROS_PAGOS_EXP','TAB_CLIENTE_CIRBE','TAB_CONTRATO_DOCUMENTOS','BUSCAR-SUBASTAS',
		'SOLO_CONSULTA'   
	   )
   );
   
--Usuario precontencioso
INSERT INTO cm01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cm01.S_FUN_PEF.nextval,
     (SELECT PEF_ID from cm01.PEF_PERFILES  WHERE PEF_CODIGO = 'PRECONTENCIOSO') pef_id,
     fun_id,
     'SYS',
     sysdate
from     
   (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
       WHERE fun.FUN_DESCRIPCION IN ( 
		'TAB_PRECONTENCIOSO','ACCIONES_PRECONTENCIOSO','BUSQUEDA_PRECONTENCIOSO','TAB_PRECONTENCIOSO_DOCUMENTOS','TAB_PRECONTENCIOSO_LIQUIDACIONES','TAB_PRECONTENCIOSO_BUROFAXES'   
	   )
   );
   
-- 'Director territorial riesgos'   
INSERT INTO CM01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cmmaster.S_FUN_FUNCIONES.nextval,
      (SELECT PEF_ID from CM01.PEF_PERFILES  WHERE PEF_CODIGO = 'DIR_TERRITORIAL_RIESGOS') pef_id,
      fun_id,
      'SYS',
      sysdate
from     
    (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
        WHERE fun.FUN_DESCRIPCION IN ( 'MENU-LIST-CLI', 'MENU-LIST-EXP', 'MENU-LIST-ASU', 'BUSQUEDA', 'EDITAR_TITULOS', 'EDITAR_GYA', 'NUEVO_TITULO', 'BORRA_TITULO', 'SOLICITAR_PRORROGA', 'SOLICITAR_EXP_MANUAL', 'EXCLUIR_CLIENTES', 'MENU-LIST-CNT', 'EDITAR_GYA_REV', 'TAB-CNT-EXP-ASU', 'SOLICITAR_EXP_MANUAL_SEG', 'VER-OBSERVACIONES-ASUNTO', 'BUSCAR-TAREAS', 'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO', 'TAB_CLIENTE_HISTORICOS', 'CREAR_ANOTACIONES', 'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 'TAB_CLIENTE_CIRBE', 'EXPORTAR_PDF_EXPEDIENTE', 'BUSCAR-SUBASTAS', 'TAB_TITULOS_EXPEDIENTE' )
    ); 

-- 'Director territorial'   
INSERT INTO CM01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cmmaster.S_FUN_FUNCIONES.nextval,
      (SELECT PEF_ID from CM01.PEF_PERFILES  WHERE PEF_CODIGO = 'DIR_TERRITORIAL_RIESGOS') pef_id,
      fun_id,
      'SYS',
      sysdate
from     
    (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
        WHERE fun.FUN_DESCRIPCION IN ( 'MENU-LIST-CLI', 'MENU-LIST-EXP', 'MENU-LIST-ASU', 'BUSQUEDA', 'EDITAR_TITULOS', 'EDITAR_GYA', 'NUEVO_TITULO', 'BORRA_TITULO', 'SOLICITAR_PRORROGA', 'SOLICITAR_EXP_MANUAL', 'EXCLUIR_CLIENTES', 'MENU-LIST-CNT', 'EDITAR_GYA_REV', 'TAB-CNT-EXP-ASU', 'SOLICITAR_EXP_MANUAL_SEG', 'VER-OBSERVACIONES-ASUNTO', 'BUSCAR-TAREAS', 'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO', 'TAB_CLIENTE_HISTORICOS', 'CREAR_ANOTACIONES', 'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 'TAB_CLIENTE_CIRBE', 'EXPORTAR_PDF_EXPEDIENTE', 'BUSCAR-SUBASTAS', 'TAB_TITULOS_EXPEDIENTE' )
    );
    
-- 'RRHH'   
INSERT INTO CM01.FUN_PEF (FP_ID,PEF_ID,FUN_ID,USUARIOCREAR,FECHACREAR) 
select cmmaster.S_FUN_FUNCIONES.nextval,
      (SELECT PEF_ID from CM01.PEF_PERFILES  WHERE PEF_CODIGO = 'RRHH') pef_id,
      fun_id,
      'SYS',
      sysdate
from     
    (SELECT fun.fun_id FROM cmmaster.FUN_FUNCIONES fun
        WHERE fun.FUN_DESCRIPCION IN ( 'MENU-LIST-CLI', 'MENU-LIST-EXP', 'MENU-LIST-ASU', 'BUSQUEDA', 'EDITAR_TITULOS', 'EDITAR_GYA', 'NUEVO_TITULO', 'BORRA_TITULO', 'SOLICITAR_PRORROGA', 'SOLICITAR_EXP_MANUAL', 'EXCLUIR_CLIENTES', 'MENU-LIST-CNT', 'EDITAR_GYA_REV', 'TAB-CNT-EXP-ASU', 'SOLICITAR_EXP_MANUAL_SEG', 'VER-OBSERVACIONES-ASUNTO', 'BUSCAR-TAREAS', 'SECCION_BIENES_EN_CONTRATO', 'BUSCAR-BIENES', 'TAB_CLIENTE_CONTRATOS', 'TAB_CLIENTE_CABECERA', 'TAB_CLIENTE_DATOS', 'TAB_CLIENTE_GRUPO', 'TAB_CLIENTE_HISTORICOS', 'CREAR_ANOTACIONES', 'OPTIMIZACION_BUZON_TAREAS', 'TAB_CONTRATO_RECIBOS', 'MENU_BUSQUEDAS_GENERAL', 'TAB_COBROS_PAGOS_EXP', 'TAB_CLIENTE_CIRBE', 'EXPORTAR_PDF_EXPEDIENTE', 'BUSCAR-SUBASTAS', 'TAB_TITULOS_EXPEDIENTE' )
    );

/* insertar usuarios de grupo por despacho */   

 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GCGHRE', '1234', 'Grupo - Gestor control de gestion HRE', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'SCGHRE', '1234', 'Grupo - Supervisor control gestion HRE', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'DIRECU', '1234', 'Grupo - Direccion recuperaciones', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GESTC', '1234', 'Grupo - Gestor concursal', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GESTI', '1234', 'Grupo - Gestor de incumplimiento', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GESTR', '1234', 'Grupo - Gerente de recuperaciones', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GESTA', '1234', 'Grupo - Gestor analisis de recuperaciones', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GESTCHRE', '1234', 'Grupo - Gestor concursal HRE', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GACON', '1234', 'Grupo - Gestor administracion contable', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GOFI', '1234', 'Grupo - Gestor oficina', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'SUPCO', '1234', 'Grupo - Supervisor concursal', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'SUPIN', '1234', 'Grupo - Supervisor de incumplimiento', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'SUPANAREC', '1234', 'Grupo - Supervisor analisis de recuperaciones', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'SUPCHRE', '1234', 'Grupo - Supervisor concursal HRE', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'SUPADMC', '1234', 'Grupo - Supervisor administracion contable', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'DIRCON', '1234', 'Grupo - Director concursal', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'DIRCGHRE', '1234', 'Grupo - Director control gestion HRE', sysdate, 'SAG', 1, 1);
 insert into cmmaster.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre, fechacrear, usuariocrear, usu_externo, usu_grupo) values (cmmaster.s_usu_usuarios.nextval, 1, 'GESTCOHREI', '1234', 'Grupo - Gestor concursal HRE insinuacion', sysdate, 'SAG', 1, 1);

insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GCGHRE'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'DIRECU'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'DIRCON'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'DIRCGHRE'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTR'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GACON'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTA'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTC'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTCHRE'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTCOHREI'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTI'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'GEST_EXTERNO'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GOFI'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPADMC'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPANAREC'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPCO'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPCHRE'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SCGHRE'), 'SAG', sysdate);
insert into cm01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values(cm01.s_zon_pef_usu.nextval, (select max(zon_id) from cm01.zon_zonificacion where zon_cod = '01'),  (select pef_id from cm01.pef_perfiles where pef_codigo = 'SUP_SUPERVISOR'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPIN'), 'SAG', sysdate);

insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Direccion recuperaciones'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'DIRECU' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Director concursal'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'DIRCON' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Director control gestion HRE'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'DIRCGHRE' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gerente de recuperaciones'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTR' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor administracion contable'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GACON' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor analisis de recuperaciones'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTA' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor concursal'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTC' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor concursal HRE insinuacion'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTCOHREI' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor control de gestion HRE'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GCGHRE' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor de incumplimiento'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTI' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor HRE'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GESTCHRE' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Gestor oficina'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'GOFI' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Supervisor administracion contable'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPADMC' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Supervisor analisis de recuperaciones'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPANAREC' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Supervisor concursal'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPCO' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Supervisor control gestion HRE'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SCGHRE' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Supervisor de incumplimiento'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPIN' and borrado = 0), 1, 0, sysdate, 'SAG');
insert into cm01.usd_usuarios_despachos usd (usd_id, des_id, usu_id, usd_gestor_defecto, usd_supervisor, fechacrear, usuariocrear) values (cm01.s_usd_usuarios_despachos.nextval,  (select des_id from cm01.des_despacho_externo where borrado = 0 and des_despacho = 'Despacho Supervisor HRE'), (select usu_id from cmmaster.usu_usuarios where usu_username = 'SUPCHRE' and borrado = 0), 1, 0, sysdate, 'SAG');

--  insertar usuarios de validacion

--Creamos los usuarios

insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.dirriesgo','1234','gestor de expedientes','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.gesriesgo','1234','gestor de expedientes','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.oficina','1234','gestor de expedientes','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'CAJAMAR','1234','Administrador','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.servcentrales','1234','Servicios centrales','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.dirterriegos','1234','Direccion territorial riesgos','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.dirterritorial','1234','Direccion territorial','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.rrhh','1234','Recursos humanos','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.gestdocumentacion','1234','Gestor documentacion','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.gestliquidaciones','1234','Gestor liquidaciones','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GESCON','1234','Gestor concursal','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GESCHRE','1234','Gestor control de gestion HRE','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.SUCHRE','1234','Supervisor control gestion HRE','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.DIRREC','1234','Direccion recuperaciones','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GESINC','1234','Gestor de incumplimiento','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GERREC','1234','Gerente de recuperaciones','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GEANREC','1234','Gestor analisis de recuperaciones','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GESHRE','1234','Gestor concursal HRE','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GADMCON','1234','Gestor administracion contable','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GESOF','1234','Gestor oficina','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.SUCON','1234','Supervisor concursal','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.SUINC','1234','Supervisor de incumplimiento','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.SUANREC','1234','Supervisor analisis de recuperaciones','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.SUHRE','1234','Supervisor concursal HRE','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.SUADCON','1234','Supervisor administracion contable','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.DIRCON','1234','Director concursal','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.DIRHRE','1234','Director control gestion HRE','','','' , 'JSV', sysdate, 0,0);
insert into CMMASTER.usu_usuarios (usu_id, entidad_id, usu_username, usu_password, usu_nombre,usu_apellido1,usu_apellido2,usu_mail, usuariocrear,fechacrear, usu_externo, usu_grupo)  values  ( CMMASTER.s_usu_usuarios.nextval, 1,'val.GEHREIN','1234','Gestor concursal HRE insinuacion','','','' , 'JSV', sysdate, 0,0);

--Zonificamos los usuarios

insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Director de riesgos' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.dirriesgo') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor de riesgos' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.gesriesgo') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Oficina' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.oficina') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Administrador' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'CAJAMAR') , 'JSV', sysdate );
--insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.gestor.concursos') , 'JSV', sysdate );
--insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Externo' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.gestor.concursos') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Servicios centrales' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.servcentrales') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Director territorial riesgos' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.dirterriegos') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Director territorial' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.dirterritorial') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'RRHH' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.rrhh') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Precontencioso' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.gestdocumentacion') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.gestdocumentacion') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Precontencioso' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.gestliquidaciones') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.gestliquidaciones') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Precontencioso' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESCHRE') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUCHRE') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUCHRE') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.DIRREC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESINC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESINC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GERREC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GERREC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GEANREC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Externo' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESHRE') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GADMCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GESOF') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Interno' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUINC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUANREC') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUHRE') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.SUADCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.DIRCON') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Supervisor' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.DIRHRE') , 'JSV', sysdate );
insert into CM01.zon_pef_usu zpu (zpu.zpu_id, zpu.zon_id, zpu.pef_id, zpu.usu_id, zpu.usuariocrear, zpu.fechacrear)values ( CM01.s_zon_pef_usu.nextval, (select max(zon_id) from CM01.zon_zonificacion where zon_cod ='01'),(SELECT pef_id FROM CM01.pef_perfiles WHERE PEF_DESCRIPCION = 'Gestor Externo' and borrado = 0),(SELECT usu_id FROM CMMASTER.usu_usuarios WHERE usu_username = 'val.GEHREIN') , 'JSV', sysdate );


---Despacho
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.gestdocumentacion'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Precontencioso - Gestor de liquidacion'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.gestliquidaciones'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Precontencioso - Gestor de documentacion'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESCON'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor concursal'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESCHRE'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor control de gestion HRE'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUCHRE'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Supervisor control gestion HRE'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.DIRREC'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Direccion recuperaciones'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESINC'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor de incumplimiento'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GERREC'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gerente de recuperaciones'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GEANREC'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor analisis de recuperaciones'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESHRE'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor HRE'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GADMCON'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor administracion contable'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESOF'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor oficina'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUCON'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Supervisor concursal'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUINC'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Supervisor de incumplimiento'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUANREC'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Supervisor analisis de recuperaciones'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUHRE'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Supervisor HRE'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUADCON'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Supervisor administracion contable'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.DIRCON'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Director concursal'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.DIRHRE'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Director control gestion HRE'),0,0 , 'JSV', sysdate );
insert into CM01.usd_usuarios_despachos usd (usd_id, usu_id, des_id, usd_gestor_defecto, usd_supervisor, usuariocrear, fechacrear) values (CM01.s_usd_usuarios_despachos.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GEHREIN'), (select des.des_id from CM01.des_despacho_externo des where des.borrado = 0 and des.DES_DESPACHO = 'Despacho Gestor concursal HRE insinuacion'),0,0 , 'JSV', sysdate );

---GRUPO
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESCON'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GESTC' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESCHRE'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GCGHRE' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUCHRE'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='SCGHRE' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.DIRREC'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='DIRECU' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESCON'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GESTC' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESINC'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GESTI' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GERREC'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GESTR' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GEANREC'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GESTA' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESHRE'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GESTCHRE' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GADMCON'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GACON' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GESOF'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GOFI' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUCON'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='SUPCO' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUINC'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='SUPIN' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUANREC'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='SUPANAREC' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUHRE'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='SUPCHRE' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.SUADCON'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='SUPADMC' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.DIRCON'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='DIRCON' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.DIRHRE'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='DIRCGHRE' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );
INSERT INTO CMMASTER.GRU_GRUPOS_USUARIOS gru (gru.GRU_ID,gru.USU_ID_USUARIO,gru.USU_ID_GRUPO,gru.USUARIOCREAR,gru.FECHACREAR) VALUES (CMMASTER.s_GRU_GRUPOS_USUARIOS.nextval,(select usu.usu_id from CMMASTER.usu_usuarios usu where usu.usu_username = 'val.GEHREIN'), (SELECT usugrupo.usu_id FROM CM01.usd_usuarios_despachos usdgrupo INNER JOIN CMMASTER.usu_usuarios usugrupo ON usugrupo.usu_id = usdgrupo.usu_id AND usugrupo.usu_grupo = 1 WHERE usugrupo.usu_username ='GESTCOHREI' AND usugrupo.borrado = 0 ) , 'JSV', sysdate );

-- carterizar migracion


-- Gestor concursal

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.des_despacho_externo des inner join cm01.usd_usuarios_despachos usd on des.des_id = usd.des_id inner join 
        cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESCON' and des.des_despacho = 'Despacho Gestor concursal') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2
                   )
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESCON') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2 )
 ) aux ;

-- Gestor control de gestion HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESCHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESCHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
  
-- Supervisor control gestion HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUCHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUCHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
-- Direccion recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.DIRREC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.DIRREC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 

 -- Gestor de incumplimiento

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESINC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESINC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
  -- Gerente de recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GERREC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GERREC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GERREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
   -- Gestor analisis de recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GEANREC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GEANREC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GEANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
  
   -- Gestor concursal HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
    -- Gestor administracion contable

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GADMCON') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GADMCON') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
  
    -- Gestor oficina

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESOF') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GESOF') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESOF'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
     -- Supervisor concursal

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUCON') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUCON') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
      -- Supervisor de incumplimiento

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUINC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUINC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUINC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
-- Supervisor analisis de recuperaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUANREC') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUANREC') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUANREC'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
 -- Supervisor concursal HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
  -- Supervisor administracion contable

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUADCON') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.SUADCON') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'SUADMCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
   -- Director concursal

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.DIRCON') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.DIRCON') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRCON'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
    -- Director control gestion HRE

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.DIRHRE') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.DIRHRE') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'DIRHRE'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
-- Gestor concursal HRE insinuacion

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GEHREIN') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.GEHREIN') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'GESHREIN'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
 -- Gestor documentacion

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.gestdocumentacion') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.gestdocumentacion') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GD_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;
 
 
-- Gestor liquidaciones

insert into cm01.GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, USUARIOCREAR, FECHACREAR)
select cm01.s_GAA_GESTOR_ADICIONAL_ASUNTO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.gestliquidaciones') usd_id,
       (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'), 'CONVIVE_F2', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAA_GESTOR_ADICIONAL_ASUNTO gaa 
                    where gaa.asu_id = asu.asu_id and gaa.dd_tge_id = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
  ) aux ;


insert into cm01.GAH_GESTOR_ADICIONAL_HISTORICO gah (gah.GAH_ID, gah.GAH_ASU_ID, gah.GAH_GESTOR_ID, gah.GAH_FECHA_DESDE, gah.GAH_TIPO_GESTOR_ID, usuariocrear, fechacrear)
select cm01.s_GAH_GESTOR_ADIC_HISTORICO.nextval, aux.asu_id,
       (select usd_id from cm01.usd_usuarios_despachos usd inner join cmmaster.usu_usuarios usu on usu.usu_id = usd.usu_id where usu.usu_username = 'val.gestliquidaciones') usd_id,
       sysdate, (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'), 'SAG', sysdate
from
 (select asu.asu_id
  from cm01.asu_asuntos asu
  where not exists (select 1 from cm01.GAH_GESTOR_ADICIONAL_HISTORICO gaa 
                    where gaa.gah_asu_id = asu.asu_id and gaa.GAH_TIPO_GESTOR_ID = (select dd_tge_id from cmmaster.dd_tge_tipo_gestor where dd_tge_codigo = 'CM_GL_PCO'))
  and asu.asu_id in (select asuu.asu_id
                    from cm01.asu_asuntos asuu inner join
                         cm01.dd_pas_propiedad_asunto pas on pas.dd_pas_id = asuu.dd_pas_id inner join
                         cm01.dd_ges_gestion_asunto ges on ges.dd_ges_id = asuu.dd_ges_id
                    where asuu.DD_TAS_ID = 2)
 ) aux ;


