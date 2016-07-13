-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_H_Procedimiento_Especifico`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_H_PRC_ESP: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de hechos Concurso, Declarativo, 
--              Ejecución Ordinaria, Hipotecario, Monitorio..
-- ==============================================================================================

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
--                                      COMUNES
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO;

-- ----------------------------------------------------------------------------------------------
--                                      CONCURSOS
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE H_CONCURSO;
TRUNCATE TABLE H_CONCURSO_MES;
TRUNCATE TABLE H_CONCURSO_TRIMESTRE;
TRUNCATE TABLE H_CONCURSO_ANIO;
TRUNCATE TABLE TEMP_CONCURSO_JERARQUIA;  
TRUNCATE TABLE TEMP_CONCURSO_DETALLE;
TRUNCATE TABLE TEMP_CONCURSO_TAREA;

-- ----------------------------------------------------------------------------------------------
--                                      DECLARATIVO
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE H_DECLARATIVO;
TRUNCATE TABLE H_DECLARATIVO_MES;
TRUNCATE TABLE H_DECLARATIVO_TRIMESTRE;
TRUNCATE TABLE H_DECLARATIVO_ANIO;
TRUNCATE TABLE TEMP_DECLARATIVO_JERARQUIA;  
TRUNCATE TABLE TEMP_DECLARATIVO_DETALLE;
TRUNCATE TABLE TEMP_DECLARATIVO_TAREA;

-- ----------------------------------------------------------------------------------------------
--                                      EJECUCION_ORDINARIA
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE H_EJECUCION_ORDINARIA;
TRUNCATE TABLE H_EJECUCION_ORDINARIA_MES;
TRUNCATE TABLE H_EJECUCION_ORDINARIA_TRIMESTRE;
TRUNCATE TABLE H_EJECUCION_ORDINARIA_ANIO;
TRUNCATE TABLE TEMP_EJECUCION_ORDINARIA_JERARQUIA;  
TRUNCATE TABLE TEMP_EJECUCION_ORDINARIA_DETALLE;
TRUNCATE TABLE TEMP_EJECUCION_ORDINARIA_TAREA;

-- ----------------------------------------------------------------------------------------------
--                                      HIPOTECARIO
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE H_HIPOTECARIO;
TRUNCATE TABLE H_HIPOTECARIO_MES;
TRUNCATE TABLE H_HIPOTECARIO_TRIMESTRE;
TRUNCATE TABLE H_HIPOTECARIO_ANIO;
TRUNCATE TABLE TEMP_HIPOTECARIO_JERARQUIA;  
TRUNCATE TABLE TEMP_HIPOTECARIO_DETALLE;
TRUNCATE TABLE TEMP_HIPOTECARIO_TAREA;

-- ----------------------------------------------------------------------------------------------
--                                      MONITORIO
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE H_MONITORIO;
TRUNCATE TABLE H_MONITORIO_MES;
TRUNCATE TABLE H_MONITORIO_TRIMESTRE;
TRUNCATE TABLE H_MONITORIO_ANIO;
TRUNCATE TABLE TEMP_MONITORIO_JERARQUIA;  
TRUNCATE TABLE TEMP_MONITORIO_DETALLE;
TRUNCATE TABLE TEMP_MONITORIO_RESOLUCION;

-- ----------------------------------------------------------------------------------------------
--                                      ETJ
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE H_ETJ;
TRUNCATE TABLE H_ETJ_MES;
TRUNCATE TABLE H_ETJ_TRIMESTRE;
TRUNCATE TABLE H_ETJ_ANIO;
TRUNCATE TABLE TEMP_ETJ_JERARQUIA;  
TRUNCATE TABLE TEMP_ETJ_DETALLE;
TRUNCATE TABLE TEMP_ETJ_RESOLUCION;

-- ----------------------------------------------------------------------------------------------
--                                      EJECUCION_NOTARIAL
-- ----------------------------------------------------------------------------------------------
TRUNCATE TABLE H_EJECUCION_NOTARIAL;
TRUNCATE TABLE H_EJECUCION_NOTARIAL_MES;
TRUNCATE TABLE H_EJECUCION_NOTARIAL_TRIMESTRE;
TRUNCATE TABLE H_EJECUCION_NOTARIAL_ANIO;
TRUNCATE TABLE TEMP_EJECUCION_NOTARIAL_JERARQUIA;  
TRUNCATE TABLE TEMP_EJECUCION_NOTARIAL_DETALLE;
TRUNCATE TABLE TEMP_EJECUCION_NOTARIAL_TAREA;


END MY_BLOCK_TRUNC_H_PRC_ESP
