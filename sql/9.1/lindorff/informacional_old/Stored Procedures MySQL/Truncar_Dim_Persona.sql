-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Truncar_Dim_Persona`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_TRUNC_PER: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Persona.
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

TRUNCATE TABLE DIM_PERSONA_AMBITO_EXPEDIENTE;
TRUNCATE TABLE DIM_PERSONA_ARQUETIPO;
TRUNCATE TABLE DIM_PERSONA_ESTADO_FINANCIERO;
TRUNCATE TABLE DIM_PERSONA_GRUPO_GESTOR;
TRUNCATE TABLE DIM_PERSONA_ITINERARIO;
TRUNCATE TABLE DIM_PERSONA_NACIONALIDAD;
TRUNCATE TABLE DIM_PERSONA_NIVEL;
TRUNCATE TABLE DIM_PERSONA_OFICINA; 
TRUNCATE TABLE DIM_PERSONA_PAIS_NACIMIENTO;
TRUNCATE TABLE DIM_PERSONA_PERFIL;
TRUNCATE TABLE DIM_PERSONA_POLITICA;
TRUNCATE TABLE DIM_PERSONA_PROVINCIA; 
TRUNCATE TABLE DIM_PERSONA_RATING_AUXILIAR;
TRUNCATE TABLE DIM_PERSONA_RATING_EXTERNO;
TRUNCATE TABLE DIM_PERSONA_SEGMENTO;
TRUNCATE TABLE DIM_PERSONA_SEGMENTO_DETALLE;
TRUNCATE TABLE DIM_PERSONA_SEXO;
TRUNCATE TABLE DIM_PERSONA_TENDENCIA;
TRUNCATE TABLE DIM_PERSONA_TIPO_DOCUMENTO;
TRUNCATE TABLE DIM_PERSONA_TIPO_ITINERARIO;
TRUNCATE TABLE DIM_PERSONA_TIPO_PERSONA;
TRUNCATE TABLE DIM_PERSONA_TIPO_POLITICA;
TRUNCATE TABLE DIM_PERSONA_ZONA; 
TRUNCATE TABLE DIM_PERSONA;

END MY_BLOCK_DIM_TRUNC_PER