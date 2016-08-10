-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_Dim_Fecha_Otras` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_Dim_Fecha_Otras`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_FEC_OTRAS: BEGIN

-- ===============================================================================================
-- Autor: María Villanueva, PFS Group
-- Fecha creación: Noviembre 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea las tablas de la dimensiones Fecha interposion_demanda y fecha carga_datos.
-- ===============================================================================================

DECLARE HAY INT;
DECLARE HAY_TABLA INT;

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

CREATE TABLE IF NOT EXISTS `D_F_CARGA_DATOS_ANIO` (
  `ANIO_CARGA_DATOS_ID` int(11) NOT NULL,
  `ANIO_FECHA` date DEFAULT NULL,
  `ANIO_DURACION` int(11) DEFAULT NULL,
  `ANIO_ANT_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ANIO_CARGA_DATOS_ID`)
);


CREATE TABLE IF NOT EXISTS `D_F_CARGA_DATOS_DIA` (
  `DIA_CARGA_DATOS_ID` date NOT NULL,
  `DIA_SEMANA_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `MES_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `ANIO_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `DIA_ANT_ID` date DEFAULT NULL,
  `DIA_ULT_MES_ID` date DEFAULT NULL,
  `DIA_ULT_TRIMESTRE_ID` date DEFAULT NULL,
  `DIA_ULT_ANIO_ID` date DEFAULT NULL,
  PRIMARY KEY (`DIA_CARGA_DATOS_ID`)
);


CREATE TABLE IF NOT EXISTS `D_F_CARGA_DATOS_DIA_SEMANA` (
  `DIA_SEMANA_CARGA_DATOS_ID` int(11) NOT NULL,
  `DIA_SEMANA_DESC` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_EN` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_DE` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_FR` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`DIA_SEMANA_CARGA_DATOS_ID`)
);


CREATE TABLE IF NOT EXISTS `D_F_CARGA_DATOS_MES` (
  `MES_CARGA_DATOS_ID` int(11) NOT NULL,
  `MES_FECHA` date DEFAULT NULL,
  `MES_DESC` varchar(45) DEFAULT NULL,
  `MES_ANIO_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `ANIO_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `MES_DURACION` int(11) DEFAULT NULL,
  `MES_ANT_ID` int(11) DEFAULT NULL,
  `MES_ULT_TRIMESTRE_ID` int(11) DEFAULT NULL,
  `MES_ULT_ANIO_ID` int(11) DEFAULT NULL,
  `MES_DESC_EN` varchar(45) DEFAULT NULL,
  `MES_DESC_DE` varchar(45) DEFAULT NULL,
  `MES_DESC_FR` varchar(45) DEFAULT NULL,
  `MES_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`MES_CARGA_DATOS_ID`)
);



CREATE TABLE IF NOT EXISTS `D_F_CARGA_DATOS_MES_ANIO` (
  `MES_ANIO_CARGA_DATOS_ID` int(11) NOT NULL,
  `MES_ANIO_DESC` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_EN` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_DE` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_FR` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`MES_ANIO_CARGA_DATOS_ID`)
);



CREATE TABLE IF NOT EXISTS `D_F_CARGA_DATOS_TRIMESTRE` (
  `TRIMESTRE_CARGA_DATOS_ID` int(11) NOT NULL,
  `TRIMESTRE_FECHA` date DEFAULT NULL,
  `TRIMESTRE_DESC` varchar(45) DEFAULT NULL,
  `ANIO_CARGA_DATOS_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_DURACION` int(11) DEFAULT NULL,
  `TRIMESTRE_ANT_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_ULT_ANIO_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_DESC_EN` varchar(45) DEFAULT NULL,
  `TRIMESTRE_DESC_DE` varchar(45) DEFAULT NULL,
  `TRIMESTRE_DESC_FR` varchar(45) DEFAULT NULL,
  `TRIMESTRE_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TRIMESTRE_CARGA_DATOS_ID`)
);

