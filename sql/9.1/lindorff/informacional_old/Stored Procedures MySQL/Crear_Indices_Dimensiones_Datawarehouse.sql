-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Crear_Indices_Dimensiones_Datawarehouse`(OUT o_error_status varchar(500))
MY_BLOCK_IND: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 06/06/2014
-- Motivos del cambio: TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que crea índices en las tablas de dimensiones del datawarehouse
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

-- -------------------------------------------- ÍNDICE -------------------------------------------
-- ÍNDICES DE HECHOS DE CONTRATO
    -- TEMP_DESPACHO_ASUNTO
    -- DIM_CONTRATO
    -- TEMP_PROCEDIMIENTO_GESTOR
    -- TEMP_PROCEDIMIENTO_SUPERVISOR
    -- TEMP_TAREA_GESTOR
    -- TEMP_TAREA_SUPERVISOR

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_DESPACHO_ASUNTO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_DESPACHO_ASUNTO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_DESPACHO_ASUNTO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_DESPACHO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_DESPACHO_ASUNTO_IX on TEMP_DESPACHO_ASUNTO (ASUNTO_ID, DESPACHO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_DESPACHO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_DESPACHO_ASUNTO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    DIM_CONTRATO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'DIM_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DIM_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'DIM_CONTRATO_CONTRATO_COD_CONTRATO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX DIM_CONTRATO_CONTRATO_COD_CONTRATO_IX on DIM_CONTRATO (CONTRATO_COD_CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE DIM_CONTRATO_CONTRATO_COD_CONTRATO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE DIM_CONTRATO_CONTRATO_COD_CONTRATO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'DIM_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DIM_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'DIM_CONTRATO_CCC_LITIGIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX DIM_CONTRATO_CCC_LITIGIO_IX on DIM_CONTRATO (CCC_LITIGIO);
    set o_error_status:= concat('Se ha insertado el INDICE DIM_CONTRATO_CCC_LITIGIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE DIM_CONTRATO_CCC_LITIGIO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'DIM_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DIM_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'DIM_CONTRATO_NUC_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX DIM_CONTRATO_NUC_IX on DIM_CONTRATO (NUC_LITIGIO);
    set o_error_status:= concat('Se ha insertado el INDICE DIM_CONTRATO_NUC_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE DIM_CONTRATO_NUC_IX. Nº [', HAY, ']');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_GESTOR
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_GESTOR' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_GESTOR' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_GESTOR_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX TEMP_PROCEDIMIENTO_GESTOR_IX on TEMP_PROCEDIMIENTO_GESTOR (PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_GESTOR_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_GESTOR_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_SUPERVISOR' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_SUPERVISOR' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_SUPERVISOR_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_SUPERVISOR_IX on TEMP_PROCEDIMIENTO_SUPERVISOR (PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_SUPERVISOR_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_SUPERVISOR_IX. Nº [', HAY, ']');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    TEMP_TAREA_GESTOR
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_TAREA_GESTOR' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_TAREA_GESTOR' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_TAREA_GESTOR_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX TEMP_TAREA_GESTOR_IX on TEMP_TAREA_GESTOR (TAREA_ID);
	set o_error_status:= concat('Se ha insertado el INDICE TEMP_TAREA_GESTOR_IX. Nº [', HAY, ']');
else 
	set o_error_status:= concat('Ya existe el INDICE TEMP_TAREA_GESTOR_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_TAREA_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_TAREA_SUPERVISOR' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_TAREA_SUPERVISOR' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_TAREA_SUPERVISOR_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_TAREA_SUPERVISOR_IX on TEMP_TAREA_SUPERVISOR (TAREA_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_TAREA_SUPERVISOR_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_TAREA_SUPERVISOR_IX. Nº [', HAY, ']');
end if;


END MY_BLOCK_IND