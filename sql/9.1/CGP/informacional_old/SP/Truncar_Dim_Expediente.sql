-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_Dim_Expediente` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_Dim_Expediente`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_TRUNC_EXP: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
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

TRUNCATE TABLE D_EXP_CEDENTE;
TRUNCATE TABLE D_EXP_PROVEEDOR;
TRUNCATE TABLE D_EXP_EST_ENTRADA;
TRUNCATE TABLE D_EXP_EST_HERRAMIENTA;
TRUNCATE TABLE D_EXP_FASE;
TRUNCATE TABLE D_EXP_EST_VIDA;
TRUNCATE TABLE D_EXP_EST_GESTION;
TRUNCATE TABLE D_EXP_MOTIVO_FACTURA;
TRUNCATE TABLE D_EXP_MOTIVO_KO;
TRUNCATE TABLE D_EXP_TIPO_KO;
TRUNCATE TABLE D_EXP_PROCURADOR;
TRUNCATE TABLE D_EXP_TIPO_PROCEDIMIENTO;
TRUNCATE TABLE D_EXP_PLAZA;
TRUNCATE TABLE D_EXP_PLAZA_UNICO; /* Dimensión para Varias Plazas */
TRUNCATE TABLE D_EXP_JUZGADO;
TRUNCATE TABLE D_EXP_EST_FACTURA;
TRUNCATE TABLE D_EXP_FACTURA;
TRUNCATE TABLE D_EXP_EST_CONEXP;
TRUNCATE TABLE D_EXP_SITUACION;
TRUNCATE TABLE D_EXP_EST_INICIO; /* Dimensión para Tabla Iniciados */
TRUNCATE TABLE D_EXP_ESCANEADO; /* Dimensión para Tabla Escaneado */
TRUNCATE TABLE D_EXP_CARTERA; /* Dimensión para Tabla Cartera */
TRUNCATE TABLE D_EXP_PLAZO_ENT_ENV; /* Dimensión para DIAS_ENTRE_ENTRADA_ENVIO_ID */  
TRUNCATE TABLE D_EXP_PLAZO_ENV_PRE; /* Dimensión para DIAS_ENTRE_ENVIO_PRESEN_ID */  
TRUNCATE TABLE D_EXP_TIENE_FACTURA; /* Dimensión para TIENE_FACTURA */
TRUNCATE TABLE D_EXP;

END MY_BLOCK_DIM_TRUNC_EXP
