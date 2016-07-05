-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`195.53.82.30` PROCEDURE `Crear_Indices_Relaciones_Datawarehouse`(OUT o_error_status varchar(500))
MY_BLOCK_IND: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff 
--
-- Descripción: Procedimiento almancenado que crea los índices en las tablas de relaciones del datawarehouse
-- ===============================================================================================
DECLARE HAY INT;
DECLARE HAY_TABLA INT;

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HandLER DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: Número de parámetros incorrecto'; 

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DEL HandLER GENÉRICO DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

-- --------------------------------------------------------------------------------
-- ÍNDICES DEL DATAWAREHOUSE: TABLA
-- --------------------------------------------------------------------------------
-- ÍNDICES DE LAS RELACIONES DE CARTERA
-- ÍNDICES DE LAS RELACIONES DE JUDICIAL


-- ----------------------------------------------------------------------------------------------
--                                    ÍNDICES DE LAS RELACIONES DE CARTERA
-- ---------------------------------------------------------------------------------------------
SELECT COUNT(table_name) INTO HAY_TABLA FROM information_schema.tables 
  WHERE table_name = 'REL_CONTRATO_PERSONA'
     AND table_schema = 'recovery_lindorff_dwh';
SELECT COUNT(INDEX_NAME) INTO HAY FROM information_schema.statistics 
  WHERE table_name = 'REL_CONTRATO_PERSONA'
     AND table_schema = 'recovery_lindorff_dwh' AND INDEX_NAME = 'REL_CONTRATO_PERSONA_IX';
IF (HAY < 1 && HAY_TABLA > 0) THEN 
	CREATE INDEX REL_CONTRATO_PERSONA_IX ON REL_CONTRATO_PERSONA (CONTRATO_ID, PERSONA_ID);
	set o_error_status:= concat('Se ha insertado el INDICE REL_CONTRATO_PERSONA_IX. Nº [', HAY, ']');
ELSE 
	set o_error_status:= concat('Ya existe el INDICE REL_CONTRATO_PERSONA_IX. Nº [', HAY, ']');
END if;

SELECT COUNT(table_name) INTO HAY_TABLA FROM information_schema.tables 
  WHERE table_name = 'REL_CONTRATO_EXPEDIENTE'
     AND table_schema = 'recovery_lindorff_dwh';
SELECT COUNT(INDEX_NAME) INTO HAY FROM information_schema.statistics 
  WHERE table_name = 'REL_CONTRATO_EXPEDIENTE'
     AND table_schema = 'recovery_lindorff_dwh' AND INDEX_NAME = 'REL_CONTRATO_EXPEDIENTE_IX';
IF (HAY < 1 && HAY_TABLA > 0) THEN 
	CREATE INDEX REL_CONTRATO_EXPEDIENTE_IX ON REL_CONTRATO_EXPEDIENTE (CONTRATO_ID, EXPEDIENTE_ID);
	set o_error_status:= concat('Se ha insertado el INDICE REL_CONTRATO_EXPEDIENTE_IX. Nº [', HAY, ']');
ELSE 
	set o_error_status:= concat('Ya existe el INDICE REL_CONTRATO_EXPEDIENTE_IX. Nº [', HAY, ']');
END if;


-- ----------------------------------------------------------------------------------------------
--                                    ÍNDICES DE LAS RELACIONES DE JUDICIAL
-- ----------------------------------------------------------------------------------------------
SELECT COUNT(table_name) INTO HAY_TABLA FROM information_schema.tables 
  WHERE table_name = 'REL_ASUNTO_GESTOR'
     AND table_schema = 'recovery_lindorff_dwh';
SELECT COUNT(INDEX_NAME) INTO HAY FROM information_schema.statistics 
  WHERE table_name = 'REL_ASUNTO_GESTOR'
     AND table_schema = 'recovery_lindorff_dwh' AND INDEX_NAME = 'REL_ASUNTO_GESTOR_IX';
IF (HAY < 1 && HAY_TABLA > 0) THEN 
	CREATE INDEX REL_ASUNTO_GESTOR_IX ON REL_ASUNTO_GESTOR (ASUNTO_ID, GESTOR_ID);
	set o_error_status:= concat('Se ha insertado el INDICE REL_ASUNTO_GESTOR_IX. Nº [', HAY, ']');
ELSE 
	set o_error_status:= concat('Ya existe el INDICE REL_ASUNTO_GESTOR_IX. Nº [', HAY, ']');
END if;

SELECT COUNT(table_name) INTO HAY_TABLA FROM information_schema.tables 
  WHERE table_name = 'REL_ASUNTO_CONTRATO'
     AND table_schema = 'recovery_lindorff_dwh';
SELECT COUNT(INDEX_NAME) INTO HAY FROM information_schema.statistics 
  WHERE table_name = 'REL_ASUNTO_CONTRATO'
     AND table_schema = 'recovery_lindorff_dwh' AND INDEX_NAME = 'REL_ASUNTO_CONTRATO_IX';
IF (HAY < 1 && HAY_TABLA > 0) THEN 
	CREATE INDEX REL_ASUNTO_CONTRATO_IX ON REL_ASUNTO_CONTRATO (ASUNTO_ID, CONTRATO_ID);
	set o_error_status:= concat('Se ha insertado el INDICE REL_ASUNTO_CONTRATO_IX. Nº [', HAY, ']');
ELSE 
	set o_error_status:= concat('Ya existe el INDICE REL_ASUNTO_CONTRATO_IX. Nº [', HAY, ']');
END if;

SELECT COUNT(table_name) INTO HAY_TABLA FROM information_schema.tables 
  WHERE table_name = 'REL_PROCEDIMIENTO_CONTRATO'
     AND table_schema = 'recovery_lindorff_dwh';
SELECT COUNT(INDEX_NAME) INTO HAY FROM information_schema.statistics 
  WHERE table_name = 'REL_PROCEDIMIENTO_CONTRATO'
     AND table_schema = 'recovery_lindorff_dwh' AND INDEX_NAME = 'REL_PROCEDIMIENTO_CONTRATO_IX';
IF (HAY < 1 && HAY_TABLA > 0) THEN 
	CREATE INDEX REL_PROCEDIMIENTO_CONTRATO_IX ON REL_PROCEDIMIENTO_CONTRATO (PROCEDIMIENTO_ID, CONTRATO_ID);
	set o_error_status:= concat('Se ha insertado el INDICE REL_PROCEDIMIENTO_CONTRATO_IX. Nº [', HAY, ']');
ELSE 
	set o_error_status:= concat('Ya existe el INDICE REL_PROCEDIMIENTO_CONTRATO_IX. Nº [', HAY, ']');
END if;



END MY_BLOCK_IND
