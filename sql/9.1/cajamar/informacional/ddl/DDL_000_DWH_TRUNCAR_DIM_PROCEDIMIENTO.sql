--/*
--##########################################
--## AUTOR=Pedro S.
--## FECHA_CREACION=20160330
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2314
--## PRODUCTO=NO
--## 
--## Finalidad: Se añade GESTOR_HAYA, CON POSTOR
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
create or replace PROCEDURE TRUNCAR_DIM_PROCEDIMIENTO (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion:Pedro S., PFS Group
-- Fecha ultima modificacion: 22/03/2016
-- Motivos del cambio: Se añade GESTOR_HAYA, CON POSTOR
-- Cliente: Recovery BI CAJAMAR
--
-- Descripcion: Procedimiento almancenado que trunca las tablas de la dimension Procedimiento
-- ===============================================================================================

V_NOMBRE VARCHAR2(50) := 'TRUNCAR_DIM_PROCEDIMIENTO';
V_SQL VARCHAR2(16000);


BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_JUZGADO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_PLAZA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_RECLAMACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_PROCEDIMIENTO_AGR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_PROCEDIMIENTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_PROCEDIMIENTO_DET'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_FASE_ACTUAL_AGR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_FASE_ACTUAL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_FASE_ACTUAL_DETALLE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_FASE_ANTERIOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_FASE_ANTERIOR_DETALLE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_PROCEDIMIENTO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_FASE_ACTUAL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_FASE_ANTERIOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_CREADA_TIPO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_CREADA_TIPO_DET'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_CREADA_DESC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_FIN_TIPO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_FIN_TIPO_DET'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_FIN_DESC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_ACT_TIPO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_ACT_TIPO_DET'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_ACT_DESC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_PEND_TIPO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_PEND_TIPO_DET'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_PEND_DESC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_DESPACHO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error; 
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_GESTOR_PRECONTENCIOSO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_GESTOR_EN_RECOVERY'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ENTIDAD_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_NIVEL_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_OFI_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_PROV_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_DESP_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_DESPACHO_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_DESPACHO_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ENTIDAD_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_NIVEL_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_OFI_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_PROV_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_DESP_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_PEND_CUMPL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_FIN_CUMPL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_CNT_GARANTIA_REAL_ASOC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_COBRO_TIPO_DET'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_COBRO_TIPO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ACT_ESTIMACIONES'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_CARTERA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TITULAR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_0'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_1'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_2'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_3'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_4'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_5'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_6'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_7'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_8'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ZONA_NIVEL_9'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_T_SALDO_TOTAL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_T_SALDO_RECUPERACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_T_SALDO_TOTAL_CONCURSO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_ULTIMA_ACTUALIZACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_CONTRATO_VENCIDO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_CNT_VENC_CREACION_ASU'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_CREA_ASU_A_INTERP_DEM'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_CREACION_ASU_ACEPT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_ACEPT_ASU_INTERP_DEM'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_CREA_ASU_REC_DOC_ACEP'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_REC_DOC_ACEPT_REG_TD'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_REC_DOC_ACEPT_REC_DC'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_AUTO_FC_DIA_ANALISIS'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_AUTO_FC_LIQUIDACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_CONVENIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_SEGUIMIENTO_CONVENIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_T_PORCENTAJE_QUITA_CONV'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_GARANTIA_CONCURSO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_ID_DECL_RESOL_FIRME'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_ID_ORD_INI_APREMIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_ID_HIP_SUBASTA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_SUB_SOL_SUB_CEL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_SUB_CEL_CESION_REMATE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_FASE_SUBASTA_HIPOTECARIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ULT_TAR_FASE_HIP'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_ID_MON_DECRETO_FIN'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_F_SUBASTA_EJEC_NOTARIAL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_PRC_SUPERVISOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_PARALIZADO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_MOTIVO_PARALIZACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_CEL_ADJUDICACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TD_RECEP_DECRE_ADJUDICA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_ACUERDO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_ACUERDO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_GESTOR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_FASE_SUBASTA_CONCURSAL'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_PROPIETARIO'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_PRE'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TIPO_PRE_AGR'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_PREPARACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_PREPARACION'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_BUROFAX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT error;
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_RESULTADO_BUROFAX'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_BUROFAX_ENVIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_RESULT_BUROFAX_ENVIO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_DOCUMENTO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_DOCUMENTO'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_RESULTADO_SOLICITUD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_ACTOR_SOLICITUD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_USUARIO_SOLICITUD'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_LIQUIDACION_ESTADO'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_MOTIVO_CANCELACION'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_MOTIVO_SUBSANACION'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TRAMO_SUBSANACION'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TRAMO_AVANCE_DOCUMENTO'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TRAMO_AVANCE_LIQUIDACION'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TRAMO_AVANCE_BUROFAX'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_DOCUMENTO_PER_ANT'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ESTADO_LIQ_PER_ANT'', '''', :O_ERROR_STATUS); END;'; 
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_PROP_SAREB'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_ENT_CEDENTE'', '''', :O_ERROR_STATUS); END;';  
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_TIPO_SOL_PREVISTA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_PROCURADOR'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_GESTOR_HAYA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_DESPACHO_GESTOR_HAYA'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''D_PRC_CON_POSTORES'', '''', :O_ERROR_STATUS); END;';
 execute immediate V_SQL USING OUT error;
  commit;
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;



END TRUNCAR_DIM_PROCEDIMIENTO;
/
EXIT


