-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Procedimiento` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_PRC: BEGIN

-- ===============================================================================================
-- Autor: Víctor Chavero, PFS Group
-- Fecha creación: Septiembre 2014
-- Responsable última modificación: María Villanueva, PFS Group
-- Fecha última modificación:23/12/2015
-- Motivos del cambio: Se añade el orden a las tareas en plazos medios
-- Cliente: CDD
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Procedimiento.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN PROCEDIMIENTO
    -- D_PRC_JUZGADO
    -- D_PRC_PLAZA 
    -- D_PRC_TIPO_RECLAMACION
    -- D_PRC_TIPO_PROCEDIMIENTO_AGR
    -- D_PRC_TIPO_PROCEDIMIENTO 
    -- D_PRC_TIPO_PROCEDIMIENTO_DET
    -- D_PRC_FASE_ACTUAL
    -- D_PRC_FASE_ACTUAL_DETALLE
    -- D_PRC_FASE_TAREA
    -- D_PRC_FASE_TAREA_DETALLE
    -- D_PRC_FASE_ANTERIOR
    -- D_PRC_FASE_ANTERIOR_DETALLE
    -- D_PRC_ESTADO_PROCEDIMIENTO
    -- D_PRC_ESTADO_FASE_ACTUAL
    -- D_PRC_ESTADO_FASE_ANTERIOR
    -- D_PRC_ULT_TAR_CREADA_TIPO
    -- D_PRC_ULT_TAR_CREADA_TIPO_DET
    -- D_PRC_ULT_TAR_CREADA_DESC
    -- D_PRC_ULT_TAR_FIN_TIPO
    -- D_PRC_ULT_TAR_FIN_TIPO_DET
    -- D_PRC_ULT_TAR_FIN_DESC
    -- D_PRC_ULT_TAR_ACT_TIPO
    -- D_PRC_ULT_TAR_ACT_TIPO_DET
    -- D_PRC_ULT_TAR_ACT_DESC
    -- D_PRC_ULT_TAR_PEND_TIPO
    -- D_PRC_ULT_TAR_PEND_TIPO_DET
    -- D_PRC_ULT_TAR_PEND_DESC
    -- D_PRC_GESTOR
    -- D_PRC_GESTOR_EN_RECOVERY
    -- D_PRC_SUPERVISOR
    -- D_PRC_DESPACHO_GESTOR
    -- D_PRC_DESPACHO_SUPERVISOR 
    -- D_PRC_TIPO_DESP_GESTOR 
    -- D_PRC_TIPO_DESPACHO_SUPERVISOR 
    -- D_PRC_ENTIDAD_GESTOR 
    -- D_PRC_ENTIDAD_SUPERVISOR 
    -- D_PRC_NIVEL_DESP_GESTOR 
    -- D_PRC_NIVEL_DESP_SUPERVISOR
    -- D_PRC_OFI_DESP_GESTOR
    -- D_PRC_OFI_DESP_SUPERVISOR
    -- D_PRC_PROV_DESP_GESTOR
    -- D_PRC_PROV_DESP_SUPERVISOR
    -- D_PRC_ZONA_DESP_GESTOR
    -- D_PRC_ZONA_DESP_SUPERVISOR
    -- D_PRC_T_SALDO_TOTAL
    -- D_PRC_T_SALDO_TOTAL_CONCURSO
    -- D_PRC_TD_ULTIMA_ACTUALIZACION
    -- D_PRC_TD_CONTRATO_VENCIDO
    -- D_PRC_TD_CNT_VENC_CREACION_ASU
    -- D_PRC_ULT_TAR_PEND_CUMPL
    -- D_PRC_ULT_TAR_FIN_CUMPL
    -- D_PRC_TD_AUTO_FC_DIA_ANALISIS
    -- D_PRC_TD_AUTO_FC_LIQUIDACION
    -- D_PRC_ESTADO_CONVENIO
    -- D_PRC_SEGUIMIENTO_CONVENIO
    -- D_PRC_T_PORCENTAJE_QUITA_CONV
    -- D_PRC_GARANTIA_CONCURSO
    -- D_PRC_TD_CREA_ASU_A_INTERP_DEM
    -- D_PRC_TD_CREACION_ASU_ACEPT
    -- D_PRC_TD_CREA_ASU_REC_DOC_ACEP
    -- D_PRC_TD_REC_DOC_ACEPT_REG_TD
    -- D_PRC_TD_REC_DOC_ACEPT_REC_DC
    -- D_PRC_TD_ACEPT_ASU_INTERP_DEM
    -- D_PRC_TD_ID_DECL_RESOL_FIRME
    -- D_PRC_TD_ID_ORD_INI_APREMIO
    -- D_PRC_TD_ID_HIP_SUBASTA
    -- D_PRC_TD_SUB_SOL_SUB_CEL
    -- D_PRC_TD_SUB_CEL_CESION_REMATE
    -- D_PRC_FASE_SUBASTA_HIPOTECARIO
    -- D_PRC_ULT_TAR_FASE_HIP
    -- D_PRC_TD_ID_MON_DECRETO_FIN
    -- D_PRC_F_SUBASTA_EJEC_NOTARIAL
    -- D_PRC_CNT_GARANTIA_REAL_ASOC
    -- D_PRC_COBRO_TIPO_DET
    -- D_PRC_COBRO_TIPO
    -- D_PRC_ACT_ESTIMACIONES
    -- D_PRC_CARTERA
    -- D_PRC_TITULAR
    -- D_PRC_PLAZA_CONEXP
    -- D_PRC_JUZGADO_CONEXP
    -- D_PRC_PROCURADOR_CONEXP
    -- D_PRC_CON_OPOSICION
    -- D_PRC_ULT_TAR_PEND_FILTR_DESC
    -- D_PRC_FASE_TAREA_AGR	
    -- D_PRC


-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
declare max_id int;
declare tarea_desc varchar(100);
declare entidad_cedente int;
declare l_last_row int default 0;

declare c_tarea_desc cursor for 
	select nn.TAR_TAREA, nn.ENTIDAD_CEDENTE_ID from (
	select distinct TAR_TAREA, 1 ENTIDAD_CEDENTE_ID 
	FROM bi_cdd_bng_datastage.TAR_TAREAS_NOTIFICACIONES 
	where PRC_ID IS NOT NULL -- order by 1
	union
	select distinct TAR_TAREA, 2 ENTIDAD_CEDENTE_ID 
	FROM bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES 
	where PRC_ID IS NOT NULL -- order by 1	
	union
	select distinct TAR_TAREA, 3 ENTIDAD_CEDENTE_ID
	FROM bi_cdd_bankia_datastage.TAR_TAREAS_NOTIFICACIONES 
	where PRC_ID IS NOT NULL -- order by 1		
	union
	select distinct TAR_TAREA, 4 ENTIDAD_CEDENTE_ID 
	FROM bi_cdd_cajamar_datastage.TAR_TAREAS_NOTIFICACIONES 
	where PRC_ID IS NOT NULL -- order by 1		
	) nn order by 1
;
	
	
declare continue HANDLER FOR NOT FOUND SET l_last_row = 1;  

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

 
/*-- ----------------------------------------------------------------------------------------------
--                            D_PRC_JUZGADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_JUZGADO where JUZGADO_ID = -1) = 0) then
	insert into D_PRC_JUZGADO (JUZGADO_ID, JUZGADO_DESC, JUZGADO_DESC_2, PLAZA_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into D_PRC_JUZGADO(JUZGADO_ID, JUZGADO_DESC, JUZGADO_DESC_2, PLAZA_ID)
    select DD_JUZ_ID, DD_JUZ_DESCRIPCION, DD_JUZ_DESCRIPCION_LARGA, DD_PLA_ID FROM bi_cdd_bng_datastage.DD_JUZ_JUZGADOS_PLAZA;
            

-- ----------------------------------------------------------------------------------------------
--                            D_PRC_PLAZA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_PLAZA where PLAZA_ID = -1) = 0) then
	insert into D_PRC_PLAZA (PLAZA_ID, PLAZA_DESC, PLAZA_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into D_PRC_PLAZA(PLAZA_ID, PLAZA_DESC, PLAZA_DESC_2)
    select DD_PLA_ID, DD_PLA_DESCRIPCION, DD_PLA_DESCRIPCION_LARGA FROM bi_cdd_bng_datastage.DD_PLA_PLAZAS;
*/

/*-- ----------------------------------------------------------------------------------------------
--                          D_PRC_TIPO_RECLAMACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TIPO_RECLAMACION where TIPO_RECLAMACION_ID = -1) = 0) then
	insert into D_PRC_TIPO_RECLAMACION (TIPO_RECLAMACION_ID, TIPO_RECLAMACION_DESC, TIPO_RECLAMACION_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into D_PRC_TIPO_RECLAMACION(TIPO_RECLAMACION_ID, TIPO_RECLAMACION_DESC, TIPO_RECLAMACION_DESC_2)
    select DD_TRE_ID, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA FROM bi_cdd_bng_datastage.DD_TRE_TIPO_RECLAMACION;
*/


-- ----------------------------------------------------------------------------------------------
--              <<OK>>             D_PRC_TIPO_PROCEDIMIENTO_AGR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = -1 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = 1 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (1 ,'P. Monitorio', -1);
end if;

if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = 2 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (2 ,'ETNJ', -1);
end if;

if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = 3 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (3 ,'P. Hipotecario', -1);
end if;

if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = 4 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (4 ,'P. Declarativo', -1);
end if;

if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = 5 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (5 ,'Concurso', -1);
end if;

if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = 6 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (6 ,'Gestión Especializada', -1);
end if;

if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_AGR where TIPO_PROCEDIMIENTO_AGR_ID = 7 AND ENTIDAD_CEDENTE_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) values (7 ,'Resto', -1);
end if;

	-- ABANCA
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (-1 ,'Desconocido', 1);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (1 ,'P. Monitorio', 1);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (2 ,'ETNJ', 1);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (3 ,'P. Hipotecario', 1);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (4 ,'P. Declarativo', 1);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (5 ,'Concurso', 1);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (6 ,'Gestión Especializada', 1);
    insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
    	values (7 ,'Resto', 1);
    
	-- BBVA
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (-1 ,'Desconocido', 2);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (1 ,'P. Monitorio', 2);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (2 ,'ETNJ', 2);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (3 ,'P. Hipotecario', 2);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (4 ,'P. Declarativo', 2);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (5 ,'Concurso', 2);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (6 ,'Gestión Especializada', 2);
    insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
    	values (7 ,'Resto', 2);

	-- BANKIA
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (-1 ,'Desconocido', 3);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (1 ,'P. Monitorio', 3);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (2 ,'ETNJ', 3);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (3 ,'P. Hipotecario', 3);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (4 ,'P. Declarativo', 3);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (5 ,'Concurso', 3);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (6 ,'Gestión Especializada', 3);
    insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
    	values (7 ,'Resto', 3);

	-- CAJAMAR
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (-1 ,'Desconocido', 4);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (1 ,'P. Monitorio', 4);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (2 ,'ETNJ', 4);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (3 ,'P. Hipotecario', 4);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (4 ,'P. Declarativo', 4);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (5 ,'Concurso', 4);
	insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
		values (6 ,'Gestión Especializada', 4);
    insert into D_PRC_TIPO_PROCEDIMIENTO_AGR (TIPO_PROCEDIMIENTO_AGR_ID, TIPO_PROCEDIMIENTO_AGR_DESC, ENTIDAD_CEDENTE_ID) 
    	values (7 ,'Resto', 4);

-- ----------------------------------------------------------------------------------------------
--                 <<OK>>               D_PRC_TIPO_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO where TIPO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO (TIPO_PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_DESC, TIPO_PROCEDIMIENTO_DESC_2, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_TIPO_PROCEDIMIENTO(TIPO_PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_DESC, TIPO_PROCEDIMIENTO_DESC_2, ENTIDAD_CEDENTE_ID)
    select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TAC_TIPO_ACTUACION	
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TAC_TIPO_ACTUACION	
;
    
-- ----------------------------------------------------------------------------------------------
--                <<OK>>         D_PRC_TIPO_PROCEDIMIENTO_DET
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TIPO_PROCEDIMIENTO_DET where TIPO_PROCEDIMIENTO_DET_ID = -1) = 0) then
	insert into D_PRC_TIPO_PROCEDIMIENTO_DET (
		TIPO_PROCEDIMIENTO_DET_ID, 
		TIPO_PROCEDIMIENTO_DET_DESC, 
		TIPO_PROCEDIMIENTO_DET_DESC_2, 
		TIPO_PROCEDIMIENTO_ID, 
		TIPO_PROCEDIMIENTO_AGR_ID, 
		ENTIDAD_CEDENTE_ID
	) values (-1 ,'Desconocido', 'Desconocido', -1, -1, -1);
end if;

insert into D_PRC_TIPO_PROCEDIMIENTO_DET(
 	TIPO_PROCEDIMIENTO_DET_ID, 
 	TIPO_PROCEDIMIENTO_DET_DESC, 
 	TIPO_PROCEDIMIENTO_DET_DESC_2, 
 	TIPO_PROCEDIMIENTO_ID, 
 	ENTIDAD_CEDENTE_ID
 	)
    select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 1 
    FROM bi_cdd_bng_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 2 
	FROM bi_cdd_bbva_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 3 
	FROM bi_cdd_bankia_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 4 
	FROM bi_cdd_cajamar_datastage.DD_TPO_TIPO_PROCEDIMIENTO		
;

-- Incluimos TIPO_PROCEDIMIENTO_AGR_ID
-- 1 - P. Monitorio
update D_PRC_TIPO_PROCEDIMIENTO_DET set TIPO_PROCEDIMIENTO_AGR_ID = 1 where TIPO_PROCEDIMIENTO_DET_ID in (2);

-- 2-ETNJ
update D_PRC_TIPO_PROCEDIMIENTO_DET set TIPO_PROCEDIMIENTO_AGR_ID = 2 where TIPO_PROCEDIMIENTO_DET_ID in (33);

-- 3-P. Hipotecario
update D_PRC_TIPO_PROCEDIMIENTO_DET set TIPO_PROCEDIMIENTO_AGR_ID = 3 where TIPO_PROCEDIMIENTO_DET_ID in (1);

-- 4-P. Declarativo
update D_PRC_TIPO_PROCEDIMIENTO_DET set TIPO_PROCEDIMIENTO_AGR_ID = 4 
where TIPO_PROCEDIMIENTO_DET_ID in (21,22,41,155,156,157,158,159,160,162,163,164,165,166,167,168,169,170,171,172);

-- 5-Concurso
update D_PRC_TIPO_PROCEDIMIENTO_DET set TIPO_PROCEDIMIENTO_AGR_ID = 5 
where TIPO_PROCEDIMIENTO_DET_ID in (141,142,143,144,145,146,147,148,149,150,151,152,541,542,543,841,1141);

-- 6-Gestión Especializada
update D_PRC_TIPO_PROCEDIMIENTO_DET set TIPO_PROCEDIMIENTO_AGR_ID = 6 where TIPO_PROCEDIMIENTO_DET_ID in (1241,1242);

-- 7-Resto
update D_PRC_TIPO_PROCEDIMIENTO_DET set TIPO_PROCEDIMIENTO_AGR_ID = 7 where TIPO_PROCEDIMIENTO_AGR_ID is null;

-- ----------------------------------------------------------------------------------------------
--                   <<OK>>          D_PRC_FASE_ACTUAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_FASE_ACTUAL where FASE_ACTUAL_ID = -1) = 0) then
	insert into D_PRC_FASE_ACTUAL (FASE_ACTUAL_ID, FASE_ACTUAL_DESC, FASE_ACTUAL_DESC_2, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_FASE_ACTUAL(FASE_ACTUAL_ID, FASE_ACTUAL_DESC, FASE_ACTUAL_DESC_2, ENTIDAD_CEDENTE_ID)
    select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TAC_TIPO_ACTUACION	
;

-- ----------------------------------------------------------------------------------------------
--                    <<OK>>         D_PRC_FASE_ACTUAL_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_FASE_ACTUAL_DETALLE where FASE_ACTUAL_DETALLE_ID = -1) = 0) then
	insert into D_PRC_FASE_ACTUAL_DETALLE (FASE_ACTUAL_DETALLE_ID, FASE_ACTUAL_DETALLE_DESC, FASE_ACTUAL_DETALLE_DESC_2, FASE_ACTUAL_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into D_PRC_FASE_ACTUAL_DETALLE(FASE_ACTUAL_DETALLE_ID, FASE_ACTUAL_DETALLE_DESC, FASE_ACTUAL_DETALLE_DESC_2, FASE_ACTUAL_ID, ENTIDAD_CEDENTE_ID)
    select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 1 
    FROM bi_cdd_bng_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 2 
	FROM bi_cdd_bbva_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 3 
	FROM bi_cdd_bankia_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 4 
	FROM bi_cdd_cajamar_datastage.DD_TPO_TIPO_PROCEDIMIENTO	
;
    
    



-- ----------------------------------------------------------------------------------------------
--                   <<OK>>          D_PRC_FASE_TAREA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_FASE_TAREA where FASE_TAREA_ID = -1) = 0) then
	insert into D_PRC_FASE_TAREA (FASE_TAREA_ID, FASE_TAREA_DESC, FASE_TAREA_DESC_2, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_FASE_TAREA(FASE_TAREA_ID, FASE_TAREA_DESC, FASE_TAREA_DESC_2, ENTIDAD_CEDENTE_ID)
    select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TAC_TIPO_ACTUACION	
;

-- ----------------------------------------------------------------------------------------------
--                    <<OK>>         D_PRC_FASE_TAREA_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_FASE_TAREA_DETALLE where FASE_TAREA_DETALLE_ID = -1) = 0) then
	insert into D_PRC_FASE_TAREA_DETALLE (FASE_TAREA_DETALLE_ID, FASE_TAREA_DETALLE_DESC, FASE_TAREA_DETALLE_DESC_2, FASE_TAREA_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into D_PRC_FASE_TAREA_DETALLE(FASE_TAREA_DETALLE_ID, FASE_TAREA_DETALLE_DESC, FASE_TAREA_DETALLE_DESC_2, FASE_TAREA_ID, ENTIDAD_CEDENTE_ID)
    select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 1 
    FROM bi_cdd_bng_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 2 
	FROM bi_cdd_bbva_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 3 
	FROM bi_cdd_bankia_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 4 
	FROM bi_cdd_cajamar_datastage.DD_TPO_TIPO_PROCEDIMIENTO	
;
-- ----------------------------------------------------------------------------------------------
--                       <<OK>>      D_PRC_FASE_ANTERIOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_FASE_ANTERIOR where FASE_ANTERIOR_ID = -2) = 0) then
	insert into D_PRC_FASE_ANTERIOR (FASE_ANTERIOR_ID, FASE_ANTERIOR_DESC, FASE_ANTERIOR_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'No Aplica (Iter)', 'No Aplica (Iter)', -1);
end if;

if ((select count(*) from D_PRC_FASE_ANTERIOR where FASE_ANTERIOR_ID = -1) = 0) then
	insert into D_PRC_FASE_ANTERIOR (FASE_ANTERIOR_ID, FASE_ANTERIOR_DESC, FASE_ANTERIOR_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_FASE_ANTERIOR(FASE_ANTERIOR_ID, FASE_ANTERIOR_DESC, FASE_ANTERIOR_DESC_2, ENTIDAD_CEDENTE_ID)
    select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TAC_TIPO_ACTUACION
	union
	select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TAC_TIPO_ACTUACION	
;


-- ----------------------------------------------------------------------------------------------
--                   <<OK>>       D_PRC_FASE_ANTERIOR_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_FASE_ANTERIOR_DETALLE where FASE_ANTERIOR_DETALLE_ID = -2) = 0) then
	insert into D_PRC_FASE_ANTERIOR_DETALLE (FASE_ANTERIOR_DETALLE_ID, FASE_ANTERIOR_DETALLE_DESC, FASE_ANTERIOR_DETALLE_DESC_2, FASE_ANTERIOR_ID, ENTIDAD_CEDENTE_ID) values (-2 ,'No Aplica (Iter)', 'No Aplica (Iter)', -2, -1);
end if;

if ((select count(*) from D_PRC_FASE_ANTERIOR_DETALLE where FASE_ANTERIOR_DETALLE_ID = -1) = 0) then
	insert into D_PRC_FASE_ANTERIOR_DETALLE (FASE_ANTERIOR_DETALLE_ID, FASE_ANTERIOR_DETALLE_DESC, FASE_ANTERIOR_DETALLE_DESC_2, FASE_ANTERIOR_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

insert into D_PRC_FASE_ANTERIOR_DETALLE(FASE_ANTERIOR_DETALLE_ID, FASE_ANTERIOR_DETALLE_DESC, FASE_ANTERIOR_DETALLE_DESC_2, FASE_ANTERIOR_ID, ENTIDAD_CEDENTE_ID)
    select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 1 
    FROM bi_cdd_bng_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 2 
	FROM bi_cdd_bbva_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 3 
	FROM bi_cdd_bankia_datastage.DD_TPO_TIPO_PROCEDIMIENTO
	union
	select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID, 4 
	FROM bi_cdd_cajamar_datastage.DD_TPO_TIPO_PROCEDIMIENTO		
;
    
    
-- ----------------------------------------------------------------------------------------------
--                 <<OK>>           D_PRC_ESTADO_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ESTADO_PROCEDIMIENTO where ESTADO_PROCEDIMIENTO_ID = -1) = 0) then
    insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) 
    values (-1 ,'Desconocido', -1);
end if;

if ((select count(*) from D_PRC_ESTADO_PROCEDIMIENTO where ESTADO_PROCEDIMIENTO_ID = 0) = 0) then
    insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) 
    values (0,'Activo', -1);
end if;

if ((select count(*) from D_PRC_ESTADO_PROCEDIMIENTO where ESTADO_PROCEDIMIENTO_ID = 1) = 0) then
    insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) 
    values (1 ,'No Activo', -1);
end if;

insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 1);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 2);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 3);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 4);

insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (0 ,'Activo', 1);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (0 ,'Activo', 2);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (0 ,'Activo', 3);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (0 ,'Activo', 4);

insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (1 ,'No Activo', 1);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (1 ,'No Activo', 2);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (1 ,'No Activo', 3);
insert into D_PRC_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (1 ,'No Activo', 4);

-- ----------------------------------------------------------------------------------------------
--                 <<OK>>       D_PRC_ESTADO_FASE_ACTUAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ESTADO_FASE_ACTUAL where ESTADO_FASE_ACTUAL_ID = -1) = 0) then
	insert into D_PRC_ESTADO_FASE_ACTUAL (ESTADO_FASE_ACTUAL_ID, ESTADO_FASE_ACTUAL_DESC, ESTADO_FASE_ACTUAL_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_ESTADO_FASE_ACTUAL(ESTADO_FASE_ACTUAL_ID, ESTADO_FASE_ACTUAL_DESC, ESTADO_FASE_ACTUAL_DESC_2, ENTIDAD_CEDENTE_ID)
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 1 
	FROM bi_cdd_bng_datastage.DD_EPR_ESTADO_PROCEDIMIENTO
	union
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_EPR_ESTADO_PROCEDIMIENTO
	union
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_EPR_ESTADO_PROCEDIMIENTO
	union
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_EPR_ESTADO_PROCEDIMIENTO	
;
    

-- ----------------------------------------------------------------------------------------------
--                 <<OK>>      D_PRC_ESTADO_FASE_ANTERIOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ESTADO_FASE_ANTERIOR where ESTADO_FASE_ANTERIOR_ID = -2) = 0) then
	insert into D_PRC_ESTADO_FASE_ANTERIOR (ESTADO_FASE_ANTERIOR_ID, ESTADO_FASE_ANTERIOR_DESC, ESTADO_FASE_ANTERIOR_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'No Aplica (Iter)', 'No Aplica (Iter)', -1);
end if;

if ((select count(*) from D_PRC_ESTADO_FASE_ANTERIOR where ESTADO_FASE_ANTERIOR_ID = -1) = 0) then
	insert into D_PRC_ESTADO_FASE_ANTERIOR (ESTADO_FASE_ANTERIOR_ID, ESTADO_FASE_ANTERIOR_DESC, ESTADO_FASE_ANTERIOR_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_ESTADO_FASE_ANTERIOR(ESTADO_FASE_ANTERIOR_ID, ESTADO_FASE_ANTERIOR_DESC, ESTADO_FASE_ANTERIOR_DESC_2, ENTIDAD_CEDENTE_ID)
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 1 
	FROM bi_cdd_bng_datastage.DD_EPR_ESTADO_PROCEDIMIENTO
	union
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_EPR_ESTADO_PROCEDIMIENTO
	union
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_EPR_ESTADO_PROCEDIMIENTO
	union
	select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_EPR_ESTADO_PROCEDIMIENTO		
;
  

-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_CREADA_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_CREADA_TIPO where ULT_TAR_CREADA_TIPO_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_CREADA_TIPO (ULT_TAR_CREADA_TIPO_ID, ULT_TAR_CREADA_TIPO_DESC, ULT_TAR_CREADA_TIPO_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_CREADA_TIPO where ULT_TAR_CREADA_TIPO_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_CREADA_TIPO (ULT_TAR_CREADA_TIPO_ID, ULT_TAR_CREADA_TIPO_DESC, ULT_TAR_CREADA_TIPO_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into D_PRC_ULT_TAR_CREADA_TIPO(ULT_TAR_CREADA_TIPO_ID, ULT_TAR_CREADA_TIPO_DESC, ULT_TAR_CREADA_TIPO_DESC_2, ENTIDAD_CEDENTE_ID)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TAR_TIPO_TAREA_BASE
    union
	select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TAR_TIPO_TAREA_BASE
    union
	select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TAR_TIPO_TAREA_BASE
    union
	select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TAR_TIPO_TAREA_BASE	
  ;
    

-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_CREADA_TIPO_DET
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_CREADA_TIPO_DET where ULT_TAR_CREADA_TIPO_DET_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_CREADA_TIPO_DET (ULT_TAR_CREADA_TIPO_DET_ID, ULT_TAR_CREADA_TIPO_DET_DESC, ULT_TAR_CREADA_TIPO_DET_DESC_2, ULT_TAR_CREADA_TIPO_ID, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2, -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_CREADA_TIPO_DET where ULT_TAR_CREADA_TIPO_DET_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_CREADA_TIPO_DET (ULT_TAR_CREADA_TIPO_DET_ID, ULT_TAR_CREADA_TIPO_DET_DESC, ULT_TAR_CREADA_TIPO_DET_DESC_2, ULT_TAR_CREADA_TIPO_ID, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into D_PRC_ULT_TAR_CREADA_TIPO_DET(ULT_TAR_CREADA_TIPO_DET_ID, ULT_TAR_CREADA_TIPO_DET_DESC, ULT_TAR_CREADA_TIPO_DET_DESC_2, ULT_TAR_CREADA_TIPO_ID, ENTIDAD_CEDENTE_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 1 
    FROM bi_cdd_bng_datastage.DD_STA_SUBTIPO_TAREA_BASE    
    union
	select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 3 
	FROM bi_cdd_bankia_datastage.DD_STA_SUBTIPO_TAREA_BASE
    union
	select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 2 
	FROM bi_cdd_bbva_datastage.DD_STA_SUBTIPO_TAREA_BASE
    union
	select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 4 
	FROM bi_cdd_cajamar_datastage.DD_STA_SUBTIPO_TAREA_BASE	    
 ;
  
    
   
-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_CREADA_DESC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_CREADA_DESC where ULT_TAR_CREADA_DESC_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_CREADA_DESC (ULT_TAR_CREADA_DESC_ID, ULT_TAR_CREADA_DESC_DESC, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'Ninguna Tarea Asociada', -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_CREADA_DESC where ULT_TAR_CREADA_DESC_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_CREADA_DESC (ULT_TAR_CREADA_DESC_ID, ULT_TAR_CREADA_DESC_DESC, ENTIDAD_CEDENTE_ID) 
	values (-1, 'Desconocido', -1);
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc, entidad_cedente;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULT_TAR_CREADA_DESC_ID) from D_PRC_ULT_TAR_CREADA_DESC) +1;
insert into D_PRC_ULT_TAR_CREADA_DESC (ULT_TAR_CREADA_DESC_ID, ULT_TAR_CREADA_DESC_DESC, ENTIDAD_CEDENTE_ID)
values (max_id, tarea_desc, entidad_cedente);

end loop; 
close c_tarea_desc;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_FIN_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_FIN_TIPO where ULT_TAR_FIN_TIPO_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_FIN_TIPO (ULT_TAR_FIN_TIPO_ID, ULT_TAR_FIN_TIPO_DESC, ULT_TAR_FIN_TIPO_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_FIN_TIPO where ULT_TAR_FIN_TIPO_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_FIN_TIPO (ULT_TAR_FIN_TIPO_ID, ULT_TAR_FIN_TIPO_DESC, ULT_TAR_FIN_TIPO_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_ULT_TAR_FIN_TIPO(ULT_TAR_FIN_TIPO_ID, ULT_TAR_FIN_TIPO_DESC, ULT_TAR_FIN_TIPO_DESC_2, ENTIDAD_CEDENTE_ID)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 1 AS ENTIDAD_CEDENTE_ID 
    FROM bi_cdd_bng_datastage.DD_TAR_TIPO_TAREA_BASE
	UNION
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 2 AS ENTIDAD_CEDENTE_ID 
    FROM bi_cdd_bbva_datastage.DD_TAR_TIPO_TAREA_BASE
	UNION
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 3 AS ENTIDAD_CEDENTE_ID 
    FROM bi_cdd_bankia_datastage.DD_TAR_TIPO_TAREA_BASE
	UNION
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 4 AS ENTIDAD_CEDENTE_ID 
    FROM bi_cdd_cajamar_datastage.DD_TAR_TIPO_TAREA_BASE			    
;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_FIN_TIPO_DET
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_FIN_TIPO_DET where ULT_TAR_FIN_TIPO_DET_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_FIN_TIPO_DET (ULT_TAR_FIN_TIPO_DET_ID, ULT_TAR_FIN_TIPO_DET_DESC, ULT_TAR_FIN_TIPO_DET_DESC_2, ULT_TAR_FIN_TIPO_ID, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2, -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_FIN_TIPO_DET where ULT_TAR_FIN_TIPO_DET_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_FIN_TIPO_DET (ULT_TAR_FIN_TIPO_DET_ID, ULT_TAR_FIN_TIPO_DET_DESC, ULT_TAR_FIN_TIPO_DET_DESC_2, ULT_TAR_FIN_TIPO_ID, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

insert into D_PRC_ULT_TAR_FIN_TIPO_DET(ULT_TAR_FIN_TIPO_DET_ID, ULT_TAR_FIN_TIPO_DET_DESC, ULT_TAR_FIN_TIPO_DET_DESC_2, ULT_TAR_FIN_TIPO_ID, ENTIDAD_CEDENTE_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 1 AS ENTIDAD_CEDENTE_ID  
    FROM bi_cdd_bng_datastage.DD_STA_SUBTIPO_TAREA_BASE
    UNION
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 2 AS ENTIDAD_CEDENTE_ID  
    FROM bi_cdd_bbva_datastage.DD_STA_SUBTIPO_TAREA_BASE
    UNION
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 3 AS ENTIDAD_CEDENTE_ID  
    FROM bi_cdd_bankia_datastage.DD_STA_SUBTIPO_TAREA_BASE
    UNION
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 4 AS ENTIDAD_CEDENTE_ID 
    FROM bi_cdd_cajamar_datastage.DD_STA_SUBTIPO_TAREA_BASE            
;
    
/*
-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_FIN_DESC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_FIN_DESC where ULT_TAR_FIN_DESC_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC) values (-2 ,'Ninguna Tarea Asociada');
end if;

if ((select count(*) from D_PRC_ULT_TAR_FIN_DESC where ULT_TAR_FIN_DESC_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC) values (-1, 'Desconocido');
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULT_TAR_FIN_DESC_ID) from D_PRC_ULT_TAR_FIN_DESC) +1;
insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC)
values (max_id,tarea_desc);

end loop;
close c_tarea_desc;
*/

-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_ACT_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_ACT_TIPO where ULT_TAR_ACT_TIPO_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_ACT_TIPO (ULT_TAR_ACT_TIPO_ID, ULT_TAR_ACT_TIPO_DESC, ULT_TAR_ACT_TIPO_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_ACT_TIPO where ULT_TAR_ACT_TIPO_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_ACT_TIPO (ULT_TAR_ACT_TIPO_ID, ULT_TAR_ACT_TIPO_DESC, ULT_TAR_ACT_TIPO_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into D_PRC_ULT_TAR_ACT_TIPO(ULT_TAR_ACT_TIPO_ID, ULT_TAR_ACT_TIPO_DESC, ULT_TAR_ACT_TIPO_DESC_2, ENTIDAD_CEDENTE_ID)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TAR_TIPO_TAREA_BASE
    union
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 2 
    FROM bi_cdd_bbva_datastage.DD_TAR_TIPO_TAREA_BASE
    union
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 3 
    FROM bi_cdd_bankia_datastage.DD_TAR_TIPO_TAREA_BASE  
    union
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA, 4 
    FROM bi_cdd_cajamar_datastage.DD_TAR_TIPO_TAREA_BASE          
    ;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_ACT_TIPO_DET
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_ACT_TIPO_DET where ULT_TAR_ACT_TIPO_DET_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_ACT_TIPO_DET (ULT_TAR_ACT_TIPO_DET_ID, ULT_TAR_ACT_TIPO_DET_DESC, ULT_TAR_ACT_TIPO_DET_DESC_2, ULT_TAR_ACT_TIPO_ID, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2, -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_ACT_TIPO_DET where ULT_TAR_ACT_TIPO_DET_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_ACT_TIPO_DET (ULT_TAR_ACT_TIPO_DET_ID, ULT_TAR_ACT_TIPO_DET_DESC, ULT_TAR_ACT_TIPO_DET_DESC_2, ULT_TAR_ACT_TIPO_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into D_PRC_ULT_TAR_ACT_TIPO_DET(ULT_TAR_ACT_TIPO_DET_ID, ULT_TAR_ACT_TIPO_DET_DESC, ULT_TAR_ACT_TIPO_DET_DESC_2, ULT_TAR_ACT_TIPO_ID, ENTIDAD_CEDENTE_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 1 
    FROM bi_cdd_bng_datastage.DD_STA_SUBTIPO_TAREA_BASE
    UNION
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 2 
    FROM bi_cdd_bbva_datastage.DD_STA_SUBTIPO_TAREA_BASE
    UNION
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 3 
    FROM bi_cdd_bankia_datastage.DD_STA_SUBTIPO_TAREA_BASE
    UNION
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 4 
    FROM bi_cdd_cajamar_datastage.DD_STA_SUBTIPO_TAREA_BASE            
    ;
    

-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_ACT_DESC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_ACT_DESC where ULT_TAR_ACT_DESC_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_ACT_DESC (ULT_TAR_ACT_DESC_ID, ULT_TAR_ACT_DESC_DESC, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'Ninguna Tarea Asociada', -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_ACT_DESC where ULT_TAR_ACT_DESC_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_ACT_DESC (ULT_TAR_ACT_DESC_ID, ULT_TAR_ACT_DESC_DESC, ENTIDAD_CEDENTE_ID) 
	values (-1, 'Desconocido', -1);
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc, entidad_cedente;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULT_TAR_ACT_DESC_ID) from D_PRC_ULT_TAR_ACT_DESC) +1;
insert into D_PRC_ULT_TAR_ACT_DESC (ULT_TAR_ACT_DESC_ID, ULT_TAR_ACT_DESC_DESC, ENTIDAD_CEDENTE_ID)
values (max_id,tarea_desc, entidad_cedente);

end loop;
close c_tarea_desc;

/*
-- ----------------------------------------------------------------------------------------------
--                       D_PRC_ULT_TAR_PEND_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_PEND_TIPO where ULT_TAR_PEND_TIPO_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_PEND_TIPO (ULT_TAR_PEND_TIPO_ID, ULT_TAR_PEND_TIPO_DESC, ULT_TAR_PEND_TIPO_DESC_2) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada');
end if;

if ((select count(*) from D_PRC_ULT_TAR_PEND_TIPO where ULT_TAR_PEND_TIPO_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_PEND_TIPO (ULT_TAR_PEND_TIPO_ID, ULT_TAR_PEND_TIPO_DESC, ULT_TAR_PEND_TIPO_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into D_PRC_ULT_TAR_PEND_TIPO(ULT_TAR_PEND_TIPO_ID, ULT_TAR_PEND_TIPO_DESC, ULT_TAR_PEND_TIPO_DESC_2)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM bi_cdd_bng_datastage.DD_TAR_TIPO_TAREA_BASE;

*/
-- ----------------------------------------------------------------------------------------------
--                                    D_PRC_ULT_TAR_PEND_TIPO_DET
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_PEND_TIPO_DET where ULT_TAR_PEND_TIPO_DET_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_PEND_TIPO_DET (ULT_TAR_PEND_TIPO_DET_ID, ULT_TAR_PEND_TIPO_DET_DESC, ULT_TAR_PEND_TIPO_DET_DESC_2, ULT_TAR_PEND_TIPO_ID, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2, -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_PEND_TIPO_DET where ULT_TAR_PEND_TIPO_DET_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_PEND_TIPO_DET (ULT_TAR_PEND_TIPO_DET_ID, ULT_TAR_PEND_TIPO_DET_DESC, ULT_TAR_PEND_TIPO_DET_DESC_2, ULT_TAR_PEND_TIPO_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

insert into D_PRC_ULT_TAR_PEND_TIPO_DET(ULT_TAR_PEND_TIPO_DET_ID, ULT_TAR_PEND_TIPO_DET_DESC, ULT_TAR_PEND_TIPO_DET_DESC_2, ULT_TAR_PEND_TIPO_ID, ENTIDAD_CEDENTE_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 1 
    FROM bi_cdd_bng_datastage.DD_STA_SUBTIPO_TAREA_BASE
    union
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 2 
    FROM bi_cdd_bbva_datastage.DD_STA_SUBTIPO_TAREA_BASE
    union
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 3 
    FROM bi_cdd_bankia_datastage.DD_STA_SUBTIPO_TAREA_BASE
    union
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID, 4 
    FROM bi_cdd_cajamar_datastage.DD_STA_SUBTIPO_TAREA_BASE            
;

    
/* */
-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_PEND_DESC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_PEND_DESC where ULT_TAR_PEND_DESC_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_PEND_DESC (ULT_TAR_PEND_DESC_ID, ULT_TAR_PEND_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', -1);
end if;

if ((select count(*) from D_PRC_ULT_TAR_PEND_DESC where ULT_TAR_PEND_DESC_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_PEND_DESC (ULT_TAR_PEND_DESC_ID, ULT_TAR_PEND_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', -1);
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc, entidad_cedente;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULT_TAR_PEND_DESC_ID) from D_PRC_ULT_TAR_PEND_DESC) +1;
insert into D_PRC_ULT_TAR_PEND_DESC (ULT_TAR_PEND_DESC_ID, ULT_TAR_PEND_DESC_DESC, ENTIDAD_CEDENTE_ID)
values (max_id,tarea_desc, entidad_cedente);

end loop;
close c_tarea_desc;



-- ----------------------------------------------------------------------------------------------
--                  <<OK>>                   D_PRC_GESTOR
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_GESTOR where GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_GESTOR(
    GESTOR_PRC_ID,
    GESTOR_PRC_NOMBRE_COMPLETO,
    GESTOR_PRC_NOMBRE,
    GESTOR_PRC_APELLIDO1,
    GESTOR_PRC_APELLIDO2,
    ENTIDAD_GESTOR_PRC_ID, 
    DESPACHO_GESTOR_PRC_ID,
	ENTIDAD_CEDENTE_ID
	) values (-1 ,'Sin Gestor Asignado','Sin Gestor Asignado', 'Sin Gestor Asignado', 'Sin Gestor Asignado', -1, -1, -1);
end if;

insert into D_PRC_GESTOR (
    GESTOR_PRC_ID,
    GESTOR_PRC_NOMBRE_COMPLETO,
    GESTOR_PRC_NOMBRE,
    GESTOR_PRC_APELLIDO1,
    GESTOR_PRC_APELLIDO2,
    ENTIDAD_GESTOR_PRC_ID, 
    DESPACHO_GESTOR_PRC_ID,
	ENTIDAD_CEDENTE_ID
    )
	select usu.USU_ID,
		coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), 'Desconocido'),
		coalesce(usu.USU_NOMBRE, 'Desconocido'),
		coalesce(usu.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu.USU_APELLIDO2, 'Desconocido'),
		usu.ENTIDAD_ID,
		usd.DES_ID,
		1
	from bi_cdd_bng_datastage.USD_USUARIOS_DESPACHOS usd 
		join bi_cdd_bng_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
		join bi_cdd_bng_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_bng_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
	where tges.DD_TGE_DESCRIPCION = 'Gestor' group by usu.USU_ID
	union 
	select usu2.USU_ID,
		coalesce(concat_ws('', usu2.USU_NOMBRE, ' ', usu2.USU_APELLIDO1, ' ', usu2.USU_APELLIDO2), 'Desconocido'),
		coalesce(usu2.USU_NOMBRE, 'Desconocido'),
		coalesce(usu2.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu2.USU_APELLIDO2, 'Desconocido'),
		usu2.ENTIDAD_ID,
		usd2.DES_ID,
		2
	from bi_cdd_bbva_datastage.USD_USUARIOS_DESPACHOS usd2 
		join bi_cdd_bbva_datastage.USU_USUARIOS usu2 on usd2.USU_ID = usu2.USU_ID     
		join bi_cdd_bbva_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa2 on gaa2.USD_ID = usd2.USD_ID
		join bi_cdd_bbva_datastage.DD_TGE_TIPO_GESTOR tges2 on gaa2.DD_TGE_ID = tges2.DD_TGE_ID
	where tges2.DD_TGE_CODIGO = 'GEXT' 
	group by usu2.USU_ID
	union
	select usu3.USU_ID,
		coalesce(concat_ws('', usu3.USU_NOMBRE, ' ', usu3.USU_APELLIDO1, ' ', usu3.USU_APELLIDO2), 'Desconocido'),
		coalesce(usu3.USU_NOMBRE, 'Desconocido'),
		coalesce(usu3.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu3.USU_APELLIDO2, 'Desconocido'),
		usu3.ENTIDAD_ID,
		usd3.DES_ID,
		3
	from bi_cdd_bankia_datastage.USD_USUARIOS_DESPACHOS usd3 
		join bi_cdd_bankia_datastage.USU_USUARIOS usu3 on usd3.USU_ID = usu3.USU_ID     
		join bi_cdd_bankia_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa3 on gaa3.USD_ID = usd3.USD_ID
		join bi_cdd_bankia_datastage.DD_TGE_TIPO_GESTOR tges3 on gaa3.DD_TGE_ID = tges3.DD_TGE_ID
	where tges3.DD_TGE_CODIGO = 'GEXT' 
	group by usu3.USU_ID	
	union
	select usu4.USU_ID,
		coalesce(concat_ws('', usu4.USU_NOMBRE, ' ', usu4.USU_APELLIDO1, ' ', usu4.USU_APELLIDO2), 'Desconocido'),
		coalesce(usu4.USU_NOMBRE, 'Desconocido'),
		coalesce(usu4.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu4.USU_APELLIDO2, 'Desconocido'),
		usu4.ENTIDAD_ID,
		usd4.DES_ID,
		4
	from bi_cdd_cajamar_datastage.USD_USUARIOS_DESPACHOS usd4 
		join bi_cdd_cajamar_datastage.USU_USUARIOS usu4 on usd4.USU_ID = usu4.USU_ID     
		join bi_cdd_cajamar_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa4 on gaa4.USD_ID = usd4.USD_ID
		join bi_cdd_cajamar_datastage.DD_TGE_TIPO_GESTOR tges4 on gaa4.DD_TGE_ID = tges4.DD_TGE_ID
	where tges4.DD_TGE_CODIGO = 'GEXT'  
	group by usu4.USU_ID		
;

-- Parece propio de UGAS, no lo hago multi-cliente
update D_PRC_GESTOR set GESTOR_EN_RECOVERY_PRC_ID = (
	case 
	when GESTOR_PRC_ID in (
		select USU_ID 
		from bi_cdd_bng_datastage.LSS_LETRADOS_NCG_PFS lss
			join bi_cdd_bng_datastage.USU_USUARIOS usu on usu.usu_username = lss.usuario
		where INDICADOR='C' OR INDICADOR='P')then 1
	else 0 end
);

-- ----------------------------------------------------------------------------------------------
--                <<OK>>          D_PRC_GESTOR_EN_RECOVERY
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_GESTOR_EN_RECOVERY where GESTOR_EN_RECOVERY_PRC_ID = 0) = 0) then
	insert into D_PRC_GESTOR_EN_RECOVERY (GESTOR_EN_RECOVERY_PRC_ID, GESTOR_EN_RECOVERY_PRC_DESC, ENTIDAD_CEDENTE_ID) 
	values (0 ,'No Usa Recovery', -1);
end if;

if ((select count(*) from D_PRC_GESTOR_EN_RECOVERY where GESTOR_EN_RECOVERY_PRC_ID = 1) = 0) then
	insert into D_PRC_GESTOR_EN_RECOVERY (GESTOR_EN_RECOVERY_PRC_ID, GESTOR_EN_RECOVERY_PRC_DESC, ENTIDAD_CEDENTE_ID) 
	values (1 ,'Usa Recovery', -1);
end if;

-- ----------------------------------------------------------------------------------------------
--                 <<OK>>            D_PRC_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_SUPERVISOR where SUPERVISOR_PRC_ID = -1) = 0) then
	insert into D_PRC_SUPERVISOR(
		SUPERVISOR_PRC_ID,
		SUPERVISOR_PRC_NOMBRE_COMPLETO,
		SUPERVISOR_PRC_NOMBRE,
		SUPERVISOR_PRC_APELLIDO1,
		SUPERVISOR_PRC_APELLIDO2,
		ENTIDAD_SUPER_PRC_ID, 
		DESP_SUPER_PRC_ID,
		ENTIDAD_CEDENTE_ID
		) values (
		-1 ,
		'Sin Supervisor Asignado', 
		'Sin Supervisor Asignado', 
		'Sin Supervisor Asignado', 
		'Sin Supervisor Asignado', 
		-1, 
		-1, 
		-1
		)
	;
end if;

	insert into D_PRC_SUPERVISOR (
		SUPERVISOR_PRC_ID,
		SUPERVISOR_PRC_NOMBRE_COMPLETO,
		SUPERVISOR_PRC_NOMBRE,
		SUPERVISOR_PRC_APELLIDO1,
		SUPERVISOR_PRC_APELLIDO2,
		ENTIDAD_SUPER_PRC_ID, 
		DESP_SUPER_PRC_ID,
		ENTIDAD_CEDENTE_ID
	)
	select usu.USU_ID,
		coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), ' ', 'Desconocido'),
		coalesce(usu.USU_NOMBRE, 'Desconocido'),
		coalesce(usu.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu.USU_APELLIDO2, 'Desconocido'),
		usu.ENTIDAD_ID,
		usd.DES_ID,
		1
	from bi_cdd_bng_datastage.USD_USUARIOS_DESPACHOS usd 
		join bi_cdd_bng_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
		join bi_cdd_bng_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_bng_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
	where tges.DD_TGE_CODIGO = 'SUP' 
	group by usu.USU_ID
	union
	select usu2.USU_ID,
		coalesce(concat_ws('', usu2.USU_NOMBRE, ' ', usu2.USU_APELLIDO1, ' ', usu2.USU_APELLIDO2), ' ', 'Desconocido'),
		coalesce(usu2.USU_NOMBRE, 'Desconocido'),
		coalesce(usu2.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu2.USU_APELLIDO2, 'Desconocido'),
		usu2.ENTIDAD_ID,
		usd2.DES_ID,
		2 
	from bi_cdd_bbva_datastage.USD_USUARIOS_DESPACHOS usd2 
		join bi_cdd_bbva_datastage.USU_USUARIOS usu2 on usd2.USU_ID = usu2.USU_ID     
		join bi_cdd_bbva_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa2 on gaa2.USD_ID = usd2.USD_ID
		join bi_cdd_bbva_datastage.DD_TGE_TIPO_GESTOR tges2 on gaa2.DD_TGE_ID = tges2.DD_TGE_ID
	where tges2.DD_TGE_CODIGO = 'SUP' 
	group by usu2.USU_ID
	union
	select usu3.USU_ID,
		coalesce(concat_ws('', usu3.USU_NOMBRE, ' ', usu3.USU_APELLIDO1, ' ', usu3.USU_APELLIDO2), ' ', 'Desconocido'),
		coalesce(usu3.USU_NOMBRE, 'Desconocido'),
		coalesce(usu3.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu3.USU_APELLIDO2, 'Desconocido'),
		usu3.ENTIDAD_ID,
		usd3.DES_ID,
		3 
	from bi_cdd_bankia_datastage.USD_USUARIOS_DESPACHOS usd3 
		join bi_cdd_bankia_datastage.USU_USUARIOS usu3 on usd3.USU_ID = usu3.USU_ID     
		join bi_cdd_bankia_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa3 on gaa3.USD_ID = usd3.USD_ID
		join bi_cdd_bankia_datastage.DD_TGE_TIPO_GESTOR tges3 on gaa3.DD_TGE_ID = tges3.DD_TGE_ID
	where tges3.DD_TGE_CODIGO = 'SUP' 
	group by usu3.USU_ID
	union
	select usu4.USU_ID,
		coalesce(concat_ws('', usu4.USU_NOMBRE, ' ', usu4.USU_APELLIDO1, ' ', usu4.USU_APELLIDO2), ' ', 'Desconocido'),
		coalesce(usu4.USU_NOMBRE, 'Desconocido'),
		coalesce(usu4.USU_APELLIDO1, 'Desconocido'),
		coalesce(usu4.USU_APELLIDO2, 'Desconocido'),
		usu4.ENTIDAD_ID,
		usd4.DES_ID,
		4 
	from bi_cdd_cajamar_datastage.USD_USUARIOS_DESPACHOS usd4 
		join bi_cdd_cajamar_datastage.USU_USUARIOS usu4 on usd4.USU_ID = usu4.USU_ID     
		join bi_cdd_cajamar_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa4 on gaa4.USD_ID = usd4.USD_ID
		join bi_cdd_cajamar_datastage.DD_TGE_TIPO_GESTOR tges4 on gaa4.DD_TGE_ID = tges4.DD_TGE_ID
	where tges4.DD_TGE_CODIGO = 'SUP' 
	group by usu4.USU_ID		
;


-- ----------------------------------------------------------------------------------------------
--        <<OK>>      D_PRC_DESPACHO_GESTOR / D_PRC_DESPACHO_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_DESPACHO_GESTOR where DESPACHO_GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_DESPACHO_GESTOR (DESPACHO_GESTOR_PRC_ID, DESPACHO_GESTOR_PRC_DESC, TIPO_DESP_GESTOR_PRC_ID, ZONA_DESP_GESTOR_PRC_ID, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', -1, -1, -1);
end if;

insert into D_PRC_DESPACHO_GESTOR(DESPACHO_GESTOR_PRC_ID, DESPACHO_GESTOR_PRC_DESC, TIPO_DESP_GESTOR_PRC_ID, ZONA_DESP_GESTOR_PRC_ID, ENTIDAD_CEDENTE_ID)
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 1 
	FROM bi_cdd_bng_datastage.DES_DESPACHO_EXTERNO
	union 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 2 
	FROM bi_cdd_bbva_datastage.DES_DESPACHO_EXTERNO
	union 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 3 
	FROM bi_cdd_bankia_datastage.DES_DESPACHO_EXTERNO
	union 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 4 
	FROM bi_cdd_cajamar_datastage.DES_DESPACHO_EXTERNO		
;

if ((select count(*) from D_PRC_DESPACHO_SUPERVISOR where DESP_SUPER_PRC_ID = -1) = 0) then
	insert into D_PRC_DESPACHO_SUPERVISOR (DESP_SUPER_PRC_ID, DESP_SUPER_PRC_DESC, TIPO_DESP_SUPER_PRC_ID, ZONA_DESP_SUPER_PRC_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, -1, -1);
end if;

insert into D_PRC_DESPACHO_SUPERVISOR(DESP_SUPER_PRC_ID, DESP_SUPER_PRC_DESC, TIPO_DESP_SUPER_PRC_ID, ZONA_DESP_SUPER_PRC_ID, ENTIDAD_CEDENTE_ID)
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 1 
	FROM bi_cdd_bng_datastage.DES_DESPACHO_EXTERNO
	UNION
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 2 
	FROM bi_cdd_bbva_datastage.DES_DESPACHO_EXTERNO
	UNION
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 3 
	FROM bi_cdd_bankia_datastage.DES_DESPACHO_EXTERNO
	UNION
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 4 
	FROM bi_cdd_cajamar_datastage.DES_DESPACHO_EXTERNO		
;



-- ----------------------------------------------------------------------------------------------
--       <<OK>>   D_PRC_TIPO_DESP_GESTOR / D_PRC_TIPO_DESPACHO_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TIPO_DESP_GESTOR where TIPO_DESP_GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_TIPO_DESP_GESTOR (TIPO_DESP_GESTOR_PRC_ID, TIPO_DESP_GESTOR_PRC_DESC, TIPO_DESP_GESTOR_PRC_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_TIPO_DESP_GESTOR(TIPO_DESP_GESTOR_PRC_ID, TIPO_DESP_GESTOR_PRC_DESC, TIPO_DESP_GESTOR_PRC_DESC_2, ENTIDAD_CEDENTE_ID)
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 1 
	FROM bi_cdd_bng_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TDE_TIPO_DESPACHO
;
    

if ((select count(*) from D_PRC_TIPO_DESPACHO_SUPERVISOR where TIPO_DESP_SUPER_PRC_ID = -1) = 0) then
	insert into D_PRC_TIPO_DESPACHO_SUPERVISOR (TIPO_DESP_SUPER_PRC_ID, TIPO_DESP_SUPER_PRC_DESC, TIPO_DESP_SUPER_PRC_DESC_2, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_PRC_TIPO_DESPACHO_SUPERVISOR(TIPO_DESP_SUPER_PRC_ID, TIPO_DESP_SUPER_PRC_DESC, TIPO_DESP_SUPER_PRC_DESC_2, ENTIDAD_CEDENTE_ID)
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 1 
	FROM bi_cdd_bng_datastage.DD_TDE_TIPO_DESPACHO
	union
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TDE_TIPO_DESPACHO
	union
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TDE_TIPO_DESPACHO
	union
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TDE_TIPO_DESPACHO
;
    

-- ----------------------------------------------------------------------------------------------
--      <<OK>>      D_PRC_ENTIDAD_GESTOR / D_PRC_ENTIDAD_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ENTIDAD_GESTOR where ENTIDAD_GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_ENTIDAD_GESTOR (ENTIDAD_GESTOR_PRC_ID, ENTIDAD_GESTOR_PRC_DESC, ENTIDAD_CEDENTE_ID) 
	values (-1, 'Desconocido', -1);
end if;

insert into D_PRC_ENTIDAD_GESTOR(ENTIDAD_GESTOR_PRC_ID, ENTIDAD_GESTOR_PRC_DESC, ENTIDAD_CEDENTE_ID)
	select ID, DESCRIPCION, 1 AS ENTIDAD FROM bi_cdd_bng_datastage.ENTIDAD
	union
	select ID, DESCRIPCION, 2 AS ENTIDAD FROM bi_cdd_bbva_datastage.ENTIDAD
	union
	select ID, DESCRIPCION, 3 AS ENTIDAD FROM bi_cdd_bankia_datastage.ENTIDAD
	union
	select ID, DESCRIPCION, 4 AS ENTIDAD FROM bi_cdd_cajamar_datastage.ENTIDAD
;

/* EJD:> No es correcto, necesita coherencia con la D_PRC_GESTOR
SELECT  (@rownum:=@rownum+1) AS rownum, DESCRIPCION, ENTIDAD FROM (
    select (@rownum:=0) r, DESCRIPCION, 1 AS ENTIDAD FROM bi_cdd_bng_datastage.ENTIDAD
	union
    select (@rownum:=0) r, DESCRIPCION, 2 AS ENTIDAD FROM bi_cdd_bbva_datastage.ENTIDAD
	union
    select (@rownum:=0) r, DESCRIPCION, 3 AS ENTIDAD FROM bi_cdd_bankia_datastage.ENTIDAD
	union
    select (@rownum:=0) r, DESCRIPCION, 4 AS ENTIDAD FROM bi_cdd_cajamar_datastage.ENTIDAD
) DD
;
*/

    
if ((select count(*) from D_PRC_ENTIDAD_SUPERVISOR where ENTIDAD_SUPER_PRC_ID = -1) = 0) then
	insert into D_PRC_ENTIDAD_SUPERVISOR (ENTIDAD_SUPER_PRC_ID, ENTIDAD_SUPER_PRC_DESC, ENTIDAD_CEDENTE_ID) 
	values (-1, 'Desconocido', -1);
end if;

insert into D_PRC_ENTIDAD_SUPERVISOR(ENTIDAD_SUPER_PRC_ID, ENTIDAD_SUPER_PRC_DESC, ENTIDAD_CEDENTE_ID)
SELECT  (@rownum:=@rownum+1) AS rownum, DESCRIPCION, ENTIDAD FROM (
    select (@rownum:=0) r, DESCRIPCION, 1 AS ENTIDAD FROM bi_cdd_bng_datastage.ENTIDAD
	union
    select (@rownum:=0) r, DESCRIPCION, 2 AS ENTIDAD FROM bi_cdd_bbva_datastage.ENTIDAD
	union
    select (@rownum:=0) r, DESCRIPCION, 3 AS ENTIDAD FROM bi_cdd_bankia_datastage.ENTIDAD
	union
    select (@rownum:=0) r, DESCRIPCION, 4 AS ENTIDAD FROM bi_cdd_cajamar_datastage.ENTIDAD
) DD    
;   
    

/*-- ----------------------------------------------------------------------------------------------
--    D_PRC_NIVEL_DESP_GESTOR / D_PRC_NIVEL_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_NIVEL_DESP_GESTOR where NIVEL_DESP_GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_NIVEL_DESP_GESTOR (NIVEL_DESP_GESTOR_PRC_ID, NIVEL_DESP_GESTOR_PRC_DESC, NIVEL_DESP_GESTOR_PRC_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into D_PRC_NIVEL_DESP_GESTOR(NIVEL_DESP_GESTOR_PRC_ID, NIVEL_DESP_GESTOR_PRC_DESC, NIVEL_DESP_GESTOR_PRC_DESC_2)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM bi_cdd_bng_datastage.NIV_NIVEL;
    
if ((select count(*) from D_PRC_NIVEL_DESP_SUPERVISOR where NIVEL_DESP_SUPER_PRC_ID = -1) = 0) then
	insert into D_PRC_NIVEL_DESP_SUPERVISOR (NIVEL_DESP_SUPER_PRC_ID, NIVEL_DESP_SUPER_PRC_DESC, NIVEL_DESP_SUPER_PRC_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into D_PRC_NIVEL_DESP_SUPERVISOR(NIVEL_DESP_SUPER_PRC_ID, NIVEL_DESP_SUPER_PRC_DESC, NIVEL_DESP_SUPER_PRC_DESC_2)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM bi_cdd_bng_datastage.NIV_NIVEL;
    

-- ----------------------------------------------------------------------------------------------
--   D_PRC_OFI_DESP_GESTOR / D_PRC_OFI_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_OFI_DESP_GESTOR where OFI_DESP_GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_OFI_DESP_GESTOR (OFI_DESP_GESTOR_PRC_ID, OFI_DESP_GESTOR_PRC_DESC, OFI_DESP_GESTOR_PRC_DESC_2, PROV_DESP_GESTOR_PRC_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into D_PRC_OFI_DESP_GESTOR(OFI_DESP_GESTOR_PRC_ID, OFI_DESP_GESTOR_PRC_DESC, PROV_DESP_GESTOR_PRC_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM bi_cdd_bng_datastage.OFI_OFICINAS;

if ((select count(*) from D_PRC_OFI_DESP_SUPERVISOR where OFICINA_DESP_SUPER_PRC_ID = -1) = 0) then
	insert into D_PRC_OFI_DESP_SUPERVISOR (OFICINA_DESP_SUPER_PRC_ID, OFICINA_DESP_SUPER_PRC_DESC, OFICINA_DESP_SUPER_PRC_DESC_2, PROV_DESP_SUPER_PRC_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into D_PRC_OFI_DESP_SUPERVISOR(OFICINA_DESP_SUPER_PRC_ID, OFICINA_DESP_SUPER_PRC_DESC, PROV_DESP_SUPER_PRC_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM bi_cdd_bng_datastage.OFI_OFICINAS;
    
    
-- ----------------------------------------------------------------------------------------------
--  D_PRC_PROV_DESP_GESTOR / D_PRC_PROV_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------    
if ((select count(*) from D_PRC_PROV_DESP_GESTOR where PROV_DESP_GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_PROV_DESP_GESTOR (PROV_DESP_GESTOR_PRC_ID, PROV_DESP_GESTOR_PRC_DESC, PROV_DESP_GESTOR_PRC_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into D_PRC_PROV_DESP_GESTOR(PROV_DESP_GESTOR_PRC_ID, PROV_DESP_GESTOR_PRC_DESC, PROV_DESP_GESTOR_PRC_DESC_2)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM bi_cdd_bng_datastage.DD_PRV_PROVINCIA;

if ((select count(*) from D_PRC_PROV_DESP_SUPERVISOR where PROV_DESP_SUPER_PRC_ID = -1) = 0) then
	insert into D_PRC_PROV_DESP_SUPERVISOR (PROV_DESP_SUPER_PRC_ID, PROV_DESP_SUPER_PRC_DESC, PROV_DESP_SUPER_PRC_DESC_2) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into D_PRC_PROV_DESP_SUPERVISOR(PROV_DESP_SUPER_PRC_ID, PROV_DESP_SUPER_PRC_DESC, PROV_DESP_SUPER_PRC_DESC_2)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM bi_cdd_bng_datastage.DD_PRV_PROVINCIA;
    

-- ----------------------------------------------------------------------------------------------
--     D_PRC_ZONA_DESP_GESTOR / D_PRC_ZONA_DESP_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------  
if ((select count(*) from D_PRC_ZONA_DESP_GESTOR where ZONA_DESP_GESTOR_PRC_ID = -1) = 0) then
	insert into D_PRC_ZONA_DESP_GESTOR (ZONA_DESP_GESTOR_PRC_ID, ZONA_DESP_GESTOR_PRC_DESC, ZONA_DESP_GESTOR_PRC_DESC_2, NIVEL_DESP_GESTOR_PRC_ID, OFI_DESP_GESTOR_PRC_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into D_PRC_ZONA_DESP_GESTOR(ZONA_DESP_GESTOR_PRC_ID, ZONA_DESP_GESTOR_PRC_DESC, ZONA_DESP_GESTOR_PRC_DESC_2, NIVEL_DESP_GESTOR_PRC_ID, OFI_DESP_GESTOR_PRC_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM bi_cdd_bng_datastage.ZON_ZONIFICACION;

if ((select count(*) from D_PRC_ZONA_DESP_SUPERVISOR where ZONA_DESP_SUPER_PRC_ID = -1) = 0) then
	insert into D_PRC_ZONA_DESP_SUPERVISOR (ZONA_DESP_SUPER_PRC_ID, ZONA_DESP_SUPER_PRC_DESC, ZONA_DESP_SUPER_PRC_DESC_2, NIVEL_DESP_SUPER_PRC_ID, OFICINA_DESP_SUPER_PRC_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into D_PRC_ZONA_DESP_SUPERVISOR(ZONA_DESP_SUPER_PRC_ID, ZONA_DESP_SUPER_PRC_DESC, ZONA_DESP_SUPER_PRC_DESC_2, NIVEL_DESP_SUPER_PRC_ID, OFICINA_DESP_SUPER_PRC_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM bi_cdd_bng_datastage.ZON_ZONIFICACION;
*/

-- ----------------------------------------------------------------------------------------------
--          <<OK>>             D_PRC_T_SALDO_TOTAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_T_SALDO_TOTAL where T_SALDO_TOTAL_PRC_ID = -1) = 0) then
	insert into D_PRC_T_SALDO_TOTAL (T_SALDO_TOTAL_PRC_ID, T_SALDO_TOTAL_PRC_DESC, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Saldo Desconocido', -1);
end if;
if ((select count(*) from D_PRC_T_SALDO_TOTAL where T_SALDO_TOTAL_PRC_ID = 0) = 0) then
	insert into D_PRC_T_SALDO_TOTAL (T_SALDO_TOTAL_PRC_ID, T_SALDO_TOTAL_PRC_DESC, ENTIDAD_CEDENTE_ID) values (0,'< 1MM €', -1);
end if;
if ((select count(*) from D_PRC_T_SALDO_TOTAL where T_SALDO_TOTAL_PRC_ID = 1) = 0) then
	insert into D_PRC_T_SALDO_TOTAL (T_SALDO_TOTAL_PRC_ID, T_SALDO_TOTAL_PRC_DESC, ENTIDAD_CEDENTE_ID) values (1 ,'>= 1 MM €', -1);
end if;


-- ----------------------------------------------------------------------------------------------
--         <<OK>>                 D_PRC_T_SALDO_TOTAL_CONCURSO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_T_SALDO_TOTAL_CONCURSO where T_SALDO_TOTAL_CONCURSO_ID = -2) = 0) then
	insert into D_PRC_T_SALDO_TOTAL_CONCURSO (T_SALDO_TOTAL_CONCURSO_ID, T_SALDO_TOTAL_CONCURSO_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Concursado Sin Riesgo Directo', -1);
end if;
if ((select count(*) from D_PRC_T_SALDO_TOTAL_CONCURSO where T_SALDO_TOTAL_CONCURSO_ID = -1) = 0) then
	insert into D_PRC_T_SALDO_TOTAL_CONCURSO (T_SALDO_TOTAL_CONCURSO_ID, T_SALDO_TOTAL_CONCURSO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Saldo Desconocido', -1);
end if;
if ((select count(*) from D_PRC_T_SALDO_TOTAL_CONCURSO where T_SALDO_TOTAL_CONCURSO_ID = 0) = 0) then
	insert into D_PRC_T_SALDO_TOTAL_CONCURSO (T_SALDO_TOTAL_CONCURSO_ID, T_SALDO_TOTAL_CONCURSO_DESC, ENTIDAD_CEDENTE_ID) values (0,'< 1MM €', -1);
end if;
if ((select count(*) from D_PRC_T_SALDO_TOTAL_CONCURSO where T_SALDO_TOTAL_CONCURSO_ID = 1) = 0) then
	insert into D_PRC_T_SALDO_TOTAL_CONCURSO (T_SALDO_TOTAL_CONCURSO_ID, T_SALDO_TOTAL_CONCURSO_DESC, ENTIDAD_CEDENTE_ID) values (1 ,'>= 1 MM €', -1);
end if;


-- ----------------------------------------------------------------------------------------------
--           <<OK>>               D_PRC_TD_ULTIMA_ACTUALIZACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_ULTIMA_ACTUALIZACION where TD_ULT_ACTUALIZACION_PRC_ID = -1) = 0) then
	insert into D_PRC_TD_ULTIMA_ACTUALIZACION (TD_ULT_ACTUALIZACION_PRC_ID, TD_ULT_ACTUALIZACION_PRC_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Número Días Desconocido', -1);
end if;
if ((select count(*) from D_PRC_TD_ULTIMA_ACTUALIZACION where TD_ULT_ACTUALIZACION_PRC_ID = 0) = 0) then
	insert into D_PRC_TD_ULTIMA_ACTUALIZACION (TD_ULT_ACTUALIZACION_PRC_ID, TD_ULT_ACTUALIZACION_PRC_DESC, ENTIDAD_CEDENTE_ID) values (0 ,'<= 30 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_ULTIMA_ACTUALIZACION where TD_ULT_ACTUALIZACION_PRC_ID = 1) = 0) then
	insert into D_PRC_TD_ULTIMA_ACTUALIZACION (TD_ULT_ACTUALIZACION_PRC_ID, TD_ULT_ACTUALIZACION_PRC_DESC, ENTIDAD_CEDENTE_ID) values (1,'31-60 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_ULTIMA_ACTUALIZACION where TD_ULT_ACTUALIZACION_PRC_ID = 2) = 0) then
	insert into D_PRC_TD_ULTIMA_ACTUALIZACION (TD_ULT_ACTUALIZACION_PRC_ID, TD_ULT_ACTUALIZACION_PRC_DESC, ENTIDAD_CEDENTE_ID) values (2 ,'61-90 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_ULTIMA_ACTUALIZACION where TD_ULT_ACTUALIZACION_PRC_ID = 3) = 0) then
	insert into D_PRC_TD_ULTIMA_ACTUALIZACION (TD_ULT_ACTUALIZACION_PRC_ID, TD_ULT_ACTUALIZACION_PRC_DESC, ENTIDAD_CEDENTE_ID) values (3 ,'> 90 Días', -1);
end if;


-- ----------------------------------------------------------------------------------------------
--           <<OK>>               D_PRC_TD_CONTRATO_VENCIDO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_CONTRATO_VENCIDO where TD_CONTRATO_VENCIDO_ID = -2) = 0) then
	insert into D_PRC_TD_CONTRATO_VENCIDO (TD_CONTRATO_VENCIDO_ID, TD_CONTRATO_VENCIDO_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ningún Contrato Asociado Vencido', -1);
end if;
if ((select count(*) from D_PRC_TD_CONTRATO_VENCIDO where TD_CONTRATO_VENCIDO_ID = -1) = 0) then
	insert into D_PRC_TD_CONTRATO_VENCIDO (TD_CONTRATO_VENCIDO_ID, TD_CONTRATO_VENCIDO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Número Días Desconocido', -1);
end if;
if ((select count(*) from D_PRC_TD_CONTRATO_VENCIDO where TD_CONTRATO_VENCIDO_ID = 0) = 0) then
	insert into D_PRC_TD_CONTRATO_VENCIDO (TD_CONTRATO_VENCIDO_ID, TD_CONTRATO_VENCIDO_DESC, ENTIDAD_CEDENTE_ID) values (0 ,'<= 30 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CONTRATO_VENCIDO where TD_CONTRATO_VENCIDO_ID = 1) = 0) then
	insert into D_PRC_TD_CONTRATO_VENCIDO (TD_CONTRATO_VENCIDO_ID, TD_CONTRATO_VENCIDO_DESC, ENTIDAD_CEDENTE_ID) values (1,'31-60 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CONTRATO_VENCIDO where TD_CONTRATO_VENCIDO_ID = 2) = 0) then
	insert into D_PRC_TD_CONTRATO_VENCIDO (TD_CONTRATO_VENCIDO_ID, TD_CONTRATO_VENCIDO_DESC, ENTIDAD_CEDENTE_ID) values (2 ,'61-90 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CONTRATO_VENCIDO where TD_CONTRATO_VENCIDO_ID = 3) = 0) then
	insert into D_PRC_TD_CONTRATO_VENCIDO (TD_CONTRATO_VENCIDO_ID, TD_CONTRATO_VENCIDO_DESC, ENTIDAD_CEDENTE_ID) values (3 ,'> 90 Días', -1);
end if;


-- ----------------------------------------------------------------------------------------------
--       <<OK>>             D_PRC_TD_CNT_VENC_CREACION_ASU
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = -2) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) 
	values (-2 ,'Ningún Contrato Asociado Vencido', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = -1) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Número Días Desconocido', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = 0) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) 
	values (0 ,'0-30 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = 1) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) values (1,'31-60 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = 2) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) values (2,'61-90 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = 3) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) values (3,'91-120 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = 4) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) values (4,'121-150 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = 5) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) values (5,'151-180 Días', -1);
end if;
if ((select count(*) from D_PRC_TD_CNT_VENC_CREACION_ASU where TD_CNT_VENC_CREACION_ASU_ID = 6) = 0) then
	insert into D_PRC_TD_CNT_VENC_CREACION_ASU (TD_CNT_VENC_CREACION_ASU_ID, TD_CNT_VENC_CREACION_ASU_DESC, ENTIDAD_CEDENTE_ID) values (6,'> 180 Días', -1);
end if;

/*
-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_PEND_CUMPL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_PEND_CUMPL where CUMPLIMIENTO_ULT_TAR_PEND_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_PEND_CUMPL (CUMPLIMIENTO_ULT_TAR_PEND_ID, CUMPLIMIENTO_ULT_TAR_PEND_DESC) values (-2, 'Ninguna Tarea Pendiente Asocidada');
end if;
if ((select count(*) from D_PRC_ULT_TAR_PEND_CUMPL where CUMPLIMIENTO_ULT_TAR_PEND_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_PEND_CUMPL (CUMPLIMIENTO_ULT_TAR_PEND_ID, CUMPLIMIENTO_ULT_TAR_PEND_DESC) values (-1, 'Última Tarea Pendiente Sin Fecha de Vencimiento');
end if;
if ((select count(*) from D_PRC_ULT_TAR_PEND_CUMPL where CUMPLIMIENTO_ULT_TAR_PEND_ID = 0) = 0) then
	insert into D_PRC_ULT_TAR_PEND_CUMPL (CUMPLIMIENTO_ULT_TAR_PEND_ID, CUMPLIMIENTO_ULT_TAR_PEND_DESC) values (0, 'En Plazo');
end if;
if ((select count(*) from D_PRC_ULT_TAR_PEND_CUMPL where CUMPLIMIENTO_ULT_TAR_PEND_ID = 1) = 0) then
	insert into D_PRC_ULT_TAR_PEND_CUMPL (CUMPLIMIENTO_ULT_TAR_PEND_ID, CUMPLIMIENTO_ULT_TAR_PEND_DESC) values (1, 'Fuera De Plazo');
end if;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_FIN_CUMPL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_FIN_CUMPL where CUMPLIMIENTO_ULT_TAR_FIN_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_FIN_CUMPL (CUMPLIMIENTO_ULT_TAR_FIN_ID, CUMPLIMIENTO_ULT_TAR_FIN_DESC) values (-2, 'Ninguna Tarea Finalizada Asocidada');
end if;
if ((select count(*) from D_PRC_ULT_TAR_FIN_CUMPL where CUMPLIMIENTO_ULT_TAR_FIN_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_FIN_CUMPL (CUMPLIMIENTO_ULT_TAR_FIN_ID, CUMPLIMIENTO_ULT_TAR_FIN_DESC) values (-1, 'Última Tarea Finalizada Sin Fecha de Vencimiento');
end if;
if ((select count(*) from D_PRC_ULT_TAR_FIN_CUMPL where CUMPLIMIENTO_ULT_TAR_FIN_ID = 0) = 0) then
	insert into D_PRC_ULT_TAR_FIN_CUMPL (CUMPLIMIENTO_ULT_TAR_FIN_ID, CUMPLIMIENTO_ULT_TAR_FIN_DESC) values (0, 'En Plazo');
end if;
if ((select count(*) from D_PRC_ULT_TAR_FIN_CUMPL where CUMPLIMIENTO_ULT_TAR_FIN_ID = 1) = 0) then
	insert into D_PRC_ULT_TAR_FIN_CUMPL (CUMPLIMIENTO_ULT_TAR_FIN_ID, CUMPLIMIENTO_ULT_TAR_FIN_DESC) values (1, 'Fuera De Plazo');
end if;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_TD_AUTO_FC_DIA_ANALISIS
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_AUTO_FC_DIA_ANALISIS where TD_AUTO_FC_DIA_ANALISIS_ID = -1) = 0) then
	insert into D_PRC_TD_AUTO_FC_DIA_ANALISIS (TD_AUTO_FC_DIA_ANALISIS_ID, TD_AUTO_FC_DIA_ANALISIS_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_AUTO_FC_DIA_ANALISIS where TD_AUTO_FC_DIA_ANALISIS_ID = 0) = 0) then
	insert into D_PRC_TD_AUTO_FC_DIA_ANALISIS (TD_AUTO_FC_DIA_ANALISIS_ID, TD_AUTO_FC_DIA_ANALISIS_DESC) values (0 ,'<= 365 Días');
end if;
if ((select count(*) from D_PRC_TD_AUTO_FC_DIA_ANALISIS where TD_AUTO_FC_DIA_ANALISIS_ID = 1) = 0) then
	insert into D_PRC_TD_AUTO_FC_DIA_ANALISIS (TD_AUTO_FC_DIA_ANALISIS_ID, TD_AUTO_FC_DIA_ANALISIS_DESC) values (1,'> 365 Días');
end if;



-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_AUTO_FC_LIQUIDACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_AUTO_FC_LIQUIDACION where TD_AUTO_FC_LIQUIDACION_ID = -1) = 0) then
	insert into D_PRC_TD_AUTO_FC_LIQUIDACION (TD_AUTO_FC_LIQUIDACION_ID, TD_AUTO_FC_LIQUIDACION_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_AUTO_FC_LIQUIDACION where TD_AUTO_FC_LIQUIDACION_ID = 0) = 0) then
	insert into D_PRC_TD_AUTO_FC_LIQUIDACION (TD_AUTO_FC_LIQUIDACION_ID, TD_AUTO_FC_LIQUIDACION_DESC) values (0 ,'<= 365 Días');
end if;
if ((select count(*) from D_PRC_TD_AUTO_FC_LIQUIDACION where TD_AUTO_FC_LIQUIDACION_ID = 1) = 0) then
	insert into D_PRC_TD_AUTO_FC_LIQUIDACION (TD_AUTO_FC_LIQUIDACION_ID, TD_AUTO_FC_LIQUIDACION_DESC) values (1,'> 365 Días');
end if;
*/

/*-- ----------------------------------------------------------------------------------------------
--                D_PRC_ESTADO_CONVENIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ESTADO_CONVENIO where ESTADO_CONVENIO_ID = -2) = 0) then
	insert into D_PRC_ESTADO_CONVENIO (ESTADO_CONVENIO_ID, ESTADO_CONVENIO_DESC) values (-2 ,'No Aplica');
end if;
if ((select count(*) from D_PRC_ESTADO_CONVENIO where ESTADO_CONVENIO_ID = -1) = 0) then
	insert into D_PRC_ESTADO_CONVENIO (ESTADO_CONVENIO_ID, ESTADO_CONVENIO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_ESTADO_CONVENIO where ESTADO_CONVENIO_ID = 0) = 0) then
	insert into D_PRC_ESTADO_CONVENIO (ESTADO_CONVENIO_ID, ESTADO_CONVENIO_DESC) values (0 ,'No Aprobado');
end if;
if ((select count(*) from D_PRC_ESTADO_CONVENIO where ESTADO_CONVENIO_ID = 1) = 0) then
	insert into D_PRC_ESTADO_CONVENIO (ESTADO_CONVENIO_ID, ESTADO_CONVENIO_DESC) values (1,'Aprobado');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_SEGUIMIENTO_CONVENIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_SEGUIMIENTO_CONVENIO where SEGUIMIENTO_CONVENIO_ID = -2) = 0) then
	insert into D_PRC_SEGUIMIENTO_CONVENIO (SEGUIMIENTO_CONVENIO_ID, SEGUIMIENTO_CONVENIO_DESC) values (-2 ,'No Aplica');
end if;
if ((select count(*) from D_PRC_SEGUIMIENTO_CONVENIO where SEGUIMIENTO_CONVENIO_ID = -1) = 0) then
	insert into D_PRC_SEGUIMIENTO_CONVENIO (SEGUIMIENTO_CONVENIO_ID, SEGUIMIENTO_CONVENIO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_SEGUIMIENTO_CONVENIO where SEGUIMIENTO_CONVENIO_ID = 0) = 0) then
	insert into D_PRC_SEGUIMIENTO_CONVENIO (SEGUIMIENTO_CONVENIO_ID, SEGUIMIENTO_CONVENIO_DESC) values (0 ,'Incumplimiento');
end if;
if ((select count(*) from D_PRC_SEGUIMIENTO_CONVENIO where SEGUIMIENTO_CONVENIO_ID = 1) = 0) then
	insert into D_PRC_SEGUIMIENTO_CONVENIO (SEGUIMIENTO_CONVENIO_ID, SEGUIMIENTO_CONVENIO_DESC) values (1,'Cumplimiento');
end if;
if ((select count(*) from D_PRC_SEGUIMIENTO_CONVENIO where SEGUIMIENTO_CONVENIO_ID = 2) = 0) then
	insert into D_PRC_SEGUIMIENTO_CONVENIO (SEGUIMIENTO_CONVENIO_ID, SEGUIMIENTO_CONVENIO_DESC) values (2 ,'Pendiente');
end if;

-- ----------------------------------------------------------------------------------------------
--                D_PRC_T_PORCENTAJE_QUITA_CONV
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_T_PORCENTAJE_QUITA_CONV where T_PORCENTAJE_QUITA_ID = -2) = 0) then
	insert into D_PRC_T_PORCENTAJE_QUITA_CONV (T_PORCENTAJE_QUITA_ID, T_PORCENTAJE_QUITA_DESC) values (-2 ,'No Aplica');
end if;
if ((select count(*) from D_PRC_T_PORCENTAJE_QUITA_CONV where T_PORCENTAJE_QUITA_ID = -1) = 0) then
	insert into D_PRC_T_PORCENTAJE_QUITA_CONV (T_PORCENTAJE_QUITA_ID, T_PORCENTAJE_QUITA_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_T_PORCENTAJE_QUITA_CONV where T_PORCENTAJE_QUITA_ID = 0) = 0) then
	insert into D_PRC_T_PORCENTAJE_QUITA_CONV (T_PORCENTAJE_QUITA_ID, T_PORCENTAJE_QUITA_DESC) values (0 ,'0%-30%');
end if;
if ((select count(*) from D_PRC_T_PORCENTAJE_QUITA_CONV where T_PORCENTAJE_QUITA_ID = 1) = 0) then
	insert into D_PRC_T_PORCENTAJE_QUITA_CONV (T_PORCENTAJE_QUITA_ID, T_PORCENTAJE_QUITA_DESC) values (1,'31%-50%');
end if;
if ((select count(*) from D_PRC_T_PORCENTAJE_QUITA_CONV where T_PORCENTAJE_QUITA_ID = 2) = 0) then
	insert into D_PRC_T_PORCENTAJE_QUITA_CONV (T_PORCENTAJE_QUITA_ID, T_PORCENTAJE_QUITA_DESC) values (2,'> 50%');
end if;



-- ----------------------------------------------------------------------------------------------
--                D_PRC_GARANTIA_CONCURSO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_GARANTIA_CONCURSO where GARANTIA_CONCURSO_ID = -1) = 0) then
	insert into D_PRC_GARANTIA_CONCURSO (GARANTIA_CONCURSO_ID, GARANTIA_CONCURSO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_GARANTIA_CONCURSO where GARANTIA_CONCURSO_ID = 0) = 0) then
	insert into D_PRC_GARANTIA_CONCURSO (GARANTIA_CONCURSO_ID, GARANTIA_CONCURSO_DESC) values (0 ,'Garantía Personal');
end if;
if ((select count(*) from D_PRC_GARANTIA_CONCURSO where GARANTIA_CONCURSO_ID = 1) = 0) then
	insert into D_PRC_GARANTIA_CONCURSO (GARANTIA_CONCURSO_ID, GARANTIA_CONCURSO_DESC) values (1,'Garantía Real');
end if;

    
-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_CREA_ASU_A_INTERP_DEM
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_CREA_ASU_A_INTERP_DEM where TD_CREA_ASU_A_INTERP_DEM_ID = -1) = 0) then
	insert into D_PRC_TD_CREA_ASU_A_INTERP_DEM (TD_CREA_ASU_A_INTERP_DEM_ID, TD_CREA_ASU_A_INTERP_DEM_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_A_INTERP_DEM where TD_CREA_ASU_A_INTERP_DEM_ID = 0) = 0) then
	insert into D_PRC_TD_CREA_ASU_A_INTERP_DEM (TD_CREA_ASU_A_INTERP_DEM_ID, TD_CREA_ASU_A_INTERP_DEM_DESC) values (0 ,'0-10 Días');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_A_INTERP_DEM where TD_CREA_ASU_A_INTERP_DEM_ID = 1) = 0) then
	insert into D_PRC_TD_CREA_ASU_A_INTERP_DEM (TD_CREA_ASU_A_INTERP_DEM_ID, TD_CREA_ASU_A_INTERP_DEM_DESC) values (1,'11-20 Días');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_A_INTERP_DEM where TD_CREA_ASU_A_INTERP_DEM_ID = 2) = 0) then
	insert into D_PRC_TD_CREA_ASU_A_INTERP_DEM (TD_CREA_ASU_A_INTERP_DEM_ID, TD_CREA_ASU_A_INTERP_DEM_DESC) values (2,'21-30 Días');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_A_INTERP_DEM where TD_CREA_ASU_A_INTERP_DEM_ID = 3) = 0) then
	insert into D_PRC_TD_CREA_ASU_A_INTERP_DEM (TD_CREA_ASU_A_INTERP_DEM_ID, TD_CREA_ASU_A_INTERP_DEM_DESC) values (3,'> 30 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_CREACION_ASU_ACEPT
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_CREACION_ASU_ACEPT where TD_CREACION_ASU_ACEPT_ID = -1) = 0) then
	insert into D_PRC_TD_CREACION_ASU_ACEPT (TD_CREACION_ASU_ACEPT_ID, TD_CREACION_ASU_ACEPT_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_CREACION_ASU_ACEPT where TD_CREACION_ASU_ACEPT_ID = 0) = 0) then
	insert into D_PRC_TD_CREACION_ASU_ACEPT (TD_CREACION_ASU_ACEPT_ID, TD_CREACION_ASU_ACEPT_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from D_PRC_TD_CREACION_ASU_ACEPT where TD_CREACION_ASU_ACEPT_ID = 1) = 0) then
	insert into D_PRC_TD_CREACION_ASU_ACEPT (TD_CREACION_ASU_ACEPT_ID, TD_CREACION_ASU_ACEPT_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from D_PRC_TD_CREACION_ASU_ACEPT where TD_CREACION_ASU_ACEPT_ID = 2) = 0) then
	insert into D_PRC_TD_CREACION_ASU_ACEPT (TD_CREACION_ASU_ACEPT_ID, TD_CREACION_ASU_ACEPT_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from D_PRC_TD_CREACION_ASU_ACEPT where TD_CREACION_ASU_ACEPT_ID = 3) = 0) then
	insert into D_PRC_TD_CREACION_ASU_ACEPT (TD_CREACION_ASU_ACEPT_ID, TD_CREACION_ASU_ACEPT_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_CREA_ASU_REC_DOC_ACEP
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_CREA_ASU_REC_DOC_ACEP where TD_CREA_ASU_REC_DOC_ACEP_ID = -1) = 0) then
	insert into D_PRC_TD_CREA_ASU_REC_DOC_ACEP (TD_CREA_ASU_REC_DOC_ACEP_ID, TD_CREA_ASU_REC_DOC_ACEP_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_REC_DOC_ACEP where TD_CREA_ASU_REC_DOC_ACEP_ID = 0) = 0) then
	insert into D_PRC_TD_CREA_ASU_REC_DOC_ACEP (TD_CREA_ASU_REC_DOC_ACEP_ID, TD_CREA_ASU_REC_DOC_ACEP_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_REC_DOC_ACEP where TD_CREA_ASU_REC_DOC_ACEP_ID = 1) = 0) then
	insert into D_PRC_TD_CREA_ASU_REC_DOC_ACEP (TD_CREA_ASU_REC_DOC_ACEP_ID, TD_CREA_ASU_REC_DOC_ACEP_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_REC_DOC_ACEP where TD_CREA_ASU_REC_DOC_ACEP_ID = 2) = 0) then
	insert into D_PRC_TD_CREA_ASU_REC_DOC_ACEP (TD_CREA_ASU_REC_DOC_ACEP_ID, TD_CREA_ASU_REC_DOC_ACEP_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from D_PRC_TD_CREA_ASU_REC_DOC_ACEP where TD_CREA_ASU_REC_DOC_ACEP_ID = 3) = 0) then
	insert into D_PRC_TD_CREA_ASU_REC_DOC_ACEP (TD_CREA_ASU_REC_DOC_ACEP_ID, TD_CREA_ASU_REC_DOC_ACEP_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_REC_DOC_ACEPT_REG_TD
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REG_TD where TD_REC_DOC_ACEPT_REG_TD_ID = -1) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REG_TD (TD_REC_DOC_ACEPT_REG_TD_ID, TD_REC_DOC_ACEPT_REG_TD_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REG_TD where TD_REC_DOC_ACEPT_REG_TD_ID = 0) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REG_TD (TD_REC_DOC_ACEPT_REG_TD_ID, TD_REC_DOC_ACEPT_REG_TD_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REG_TD where TD_REC_DOC_ACEPT_REG_TD_ID = 1) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REG_TD (TD_REC_DOC_ACEPT_REG_TD_ID, TD_REC_DOC_ACEPT_REG_TD_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REG_TD where TD_REC_DOC_ACEPT_REG_TD_ID = 2) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REG_TD (TD_REC_DOC_ACEPT_REG_TD_ID, TD_REC_DOC_ACEPT_REG_TD_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REG_TD where TD_REC_DOC_ACEPT_REG_TD_ID = 3) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REG_TD (TD_REC_DOC_ACEPT_REG_TD_ID, TD_REC_DOC_ACEPT_REG_TD_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_REC_DOC_ACEPT_REC_DC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REC_DC where TD_REC_DOC_ACEPT_REC_DC_ID = -1) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REC_DC (TD_REC_DOC_ACEPT_REC_DC_ID, TD_REC_DOC_ACEPT_REC_DC_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REC_DC where TD_REC_DOC_ACEPT_REC_DC_ID = 0) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REC_DC (TD_REC_DOC_ACEPT_REC_DC_ID, TD_REC_DOC_ACEPT_REC_DC_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REC_DC where TD_REC_DOC_ACEPT_REC_DC_ID = 1) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REC_DC (TD_REC_DOC_ACEPT_REC_DC_ID, TD_REC_DOC_ACEPT_REC_DC_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REC_DC where TD_REC_DOC_ACEPT_REC_DC_ID = 2) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REC_DC (TD_REC_DOC_ACEPT_REC_DC_ID, TD_REC_DOC_ACEPT_REC_DC_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from D_PRC_TD_REC_DOC_ACEPT_REC_DC where TD_REC_DOC_ACEPT_REC_DC_ID = 3) = 0) then
	insert into D_PRC_TD_REC_DOC_ACEPT_REC_DC (TD_REC_DOC_ACEPT_REC_DC_ID, TD_REC_DOC_ACEPT_REC_DC_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_ACEPT_ASU_INTERP_DEM
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_ACEPT_ASU_INTERP_DEM where TD_ACEPT_ASU_INTERP_DEM_ID = -1) = 0) then
	insert into D_PRC_TD_ACEPT_ASU_INTERP_DEM (TD_ACEPT_ASU_INTERP_DEM_ID, TD_ACEPT_ASU_INTERP_DEM_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_ACEPT_ASU_INTERP_DEM where TD_ACEPT_ASU_INTERP_DEM_ID = 0) = 0) then
	insert into D_PRC_TD_ACEPT_ASU_INTERP_DEM (TD_ACEPT_ASU_INTERP_DEM_ID, TD_ACEPT_ASU_INTERP_DEM_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from D_PRC_TD_ACEPT_ASU_INTERP_DEM where TD_ACEPT_ASU_INTERP_DEM_ID = 1) = 0) then
	insert into D_PRC_TD_ACEPT_ASU_INTERP_DEM (TD_ACEPT_ASU_INTERP_DEM_ID, TD_ACEPT_ASU_INTERP_DEM_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from D_PRC_TD_ACEPT_ASU_INTERP_DEM where TD_ACEPT_ASU_INTERP_DEM_ID = 2) = 0) then
	insert into D_PRC_TD_ACEPT_ASU_INTERP_DEM (TD_ACEPT_ASU_INTERP_DEM_ID, TD_ACEPT_ASU_INTERP_DEM_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from D_PRC_TD_ACEPT_ASU_INTERP_DEM where TD_ACEPT_ASU_INTERP_DEM_ID = 3) = 0) then
	insert into D_PRC_TD_ACEPT_ASU_INTERP_DEM (TD_ACEPT_ASU_INTERP_DEM_ID, TD_ACEPT_ASU_INTERP_DEM_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_ID_DECL_RESOL_FIRME
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_ID_DECL_RESOL_FIRME where TD_ID_DECL_RESOL_FIRME_ID = -1) = 0) then
	insert into D_PRC_TD_ID_DECL_RESOL_FIRME (TD_ID_DECL_RESOL_FIRME_ID, TD_ID_DECL_RESOL_FIRME_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_ID_DECL_RESOL_FIRME where TD_ID_DECL_RESOL_FIRME_ID = 0) = 0) then
	insert into D_PRC_TD_ID_DECL_RESOL_FIRME (TD_ID_DECL_RESOL_FIRME_ID, TD_ID_DECL_RESOL_FIRME_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_DECL_RESOL_FIRME where TD_ID_DECL_RESOL_FIRME_ID = 1) = 0) then
	insert into D_PRC_TD_ID_DECL_RESOL_FIRME (TD_ID_DECL_RESOL_FIRME_ID, TD_ID_DECL_RESOL_FIRME_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_DECL_RESOL_FIRME where TD_ID_DECL_RESOL_FIRME_ID = 2) = 0) then
	insert into D_PRC_TD_ID_DECL_RESOL_FIRME (TD_ID_DECL_RESOL_FIRME_ID, TD_ID_DECL_RESOL_FIRME_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_DECL_RESOL_FIRME where TD_ID_DECL_RESOL_FIRME_ID = 3) = 0) then
	insert into D_PRC_TD_ID_DECL_RESOL_FIRME (TD_ID_DECL_RESOL_FIRME_ID, TD_ID_DECL_RESOL_FIRME_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_DECL_RESOL_FIRME where TD_ID_DECL_RESOL_FIRME_ID = 4) = 0) then
	insert into D_PRC_TD_ID_DECL_RESOL_FIRME (TD_ID_DECL_RESOL_FIRME_ID, TD_ID_DECL_RESOL_FIRME_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_DECL_RESOL_FIRME where TD_ID_DECL_RESOL_FIRME_ID = 5) = 0) then
	insert into D_PRC_TD_ID_DECL_RESOL_FIRME (TD_ID_DECL_RESOL_FIRME_ID, TD_ID_DECL_RESOL_FIRME_DESC) values (5,'> 150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_ID_ORD_INI_APREMIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_ID_ORD_INI_APREMIO where TD_ID_ORD_INI_APREMIO_ID = -1) = 0) then
	insert into D_PRC_TD_ID_ORD_INI_APREMIO (TD_ID_ORD_INI_APREMIO_ID, TD_ID_ORD_INI_APREMIO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_ID_ORD_INI_APREMIO where TD_ID_ORD_INI_APREMIO_ID = 0) = 0) then
	insert into D_PRC_TD_ID_ORD_INI_APREMIO (TD_ID_ORD_INI_APREMIO_ID, TD_ID_ORD_INI_APREMIO_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_ORD_INI_APREMIO where TD_ID_ORD_INI_APREMIO_ID = 1) = 0) then
	insert into D_PRC_TD_ID_ORD_INI_APREMIO (TD_ID_ORD_INI_APREMIO_ID, TD_ID_ORD_INI_APREMIO_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_ORD_INI_APREMIO where TD_ID_ORD_INI_APREMIO_ID = 2) = 0) then
	insert into D_PRC_TD_ID_ORD_INI_APREMIO (TD_ID_ORD_INI_APREMIO_ID, TD_ID_ORD_INI_APREMIO_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_ORD_INI_APREMIO where TD_ID_ORD_INI_APREMIO_ID = 3) = 0) then
	insert into D_PRC_TD_ID_ORD_INI_APREMIO (TD_ID_ORD_INI_APREMIO_ID, TD_ID_ORD_INI_APREMIO_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_ORD_INI_APREMIO where TD_ID_ORD_INI_APREMIO_ID = 4) = 0) then
	insert into D_PRC_TD_ID_ORD_INI_APREMIO (TD_ID_ORD_INI_APREMIO_ID, TD_ID_ORD_INI_APREMIO_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_ORD_INI_APREMIO where TD_ID_ORD_INI_APREMIO_ID = 5) = 0) then
	insert into D_PRC_TD_ID_ORD_INI_APREMIO (TD_ID_ORD_INI_APREMIO_ID, TD_ID_ORD_INI_APREMIO_DESC) values (5,'> 150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_ID_HIP_SUBASTA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_ID_HIP_SUBASTA where TD_ID_HIP_SUBASTA_ID = -1) = 0) then
	insert into D_PRC_TD_ID_HIP_SUBASTA (TD_ID_HIP_SUBASTA_ID, TD_ID_HIP_SUBASTA_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_ID_HIP_SUBASTA where TD_ID_HIP_SUBASTA_ID = 0) = 0) then
	insert into D_PRC_TD_ID_HIP_SUBASTA (TD_ID_HIP_SUBASTA_ID, TD_ID_HIP_SUBASTA_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_HIP_SUBASTA where TD_ID_HIP_SUBASTA_ID = 1) = 0) then
	insert into D_PRC_TD_ID_HIP_SUBASTA (TD_ID_HIP_SUBASTA_ID, TD_ID_HIP_SUBASTA_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_HIP_SUBASTA where TD_ID_HIP_SUBASTA_ID = 2) = 0) then
	insert into D_PRC_TD_ID_HIP_SUBASTA (TD_ID_HIP_SUBASTA_ID, TD_ID_HIP_SUBASTA_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_HIP_SUBASTA where TD_ID_HIP_SUBASTA_ID = 3) = 0) then
	insert into D_PRC_TD_ID_HIP_SUBASTA (TD_ID_HIP_SUBASTA_ID, TD_ID_HIP_SUBASTA_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_HIP_SUBASTA where TD_ID_HIP_SUBASTA_ID = 4) = 0) then
	insert into D_PRC_TD_ID_HIP_SUBASTA (TD_ID_HIP_SUBASTA_ID, TD_ID_HIP_SUBASTA_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_HIP_SUBASTA where TD_ID_HIP_SUBASTA_ID = 5) = 0) then
	insert into D_PRC_TD_ID_HIP_SUBASTA (TD_ID_HIP_SUBASTA_ID, TD_ID_HIP_SUBASTA_DESC) values (5,'> 150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_SUB_SOL_SUB_CEL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_SUB_SOL_SUB_CEL where TD_SUB_SOL_SUB_CEL_ID = -1) = 0) then
	insert into D_PRC_TD_SUB_SOL_SUB_CEL (TD_SUB_SOL_SUB_CEL_ID, TD_SUB_SOL_SUB_CEL_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_SUB_SOL_SUB_CEL where TD_SUB_SOL_SUB_CEL_ID = 0) = 0) then
	insert into D_PRC_TD_SUB_SOL_SUB_CEL (TD_SUB_SOL_SUB_CEL_ID, TD_SUB_SOL_SUB_CEL_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from D_PRC_TD_SUB_SOL_SUB_CEL where TD_SUB_SOL_SUB_CEL_ID = 1) = 0) then
	insert into D_PRC_TD_SUB_SOL_SUB_CEL (TD_SUB_SOL_SUB_CEL_ID, TD_SUB_SOL_SUB_CEL_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from D_PRC_TD_SUB_SOL_SUB_CEL where TD_SUB_SOL_SUB_CEL_ID = 2) = 0) then
	insert into D_PRC_TD_SUB_SOL_SUB_CEL (TD_SUB_SOL_SUB_CEL_ID, TD_SUB_SOL_SUB_CEL_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from D_PRC_TD_SUB_SOL_SUB_CEL where TD_SUB_SOL_SUB_CEL_ID = 3) = 0) then
	insert into D_PRC_TD_SUB_SOL_SUB_CEL (TD_SUB_SOL_SUB_CEL_ID, TD_SUB_SOL_SUB_CEL_DESC) values (3,'> 90 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_SUB_CEL_CESION_REMATE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_SUB_CEL_CESION_REMATE where TD_SUB_CEL_CESION_REMATE_ID = -1) = 0) then
	insert into D_PRC_TD_SUB_CEL_CESION_REMATE (TD_SUB_CEL_CESION_REMATE_ID, TD_SUB_CEL_CESION_REMATE_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_SUB_CEL_CESION_REMATE where TD_SUB_CEL_CESION_REMATE_ID = 0) = 0) then
	insert into D_PRC_TD_SUB_CEL_CESION_REMATE (TD_SUB_CEL_CESION_REMATE_ID, TD_SUB_CEL_CESION_REMATE_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from D_PRC_TD_SUB_CEL_CESION_REMATE where TD_SUB_CEL_CESION_REMATE_ID = 1) = 0) then
	insert into D_PRC_TD_SUB_CEL_CESION_REMATE (TD_SUB_CEL_CESION_REMATE_ID, TD_SUB_CEL_CESION_REMATE_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from D_PRC_TD_SUB_CEL_CESION_REMATE where TD_SUB_CEL_CESION_REMATE_ID = 2) = 0) then
	insert into D_PRC_TD_SUB_CEL_CESION_REMATE (TD_SUB_CEL_CESION_REMATE_ID, TD_SUB_CEL_CESION_REMATE_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from D_PRC_TD_SUB_CEL_CESION_REMATE where TD_SUB_CEL_CESION_REMATE_ID = 3) = 0) then
	insert into D_PRC_TD_SUB_CEL_CESION_REMATE (TD_SUB_CEL_CESION_REMATE_ID, TD_SUB_CEL_CESION_REMATE_DESC) values (3,'> 90 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_FASE_SUBASTA_HIPOTECARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = -1) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 0) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (0 ,'Interposición Demanda');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 1) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (1,'Demanda Presentada');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 2) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (2,'Subasta Solicitada');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 3) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (3,'Subasta Señalada');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 4) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (4,'Subasta Celebrada: Pendiente Cesión de Remate');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 5) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (5,'Subasta Celebrada: Con Cesión de Remate');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 6) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (6,'Subasta Celebrada: Pendiente Adjudicación');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 7) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (7,'Subasta Celebrada: Pendiente Posesión');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 8) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (8,'Subasta Celebrada: Posesión Realizada');
end if;
if ((select count(*) from D_PRC_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 9) = 0) then
	insert into D_PRC_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (9,'Otros');
end if;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_FASE_HIP
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_FASE_HIP where ULT_TAR_FASE_HIP_ID = -2) = 0) then
	insert into D_PRC_ULT_TAR_FASE_HIP (ULT_TAR_FASE_HIP_ID, ULT_TAR_FASE_HIP_DESC) values (-2 ,'Ninguna Tarea Asociada');
end if;

if ((select count(*) from D_PRC_ULT_TAR_FASE_HIP where ULT_TAR_FASE_HIP_ID = -1) = 0) then
	insert into D_PRC_ULT_TAR_FASE_HIP (ULT_TAR_FASE_HIP_ID, ULT_TAR_FASE_HIP_DESC) values (-1, 'Desconocido');
end if;

insert into D_PRC_ULT_TAR_FASE_HIP (ULT_TAR_FASE_HIP_ID, ULT_TAR_FASE_HIP_DESC) 
select TAP_ID, TAP_DESCRIPCION FROM bi_cdd_bng_datastage.TAP_TAREA_PROCEDIMIENTO;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_TD_ID_MON_DECRETO_FIN
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TD_ID_MON_DECRETO_FIN where TD_ID_MON_DECRETO_FIN_ID = -1) = 0) then
	insert into D_PRC_TD_ID_MON_DECRETO_FIN (TD_ID_MON_DECRETO_FIN_ID, TD_ID_MON_DECRETO_FIN_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from D_PRC_TD_ID_MON_DECRETO_FIN where TD_ID_MON_DECRETO_FIN_ID = 0) = 0) then
	insert into D_PRC_TD_ID_MON_DECRETO_FIN (TD_ID_MON_DECRETO_FIN_ID, TD_ID_MON_DECRETO_FIN_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_MON_DECRETO_FIN where TD_ID_MON_DECRETO_FIN_ID = 1) = 0) then
	insert into D_PRC_TD_ID_MON_DECRETO_FIN (TD_ID_MON_DECRETO_FIN_ID, TD_ID_MON_DECRETO_FIN_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_MON_DECRETO_FIN where TD_ID_MON_DECRETO_FIN_ID = 2) = 0) then
	insert into D_PRC_TD_ID_MON_DECRETO_FIN (TD_ID_MON_DECRETO_FIN_ID, TD_ID_MON_DECRETO_FIN_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_MON_DECRETO_FIN where TD_ID_MON_DECRETO_FIN_ID = 3) = 0) then
	insert into D_PRC_TD_ID_MON_DECRETO_FIN (TD_ID_MON_DECRETO_FIN_ID, TD_ID_MON_DECRETO_FIN_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_MON_DECRETO_FIN where TD_ID_MON_DECRETO_FIN_ID = 4) = 0) then
	insert into D_PRC_TD_ID_MON_DECRETO_FIN (TD_ID_MON_DECRETO_FIN_ID, TD_ID_MON_DECRETO_FIN_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from D_PRC_TD_ID_MON_DECRETO_FIN where TD_ID_MON_DECRETO_FIN_ID = 5) = 0) then
	insert into D_PRC_TD_ID_MON_DECRETO_FIN (TD_ID_MON_DECRETO_FIN_ID, TD_ID_MON_DECRETO_FIN_DESC) values (5,'>150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                D_PRC_F_SUBASTA_EJEC_NOTARIAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = -1) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 0) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (0 ,'Interposición Demanda');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 1) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (1 ,'Demanda Presentada');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 2) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (2,'Subasta Solicitada');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 3) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (3,'Subasta Señalada');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 4) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (4,'Subasta Celebrada: Pendiente Cesión de remate');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 5) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (5,'Subasta Celebrada: Con Cesión de Remate');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 6) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (6,'Subasta Celebrada: Pendiente Adjudicación');
end if;
if ((select count(*) from D_PRC_F_SUBASTA_EJEC_NOTARIAL where F_SUBASTA_EJEC_NOTARIAL_ID = 7) = 0) then
	insert into D_PRC_F_SUBASTA_EJEC_NOTARIAL (F_SUBASTA_EJEC_NOTARIAL_ID, F_SUBASTA_EJEC_NOTARIAL_DESC) values (7,'Otros');
end if;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_CNT_GARANTIA_REAL_ASOC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_CNT_GARANTIA_REAL_ASOC where CNT_GARANTIA_REAL_ASOC_ID = -1) = 0) then
	insert into D_PRC_CNT_GARANTIA_REAL_ASOC (CNT_GARANTIA_REAL_ASOC_ID, CNT_GARANTIA_REAL_ASOC_DESC) values (-1, 'Desconocido');
end if;
if ((select count(*) from D_PRC_CNT_GARANTIA_REAL_ASOC where CNT_GARANTIA_REAL_ASOC_ID = 0) = 0) then
	insert into D_PRC_CNT_GARANTIA_REAL_ASOC (CNT_GARANTIA_REAL_ASOC_ID, CNT_GARANTIA_REAL_ASOC_DESC) values (0, 'Contrato Garantía Real No Asociado');
end if;
if ((select count(*) from D_PRC_CNT_GARANTIA_REAL_ASOC where CNT_GARANTIA_REAL_ASOC_ID = 1) = 0) then
	insert into D_PRC_CNT_GARANTIA_REAL_ASOC (CNT_GARANTIA_REAL_ASOC_ID, CNT_GARANTIA_REAL_ASOC_DESC) values (1, 'Contrato Garantía Real Asociado');
end if;


-- ----------------------------------------------------------------------------------------------
--                                 D_PRC_COBRO_TIPO_DET
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = -1) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (-1 ,'Desconocido', -1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 50) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (50 ,'Liquidación Gastos', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 89) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (89, 'Entregas A Cuentas IDLs', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 90) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (90, 'Entrega Adjudicaciones Bienes', 2);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 91) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (91, 'Ingresos A Cuenta Litigio', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 92) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (92, 'Ingresos Cancelación', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 93) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (93, 'Ingresos Cancelación', 3);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 94) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (94, 'Cancelación Adj. De Bienes', 2);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 95) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (95, 'Cancelación Con Quita', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 96) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (96, 'Cancelación Con Condonación', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 97) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (97, 'Cancelación Con Insolvencia', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 98) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (98, 'Cancelación Por Pago Judicial', 1);
end if;
if ((select count(*) from D_PRC_COBRO_TIPO_DET where TIPO_COBRO_DETALLE_ID = 99) = 0) then
	insert into D_PRC_COBRO_TIPO_DET (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (99, 'Enervación', 1);
end if;


-- ----------------------------------------------------------------------------------------------
--                                 D_PRC_COBRO_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_COBRO_TIPO where TIPO_COBRO_ID = -1) = 0) then
	insert into D_PRC_COBRO_TIPO (TIPO_COBRO_ID, TIPO_COBRO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_COBRO_TIPO where TIPO_COBRO_ID = 1) = 0) then
	insert into D_PRC_COBRO_TIPO (TIPO_COBRO_ID, TIPO_COBRO_DESC) values (1 ,'Cash');
end if;
if ((select count(*) from D_PRC_COBRO_TIPO where TIPO_COBRO_ID = 2) = 0) then
	insert into D_PRC_COBRO_TIPO (TIPO_COBRO_ID, TIPO_COBRO_DESC) values (2, 'Adjudicaciones');
end if;
if ((select count(*) from D_PRC_COBRO_TIPO where TIPO_COBRO_ID = 3) = 0) then
	insert into D_PRC_COBRO_TIPO (TIPO_COBRO_ID, TIPO_COBRO_DESC) values (3, 'Refinanciaciones');
end if;


-- ----------------------------------------------------------------------------------------------
--                                 D_PRC_ACT_ESTIMACIONES
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ACT_ESTIMACIONES where ACT_ESTIMACIONES_ID = -1) = 0) then
	insert into D_PRC_ACT_ESTIMACIONES (ACT_ESTIMACIONES_ID, ACT_ESTIMACIONES_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from D_PRC_ACT_ESTIMACIONES where ACT_ESTIMACIONES_ID = 0) = 0) then
	insert into D_PRC_ACT_ESTIMACIONES (ACT_ESTIMACIONES_ID, ACT_ESTIMACIONES_DESC) values (0 ,'No Actualizada En Último Semestre');
end if;
if ((select count(*) from D_PRC_ACT_ESTIMACIONES where ACT_ESTIMACIONES_ID = 1) = 0) then
	insert into D_PRC_ACT_ESTIMACIONES (ACT_ESTIMACIONES_ID, ACT_ESTIMACIONES_DESC) values (1, 'Actualizada En Último Semestre');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_CARTERA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_CARTERA where CARTERA_PROCEDIMIENTO_ID = -1) = 0) then
	insert into D_PRC_CARTERA (CARTERA_PROCEDIMIENTO_ID, CARTERA_PROCEDIMIENTO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from D_PRC_CARTERA where CARTERA_PROCEDIMIENTO_ID = 0) = 0) then
	insert into D_PRC_CARTERA (CARTERA_PROCEDIMIENTO_ID, CARTERA_PROCEDIMIENTO_DESC) values (0 ,'NCG BANCO, S.A');
end if;

if ((select count(*) from D_PRC_CARTERA where CARTERA_PROCEDIMIENTO_ID = 1) = 0) then
	insert into D_PRC_CARTERA (CARTERA_PROCEDIMIENTO_ID, CARTERA_PROCEDIMIENTO_DESC) values (1 ,'SAREB');
end if;

if ((select count(*) from D_PRC_CARTERA where CARTERA_PROCEDIMIENTO_ID = 2) = 0) then
	insert into D_PRC_CARTERA (CARTERA_PROCEDIMIENTO_ID, CARTERA_PROCEDIMIENTO_DESC) values (2 ,'Compartida');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_TITULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TITULAR where TITULAR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into D_PRC_TITULAR (TITULAR_PROCEDIMIENTO_ID, TITULAR_PROCEDIMIENTO_DESC, DOCUMENTO_ID, NOMBRE, APELLIDO_1, APELLIDO_2) values (-1 , -1, 'Desconocido', 'Desconocido', 'Desconocido', 'Desconocido');
end if;

-- Insert del primer titular del contrato de pase
insert into D_PRC_TITULAR (TITULAR_PROCEDIMIENTO_ID, TITULAR_PROCEDIMIENTO_DESC, DOCUMENTO_ID, NOMBRE, APELLIDO_1, APELLIDO_2)
select p.PER_ID, 
       PER_COD_CLIENTE_ENTIDAD, 
       coalesce(PER_DOC_ID, 'Desconocido'), 
       coalesce(PER_NOMBRE, 'Desconocido'), 
       coalesce(PER_APELLIDO1, 'Desconocido'), 
       coalesce(PER_APELLIDO2, 'Desconocido')
from bi_cdd_bng_datastage.PER_PERSONAS p
join bi_cdd_bng_datastage.CPE_CONTRATOS_PERSONAS cpe on p.PER_ID = cpe.PER_ID
join bi_cdd_bng_datastage.CEX_CONTRATOS_EXPEDIENTE cex on cpe.CNT_ID = cex.CNT_ID
where DD_TIN_ID = 1 and CPE_ORDEN = 1 and cex.CEX_PASE = 1
group by p.PER_ID;
 */

-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_FIN_DESC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_FIN_DESC where ULT_TAR_FIN_DESC_ID = -2) = 0) then
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 1);
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 2);
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 3);
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 4);
end if;

if ((select count(*) from D_PRC_ULT_TAR_FIN_DESC where ULT_TAR_FIN_DESC_ID = -1) = 0) then
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 1);
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 2);
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 3);
    insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 4);
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc, entidad_cedente;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULT_TAR_FIN_DESC_ID) from D_PRC_ULT_TAR_FIN_DESC) +1;
insert into D_PRC_ULT_TAR_FIN_DESC (ULT_TAR_FIN_DESC_ID, ULT_TAR_FIN_DESC_DESC, ENTIDAD_CEDENTE_ID)
values (max_id,tarea_desc, entidad_cedente);

end loop;
close c_tarea_desc;

UPDATE D_PRC_ULT_TAR_FIN_DESC t1 ,tareas_proc_aux t2
SET t1.orden_tarea=t2.orden_tarea
where t1.ULT_TAR_FIN_DESC_DESC=t2.tarea;

update bi_cdd_dwh.D_PRC_ULT_TAR_FIN_DESC t1
SET t1.orden_tarea=NULL
WHERE t1.orden_tarea =0;

commit;
-- ----------------------------------------------------------------------------------------------
--                      D_PRC_ULT_TAR_PEND_FILTR_DESC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_ULT_TAR_PEND_FILTR_DESC where ULT_TAR_PEND_FILTR_DESC_ID = -2) = 0) then
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 1);
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 2);
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 3);
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Ninguna Tarea Asociada', 4);
end if;

if ((select count(*) from D_PRC_ULT_TAR_PEND_FILTR_DESC where ULT_TAR_PEND_FILTR_DESC_ID = -1) = 0) then
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 1);
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 2);
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 3);
    insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', 4);
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc, entidad_cedente;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULT_TAR_PEND_FILTR_DESC_ID) from D_PRC_ULT_TAR_PEND_FILTR_DESC) +1;
insert into D_PRC_ULT_TAR_PEND_FILTR_DESC (ULT_TAR_PEND_FILTR_DESC_ID, ULT_TAR_PEND_FILTR_DESC, ENTIDAD_CEDENTE_ID)
values (max_id,tarea_desc, entidad_cedente);

end loop;
close c_tarea_desc;

UPDATE D_PRC_ULT_TAR_PEND_FILTR_DESC t1 ,tareas_proc_aux t2
SET t1.orden_tarea=t2.orden_tarea
where t1.ULT_TAR_PEND_FILTR_DESC=t2.tarea;

update bi_cdd_dwh.D_PRC_ULT_TAR_PEND_FILTR_DESC t1
SET t1.orden_tarea=NULL
WHERE t1.orden_tarea =0;
																
-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_JUZGADO_CONEXP
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_JUZGADO_CONEXP where JUZGADO_ID = -1) = 0) then
	insert into D_PRC_JUZGADO_CONEXP (JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, -1);
	insert into D_PRC_JUZGADO_CONEXP (JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, 1);
	insert into D_PRC_JUZGADO_CONEXP (JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, 2);
	insert into D_PRC_JUZGADO_CONEXP (JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, 3);
	insert into D_PRC_JUZGADO_CONEXP (JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, 4);
end if;

 insert into D_PRC_JUZGADO_CONEXP(JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID)
    select distinct juz.JUZ_ID, juz.JUZ_DESCRIPCION, juz.PLA_ID, ccx.ENTIDAD_CEDENTE_ID
																    from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																	inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																	inner join bi_cdd_conexp_datastage.PLA_PLAZAS pla on pla.pla_id = dej.pla_id
																	inner join bi_cdd_conexp_datastage.JUZ_JUZGADOS juz on juz.pla_id = pla.pla_id
																	inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																	inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																			ENTIDAD_CEDENTE_ID,
																			case
																			when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																			when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																			when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																			when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																			ELSE ENTIDAD_CEDENTE_DESC
																			end cedente_conexp
																	from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																	) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;







-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_PLAZA_CONEXP
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_PLAZA_CONEXP where PLAZA_ID = -1) = 0) then
	insert into D_PRC_PLAZA_CONEXP (PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
	insert into D_PRC_PLAZA_CONEXP (PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 1);
	insert into D_PRC_PLAZA_CONEXP (PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 2);
	insert into D_PRC_PLAZA_CONEXP (PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 3);
	insert into D_PRC_PLAZA_CONEXP (PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 4);
end if;

 insert into D_PRC_PLAZA_CONEXP(PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct pla.PLA_ID, pla.PLA_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																inner join bi_cdd_conexp_datastage.PLA_PLAZAS pla on pla.pla_id = dej.pla_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;







-- ----------------------------------------------------------------------------------------------
--                                      D_PRC_PROCURADOR_CONEXP
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_PROCURADOR_CONEXP where PROCURADOR_ID = -1) = 0) then
	insert into D_PRC_PROCURADOR_CONEXP (PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
	insert into D_PRC_PROCURADOR_CONEXP (PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 1);
	insert into D_PRC_PROCURADOR_CONEXP (PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 2);
	insert into D_PRC_PROCURADOR_CONEXP (PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 3);
	insert into D_PRC_PROCURADOR_CONEXP (PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 4);
end if;

 insert into D_PRC_PROCURADOR_CONEXP(PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID)
    select distinct ppr.PPR_ID, ppr.PPR_NOMBRE, ccx.ENTIDAD_CEDENTE_ID
    													from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																inner join bi_cdd_conexp_datastage.PPR_PROCURADOR ppr on ppr.ppr_id = dej.ppr_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;
															


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_CON_OPOSICION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_CON_OPOSICION where PRC_CON_OPOSICION_ID = -1) = 0) then
	insert into D_PRC_CON_OPOSICION (PRC_CON_OPOSICION_ID, PRC_CON_OPOSICION_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from D_PRC_CON_OPOSICION where PRC_CON_OPOSICION_ID = 0) = 0) then
	insert into D_PRC_CON_OPOSICION(PRC_CON_OPOSICION_ID, PRC_CON_OPOSICION_DESC) values (0,'Sin Oposición');
end if;

if ((select count(*) from D_PRC_CON_OPOSICION where PRC_CON_OPOSICION_ID = 1) = 0) then
	insert into D_PRC_CON_OPOSICION (PRC_CON_OPOSICION_ID, PRC_CON_OPOSICION_DESC) values (1 ,'Con Oposición');
end if;


-- ----------------------------------------------------------------------------------------------
--                      D_PRC_TAREA_HITO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_PRC_TAREA_HITO where PRC_TAREA_HITO_ID = -1) = 0) then
	insert into D_PRC_TAREA_HITO (PRC_TAREA_HITO_ID, PRC_TAREA_HITO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from D_PRC_TAREA_HITO where PRC_TAREA_HITO_ID = 0) = 0) then
	insert into D_PRC_TAREA_HITO(PRC_TAREA_HITO_ID, PRC_TAREA_HITO_DESC) values (0,'Tarea no hito');
end if;

if ((select count(*) from D_PRC_TAREA_HITO where PRC_TAREA_HITO_ID = 1) = 0) then
	insert into D_PRC_TAREA_HITO (PRC_TAREA_HITO_ID, PRC_TAREA_HITO_DESC) values (1 ,'Tarea hito');
end if;


-- ----------------------------------------------------------------------------------------------
--                          D_PRC_FASE_TAREA_AGR
-- ----------------------------------------------------------------------------------------------
  if ((select count(*) from  D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = -1 )= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (-1 ,'Desconocido',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (-1 ,'Desconocido',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (-1 ,'Desconocido',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (-1 ,'Desconocido',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 1)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (1 ,'P. ABREVIADO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (1 ,'P. ABREVIADO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (1 ,'P. ABREVIADO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (1 ,'P. ABREVIADO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 2)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (2 ,'P. CAMBIARIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (2 ,'P. CAMBIARIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (2 ,'P. CAMBIARIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (2 ,'P. CAMBIARIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 3)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (3 ,'P. EJ. DE TÍTULO JUDICIAL',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (3 ,'P. EJ. DE TÍTULO JUDICIAL',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (3 ,'P. EJ. DE TÍTULO JUDICIAL',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (3 ,'P. EJ. DE TÍTULO JUDICIAL',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 4)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (4 ,'P. EJ. DE TÍTULO NO JUDICIAL',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (4 ,'P. EJ. DE TÍTULO NO JUDICIAL',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (4 ,'P. EJ. DE TÍTULO NO JUDICIAL',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (4 ,'P. EJ. DE TÍTULO NO JUDICIAL',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 5)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (5 ,'P. HIPOTECARIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (5 ,'P. HIPOTECARIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (5 ,'P. HIPOTECARIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (5 ,'P. HIPOTECARIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 6)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (6 ,'P. MONITORIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (6 ,'P. MONITORIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (6 ,'P. MONITORIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (6 ,'P. MONITORIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 7)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (7 ,'P. ORD. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (7 ,'P. ORD. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (7 ,'P. ORD. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (7 ,'P. ORD. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 8)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (8 ,'P. ORD. DE ACCIÓN EN NEGATORIAS DE SERVIDUMBRE',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (8 ,'P. ORD. DE ACCIÓN EN NEGATORIAS DE SERVIDUMBRE',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (8 ,'P. ORD. DE ACCIÓN EN NEGATORIAS DE SERVIDUMBRE',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (8 ,'P. ORD. DE ACCIÓN EN NEGATORIAS DE SERVIDUMBRE',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 9)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (9 ,'P. ORD. DE INTERDICTO DE RECOBRO POSESORIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (9 ,'P. ORD. DE INTERDICTO DE RECOBRO POSESORIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (9 ,'P. ORD. DE INTERDICTO DE RECOBRO POSESORIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (9 ,'P. ORD. DE INTERDICTO DE RECOBRO POSESORIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 10)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (10 ,'P. ORD. DE NULIDAD DE CONTRATO DE ARRENDAMIENTO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (10 ,'P. ORD. DE NULIDAD DE CONTRATO DE ARRENDAMIENTO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (10 ,'P. ORD. DE NULIDAD DE CONTRATO DE ARRENDAMIENTO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (10 ,'P. ORD. DE NULIDAD DE CONTRATO DE ARRENDAMIENTO',4);
  END IF;


  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 11)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (11 ,'P. ORDINARIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (11 ,'P. ORDINARIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (11 ,'P. ORDINARIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (11 ,'P. ORDINARIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 12)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (12 ,'P. ORDINARIO DE ACCIÓN DE DOMINIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (12 ,'P. ORDINARIO DE ACCIÓN DE DOMINIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (12 ,'P. ORDINARIO DE ACCIÓN DE DOMINIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (12 ,'P. ORDINARIO DE ACCIÓN DE DOMINIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 13)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (13 ,'P. ORDINARIO DE ACCIÓN PAULIANA',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (13 ,'P. ORDINARIO DE ACCIÓN PAULIANA',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (13 ,'P. ORDINARIO DE ACCIÓN PAULIANA',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (13 ,'P. ORDINARIO DE ACCIÓN PAULIANA',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 14)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (14 ,'P. ORDINARIO DE DESLINDE O AMOJONAMIENTO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (14 ,'P. ORDINARIO DE DESLINDE O AMOJONAMIENTO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (14 ,'P. ORDINARIO DE DESLINDE O AMOJONAMIENTO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (14 ,'P. ORDINARIO DE DESLINDE O AMOJONAMIENTO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 15)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (15 ,'P. ORDINARIO DE DIVISIÓN DE COSA COMÚN',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (15 ,'P. ORDINARIO DE DIVISIÓN DE COSA COMÚN',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (15 ,'P. ORDINARIO DE DIVISIÓN DE COSA COMÚN',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (15 ,'P. ORDINARIO DE DIVISIÓN DE COSA COMÚN',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 16)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (16 ,'P. SOLICITUD DE CONCURSO NECESARIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (16 ,'P. SOLICITUD DE CONCURSO NECESARIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (16 ,'P. SOLICITUD DE CONCURSO NECESARIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (16 ,'P. SOLICITUD DE CONCURSO NECESARIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 17)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (17 ,'P. VER. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (17 ,'P. VER. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (17 ,'P. VER. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (17 ,'P. VER. DE ACCIÓN CONFIRMATORIA DE SERVIDUMBRE',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 18)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (18 ,'P. VERBAL DE ACCIÓN DE DOMINIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (18 ,'P. VERBAL DE ACCIÓN DE DOMINIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (18 ,'P. VERBAL DE ACCIÓN DE DOMINIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (18 ,'P. VERBAL DE ACCIÓN DE DOMINIO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 19)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (19 ,'P. VERBAL DE DESLINDE O AMOJONAMIENTO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (19 ,'P. VERBAL DE DESLINDE O AMOJONAMIENTO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (19 ,'P. VERBAL DE DESLINDE O AMOJONAMIENTO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (19 ,'P. VERBAL DE DESLINDE O AMOJONAMIENTO',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 20)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (20 ,'T. DE EJECUCIÓN NOTARIAL',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (20 ,'T. DE EJECUCIÓN NOTARIAL',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (20 ,'T. DE EJECUCIÓN NOTARIAL',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (20 ,'T. DE EJECUCIÓN NOTARIAL',4);
  END IF;

  if ((select count(*) from D_PRC_FASE_TAREA_AGR WHERE FASE_TAREA_AGR_ID = 21)= 0) then
 
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (21 ,'P. VERBAL DESDE MONITORIO',1);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (21 ,'P. VERBAL DESDE MONITORIO',2);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (21 ,'P. VERBAL DESDE MONITORIO',3);
    INSERT INTO D_PRC_FASE_TAREA_AGR (FASE_TAREA_AGR_ID, FASE_TAREA_AGR_DESC,ENTIDAD_CEDENTE_ID) VALUES (21 ,'P. VERBAL DESDE MONITORIO',4);
  END IF;


-- ----------------------------------------------------------------------------------------------
--         <<OK>>        D_PRC (Usamos el ID de la primera fase del procedimiento)
-- ----------------------------------------------------------------------------------------------
  insert into D_PRC    
   (PROCEDIMIENTO_ID,
    NUMERO_AUTO,
    ANIO_CODIGO_AUTO,
    ASUNTO_ID,
    JUZGADO_ID,
    TIPO_RECLAMACION_ID,
	ENTIDAD_CEDENTE_ID
   )
	select PRC_ID,
		coalesce(PRC_COD_PROC_EN_JUZGADO, 'Desconocido'),
		coalesce(right(PRC_COD_PROC_EN_JUZGADO, 4), 'Desconocido'),-- Actualizar para recoger los que tienen la fecha en la izquierda (mal introducidos).
		ASU_ID,
		coalesce(DD_JUZ_ID, -1),
		coalesce(DD_TRE_ID, -1),
		1
	from bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS where PRC_PRC_ID is null
	UNION
	select PRC_ID,
		coalesce(PRC_COD_PROC_EN_JUZGADO, 'Desconocido'),
		coalesce(right(PRC_COD_PROC_EN_JUZGADO, 4), 'Desconocido'),-- Actualizar para recoger los que tienen la fecha en la izquierda (mal introducidos).
		ASU_ID,
		coalesce(DD_JUZ_ID, -1),
		coalesce(DD_TRE_ID, -1),
		2
	from bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS where PRC_PRC_ID is null
	UNION
	select PRC_ID,
		coalesce(PRC_COD_PROC_EN_JUZGADO, 'Desconocido'),
		coalesce(right(PRC_COD_PROC_EN_JUZGADO, 4), 'Desconocido'),-- Actualizar para recoger los que tienen la fecha en la izquierda (mal introducidos).
		ASU_ID,
		coalesce(DD_JUZ_ID, -1),
		coalesce(DD_TRE_ID, -1),
		3
	from bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS 
	where PRC_PRC_ID is null	
	UNION
	select PRC_ID,
		coalesce(PRC_COD_PROC_EN_JUZGADO, 'Desconocido'),
		coalesce(right(PRC_COD_PROC_EN_JUZGADO, 4), 'Desconocido'),-- Actualizar para recoger los que tienen la fecha en la izquierda (mal introducidos).
		ASU_ID,
		coalesce(DD_JUZ_ID, -1),
		coalesce(DD_TRE_ID, -1),
		4
	from bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS 
	where PRC_PRC_ID is null		
  ;
  
  
insert into TMP_PRC_GESTOR (PROCEDIMIENTO_ID, GESTOR_PRC_ID, ENTIDAD_CEDENTE_ID)
	select prc.PRC_ID, usu.USU_ID, 1 
	from bi_cdd_bng_datastage.USD_USUARIOS_DESPACHOS usd 
		join bi_cdd_bng_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
		join bi_cdd_bng_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_bng_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
		join bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc on gaa.ASU_ID = prc.ASU_ID
	where tges.DD_TGE_CODIGO = 'GEXT'
	union
	select prc2.PRC_ID, usu2.USU_ID, 2 
	from bi_cdd_bbva_datastage.USD_USUARIOS_DESPACHOS usd2 
		join bi_cdd_bbva_datastage.USU_USUARIOS usu2 on usd2.USU_ID = usu2.USU_ID     
		join bi_cdd_bbva_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa2 on gaa2.USD_ID = usd2.USD_ID
		join bi_cdd_bbva_datastage.DD_TGE_TIPO_GESTOR tges2 on gaa2.DD_TGE_ID = tges2.DD_TGE_ID
		join bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc2 on gaa2.ASU_ID = prc2.ASU_ID
	where tges2.DD_TGE_CODIGO = 'GEXT'
	union
	select prc3.PRC_ID, usu3.USU_ID, 3 
	from bi_cdd_bankia_datastage.USD_USUARIOS_DESPACHOS usd3 
		join bi_cdd_bankia_datastage.USU_USUARIOS usu3 on usd3.USU_ID = usu3.USU_ID     
		join bi_cdd_bankia_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa3 on gaa3.USD_ID = usd3.USD_ID
		join bi_cdd_bankia_datastage.DD_TGE_TIPO_GESTOR tges3 on gaa3.DD_TGE_ID = tges3.DD_TGE_ID
		join bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS prc3 on gaa3.ASU_ID = prc3.ASU_ID
	where tges3.DD_TGE_CODIGO = 'GEXT'	
	union
	select prc4.PRC_ID, usu4.USU_ID, 4 
	from bi_cdd_cajamar_datastage.USD_USUARIOS_DESPACHOS usd4 
		join bi_cdd_cajamar_datastage.USU_USUARIOS usu4 on usd4.USU_ID = usu4.USU_ID     
		join bi_cdd_cajamar_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa4 on gaa4.USD_ID = usd4.USD_ID
		join bi_cdd_cajamar_datastage.DD_TGE_TIPO_GESTOR tges4 on gaa4.DD_TGE_ID = tges4.DD_TGE_ID
		join bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc4 on gaa4.ASU_ID = prc4.ASU_ID
	where tges4.DD_TGE_CODIGO = 'GEXT'		
;

    
insert into TMP_PRC_SUPERVISOR (PROCEDIMIENTO_ID, SUPERVISOR_PRC_ID, ENTIDAD_CEDENTE_ID)
	select prc.PRC_ID, usu.USU_ID, 1
	from bi_cdd_bng_datastage.USD_USUARIOS_DESPACHOS usd 
		join bi_cdd_bng_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
		join bi_cdd_bng_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_bng_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
		join bi_cdd_bng_datastage.PRC_PROCEDIMIENTOS prc on gaa.ASU_ID = prc.ASU_ID
	where tges.DD_TGE_CODIGO = 'SUP'
	union
	select prc2.PRC_ID, usu2.USU_ID, 2 
	from bi_cdd_bbva_datastage.USD_USUARIOS_DESPACHOS usd2 
		join bi_cdd_bbva_datastage.USU_USUARIOS usu2 on usd2.USU_ID = usu2.USU_ID     
		join bi_cdd_bbva_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa2 on gaa2.USD_ID = usd2.USD_ID
		join bi_cdd_bbva_datastage.DD_TGE_TIPO_GESTOR tges2 on gaa2.DD_TGE_ID = tges2.DD_TGE_ID
		join bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS prc2 on gaa2.ASU_ID = prc2.ASU_ID
	where tges2.DD_TGE_CODIGO = 'SUP'
	union
	select prc3.PRC_ID, usu3.USU_ID, 3 
	from bi_cdd_bankia_datastage.USD_USUARIOS_DESPACHOS usd3 
		join bi_cdd_bankia_datastage.USU_USUARIOS usu3 on usd3.USU_ID = usu3.USU_ID     
		join bi_cdd_bankia_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa3 on gaa3.USD_ID = usd3.USD_ID
		join bi_cdd_bankia_datastage.DD_TGE_TIPO_GESTOR tges3 on gaa3.DD_TGE_ID = tges3.DD_TGE_ID
		join bi_cdd_bankia_datastage.PRC_PROCEDIMIENTOS prc3 on gaa3.ASU_ID = prc3.ASU_ID
	where tges3.DD_TGE_CODIGO = 'SUP'
	union
	select prc4.PRC_ID, usu4.USU_ID, 4 
	from bi_cdd_cajamar_datastage.USD_USUARIOS_DESPACHOS usd4
		join bi_cdd_cajamar_datastage.USU_USUARIOS usu4 on usd4.USU_ID = usu4.USU_ID     
		join bi_cdd_cajamar_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa4 on gaa4.USD_ID = usd4.USD_ID
		join bi_cdd_cajamar_datastage.DD_TGE_TIPO_GESTOR tges4 on gaa4.DD_TGE_ID = tges4.DD_TGE_ID
		join bi_cdd_cajamar_datastage.PRC_PROCEDIMIENTOS prc4 on gaa4.ASU_ID = prc4.ASU_ID
	where tges4.DD_TGE_CODIGO = 'SUP'		
;
                    
  update D_PRC dprc set GESTOR_PRC_ID = (
  	select GESTOR_PRC_ID 
  	from TMP_PRC_GESTOR tpg 
  	where dprc.PROCEDIMIENTO_ID =  tpg.PROCEDIMIENTO_ID and dprc.ENTIDAD_CEDENTE_ID = tpg.ENTIDAD_CEDENTE_ID
  );
  
  update D_PRC set GESTOR_PRC_ID = -1 where  GESTOR_PRC_ID is null;
  
  update D_PRC dprc set SUPERVISOR_PRC_ID =(
  	select coalesce(SUPERVISOR_PRC_ID, -1) 
  	from TMP_PRC_SUPERVISOR tps 
  	where dprc.PROCEDIMIENTO_ID = tps.PROCEDIMIENTO_ID and dprc.ENTIDAD_CEDENTE_ID = tps.ENTIDAD_CEDENTE_ID
  );
  
  update D_PRC set SUPERVISOR_PRC_ID = -1 where  SUPERVISOR_PRC_ID is null;

END MY_BLOCK_DIM_PRC
