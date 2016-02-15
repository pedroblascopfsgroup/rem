-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_H_Prc_Recursos` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_H_Prc_Recursos`(OUT o_error_status varchar(500))
MY_BLOCK_CREAR_H_PRC_COBROS: BEGIN

-- ===============================================================================================
-- Autor: Joaquín Arnal, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea las tablas de hecho de H_PRC_RECURSOS.
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

	/* TEMPORALES */
	-- =================================================================================================================================================
	--                                                 TABLAS TMPORALES
	-- =================================================================================================================================================

	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_CODIGO_PRIORIDAD_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_CODIGO_PRIORIDAD_REC;
	end if;
	CREATE TABLE TMP_PRC_CODIGO_PRIORIDAD_REC (
	  `DD_TPO_CODIGO` VARCHAR(50) NULL ,
	  `PRIORIDAD` INT NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL 
	);  
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_JERARQUIA_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_JERARQUIA_REC;
	end if;
	CREATE TABLE TMP_PRC_JERARQUIA_REC (
	  `DIA_ID` DATE NOT NULL,                               
	  `ITER` DECIMAL(16,0) NOT NULL,   
	  `FASE_ACTUAL` DECIMAL(16,0) NULL,
	  `ULTIMA_FASE` DECIMAL(16,0) NULL,
	  `ULT_TAR_CREADA` DECIMAL(16,0) NULL, 
	  `ULT_TAR_FIN` DECIMAL(16,0) NULL, 
	  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL, 
	  `ULT_TAR_PEND` DECIMAL(16,0) NULL,
	  `FECHA_ULT_TAR_CREADA` DATETIME NULL,  
	  `FECHA_ULT_TAR_FIN` DATETIME NULL,  
	  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATETIME NULL , 
	  `FECHA_ULT_TAR_PEND` DATETIME NULL , 
	  `FECHA_ACEPTACION` DATE NULL,
	  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
	  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,                          
	  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                           
	  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,                             
	  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL, 
	  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
	  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL, 
	  `NIVEL` decimal(2,0) NULL,
	  `CONTEXTO` varchar(300) NULL,
	  `CODIGO_FASE_ACTUAL` varchar(20) NULL, 
	  `PRIORIDAD_FASE` INT NULL,      
	  `PRIORIDAD_PROCEDIMIENTO` INT NULL,
	  `CANCELADO_FASE` INT NULL,
	  `CANCELADO_PROCEDIMIENTO` INT NULL,
	  `ASU_ID` decimal(16,0) NULL,
	  `NUM_FASES` INT NULL,
	  `NUM_CONTRATOS` INT NULL,
	  `SALDO_VENCIDO` DECIMAL(14,2) NULL ,         
	  `SALDO_NO_VENCIDO` DECIMAL(14,2) NULL ,
	  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
	  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
	  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
	  `SUBTOTAL` DECIMAL(14,2) NULL ,  
	  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,
	  `NUM_DIAS_VENCIDO` INT NULL,
	  `CARTERA` DECIMAL(16,0) NULL,
	  `FECHA_CONTABLE_LITIGIO` DATE NULL,
	  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
	  `FECHA_ULTIMA_AUTO_PRORROGA` DATE NULL,
	  `FECHA_ULTIMA_PRORROGA` DATE NULL,
	  `NUM_AUTO_PRORROGA` INT NULL,
	  `NUM_PRORROGA` INT NULL, 
	  `NUM_PARALIZACIONES` INT NOT NULL DEFAULT 0, -- Numero de paralizaciones realizadas sobre todos los procedimientos del asunto
	  `PARALIZADO` INT NOT NULL DEFAULT 0 -- 1=PARALIZADO 0=NO PARALIZADO	  
	  ); 
	
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_DETALLE_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_DETALLE_REC;
	end if;
	CREATE TABLE TMP_PRC_DETALLE_REC (
	  `ITER` DECIMAL(16,0) NULL ,
	  `FASE_ACTUAL` DECIMAL(16,0) NULL,
	  `ULT_TAR_CREADA` DECIMAL(16,0) NULL,
	  `ULT_TAR_FIN` DECIMAL(16,0) NULL, 
	  `ULTIMA_TAREA_ACTUALIZADA` DECIMAL(16,0) NULL,
	  `ULT_TAR_PEND` DECIMAL(16,0) NULL,
	  `FECHA_ULT_TAR_CREADA` DATETIME NULL,  
	  `FECHA_ULT_TAR_FIN` DATETIME NULL,  
	  `FECHA_ULTIMA_TAREA_ACTUALIZADA` DATETIME NULL ,  
	  `FECHA_ULT_TAR_PEND` DATETIME NULL , 
	  `FECHA_ACEPTACION` DATE NULL,
	  `FECHA_INTERPOSICION_DEMANDA` DATE NULL,
	  `FECHA_RECOGIDA_DOC_Y_ACEPT` DATE NULL,                          
	  `FECHA_REGISTRAR_TOMA_DECISION` DATE NULL,                           
	  `FECHA_RECEPCION_DOC_COMPLETA` DATE NULL,    
	  `FECHA_ULTIMA_POSICION_VENCIDA` DATE NULL,
	  `FECHA_ULTIMA_ESTIMACION` DATE NULL, 
	  `MAX_PRIORIDAD` DECIMAL(16,0) NULL,
	  `FASE_MAX_PRIORIDAD` DECIMAL(16,0) NULL,
	  `CANCELADO_FASE` INT NULL,
	  `NUM_FASES` INT NULL,
	  `CANCELADO_PROCEDIMIENTO` INT NULL,
	  `NUM_CONTRATOS` INT NULL,
	  `SALDO_VENCIDO` DECIMAL(14,2) NULL ,         
	  `SALDO_NO_VENCIDO` DECIMAL(14,2) NULL ,
	  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,  -- Saldo vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
	  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,        -- Saldo no vencido de los contratos asociados a los demandados del procedimiento que actúan como 1er y 2º Titular
	  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
	  `SUBTOTAL` DECIMAL(14,2) NULL ,  
	  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,
	  `NUM_DIAS_VENCIDO` INT NULL,
	  `CARTERA` DECIMAL(16,0) NULL,
	  `FECHA_CONTABLE_LITIGIO` DATE NULL,
	  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL, 
	  `FECHA_ULTIMA_AUTO_PRORROGA` DATE NULL,
	  `FECHA_ULTIMA_PRORROGA` DATE NULL,
	  `NUM_AUTO_PRORROGA` INT NULL,
	  `NUM_PRORROGA` INT NULL
	  );  
	    
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_TAREA_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_TAREA_REC;
	end if;
	CREATE TABLE TMP_PRC_TAREA_REC (
	  `ITER` DECIMAL(16,0) NULL,
	  `FASE` DECIMAL(16,0) NULL,
	  `TAREA` DECIMAL(16,0) NULL,
	  `FECHA_INI` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_FIN` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_AUTO_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_ACTUALIZACION` DATETIME,
	  `DESCRIPCION_TAREA` VARCHAR(250) NULL, 
	  `TAP_ID` DECIMAL(16,0) NULL,
	  `TEX_ID` DECIMAL(16,0) NULL,
	  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
	  `FECHA_FORMULARIO` DATE NULL ,       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR) 
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  `NUM_AUTO_PRORROGAS` INT NOT NULL DEFAULT 0,
	  `NUM_PRORROGAS` INT NOT NULL DEFAULT 0 
	);   
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_TAREA_STP1_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_TAREA_STP1_REC;
	end if;
	CREATE TABLE TMP_PRC_TAREA_STP1_REC (
	  `ITER` DECIMAL(16,0) NULL,
	  `FASE` DECIMAL(16,0) NULL,
	  `TAREA` DECIMAL(16,0) NULL,
	  `FECHA_INI` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_FIN` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_AUTO_PRORROGA` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00' ,
	  `FECHA_ACTUALIZACION` DATETIME,
	  `DESCRIPCION_TAREA` VARCHAR(250) NULL, 
	  `TAP_ID` DECIMAL(16,0) NULL,
	  `TEX_ID` DECIMAL(16,0) NULL,
	  `DESCRIPCION_FORMULARIO` VARCHAR(250) NULL,        -- TEV_NOMBRE (TEV_TAREA_EXTERNA_VALOR)
	  `FECHA_FORMULARIO` DATE NULL ,       -- TEV_VALOR (TEV_TAREA_EXTERNA_VALOR) 
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
	  `NUM_AUTO_PRORROGAS` INT NOT NULL DEFAULT 0,
	  `NUM_PRORROGAS` INT NOT NULL DEFAULT 0 
	);
	
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_AUTO_PRORROGAS_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_AUTO_PRORROGAS_REC;
	end if;
	CREATE TABLE TMP_PRC_AUTO_PRORROGAS_REC (
	  `TAREA` DECIMAL(16,0) NULL,       
	  `FECHA_AUTO_PRORROGA` DATETIME NULL,     -- Para prórrogas y autoprórrogas   
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL      
	  );  
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_CONTRATO_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_CONTRATO_REC;
	end if;
	CREATE TABLE TMP_PRC_CONTRATO_REC( 
	  `ITER` DECIMAL(16,0) NULL, 
	  `CONTRATO` DECIMAL(16,0) NULL,
	  `CEX_ID` DECIMAL(16,0) NULL,
	  `MAX_MOV_ID` DECIMAL(16,0) NULL,
	  `SALDO_VENCIDO` DECIMAL(14,2) NULL ,    -- Saldo vencido de los contratos asociados al procedimiento
	  `SALDO_NO_VENCIDO` DECIMAL(14,2) NULL ,      -- Saldo no vencido de los contratos asociados al procedimiento
	  `INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
	  `FECHA_POS_VENCIDA` DATE NULL,
	  `GARANTIA_CONTRATO` DECIMAL(16,0) NULL,      -- Garantía del contrato
	  `NUM_DIAS_VENCIDO` INT NULL,
	  `CARTERA` DECIMAL(16,0) NULL,  -- Cartera a la que pertenece el contrato (UGAS, SAREB o Compartida)
	  `FECHA_CONTABLE_LITIGIO` DATE NULL,      -- Fecha contable del litigio asociado al contrato
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	 );
	 
	   
	-- Calcular el saldo de los concursos
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_CONCURSO_CONTRATO_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_CONCURSO_CONTRATO_REC;
	end if;
	CREATE TABLE TMP_PRC_CONCURSO_CONTRATO_REC( 
	  `ITER` DECIMAL(16,0) NULL, 
	  `CONTRATO` DECIMAL(16,0) NULL,
	  `SALDO_CONCURSOS_VENCIDO` DECIMAL(14,2) NULL ,                 
	  `SALDO_CONCURSOS_NO_VENCIDO` DECIMAL(14,2) NULL ,               
	  `DEMANDADO` DECIMAL(16,0) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	 );
	 
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_CARTERA_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_CARTERA_REC;
	end if;
	CREATE TABLE TMP_PRC_CARTERA_REC ( 
	  `CONTRATO` DECIMAL(16,0) NULL,
	  `CARTERA` DECIMAL(16,0) NULL,   -- Cartera a la que pertenece el contrato (UGAS, SAREB o Compartida)
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	  );  
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_FECHA_CONTABLE_LITIGIO_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_FECHA_CONTABLE_LITIGIO_REC;
	end if;
	CREATE TABLE TMP_PRC_FECHA_CONTABLE_LITIGIO_REC ( 
	  `CONTRATO` DECIMAL(16,0) NULL,
	  `FECHA_CONTABLE_LITIGIO` DATE NULL,      -- Fecha contable del litigio asociado al contrato
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	  ); 
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_TITULAR_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_TITULAR_REC;
	end if;
	CREATE TABLE TMP_PRC_TITULAR_REC ( 
	  `PROCEDIMIENTO` DECIMAL(16,0) NULL,
	  `CONTRATO` DECIMAL(16,0) NULL,
	  `TITULAR_PROCEDIMIENTO` DECIMAL(16,0) NULL,   -- Primer titular del contrato de pase
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	  ); 
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_DEMANDADO_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_DEMANDADO_REC;
	end if;
	CREATE TABLE TMP_PRC_DEMANDADO_REC ( 
	  `PROCEDIMIENTO` DECIMAL(16,0) NULL,
	  `CONTRATO` DECIMAL(16,0) NULL,
	  `DEMANDADO` DECIMAL(16,0) NULL,          -- Demandado interviene como 1er o 2º Titular del contrato
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	  ); 
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_COBROS_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_COBROS_REC;
	end if;
	CREATE TABLE TMP_PRC_COBROS_REC( 
	  `FECHA_COBRO` DATE NULL,  
	  `CONTRATO` DECIMAL(16,0) NULL,
	  `IMPORTE` DECIMAL(15,2) NULL,
	  `REFERENCIA` DECIMAL(16,0) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	 );
	  
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_ESTIMACION_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_ESTIMACION_REC;
	end if;
	CREATE TABLE TMP_PRC_ESTIMACION_REC( 
	  `ITER` DECIMAL(16,0) NULL,
	  `FASE` DECIMAL(16,0) NULL,
	  `FECHA_ESTIMACION` DATETIME NULL,  
	  `IRG_CLAVE` varchar(20) NULL,
	  `IRG_VALOR` varchar(255) NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	 );
	 
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_EXTRAS_RECOVERY_BI_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE TMP_PRC_EXTRAS_RECOVERY_BI_REC;
	end if;
	CREATE TABLE TMP_PRC_EXTRAS_RECOVERY_BI_REC( 
	  `FECHA_VALOR` DATE NULL,  
	  `TIPO_ENTIDAD` DECIMAL(16,0) DEFAULT NULL,
	  `UNIDAD_GESTION` DECIMAL(16,0) DEFAULT NULL,
	  `DD_IFB_ID` DECIMAL(16,0) DEFAULT NULL,
	  `VALOR` varchar(50) DEFAULT NULL,
	  `ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL  
	 );
	 
	 
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_JERARQUIA_REC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_JERARQUIA_ITER_REC_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_JERARQUIA_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_JERARQUIA_ITER_REC_IX ON TMP_PRC_JERARQUIA_REC (DIA_ID, ITER, ENTIDAD_CEDENTE_ID);
	end if;
	
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_JERARQUIA_REC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_JERARQUIA_FASE_ACT_REC_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_JERARQUIA_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_JERARQUIA_FASE_ACT_REC_IX ON TMP_PRC_JERARQUIA_REC (DIA_ID, FASE_ACTUAL, ENTIDAD_CEDENTE_ID);
	end if;
	
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_JERARQUIA_REC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_JERARQUIA_ULT_FASE_REC_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_JERARQUIA_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_JERARQUIA_ULT_FASE_REC_IX ON TMP_PRC_JERARQUIA_REC (DIA_ID, ULTIMA_FASE, ENTIDAD_CEDENTE_ID);
	end if;
	
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_DETALLE_REC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_DETALLE_REC_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_DETALLE_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_DETALLE_REC_IX ON TMP_PRC_DETALLE_REC (ITER, ENTIDAD_CEDENTE_ID);
	end if;

	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_TAREA_REC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_TAREA_REC_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_TAREA_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_TAREA_REC_IX ON TMP_PRC_TAREA_REC (ITER, TAREA, ENTIDAD_CEDENTE_ID);
	end if;

	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_CONTRATO_REC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_CONTRATO_REC_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_CONTRATO_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_CONTRATO_REC_IX ON TMP_PRC_CONTRATO_REC (ITER, CONTRATO, ENTIDAD_CEDENTE_ID);
	end if;

	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TMP_PRC_CONTRATO_REC' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'TMP_PRC_CONTRATO_CEX_REC_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'TMP_PRC_CONTRATO_REC' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX TMP_PRC_CONTRATO_CEX_REC_IX ON TMP_PRC_CONTRATO_REC (CEX_ID, CONTRATO, ENTIDAD_CEDENTE_ID); 
	end if;
	 
	/* FIN TEMPORALES*/

	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_RECURSOS' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_RECURSOS;
	end if;
 
	CREATE TABLE H_PRC_RECURSOS(  
	  	`DIA_ID` DATE NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`RECURSO_ID` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`PROCEDIMIENTO_PARALIZADO_ID` DECIMAL(16,0) NULL, /* Nombre modificado en el cambio 2015-04-07 */ 
		/* INICIO: Cambio 2015-04-07 */
		`TIPO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO
		`TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO_DET
		`FASE_ACTUAL_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL
		`FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL_DETALLE
		/* FIN: Cambio 2015-04-07 */
		`ACTOR_ID` DECIMAL(16,0) NULL,
		`TIPO_RECURSO_ID` DECIMAL(16,0) NULL,
		`CAUSA_RECURSO_ID` DECIMAL(16,0) NULL,
		`ES_FAVORABLE_ID` DECIMAL(16,0) NULL,
		`RESULTADO_RESOL_ID` DECIMAL(16,0) NULL,
		`TAREA_ID` DECIMAL(16,0) NULL,
		`FECHA_RECURSO` DATE NULL,
		`FECHA_IMPUGNACION` DATE NULL,
		`FECHA_VISTA` DATE NULL,
		`FECHA_RESOLUCION` DATE NULL,
		`RCR_OBSERVACIONES` VARCHAR(500) NULL,
		`OBSERVACIONES_IMPUGNACION` VARCHAR(500) NULL,
		`OBSERVACIONES_RESOLUCION` VARCHAR(500) NULL,
		`CONFIRM_VISTA_ID` DECIMAL(16,0) NULL,
		`CONFIRM_IMPUGNACION_ID` DECIMAL(16,0) NULL,
		`OBSERVACIONES_VISTA` VARCHAR(500) NULL,
		`SUSPENSIVO_ID` DECIMAL(16,0) NULL,
		`COL_DUMMY` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
		`NUM_CONTRATOS` INT NULL,
  		`SALDO_VENCIDO` DECIMAL(14,2) NULL,         
  		`SALDO_NO_VENCIDO` DECIMAL(14,2) NULL,
		`INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  		`SUBTOTAL` DECIMAL(14,2) NULL
	);
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_RECURSOS_MES' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_RECURSOS_MES;
	end if;
	
	CREATE TABLE H_PRC_RECURSOS_MES(  
	  	`DIA_ID` DATE NULL,
	  	`MES_ID` INT NOT NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`RECURSO_ID` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`PROCEDIMIENTO_PARALIZADO_ID` DECIMAL(16,0) NULL, /* Nombre modificado en el cambio 2015-04-07 */ 
		/* INICIO: Cambio 2015-04-07 */
		`TIPO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO
		`TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO_DET
		`FASE_ACTUAL_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL
		`FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL_DETALLE
		/* FIN: Cambio 2015-04-07 */
		`ACTOR_ID` DECIMAL(16,0) NULL,
		`TIPO_RECURSO_ID` DECIMAL(16,0) NULL,
		`CAUSA_RECURSO_ID` DECIMAL(16,0) NULL,
		`ES_FAVORABLE_ID` DECIMAL(16,0) NULL,
		`RESULTADO_RESOL_ID` DECIMAL(16,0) NULL,
		`TAREA_ID` DECIMAL(16,0) NULL,
		`FECHA_RECURSO` DATE NULL,
		`FECHA_IMPUGNACION` DATE NULL,
		`FECHA_VISTA` DATE NULL,
		`FECHA_RESOLUCION` DATE NULL,
		`RCR_OBSERVACIONES` VARCHAR(500) NULL,
		`OBSERVACIONES_IMPUGNACION` VARCHAR(500) NULL,
		`OBSERVACIONES_RESOLUCION` VARCHAR(500) NULL,
		`CONFIRM_VISTA_ID` DECIMAL(16,0) NULL,
		`CONFIRM_IMPUGNACION_ID` DECIMAL(16,0) NULL,
		`OBSERVACIONES_VISTA` VARCHAR(500) NULL,
		`SUSPENSIVO_ID` DECIMAL(16,0) NULL,
		`COL_DUMMY` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
		`NUM_CONTRATOS` INT NULL,
  		`SALDO_VENCIDO` DECIMAL(14,2) NULL,         
  		`SALDO_NO_VENCIDO` DECIMAL(14,2) NULL,
		`INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  		`SUBTOTAL` DECIMAL(14,2) NULL
	);
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_RECURSOS_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_RECURSOS_TRIMESTRE;
	end if;
	
	CREATE TABLE H_PRC_RECURSOS_TRIMESTRE(  
	  	`TRIMESTRE_ID` INT NOT NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`RECURSO_ID` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`PROCEDIMIENTO_PARALIZADO_ID` DECIMAL(16,0) NULL, /* Nombre modificado en el cambio 2015-04-07 */ 
		/* INICIO: Cambio 2015-04-07 */
		`TIPO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO
		`TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO_DET
		`FASE_ACTUAL_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL
		`FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL_DETALLE
		/* FIN: Cambio 2015-04-07 */
		`ACTOR_ID` DECIMAL(16,0) NULL,
		`TIPO_RECURSO_ID` DECIMAL(16,0) NULL,
		`CAUSA_RECURSO_ID` DECIMAL(16,0) NULL,
		`ES_FAVORABLE_ID` DECIMAL(16,0) NULL,
		`RESULTADO_RESOL_ID` DECIMAL(16,0) NULL,
		`TAREA_ID` DECIMAL(16,0) NULL,
		`FECHA_RECURSO` DATE NULL,
		`FECHA_IMPUGNACION` DATE NULL,
		`FECHA_VISTA` DATE NULL,
		`FECHA_RESOLUCION` DATE NULL,
		`RCR_OBSERVACIONES` VARCHAR(500) NULL,
		`OBSERVACIONES_IMPUGNACION` VARCHAR(500) NULL,
		`OBSERVACIONES_RESOLUCION` VARCHAR(500) NULL,
		`CONFIRM_VISTA_ID` DECIMAL(16,0) NULL,
		`CONFIRM_IMPUGNACION_ID` DECIMAL(16,0) NULL,
		`OBSERVACIONES_VISTA` VARCHAR(500) NULL,
		`SUSPENSIVO_ID` DECIMAL(16,0) NULL,
		`COL_DUMMY` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
		`NUM_CONTRATOS` INT NULL,
  		`SALDO_VENCIDO` DECIMAL(14,2) NULL,         
  		`SALDO_NO_VENCIDO` DECIMAL(14,2) NULL,
		`INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  		`SUBTOTAL` DECIMAL(14,2) NULL
	);
	
	select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PRC_RECURSOS_ANIO' and table_schema = 'bi_cdd_dwh';
	if (HAY_TABLA > 0) then 
	    DROP TABLE H_PRC_RECURSOS_ANIO;
	end if;
	
	CREATE TABLE H_PRC_RECURSOS_ANIO(  
	  	`ANIO_ID` INT NOT NULL,
		`FECHA_CARGA_DATOS` DATE NOT NULL,
		`RECURSO_ID` DECIMAL(16,0) NOT NULL,
		`PROCEDIMIENTO_ID` DECIMAL(16,0) NULL,
		`PROCEDIMIENTO_PARALIZADO_ID` DECIMAL(16,0) NULL, /* Nombre modificado en el cambio 2015-04-07 */ 
		/* INICIO: Cambio 2015-04-07 */
		`TIPO_PROCEDIMIENTO_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO
		`TIPO_PROCEDIMIENTO_DET_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_TIPO_PROCEDIMIENTO_DET
		`FASE_ACTUAL_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL
		`FASE_ACTUAL_DETALLE_ID` DECIMAL(16,0) NULL, -- ID relacionado con D_PRC_FASE_ACTUAL_DETALLE
		/* FIN: Cambio 2015-04-07 */
		`ACTOR_ID` DECIMAL(16,0) NULL,
		`TIPO_RECURSO_ID` DECIMAL(16,0) NULL,
		`CAUSA_RECURSO_ID` DECIMAL(16,0) NULL,
		`ES_FAVORABLE_ID` DECIMAL(16,0) NULL,
		`RESULTADO_RESOL_ID` DECIMAL(16,0) NULL,
		`TAREA_ID` DECIMAL(16,0) NULL,
		`FECHA_RECURSO` DATE NULL,
		`FECHA_IMPUGNACION` DATE NULL,
		`FECHA_VISTA` DATE NULL,
		`FECHA_RESOLUCION` DATE NULL,
		`RCR_OBSERVACIONES` VARCHAR(500) NULL,
		`OBSERVACIONES_IMPUGNACION` VARCHAR(500) NULL,
		`OBSERVACIONES_RESOLUCION` VARCHAR(500) NULL,
		`CONFIRM_VISTA_ID` DECIMAL(16,0) NULL,
		`CONFIRM_IMPUGNACION_ID` DECIMAL(16,0) NULL,
		`OBSERVACIONES_VISTA` VARCHAR(500) NULL,
		`SUSPENSIVO_ID` DECIMAL(16,0) NULL,
		`COL_DUMMY` DECIMAL(16,0) NULL,
		`ENTIDAD_CEDENTE_ID` DECIMAL(16,0) NOT NULL,
		`NUM_CONTRATOS` INT NULL,
  		`SALDO_VENCIDO` DECIMAL(14,2) NULL,         
  		`SALDO_NO_VENCIDO` DECIMAL(14,2) NULL,
		`INGRESOS_PENDIENTES_APLICAR` DECIMAL(14,2) NULL,
  		`SUBTOTAL` DECIMAL(14,2) NULL
	);
	
	-- ** CREACION DE INDICES **

	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_RECURSOS' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_RECURSO_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_RECURSOS' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX H_PRC_RECURSO_IX ON H_PRC_RECURSOS (DIA_ID, RECURSO_ID, ENTIDAD_CEDENTE_ID);
	end if;

	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_RECURSOS_MES' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_RECURSO_MES_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_RECURSOS_MES' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX H_PRC_RECURSO_MES_IX ON H_PRC_RECURSOS_MES (MES_ID, RECURSO_ID, ENTIDAD_CEDENTE_ID);
	end if;
	
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_RECURSOS_TRIMESTRE' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_RECURSO_TRIMESTRE_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_RECURSOS_TRIMESTRE' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX H_PRC_RECURSO_TRIMESTRE_IX ON H_PRC_RECURSOS_TRIMESTRE (TRIMESTRE_ID, RECURSO_ID, ENTIDAD_CEDENTE_ID);
	end if;
	
	select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PRC_RECURSOS_ANIO' and table_schema = 'bi_cdd_dwh' and INDEX_NAME = 'H_PRC_RECURSO_ANIO_IX';
	select count(TABLE_NAME) into HAY_TABLA from information_schema.tables  where table_name = 'H_PRC_RECURSOS_ANIO' and table_schema = 'bi_cdd_dwh';
	if (HAY < 1 && HAY_TABLA = 1) then 
		CREATE INDEX H_PRC_RECURSO_ANIO_IX ON H_PRC_RECURSOS_ANIO (ANIO_ID, RECURSO_ID, ENTIDAD_CEDENTE_ID);
	end if;
 
END MY_BLOCK_CREAR_H_PRC_COBROS
