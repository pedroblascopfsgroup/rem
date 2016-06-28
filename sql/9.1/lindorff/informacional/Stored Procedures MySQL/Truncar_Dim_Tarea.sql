-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_Dim_Tarea`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_DIM_TAR:BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Tarea.
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

TRUNCATE TABLE DIM_TAREA_ALERTA;
TRUNCATE TABLE DIM_TAREA_AMBITO;
TRUNCATE TABLE DIM_TAREA_CUMPLIMIENTO;
TRUNCATE TABLE DIM_TAREA_ESTADO_PRORROGA;
TRUNCATE TABLE DIM_TAREA_PENDIENTE_RESPUESTA;
TRUNCATE TABLE DIM_TAREA_MOTIVO_PRORROGA;
TRUNCATE TABLE DIM_TAREA_RESOLUCION_PRORROGA;
TRUNCATE TABLE DIM_TAREA_REALIZACION;
TRUNCATE TABLE DIM_TAREA_TIPO;
TRUNCATE TABLE DIM_TAREA_TIPO_DETALLE;  
TRUNCATE TABLE DIM_TAREA_GESTOR;
TRUNCATE TABLE DIM_TAREA_SUPERVISOR;
TRUNCATE TABLE DIM_TAREA_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_TAREA_DESPACHO_SUPERVISOR;
TRUNCATE TABLE DIM_TAREA_TIPO_DESPACHO_GESTOR; 
TRUNCATE TABLE DIM_TAREA_TIPO_DESPACHO_SUPERVISOR;
TRUNCATE TABLE DIM_TAREA_ENTIDAD_GESTOR; 
TRUNCATE TABLE DIM_TAREA_ENTIDAD_SUPERVISOR; 
TRUNCATE TABLE DIM_TAREA_NIVEL_DESPACHO_GESTOR; 
TRUNCATE TABLE DIM_TAREA_NIVEL_DESPACHO_SUPERVISOR;
TRUNCATE TABLE DIM_TAREA_OFICINA_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_TAREA_OFICINA_DESPACHO_SUPERVISOR;
TRUNCATE TABLE DIM_TAREA_PROVINCIA_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_TAREA_PROVINCIA_DESPACHO_SUPERVISOR;
TRUNCATE TABLE DIM_TAREA_ZONA_DESPACHO_GESTOR;
TRUNCATE TABLE DIM_TAREA_ZONA_DESPACHO_SUPERVISOR;
TRUNCATE TABLE TEMP_TAREA_GESTOR;
TRUNCATE TABLE TEMP_TAREA_SUPERVISOR;
TRUNCATE TABLE DIM_TAREA_DESCRIPCION;
TRUNCATE TABLE DIM_TAREA_RESPONSABLE;
TRUNCATE TABLE DIM_TAREA;


END MY_BLOCK_TRUNC_DIM_TAR