CREATE TABLE IF NOT EXISTS `DIM_FECHA_INTERPOS_DEMANDA_ANIO` (
  `ANIO_INTERPOS_DEMANDA_ID` int(11) NOT NULL,
  `ANIO_FECHA` date DEFAULT NULL,
  `ANIO_DURACION` int(11) DEFAULT NULL,
  `ANIO_ANT_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ANIO_INTERPOS_DEMANDA_ID`)
);


CREATE TABLE IF NOT EXISTS `DIM_FECHA_INTERPOS_DEMANDA_DIA` (
  `DIA_INTERPOS_DEMANDA_ID` date NOT NULL,
  `DIA_SEMANA_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `MES_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `ANIO_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `DIA_ANT_ID` date DEFAULT NULL,
  `DIA_ULT_MES_ID` date DEFAULT NULL,
  `DIA_ULT_TRIMESTRE_ID` date DEFAULT NULL,
  `DIA_ULT_ANIO_ID` date DEFAULT NULL,
  PRIMARY KEY (`DIA_INTERPOS_DEMANDA_ID`)
);


CREATE TABLE IF NOT EXISTS `DIM_FECHA_INTERPOS_DEMANDA_DIA_SEMANA` (
  `DIA_SEMANA_INTERPOS_DEMANDA_ID` int(11) NOT NULL,
  `DIA_SEMANA_DESC` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_EN` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_DE` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_FR` varchar(45) DEFAULT NULL,
  `DIA_SEMANA_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`DIA_SEMANA_INTERPOS_DEMANDA_ID`)
);


CREATE TABLE IF NOT EXISTS `DIM_FECHA_INTERPOS_DEMANDA_MES` (
  `MES_INTERPOS_DEMANDA_ID` int(11) NOT NULL,
  `MES_FECHA` date DEFAULT NULL,
  `MES_DESC` varchar(45) DEFAULT NULL,
  `MES_ANIO_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `ANIO_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `MES_DURACION` int(11) DEFAULT NULL,
  `MES_ANT_ID` int(11) DEFAULT NULL,
  `MES_ULT_TRIMESTRE_ID` int(11) DEFAULT NULL,
  `MES_ULT_ANIO_ID` int(11) DEFAULT NULL,
  `MES_DESC_EN` varchar(45) DEFAULT NULL,
  `MES_DESC_DE` varchar(45) DEFAULT NULL,
  `MES_DESC_FR` varchar(45) DEFAULT NULL,
  `MES_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`MES_INTERPOS_DEMANDA_ID`)
);



CREATE TABLE IF NOT EXISTS `DIM_FECHA_INTERPOS_DEMANDA_MES_ANIO` (
  `MES_ANIO_INTERPOS_DEMANDA_ID` int(11) NOT NULL,
  `MES_ANIO_DESC` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_EN` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_DE` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_FR` varchar(45) DEFAULT NULL,
  `MES_ANIO_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`MES_ANIO_INTERPOS_DEMANDA_ID`)
);





CREATE TABLE IF NOT EXISTS `DIM_FECHA_INTERPOS_DEMANDA_TRIMESTRE` (
  `TRIMESTRE_INTERPOS_DEMANDA_ID` int(11) NOT NULL,
  `TRIMESTRE_FECHA` date DEFAULT NULL,
  `TRIMESTRE_DESC` varchar(45) DEFAULT NULL,
  `ANIO_INTERPOS_DEMANDA_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_DURACION` int(11) DEFAULT NULL,
  `TRIMESTRE_ANT_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_ULT_ANIO_ID` int(11) DEFAULT NULL,
  `TRIMESTRE_DESC_EN` varchar(45) DEFAULT NULL,
  `TRIMESTRE_DESC_DE` varchar(45) DEFAULT NULL,
  `TRIMESTRE_DESC_FR` varchar(45) DEFAULT NULL,
  `TRIMESTRE_DESC_IT` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`TRIMESTRE_INTERPOS_DEMANDA_ID`)
);

END MY_BLOCK_DIM_FEC_OTRAS$$
DELIMITER ;

