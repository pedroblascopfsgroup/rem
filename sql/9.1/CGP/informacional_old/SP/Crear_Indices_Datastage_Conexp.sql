-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_Indices_Datastage_Conexp` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_Indices_Datastage_Conexp`(OUT o_error_status varchar(500))
MY_BLOCK_IND: BEGIN

-- ===============================================================================================
-- Autor: Enrique Jiménez, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea índices en las tablas del datastage
-- ===============================================================================================

DECLARE HAY INT;
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


-- select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'EXP_EXPEDIENTE' and table_schema = 'bi_cdd_conexp_datastage' and INDEX_NAME = 'EXP_EXPEDIENTE_IX';
-- select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'EXP_EXPEDIENTE' and table_schema = 'bi_cdd_conexp_datastage';
-- if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX EXP_EXPEDIENTE_IX ON bi_cdd_conexp_datastage.EXP_EXPEDIENTE (exp_id);
--	set o_error_status:= concat('Se ha insertado el INDICE EXP_EXPEDIENTE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE EXP_EXPEDIENTE_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
-- end if;


-- select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'DEJ_DEMANDA_JUDICIAL' and table_schema = 'bi_cdd_conexp_datastage' and INDEX_NAME = 'DEJ_DEMANDA_JUDICIAL_IX';
-- select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'DEJ_DEMANDA_JUDICIAL' and table_schema = 'bi_cdd_conexp_datastage';
-- if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX DEJ_DEMANDA_JUDICIAL_IX ON bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL (exp_id);
--	set o_error_status:= concat('Se ha insertado el INDICE DEJ_DEMANDA_JUDICIAL_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE DEJ_DEMANDA_JUDICIAL_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
-- end if;



-- select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'GKO_GESTION_KO' and table_schema = 'bi_cdd_conexp_datastage' and INDEX_NAME = 'GKO_GESTION_KO_IX';
-- select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'GKO_GESTION_KO' and table_schema = 'bi_cdd_conexp_datastage';
-- if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX GKO_GESTION_KO_IX ON bi_cdd_conexp_datastage.GKO_GESTION_KO (exp_id);
--	set o_error_status:= concat('Se ha insertado el INDICE GKO_GESTION_KO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE GKO_GESTION_KO_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
-- end if;



-- select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'FAC_FACTURACION' and table_schema = 'bi_cdd_conexp_datastage' and INDEX_NAME = 'FAC_FACTURACION_IX';
-- select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'FAC_FACTURACION' and table_schema = 'bi_cdd_conexp_datastage';
-- if (HAY < 1 && HAY_TABLA = 1) then 
	CREATE INDEX FAC_FACTURACION_IX ON bi_cdd_conexp_datastage.FAC_FACTURACION (exp_id);
-- set o_error_status:= concat('Se ha insertado el INDICE FAC_FACTURACION_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE FAC_FACTURACION_IX. Nº [', HAY, '] o no existe la Tabla. Nº[',HAY_TABLA,']');
-- end if;


END MY_BLOCK_IND
