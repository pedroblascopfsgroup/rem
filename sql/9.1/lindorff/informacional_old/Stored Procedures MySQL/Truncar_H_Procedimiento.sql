-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`ba01` PROCEDURE `Truncar_H_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_H_PRC: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Mart�n, PFS Group
-- Fecha creaci�n: Septiembre 2013
-- Responsable �ltima modificaci�n: Gonzalo Mart�n, PFS Group
-- Fecha �ltima modificaci�n: 26/03/2015
-- Motivos del cambio: segmento y socio
-- Cliente: Recovery BI Lindorff
--
-- Descripci�n: Procedimiento almancenado que trunca las tablas de hechos H_PROCEDIMIENTO.
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


TRUNCATE TABLE H_PROCEDIMIENTO;
TRUNCATE TABLE H_PROCEDIMIENTO_MES;
TRUNCATE TABLE H_PROCEDIMIENTO_TRIMESTRE;
TRUNCATE TABLE H_PROCEDIMIENTO_ANIO;

TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_COBRO;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_COBRO_MES;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_COBRO_ANIO;

TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_CONTRATO;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_CONTRATO_MES;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO;

TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_RESOLUCION;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE;
TRUNCATE TABLE H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO;

TRUNCATE TABLE TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_JERARQUIA;  
TRUNCATE TABLE TEMP_PROCEDIMIENTO_DETALLE;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_TAREA;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_CONTRATO;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_AUTO_PRORROGAS;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_COBROS;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_ESTIMACION;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_CARTERA;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_CEDENTE;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_PROPIETARIO;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_TITULAR;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_DEMANDADO;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_RESOLUCIONES;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_USUARIOS;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_REFERENCIA;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_SEGMENTO;
TRUNCATE TABLE TEMP_PROCEDIMIENTO_SOCIO;

TRUNCATE TABLE TEMP_FECHA_INTERPOSICION;
TRUNCATE TABLE TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX;
TRUNCATE TABLE TEMP_PROCURADOR;
END MY_BLOCK_TRUNC_H_PRC
