-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_H_Contrato`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_H_CNT: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de hechos H_CONTRATO.
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

TRUNCATE TABLE H_CONTRATO;
TRUNCATE TABLE H_CONTRATO_MES;
TRUNCATE TABLE H_CONTRATO_TRIMESTRE;
TRUNCATE TABLE H_CONTRATO_ANIO;
TRUNCATE TABLE H_CONTRATO_INICIO_CAMPANA_RECOBRO;
TRUNCATE TABLE TEMP_ANT;
TRUNCATE TABLE TEMP_H;
TRUNCATE TABLE TEMP_MANTIENE;
TRUNCATE TABLE TEMP_BAJA;
TRUNCATE TABLE TEMP_ALTA;
TRUNCATE TABLE TEMP_FECHA;
TRUNCATE TABLE TEMP_FECHA_AUX;
TRUNCATE TABLE TEMP_CONTRATO_PROCEDIMIENTO;
TRUNCATE TABLE TEMP_CONTRATO_PROCEDIMIENTO_AUX;
TRUNCATE TABLE TEMP_CONTRATO_SITUACION_FINANCIERA;
TRUNCATE TABLE TEMP_CONTRATO_CREDITO_INSINUADO;
TRUNCATE TABLE TEMP_CONTRATO_RECOBRO;
TRUNCATE TABLE TEMP_CONTRATO_DPS;
TRUNCATE TABLE TEMP_CONTRATO_ACTIVIDAD;
TRUNCATE TABLE TEMP_CONTRATO_ESPECIALIZADA;
TRUNCATE TABLE TEMP_CONTRATO_PREVISIONES;
TRUNCATE TABLE TEMP_CONTRATO_PREVISIONES_DIA;
TRUNCATE TABLE TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES;
TRUNCATE TABLE TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX;

END MY_BLOCK_TRUNC_H_CNT
