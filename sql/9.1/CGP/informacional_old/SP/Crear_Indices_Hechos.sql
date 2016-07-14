-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_Indices_Hechos` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_Indices_Hechos`(OUT o_error_status varchar(500))
MY_BLOCK_IND: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea índices en las tablas de hechos
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


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_IX ON H_EXP (DIA_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_SEMANA' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_SEMANA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_SEMANA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_SEMANA_IX ON H_EXP_SEMANA (SEMANA_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_SEMANA_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_SEMANA_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_MES' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_MES_IX ON H_EXP_MES (MES_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_MES_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_MES_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_TRIMESTRE_IX ON H_EXP_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_TRIMESTRE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_TRIMESTRE_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_ANIO' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_ANIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_ANIO_IX ON H_EXP_ANIO (ANIO_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_ANIO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_ANIO_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_KO' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_KO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_KO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_KO_IX ON H_EXP_DET_KO (DIA_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_KO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_KO_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_KO_SEMANA' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_KO_SEMANA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_KO_SEMANA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_KO_SEMANA_IX ON H_EXP_DET_KO_SEMANA (SEMANA_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_KO_SEMANA_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_KO_SEMANA_IX. Nº [', HAY, ']');
end if;



select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_KO_MES' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_KO_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_KO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_KO_MES_IX ON H_EXP_DET_KO_MES (MES_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_KO_MES_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_KO_MES_IX. Nº [', HAY, ']');
end if;




select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_KO_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_KO_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_KO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_KO_TRIMESTRE_IX ON H_EXP_DET_KO_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_KO_TRIMESTRE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_KO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;



select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_KO_ANIO' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_KO_ANIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_KO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_KO_ANIO_IX ON H_EXP_DET_KO_ANIO (ANIO_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_KO_ANIO_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_KO_ANIO_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_FACTURA' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_FACTURA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_FACTURA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_FACTURA_IX ON H_EXP_DET_FACTURA (DIA_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_FACTURA_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_FACTURA_IX. Nº [', HAY, ']');
end if;



select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_FACTURA_SEMANA' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_FACTURA_SEMANA' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_FACTURA_SEMANA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_FACTURA_SEMANA_IX ON H_EXP_DET_FACTURA_SEMANA (SEMANA_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_FACTURA_SEMANA_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_FACTURA_SEMANA_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_FACTURA_MES' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_FACTURA_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_FACTURA_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_FACTURA_MES_IX ON H_EXP_DET_FACTURA_MES (MES_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_FACTURA_MES_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_FACTURA_MES_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_FACTURA_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_FACTURA_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_FACTURA_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_FACTURA_TRIMESTRE_IX ON H_EXP_DET_FACTURA_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_FACTURA_TRIMESTRE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_FACTURA_TRIMESTRE_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EXP_DET_FACTURA_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EXP_DET_FACTURA_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_EXP_DET_FACTURA_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_EXP_DET_FACTURA_TRIMESTRE_IX ON H_EXP_DET_FACTURA_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_EXP_DET_FACTURA_TRIMESTRE_IX. Nº [', HAY, ']');
-- else 
--	set o_error_status:= concat('Ya existe el INDICE H_EXP_DET_FACTURA_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

END MY_BLOCK_IND
