-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_H_Tarea_Finalizada`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_H_TAR_FIN: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Mart�n, PFS Group
-- Fecha creaci�n: Septiembre 2013
-- Responsable �ltima modificaci�n: Gonzalo Mart�n, PFS Group
-- Fecha �ltima modificaci�n: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripci�n: Procedimiento almancenado que trunca las tablas de hechos Tarea Finalizada.
-- ===============================================================================================

-- --------------------------------------------------------------------------------
-- DEFINICI�N DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: N�mero de par�metros incorrecto'; 

-- --------------------------------------------------------------------------------
-- DEFINICI�N DEL HANDLER GEN�RICO DE ERROR
-- --------------------------------------------------------------------------------
DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

TRUNCATE TABLE H_TAREA_FINALIZADA;
TRUNCATE TABLE TEMP_TAREA_JERARQUIA;

END MY_BLOCK_TRUNC_H_TAR_FIN
