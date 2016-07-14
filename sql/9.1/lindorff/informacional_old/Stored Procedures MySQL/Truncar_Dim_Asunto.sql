-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_Dim_Asunto`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_DIM_ASU:BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Asunto.
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

TRUNCATE TABLE DIM_ASUNTO_DESPACHO;
TRUNCATE TABLE DIM_ASUNTO_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_ENTIDAD_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_ESTADO;
TRUNCATE TABLE DIM_ASUNTO_ESTADO_AGRUPADO;
TRUNCATE TABLE DIM_ASUNTO_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_NIVEL_DESPACHO;
TRUNCATE TABLE DIM_ASUNTO_NIVEL_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_OFICINA_DESPACHO; 
TRUNCATE TABLE DIM_ASUNTO_OFICINA_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_PROVINCIA_DESPACHO;
TRUNCATE TABLE DIM_ASUNTO_PROVINCIA_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_TIPO_DESPACHO;
TRUNCATE TABLE DIM_ASUNTO_TIPO_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_ROL_GESTOR;
TRUNCATE TABLE DIM_ASUNTO_ZONA_DESPACHO; 
TRUNCATE TABLE DIM_ASUNTO_ZONA_DESPACHO_GESTOR;
-- TRUNCATE TABLE DIM_ASUNTO_ACUERDO;
-- TRUNCATE TABLE DIM_ASUNTO_CONTRATO_FISICO;
TRUNCATE TABLE DIM_ASUNTO;
  
END MY_BLOCK_TRUNC_DIM_ASU