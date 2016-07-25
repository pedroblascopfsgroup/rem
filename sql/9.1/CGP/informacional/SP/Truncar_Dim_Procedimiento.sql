-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Truncar_Dim_Procedimiento` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Truncar_Dim_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_TRUNC_DIM_PRC:BEGIN

-- ===============================================================================================
-- Autor: Enrique Jiménez, PFS Group
-- Fecha creación: Septiembre 2014
-- Responsable última modificación:María Villanueva, PFS Group
-- Fecha última modificación: 12/11/2015
-- Motivos del cambio: D_PRC_FASE_TAREA_DETALLE y D_PRC_FASE_TAREA
-- Cliente: CDD
--
-- Descripción: Procedimiento almancenado que trunca las tablas de la dimensión Procedimiento.
-- ===============================================================================================

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

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_JUZGADO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_JUZGADO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_PLAZA' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_PLAZA;
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TIPO_RECLAMACION' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TIPO_RECLAMACION;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TIPO_PROCEDIMIENTO_AGR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TIPO_PROCEDIMIENTO_AGR;
end if;		

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TIPO_PROCEDIMIENTO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TIPO_PROCEDIMIENTO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TIPO_PROCEDIMIENTO_DET' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TIPO_PROCEDIMIENTO_DET;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_ACTUAL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_ACTUAL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_ACTUAL_DETALLE' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_ACTUAL_DETALLE;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_ANTERIOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_ANTERIOR;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_ANTERIOR_DETALLE' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_ANTERIOR_DETALLE;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ESTADO_PROCEDIMIENTO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ESTADO_PROCEDIMIENTO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ESTADO_FASE_ACTUAL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ESTADO_FASE_ACTUAL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ESTADO_FASE_ANTERIOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ESTADO_FASE_ANTERIOR;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_CREADA_TIPO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_CREADA_TIPO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_CREADA_TIPO_DET' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_CREADA_TIPO_DET;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_CREADA_DESC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_CREADA_DESC;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_FIN_TIPO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_FIN_TIPO;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_FIN_TIPO_DET' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_FIN_TIPO_DET;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_FIN_DESC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_FIN_DESC;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_ACT_TIPO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_ACT_TIPO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_ACT_TIPO_DET' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_ACT_TIPO_DET;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_ACT_DESC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_ACT_DESC;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_PEND_TIPO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_PEND_TIPO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_PEND_TIPO_DET' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_PEND_TIPO_DET;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_PEND_DESC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_PEND_DESC;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_GESTOR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_GESTOR_EN_RECOVERY' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_GESTOR_EN_RECOVERY;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_SUPERVISOR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_DESPACHO_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_DESPACHO_GESTOR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_DESPACHO_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_DESPACHO_SUPERVISOR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TIPO_DESP_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TIPO_DESP_GESTOR; 
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TIPO_DESPACHO_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TIPO_DESPACHO_SUPERVISOR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ENTIDAD_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ENTIDAD_GESTOR; 
end if;	



select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ENTIDAD_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ENTIDAD_SUPERVISOR; 
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_NIVEL_DESP_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_NIVEL_DESP_GESTOR; 
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_NIVEL_DESP_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_NIVEL_DESP_SUPERVISOR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_OFI_DESP_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_OFI_DESP_GESTOR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_OFI_DESP_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_OFI_DESP_SUPERVISOR;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_PROV_DESP_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_PROV_DESP_GESTOR;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_PROV_DESP_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_PROV_DESP_SUPERVISOR;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ZONA_DESP_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ZONA_DESP_GESTOR;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ZONA_DESP_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ZONA_DESP_SUPERVISOR;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_T_SALDO_TOTAL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_T_SALDO_TOTAL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_T_SALDO_TOTAL_CONCURSO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_T_SALDO_TOTAL_CONCURSO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_ULTIMA_ACTUALIZACION' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_ULTIMA_ACTUALIZACION;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_CONTRATO_VENCIDO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_CONTRATO_VENCIDO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_CNT_VENC_CREACION_ASU' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_CNT_VENC_CREACION_ASU;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_PEND_CUMPL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_PEND_CUMPL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_FIN_CUMPL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_FIN_CUMPL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_AUTO_FC_DIA_ANALISIS' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_AUTO_FC_DIA_ANALISIS;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_AUTO_FC_LIQUIDACION' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_AUTO_FC_LIQUIDACION;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ESTADO_CONVENIO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ESTADO_CONVENIO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_SEGUIMIENTO_CONVENIO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_SEGUIMIENTO_CONVENIO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_T_PORCENTAJE_QUITA_CONV' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_T_PORCENTAJE_QUITA_CONV;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_GARANTIA_CONCURSO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_GARANTIA_CONCURSO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_CREA_ASU_A_INTERP_DEM' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_CREA_ASU_A_INTERP_DEM;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_CREACION_ASU_ACEPT' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_CREACION_ASU_ACEPT;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_ACEPT_ASU_INTERP_DEM' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_ACEPT_ASU_INTERP_DEM;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_CREA_ASU_REC_DOC_ACEP' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_CREA_ASU_REC_DOC_ACEP;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_REC_DOC_ACEPT_REG_TD' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_REC_DOC_ACEPT_REG_TD;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_REC_DOC_ACEPT_REC_DC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_REC_DOC_ACEPT_REC_DC;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_ID_DECL_RESOL_FIRME' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_ID_DECL_RESOL_FIRME;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_ID_ORD_INI_APREMIO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_ID_ORD_INI_APREMIO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_ID_HIP_SUBASTA' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_ID_HIP_SUBASTA;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_SUB_SOL_SUB_CEL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_SUB_SOL_SUB_CEL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_SUB_CEL_CESION_REMATE' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_SUB_CEL_CESION_REMATE;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_SUBASTA_HIPOTECARIO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_SUBASTA_HIPOTECARIO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_FASE_HIP' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_FASE_HIP;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TD_ID_MON_DECRETO_FIN' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TD_ID_MON_DECRETO_FIN;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_CNT_GARANTIA_REAL_ASOC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_CNT_GARANTIA_REAL_ASOC;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_COBRO_TIPO_DET' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_COBRO_TIPO_DET;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_COBRO_TIPO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_COBRO_TIPO;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ACT_ESTIMACIONES' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ACT_ESTIMACIONES;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_CARTERA' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_CARTERA;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_F_SUBASTA_EJEC_NOTARIAL' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_F_SUBASTA_EJEC_NOTARIAL;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TITULAR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TITULAR;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_PROCURADOR_CONEXP' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_PROCURADOR_CONEXP;
end if;	


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_JUZGADO_CONEXP' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_JUZGADO_CONEXP;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_PLAZA_CONEXP' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_PLAZA_CONEXP;
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_CON_OPOSICION' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_CON_OPOSICION;
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_TAREA_HITO' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_TAREA_HITO;
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_ULT_TAR_PEND_FILTR_DESC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_ULT_TAR_PEND_FILTR_DESC;
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC;
end if;	
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_GESTOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE TMP_PRC_GESTOR;
end if;	

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TMP_PRC_SUPERVISOR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE TMP_PRC_SUPERVISOR;
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_TAREA_DETALLE' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_TAREA_DETALLE;
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_TAREA' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_TAREA;
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'D_PRC_FASE_TAREA_AGR' and table_schema = 'bi_cdd_dwh';
if (HAY_TABLA > 0) then
	TRUNCATE TABLE D_PRC_FASE_TAREA_AGR;
end if;

  
END MY_BLOCK_TRUNC_DIM_PRC
