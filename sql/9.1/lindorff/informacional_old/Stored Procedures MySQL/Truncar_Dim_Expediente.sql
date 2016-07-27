-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_Dim_Expediente`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_TRUNC_EXP: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Expediente.
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

TRUNCATE TABLE DIM_EXPEDIENTE; 
TRUNCATE TABLE DIM_EXPEDIENTE_ACTITUD;
TRUNCATE TABLE DIM_EXPEDIENTE_AMBITO_EXPEDIENTE;
TRUNCATE TABLE DIM_EXPEDIENTE_ARQUETIPO;
TRUNCATE TABLE DIM_EXPEDIENTE_CAUSA_IMPAGO; 
TRUNCATE TABLE DIM_EXPEDIENTE_COMITE;
TRUNCATE TABLE DIM_EXPEDIENTE_DECISION;
TRUNCATE TABLE DIM_EXPEDIENTE_ENTIDAD_INFORMACION;
TRUNCATE TABLE DIM_EXPEDIENTE_ESTADO_EXPEDIENTE;
TRUNCATE TABLE DIM_EXPEDIENTE_ESTADO_ITINERARIO;
TRUNCATE TABLE DIM_EXPEDIENTE_ITINERARIO;
TRUNCATE TABLE DIM_EXPEDIENTE_NIVEL;   
TRUNCATE TABLE DIM_EXPEDIENTE_OFICINA; 
TRUNCATE TABLE DIM_EXPEDIENTE_PROPUESTA;
TRUNCATE TABLE DIM_EXPEDIENTE_PROVINCIA; 
TRUNCATE TABLE DIM_EXPEDIENTE_SESION;
TRUNCATE TABLE DIM_EXPEDIENTE_TIPO_ITINERARIO ;
TRUNCATE TABLE DIM_EXPEDIENTE_ZONA; 
  
END MY_BLOCK_DIM_TRUNC_EXP