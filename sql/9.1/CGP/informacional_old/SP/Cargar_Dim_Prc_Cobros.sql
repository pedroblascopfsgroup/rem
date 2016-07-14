-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Prc_Cobros` $$


-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Prc_Cobros`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_PRC_COBROS: BEGIN


-- ===============================================================================================
-- Autor: Joaquín Arnal, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Prc_Cobros.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN PRC_COBROS 
  	-- D_PRC_COBRO_ESTADO_PAGO
	-- D_PRC_COBRO_TIPO_PAGO
	-- D_PRC_COBRO_SUBTIPO_PAGO

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
--                                      D_PRC_COBRO_ESTADO_PAGO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_COBRO_ESTADO_PAGO where ESTADO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_COBRO_ESTADO_PAGO (ESTADO_PAGO_ID, ESTADO_PAGO_CODIGO, ESTADO_PAGO_DESC, ESTADO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', 'Desconocido', -1);
end if;
if ((select count(*) from D_PRC_COBRO_ESTADO_PAGO where ESTADO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_PRC_COBRO_ESTADO_PAGO (ESTADO_PAGO_ID, ESTADO_PAGO_CODIGO, ESTADO_PAGO_DESC, ESTADO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 1);
end if;
if ((select count(*) from D_PRC_COBRO_ESTADO_PAGO where ESTADO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_PRC_COBRO_ESTADO_PAGO (ESTADO_PAGO_ID, ESTADO_PAGO_CODIGO, ESTADO_PAGO_DESC, ESTADO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 2);
end if;
if ((select count(*) from D_PRC_COBRO_ESTADO_PAGO where ESTADO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_PRC_COBRO_ESTADO_PAGO (ESTADO_PAGO_ID, ESTADO_PAGO_CODIGO, ESTADO_PAGO_DESC, ESTADO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 3);
end if;
if ((select count(*) from D_PRC_COBRO_ESTADO_PAGO where ESTADO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_PRC_COBRO_ESTADO_PAGO (ESTADO_PAGO_ID, ESTADO_PAGO_CODIGO, ESTADO_PAGO_DESC, ESTADO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 4);
end if;

 	insert into D_PRC_COBRO_ESTADO_PAGO (ESTADO_PAGO_ID, ESTADO_PAGO_CODIGO, ESTADO_PAGO_DESC, ESTADO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select DD_ECP_ID, DD_ECP_CODIGO, DD_ECP_DESCRIPCION, DD_ECP_DESCRIPCION_LARGA, 1 FROM bi_cdd_bng_datastage.DD_ECP_ESTADO_COBRO_PAGO
	    UNION
	    select DD_ECP_ID, DD_ECP_CODIGO, DD_ECP_DESCRIPCION, DD_ECP_DESCRIPCION_LARGA, 2 FROM bi_cdd_bbva_datastage.DD_ECP_ESTADO_COBRO_PAGO
	    UNION
	    select DD_ECP_ID, DD_ECP_CODIGO, DD_ECP_DESCRIPCION, DD_ECP_DESCRIPCION_LARGA, 3 FROM bi_cdd_bankia_datastage.DD_ECP_ESTADO_COBRO_PAGO    
	    UNION
	   	select DD_ECP_ID, DD_ECP_CODIGO, DD_ECP_DESCRIPCION, DD_ECP_DESCRIPCION_LARGA, 4 FROM bi_cdd_cajamar_datastage.DD_ECP_ESTADO_COBRO_PAGO        
	;

-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_COBRO_TIPO_PAGO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_COBRO_TIPO_PAGO where TIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_COBRO_TIPO_PAGO (TIPO_PAGO_ID, TIPO_PAGO_CODIGO, TIPO_PAGO_DESC, TIPO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', 'Desconocido', -1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_PAGO where TIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_PRC_COBRO_TIPO_PAGO (TIPO_PAGO_ID, TIPO_PAGO_CODIGO, TIPO_PAGO_DESC, TIPO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_PAGO where TIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_PRC_COBRO_TIPO_PAGO (TIPO_PAGO_ID, TIPO_PAGO_CODIGO, TIPO_PAGO_DESC, TIPO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 2);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_PAGO where TIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_PRC_COBRO_TIPO_PAGO (TIPO_PAGO_ID, TIPO_PAGO_CODIGO, TIPO_PAGO_DESC, TIPO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 3);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_PAGO where TIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_PRC_COBRO_TIPO_PAGO (TIPO_PAGO_ID, TIPO_PAGO_CODIGO, TIPO_PAGO_DESC, TIPO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'No indicado', 'No indicado', 'No indicado', 4);
end if;

	insert into D_PRC_COBRO_TIPO_PAGO (TIPO_PAGO_ID, TIPO_PAGO_CODIGO, TIPO_PAGO_DESC, TIPO_PAGO_DESC_LARGA, ENTIDAD_CEDENTE_ID)
	    select DD_TCP_ID, DD_TCP_CODIGO, DD_TCP_DESCRIPCION, DD_TCP_DESCRIPCION_LARGA, 1 FROM bi_cdd_bng_datastage.DD_TCP_TIPO_COBRO_PAGO
	    UNION
	    select DD_TCP_ID, DD_TCP_CODIGO, DD_TCP_DESCRIPCION, DD_TCP_DESCRIPCION_LARGA, 2 FROM bi_cdd_bbva_datastage.DD_TCP_TIPO_COBRO_PAGO
	    UNION
	    select DD_TCP_ID, DD_TCP_CODIGO, DD_TCP_DESCRIPCION, DD_TCP_DESCRIPCION_LARGA, 3 FROM bi_cdd_bankia_datastage.DD_TCP_TIPO_COBRO_PAGO    
	    UNION
	   	select DD_TCP_ID, DD_TCP_CODIGO, DD_TCP_DESCRIPCION, DD_TCP_DESCRIPCION_LARGA, 4 FROM bi_cdd_cajamar_datastage.DD_TCP_TIPO_COBRO_PAGO        
	;

-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_COBRO_SUBTIPO_PAGO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_COBRO_SUBTIPO_PAGO where SUBTIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_COBRO_SUBTIPO_PAGO (SUBTIPO_PAGO_ID, SUBTIPO_PAGO_CODIGO, SUBTIPO_PAGO_DESC, SUBTIPO_PAGO_DESC_LARGA, TIPO_PAGO_ID, ENTIDAD_CEDENTE_ID)
	values (-1 ,'Desconocido', 'Desconocido', 'Desconocido', -1, -1);
end if;
if ((select count(*) from D_PRC_COBRO_SUBTIPO_PAGO where SUBTIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_PRC_COBRO_SUBTIPO_PAGO (SUBTIPO_PAGO_ID, SUBTIPO_PAGO_CODIGO, SUBTIPO_PAGO_DESC, SUBTIPO_PAGO_DESC_LARGA, TIPO_PAGO_ID, ENTIDAD_CEDENTE_ID)
	values (-1 ,'No indicado', 'No indicado', 'No indicado', -1, 1);
end if;
if ((select count(*) from D_PRC_COBRO_SUBTIPO_PAGO where SUBTIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_PRC_COBRO_SUBTIPO_PAGO (SUBTIPO_PAGO_ID, SUBTIPO_PAGO_CODIGO, SUBTIPO_PAGO_DESC, SUBTIPO_PAGO_DESC_LARGA, TIPO_PAGO_ID, ENTIDAD_CEDENTE_ID)
	values (-1 ,'No indicado', 'No indicado', 'No indicado', -1, 2);
end if;
if ((select count(*) from D_PRC_COBRO_SUBTIPO_PAGO where SUBTIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_PRC_COBRO_SUBTIPO_PAGO (SUBTIPO_PAGO_ID, SUBTIPO_PAGO_CODIGO, SUBTIPO_PAGO_DESC, SUBTIPO_PAGO_DESC_LARGA, TIPO_PAGO_ID, ENTIDAD_CEDENTE_ID)
	values (-1 ,'No indicado', 'No indicado', 'No indicado', -1, 3);
end if;
if ((select count(*) from D_PRC_COBRO_SUBTIPO_PAGO where SUBTIPO_PAGO_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_PRC_COBRO_SUBTIPO_PAGO (SUBTIPO_PAGO_ID, SUBTIPO_PAGO_CODIGO, SUBTIPO_PAGO_DESC, SUBTIPO_PAGO_DESC_LARGA, TIPO_PAGO_ID, ENTIDAD_CEDENTE_ID)
	values (-1 ,'No indicado', 'No indicado', 'No indicado', -1, 4);
end if;

	insert into D_PRC_COBRO_SUBTIPO_PAGO (SUBTIPO_PAGO_ID, SUBTIPO_PAGO_CODIGO, SUBTIPO_PAGO_DESC, SUBTIPO_PAGO_DESC_LARGA, TIPO_PAGO_ID, ENTIDAD_CEDENTE_ID)
	    select DD_SCP_ID, DD_SCP_CODIGO, DD_SCP_DESCRIPCION, DD_SCP_DESCRIPCION_LARGA, DD_TCP_ID, 1 FROM bi_cdd_bng_datastage.DD_SCP_SUBTIPO_COBRO_PAGO
	    UNION
	    select DD_SCP_ID, DD_SCP_CODIGO, DD_SCP_DESCRIPCION, DD_SCP_DESCRIPCION_LARGA, DD_TCP_ID, 2 FROM bi_cdd_bbva_datastage.DD_SCP_SUBTIPO_COBRO_PAGO
	    UNION
	    select DD_SCP_ID, DD_SCP_CODIGO, DD_SCP_DESCRIPCION, DD_SCP_DESCRIPCION_LARGA, DD_TCP_ID, 3 FROM bi_cdd_bankia_datastage.DD_SCP_SUBTIPO_COBRO_PAGO    
	    UNION
	   	select DD_SCP_ID, DD_SCP_CODIGO, DD_SCP_DESCRIPCION, DD_SCP_DESCRIPCION_LARGA, DD_TCP_ID, 4 FROM bi_cdd_cajamar_datastage.DD_SCP_SUBTIPO_COBRO_PAGO        
	;


END MY_BLOCK_DIM_PRC_COBROS
