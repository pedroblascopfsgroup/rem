-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Actuacion_Recobro`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_ACR: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Actuacion Recobro.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN ACTUACION RECOBRO
    -- DIM_ACTUACION_RECOBRO_MODELO;
    -- DIM_ACTUACION_RECOBRO_PROVEEDOR;
    -- DIM_ACTUACION_RECOBRO_TIPO;
    -- DIM_ACTUACION_RECOBRO_RESULTADO;
	
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
--                   				DIM_ACTUACION_RECOBRO_MODELO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ACTUACION_RECOBRO_MODELO where MODELO_ACTUACION_RECOBRO_ID = -1) = 0) then
	insert into DIM_ACTUACION_RECOBRO_MODELO (MODELO_ACTUACION_RECOBRO_ID, MODELO_ACTUACION_RECOBRO_ALT, MODELO_ACTUACION_RECOBRO_DESC_ALT) values (-1, 'Desconocido', -1);
end if;

 insert into DIM_ACTUACION_RECOBRO_MODELO(MODELO_ACTUACION_RECOBRO_ID, MODELO_ACTUACION_RECOBRO_ALT, MODELO_ACTUACION_RECOBRO_DESC_ALT)
    select DD_MOR_ID, DD_MOR_DESCRIPCION, DD_MOR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_MOR_MODELO_RECOBRO; 
	
	
-- ----------------------------------------------------------------------------------------------
--                   				DIM_ACTUACION_RECOBRO_PROVEEDOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ACTUACION_RECOBRO_PROVEEDOR where PROVEEDOR_ACTUACION_RECOBRO_ID = -2) = 0) then
	insert into DIM_ACTUACION_RECOBRO_PROVEEDOR (PROVEEDOR_ACTUACION_RECOBRO_ID, PROVEEDOR_ACTUACION_RECOBRO_DESC, PROVEEDOR_ACTUACION_RECOBRO_DESC_ALT) values (-2, 'No En Recobro', 'No En Recobro');
end if;

if ((select count(*) from DIM_ACTUACION_RECOBRO_PROVEEDOR where PROVEEDOR_ACTUACION_RECOBRO_ID = -1) = 0) then
	insert into DIM_ACTUACION_RECOBRO_PROVEEDOR (PROVEEDOR_ACTUACION_RECOBRO_ID, PROVEEDOR_ACTUACION_RECOBRO_DESC, PROVEEDOR_ACTUACION_RECOBRO_DESC_ALT) values (-1, 'Desconocido', 'Desconocido');
end if;

 insert into DIM_ACTUACION_RECOBRO_PROVEEDOR (PROVEEDOR_ACTUACION_RECOBRO_ID, PROVEEDOR_ACTUACION_RECOBRO_DESC, PROVEEDOR_ACTUACION_RECOBRO_DESC_ALT)
    select DD_PRE_ID, DD_PRE_DESCRIPCION, DD_PRE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRE_PROVEEDORES_RECOBRO; 
	
	
-- ----------------------------------------------------------------------------------------------
--                   				DIM_ACTUACION_RECOBRO_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ACTUACION_RECOBRO_TIPO where TIPO_ACTUACION_RECOBRO_ID = -1) = 0) then
	insert into DIM_ACTUACION_RECOBRO_TIPO (TIPO_ACTUACION_RECOBRO_ID, TIPO_ACTUACION_RECOBRO_DESC, TIPO_ACTUACION_RECOBRO_DESC_ALT) values (-1, 'Desconocido', 'Desconocido');
end if;

 insert into DIM_ACTUACION_RECOBRO_TIPO(TIPO_ACTUACION_RECOBRO_ID, TIPO_ACTUACION_RECOBRO_DESC, TIPO_ACTUACION_RECOBRO_DESC_ALT)
    select DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TGE_TIPO_GESTION; 
    

-- ----------------------------------------------------------------------------------------------
--                   				DIM_ACTUACION_RECOBRO_RESULTADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ACTUACION_RECOBRO_RESULTADO where RESULTADO_ACTUACION_RECOBRO_ID = -1) = 0) then
	insert into DIM_ACTUACION_RECOBRO_RESULTADO (RESULTADO_ACTUACION_RECOBRO_ID, RESULTADO_ACTUACION_RECOBRO_DESC, RESULTADO_ACTUACION_RECOBRO_DESC_ALT) values (-1, 'Desconocido', 'Desconocido');
end if;

insert into DIM_ACTUACION_RECOBRO_RESULTADO (RESULTADO_ACTUACION_RECOBRO_ID, RESULTADO_ACTUACION_RECOBRO_DESC, RESULTADO_ACTUACION_RECOBRO_DESC_ALT)
    select DD_RGT_ID, DD_RGT_DESCRIPCION, DD_RGT_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_RGT_RESULT_GESTION_TEL; 
    

END MY_BLOCK_DIM_ACR
