-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Prc_Recursos` $$


-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Prc_Recursos`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_PRC_RECURSOS: BEGIN


-- ===============================================================================================
-- Autor: Joaquín Arnal, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Prc_Recursos.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN PRC_RECURSOS 
  	-- D_PRC_RECURSOS_ACTOR
	-- D_PRC_RECURSOS_TIPO
	-- D_PRC_RECURSOS_CAUSA
	-- D_PRC_RECURSOS_ES_FAV
	-- D_PRC_RECURSOS_RESUL_RESOL
	-- D_PRC_RECURSOS_CONF_VISTA
	-- D_PRC_RECURSOS_CONF_IMPUG
	-- D_PRC_RECURSOS_SUSPENSIVO

-- ===============================================================================================
 
-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: Número de parámetros incorrecto'; 

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DEL HANDLER GENÉRICO DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

 
-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_ACTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_ACTOR where ACTOR_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_ACTOR (ACTOR_ID, ACTOR_CODIGO, ACTOR_DESC, ACTOR_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_ACTOR (ACTOR_ID, ACTOR_CODIGO, ACTOR_DESC, ACTOR_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select DD_ACT_ID, DD_ACT_CODIGO, DD_ACT_DESCRIPCION, DD_ACT_DESCRIPCION_LARGA, 1 FROM bi_cdd_bng_datastage.DD_ACT_ACTOR
	    UNION
	    select DD_ACT_ID, DD_ACT_CODIGO, DD_ACT_DESCRIPCION, DD_ACT_DESCRIPCION_LARGA, 2 FROM bi_cdd_bbva_datastage.DD_ACT_ACTOR
	    UNION
	    select DD_ACT_ID, DD_ACT_CODIGO, DD_ACT_DESCRIPCION, DD_ACT_DESCRIPCION_LARGA, 3 FROM bi_cdd_bankia_datastage.DD_ACT_ACTOR    
	    UNION
	   	select DD_ACT_ID, DD_ACT_CODIGO, DD_ACT_DESCRIPCION, DD_ACT_DESCRIPCION_LARGA, 4 FROM bi_cdd_cajamar_datastage.DD_ACT_ACTOR        
	;

-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_TIPO where TIPO_RECURSO_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_TIPO (TIPO_RECURSO_ID, TIPO_RECURSO_CODIGO, TIPO_RECURSO_DESC, TIPO_RECURSO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_TIPO (TIPO_RECURSO_ID, TIPO_RECURSO_CODIGO, TIPO_RECURSO_DESC, TIPO_RECURSO_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select DD_DTR_ID, DD_DTR_CODIGO, DD_DTR_DESCRIPCION, DD_DTR_DESCRIPCION_LARGA, 1 FROM bi_cdd_bng_datastage.DD_DTR_TIPO_RECURSO
	    UNION
	    select DD_DTR_ID, DD_DTR_CODIGO, DD_DTR_DESCRIPCION, DD_DTR_DESCRIPCION_LARGA, 2 FROM bi_cdd_bbva_datastage.DD_DTR_TIPO_RECURSO
	    UNION
	    select DD_DTR_ID, DD_DTR_CODIGO, DD_DTR_DESCRIPCION, DD_DTR_DESCRIPCION_LARGA, 3 FROM bi_cdd_bankia_datastage.DD_DTR_TIPO_RECURSO    
	    UNION
	   	select DD_DTR_ID, DD_DTR_CODIGO, DD_DTR_DESCRIPCION, DD_DTR_DESCRIPCION_LARGA, 4 FROM bi_cdd_cajamar_datastage.DD_DTR_TIPO_RECURSO        
	;

-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_CAUSA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_CAUSA where CAUSA_RECURSO_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_CAUSA (CAUSA_RECURSO_ID, CAUSA_RECURSO_CODIGO, CAUSA_RECURSO_DESC, CAUSA_RECURSO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_CAUSA (CAUSA_RECURSO_ID, CAUSA_RECURSO_CODIGO, CAUSA_RECURSO_DESC, CAUSA_RECURSO_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select DD_CRE_ID, DD_CRE_CODIGO, DD_CRE_DESCRIPCION, DD_CRE_DESCRIPCION_LARGA, 1 FROM bi_cdd_bng_datastage.DD_CRE_CAUSA_RECURSO
	    UNION
	    select DD_CRE_ID, DD_CRE_CODIGO, DD_CRE_DESCRIPCION, DD_CRE_DESCRIPCION_LARGA, 2 FROM bi_cdd_bbva_datastage.DD_CRE_CAUSA_RECURSO
	    UNION
	    select DD_CRE_ID, DD_CRE_CODIGO, DD_CRE_DESCRIPCION, DD_CRE_DESCRIPCION_LARGA, 3 FROM bi_cdd_bankia_datastage.DD_CRE_CAUSA_RECURSO    
	    UNION
	   	select DD_CRE_ID, DD_CRE_CODIGO, DD_CRE_DESCRIPCION, DD_CRE_DESCRIPCION_LARGA, 4 FROM bi_cdd_cajamar_datastage.DD_CRE_CAUSA_RECURSO        
	;

-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_ES_FAV
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_ES_FAV where ES_FAVORABLE_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_ES_FAV (ES_FAVORABLE_ID, ES_FAVORABLE_CODIGO, ES_FAVORABLE_DESC, ES_FAVORABLE_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_ES_FAV (ES_FAVORABLE_ID, ES_FAVORABLE_CODIGO, ES_FAVORABLE_DESC, ES_FAVORABLE_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select DD_FAV_ID, DD_FAV_CODIGO, DD_FAV_DESCRIPCION, DD_FAV_DESCRIPCION_LARGA, 1 FROM bi_cdd_bng_datastage.DD_FAV_FAVORABLE
	    UNION
	    select DD_FAV_ID, DD_FAV_CODIGO, DD_FAV_DESCRIPCION, DD_FAV_DESCRIPCION_LARGA, 2 FROM bi_cdd_bbva_datastage.DD_FAV_FAVORABLE
	    UNION
	    select DD_FAV_ID, DD_FAV_CODIGO, DD_FAV_DESCRIPCION, DD_FAV_DESCRIPCION_LARGA, 3 FROM bi_cdd_bankia_datastage.DD_FAV_FAVORABLE    
	    UNION
	   	select DD_FAV_ID, DD_FAV_CODIGO, DD_FAV_DESCRIPCION, DD_FAV_DESCRIPCION_LARGA, 4 FROM bi_cdd_cajamar_datastage.DD_FAV_FAVORABLE        
	;
	
-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_RESUL_RESOL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_RESUL_RESOL where RESULTADO_RESOL_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_RESUL_RESOL (RESULTADO_RESOL_ID, RESULTADO_RESOL_CODIGO, RESULTADO_RESOL_DESC, RESULTADO_RESOL_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_RESUL_RESOL (RESULTADO_RESOL_ID, RESULTADO_RESOL_CODIGO, RESULTADO_RESOL_DESC, RESULTADO_RESOL_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select DD_DRR_ID, DD_DRR_CODIGO, DD_DRR_DESCRIPCION, DD_DRR_DESCRIPCION_LARGA, 1 FROM bi_cdd_bng_datastage.DD_DRR_RESULTADO_RESOL
	    UNION
	    select DD_DRR_ID, DD_DRR_CODIGO, DD_DRR_DESCRIPCION, DD_DRR_DESCRIPCION_LARGA, 2 FROM bi_cdd_bbva_datastage.DD_DRR_RESULTADO_RESOL
	    UNION
	    select DD_DRR_ID, DD_DRR_CODIGO, DD_DRR_DESCRIPCION, DD_DRR_DESCRIPCION_LARGA, 3 FROM bi_cdd_bankia_datastage.DD_DRR_RESULTADO_RESOL    
	    UNION
	   	select DD_DRR_ID, DD_DRR_CODIGO, DD_DRR_DESCRIPCION, DD_DRR_DESCRIPCION_LARGA, 4 FROM bi_cdd_cajamar_datastage.DD_DRR_RESULTADO_RESOL        
	;

-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_CONF_VISTA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_CONF_VISTA where CONFIRM_VISTA_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_CONF_VISTA (CONFIRM_VISTA_ID, CONFIRM_VISTA_DESC, CONFIRM_VISTA_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_CONF_VISTA (CONFIRM_VISTA_ID, CONFIRM_VISTA_DESC, CONFIRM_VISTA_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select 0,'NO','NO', 1 FROM DUAL
		union
		select 1,'SI','SI', 1 FROM DUAL
		union
		select 0,'NO','NO', 2 FROM DUAL
		union
		select 1,'SI','SI', 2 FROM DUAL
		union
		select 0,'NO','NO', 3 FROM DUAL
		union
		select 1,'SI','SI', 3 FROM DUAL
		union
		select 0,'NO','NO', 4 FROM DUAL
		union
		select 1,'SI','SI', 4 FROM DUAL
	;
	
-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_CONF_IMPUG
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_CONF_IMPUG where CONFIRM_IMPUGNACION_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_CONF_IMPUG (CONFIRM_IMPUGNACION_ID, CONFIRM_IMPUGNACION_DESC, CONFIRM_IMPUGNACION_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_CONF_IMPUG (CONFIRM_IMPUGNACION_ID, CONFIRM_IMPUGNACION_DESC, CONFIRM_IMPUGNACION_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select 0,'NO','NO', 1 FROM DUAL
		union
		select 1,'SI','SI', 1 FROM DUAL
		union
		select 0,'NO','NO', 2 FROM DUAL
		union
		select 1,'SI','SI', 2 FROM DUAL
		union
		select 0,'NO','NO', 3 FROM DUAL
		union
		select 1,'SI','SI', 3 FROM DUAL
		union
		select 0,'NO','NO', 4 FROM DUAL
		union
		select 1,'SI','SI', 4 FROM DUAL
	;
	
-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_RECURSOS_SUSPENSIVO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_RECURSOS_SUSPENSIVO where SUSPENSIVO_ID = -1) = 0) then
	insert into D_PRC_RECURSOS_SUSPENSIVO (SUSPENSIVO_ID, SUSPENSIVO_DESC, SUSPENSIVO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 , 'Desconocido', 'Desconocido', -1);
end if;

 	insert into D_PRC_RECURSOS_SUSPENSIVO (SUSPENSIVO_ID, SUSPENSIVO_DESC, SUSPENSIVO_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select 0,'NO','NO', 1 FROM DUAL
		union
		select 1,'SI','SI', 1 FROM DUAL
		union
		select 0,'NO','NO', 2 FROM DUAL
		union
		select 1,'SI','SI', 2 FROM DUAL
		union
		select 0,'NO','NO', 3 FROM DUAL
		union
		select 1,'SI','SI', 3 FROM DUAL
		union
		select 0,'NO','NO', 4 FROM DUAL
		union
		select 1,'SI','SI', 4 FROM DUAL
	;
	

END MY_BLOCK_DIM_PRC_RECURSOS
