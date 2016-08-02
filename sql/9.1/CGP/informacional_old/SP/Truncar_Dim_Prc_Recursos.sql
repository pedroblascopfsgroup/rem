-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_Dim_Prc_Recursos` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_Dim_Prc_Recursos`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_DIM_PRC_REC:BEGIN

-- ===============================================================================================
-- Autor: Joaquín Arnal PFS Group
-- Fecha creación: Marzo 2014
-- Responsable última modificación:
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: CDD
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Prc_Recursos.
-- ===============================================================================================

DECLARE HAY_TABLA INT;

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

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_ACTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_ACTOR;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_TIPO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_TIPO;
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_CAUSA' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_CAUSA;
end if;	 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_ES_FAV' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_ES_FAV;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_RESUL_RESOL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_RESUL_RESOL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_CONF_VISTA' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_CONF_VISTA;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_CONF_IMPUG' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_CONF_IMPUG;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_RECURSOS_SUSPENSIVO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_RECURSOS_SUSPENSIVO;
end if;	

END MY_BLOCK_TRUNC_DIM_PRC_REC
