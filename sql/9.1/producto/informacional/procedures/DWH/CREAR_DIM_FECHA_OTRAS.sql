create or replace PROCEDURE CREAR_DIM_FECHA_OTRAS (error OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Agustin Mompo, PFS Group
-- Fecha creacion: Mayo 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 03/02/2016
-- Motivos del cambio: D_F_LLAMADA
-- Cliente: Recovery BI PRODUCTO
--
-- Descripcion: Procedimiento almancenado que crea las tablas de la dimension Fecha_Otras.
-- ===============================================================================================

-- -------------------------------------------- INDICE -------------------------------------------
-- DIMENSION FECHA_OTRAS
    -- D_F_CARGA_DATOS_ANIO
    -- D_F_CARGA_DATOS_DIA_SEMANA
    -- D_F_CARGA_DATOS_MES
    -- D_F_CARGA_DATOS_MES_ANIO
    -- D_F_CARGA_DATOS_TRIMESTRE
    -- D_F_CARGA_DATOS_DIA
    -- D_F_POS_VENCIDA_ANIO
    -- D_F_POS_VENCIDA_DIA_SEMANA
    -- D_F_POS_VENCIDA_MES
    -- D_F_POS_VENCIDA_MES_ANIO
    -- D_F_POS_VENCIDA_TRIMESTRE
    -- D_F_POS_VENCIDA_DIA
    -- D_F_SALDO_DUDOSO_ANIO
    -- D_F_SALDO_DUDOSO_DIA_SEMANA
    -- D_F_SALDO_DUDOSO_MES
    -- D_F_SALDO_DUDOSO_MES_ANIO
    -- D_F_SALDO_DUDOSO_TRIMESTRE
    -- D_F_SALDO_DUDOSO_DIA
    -- D_F_CREACION_ASUNTO_ANIO
    -- D_F_CREACION_ASUNTO_DIA_SEMANA
    -- D_F_CREACION_ASUNTO_MES
    -- D_F_CREACION_ASUNTO_MES_ANIO
    -- D_F_CREACION_ASUNTO_TRIMESTRE
    -- D_F_CREACION_ASUNTO_DIA
    -- D_F_CREACION_PRC_ANIO
    -- D_F_CREACION_PRC_DIA_SEMANA
    -- D_F_CREACION_PRC_MES
    -- D_F_CREACION_PRC_MES_ANIO
    -- D_F_CREACION_PRC_TRIMESTRE
    -- D_F_CREACION_PRC_DIA
    -- D_F_ULT_TAR_CRE_ANIO
    -- D_F_ULT_TAR_CRE_DIA_SEMANA
    -- D_F_ULT_TAR_CRE_MES
    -- D_F_ULT_TAR_CRE_MES_ANIO
    -- D_F_ULT_TAR_CRE_TRIMESTRE
    -- D_F_ULT_TAR_CRE_DIA
    -- D_F_ULT_TAR_FIN_ANIO
    -- D_F_ULT_TAR_FIN_DIA_SEMANA
    -- D_F_ULT_TAR_FIN_MES
    -- D_F_ULT_TAR_FIN_MES_ANIO
    -- D_F_ULT_TAR_FIN_TRIMESTRE
    -- D_F_ULT_TAR_FIN_DIA
    -- D_F_ULT_TAR_ACT_ANIO
    -- D_F_ULT_TAR_ACT_DIA_SEMANA
    -- D_F_ULT_TAR_ACT_MES
    -- D_F_ULT_TAR_ACT_MES_ANIO
    -- D_F_ULT_TAR_ACT_TRIMESTRE
    -- D_F_ULT_TAR_ACT_DIA
    -- D_F_ULT_TAR_PEN_ANIO
    -- D_F_ULT_TAR_PEN_DIA_SEMANA
    -- D_F_ULT_TAR_PEN_MES
    -- D_F_ULT_TAR_PEN_MES_ANIO
    -- D_F_ULT_TAR_PEN_TRIMESTRE
    -- D_F_ULT_TAR_PEN_DIA
    -- D_F_VA_ULT_TAR_PEN_ANIO
    -- D_F_VA_ULT_TAR_PEN_DIA_SEMANA
    -- D_F_VA_ULT_TAR_PEN_MES
    -- D_F_VA_ULT_TAR_PEN_MES_ANIO
    -- D_F_VA_ULT_TAR_PEN_TRIMESTRE
    -- D_F_VA_ULT_TAR_PEN_DIA
    -- D_F_VA_ULT_TAR_FIN_ANIO
    -- D_F_VA_ULT_TAR_FIN_DIA_SEMANA
    -- D_F_VA_ULT_TAR_FIN_MES
    -- D_F_VA_ULT_TAR_FIN_MES_ANIO
    -- D_F_VA_ULT_TAR_FIN_TRIMESTRE
    -- D_F_VA_ULT_TAR_FIN_DIA
    -- D_F_COBRO_ANIO
    -- D_F_COBRO_DIA_SEMANA
    -- D_F_COBRO_MES
    -- D_F_COBRO_MES_ANIO
    -- D_F_COBRO_TRIMESTRE
    -- D_F_COBRO_DIA
    -- D_F_ACEPTACION_ANIO
    -- D_F_ACEPTACION_DIA_SEMANA
    -- D_F_ACEPTACION_MES
    -- D_F_ACEPTACION_MES_ANIO
    -- D_F_ACEPTACION_TRIMESTRE
    -- D_F_ACEPTACION_DIA
    -- D_F_INTER_DEM_ANIO
    -- D_F_INTER_DEM_DIA_SEMANA
    -- D_F_INTER_DEM_MES
    -- D_F_INTER_DEM_MES_ANIO
    -- D_F_INTER_DEM_TRIMESTRE
    -- D_F_INTER_DEM_DIA
    -- D_F_DECRETO_FIN_ANIO
    -- D_F_DECRETO_FIN_DIA_SEMANA
    -- D_F_DECRETO_FIN_MES
    -- D_F_DECRETO_FIN_MES_ANIO
    -- D_F_DECRETO_FIN_TRIMESTRE
    -- D_F_DECRETO_FIN_DIA
    -- D_F_RESOL_FIRME_ANIO
    -- D_F_RESOL_FIRME_DIA_SEMANA
    -- D_F_RESOL_FIRME_MES
    -- D_F_RESOL_FIRME_MES_ANIO
    -- D_F_RESOL_FIRME_TRIMESTRE
    -- D_F_RESOL_FIRME_DIA
    -- D_F_SUBASTA_ANIO
    -- D_F_SUBASTA_DIA_SEMANA
    -- D_F_SUBASTA_MES
    -- D_F_SUBASTA_MES_ANIO
    -- D_F_SUBASTA_TRIMESTRE
    -- D_F_SUBASTA_DIA
    -- D_F_INICIO_APREMIO_ANIO
    -- D_F_INICIO_APREMIO_DIA_SEMANA
    -- D_F_INICIO_APREMIO_MES
    -- D_F_INICIO_APREMIO_MES_ANIO
    -- D_F_INICIO_APREMIO_TRIMESTRE
    -- D_F_INICIO_APREMIO_DIA
    -- D_F_ESTIMADA_COBRO_ANIO
    -- D_F_ESTIMADA_COBRO_DIA_SEMANA
    -- D_F_ESTIMADA_COBRO_MES
    -- D_F_ESTIMADA_COBRO_MES_ANIO
    -- D_F_ESTIMADA_COBRO_TRIMESTRE
    -- D_F_ESTIMADA_COBRO_DIA
    -- D_F_ULT_EST_ANIO
    -- D_F_ULT_EST_DIA_SEMANA
    -- D_F_ULT_EST_MES
    -- D_F_ULT_EST_MES_ANIO
    -- D_F_ULT_EST_TRIMESTRE
    -- D_F_ULT_EST_DIA
    -- D_F_LIQUIDACION_ANIO
    -- D_F_LIQUIDACION_DIA_SEMANA
    -- D_F_LIQUIDACION_MES
    -- D_F_LIQUIDACION_MES_ANIO
    -- D_F_LIQUIDACION_TRIMESTRE
    -- D_F_LIQUIDACION_DIA
    -- D_F_INSI_FINAL_CRED_ANIO
    -- D_F_INSI_FINAL_CRED_DIA_SEMANA
    -- D_F_SUBINSI_FINAL_CREDASTA_MES
    -- D_F_INSI_FINAL_CRED_MES_ANIO
    -- D_F_INSI_FINAL_CRED_TRIMESTRE
    -- D_F_INSI_FINAL_CRED_DIA
    -- D_F_AUTO_APERT_CONV_ANIO
    -- D_F_AUTO_APERT_CONV_DIA_SEMANA
    -- D_F_AUTO_APERT_CONV_MES
    -- D_F_AUTO_APERT_CONV_MES_ANIO
    -- D_F_AUTO_APERT_CONV_TRIMESTRE
    -- D_F_AUTO_APERT_CONV_DIA
    -- D_F_JUNTA_ACREE_ANIO
    -- D_F_JUNTA_ACREE_DIA_SEMANA
    -- D_F_JUNTA_ACREE_MES
    -- D_F_JUNTA_ACREE_MES_ANIO
    -- D_F_JUNTA_ACREE_TRIMESTRE
    -- D_F_JUNTA_ACREE_DIA
    -- D_F_REG_RESOL_LIQ_ANIO
    -- D_F_REG_RESOL_LIQ_DIA_SEMANA
    -- D_F_REG_RESOL_LIQ_MES
    -- D_F_REG_RESOL_LIQ_MES_ANIO
    -- D_F_REG_RESOL_LIQ_TRIMESTRE
    -- D_F_REG_RESOL_LIQ_DIA
    -- D_F_SUB_EJEC_NOT_ANIO
    -- D_F_SUB_EJEC_NOT_DIA_SEMANA
    -- D_F_SUB_EJEC_NOT_MES
    -- D_F_SUB_EJEC_NOT_MES_ANIO
    -- D_F_SUB_EJEC_NOT_TRIMESTRE
    -- D_F_SUB_EJEC_NOT_DIA
    -- D_F_CREACION_TAREA_ANIO
    -- D_F_CREACION_TAREA_DIA_SEMANA
    -- D_F_CREACION_TAREA_MES
    -- D_F_CREACION_TAREA_MES_ANIO
    -- D_F_CREACION_TAREA_TRIMESTRE
    -- D_F_CREACION_TAREA_DIA
    -- D_F_FIN_TAREA_ANIO
    -- D_F_FIN_TAREA_DIA_SEMANA
    -- D_F_FIN_TAREA_MES
    -- D_F_FIN_TAREA_MES_ANIO
    -- D_F_FIN_TAREA_TRIMESTRE
    -- D_F_FIN_TAREA_DIA
    -- D_F_RECOG_DOC_ACEPT_ANIO
    -- D_F_RECOG_DOC_ACEPT_DIA_SEMANA
    -- D_F_RECOG_DOC_ACEPT_MES
    -- D_F_RECOG_DOC_ACEPT_MES_ANIO
    -- D_F_RECOG_DOC_ACEPT_TRIMESTRE
    -- D_F_RECOG_DOC_ACEPT_DIA
    -- D_F_REG_DEC_ANIO
    -- D_F_REG_DEC_DIA_SEMANA
    -- D_F_REG_DEC_MES
    -- D_F_REG_DEC_MES_ANIO
    -- D_F_REG_DEC_TRIMESTRE
    -- D_F_REG_DEC_DIA
    -- D_F_RECEP_DOC_ANIO
    -- D_F_RECEP_DOC_DIA_SEMANA
    -- D_F_RECEP_DOC_MES
    -- D_F_RECEP_DOC_MES_ANIO
    -- D_F_RECEP_DOC_TRIMESTRE
    -- D_F_RECEP_DOC_DIA
    -- D_F_CONT_LIT_ANIO
    -- D_F_CONT_LIT_DIA_SEMANA
    -- D_F_CONT_LIT_MES
    -- D_F_CONT_LIT_MES_ANIO
    -- D_F_CONT_LIT_TRIMESTRE
    -- D_F_CONT_LIT_DIA
    -- D_F_DPS_ANIO
    -- D_F_DPS_DIA_SEMANA
    -- D_F_DPS_MES
    -- D_F_DPS_MES_ANIO
    -- D_F_DPS_TRIMESTRE
    -- D_F_DPS_DIA
    -- D_F_COMP_PAGO_ANIO
    -- D_F_COMP_PAGO_DIA_SEMANA
    -- D_F_COMP_PAGO_MES
    -- D_F_COMP_PAGO_MES_ANIO
    -- D_F_COMP_PAGO_TRIMESTRE
    -- D_F_COMP_PAGO_DIA
    -- D_F_ALTA_GEST_REC_ANIO
    -- D_F_ALTA_GEST_REC_DIA_SEMANA
    -- D_F_ALTA_GEST_REC_MES
    -- D_F_ALTA_GEST_REC_MES_ANIO
    -- D_F_ALTA_GEST_REC_TRIMESTRE
    -- D_F_ALTA_GEST_REC_DIA
    -- D_F_BAJA_GEST_REC_ANIO
    -- D_F_BAJA_GEST_REC_DIA_SEMANA
    -- D_F_BAJA_GEST_REC_MES
    -- D_F_BAJA_GEST_REC_MES_ANIO
    -- D_F_BAJA_GEST_REC_TRIMESTRE
    -- D_F_BAJA_GEST_REC_DIA
    -- D_F_ACT_RECOBRO_ANIO
    -- D_F_ACT_RECOBRO_DIA_SEMANA
    -- D_F_ACT_RECOBRO_MES
    -- D_F_ACT_RECOBRO_MES_ANIO
    -- D_F_ACT_RECOBRO_TRIMESTRE
    -- D_F_ACT_RECOBRO_DIA
    -- D_F_PAGO_COMP_ANIO
    -- D_F_PAGO_COMP_DIA_SEMANA
    -- D_F_PAGO_COMP_MES
    -- D_F_PAGO_COMP_MES_ANIO
    -- D_F_PAGO_COMP_TRIMESTRE
    -- D_F_PAGO_COMP_DIA
    -- D_F_VENC_TAR_ANIO
    -- D_F_VENC_TAR_DIA_SEMANA
    -- D_F_VENC_TAR_MES
    -- D_F_VENC_TAR_MES_ANIO
    -- D_F_VENC_TAR_TRIMESTRE
    -- D_F_VENC_TAR_DIA
    -- D_F_CESION_REMATE_ANIO
    -- D_F_CESION_REMATE_DIA_SEMANA
    -- D_F_CESION_REMATE_MES
    -- D_F_CESION_REMATE_MES_ANIO
    -- D_F_CESION_REMATE_TRIMESTRE
    -- D_F_CESION_REMATE_DIA
    -- D_F_CREACION_EXP_ANIO
    -- D_F_CREACION_EXP_DIA_SEMANA
    -- D_F_CREACION_EXP_MES
    -- D_F_CREACION_EXP_MES_ANIO
    -- D_F_CREACION_EXP_TRIMESTRE
    -- D_F_CREACION_EXP_DIA
    -- D_F_ROTURA_EXP_ANIO
    -- D_F_ROTURA_EXP_DIA_SEMANA
    -- D_F_ROTURA_EXP_MES
    -- D_F_ROTURA_EXP_MES_ANIO
    -- D_F_ROTURA_EXP_TRIMESTRE
    -- D_F_ROTURA_EXP_DIA
    -- D_F_CREACION_CNT_ANIO
    -- D_F_CREACION_CNT_DIA_SEMANA
    -- D_F_CREACION_CNT_MES
    -- D_F_CREACION_CNT_MES_ANIO
    -- D_F_CREACION_CNT_TRIMESTRE
    -- D_F_CREACION_CNT_DIA
    -- D_F_SAL_AGENCIA_EXP_ANIO
    -- D_F_SAL_AGENCIA_EXP_DIA_SEMANA
    -- D_F_SAL_AGENCIA_EXP_MES
    -- D_F_SAL_AGENCIA_EXP_MES_ANIO
    -- D_F_SAL_AGENCIA_EXP_TRIMESTRE
    -- D_F_SAL_AGENCIA_EXP_DIA
    -- D_F_OFREC_PROP_ANIO
    -- D_F_OFREC_PROP_DIA_SEMANA
    -- D_F_OFREC_PROP_MES
    -- D_F_OFREC_PROP_MES_ANIO
    -- D_F_OFREC_PROP_TRIMESTRE
    -- D_F_OFREC_PROP_DIA
    -- D_F_FORM_PROPUESTA_ANIO
    -- D_F_FORM_PROPUESTA_DIA_SEMANA
    -- D_F_FORM_PROPUESTA_MES
    -- D_F_FORM_PROPUESTA_MES_ANIO
    -- D_F_FORM_PROPUESTA_TRIMESTRE
    -- D_F_FORM_PROPUESTA_DIA
    -- D_F_SANCION_PROP_ANIO
    -- D_F_SANCION_PROP_DIA_SEMANA
    -- D_F_SANCION_PROP_MES
    -- D_F_SANCION_PROP_MES_ANIO
    -- D_F_SANCION_PROP_TRIMESTRE
    -- D_F_SANCION_PROP_DIA
    -- D_F_ACTIVACION_INCI_ANIO
    -- D_F_ACTIVACION_INCI_DIA_SEMANA
    -- D_F_ACTIVACION_INCI_MES
    -- D_F_ACTIVACION_INCI_MES_ANIO
    -- D_F_ACTIVACION_INCI_TRIMESTRE
    -- D_F_ACTIVACION_INCI_DIA
    -- D_F_RESOL_INCI_ANIO
    -- D_F_RESOL_INCI_DIA_SEMANA
    -- D_F_RESOL_INCI_MES
    -- D_F_RESOL_INCI_MES_ANIO
    -- D_F_RESOL_INCI_TRIMESTRE
    -- D_F_RESOL_INCI_DIA
    -- D_F_ELEV_COMITE_ANIO
    -- D_F_ELEV_COMITE_DIA_SEMANA
    -- D_F_ELEV_COMITE_MES
    -- D_F_ELEV_COMITE_MES_ANIO
    -- D_F_ELEV_COMITE_TRIMESTRE
    -- D_F_ELEV_COMITE_DIA
    -- D_F_ULTIMO_COBRO_ANIO
    -- D_F_ULTIMO_COBRO_DIA_SEMANA
    -- D_F_ULTIMO_COBRO_MES
    -- D_F_ULTIMO_COBRO_MES_ANIO
    -- D_F_ULTIMO_COBRO_TRIMESTRE
    -- D_F_ULTIMO_COBRO_DIA
    -- D_F_ENT_AGENCIA_EXP_ANIO
    -- D_F_ENT_AGENCIA_EXP_DIA_SEMANA
    -- D_F_ENT_AGENCIA_EXP_MES
    -- D_F_ENT_AGENCIA_EXP_MES_ANIO
    -- D_F_ENT_AGENCIA_EXP_TRIMESTRE
    -- D_F_ENT_AGENCIA_EXP_DIA
    -- D_F_ALTA_CICLO_REC_ANIO
    -- D_F_ALTA_CICLO_REC_DIA_SEMANA
    -- D_F_ALTA_CICLO_REC_MES
    -- D_F_ALTA_CICLO_REC_MES_ANIO
    -- D_F_ALTA_CICLO_REC_TRIMESTRE
    -- D_F_ALTA_CICLO_REC_DIA
    -- D_F_BAJA_CICLO_REC_ANIO
    -- D_F_BAJA_CICLO_REC_DIA_SEMANA
    -- D_F_BAJA_CICLO_REC_MES
    -- D_F_BAJA_CICLO_REC_MES_ANIO
    -- D_F_BAJA_CICLO_REC_TRIMESTRE
    -- D_F_BAJA_CICLO_REC_DIA
    -- D_F_ALTA_EXP_CR_ANIO
    -- D_F_ALTA_EXP_CR_DIA_SEMANA
    -- D_F_ALTA_EXP_CR_MES
    -- D_F_ALTA_EXP_CR_MES_ANIO
    -- D_F_ALTA_EXP_CR_TRIMESTRE
    -- D_F_ALTA_EXP_CR_DIA
    -- D_F_BAJA_EXP_CR_ANIO
    -- D_F_BAJA_EXP_CR_DIA_SEMANA
    -- D_F_BAJA_EXP_CR_MES
    -- D_F_BAJA_EXP_CR_MES_ANIO
    -- D_F_BAJA_EXP_CR_TRIMESTRE
    -- D_F_BAJA_EXP_CR_DIA
    -- D_F_MEJOR_GESTION_ANIO
    -- D_F_MEJOR_GESTION_DIA_SEMANA
    -- D_F_MEJOR_GESTION_MES
    -- D_F_MEJOR_GESTION_MES_ANIO
    -- D_F_MEJOR_GESTION_TRIMESTRE
    -- D_F_MEJOR_GESTION_DIA
    -- D_F_PROPUESTA_ACU_ANIO
    -- D_F_PROPUESTA_ACU_DIA_SEMANA
    -- D_F_PROPUESTA_ACU_MES
    -- D_F_PROPUESTA_ACU_MES_ANIO
    -- D_F_PROPUESTA_ACU_TRIMESTRE
    -- D_F_PROPUESTA_ACU_DIA
    -- D_F_INCIDENCIA_ANIO
    -- D_F_INCIDENCIA_DIA_SEMANA
    -- D_F_INCIDENCIA_MES
    -- D_F_INCIDENCIA_MES_ANIO
    -- D_F_INCIDENCIA_TRIMESTRE
    -- D_F_INCIDENCIA_DIA
    -- D_F_CANCELA_ASUNTO_ANIO
    -- D_F_CANCELA_ASUNTO_DIA_SEMANA
    -- D_F_CANCELA_ASUNTO_MES
    -- D_F_CANCELA_ASUNTO_MES_ANIO
    -- D_F_CANCELA_ASUNTO_TRIMESTRE
    -- D_F_CANCELA_ASUNTO_DIA
    -- D_F_CREDITO_INSI_ANIO
    -- D_F_CREDITO_INSI_DIA_SEMANA
    -- D_F_CREDITO_INSI_MES
    -- D_F_CREDITO_INSI_MES_ANIO
    -- D_F_CREDITO_INSI_TRIMESTRE
    -- D_F_CREDITO_INSI_DIA
    -- D_F_SOLIC_SUBASTA_ANIO
    -- D_F_SOLIC_SUBASTA_DIA_SEMANA
    -- D_F_SOLIC_SUBASTA_MES
    -- D_F_SOLIC_SUBASTA_MES_ANIO
    -- D_F_SOLIC_SUBASTA_TRIMESTRE
    -- D_F_SOLIC_SUBASTA_DIA
    -- D_F_CELEB_SUBASTA_ANIO
    -- D_F_CELEB_SUBASTA_DIA_SEMANA
    -- D_F_CELEB_SUBASTA_MES
    -- D_F_CELEB_SUBASTA_MES_ANIO
    -- D_F_CELEB_SUBASTA_TRIMESTRE
    -- D_F_CELEB_SUBASTA_DIA
    -- D_F_PARALIZACION_ANIO
    -- D_F_PARALIZACION_DIA_SEMANA
    -- D_F_PARALIZACION_MES
    -- D_F_PARALIZACION_MES_ANIO
    -- D_F_PARALIZACION_TRIMESTRE
    -- D_F_PARALIZACION_DIA
    -- D_F_FINALIZACION_ANIO
    -- D_F_FINALIZACION_DIA_SEMANA
    -- D_F_FINALIZACION_MES
    -- D_F_FINALIZACION_MES_ANIO
    -- D_F_FINALIZACION_TRIMESTRE
    -- D_F_FINALIZACION_DIA
    -- D_F_ACUERDO_ANIO
    -- D_F_ACUERDO_DIA_SEMANA
    -- D_F_ACUERDO_MES
    -- D_F_ACUERDO_MES_ANIO
    -- D_F_ACUERDO_TRIMESTRE
    -- D_F_ACUERDO_DIA
    -- D_F_RECEP_TESTIMO_ANIO
    -- D_F_RECEP_TESTIMO_DIA_SEMANA
    -- D_F_RECEP_TESTIMO_MES
    -- D_F_RECEP_TESTIMO_MES_ANIO
    -- D_F_RECEP_TESTIMO_TRIMESTRE
    -- D_F_RECEP_TESTIMO_DIA
    -- D_F_DECRETO_ADJ_ANIO
    -- D_F_DECRETO_ADJ_DIA_SEMANA
    -- D_F_DECRETO_ADJ_MES
    -- D_F_DECRETO_ADJ_MES_ANIO
    -- D_F_DECRETO_ADJ_TRIMESTRE
    -- D_F_DECRETO_ADJ_DIA
    -- D_F_SOL_DECRETO_ADJ_ANIO
    -- D_F_SOL_DECRETO_ADJ_DIA_SEMANA
    -- D_F_SOL_DECRETO_ADJ_MES
    -- D_F_SOL_DECRETO_ADJ_MES_ANIO
    -- D_F_SOL_DECRETO_ADJ_TRIMESTRE
    -- D_F_SOL_DECRETO_ADJ_DIA
    -- D_F_PUBLICACION_BOE_ANIO
    -- D_F_PUBLICACION_BOE_DIA_SEMANA
    -- D_F_PUBLICACION_BOE_MES
    -- D_F_PUBLICACION_BOE_MES_ANIO
    -- D_F_PUBLICACION_BOE_TRIMESTRE
    -- D_F_PUBLICACION_BOE_DIA
    -- D_F_REGISTRAR_IAC_ANIO
    -- D_F_REGISTRAR_IAC_DIA_SEMANA
    -- D_F_REGISTRAR_IAC_MES
    -- D_F_REGISTRAR_IAC_MES_ANIO
    -- D_F_REGISTRAR_IAC_TRIMESTRE
    -- D_F_REGISTRAR_IAC_DIA
  --> Jaime S-C: Módulo de PreContecioso:
    --        1)  PreLitigios:
    -- D_F_PRE_INICIO_ANIO
    -- D_F_PRE_INICIO_TRIMESTRE
    -- D_F_PRE_INICIO_MES_ANIO
    -- D_F_PRE_INICIO_MES
    -- D_F_PRE_INICIO_DIA_SEMANA
    -- D_F_PRE_INICIO_DIA
    -- D_F_PRE_ESTUDIO_ANIO
    -- D_F_PRE_ESTUDIO_TRIMESTRE
    -- D_F_PRE_ESTUDIO_MES_ANIO
    -- D_F_PRE_ESTUDIO_MES
    -- D_F_PRE_ESTUDIO_DIA_SEMANA
    -- D_F_PRE_ESTUDIO_DIA
    -- D_F_PRE_PREPARADO_ANIO
    -- D_F_PRE_PREPARADO_TRIMESTRE
    -- D_F_PRE_PREPARADO_MES_ANIO
    -- D_F_PRE_PREPARADO_MES
    -- D_F_PRE_PREPARADO_DIA_SEMANA
    -- D_F_PRE_PREPARADO_DIA
    -- D_F_PRE_ENV_LET_ANIO
    -- D_F_PRE_ENV_LET_TRIMESTRE
    -- D_F_PRE_ENV_LET_MES_ANIO
    -- D_F_PRE_ENV_LET_MES
    -- D_F_PRE_ENV_LET_DIA_SEMANA
    -- D_F_PRE_ENV_LET_DIA
    -- D_F_PRE_FINALIZADO_ANIO
    -- D_F_PRE_FINALIZADO_TRIMESTRE
    -- D_F_PRE_FINALIZADO_MES_ANIO
    -- D_F_PRE_FINALIZADO_MES
    -- D_F_PRE_FINALIZADO_DIA_SEMANA
    -- D_F_PRE_FINALIZADO_DIA
    -- D_F_PRE_ULT_SUBS_ANIO
    -- D_F_PRE_ULT_SUBS_TRIMESTRE
    -- D_F_PRE_ULT_SUBS_MES_ANIO
    -- D_F_PRE_ULT_SUBS_MES
    -- D_F_PRE_ULT_SUBS_DIA_SEMANA
    -- D_F_PRE_ULT_SUBS_DIA
    -- D_F_PRE_CANCELADO_ANIO
    -- D_F_PRE_CANCELADO_TRIMESTRE
    -- D_F_PRE_CANCELADO_MES_ANIO
    -- D_F_PRE_CANCELADO_MES
    -- D_F_PRE_CANCELADO_DIA_SEMANA
    -- D_F_PRE_CANCELADO_DIA
    -- D_F_PRE_PARALIZADO_ANIO
    -- D_F_PRE_PARALIZADO_TRIMESTRE
    -- D_F_PRE_PARALIZADO_MES_ANIO
    -- D_F_PRE_PARALIZADO_MES
    -- D_F_PRE_PARALIZADO_DIA_SEMANA
    -- D_F_PRE_PARALIZADO_DIA
    --        2)  Burofax:
    -- D_F_BURO_SOLICITUD_ANIO
    -- D_F_BURO_SOLICITUD_TRIMESTRE
    -- D_F_BURO_SOLICITUD_MES_ANIO
    -- D_F_BURO_SOLICITUD_MES 
    -- D_F_BURO_SOLICITUD_DIA_SEMANA
    -- D_F_BURO_SOLICITUD_DIA
    -- D_F_BURO_ENVIO_ANIO
    -- D_F_BURO_ENVIO_TRIMESTRE
    -- D_F_BURO_ENVIO_MES_ANIO
    -- D_F_BURO_ENVIO_MES
    -- D_F_BURO_ENVIO_DIA_SEMANA
    -- D_F_BURO_ENVIO_DIA
    -- D_F_BURO_ACUSE_ANIO
    -- D_F_BURO_ACUSE_TRIMESTRE
    -- D_F_BURO_ACUSE_MES_ANIO
    -- D_F_BURO_ACUSE_MES
    -- D_F_BURO_ACUSE_DIA_SEMANA
    -- D_F_BURO_ACUSE_DIA
    --        3)  Documento:
    -- D_F_DOC_SOLICITUD_ANIO
    -- D_F_DOC_SOLICITUD_TRIMESTRE
    -- D_F_DOC_SOLICITUD_MES_ANIO
    -- D_F_DOC_SOLICITUD_MES 
    -- D_F_DOC_SOLICITUD_DIA_SEMANA
    -- D_F_DOC_SOLICITUD_DIA
    -- D_F_DOC_ENVIO_ANIO
    -- D_F_DOC_ENVIO_TRIMESTRE
    -- D_F_DOC_ENVIO_MES_ANIO
    -- D_F_DOC_ENVIO_MES
    -- D_F_DOC_ENVIO_DIA_SEMANA
    -- D_F_DOC_ENVIO_DIA
    -- D_F_DOC_RESULT_ANIO
    -- D_F_DOC_RESULT_TRIMESTRE
    -- D_F_DOC_RESULT_MES_ANIO
    -- D_F_DOC_RESULT_MES 
    -- D_F_DOC_RESULT_DIA_SEMANA
    -- D_F_DOC_RESULT_DIA
    -- D_F_DOC_RECEP_ANIO
    -- D_F_DOC_RECEP_TRIMESTRE
    -- D_F_DOC_RECEP_MES_ANIO
    -- D_F_DOC_RECEP_MES
    -- D_F_DOC_RECEP_DIA_SEMANA
    -- D_F_DOC_RECEP_DIA
    --        4)  Liquidación: 
    -- D_F_LIQ_SOLICITUD_ANIO
    -- D_F_LIQ_SOLICITUD_TRIMESTRE
    -- D_F_LIQ_SOLICITUD_MES_ANIO
    -- D_F_LIQ_SOLICITUD_MES
    -- D_F_LIQ_SOLICITUD_DIA_SEMANA
    -- D_F_LIQ_SOLICITUD_DIA
    -- D_F_LIQ_RECEP_ANIO
    -- D_F_LIQ_RECEP_TRIMESTRE
    -- D_F_LIQ_RECEP_MES_ANIO
    -- D_F_LIQ_RECEP_MES
    -- D_F_LIQ_RECEP_DIA_SEMANA
    -- D_F_LIQ_RECEP_DIA
    -- D_F_LIQ_CONFIRM_ANIO
    -- D_F_LIQ_CONFIRM_TRIMESTRE
    -- D_F_LIQ_CONFIRM_MES_ANIO
    -- D_F_LIQ_CONFIRM_MES
    -- D_F_LIQ_CONFIRM_DIA_SEMANA
    -- D_F_LIQ_CONFIRM_DIA
    -- D_F_LIQ_CIERRE_ANIO
    -- D_F_LIQ_CIERRE_TRIMESTRE
    -- D_F_LIQ_CIERRE_MES_ANIO
    -- D_F_LIQ_CIERRE_MES
    -- D_F_LIQ_CIERRE_DIA_SEMANA
    -- D_F_LIQ_CIERRE_DIA
  --< Fin PreContecioso
        -- Fecha concesión de la operación
    -- D_F_CONCESION_CNT_DIA
    -- D_F_CONCESION_CNT_MES
    -- D_F_CONCESION_CNT_TRIMESTRE
    -- D_F_CONCESION_CNT_ANIO
    -- D_F_CONCESION_CNT_DIA_SEMANA
    -- D_F_CONCESION_CNT_MES_ANIO
        -- Fecha constitución
    -- D_F_CONSTI_CNT_DIA
    -- D_F_CONSTI_CNT_MES
    -- D_F_CONSTI_CNT_TRIMESTRE
    -- D_F_CONSTI_CNT_ANIO
    -- D_F_CONSTI_CNT_DIA_SEMANA
    -- D_F_CONSTI_CNT_MES_ANIO

      -- DIMENSIÓN FECHA_SOLICITUD_SUBASTA
    -- D_F_SOL_SUBASTA_ANIO
    -- D_F_SOL_SUBASTA_DIA_SEMANA
    -- D_F_SOL_SUBASTA_DIA
    -- D_F_SOL_SUBASTA_MES
    -- D_F_SOL_SUBASTA_MES_ANIO
    -- D_F_SOL_SUBASTA_TRIMESTRE
      -- DIMENSIÓN FECHA_ANUNCIO_SUBASTA
    -- D_F_ANUN_SUBASTA_ANIO
    --D_F_ANUN_SUBASTA_DIA_SEMANA
    -- D_F_ANUN_SUBASTA_DIA
    -- D_F_ANUN_SUBASTA_MES
    -- D_F_ANUN_SUBASTA_MES_ANIO
    -- D_F_ANUN_SUBASTA_TRIMESTRE
      -- DIMENSIÓN FECHA_SEÑALAMIENTO_SUBASTA
    -- D_F_SE_SUBASTA_ANIO
    -- D_F_SE_SUBASTA_DIA_SEMANA
    -- D_F_SE_SUBASTA_DIA
    -- D_F_SE_SUBASTA_MES
    -- D_F_SE_SUBASTA_MES_ANIO
    -- D_F_SE_SUBASTA_TRIMESTRE
    -- D_F_SOL_ART5_BIS_DIA
    -- D_F_SOL_ART5_BIS_MES
    -- D_F_SOL_ART5_BIS_TRIMESTRE
    -- D_F_SOL_ART5_BIS_ANIO
    -- D_F_SOL_ART5_BIS_DIA_SEMANA
    -- D_F_SOL_ART5_BIS_MES_ANIO
    -- D_F_PREP_DEC_PROP_DIA
    -- D_F_PREP_DEC_PROP_MES
    -- D_F_PREP_DEC_PROP_TRIMESTRE
    -- D_F_PREP_DEC_PROP_ANIO
    -- D_F_PREP_DEC_PROP_DIA_SEMANA
    -- D_F_PREP_DEC_PROP_MES_ANIO
    -- D_F_ULT_PROPUESTA_DIA
    -- D_F_ULT_PROPUESTA_MES
    -- D_F_ULT_PROPUESTA_TRIMESTRE
    -- D_F_ULT_PROPUESTA_ANIO
    -- D_F_ULT_PROPUESTA_DIA_SEMANA
    -- D_F_ULT_PROPUESTA_MES_ANIO
	
	-- D_F_CAMBIO_TRAMO_DIA
	-- D_F_CAMBIO_TRAMO_MES
	-- D_F_CAMBIO_TRAMO_TRIMESTRE
	-- D_F_CAMBIO_TRAMO_ANIO
	-- D_F_CAMBIO_TRAMO_DIA_SEMANA
	-- D_F_CAMBIO_TRAMO_MES_ANIO
	
	-- D_F_BAJA_DUDOSO_DIA
	-- D_F_BAJA_DUDOSO_MES
	-- D_F_BAJA_DUDOSO_TRIMESTRE
	-- D_F_BAJA_DUDOSO_ANIO
	-- D_F_BAJA_DUDOSO_DIA_SEMANA
	-- D_F_BAJA_DUDOSO_MES_ANIO
	
	-- D_F_ALTA_DUDOSO_DIA
	-- D_F_ALTA_DUDOSO_MES
	-- D_F_ALTA_DUDOSO_TRIMESTRE
	-- D_F_ALTA_DUDOSO_ANIO
	-- D_F_ALTA_DUDOSO_DIA_SEMANA
	-- D_F_ALTA_DUDOSO_MES_ANIO
	
	-- D_F_INICIO_CE_DIA
	-- D_F_INICIO_CE_MES
	-- D_F_INICIO_CE_TRIMESTRE
	-- D_F_INICIO_CE_ANIO
	-- D_F_INICIO_CE_DIA_SEMANA
	-- D_F_INICIO_CE_MES_ANIO
	
	-- D_F_INICIO_RE_DIA
	-- D_F_INICIO_RE_MES
	-- D_F_INICIO_RE_TRIMESTRE
	-- D_F_INICIO_RE_ANIO
	-- D_F_INICIO_RE_DIA_SEMANA
	-- D_F_INICIO_RE_MES_ANIO
	
	-- D_F_INICIO_DC_DIA
	-- D_F_INICIO_DC_MES
	-- D_F_INICIO_DC_TRIMESTRE
	-- D_F_INICIO_DC_ANIO
	-- D_F_INICIO_DC_DIA_SEMANA
	-- D_F_INICIO_DC_MES_ANIO
	
	-- D_F_FIN_CE_DIA
	-- D_F_FIN_CE_MES
	-- D_F_FIN_CE_TRIMESTRE
	-- D_F_FIN_CE_ANIO
	-- D_F_FIN_CE_DIA_SEMANA
	-- D_F_FIN_CE_MES_ANIO
	
	-- D_F_FIN_RE_DIA
	-- D_F_FIN_RE_MES
	-- D_F_FIN_RE_TRIMESTRE
	-- D_F_FIN_RE_ANIO
	-- D_F_FIN_RE_DIA_SEMANA
	-- D_F_FIN_RE_MES_ANIO
	
	-- D_F_FIN_DC_DIA
	-- D_F_FIN_DC_MES
	-- D_F_FIN_DC_TRIMESTRE
	-- D_F_FIN_DC_ANIO
	-- D_F_FIN_DC_DIA_SEMANA
	-- D_F_FIN_DC_MES_ANIO

 	-- D_F_INICIO_FP_DIA
	-- D_F_INICIO_FP_MES
	-- D_F_INICIO_FP_TRIMESTRE
	-- D_F_INICIO_FP_ANIO
	-- D_F_INICIO_FP_DIA_SEMANA
	-- D_F_INICIO_FP_MES_ANIO

	-- D_F_FIN_FP_DIA
	-- D_F_FIN_FP_MES
	-- D_F_FIN_FP_TRIMESTRE
	-- D_F_FIN_FP_ANIO
	-- D_F_FIN_FP_DIA_SEMANA
	-- D_F_FIN_FP_MES_ANIO
	
	-- D_F_ANOTA_PER_DIA
	-- D_F_ANOTA_PER_MES
	-- D_F_ANOTA_PER_TRIMESTRE
	-- D_F_ANOTA_PER_ANIO
	-- D_F_ANOTA_PER_DIA_SEMANA
	-- D_F_ANOTA_PER_MES_ANIO
	
	-- D_F_LLAMADA_DIA
	-- D_F_LLAMADA_MES
	-- D_F_LLAMADA_TRIMESTRE
	-- D_F_LLAMADA_ANIO
	-- D_F_LLAMADA_DIA_SEMANA
	-- D_F_LLAMADA_MES_ANIO
    
BEGIN

  declare
  nCount NUMBER;
  V_SQL varchar2(16000);
  V_NOMBRE VARCHAR2(50) := 'CREAR_DIM_FECHA_OTRAS';

  begin

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
   
    ------------------------------ D_F_CARGA_DATOS_ANIO ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CARGA_DATOS_ANIO'',
						  ''ANIO_CARGA_DATOS_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CARGA_DATOS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CARGA_DATOS_DIA_SEMANA ------------------------------
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CARGA_DATOS_DIA_SEMANA'',
                          ''DIA_SEMANA_CARGA_DATOS_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CARGA_DATOS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CARGA_DATOS_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CARGA_DATOS_MES'',
                          ''MES_CARGA_DATOS_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CARGA_DATOS_ID INTEGER,
                            TRIMESTRE_CARGA_DATOS_ID INTEGER,
                            ANIO_CARGA_DATOS_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CARGA_DATOS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CARGA_DATOS_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CARGA_DATOS_MES_ANIO'',
                          ''MES_ANIO_CARGA_DATOS_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CARGA_DATOS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CARGA_DATOS_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CARGA_DATOS_TRIMESTRE'',
                          ''TRIMESTRE_CARGA_DATOS_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CARGA_DATOS_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CARGA_DATOS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CARGA_DATOS_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CARGA_DATOS_DIA'',
                          ''DIA_CARGA_DATOS_ID DATE NOT NULL,
                            DIA_SEMANA_CARGA_DATOS_ID INTEGER,
                            MES_CARGA_DATOS_ID INTEGER,
                            TRIMESTRE_CARGA_DATOS_ID INTEGER,
                            ANIO_CARGA_DATOS_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CARGA_DATOS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_POS_VENCIDA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_POS_VENCIDA_ANIO'',
						  ''ANIO_POS_VENCIDA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_POS_VENCIDA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_POS_VENCIDA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_POS_VENCIDA_DIA_SEMANA'',
                          ''DIA_SEMANA_POS_VENCIDA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_POS_VENCIDA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_POS_VENCIDA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_POS_VENCIDA_MES'',
                          ''MES_POS_VENCIDA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_POS_VENCIDA_ID INTEGER,
                            TRIMESTRE_POS_VENCIDA_ID INTEGER,
                            ANIO_POS_VENCIDA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_POS_VENCIDA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_POS_VENCIDA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_POS_VENCIDA_MES_ANIO'',
                          ''MES_ANIO_POS_VENCIDA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_POS_VENCIDA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_POS_VENCIDA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_POS_VENCIDA_TRIMESTRE'',
                          ''TRIMESTRE_POS_VENCIDA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_POS_VENCIDA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_POS_VENCIDA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_POS_VENCIDA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_POS_VENCIDA_DIA'',
                          ''DIA_POS_VENCIDA_ID DATE NOT NULL,
                            DIA_SEMANA_POS_VENCIDA_ID INTEGER,
                            MES_POS_VENCIDA_ID INTEGER,
                            TRIMESTRE_POS_VENCIDA_ID INTEGER,
                            ANIO_POS_VENCIDA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_POS_VENCIDA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SALDO_DUDOSO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SALDO_DUDOSO_ANIO'',
                          ''ANIO_SALDO_DUDOSO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SALDO_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SALDO_DUDOSO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SALDO_DUDOSO_DIA_SEMANA'',
                          ''DIA_SEMANA_SALDO_DUDOSO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SALDO_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SALDO_DUDOSO_MES------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SALDO_DUDOSO_MES'',
                          ''MES_SALDO_DUDOSO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SALDO_DUDOSO_ID INTEGER,
                            TRIMESTRE_SALDO_DUDOSO_ID INTEGER,
                            ANIO_SALDO_DUDOSO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SALDO_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SALDO_DUDOSO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SALDO_DUDOSO_MES_ANIO'',
                          ''MES_ANIO_SALDO_DUDOSO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SALDO_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SALDO_DUDOSO_TRIMESTRE ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SALDO_DUDOSO_TRIMESTRE'',
                          ''TRIMESTRE_SALDO_DUDOSO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SALDO_DUDOSO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SALDO_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SALDO_DUDOSO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SALDO_DUDOSO_DIA'',
                          ''DIA_SALDO_DUDOSO_ID DATE NOT NULL,
                            DIA_SEMANA_SALDO_DUDOSO_ID INTEGER,
                            MES_SALDO_DUDOSO_ID INTEGER,
                            TRIMESTRE_SALDO_DUDOSO_ID INTEGER,
                            ANIO_SALDO_DUDOSO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SALDO_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_ASUNTO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_ASUNTO_ANIO'',
                          ''ANIO_CREACION_ASUNTO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CREACION_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_ASUNTO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_ASUNTO_DIA_SEMANA'',
                          ''DIA_SEMANA_CREACION_ASUNTO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CREACION_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_ASUNTO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_ASUNTO_MES'',
                          ''MES_CREACION_ASUNTO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CREACION_ASUNTO_ID INTEGER,
                            TRIMESTRE_CREACION_ASUNTO_ID INTEGER,
                            ANIO_CREACION_ASUNTO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CREACION_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_ASUNTO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_ASUNTO_MES_ANIO'',
                          ''MES_ANIO_CREACION_ASUNTO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CREACION_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CREACION_ASUNTO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_ASUNTO_TRIMESTRE'',
                          ''TRIMESTRE_CREACION_ASUNTO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CREACION_ASUNTO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CREACION_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_ASUNTO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_ASUNTO_DIA'',
                          ''DIA_CREACION_ASUNTO_ID DATE NOT NULL,
                            DIA_SEMANA_CREACION_ASUNTO_ID INTEGER,
                            MES_CREACION_ASUNTO_ID INTEGER,
                            TRIMESTRE_CREACION_ASUNTO_ID INTEGER,
                            ANIO_CREACION_ASUNTO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CREACION_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_PRC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_PRC_ANIO'',
                          ''ANIO_CREACION_PRC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CREACION_PRC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_PRC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_PRC_DIA_SEMANA'',
                          ''DIA_SEMANA_CREACION_PRC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CREACION_PRC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_PRC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_PRC_MES'',
                          ''MES_CREACION_PRC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CREACION_PRC_ID INTEGER,
                            TRIMESTRE_CREACION_PRC_ID INTEGER,
                            ANIO_CREACION_PRC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CREACION_PRC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_PRC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_PRC_MES_ANIO'',
                          ''MES_ANIO_CREACION_PRC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CREACION_PRC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CREACION_PRC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_PRC_TRIMESTRE'',
                          ''TRIMESTRE_CREACION_PRC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CREACION_PRC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CREACION_PRC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_PRC_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_PRC_DIA'',
                          ''DIA_CREACION_PRC_ID DATE NOT NULL,
                            DIA_SEMANA_CREACION_PRC_ID INTEGER,
                            MES_CREACION_PRC_ID INTEGER,
                            TRIMESTRE_CREACION_PRC_ID INTEGER,
                            ANIO_CREACION_PRC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CREACION_PRC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_CRE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_CRE_ANIO'',
                          ''ANIO_ULT_TAR_CRE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ULT_TAR_CRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_CRE_DIA_SEMANA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_CRE_DIA_SEMANA'',
                          ''DIA_SEMANA_ULT_TAR_CRE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ULT_TAR_CRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_CRE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_CRE_MES'',
						  ''MES_ULT_TAR_CRE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ULT_TAR_CRE_ID INTEGER,
                            TRIMESTRE_ULT_TAR_CRE_ID INTEGER,
                            ANIO_ULT_TAR_CRE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ULT_TAR_CRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_CRE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_CRE_MES_ANIO'',
						  ''MES_ANIO_ULT_TAR_CRE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ULT_TAR_CRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ULT_TAR_CRE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_CRE_TRIMESTRE'',
						  ''TRIMESTRE_ULT_TAR_CRE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ULT_TAR_CRE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ULT_TAR_CRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_CRE_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_CRE_DIA'',
						  ''DIA_ULT_TAR_CRE_ID DATE NOT NULL,
                            DIA_SEMANA_ULT_TAR_CRE_ID INTEGER,
                            MES_ULT_TAR_CRE_ID INTEGER,
                            TRIMESTRE_ULT_TAR_CRE_ID INTEGER,
                            ANIO_ULT_TAR_CRE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ULT_TAR_CRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_FIN_ANIO ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_FIN_ANIO'',
						  ''ANIO_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_FIN_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_FIN_DIA_SEMANA'',
						  ''DIA_SEMANA_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_FIN_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_FIN_MES'',
						  ''MES_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ULT_TAR_FIN_ID INTEGER,
                            TRIMESTRE_ULT_TAR_FIN_ID INTEGER,
                            ANIO_ULT_TAR_FIN_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_FIN_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_FIN_MES_ANIO'',
						  ''MES_ANIO_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ULT_TAR_FIN_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_FIN_TRIMESTRE'',
						  ''TRIMESTRE_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ULT_TAR_FIN_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_FIN_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_FIN_DIA'',
						  ''DIA_ULT_TAR_FIN_ID DATE NOT NULL,
                            DIA_SEMANA_ULT_TAR_FIN_ID INTEGER,
                            MES_ULT_TAR_FIN_ID INTEGER,
                            TRIMESTRE_ULT_TAR_FIN_ID INTEGER,
                            ANIO_ULT_TAR_FIN_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_ACT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_ACT_ANIO'',
						  ''ANIO_ULT_TAR_ACT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ULT_TAR_ACT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_ACT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_ACT_DIA_SEMANA'',
						  ''DIA_SEMANA_ULT_TAR_ACT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ULT_TAR_ACT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_ACT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_ACT_MES'',
						  ''MES_ULT_TAR_ACT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ULT_TAR_ACT_ID INTEGER,
                            TRIMESTRE_ULT_TAR_ACT_ID INTEGER,
                            ANIO_ULT_TAR_ACT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ULT_TAR_ACT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_ACT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_ACT_MES_ANIO'',
						  ''MES_ANIO_ULT_TAR_ACT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ULT_TAR_ACT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ULT_TAR_ACT_TRIMESTRE ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_ACT_TRIMESTRE'',
						  ''TRIMESTRE_ULT_TAR_ACT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ULT_TAR_ACT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ULT_TAR_ACT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_ACT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_ACT_DIA'',
						  ''DIA_ULT_TAR_ACT_ID DATE NOT NULL,
                            DIA_SEMANA_ULT_TAR_ACT_ID INTEGER,
                            MES_ULT_TAR_ACT_ID INTEGER,
                            TRIMESTRE_ULT_TAR_ACT_ID INTEGER,
                            ANIO_ULT_TAR_ACT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ULT_TAR_ACT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_PEN_ANIO ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_PEN_ANIO'',
						  ''ANIO_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_PEN_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_PEN_DIA_SEMANA'',
						  ''DIA_SEMANA_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_PEN_MES ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_PEN_MES'',
						  ''MES_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ULT_TAR_PEN_ID INTEGER,
                            TRIMESTRE_ULT_TAR_PEN_ID INTEGER,
                            ANIO_ULT_TAR_PEN_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_TAR_PEN_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_PEN_MES_ANIO'',
						  ''MES_ANIO_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ULT_TAR_PEN_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_PEN_TRIMESTRE'',
						  ''TRIMESTRE_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ULT_TAR_PEN_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_TAR_PEN_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_TAR_PEN_DIA'',
						  ''DIA_ULT_TAR_PEN_ID DATE NOT NULL,
                            DIA_SEMANA_ULT_TAR_PEN_ID INTEGER,
                            MES_ULT_TAR_PEN_ID INTEGER,
                            TRIMESTRE_ULT_TAR_PEN_ID INTEGER,
                            ANIO_ULT_TAR_PEN_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VA_ULT_TAR_PEN_ANIO ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_PEN_ANIO'',
						  ''ANIO_VA_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_VA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_VA_ULT_TAR_PEN_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_PEN_DIA_SEMANA'',
						  ''DIA_SEMANA_VA_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_VA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VA_ULT_TAR_PEN_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_PEN_MES'',
						  ''MES_VA_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_VA_ULT_TAR_PEN_ID INTEGER,
                            TRIMESTRE_VA_ULT_TAR_PEN_ID INTEGER,
                            ANIO_VA_ULT_TAR_PEN_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_VA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_VA_ULT_TAR_PEN_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_PEN_MES_ANIO'',
						  ''MES_ANIO_VA_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_VA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_VA_ULT_TAR_PEN_TRIMESTRE ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_PEN_TRIMESTRE'',
						  ''TRIMESTRE_VA_ULT_TAR_PEN_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_VA_ULT_TAR_PEN_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_VA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
   ------------------------------ D_F_VA_ULT_TAR_PEN_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_PEN_DIA'',
						  ''DIA_VA_ULT_TAR_PEN_ID DATE NOT NULL,
                            DIA_SEMANA_VA_ULT_TAR_PEN_ID INTEGER,
                            MES_VA_ULT_TAR_PEN_ID INTEGER,
                            TRIMESTRE_VA_ULT_TAR_PEN_ID INTEGER,
                            ANIO_VA_ULT_TAR_PEN_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_VA_ULT_TAR_PEN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VA_ULT_TAR_FIN_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_FIN_ANIO'',
						  ''ANIO_VA_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_VA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_VA_ULT_TAR_FIN_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_FIN_DIA_SEMANA'',
						  ''DIA_SEMANA_VA_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_VA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VA_ULT_TAR_FIN_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_FIN_MES'',
						  ''MES_VA_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_VA_ULT_TAR_FIN_ID INTEGER,
                            TRIMESTRE_VA_ULT_TAR_FIN_ID INTEGER,
                            ANIO_VA_ULT_TAR_FIN_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_VA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_VA_ULT_TAR_FIN_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_FIN_MES_ANIO'',
						  ''MES_ANIO_VA_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_VA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_VA_ULT_TAR_FIN_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_FIN_TRIMESTRE'',
						  ''TRIMESTRE_VA_ULT_TAR_FIN_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_VA_ULT_TAR_FIN_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_VA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VA_ULT_TAR_FIN_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VA_ULT_TAR_FIN_DIA'',
						  ''DIA_VA_ULT_TAR_FIN_ID DATE NOT NULL,
                            DIA_SEMANA_VA_ULT_TAR_FIN_ID INTEGER,
                            MES_VA_ULT_TAR_FIN_ID INTEGER,
                            TRIMESTRE_VA_ULT_TAR_FIN_ID INTEGER,
                            ANIO_VA_ULT_TAR_FIN_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_VA_ULT_TAR_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_COBRO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COBRO_ANIO'',
						  ''ANIO_COBRO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_COBRO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COBRO_DIA_SEMANA'',
						  ''DIA_SEMANA_COBRO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_COBRO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COBRO_MES'',
						  ''MES_COBRO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_COBRO_ID INTEGER,
                            TRIMESTRE_COBRO_ID INTEGER,
                            ANIO_COBRO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_COBRO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COBRO_MES_ANIO'',
						  ''MES_ANIO_COBRO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_COBRO_TRIMESTRE ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COBRO_TRIMESTRE'',
						  ''TRIMESTRE_COBRO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_COBRO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_COBRO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COBRO_DIA'',
						  ''DIA_COBRO_ID DATE NOT NULL,
                            DIA_SEMANA_COBRO_ID INTEGER,
                            MES_COBRO_ID INTEGER,
                            TRIMESTRE_COBRO_ID INTEGER,
                            ANIO_COBRO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACEPTACION_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACEPTACION_ANIO'',
						  ''ANIO_ACEPTACION_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ACEPTACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACEPTACION_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACEPTACION_DIA_SEMANA'',
						  ''DIA_SEMANA_ACEPTACION_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ACEPTACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACEPTACION_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACEPTACION_MES'',
						  ''MES_ACEPTACION_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ACEPTACION_ID INTEGER,
                            TRIMESTRE_ACEPTACION_ID INTEGER,
                            ANIO_ACEPTACION_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ACEPTACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACEPTACION_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACEPTACION_MES_ANIO'',
						  ''MES_ANIO_ACEPTACION_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ACEPTACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ACEPTACION_TRIMESTRE ------------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACEPTACION_TRIMESTRE'',
						  ''TRIMESTRE_ACEPTACION_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ACEPTACION_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ACEPTACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACEPTACION_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACEPTACION_DIA'',
						  ''DIA_ACEPTACION_ID DATE NOT NULL,
                            DIA_SEMANA_ACEPTACION_ID INTEGER,
                            MES_ACEPTACION_ID INTEGER,
                            TRIMESTRE_ACEPTACION_ID INTEGER,
                            ANIO_ACEPTACION_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ACEPTACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INTER_DEM_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INTER_DEM_ANIO'',
						  ''ANIO_INTER_DEM_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INTER_DEM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INTER_DEM_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INTER_DEM_DIA_SEMANA'',
						  ''DIA_SEMANA_INTER_DEM_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INTER_DEM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INTER_DEM_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INTER_DEM_MES'',
						  ''MES_INTER_DEM_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INTER_DEM_ID INTEGER,
                            TRIMESTRE_INTER_DEM_ID INTEGER,
                            ANIO_INTER_DEM_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INTER_DEM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INTER_DEM_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INTER_DEM_MES_ANIO'',
						  ''MES_ANIO_INTER_DEM_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INTER_DEM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_INTER_DEM_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INTER_DEM_TRIMESTRE'',
						  ''TRIMESTRE_INTER_DEM_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INTER_DEM_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INTER_DEM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INTER_DEM_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INTER_DEM_DIA'',
						  ''DIA_INTER_DEM_ID DATE NOT NULL,
                            DIA_SEMANA_INTER_DEM_ID INTEGER,
                            MES_INTER_DEM_ID INTEGER,
                            TRIMESTRE_INTER_DEM_ID INTEGER,
                            ANIO_INTER_DEM_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INTER_DEM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DECRETO_FIN_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_FIN_ANIO'',
						  ''ANIO_DECRETO_FIN_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_DECRETO_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DECRETO_FIN_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_FIN_DIA_SEMANA'',
						  ''DIA_SEMANA_DECRETO_FIN_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_DECRETO_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DECRETO_FIN_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_FIN_MES'',
						  ''MES_DECRETO_FIN_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_DECRETO_FIN_ID INTEGER,
                            TRIMESTRE_DECRETO_FIN_ID INTEGER,
                            ANIO_DECRETO_FIN_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_DECRETO_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DECRETO_FIN_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_FIN_MES_ANIO'',
						  ''MES_ANIO_DECRETO_FIN_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_DECRETO_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_DECRETO_FIN_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_FIN_TRIMESTRE'',
						  ''TRIMESTRE_DECRETO_FIN_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_DECRETO_FIN_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_DECRETO_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DECRETO_FIN_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_FIN_DIA'',
						  ''DIA_DECRETO_FIN_ID DATE NOT NULL,
                            DIA_SEMANA_DECRETO_FIN_ID INTEGER,
                            MES_DECRETO_FIN_ID INTEGER,
                            TRIMESTRE_DECRETO_FIN_ID INTEGER,
                            ANIO_DECRETO_FIN_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_DECRETO_FIN_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RESOL_FIRME_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_FIRME_ANIO'',
						  ''ANIO_RESOL_FIRME_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_RESOL_FIRME_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RESOL_FIRME_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_FIRME_DIA_SEMANA'',
						  ''DIA_SEMANA_RESOL_FIRME_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_RESOL_FIRME_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RESOL_FIRME_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_FIRME_MES'',
						  ''MES_RESOL_FIRME_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_RESOL_FIRME_ID INTEGER,
                            TRIMESTRE_RESOL_FIRME_ID INTEGER,
                            ANIO_RESOL_FIRME_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_RESOL_FIRME_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RESOL_FIRME_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_FIRME_MES_ANIO'',
						  ''MES_ANIO_RESOL_FIRME_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_RESOL_FIRME_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_RESOL_FIRME_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_FIRME_TRIMESTRE'',
						  ''TRIMESTRE_RESOL_FIRME_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_RESOL_FIRME_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_RESOL_FIRME_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RESOL_FIRME_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_FIRME_DIA'',
						  ''DIA_RESOL_FIRME_ID DATE NOT NULL,
                            DIA_SEMANA_RESOL_FIRME_ID INTEGER,
                            MES_RESOL_FIRME_ID INTEGER,
                            TRIMESTRE_RESOL_FIRME_ID INTEGER,
                            ANIO_RESOL_FIRME_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_RESOL_FIRME_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SUBASTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUBASTA_ANIO'',
						  ''ANIO_SUBASTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SUBASTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUBASTA_DIA_SEMANA'',
						  ''DIA_SEMANA_SUBASTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SUBASTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUBASTA_MES'',
						  ''MES_SUBASTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SUBASTA_ID INTEGER,
                            TRIMESTRE_SUBASTA_ID INTEGER,
                            ANIO_SUBASTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SUBASTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUBASTA_MES_ANIO'',
						  ''MES_ANIO_SUBASTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SUBASTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUBASTA_TRIMESTRE'',
						  ''TRIMESTRE_SUBASTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SUBASTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SUBASTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUBASTA_DIA'',
						  ''DIA_SUBASTA_ID DATE NOT NULL,
                            DIA_SEMANA_SUBASTA_ID INTEGER,
                            MES_SUBASTA_ID INTEGER,
                            TRIMESTRE_SUBASTA_ID INTEGER,
                            ANIO_SUBASTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INICIO_APREMIO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_APREMIO_ANIO'',
						  ''ANIO_INICIO_APREMIO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INICIO_APREMIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INICIO_APREMIO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_APREMIO_DIA_SEMANA'',
						  ''DIA_SEMANA_INICIO_APREMIO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INICIO_APREMIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INICIO_APREMIO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_APREMIO_MES'',
						  ''MES_INICIO_APREMIO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INICIO_APREMIO_ID INTEGER,
                            TRIMESTRE_INICIO_APREMIO_ID INTEGER,
                            ANIO_INICIO_APREMIO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INICIO_APREMIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INICIO_APREMIO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_APREMIO_MES_ANIO'',
						  ''MES_ANIO_INICIO_APREMIO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INICIO_APREMIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_INICIO_APREMIO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_APREMIO_TRIMESTRE'',
						  ''TRIMESTRE_INICIO_APREMIO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INICIO_APREMIO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INICIO_APREMIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INICIO_APREMIO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_APREMIO_DIA'',
						  ''DIA_INICIO_APREMIO_ID DATE NOT NULL,
                            DIA_SEMANA_INICIO_APREMIO_ID INTEGER,
                            MES_INICIO_APREMIO_ID INTEGER,
                            TRIMESTRE_INICIO_APREMIO_ID INTEGER,
                            ANIO_INICIO_APREMIO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INICIO_APREMIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ESTIMADA_COBRO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ESTIMADA_COBRO_ANIO'',
						  ''ANIO_ESTIMADA_COBRO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ESTIMADA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ESTIMADA_COBRO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ESTIMADA_COBRO_DIA_SEMANA'',
						  ''DIA_SEMANA_ESTIMADA_COBRO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ESTIMADA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ESTIMADA_COBRO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ESTIMADA_COBRO_MES'',
						  ''MES_ESTIMADA_COBRO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ESTIMADA_COBRO_ID INTEGER,
                            TRIMESTRE_ESTIMADA_COBRO_ID INTEGER,
                            ANIO_ESTIMADA_COBRO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ESTIMADA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ESTIMADA_COBRO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ESTIMADA_COBRO_MES_ANIO'',
						  ''MES_ANIO_ESTIMADA_COBRO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ESTIMADA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ESTIMADA_COBRO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ESTIMADA_COBRO_TRIMESTRE'',
						  ''TRIMESTRE_ESTIMADA_COBRO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ESTIMADA_COBRO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ESTIMADA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ESTIMADA_COBRO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ESTIMADA_COBRO_DIA'',
						  ''DIA_ESTIMADA_COBRO_ID DATE NOT NULL,
                            DIA_SEMANA_ESTIMADA_COBRO_ID INTEGER,
                            MES_ESTIMADA_COBRO_ID INTEGER,
                            TRIMESTRE_ESTIMADA_COBRO_ID INTEGER,
                            ANIO_ESTIMADA_COBRO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ESTIMADA_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_EST_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_EST_ANIO'',
						  ''ANIO_ULT_EST_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ULT_EST_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_EST_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_EST_DIA_SEMANA'',
						  ''DIA_SEMANA_ULT_EST_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ULT_EST_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_EST_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_EST_MES'',
						  ''MES_ULT_EST_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ULT_EST_ID INTEGER,
                            TRIMESTRE_ULT_EST_ID INTEGER,
                            ANIO_ULT_EST_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ULT_EST_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULT_EST_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_EST_MES_ANIO'',
						  ''MES_ANIO_ULT_EST_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ULT_EST_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ULT_EST_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_EST_TRIMESTRE'',
						  ''TRIMESTRE_ULT_EST_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ULT_EST_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ULT_EST_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULT_EST_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_EST_DIA'',
						  ''DIA_ULT_EST_ID DATE NOT NULL,
                            DIA_SEMANA_ULT_EST_ID INTEGER,
                            MES_ULT_EST_ID INTEGER,
                            TRIMESTRE_ULT_EST_ID INTEGER,
                            ANIO_ULT_EST_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ULT_EST_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQUIDACION_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQUIDACION_ANIO'',
						  ''ANIO_LIQUIDACION_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_LIQUIDACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQUIDACION_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQUIDACION_DIA_SEMANA'',
						  ''DIA_SEMANA_LIQUIDACION_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_LIQUIDACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQUIDACION_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQUIDACION_MES'',
						  ''MES_LIQUIDACION_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_LIQUIDACION_ID INTEGER,
                            TRIMESTRE_LIQUIDACION_ID INTEGER,
                            ANIO_LIQUIDACION_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_LIQUIDACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQUIDACION_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQUIDACION_MES_ANIO'',
						  ''MES_ANIO_LIQUIDACION_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_LIQUIDACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_LIQUIDACION_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQUIDACION_TRIMESTRE'',
						  ''TRIMESTRE_LIQUIDACION_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_LIQUIDACION_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_LIQUIDACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQUIDACION_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQUIDACION_DIA'',
						  ''DIA_LIQUIDACION_ID DATE NOT NULL,
                            DIA_SEMANA_LIQUIDACION_ID INTEGER,
                            MES_LIQUIDACION_ID INTEGER,
                            TRIMESTRE_LIQUIDACION_ID INTEGER,
                            ANIO_LIQUIDACION_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_LIQUIDACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INSI_FINAL_CRED_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INSI_FINAL_CRED_ANIO'',
						  ''ANIO_INSI_FINAL_CRED_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INSI_FINAL_CRED_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INSI_FINAL_CRED_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INSI_FINAL_CRED_DIA_SEMANA'',
						  ''DIA_SEMANA_INSI_FINAL_CRED_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INSI_FINAL_CRED_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INSI_FINAL_CRED_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INSI_FINAL_CRED_MES'',
						  ''MES_INSI_FINAL_CRED_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INSI_FINAL_CRED_ID INTEGER,
                            TRIMESTRE_INSI_FINAL_CRED_ID INTEGER,
                            ANIO_INSI_FINAL_CRED_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INSI_FINAL_CRED_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INSI_FINAL_CRED_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INSI_FINAL_CRED_MES_ANIO'',
						  ''MES_ANIO_INSI_FINAL_CRED_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INSI_FINAL_CRED_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_INSI_FINAL_CRED_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INSI_FINAL_CRED_TRIMESTRE'',
						  ''TRIMESTRE_INSI_FINAL_CRED_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INSI_FINAL_CRED_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INSI_FINAL_CRED_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_INSI_FINAL_CRED_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INSI_FINAL_CRED_DIA'',
						  ''DIA_INSI_FINAL_CRED_ID DATE NOT NULL,
                            DIA_SEMANA_INSI_FINAL_CRED_ID INTEGER,
                            MES_INSI_FINAL_CRED_ID INTEGER,
                            TRIMESTRE_INSI_FINAL_CRED_ID INTEGER,
                            ANIO_INSI_FINAL_CRED_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INSI_FINAL_CRED_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_AUTO_APERT_CONV_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_AUTO_APERT_CONV_ANIO'',
						  ''ANIO_AUTO_APERT_CONV_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_AUTO_APERT_CONV_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_AUTO_APERT_CONV_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_AUTO_APERT_CONV_DIA_SEMANA'',
						  ''DIA_SEMANA_AUTO_APERT_CONV_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_AUTO_APERT_CONV_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_AUTO_APERT_CONV_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_AUTO_APERT_CONV_MES'',
						  ''MES_AUTO_APERT_CONV_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_AUTO_APERT_CONV_ID INTEGER,
                            TRIMESTRE_AUTO_APERT_CONV_ID INTEGER,
                            ANIO_AUTO_APERT_CONV_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_AUTO_APERT_CONV_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_AUTO_APERT_CONV_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_AUTO_APERT_CONV_MES_ANIO'',
						  ''MES_ANIO_AUTO_APERT_CONV_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_AUTO_APERT_CONV_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_AUTO_APERT_CONV_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_AUTO_APERT_CONV_TRIMESTRE'',
						  ''TRIMESTRE_AUTO_APERT_CONV_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_AUTO_APERT_CONV_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_AUTO_APERT_CONV_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_AUTO_APERT_CONV_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_AUTO_APERT_CONV_DIA'',
						  ''DIA_AUTO_APERT_CONV_ID DATE NOT NULL,
                            DIA_SEMANA_AUTO_APERT_CONV_ID INTEGER,
                            MES_AUTO_APERT_CONV_ID INTEGER,
                            TRIMESTRE_AUTO_APERT_CONV_ID INTEGER,
                            ANIO_AUTO_APERT_CONV_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_AUTO_APERT_CONV_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_JUNTA_ACREE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_JUNTA_ACREE_ANIO'',
						  ''ANIO_JUNTA_ACREE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_JUNTA_ACREE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_JUNTA_ACREE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_JUNTA_ACREE_DIA_SEMANA'',
						  ''DIA_SEMANA_JUNTA_ACREE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_JUNTA_ACREE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_JUNTA_ACREE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_JUNTA_ACREE_MES'',
						  ''MES_JUNTA_ACREE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_JUNTA_ACREE_ID INTEGER,
                            TRIMESTRE_JUNTA_ACREE_ID INTEGER,
                            ANIO_JUNTA_ACREE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_JUNTA_ACREE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_JUNTA_ACREE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_JUNTA_ACREE_MES_ANIO'',
						  ''MES_ANIO_JUNTA_ACREE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_JUNTA_ACREE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_JUNTA_ACREE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_JUNTA_ACREE_TRIMESTRE'',
						  ''TRIMESTRE_JUNTA_ACREE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_JUNTA_ACREE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_JUNTA_ACREE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_JUNTA_ACREE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_JUNTA_ACREE_DIA'',
						  ''DIA_JUNTA_ACREE_ID DATE NOT NULL,
                            DIA_SEMANA_JUNTA_ACREE_ID INTEGER,
                            MES_JUNTA_ACREE_ID INTEGER,
                            TRIMESTRE_JUNTA_ACREE_ID INTEGER,
                            ANIO_JUNTA_ACREE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_JUNTA_ACREE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REG_RESOL_LIQ_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_RESOL_LIQ_ANIO'',
						  ''ANIO_REG_RESOL_LIQ_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_REG_RESOL_LIQ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_REG_RESOL_LIQ_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_RESOL_LIQ_DIA_SEMANA'',
						  ''DIA_SEMANA_REG_RESOL_LIQ_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_REG_RESOL_LIQ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REG_RESOL_LIQ_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_RESOL_LIQ_MES'',
						  ''MES_REG_RESOL_LIQ_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_REG_RESOL_LIQ_ID INTEGER,
                            TRIMESTRE_REG_RESOL_LIQ_ID INTEGER,
                            ANIO_REG_RESOL_LIQ_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_REG_RESOL_LIQ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_REG_RESOL_LIQ_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_RESOL_LIQ_MES_ANIO'',
						  ''MES_ANIO_REG_RESOL_LIQ_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_REG_RESOL_LIQ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_REG_RESOL_LIQ_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_RESOL_LIQ_TRIMESTRE'',
						  ''TRIMESTRE_REG_RESOL_LIQ_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_REG_RESOL_LIQ_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_REG_RESOL_LIQ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REG_RESOL_LIQ_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_RESOL_LIQ_DIA'',
						  ''DIA_REG_RESOL_LIQ_ID DATE NOT NULL,
                            DIA_SEMANA_REG_RESOL_LIQ_ID INTEGER,
                            MES_REG_RESOL_LIQ_ID INTEGER,
                            TRIMESTRE_REG_RESOL_LIQ_ID INTEGER,
                            ANIO_REG_RESOL_LIQ_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_REG_RESOL_LIQ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SUB_EJEC_NOT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUB_EJEC_NOT_ANIO'',
						  ''ANIO_SUB_EJEC_NOT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SUB_EJEC_NOT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SUB_EJEC_NOT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUB_EJEC_NOT_DIA_SEMANA'',
						  ''DIA_SEMANA_SUB_EJEC_NOT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SUB_EJEC_NOT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SUB_EJEC_NOT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUB_EJEC_NOT_MES'',
						  ''MES_SUB_EJEC_NOT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SUB_EJEC_NOT_ID INTEGER,
                            TRIMESTRE_SUB_EJEC_NOT_ID INTEGER,
                            ANIO_SUB_EJEC_NOT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SUB_EJEC_NOT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SUB_EJEC_NOT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUB_EJEC_NOT_MES_ANIO'',
						  ''MES_ANIO_SUB_EJEC_NOT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SUB_EJEC_NOT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SUB_EJEC_NOT_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUB_EJEC_NOT_TRIMESTRE'',
						  ''TRIMESTRE_SUB_EJEC_NOT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SUB_EJEC_NOT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SUB_EJEC_NOT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SUB_EJEC_NOT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SUB_EJEC_NOT_DIA'',
						  ''DIA_SUB_EJEC_NOT_ID DATE NOT NULL,
                            DIA_SEMANA_SUB_EJEC_NOT_ID INTEGER,
                            MES_SUB_EJEC_NOT_ID INTEGER,
                            TRIMESTRE_SUB_EJEC_NOT_ID INTEGER,
                            ANIO_SUB_EJEC_NOT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SUB_EJEC_NOT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_TAREA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_TAREA_ANIO'',
						  ''ANIO_CREACION_TAREA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CREACION_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_TAREA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_TAREA_DIA_SEMANA'',
						  ''DIA_SEMANA_CREACION_TAREA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CREACION_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_TAREA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_TAREA_MES'',
						  ''MES_CREACION_TAREA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CREACION_TAREA_ID INTEGER,
                            TRIMESTRE_CREACION_TAREA_ID INTEGER,
                            ANIO_CREACION_TAREA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CREACION_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_TAREA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_TAREA_MES_ANIO'',
						  ''MES_ANIO_CREACION_TAREA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CREACION_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CREACION_TAREA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_TAREA_TRIMESTRE'',
						  ''TRIMESTRE_CREACION_TAREA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CREACION_TAREA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CREACION_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_TAREA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_TAREA_DIA'',
						  ''DIA_CREACION_TAREA_ID DATE NOT NULL,
                            DIA_SEMANA_CREACION_TAREA_ID INTEGER,
                            MES_CREACION_TAREA_ID INTEGER,
                            TRIMESTRE_CREACION_TAREA_ID INTEGER,
                            ANIO_CREACION_TAREA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CREACION_TAREA_ID, MES_CREACION_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FIN_TAREA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_TAREA_ANIO'',
						  ''ANIO_FIN_TAREA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FIN_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_FIN_TAREA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_TAREA_DIA_SEMANA'',
						  ''DIA_SEMANA_FIN_TAREA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FIN_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FIN_TAREA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_TAREA_MES'',
						  ''MES_FIN_TAREA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FIN_TAREA_ID INTEGER,
                            TRIMESTRE_FIN_TAREA_ID INTEGER,
                            ANIO_FIN_TAREA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FIN_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_FIN_TAREA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_TAREA_MES_ANIO'',
						  ''MES_ANIO_FIN_TAREA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FIN_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_FIN_TAREA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_TAREA_TRIMESTRE'',
						  ''TRIMESTRE_FIN_TAREA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FIN_TAREA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FIN_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FIN_TAREA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_TAREA_DIA'',
						  ''DIA_FIN_TAREA_ID DATE NOT NULL,
                            DIA_SEMANA_FIN_TAREA_ID INTEGER,
                            MES_FIN_TAREA_ID INTEGER,
                            TRIMESTRE_FIN_TAREA_ID INTEGER,
                            ANIO_FIN_TAREA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FIN_TAREA_ID, MES_FIN_TAREA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECOG_DOC_ACEPT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECOG_DOC_ACEPT_ANIO'',
						  ''ANIO_RECOG_DOC_ACEPT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_RECOG_DOC_ACEPT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RECOG_DOC_ACEPT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECOG_DOC_ACEPT_DIA_SEMANA'',
						  ''DIA_SEMANA_RECOG_DOC_ACEPT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_RECOG_DOC_ACEPT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECOG_DOC_ACEPT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECOG_DOC_ACEPT_MES'',
						  ''MES_RECOG_DOC_ACEPT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_RECOG_DOC_ACEPT_ID INTEGER,
                            TRIMESTRE_RECOG_DOC_ACEPT_ID INTEGER,
                            ANIO_RECOG_DOC_ACEPT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_RECOG_DOC_ACEPT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RECOG_DOC_ACEPT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECOG_DOC_ACEPT_MES_ANIO'',
						  ''MES_ANIO_RECOG_DOC_ACEPT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_RECOG_DOC_ACEPT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_RECOG_DOC_ACEPT_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECOG_DOC_ACEPT_TRIMESTRE'',
						  ''TRIMESTRE_RECOG_DOC_ACEPT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_RECOG_DOC_ACEPT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_RECOG_DOC_ACEPT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECOG_DOC_ACEPT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECOG_DOC_ACEPT_DIA'',
						  ''DIA_RECOG_DOC_ACEPT_ID DATE NOT NULL,
                            DIA_SEMANA_RECOG_DOC_ACEPT_ID INTEGER,
                            MES_RECOG_DOC_ACEPT_ID INTEGER,
                            TRIMESTRE_RECOG_DOC_ACEPT_ID INTEGER,
                            ANIO_RECOG_DOC_ACEPT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_RECOG_DOC_ACEPT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REG_DEC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_DEC_ANIO'',
						  ''ANIO_FECHA_REG_DEC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FECHA_REG_DEC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_REG_DEC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_DEC_DIA_SEMANA'',
						  ''DIA_SEMANA_FECHA_REG_DEC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FECHA_REG_DEC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REG_DEC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_DEC_MES'',
						  ''MES_FECHA_REG_DEC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FECHA_REG_DEC_ID INTEGER,
                            TRIMESTRE_FECHA_REG_DEC_ID INTEGER,
                            ANIO_FECHA_REG_DEC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FECHA_REG_DEC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_REG_DEC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_DEC_MES_ANIO'',
						  ''MES_ANIO_FECHA_REG_DEC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FECHA_REG_DEC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_REG_DEC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_DEC_TRIMESTRE'',
						  ''TRIMESTRE_FECHA_REG_DEC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FECHA_REG_DEC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FECHA_REG_DEC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REG_DEC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REG_DEC_DIA'',
						  ''DIA_FECHA_REG_DEC_ID DATE NOT NULL,
                            DIA_SEMANA_FECHA_REG_DEC_ID INTEGER,
                            MES_FECHA_REG_DEC_ID INTEGER,
                            TRIMESTRE_FECHA_REG_DEC_ID INTEGER,
                            ANIO_FECHA_REG_DEC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FECHA_REG_DEC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECEP_DOC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_DOC_ANIO'',
						  ''ANIO_FECHA_RECEP_DOC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FECHA_RECEP_DOC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RECEP_DOC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_DOC_DIA_SEMANA'',
						  ''DIA_SEMANA_FECHA_RECEP_DOC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FECHA_RECEP_DOC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECEP_DOC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_DOC_MES'',
						  ''MES_FECHA_RECEP_DOC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FECHA_RECEP_DOC_ID INTEGER,
                            TRIMESTRE_FECHA_RECEP_DOC_ID INTEGER,
                            ANIO_FECHA_RECEP_DOC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FECHA_RECEP_DOC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RECEP_DOC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_DOC_MES_ANIO'',
						  ''MES_ANIO_FECHA_RECEP_DOC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FECHA_RECEP_DOC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_RECEP_DOC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_DOC_TRIMESTRE'',
						  ''TRIMESTRE_FECHA_RECEP_DOC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FECHA_RECEP_DOC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FECHA_RECEP_DOC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECEP_DOC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_DOC_DIA'',
						  ''DIA_FECHA_RECEP_DOC_ID DATE NOT NULL,
                            DIA_SEMANA_FECHA_RECEP_DOC_ID INTEGER,
                            MES_FECHA_RECEP_DOC_ID INTEGER,
                            TRIMESTRE_FECHA_RECEP_DOC_ID INTEGER,
                            ANIO_FECHA_RECEP_DOC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FECHA_RECEP_DOC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CONT_LIT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONT_LIT_ANIO'',
						  ''ANIO_FECHA_CONT_LIT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FECHA_CONT_LIT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CONT_LIT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONT_LIT_DIA_SEMANA'',
						  ''DIA_SEMANA_FECHA_CONT_LIT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FECHA_CONT_LIT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CONT_LIT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONT_LIT_MES'',
						  ''MES_FECHA_CONT_LIT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FECHA_CONT_LIT_ID INTEGER,
                            TRIMESTRE_FECHA_CONT_LIT_ID INTEGER,
                            ANIO_FECHA_CONT_LIT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FECHA_CONT_LIT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CONT_LIT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONT_LIT_MES_ANIO'',
						  ''MES_ANIO_FECHA_CONT_LIT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FECHA_CONT_LIT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CONT_LIT_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONT_LIT_TRIMESTRE'',
						  ''TRIMESTRE_FECHA_CONT_LIT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FECHA_CONT_LIT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FECHA_CONT_LIT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CONT_LIT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONT_LIT_DIA'',
						  ''DIA_FECHA_CONT_LIT_ID DATE NOT NULL,
                            DIA_SEMANA_FECHA_CONT_LIT_ID INTEGER,
                            MES_FECHA_CONT_LIT_ID INTEGER,
                            TRIMESTRE_FECHA_CONT_LIT_ID INTEGER,
                            ANIO_FECHA_CONT_LIT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FECHA_CONT_LIT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DPS_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DPS_ANIO'',
						  ''ANIO_DPS_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_DPS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DPS_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DPS_DIA_SEMANA'',
						  ''DIA_SEMANA_DPS_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_DPS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DPS_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DPS_MES'',
						  ''MES_DPS_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_DPS_ID INTEGER,
                            TRIMESTRE_DPS_ID INTEGER,
                            ANIO_DPS_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_DPS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DPS_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DPS_MES_ANIO'',
						  ''MES_ANIO_DPS_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_DPS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_DPS_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DPS_TRIMESTRE'',
						  ''TRIMESTRE_DPS_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_DPS_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_DPS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DPS_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DPS_DIA'',
						  ''DIA_DPS_ID DATE NOT NULL,
                            DIA_SEMANA_DPS_ID INTEGER,
                            MES_DPS_ID INTEGER,
                            TRIMESTRE_DPS_ID INTEGER,
                            ANIO_DPS_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_DPS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_COMP_PAGO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COMP_PAGO_ANIO'',
						  ''ANIO_COMP_PAGO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_COMP_PAGO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_COMP_PAGO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COMP_PAGO_DIA_SEMANA'',
						  ''DIA_SEMANA_COMP_PAGO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_COMP_PAGO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_COMP_PAGO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COMP_PAGO_MES'',
						  ''MES_COMP_PAGO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_COMP_PAGO_ID INTEGER,
                            TRIMESTRE_COMP_PAGO_ID INTEGER,
                            ANIO_COMP_PAGO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_COMP_PAGO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_COMP_PAGO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COMP_PAGO_MES_ANIO'',
						  ''MES_ANIO_COMP_PAGO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_COMP_PAGO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_COMP_PAGO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COMP_PAGO_TRIMESTRE'',
						  ''TRIMESTRE_COMP_PAGO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_COMP_PAGO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_COMP_PAGO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_COMP_PAGO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_COMP_PAGO_DIA'',
						  ''DIA_COMP_PAGO_ID DATE NOT NULL,
                            DIA_SEMANA_COMP_PAGO_ID INTEGER,
                            MES_COMP_PAGO_ID INTEGER,
                            TRIMESTRE_COMP_PAGO_ID INTEGER,
                            ANIO_COMP_PAGO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_COMP_PAGO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ALTA_GEST_REC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_GEST_REC_ANIO'',
						  ''ANIO_ALTA_GEST_REC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ALTA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_GEST_REC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_GEST_REC_DIA_SEMANA'',
						  ''DIA_SEMANA_ALTA_GEST_REC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ALTA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ALTA_GEST_REC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_GEST_REC_MES'',
						  ''MES_ALTA_GEST_REC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ALTA_GEST_REC_ID INTEGER,
                            TRIMESTRE_ALTA_GEST_REC_ID INTEGER,
                            ANIO_ALTA_GEST_REC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ALTA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_GEST_REC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_GEST_REC_MES_ANIO'',
						  ''MES_ANIO_ALTA_GEST_REC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ALTA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ALTA_GEST_REC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_GEST_REC_TRIMESTRE'',
						  ''TRIMESTRE_ALTA_GEST_REC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ALTA_GEST_REC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ALTA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ALTA_GEST_REC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_GEST_REC_DIA'',
						  ''DIA_ALTA_GEST_REC_ID DATE NOT NULL,
                            DIA_SEMANA_ALTA_GEST_REC_ID INTEGER,
                            MES_ALTA_GEST_REC_ID INTEGER,
                            TRIMESTRE_ALTA_GEST_REC_ID INTEGER,
                            ANIO_ALTA_GEST_REC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ALTA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BAJA_GEST_REC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_GEST_REC_ANIO'',
						  ''ANIO_BAJA_GEST_REC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_BAJA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_GEST_REC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_GEST_REC_DIA_SEMANA'',
						  ''DIA_SEMANA_BAJA_GEST_REC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_BAJA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BAJA_GEST_REC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_GEST_REC_MES'',
						  ''MES_BAJA_GEST_REC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_BAJA_GEST_REC_ID INTEGER,
                            TRIMESTRE_BAJA_GEST_REC_ID INTEGER,
                            ANIO_BAJA_GEST_REC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_BAJA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_GEST_REC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_GEST_REC_MES_ANIO'',
						  ''MES_ANIO_BAJA_GEST_REC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_BAJA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_BAJA_GEST_REC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_GEST_REC_TRIMESTRE'',
						  ''TRIMESTRE_BAJA_GEST_REC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_BAJA_GEST_REC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_BAJA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BAJA_GEST_REC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_GEST_REC_DIA'',
						  ''DIA_BAJA_GEST_REC_ID DATE NOT NULL,
                            DIA_SEMANA_BAJA_GEST_REC_ID INTEGER,
                            MES_BAJA_GEST_REC_ID INTEGER,
                            TRIMESTRE_BAJA_GEST_REC_ID INTEGER,
                            ANIO_BAJA_GEST_REC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_BAJA_GEST_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACT_RECOBRO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACT_RECOBRO_ANIO'',
						  ''ANIO_ACT_RECOBRO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ACT_RECOBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACT_RECOBRO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACT_RECOBRO_DIA_SEMANA'',
						  ''DIA_SEMANA_ACT_RECOBRO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ACT_RECOBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACT_RECOBRO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACT_RECOBRO_MES'',
						  ''MES_ACT_RECOBRO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ACT_RECOBRO_ID INTEGER,
                            TRIMESTRE_ACT_RECOBRO_ID INTEGER,
                            ANIO_ACT_RECOBRO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ACT_RECOBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACT_RECOBRO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACT_RECOBRO_MES_ANIO'',
						  ''MES_ANIO_ACT_RECOBRO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ACT_RECOBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ACT_RECOBRO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACT_RECOBRO_TRIMESTRE'',
						  ''TRIMESTRE_ACT_RECOBRO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ACT_RECOBRO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ACT_RECOBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACT_RECOBRO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACT_RECOBRO_DIA'',
						  ''DIA_ACT_RECOBRO_ID DATE NOT NULL,
                            DIA_SEMANA_ACT_RECOBRO_ID INTEGER,
                            MES_ACT_RECOBRO_ID INTEGER,
                            TRIMESTRE_ACT_RECOBRO_ID INTEGER,
                            ANIO_ACT_RECOBRO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ACT_RECOBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PAGO_COMP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PAGO_COMP_ANIO'',
						  ''ANIO_PAGO_COMP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PAGO_COMP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PAGO_COMP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PAGO_COMP_DIA_SEMANA'',
						  ''DIA_SEMANA_PAGO_COMP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PAGO_COMP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PAGO_COMP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PAGO_COMP_MES'',
						  ''MES_PAGO_COMP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PAGO_COMP_ID INTEGER,
                            TRIMESTRE_PAGO_COMP_ID INTEGER,
                            ANIO_PAGO_COMP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PAGO_COMP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PAGO_COMP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PAGO_COMP_MES_ANIO'',
						  ''MES_ANIO_PAGO_COMP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PAGO_COMP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PAGO_COMP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PAGO_COMP_TRIMESTRE'',
						  ''TRIMESTRE_PAGO_COMP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PAGO_COMP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PAGO_COMP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PAGO_COMP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PAGO_COMP_DIA'',
						  ''DIA_PAGO_COMP_ID DATE NOT NULL,
                            DIA_SEMANA_PAGO_COMP_ID INTEGER,
                            MES_PAGO_COMP_ID INTEGER,
                            TRIMESTRE_PAGO_COMP_ID INTEGER,
                            ANIO_PAGO_COMP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PAGO_COMP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VENC_TAR_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VENC_TAR_ANIO'',
						  ''ANIO_VENC_TAR_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_VENC_TAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_VENC_TAR_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VENC_TAR_DIA_SEMANA'',
						  ''DIA_SEMANA_VENC_TAR_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_VENC_TAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VENC_TAR_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VENC_TAR_MES'',
						  ''MES_VENC_TAR_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_VENC_TAR_ID INTEGER,
                            TRIMESTRE_VENC_TAR_ID INTEGER,
                            ANIO_VENC_TAR_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_VENC_TAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_VENC_TAR_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VENC_TAR_MES_ANIO'',
						  ''MES_ANIO_VENC_TAR_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_VENC_TAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_VENC_TAR_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VENC_TAR_TRIMESTRE'',
						  ''TRIMESTRE_VENC_TAR_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_VENC_TAR_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_VENC_TAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_VENC_TAR_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_VENC_TAR_DIA'',
						  ''DIA_VENC_TAR_ID DATE NOT NULL,
                            DIA_SEMANA_VENC_TAR_ID INTEGER,
                            MES_VENC_TAR_ID INTEGER,
                            TRIMESTRE_VENC_TAR_ID INTEGER,
                            ANIO_VENC_TAR_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_VENC_TAR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CESION_REMATE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CESION_REMATE_ANIO'',
						  ''ANIO_CESION_REMATE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CESION_REMATE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CESION_REMATE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CESION_REMATE_DIA_SEMANA'',
						  ''DIA_SEMANA_CESION_REMATE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CESION_REMATE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CESION_REMATE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CESION_REMATE_MES'',
						  ''MES_CESION_REMATE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CESION_REMATE_ID INTEGER,
                            TRIMESTRE_CESION_REMATE_ID INTEGER,
                            ANIO_CESION_REMATE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CESION_REMATE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CESION_REMATE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CESION_REMATE_MES_ANIO'',
						  ''MES_ANIO_CESION_REMATE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CESION_REMATE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CESION_REMATE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CESION_REMATE_TRIMESTRE'',
						  ''TRIMESTRE_CESION_REMATE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CESION_REMATE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CESION_REMATE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CESION_REMATE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CESION_REMATE_DIA'',
						  ''DIA_CESION_REMATE_ID DATE NOT NULL,
                            DIA_SEMANA_CESION_REMATE_ID INTEGER,
                            MES_CESION_REMATE_ID INTEGER,
                            TRIMESTRE_CESION_REMATE_ID INTEGER,
                            ANIO_CESION_REMATE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CESION_REMATE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
   ------------------------------ D_F_CREACION_EXP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_EXP_ANIO'',
						  ''ANIO_CREACION_EXP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CREACION_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_EXP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_EXP_DIA_SEMANA'',
						  ''DIA_SEMANA_CREACION_EXP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CREACION_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_EXP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_EXP_MES'',
						  ''MES_CREACION_EXP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CREACION_EXP_ID INTEGER,
                            TRIMESTRE_CREACION_EXP_ID INTEGER,
                            ANIO_CREACION_EXP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CREACION_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_EXP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_EXP_MES_ANIO'',
						  ''MES_ANIO_CREACION_EXP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CREACION_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CREACION_EXP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_EXP_TRIMESTRE'',
						  ''TRIMESTRE_CREACION_EXP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CREACION_EXP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CREACION_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_EXP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_EXP_DIA'',
						  ''DIA_CREACION_EXP_ID DATE NOT NULL,
                            DIA_SEMANA_CREACION_EXP_ID INTEGER,
                            MES_CREACION_EXP_ID INTEGER,
                            TRIMESTRE_CREACION_EXP_ID INTEGER,
                            ANIO_CREACION_EXP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CREACION_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ROTURA_EXP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ROTURA_EXP_ANIO'',
						  ''ANIO_ROTURA_EXP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ROTURA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ROTURA_EXP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ROTURA_EXP_DIA_SEMANA'',
						  ''DIA_SEMANA_ROTURA_EXP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ROTURA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ROTURA_EXP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ROTURA_EXP_MES'',
						  ''MES_ROTURA_EXP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ROTURA_EXP_ID INTEGER,
                            TRIMESTRE_ROTURA_EXP_ID INTEGER,
                            ANIO_ROTURA_EXP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ROTURA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ROTURA_EXP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ROTURA_EXP_MES_ANIO'',
						  ''MES_ANIO_ROTURA_EXP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ROTURA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ROTURA_EXP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ROTURA_EXP_TRIMESTRE'',
						  ''TRIMESTRE_ROTURA_EXP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ROTURA_EXP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ROTURA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ROTURA_EXP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ROTURA_EXP_DIA'',
						  ''DIA_ROTURA_EXP_ID DATE NOT NULL,
                            DIA_SEMANA_ROTURA_EXP_ID INTEGER,
                            MES_ROTURA_EXP_ID INTEGER,
                            TRIMESTRE_ROTURA_EXP_ID INTEGER,
                            ANIO_ROTURA_EXP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ROTURA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_CNT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_CNT_ANIO'',
						  ''ANIO_CREACION_CNT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CREACION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_CNT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_CNT_DIA_SEMANA'',
						  ''DIA_SEMANA_CREACION_CNT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CREACION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_CNT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_CNT_MES'',
						  ''MES_CREACION_CNT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CREACION_CNT_ID INTEGER,
                            TRIMESTRE_CREACION_CNT_ID INTEGER,
                            ANIO_CREACION_CNT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CREACION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREACION_CNT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_CNT_MES_ANIO'',
						  ''MES_ANIO_CREACION_CNT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CREACION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CREACION_CNT_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_CNT_TRIMESTRE'',
						  ''TRIMESTRE_CREACION_CNT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CREACION_CNT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CREACION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREACION_CNT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREACION_CNT_DIA'',
						  ''DIA_CREACION_CNT_ID DATE NOT NULL,
                            DIA_SEMANA_CREACION_CNT_ID INTEGER,
                            MES_CREACION_CNT_ID INTEGER,
                            TRIMESTRE_CREACION_CNT_ID INTEGER,
                            ANIO_CREACION_CNT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CREACION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SAL_AGENCIA_EXP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SAL_AGENCIA_EXP_ANIO'',
						  ''ANIO_SAL_AGENCIA_EXP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SAL_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SAL_AGENCIA_EXP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SAL_AGENCIA_EXP_DIA_SEMANA'',
						  ''DIA_SEMANA_SAL_AGENCIA_EXP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SAL_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SAL_AGENCIA_EXP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SAL_AGENCIA_EXP_MES'',
						  ''MES_SAL_AGENCIA_EXP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SAL_AGENCIA_EXP_ID INTEGER,
                            TRIMESTRE_SAL_AGENCIA_EXP_ID INTEGER,
                            ANIO_SAL_AGENCIA_EXP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SAL_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SAL_AGENCIA_EXP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SAL_AGENCIA_EXP_MES_ANIO'',
						  ''MES_ANIO_SAL_AGENCIA_EXP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SAL_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SAL_AGENCIA_EXP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SAL_AGENCIA_EXP_TRIMESTRE'',
						  ''TRIMESTRE_SAL_AGENCIA_EXP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SAL_AGENCIA_EXP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SAL_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SAL_AGENCIA_EXP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SAL_AGENCIA_EXP_DIA'',
						  ''DIA_SAL_AGENCIA_EXP_ID DATE NOT NULL,
                            DIA_SEMANA_SAL_AGENCIA_EXP_ID INTEGER,
                            MES_SAL_AGENCIA_EXP_ID INTEGER,
                            TRIMESTRE_SAL_AGENCIA_EXP_ID INTEGER,
                            ANIO_SAL_AGENCIA_EXP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SAL_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_OFREC_PROP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_OFREC_PROP_ANIO'',
						  ''ANIO_OFREC_PROP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_OFREC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_OFREC_PROP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_OFREC_PROP_DIA_SEMANA'',
						  ''DIA_SEMANA_OFREC_PROP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_OFREC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_OFREC_PROP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_OFREC_PROP_MES'',
						  ''MES_OFREC_PROP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_OFREC_PROP_ID INTEGER,
                            TRIMESTRE_OFREC_PROP_ID INTEGER,
                            ANIO_OFREC_PROP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_OFREC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_OFREC_PROP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_OFREC_PROP_MES_ANIO'',
						  ''MES_ANIO_OFREC_PROP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_OFREC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_OFREC_PROP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_OFREC_PROP_TRIMESTRE'',
						  ''TRIMESTRE_OFREC_PROP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_OFREC_PROP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_OFREC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_OFREC_PROP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_OFREC_PROP_DIA'',
						  ''DIA_OFREC_PROP_ID DATE NOT NULL,
                            DIA_SEMANA_OFREC_PROP_ID INTEGER,
                            MES_OFREC_PROP_ID INTEGER,
                            TRIMESTRE_OFREC_PROP_ID INTEGER,
                            ANIO_OFREC_PROP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_OFREC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FORM_PROPUESTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FORM_PROPUESTA_ANIO'',
						  ''ANIO_FORM_PROPUESTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FORM_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_FORM_PROPUESTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FORM_PROPUESTA_DIA_SEMANA'',
						  ''DIA_SEMANA_FORM_PROPUESTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FORM_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FORM_PROPUESTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FORM_PROPUESTA_MES'',
						  ''MES_FORM_PROPUESTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FORM_PROPUESTA_ID INTEGER,
                            TRIMESTRE_FORM_PROPUESTA_ID INTEGER,
                            ANIO_FORM_PROPUESTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FORM_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_FORM_PROPUESTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FORM_PROPUESTA_MES_ANIO'',
						  ''MES_ANIO_FORM_PROPUESTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FORM_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_FORM_PROPUESTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FORM_PROPUESTA_TRIMESTRE'',
						  ''TRIMESTRE_FORM_PROPUESTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FORM_PROPUESTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FORM_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FORM_PROPUESTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FORM_PROPUESTA_DIA'',
						  ''DIA_FORM_PROPUESTA_ID DATE NOT NULL,
                            DIA_SEMANA_FORM_PROPUESTA_ID INTEGER,
                            MES_FORM_PROPUESTA_ID INTEGER,
                            TRIMESTRE_FORM_PROPUESTA_ID INTEGER,
                            ANIO_FORM_PROPUESTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FORM_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SANCION_PROP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SANCION_PROP_ANIO'',
						  ''ANIO_SANCION_PROP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SANCION_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SANCION_PROP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SANCION_PROP_DIA_SEMANA'',
						  ''DIA_SEMANA_SANCION_PROP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SANCION_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SANCION_PROP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SANCION_PROP_MES'',
						  ''MES_SANCION_PROP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SANCION_PROP_ID INTEGER,
                            TRIMESTRE_SANCION_PROP_ID INTEGER,
                            ANIO_SANCION_PROP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SANCION_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SANCION_PROP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SANCION_PROP_MES_ANIO'',
						  ''MES_ANIO_SANCION_PROP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SANCION_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SANCION_PROP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SANCION_PROP_TRIMESTRE'',
						  ''TRIMESTRE_SANCION_PROP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SANCION_PROP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SANCION_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SANCION_PROP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SANCION_PROP_DIA'',
						  ''DIA_SANCION_PROP_ID DATE NOT NULL,
                            DIA_SEMANA_SANCION_PROP_ID INTEGER,
                            MES_SANCION_PROP_ID INTEGER,
                            TRIMESTRE_SANCION_PROP_ID INTEGER,
                            ANIO_SANCION_PROP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SANCION_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACTIVACION_INCI_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACTIVACION_INCI_ANIO'',
						  ''ANIO_ACTIVACION_INCI_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ACTIVACION_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACTIVACION_INCI_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACTIVACION_INCI_DIA_SEMANA'',
						  ''DIA_SEMANA_ACTIVACION_INCI_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ACTIVACION_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACTIVACION_INCI_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACTIVACION_INCI_MES'',
						  ''MES_ACTIVACION_INCI_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ACTIVACION_INCI_ID INTEGER,
                            TRIMESTRE_ACTIVACION_INCI_ID INTEGER,
                            ANIO_ACTIVACION_INCI_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ACTIVACION_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACTIVACION_INCI_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACTIVACION_INCI_MES_ANIO'',
						  ''MES_ANIO_ACTIVACION_INCI_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ACTIVACION_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ACTIVACION_INCI_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACTIVACION_INCI_TRIMESTRE'',
						  ''TRIMESTRE_ACTIVACION_INCI_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ACTIVACION_INCI_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ACTIVACION_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACTIVACION_INCI_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACTIVACION_INCI_DIA'',
						  ''DIA_ACTIVACION_INCI_ID DATE NOT NULL,
                            DIA_SEMANA_ACTIVACION_INCI_ID INTEGER,
                            MES_ACTIVACION_INCI_ID INTEGER,
                            TRIMESTRE_ACTIVACION_INCI_ID INTEGER,
                            ANIO_ACTIVACION_INCI_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ACTIVACION_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RESOL_INCI_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_INCI_ANIO'',
						  ''ANIO_RESOL_INCI_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_RESOL_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RESOL_INCI_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_INCI_DIA_SEMANA'',
						  ''DIA_SEMANA_RESOL_INCI_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_RESOL_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RESOL_INCI_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_INCI_MES'',
						  ''MES_RESOL_INCI_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_RESOL_INCI_ID INTEGER,
                            TRIMESTRE_RESOL_INCI_ID INTEGER,
                            ANIO_RESOL_INCI_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_RESOL_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RESOL_INCI_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_INCI_MES_ANIO'',
						  ''MES_ANIO_RESOL_INCI_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_RESOL_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_RESOL_INCI_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_INCI_TRIMESTRE'',
						  ''TRIMESTRE_RESOL_INCI_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_RESOL_INCI_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_RESOL_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RESOL_INCI_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RESOL_INCI_DIA'',
						  ''DIA_RESOL_INCI_ID DATE NOT NULL,
                            DIA_SEMANA_RESOL_INCI_ID INTEGER,
                            MES_RESOL_INCI_ID INTEGER,
                            TRIMESTRE_RESOL_INCI_ID INTEGER,
                            ANIO_RESOL_INCI_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_RESOL_INCI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ELEV_COMITE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ELEV_COMITE_ANIO'',
						  ''ANIO_ELEV_COMITE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ELEV_COMITE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ELEV_COMITE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ELEV_COMITE_DIA_SEMANA'',
						  ''DIA_SEMANA_ELEV_COMITE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ELEV_COMITE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ELEV_COMITE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ELEV_COMITE_MES'',
						  ''MES_ELEV_COMITE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ELEV_COMITE_ID INTEGER,
                            TRIMESTRE_ELEV_COMITE_ID INTEGER,
                            ANIO_ELEV_COMITE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ELEV_COMITE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ELEV_COMITE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ELEV_COMITE_MES_ANIO'',
						  ''MES_ANIO_ELEV_COMITE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ELEV_COMITE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ELEV_COMITE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ELEV_COMITE_TRIMESTRE'',
						  ''TRIMESTRE_ELEV_COMITE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ELEV_COMITE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ELEV_COMITE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ELEV_COMITE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ELEV_COMITE_DIA'',
						  ''DIA_ELEV_COMITE_ID DATE NOT NULL,
                            DIA_SEMANA_ELEV_COMITE_ID INTEGER,
                            MES_ELEV_COMITE_ID INTEGER,
                            TRIMESTRE_ELEV_COMITE_ID INTEGER,
                            ANIO_ELEV_COMITE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ELEV_COMITE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULTIMO_COBRO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULTIMO_COBRO_ANIO'',
						  ''ANIO_ULTIMO_COBRO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ULTIMO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULTIMO_COBRO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULTIMO_COBRO_DIA_SEMANA'',
						  ''DIA_SEMANA_ULTIMO_COBRO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ULTIMO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULTIMO_COBRO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULTIMO_COBRO_MES'',
						  ''MES_ULTIMO_COBRO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ULTIMO_COBRO_ID INTEGER,
                            TRIMESTRE_ULTIMO_COBRO_ID INTEGER,
                            ANIO_ULTIMO_COBRO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ULTIMO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ULTIMO_COBRO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULTIMO_COBRO_MES_ANIO'',
						  ''MES_ANIO_ULTIMO_COBRO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ULTIMO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ULTIMO_COBRO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULTIMO_COBRO_TRIMESTRE'',
						  ''TRIMESTRE_ULTIMO_COBRO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ULTIMO_COBRO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ULTIMO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ULTIMO_COBRO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULTIMO_COBRO_DIA'',
						  ''DIA_ULTIMO_COBRO_ID DATE NOT NULL,
                            DIA_SEMANA_ULTIMO_COBRO_ID INTEGER,
                            MES_ULTIMO_COBRO_ID INTEGER,
                            TRIMESTRE_ULTIMO_COBRO_ID INTEGER,
                            ANIO_ULTIMO_COBRO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ULTIMO_COBRO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ENT_AGENCIA_EXP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ENT_AGENCIA_EXP_ANIO'',
						  ''ANIO_ENT_AGENCIA_EXP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ENT_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ENT_AGENCIA_EXP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ENT_AGENCIA_EXP_DIA_SEMANA'',
						  ''DIA_SEMANA_ENT_AGENCIA_EXP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ENT_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ENT_AGENCIA_EXP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ENT_AGENCIA_EXP_MES'',
						  ''MES_ENT_AGENCIA_EXP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ENT_AGENCIA_EXP_ID INTEGER,
                            TRIMESTRE_ENT_AGENCIA_EXP_ID INTEGER,
                            ANIO_ENT_AGENCIA_EXP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ENT_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ENT_AGENCIA_EXP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ENT_AGENCIA_EXP_MES_ANIO'',
						  ''MES_ANIO_ENT_AGENCIA_EXP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ENT_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ENT_AGENCIA_EXP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ENT_AGENCIA_EXP_TRIMESTRE'',
						  ''TRIMESTRE_ENT_AGENCIA_EXP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ENT_AGENCIA_EXP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ENT_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ENT_AGENCIA_EXP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ENT_AGENCIA_EXP_DIA'',
						  ''DIA_ENT_AGENCIA_EXP_ID DATE NOT NULL,
                            DIA_SEMANA_ENT_AGENCIA_EXP_ID INTEGER,
                            MES_ENT_AGENCIA_EXP_ID INTEGER,
                            TRIMESTRE_ENT_AGENCIA_EXP_ID INTEGER,
                            ANIO_ENT_AGENCIA_EXP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ENT_AGENCIA_EXP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


  ------------------------------ D_F_ALTA_CICLO_REC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_CICLO_REC_ANIO'',
						  ''ANIO_ALTA_CICLO_REC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ALTA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_CICLO_REC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_CICLO_REC_DIA_SEMANA'',
						  ''DIA_SEMANA_ALTA_CICLO_REC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ALTA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_CICLO_REC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_CICLO_REC_MES'',
						  ''MES_ALTA_CICLO_REC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ALTA_CICLO_REC_ID INTEGER,
                            TRIMESTRE_ALTA_CICLO_REC_ID INTEGER,
                            ANIO_ALTA_CICLO_REC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ALTA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_CICLO_REC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_CICLO_REC_MES_ANIO'',
						  ''MES_ANIO_ALTA_CICLO_REC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ALTA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_CICLO_REC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_CICLO_REC_TRIMESTRE'',
						  ''TRIMESTRE_ALTA_CICLO_REC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ALTA_CICLO_REC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ALTA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_CICLO_REC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_CICLO_REC_DIA'',
						  ''DIA_ALTA_CICLO_REC_ID DATE NOT NULL,
                            DIA_SEMANA_ALTA_CICLO_REC_ID INTEGER,
                            MES_ALTA_CICLO_REC_ID INTEGER,
                            TRIMESTRE_ALTA_CICLO_REC_ID INTEGER,
                            ANIO_ALTA_CICLO_REC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ALTA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_BAJA_CICLO_REC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_CICLO_REC_ANIO'',
						  ''ANIO_BAJA_CICLO_REC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_BAJA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_CICLO_REC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_CICLO_REC_DIA_SEMANA'',
						  ''DIA_SEMANA_BAJA_CICLO_REC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_BAJA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_CICLO_REC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_CICLO_REC_MES'',
						  ''MES_BAJA_CICLO_REC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_BAJA_CICLO_REC_ID INTEGER,
                            TRIMESTRE_BAJA_CICLO_REC_ID INTEGER,
                            ANIO_BAJA_CICLO_REC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_BAJA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_CICLO_REC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_CICLO_REC_MES_ANIO'',
						  ''MES_ANIO_BAJA_CICLO_REC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_BAJA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_CICLO_REC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_CICLO_REC_TRIMESTRE'',
						  ''TRIMESTRE_BAJA_CICLO_REC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_BAJA_CICLO_REC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_BAJA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_CICLO_REC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_CICLO_REC_DIA'',
						  ''DIA_BAJA_CICLO_REC_ID DATE NOT NULL,
                            DIA_SEMANA_BAJA_CICLO_REC_ID INTEGER,
                            MES_BAJA_CICLO_REC_ID INTEGER,
                            TRIMESTRE_BAJA_CICLO_REC_ID INTEGER,
                            ANIO_BAJA_CICLO_REC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_BAJA_CICLO_REC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ALTA_EXP_CR_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_EXP_CR_ANIO'',
						  ''ANIO_ALTA_EXP_CR_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ALTA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_EXP_CR_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_EXP_CR_DIA_SEMANA'',
						  ''DIA_SEMANA_ALTA_EXP_CR_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ALTA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_EXP_CR_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_EXP_CR_MES'',
						  ''MES_ALTA_EXP_CR_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ALTA_EXP_CR_ID INTEGER,
                            TRIMESTRE_ALTA_EXP_CR_ID INTEGER,
                            ANIO_ALTA_EXP_CR_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ALTA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_EXP_CR_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_EXP_CR_MES_ANIO'',
						  ''MES_ANIO_ALTA_EXP_CR_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ALTA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ALTA_EXP_CR_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_EXP_CR_TRIMESTRE'',
						  ''TRIMESTRE_ALTA_EXP_CR_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ALTA_EXP_CR_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ALTA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_ALTA_EXP_CR_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_EXP_CR_DIA'',
						  ''DIA_ALTA_EXP_CR_ID DATE NOT NULL,
                            DIA_SEMANA_ALTA_EXP_CR_ID INTEGER,
                            MES_ALTA_EXP_CR_ID INTEGER,
                            TRIMESTRE_ALTA_EXP_CR_ID INTEGER,
                            ANIO_ALTA_EXP_CR_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ALTA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_BAJA_EXP_CR_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_EXP_CR_ANIO'',
						  ''ANIO_BAJA_EXP_CR_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_BAJA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_EXP_CR_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_EXP_CR_DIA_SEMANA'',
						  ''DIA_SEMANA_BAJA_EXP_CR_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_BAJA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_EXP_CR_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_EXP_CR_MES'',
						  ''MES_BAJA_EXP_CR_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_BAJA_EXP_CR_ID INTEGER,
                            TRIMESTRE_BAJA_EXP_CR_ID INTEGER,
                            ANIO_BAJA_EXP_CR_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_BAJA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_EXP_CR_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_EXP_CR_MES_ANIO'',
						  ''MES_ANIO_BAJA_EXP_CR_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_BAJA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_EXP_CR_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_EXP_CR_TRIMESTRE'',
						  ''TRIMESTRE_BAJA_EXP_CR_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_BAJA_EXP_CR_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_BAJA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BAJA_EXP_CR_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_EXP_CR_DIA'',
						  ''DIA_BAJA_EXP_CR_ID DATE NOT NULL,
                            DIA_SEMANA_BAJA_EXP_CR_ID INTEGER,
                            MES_BAJA_EXP_CR_ID INTEGER,
                            TRIMESTRE_BAJA_EXP_CR_ID INTEGER,
                            ANIO_BAJA_EXP_CR_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_BAJA_EXP_CR_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_MEJOR_GESTION_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MEJOR_GESTION_ANIO'',
						  ''ANIO_MEJOR_GESTION_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_MEJOR_GESTION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_MEJOR_GESTION_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MEJOR_GESTION_DIA_SEMANA'',
						  ''DIA_SEMANA_MEJOR_GESTION_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_MEJOR_GESTION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_MEJOR_GESTION_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MEJOR_GESTION_MES'',
						  ''MES_MEJOR_GESTION_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_MEJOR_GESTION_ID INTEGER,
                            TRIMESTRE_MEJOR_GESTION_ID INTEGER,
                            ANIO_MEJOR_GESTION_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_MEJOR_GESTION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_MEJOR_GESTION_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MEJOR_GESTION_MES_ANIO'',
						  ''MES_ANIO_MEJOR_GESTION_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_MEJOR_GESTION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_MEJOR_GESTION_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MEJOR_GESTION_TRIMESTRE'',
						  ''TRIMESTRE_MEJOR_GESTION_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_MEJOR_GESTION_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_MEJOR_GESTION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_MEJOR_GESTION_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_MEJOR_GESTION_DIA'',
						  ''DIA_MEJOR_GESTION_ID DATE NOT NULL,
                            DIA_SEMANA_MEJOR_GESTION_ID INTEGER,
                            MES_MEJOR_GESTION_ID INTEGER,
                            TRIMESTRE_MEJOR_GESTION_ID INTEGER,
                            ANIO_MEJOR_GESTION_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_MEJOR_GESTION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PROPUESTA_ACU_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PROPUESTA_ACU_ANIO'',
						  ''ANIO_PROPUESTA_ACU_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PROPUESTA_ACU_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PROPUESTA_ACU_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PROPUESTA_ACU_DIA_SEMANA'',
						  ''DIA_SEMANA_PROPUESTA_ACU_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PROPUESTA_ACU_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
    ------------------------------ D_F_PROPUESTA_ACU_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PROPUESTA_ACU_MES'',
						  ''MES_PROPUESTA_ACU_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PROPUESTA_ACU_ID INTEGER,
                            TRIMESTRE_PROPUESTA_ACU_ID INTEGER,
                            ANIO_PROPUESTA_ACU_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PROPUESTA_ACU_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

------------------------------ D_F_PROPUESTA_ACU_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PROPUESTA_ACU_MES_ANIO'',
						  ''MES_ANIO_PROPUESTA_ACU_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PROPUESTA_ACU_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PROPUESTA_ACU_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PROPUESTA_ACU_TRIMESTRE'',
						  ''TRIMESTRE_PROPUESTA_ACU_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PROPUESTA_ACU_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PROPUESTA_ACU_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PROPUESTA_ACU_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PROPUESTA_ACU_DIA'',
						  ''DIA_PROPUESTA_ACU_ID DATE NOT NULL,
                            DIA_SEMANA_PROPUESTA_ACU_ID INTEGER,
                            MES_PROPUESTA_ACU_ID INTEGER,
                            TRIMESTRE_PROPUESTA_ACU_ID INTEGER,
                            ANIO_PROPUESTA_ACU_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PROPUESTA_ACU_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

    ------------------------------ D_F_INCIDENCIA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INCIDENCIA_ANIO'',
						  ''ANIO_INCIDENCIA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INCIDENCIA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INCIDENCIA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INCIDENCIA_DIA_SEMANA'',
						  ''DIA_SEMANA_INCIDENCIA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INCIDENCIA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INCIDENCIA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INCIDENCIA_MES'',
						  ''MES_INCIDENCIA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INCIDENCIA_ID INTEGER,
                            TRIMESTRE_INCIDENCIA_ID INTEGER,
                            ANIO_INCIDENCIA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INCIDENCIA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INCIDENCIA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INCIDENCIA_MES_ANIO'',
						  ''MES_ANIO_INCIDENCIA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INCIDENCIA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INCIDENCIA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INCIDENCIA_TRIMESTRE'',
						  ''TRIMESTRE_INCIDENCIA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INCIDENCIA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INCIDENCIA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_INCIDENCIA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INCIDENCIA_DIA'',
						  ''DIA_INCIDENCIA_ID DATE NOT NULL,
                            DIA_SEMANA_INCIDENCIA_ID INTEGER,
                            MES_INCIDENCIA_ID INTEGER,
                            TRIMESTRE_INCIDENCIA_ID INTEGER,
                            ANIO_INCIDENCIA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INCIDENCIA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CANCELA_ASUNTO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CANCELA_ASUNTO_ANIO'',
						  ''ANIO_CANCELA_ASUNTO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CANCELA_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CANCELA_ASUNTO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CANCELA_ASUNTO_DIA_SEMANA'',
						  ''DIA_SEMANA_CANCELA_ASUNTO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CANCELA_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CANCELA_ASUNTO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CANCELA_ASUNTO_MES'',
						  ''MES_CANCELA_ASUNTO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CANCELA_ASUNTO_ID INTEGER,
                            TRIMESTRE_CANCELA_ASUNTO_ID INTEGER,
                            ANIO_CANCELA_ASUNTO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CANCELA_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CANCELA_ASUNTO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CANCELA_ASUNTO_MES_ANIO'',
						  ''MES_ANIO_CANCELA_ASUNTO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CANCELA_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CANCELA_ASUNTO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CANCELA_ASUNTO_TRIMESTRE'',
						  ''TRIMESTRE_CANCELA_ASUNTO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CANCELA_ASUNTO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CANCELA_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CANCELA_ASUNTO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CANCELA_ASUNTO_DIA'',
						  ''DIA_CANCELA_ASUNTO_ID DATE NOT NULL,
                            DIA_SEMANA_CANCELA_ASUNTO_ID INTEGER,
                            MES_CANCELA_ASUNTO_ID INTEGER,
                            TRIMESTRE_CANCELA_ASUNTO_ID INTEGER,
                            ANIO_CANCELA_ASUNTO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CANCELA_ASUNTO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


   ------------------------------ D_F_CREDITO_INSI_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREDITO_INSI_ANIO'',
						  ''ANIO_CREDITO_INSI_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CREDITO_INSI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREDITO_INSI_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREDITO_INSI_DIA_SEMANA'',
						  ''DIA_SEMANA_CREDITO_INSI_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CREDITO_INSI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREDITO_INSI_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREDITO_INSI_MES'',
						  ''MES_CREDITO_INSI_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CREDITO_INSI_ID INTEGER,
                            TRIMESTRE_CREDITO_INSI_ID INTEGER,
                            ANIO_CREDITO_INSI_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CREDITO_INSI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CREDITO_INSI_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREDITO_INSI_MES_ANIO'',
						  ''MES_ANIO_CREDITO_INSI_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CREDITO_INSI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CREDITO_INSI_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREDITO_INSI_TRIMESTRE'',
						  ''TRIMESTRE_CREDITO_INSI_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CREDITO_INSI_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CREDITO_INSI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CREDITO_INSI_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CREDITO_INSI_DIA'',
						  ''DIA_CREDITO_INSI_ID DATE NOT NULL,
                            DIA_SEMANA_CREDITO_INSI_ID INTEGER,
                            MES_CREDITO_INSI_ID INTEGER,
                            TRIMESTRE_CREDITO_INSI_ID INTEGER,
                            ANIO_CREDITO_INSI_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CREDITO_INSI_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SOLIC_SUBASTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOLIC_SUBASTA_ANIO'',
						  ''ANIO_SOLIC_SUBASTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SOLIC_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SOLIC_SUBASTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOLIC_SUBASTA_DIA_SEMANA'',
						  ''DIA_SEMANA_SOLIC_SUBASTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SOLIC_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SOLIC_SUBASTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOLIC_SUBASTA_MES'',
						  ''MES_SOLIC_SUBASTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SOLIC_SUBASTA_ID INTEGER,
                            TRIMESTRE_SOLIC_SUBASTA_ID INTEGER,
                            ANIO_SOLIC_SUBASTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SOLIC_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SOLIC_SUBASTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOLIC_SUBASTA_MES_ANIO'',
						  ''MES_ANIO_SOLIC_SUBASTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SOLIC_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SOLIC_SUBASTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOLIC_SUBASTA_TRIMESTRE'',
						  ''TRIMESTRE_SOLIC_SUBASTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SOLIC_SUBASTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SOLIC_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SOLIC_SUBASTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOLIC_SUBASTA_DIA'',
						  ''DIA_SOLIC_SUBASTA_ID DATE NOT NULL,
                            DIA_SEMANA_SOLIC_SUBASTA_ID INTEGER,
                            MES_SOLIC_SUBASTA_ID INTEGER,
                            TRIMESTRE_SOLIC_SUBASTA_ID INTEGER,
                            ANIO_SOLIC_SUBASTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SOLIC_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CELEB_SUBASTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CELEB_SUBASTA_ANIO'',
						  ''ANIO_CELEB_SUBASTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CELEB_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CELEB_SUBASTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CELEB_SUBASTA_DIA_SEMANA'',
						  ''DIA_SEMANA_CELEB_SUBASTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CELEB_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CELEB_SUBASTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CELEB_SUBASTA_MES'',
						  ''MES_CELEB_SUBASTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CELEB_SUBASTA_ID INTEGER,
                            TRIMESTRE_CELEB_SUBASTA_ID INTEGER,
                            ANIO_CELEB_SUBASTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CELEB_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CELEB_SUBASTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CELEB_SUBASTA_MES_ANIO'',
						  ''MES_ANIO_CELEB_SUBASTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CELEB_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_CELEB_SUBASTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CELEB_SUBASTA_TRIMESTRE'',
						  ''TRIMESTRE_CELEB_SUBASTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CELEB_SUBASTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CELEB_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CELEB_SUBASTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CELEB_SUBASTA_DIA'',
						  ''DIA_CELEB_SUBASTA_ID DATE NOT NULL,
                            DIA_SEMANA_CELEB_SUBASTA_ID INTEGER,
                            MES_CELEB_SUBASTA_ID INTEGER,
                            TRIMESTRE_CELEB_SUBASTA_ID INTEGER,
                            ANIO_CELEB_SUBASTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CELEB_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 ------------------------------ D_F_PARALIZACION_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PARALIZACION_ANIO'',
						  ''ANIO_PARALIZACION_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PARALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PARALIZACION_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PARALIZACION_DIA_SEMANA'',
						  ''DIA_SEMANA_PARALIZACION_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PARALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PARALIZACION_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PARALIZACION_MES'',
						  ''MES_PARALIZACION_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PARALIZACION_ID INTEGER,
                            TRIMESTRE_PARALIZACION_ID INTEGER,
                            ANIO_PARALIZACION_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PARALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PARALIZACION_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PARALIZACION_MES_ANIO'',
						  ''MES_ANIO_PARALIZACION_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PARALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PARALIZACION_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PARALIZACION_TRIMESTRE'',
						  ''TRIMESTRE_PARALIZACION_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PARALIZACION_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PARALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PARALIZACION_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PARALIZACION_DIA'',
						  ''DIA_PARALIZACION_ID DATE NOT NULL,
                            DIA_SEMANA_PARALIZACION_ID INTEGER,
                            MES_PARALIZACION_ID INTEGER,
                            TRIMESTRE_PARALIZACION_ID INTEGER,
                            ANIO_PARALIZACION_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PARALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_FINALIZACION_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FINALIZACION_ANIO'',
						  ''ANIO_FINALIZACION_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FINALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_FINALIZACION_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FINALIZACION_DIA_SEMANA'',
						  ''DIA_SEMANA_FINALIZACION_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FINALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FINALIZACION_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FINALIZACION_MES'',
						  ''MES_FINALIZACION_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FINALIZACION_ID INTEGER,
                            TRIMESTRE_FINALIZACION_ID INTEGER,
                            ANIO_FINALIZACION_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FINALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_FINALIZACION_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FINALIZACION_MES_ANIO'',
						  ''MES_ANIO_FINALIZACION_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FINALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_FINALIZACION_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FINALIZACION_TRIMESTRE'',
						  ''TRIMESTRE_FINALIZACION_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FINALIZACION_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FINALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_FINALIZACION_DIA ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FINALIZACION_DIA'',
						  ''DIA_FINALIZACION_ID DATE NOT NULL,
                            DIA_SEMANA_FINALIZACION_ID INTEGER,
                            MES_FINALIZACION_ID INTEGER,
                            TRIMESTRE_FINALIZACION_ID INTEGER,
                            ANIO_FINALIZACION_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FINALIZACION_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_ACUERDO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACUERDO_ANIO'',
						  ''ANIO_ACUERDO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ACUERDO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACUERDO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACUERDO_DIA_SEMANA'',
						  ''DIA_SEMANA_ACUERDO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ACUERDO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACUERDO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACUERDO_MES'',
						  ''MES_ACUERDO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ACUERDO_ID INTEGER,
                            TRIMESTRE_ACUERDO_ID INTEGER,
                            ANIO_ACUERDO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ACUERDO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_ACUERDO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACUERDO_MES_ANIO'',
						  ''MES_ANIO_ACUERDO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ACUERDO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
  ------------------------------ D_F_ACUERDO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACUERDO_TRIMESTRE'',
						  ''TRIMESTRE_ACUERDO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ACUERDO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ACUERDO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_ACUERDO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ACUERDO_DIA'',
						  ''DIA_ACUERDO_ID DATE NOT NULL,
                            DIA_SEMANA_ACUERDO_ID INTEGER,
                            MES_ACUERDO_ID INTEGER,
                            TRIMESTRE_ACUERDO_ID INTEGER,
                            ANIO_ACUERDO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ACUERDO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
 ------------------------------ D_F_DECRETO_ADJ_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_ADJ_ANIO'',
						  ''ANIO_DECRETO_ADJ_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DECRETO_ADJ_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_ADJ_DIA_SEMANA'',
						  ''DIA_SEMANA_DECRETO_ADJ_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
   ------------------------------ D_F_DECRETO_ADJ_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_ADJ_MES'',
						  ''MES_DECRETO_ADJ_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_DECRETO_ADJ_ID INTEGER,
                            TRIMESTRE_DECRETO_ADJ_ID INTEGER,
                            ANIO_DECRETO_ADJ_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DECRETO_ADJ_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_ADJ_MES_ANIO'',
						  ''MES_ANIO_DECRETO_ADJ_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_DECRETO_ADJ_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_ADJ_TRIMESTRE'',
						  ''TRIMESTRE_DECRETO_ADJ_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_DECRETO_ADJ_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DECRETO_ADJ_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DECRETO_ADJ_DIA'',
						  ''DIA_DECRETO_ADJ_ID DATE NOT NULL,
                            DIA_SEMANA_DECRETO_ADJ_ID INTEGER,
                            MES_DECRETO_ADJ_ID INTEGER,
                            TRIMESTRE_DECRETO_ADJ_ID INTEGER,
                            ANIO_DECRETO_ADJ_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 ------------------------------ D_F_SOL_DECRETO_ADJ_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_DECRETO_ADJ_ANIO'',
						  ''ANIO_SOL_DECRETO_ADJ_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SOL_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SOL_DECRETO_ADJ_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_DECRETO_ADJ_DIA_SEMANA'',
						  ''DIA_SEMANA_SOL_DECRETO_ADJ_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SOL_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SOL_DECRETO_ADJ_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_DECRETO_ADJ_MES'',
						  ''MES_SOL_DECRETO_ADJ_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SOL_DECRETO_ADJ_ID INTEGER,
                            TRIMESTRE_SOL_DECRETO_ADJ_ID INTEGER,
                            ANIO_SOL_DECRETO_ADJ_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SOL_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_SOL_DECRETO_ADJ_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_DECRETO_ADJ_MES_ANIO'',
						  ''MES_ANIO_SOL_DECRETO_ADJ_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SOL_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SOL_DECRETO_ADJ_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_DECRETO_ADJ_TRIMESTRE'',
						  ''TRIMESTRE_SOL_DECRETO_ADJ_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SOL_DECRETO_ADJ_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SOL_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_SOL_DECRETO_ADJ_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_DECRETO_ADJ_DIA'',
						  ''DIA_SOL_DECRETO_ADJ_ID DATE NOT NULL,
                            DIA_SEMANA_SOL_DECRETO_ADJ_ID INTEGER,
                            MES_SOL_DECRETO_ADJ_ID INTEGER,
                            TRIMESTRE_SOL_DECRETO_ADJ_ID INTEGER,
                            ANIO_SOL_DECRETO_ADJ_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SOL_DECRETO_ADJ_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


 ------------------------------ D_F_RECEP_TESTIMO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_TESTIMO_ANIO'',
						  ''ANIO_RECEP_TESTIMO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_RECEP_TESTIMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RECEP_TESTIMO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_TESTIMO_DIA_SEMANA'',
						  ''DIA_SEMANA_RECEP_TESTIMO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_RECEP_TESTIMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECEP_TESTIMO_MES ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_TESTIMO_MES'',
						  ''MES_RECEP_TESTIMO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_RECEP_TESTIMO_ID INTEGER,
                            TRIMESTRE_RECEP_TESTIMO_ID INTEGER,
                            ANIO_RECEP_TESTIMO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_RECEP_TESTIMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_RECEP_TESTIMO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_TESTIMO_MES_ANIO'',
						  ''MES_ANIO_RECEP_TESTIMO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_RECEP_TESTIMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_RECEP_TESTIMO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_TESTIMO_TRIMESTRE'',
						  ''TRIMESTRE_RECEP_TESTIMO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_RECEP_TESTIMO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_RECEP_TESTIMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_RECEP_TESTIMO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_RECEP_TESTIMO_DIA'',
						  ''DIA_RECEP_TESTIMO_ID DATE NOT NULL,
                            DIA_SEMANA_RECEP_TESTIMO_ID INTEGER,
                            MES_RECEP_TESTIMO_ID INTEGER,
                            TRIMESTRE_RECEP_TESTIMO_ID INTEGER,
                            ANIO_RECEP_TESTIMO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_RECEP_TESTIMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 ------------------------------ D_F_PUBLICACION_BOE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PUBLICACION_BOE_ANIO'',
						  ''ANIO_PUBLICACION_BOE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PUBLICACION_BOE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PUBLICACION_BOE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PUBLICACION_BOE_DIA_SEMANA'',
						  ''DIA_SEMANA_PUBLICACION_BOE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PUBLICACION_BOE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PUBLICACION_BOE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PUBLICACION_BOE_MES'',
						  ''MES_PUBLICACION_BOE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PUBLICACION_BOE_ID INTEGER,
                            TRIMESTRE_PUBLICACION_BOE_ID INTEGER,
                            ANIO_PUBLICACION_BOE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PUBLICACION_BOE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PUBLICACION_BOE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PUBLICACION_BOE_MES_ANIO'',
						  ''MES_ANIO_PUBLICACION_BOE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PUBLICACION_BOE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
  ------------------------------ D_F_PUBLICACION_BOE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PUBLICACION_BOE_TRIMESTRE'',
						  ''TRIMESTRE_PUBLICACION_BOE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PUBLICACION_BOE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PUBLICACION_BOE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PUBLICACION_BOE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PUBLICACION_BOE_DIA'',
						  ''DIA_PUBLICACION_BOE_ID DATE NOT NULL,
                            DIA_SEMANA_PUBLICACION_BOE_ID INTEGER,
                            MES_PUBLICACION_BOE_ID INTEGER,
                            TRIMESTRE_PUBLICACION_BOE_ID INTEGER,
                            ANIO_PUBLICACION_BOE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PUBLICACION_BOE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

 ------------------------------ D_F_REGISTRAR_IAC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REGISTRAR_IAC_ANIO'',
						  ''ANIO_REGISTRAR_IAC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_REGISTRAR_IAC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_REGISTRAR_IAC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REGISTRAR_IAC_DIA_SEMANA'',
						  ''DIA_SEMANA_REGISTRAR_IAC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_REGISTRAR_IAC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REGISTRAR_IAC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REGISTRAR_IAC_MES'',
						  ''MES_REGISTRAR_IAC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_REGISTRAR_IAC_ID INTEGER,
                            TRIMESTRE_REGISTRAR_IAC_ID INTEGER,
                            ANIO_REGISTRAR_IAC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_REGISTRAR_IAC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_REGISTRAR_IAC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REGISTRAR_IAC_MES_ANIO'',
						  ''MES_ANIO_REGISTRAR_IAC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_REGISTRAR_IAC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_REGISTRAR_IAC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REGISTRAR_IAC_TRIMESTRE'',
						  ''TRIMESTRE_REGISTRAR_IAC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_REGISTRAR_IAC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_REGISTRAR_IAC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_REGISTRAR_IAC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_REGISTRAR_IAC_DIA'',
						  ''DIA_REGISTRAR_IAC_ID DATE NOT NULL,
                            DIA_SEMANA_REGISTRAR_IAC_ID INTEGER,
                            MES_REGISTRAR_IAC_ID INTEGER,
                            TRIMESTRE_REGISTRAR_IAC_ID INTEGER,
                            ANIO_REGISTRAR_IAC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_REGISTRAR_IAC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_INICIO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_INICIO_ANIO'',
						  ''ANIO_PRE_INICIO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_INICIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_INICIO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_INICIO_TRIMESTRE'',
						  ''TRIMESTRE_PRE_INICIO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_INICIO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_INICIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_INICIO_MES_ANIO ------------------------------
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_INICIO_MES_ANIO'',
						  ''MES_ANIO_PRE_INICIO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_INICIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_INICIO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_INICIO_MES'',
						  ''MES_PRE_INICIO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_INICIO_ID INTEGER,
                            TRIMESTRE_PRE_INICIO_ID INTEGER,
                            ANIO_PRE_INICIO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_INICIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_INICIO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_INICIO_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_INICIO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_INICIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_INICIO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_INICIO_DIA'',
						  ''DIA_PRE_INICIO_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_INICIO_ID INTEGER,
                            MES_PRE_INICIO_ID INTEGER,
                            TRIMESTRE_PRE_INICIO_ID INTEGER,
                            ANIO_PRE_INICIO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_INICIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ESTUDIO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ESTUDIO_ANIO'',
						  ''ANIO_PRE_ESTUDIO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_ESTUDIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_ESTUDIO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ESTUDIO_TRIMESTRE'',
						  ''TRIMESTRE_PRE_ESTUDIO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_ESTUDIO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_ESTUDIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ESTUDIO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ESTUDIO_MES_ANIO'',
						  ''MES_ANIO_PRE_ESTUDIO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_ESTUDIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_ESTUDIO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ESTUDIO_MES'',
						  ''MES_PRE_ESTUDIO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_ESTUDIO_ID INTEGER,
                            TRIMESTRE_PRE_ESTUDIO_ID INTEGER,
                            ANIO_PRE_ESTUDIO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_ESTUDIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ESTUDIO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ESTUDIO_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_ESTUDIO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_ESTUDIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_ESTUDIO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ESTUDIO_DIA'',
						  ''DIA_PRE_ESTUDIO_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_ESTUDIO_ID INTEGER,
                            MES_PRE_ESTUDIO_ID INTEGER,
                            TRIMESTRE_PRE_ESTUDIO_ID INTEGER,
                            ANIO_PRE_ESTUDIO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_ESTUDIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_PREPARADO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PREPARADO_ANIO'',
						  ''ANIO_PRE_PREPARADO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_PREPARADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_PREPARADO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PREPARADO_TRIMESTRE'',
						  ''TRIMESTRE_PRE_PREPARADO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_PREPARADO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_PREPARADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_PREPARADO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PREPARADO_MES_ANIO'',
						  ''MES_ANIO_PRE_PREPARADO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_PREPARADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_PREPARADO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PREPARADO_MES'',
						  ''MES_PRE_PREPARADO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_PREPARADO_ID INTEGER,
                            TRIMESTRE_PRE_PREPARADO_ID INTEGER,
                            ANIO_PRE_PREPARADO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_PREPARADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
    ------------------------------ D_F_PRE_PREPARADO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PREPARADO_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_PREPARADO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_PREPARADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_PREPARADO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PREPARADO_DIA'',
						  ''DIA_PRE_PREPARADO_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_PREPARADO_ID INTEGER,
                            MES_PRE_PREPARADO_ID INTEGER,
                            TRIMESTRE_PRE_PREPARADO_ID INTEGER,
                            ANIO_PRE_PREPARADO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_PREPARADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
   
    ------------------------------ D_F_PRE_ENV_LET_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ENV_LET_ANIO'',
						  ''ANIO_PRE_ENV_LET_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_ENV_LET_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_ENV_LET_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ENV_LET_TRIMESTRE'',
						  ''TRIMESTRE_PRE_ENV_LET_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_ENV_LET_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_ENV_LET_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ENV_LET_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ENV_LET_MES_ANIO'',
						  ''MES_ANIO_PRE_ENV_LET_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_ENV_LET_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_ENV_LET_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ENV_LET_MES'',
						  ''MES_PRE_ENV_LET_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_ENV_LET_ID INTEGER,
                            TRIMESTRE_PRE_ENV_LET_ID INTEGER,
                            ANIO_PRE_ENV_LET_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_ENV_LET_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ENV_LET_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ENV_LET_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_ENV_LET_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_ENV_LET_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_ENV_LET_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ENV_LET_DIA'',
						  ''DIA_PRE_ENV_LET_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_ENV_LET_ID INTEGER,
                            MES_PRE_ENV_LET_ID INTEGER,
                            TRIMESTRE_PRE_ENV_LET_ID INTEGER,
                            ANIO_PRE_ENV_LET_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_ENV_LET_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
    
    ------------------------------ D_F_PRE_FINALIZADO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_FINALIZADO_ANIO'',
						  ''ANIO_PRE_FINALIZADO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_FINALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_FINALIZADO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_FINALIZADO_TRIMESTRE'',
						  ''TRIMESTRE_PRE_FINALIZADO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_FINALIZADO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_FINALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_PREPARADO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_FINALIZADO_MES_ANIO'',
						  ''MES_ANIO_PRE_FINALIZADO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_FINALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_FINALIZADO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_FINALIZADO_MES'',
						  ''MES_PRE_FINALIZADO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_FINALIZADO_ID INTEGER,
                            TRIMESTRE_PRE_FINALIZADO_ID INTEGER,
                            ANIO_PRE_FINALIZADO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_FINALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_FINALIZADO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_FINALIZADO_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_FINALIZADO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_FINALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_FINALIZADO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_FINALIZADO_DIA'',
						  ''DIA_PRE_FINALIZADO_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_FINALIZADO_ID INTEGER,
                            MES_PRE_FINALIZADO_ID INTEGER,
                            TRIMESTRE_PRE_FINALIZADO_ID INTEGER,
                            ANIO_PRE_FINALIZADO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_FINALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ULT_SUBS_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ULT_SUBS_ANIO'',
						  ''ANIO_PRE_ULT_SUBS_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_ULT_SUBS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_ULT_SUBS_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ULT_SUBS_TRIMESTRE'',
						  ''TRIMESTRE_PRE_ULT_SUBS_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_ULT_SUBS_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_ULT_SUBS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ULT_SUBS_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ULT_SUBS_MES_ANIO'',
						  ''MES_ANIO_PRE_ULT_SUBS_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_ULT_SUBS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_ULT_SUBS_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ULT_SUBS_MES'',
						  ''MES_PRE_ULT_SUBS_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_ULT_SUBS_ID INTEGER,
                            TRIMESTRE_PRE_ULT_SUBS_ID INTEGER,
                            ANIO_PRE_ULT_SUBS_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_ULT_SUBS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_ULT_SUBS_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ULT_SUBS_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_ULT_SUBS_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_ULT_SUBS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_ULT_SUBS_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_ULT_SUBS_DIA'',
						  ''DIA_PRE_ULT_SUBS_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_ULT_SUBS_ID INTEGER,
                            MES_PRE_ULT_SUBS_ID INTEGER,
                            TRIMESTRE_PRE_ULT_SUBS_ID INTEGER,
                            ANIO_PRE_ULT_SUBS_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_ULT_SUBS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_CANCELADO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_CANCELADO_ANIO'',
						  ''ANIO_PRE_CANCELADO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_CANCELADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_CANCELADO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_CANCELADO_TRIMESTRE'',
						  ''TRIMESTRE_PRE_CANCELADO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_CANCELADO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_CANCELADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_CANCELADO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_CANCELADO_MES_ANIO'',
						  ''MES_ANIO_PRE_CANCELADO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_CANCELADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_FINALIZADO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_CANCELADO_MES'',
						  ''MES_PRE_CANCELADO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_CANCELADO_ID INTEGER,
                            TRIMESTRE_PRE_CANCELADO_ID INTEGER,
                            ANIO_PRE_CANCELADO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_CANCELADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_CANCELADO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_CANCELADO_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_CANCELADO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_CANCELADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_CANCELADO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_CANCELADO_DIA'',
						  ''DIA_PRE_CANCELADO_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_CANCELADO_ID INTEGER,
                            MES_PRE_CANCELADO_ID INTEGER,
                            TRIMESTRE_PRE_CANCELADO_ID INTEGER,
                            ANIO_PRE_CANCELADO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_CANCELADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_PARALIZADO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PARALIZADO_ANIO'',
						  ''ANIO_PRE_PARALIZADO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PRE_PARALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PRE_PARALIZADO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PARALIZADO_TRIMESTRE'',
						  ''TRIMESTRE_PRE_PARALIZADO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PRE_PARALIZADO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PRE_PARALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_PARALIZADO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PARALIZADO_MES_ANIO'',
						  ''MES_ANIO_PRE_PARALIZADO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PRE_PARALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_PARALIZADO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PARALIZADO_MES'',
						  ''MES_PRE_PARALIZADO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PRE_PARALIZADO_ID INTEGER,
                            TRIMESTRE_PRE_PARALIZADO_ID INTEGER,
                            ANIO_PRE_PARALIZADO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PRE_PARALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_PRE_PARALIZADO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PARALIZADO_DIA_SEMANA'',
						  ''DIA_SEMANA_PRE_PARALIZADO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PRE_PARALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_PRE_PARALIZADO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PRE_PARALIZADO_DIA'',
						  ''DIA_PRE_PARALIZADO_ID DATE NOT NULL,
                            DIA_SEMANA_PRE_PARALIZADO_ID INTEGER,
                            MES_PRE_PARALIZADO_ID INTEGER,
                            TRIMESTRE_PRE_PARALIZADO_ID INTEGER,
                            ANIO_PRE_PARALIZADO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PRE_PARALIZADO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_SOLICITUD_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_SOLICITUD_ANIO'',
						  ''ANIO_BURO_SOLICITUD_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_BURO_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_BURO_SOLICITUD_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_SOLICITUD_TRIMESTRE'',
						  ''TRIMESTRE_BURO_SOLICITUD_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_BURO_SOLICITUD_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_BURO_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_SOLICITUD_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_SOLICITUD_MES_ANIO'',
						  ''MES_ANIO_BURO_SOLICITUD_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_BURO_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BURO_SOLICITUD_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_SOLICITUD_MES'',
						  ''MES_BURO_SOLICITUD_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_BURO_SOLICITUD_ID INTEGER,
                            TRIMESTRE_BURO_SOLICITUD_ID INTEGER,
                            ANIO_BURO_SOLICITUD_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_BURO_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_SOLICITUD_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_SOLICITUD_DIA_SEMANA'',
						  ''DIA_SEMANA_BURO_SOLICITUD_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_BURO_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BURO_SOLICITUD_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_SOLICITUD_DIA'',
						  ''DIA_BURO_SOLICITUD_ID DATE NOT NULL,
                            DIA_SEMANA_BURO_SOLICITUD_ID INTEGER,
                            MES_BURO_SOLICITUD_ID INTEGER,
                            TRIMESTRE_BURO_SOLICITUD_ID INTEGER,
                            ANIO_BURO_SOLICITUD_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_BURO_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_ENVIO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ENVIO_ANIO'',
						  ''ANIO_BURO_ENVIO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_BURO_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
  ------------------------------ D_F_BURO_ENVIO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ENVIO_TRIMESTRE'',
						  ''TRIMESTRE_BURO_ENVIO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_BURO_ENVIO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_BURO_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_ENVIO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ENVIO_MES_ANIO'',
						  ''MES_ANIO_BURO_ENVIO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_BURO_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BURO_ENVIO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ENVIO_MES'',
						  ''MES_BURO_ENVIO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_BURO_ENVIO_ID INTEGER,
                            TRIMESTRE_BURO_ENVIO_ID INTEGER,
                            ANIO_BURO_ENVIO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_BURO_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_ENVIO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ENVIO_DIA_SEMANA'',
						  ''DIA_SEMANA_BURO_ENVIO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_BURO_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BURO_ENVIO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ENVIO_DIA'',
						  ''DIA_BURO_ENVIO_ID DATE NOT NULL,
                            DIA_SEMANA_BURO_ENVIO_ID INTEGER,
                            MES_BURO_ENVIO_ID INTEGER,
                            TRIMESTRE_BURO_ENVIO_ID INTEGER,
                            ANIO_BURO_ENVIO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_BURO_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_ACUSE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ACUSE_ANIO'',
						  ''ANIO_BURO_ACUSE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_BURO_ACUSE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_BURO_ACUSE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ACUSE_TRIMESTRE'',
						  ''TRIMESTRE_BURO_ACUSE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_BURO_ACUSE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_BURO_ACUSE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_ACUSE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ACUSE_MES_ANIO'',
						  ''MES_ANIO_BURO_ACUSE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_BURO_ACUSE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BURO_ACUSE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ACUSE_MES'',
						  ''MES_BURO_ACUSE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_BURO_ACUSE_ID INTEGER,
                            TRIMESTRE_BURO_ACUSE_ID INTEGER,
                            ANIO_BURO_ACUSE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_BURO_ACUSE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_BURO_ACUSE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ACUSE_DIA_SEMANA'',
						  ''DIA_SEMANA_BURO_ACUSE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_BURO_ACUSE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BURO_ACUSE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BURO_ACUSE_DIA'',
						  ''DIA_BURO_ACUSE_ID DATE NOT NULL,
                            DIA_SEMANA_BURO_ACUSE_ID INTEGER,
                            MES_BURO_ACUSE_ID INTEGER,
                            TRIMESTRE_BURO_ACUSE_ID INTEGER,
                            ANIO_BURO_ACUSE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_BURO_ACUSE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_SOLICITUD_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_SOLICITUD_ANIO'',
						  ''ANIO_DOC_SOLICITUD_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_DOC_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_DOC_SOLICITUD_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_SOLICITUD_TRIMESTRE'',
						  ''TRIMESTRE_DOC_SOLICITUD_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_DOC_SOLICITUD_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_DOC_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_SOLICITUD_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_SOLICITUD_MES_ANIO'',
						  ''MES_ANIO_DOC_SOLICITUD_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_DOC_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DOC_SOLICITUD_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_SOLICITUD_MES'',
						  ''MES_DOC_SOLICITUD_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_DOC_SOLICITUD_ID INTEGER,
                            TRIMESTRE_DOC_SOLICITUD_ID INTEGER,
                            ANIO_DOC_SOLICITUD_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_DOC_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_SOLICITUD_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_SOLICITUD_DIA_SEMANA'',
						  ''DIA_SEMANA_DOC_SOLICITUD_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_DOC_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DOC_SOLICITUD_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_SOLICITUD_DIA'',
						  ''DIA_DOC_SOLICITUD_ID DATE NOT NULL,
                            DIA_SEMANA_DOC_SOLICITUD_ID INTEGER,
                            MES_DOC_SOLICITUD_ID INTEGER,
                            TRIMESTRE_DOC_SOLICITUD_ID INTEGER,
                            ANIO_DOC_SOLICITUD_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_DOC_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_ENVIO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_ENVIO_ANIO'',
						  ''ANIO_DOC_ENVIO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_DOC_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_DOC_ENVIO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_ENVIO_TRIMESTRE'',
						  ''TRIMESTRE_DOC_ENVIO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_DOC_ENVIO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_DOC_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_ENVIO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_ENVIO_MES_ANIO'',
						  ''MES_ANIO_DOC_ENVIO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_DOC_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_BURO_ENVIO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_ENVIO_MES'',
						  ''MES_DOC_ENVIO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_DOC_ENVIO_ID INTEGER,
                            TRIMESTRE_DOC_ENVIO_ID INTEGER,
                            ANIO_DOC_ENVIO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_DOC_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_ENVIO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_ENVIO_DIA_SEMANA'',
						  ''DIA_SEMANA_DOC_ENVIO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_DOC_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DOC_ENVIO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_ENVIO_DIA'',
						  ''DIA_DOC_ENVIO_ID DATE NOT NULL,
                            DIA_SEMANA_DOC_ENVIO_ID INTEGER,
                            MES_DOC_ENVIO_ID INTEGER,
                            TRIMESTRE_DOC_ENVIO_ID INTEGER,
                            ANIO_DOC_ENVIO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_DOC_ENVIO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_RESULT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RESULT_ANIO'',
						  ''ANIO_DOC_RESULT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_DOC_RESULT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_DOC_RESULT_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RESULT_TRIMESTRE'',
						  ''TRIMESTRE_DOC_RESULT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_DOC_RESULT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_DOC_RESULT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_RESULT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RESULT_MES_ANIO'',
						  ''MES_ANIO_DOC_RESULT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_DOC_RESULT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DOC_RESULT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RESULT_MES'',
						  ''MES_DOC_RESULT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_DOC_RESULT_ID INTEGER,
                            TRIMESTRE_DOC_RESULT_ID INTEGER,
                            ANIO_DOC_RESULT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_DOC_RESULT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_RESULT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RESULT_DIA_SEMANA'',
						  ''DIA_SEMANA_DOC_RESULT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_DOC_RESULT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DOC_RESULT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RESULT_DIA'',
						  ''DIA_DOC_RESULT_ID DATE NOT NULL,
                            DIA_SEMANA_DOC_RESULT_ID INTEGER,
                            MES_DOC_RESULT_ID INTEGER,
                            TRIMESTRE_DOC_RESULT_ID INTEGER,
                            ANIO_DOC_RESULT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_DOC_RESULT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_RECEP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RECEP_ANIO'',
						  ''ANIO_DOC_RECEP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_DOC_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_DOC_RECEP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RECEP_TRIMESTRE'',
						  ''TRIMESTRE_DOC_RECEP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_DOC_RECEP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_DOC_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_RECEP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RECEP_MES_ANIO'',
						  ''MES_ANIO_DOC_RECEP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_DOC_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DOC_RECEP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RECEP_MES'',
						  ''MES_DOC_RECEP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_DOC_RECEP_ID INTEGER,
                            TRIMESTRE_DOC_RECEP_ID INTEGER,
                            ANIO_DOC_RECEP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_DOC_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_DOC_RECEP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RECEP_DIA_SEMANA'',
						  ''DIA_SEMANA_DOC_RECEP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_DOC_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_DOC_RECEP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_DOC_RECEP_DIA'',
						  ''DIA_DOC_RECEP_ID DATE NOT NULL,
                            DIA_SEMANA_DOC_RECEP_ID INTEGER,
                            MES_DOC_RECEP_ID INTEGER,
                            TRIMESTRE_DOC_RECEP_ID INTEGER,
                            ANIO_DOC_RECEP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_DOC_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
    
    ------------------------------ D_F_LIQ_SOLICITUD_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_SOLICITUD_ANIO'',
						  ''ANIO_LIQ_SOLICITUD_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_LIQ_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_LIQ_SOLICITUD_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_SOLICITUD_TRIMESTRE'',
						  ''TRIMESTRE_LIQ_SOLICITUD_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_LIQ_SOLICITUD_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_LIQ_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_SOLICITUD_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_SOLICITUD_MES_ANIO'',
						  ''MES_ANIO_LIQ_SOLICITUD_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_LIQ_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_SOLICITUD_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_SOLICITUD_MES'',
						  ''MES_LIQ_SOLICITUD_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_LIQ_SOLICITUD_ID INTEGER,
                            TRIMESTRE_LIQ_SOLICITUD_ID INTEGER,
                            ANIO_LIQ_SOLICITUD_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_LIQ_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_SOLICITUD_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_SOLICITUD_DIA_SEMANA'',
						  ''DIA_SEMANA_LIQ_SOLICITUD_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_LIQ_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_SOLICITUD_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_SOLICITUD_DIA'',
						  ''DIA_LIQ_SOLICITUD_ID DATE NOT NULL,
                            DIA_SEMANA_LIQ_SOLICITUD_ID INTEGER,
                            MES_LIQ_SOLICITUD_ID INTEGER,
                            TRIMESTRE_LIQ_SOLICITUD_ID INTEGER,
                            ANIO_LIQ_SOLICITUD_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_LIQ_SOLICITUD_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
    
    ------------------------------ D_F_LIQ_RECEP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_RECEP_ANIO'',
						  ''ANIO_LIQ_RECEP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_LIQ_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_LIQ_RECEP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_RECEP_TRIMESTRE'',
						  ''TRIMESTRE_LIQ_RECEP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_LIQ_RECEP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_LIQ_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_RECEP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_RECEP_MES_ANIO'',
						  ''MES_ANIO_LIQ_RECEP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_LIQ_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_RECEP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_RECEP_MES'',
						  ''MES_LIQ_RECEP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_LIQ_RECEP_ID INTEGER,
                            TRIMESTRE_LIQ_RECEP_ID INTEGER,
                            ANIO_LIQ_RECEP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_LIQ_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_RECEP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_RECEP_DIA_SEMANA'',
						  ''DIA_SEMANA_LIQ_RECEP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_LIQ_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_RECEP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_RECEP_DIA'',
						  ''DIA_LIQ_RECEP_ID DATE NOT NULL,
                            DIA_SEMANA_LIQ_RECEP_ID INTEGER,
                            MES_LIQ_RECEP_ID INTEGER,
                            TRIMESTRE_LIQ_RECEP_ID INTEGER,
                            ANIO_LIQ_RECEP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_LIQ_RECEP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
    
    ------------------------------ D_F_LIQ_CONFIRM_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CONFIRM_ANIO'',
						  ''ANIO_LIQ_CONFIRM_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_LIQ_CONFIRM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_LIQ_CONFIRM_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CONFIRM_TRIMESTRE'',
						  ''TRIMESTRE_LIQ_CONFIRM_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_LIQ_CONFIRM_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_LIQ_CONFIRM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_CONFIRM_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CONFIRM_MES_ANIO'',
						  ''MES_ANIO_LIQ_CONFIRM_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_LIQ_CONFIRM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_CONFIRM_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CONFIRM_MES'',
						  ''MES_LIQ_CONFIRM_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_LIQ_CONFIRM_ID INTEGER,
                            TRIMESTRE_LIQ_CONFIRM_ID INTEGER,
                            ANIO_LIQ_CONFIRM_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_LIQ_CONFIRM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_CONFIRM_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CONFIRM_DIA_SEMANA'',
						  ''DIA_SEMANA_LIQ_CONFIRM_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_LIQ_CONFIRM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_CONFIRM_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CONFIRM_DIA'',
						  ''DIA_LIQ_CONFIRM_ID DATE NOT NULL,
                            DIA_SEMANA_LIQ_CONFIRM_ID INTEGER,
                            MES_LIQ_CONFIRM_ID INTEGER,
                            TRIMESTRE_LIQ_CONFIRM_ID INTEGER,
                            ANIO_LIQ_CONFIRM_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_LIQ_CONFIRM_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
    
    ------------------------------ D_F_LIQ_RECEP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CIERRE_ANIO'',
						  ''ANIO_LIQ_CIERRE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_LIQ_CIERRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_LIQ_CIERRE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CIERRE_TRIMESTRE'',
						  ''TRIMESTRE_LIQ_CIERRE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_LIQ_CIERRE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_LIQ_CIERRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_CIERRE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CIERRE_MES_ANIO'',
						  ''MES_ANIO_LIQ_CIERRE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_LIQ_CIERRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_CIERRE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CIERRE_MES'',
						  ''MES_LIQ_CIERRE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_LIQ_CIERRE_ID INTEGER,
                            TRIMESTRE_LIQ_CIERRE_ID INTEGER,
                            ANIO_LIQ_CIERRE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_LIQ_CIERRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_LIQ_CIERRE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CIERRE_DIA_SEMANA'',
						  ''DIA_SEMANA_LIQ_CIERRE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_LIQ_CIERRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_LIQ_CIERRE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LIQ_CIERRE_DIA'',
						  ''DIA_LIQ_CIERRE_ID DATE NOT NULL,
                            DIA_SEMANA_LIQ_CIERRE_ID INTEGER,
                            MES_LIQ_CIERRE_ID INTEGER,
                            TRIMESTRE_LIQ_CIERRE_ID INTEGER,
                            ANIO_LIQ_CIERRE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_LIQ_CIERRE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;





    ------------------------------ D_F_CONCESION_CNT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONCESION_CNT_ANIO'',
						  ''ANIO_CONCESION_CNT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CONCESION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


  ------------------------------ D_F_CONCESION_CNT_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONCESION_CNT_TRIMESTRE'',
						  ''TRIMESTRE_CONCESION_CNT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CONCESION_CNT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CONCESION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_CONCESION_CNT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONCESION_CNT_MES_ANIO'',
						  ''MES_ANIO_CONCESION_CNT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CONCESION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


   ------------------------------ D_F_CONCESION_CNT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONCESION_CNT_MES'',
						  ''MES_CONCESION_CNT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CONCESION_CNT_ID INTEGER,
                            TRIMESTRE_CONCESION_CNT_ID INTEGER,
                            ANIO_CONCESION_CNT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CONCESION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_CONCESION_CNT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONCESION_CNT_DIA_SEMANA'',
						  ''DIA_SEMANA_CONCESION_CNT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CONCESION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


   ------------------------------ D_F_CONCESION_CNT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONCESION_CNT_DIA'',
						  ''DIA_CONCESION_CNT_ID DATE NOT NULL,
                            DIA_SEMANA_CONCESION_CNT_ID INTEGER,
                            MES_CONCESION_CNT_ID INTEGER,
                            TRIMESTRE_CONCESION_CNT_ID INTEGER,
                            ANIO_CONCESION_CNT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CONCESION_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CONSTI_CNT_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONSTI_CNT_ANIO'',
						  ''ANIO_CONSTI_CNT_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CONSTI_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


  ------------------------------ D_F_CONSTI_CNT_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONSTI_CNT_TRIMESTRE'',
						  ''TRIMESTRE_CONSTI_CNT_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CONSTI_CNT_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CONSTI_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CONSTI_CNT_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONSTI_CNT_MES_ANIO'',
						  ''MES_ANIO_CONSTI_CNT_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CONSTI_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CONSTI_CNT_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONSTI_CNT_MES'',
						  ''MES_CONSTI_CNT_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CONSTI_CNT_ID INTEGER,
                            TRIMESTRE_CONSTI_CNT_ID INTEGER,
                            ANIO_CONSTI_CNT_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CONSTI_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------ D_F_CONSTI_CNT_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONSTI_CNT_DIA_SEMANA'',
						  ''DIA_SEMANA_CONSTI_CNT_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CONSTI_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------ D_F_CONSTI_CNT_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CONSTI_CNT_DIA'',
						  ''DIA_CONSTI_CNT_ID DATE NOT NULL,
                            DIA_SEMANA_CONSTI_CNT_ID INTEGER,
                            MES_CONSTI_CNT_ID INTEGER,
                            TRIMESTRE_CONSTI_CNT_ID INTEGER,
                            ANIO_CONSTI_CNT_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CONSTI_CNT_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
    
   ------------------------------  D_F_SOL_SUBASTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_SUBASTA_ANIO'',
						  ''ANIO_SOL_SUBASTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SOL_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_SOL_SUBASTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_SUBASTA_DIA_SEMANA'',
						  ''DIA_SEMANA_SOL_SUBASTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SOL_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



------------------------------ D_F_SOL_SUBASTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_SUBASTA_DIA'',
						  ''DIA_SOL_SUBASTA_ID DATE NOT NULL,
                            DIA_SEMANA_SOL_SUBASTA_ID INTEGER,
                            MES_SOL_SUBASTA_ID INTEGER,
                            TRIMESTRE_SOL_SUBASTA_ID INTEGER,
                            ANIO_SOL_SUBASTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SOL_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_SOL_SUBASTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_SUBASTA_MES'',
						  ''MES_SOL_SUBASTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SOL_SUBASTA_ID INTEGER,
                            TRIMESTRE_SOL_SUBASTA_ID INTEGER,
                            ANIO_SOL_SUBASTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SOL_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_SOL_SUBASTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_SUBASTA_MES_ANIO'',
						  ''MES_ANIO_SOL_SUBASTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SOL_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SOL_SUBASTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_SUBASTA_TRIMESTRE'',
						  ''TRIMESTRE_SOL_SUBASTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SOL_SUBASTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SOL_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



   ------------------------------  D_F_ANUN_SUBASTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANUN_SUBASTA_ANIO'',
						  ''ANIO_ANUN_SUBASTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ANUN_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_ANUN_SUBASTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANUN_SUBASTA_DIA_SEMANA'',
						  ''DIA_SEMANA_ANUN_SUBASTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ANUN_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



------------------------------ D_F_ANUN_SUBASTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANUN_SUBASTA_DIA'',
						  ''DIA_ANUN_SUBASTA_ID DATE NOT NULL,
                            DIA_SEMANA_ANUN_SUBASTA_ID INTEGER,
                            MES_ANUN_SUBASTA_ID INTEGER,
                            TRIMESTRE_ANUN_SUBASTA_ID INTEGER,
                            ANIO_ANUN_SUBASTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ANUN_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_ANUN_SUBASTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANUN_SUBASTA_MES'',
						  ''MES_ANUN_SUBASTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ANUN_SUBASTA_ID INTEGER,
                            TRIMESTRE_ANUN_SUBASTA_ID INTEGER,
                            ANIO_ANUN_SUBASTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANUN_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_ANUN_SUBASTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANUN_SUBASTA_MES_ANIO'',
						  ''MES_ANIO_ANUN_SUBASTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ANUN_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ANUN_SUBASTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANUN_SUBASTA_TRIMESTRE'',
						  ''TRIMESTRE_ANUN_SUBASTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ANUN_SUBASTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ANUN_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



   ------------------------------  D_F_SE_SUBASTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SE_SUBASTA_ANIO'',
						  ''ANIO_SE_SUBASTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SE_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_SE_SUBASTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SE_SUBASTA_DIA_SEMANA'',
						  ''DIA_SEMANA_SE_SUBASTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SE_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



------------------------------ D_F_SE_SUBASTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SE_SUBASTA_DIA'',
						  ''DIA_SE_SUBASTA_ID DATE NOT NULL,
                            DIA_SEMANA_SE_SUBASTA_ID INTEGER,
                            MES_SE_SUBASTA_ID INTEGER,
                            TRIMESTRE_SE_SUBASTA_ID INTEGER,
                            ANIO_SE_SUBASTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SE_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_SE_SUBASTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SE_SUBASTA_MES'',
						  ''MES_SE_SUBASTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SE_SUBASTA_ID INTEGER,
                            TRIMESTRE_SE_SUBASTA_ID INTEGER,
                            ANIO_SE_SUBASTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SE_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_SUBASTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SE_SUBASTA_MES_ANIO'',
						  ''MES_ANIO_SE_SUBASTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SE_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SE_SUBASTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SE_SUBASTA_TRIMESTRE'',
						  ''TRIMESTRE_SE_SUBASTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SE_SUBASTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SE_SUBASTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------  D_F_SOL_ART5_BIS_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_ART5_BIS_ANIO'',
						  ''ANIO_SOL_ART5_BIS_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_SOL_ART5_BIS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_SOL_ART5_BIS_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_ART5_BIS_DIA_SEMANA'',
						  ''DIA_SEMANA_SOL_ART5_BIS_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_SOL_ART5_BIS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



------------------------------ D_F_SOL_ART5_BIS_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_ART5_BIS_DIA'',
						  ''DIA_SOL_ART5_BIS_ID DATE NOT NULL,
                            DIA_SEMANA_SOL_ART5_BIS_ID INTEGER,
                            MES_SOL_ART5_BIS_ID INTEGER,
                            TRIMESTRE_SOL_ART5_BIS_ID INTEGER,
                            ANIO_SOL_ART5_BIS_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_SOL_ART5_BIS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_SOL_ART5_BIS_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_ART5_BIS_MES'',
						  ''MES_SOL_ART5_BIS_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_SOL_ART5_BIS_ID INTEGER,
                            TRIMESTRE_SOL_ART5_BIS_ID INTEGER,
                            ANIO_SOL_ART5_BIS_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_SOL_ART5_BIS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_SOL_ART5_BIS_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_ART5_BIS_MES_ANIO'',
						  ''MES_ANIO_SOL_ART5_BIS_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_SOL_ART5_BIS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_SOL_ART5_BIS_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_SOL_ART5_BIS_TRIMESTRE'',
						  ''TRIMESTRE_SOL_ART5_BIS_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_SOL_ART5_BIS_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_SOL_ART5_BIS_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------  D_F_PREP_DEC_PROP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PREP_DEC_PROP_ANIO'',
						  ''ANIO_PREP_DEC_PROP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_PREP_DEC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_PREP_DEC_PROP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PREP_DEC_PROP_DIA_SEMANA'',
						  ''DIA_SEMANA_PREP_DEC_PROP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_PREP_DEC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



------------------------------ D_F_PREP_DEC_PROP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PREP_DEC_PROP_DIA'',
						  ''DIA_PREP_DEC_PROP_ID DATE NOT NULL,
                            DIA_SEMANA_PREP_DEC_PROP_ID INTEGER,
                            MES_PREP_DEC_PROP_ID INTEGER,
                            TRIMESTRE_PREP_DEC_PROP_ID INTEGER,
                            ANIO_PREP_DEC_PROP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_PREP_DEC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_PREP_DEC_PROP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PREP_DEC_PROP_MES'',
						  ''MES_PREP_DEC_PROP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_PREP_DEC_PROP_ID INTEGER,
                            TRIMESTRE_PREP_DEC_PROP_ID INTEGER,
                            ANIO_PREP_DEC_PROP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_PREP_DEC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_PREP_DEC_PROP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PREP_DEC_PROP_MES_ANIO'',
						  ''MES_ANIO_PREP_DEC_PROP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_PREP_DEC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_PREP_DEC_PROP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_PREP_DEC_PROP_TRIMESTRE'',
						  ''TRIMESTRE_PREP_DEC_PROP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_PREP_DEC_PROP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_PREP_DEC_PROP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	------------------------------  D_F_ULT_PROPUESTA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_PROPUESTA_ANIO'',
						  ''ANIO_ULT_PROPUESTA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ULT_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


    ------------------------------ D_F_ULT_PROPUESTA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_PROPUESTA_DIA_SEMANA'',
						  ''DIA_SEMANA_ULT_PROPUESTA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ULT_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



------------------------------ D_F_ULT_PROPUESTA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_PROPUESTA_DIA'',
						  ''DIA_ULT_PROPUESTA_ID DATE NOT NULL,
                            DIA_SEMANA_ULT_PROPUESTA_ID INTEGER,
                            MES_ULT_PROPUESTA_ID INTEGER,
                            TRIMESTRE_ULT_PROPUESTA_ID INTEGER,
                            ANIO_ULT_PROPUESTA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ULT_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_ULT_PROPUESTA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_PROPUESTA_MES'',
						  ''MES_ULT_PROPUESTA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ULT_PROPUESTA_ID INTEGER,
                            TRIMESTRE_ULT_PROPUESTA_ID INTEGER,
                            ANIO_ULT_PROPUESTA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ULT_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;


------------------------------ D_F_ULT_PROPUESTA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_PROPUESTA_MES_ANIO'',
						  ''MES_ANIO_ULT_PROPUESTA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ULT_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------ D_F_ULT_PROPUESTA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ULT_PROPUESTA_TRIMESTRE'',
						  ''TRIMESTRE_ULT_PROPUESTA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ULT_PROPUESTA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ULT_PROPUESTA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	

  ------------------------------D_F_CAMBIO_TRAMO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CAMBIO_TRAMO_ANIO'',
						  ''ANIO_CAMBIO_TRAMO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_CAMBIO_TRAMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_CAMBIO_TRAMO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CAMBIO_TRAMO_TRIMESTRE'',
						  ''TRIMESTRE_CAMBIO_TRAMO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_CAMBIO_TRAMO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_CAMBIO_TRAMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_CAMBIO_TRAMO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CAMBIO_TRAMO_MES_ANIO'',
						  ''MES_ANIO_CAMBIO_TRAMO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_CAMBIO_TRAMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_CAMBIO_TRAMO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CAMBIO_TRAMO_MES'',
						  ''MES_CAMBIO_TRAMO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_CAMBIO_TRAMO_ID INTEGER,
                            TRIMESTRE_CAMBIO_TRAMO_ID INTEGER,
                            ANIO_CAMBIO_TRAMO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_CAMBIO_TRAMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_CAMBIO_TRAMO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CAMBIO_TRAMO_DIA_SEMANA'',
						  ''DIA_SEMANA_CAMBIO_TRAMO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_CAMBIO_TRAMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_CAMBIO_TRAMO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_CAMBIO_TRAMO_DIA'',
						  ''DIA_CAMBIO_TRAMO_ID DATE NOT NULL,
                            DIA_SEMANA_CAMBIO_TRAMO_ID INTEGER,
                            MES_CAMBIO_TRAMO_ID INTEGER,
                            TRIMESTRE_CAMBIO_TRAMO_ID INTEGER,
                            ANIO_CAMBIO_TRAMO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_CAMBIO_TRAMO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	   
	   
  ------------------------------D_F_BAJA_DUDOSO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_DUDOSO_ANIO'',
						  ''ANIO_BAJA_DUDOSO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_BAJA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_BAJA_DUDOSO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_DUDOSO_TRIMESTRE'',
						  ''TRIMESTRE_BAJA_DUDOSO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_BAJA_DUDOSO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_BAJA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_BAJA_DUDOSO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_DUDOSO_MES_ANIO'',
						  ''MES_ANIO_BAJA_DUDOSO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_BAJA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_BAJA_DUDOSO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_DUDOSO_MES'',
						  ''MES_BAJA_DUDOSO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_BAJA_DUDOSO_ID INTEGER,
                            TRIMESTRE_BAJA_DUDOSO_ID INTEGER,
                            ANIO_BAJA_DUDOSO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_BAJA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_BAJA_DUDOSO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_DUDOSO_DIA_SEMANA'',
						  ''DIA_SEMANA_BAJA_DUDOSO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_BAJA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_BAJA_DUDOSO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_BAJA_DUDOSO_DIA'',
						  ''DIA_BAJA_DUDOSO_ID DATE NOT NULL,
                            DIA_SEMANA_BAJA_DUDOSO_ID INTEGER,
                            MES_BAJA_DUDOSO_ID INTEGER,
                            TRIMESTRE_BAJA_DUDOSO_ID INTEGER,
                            ANIO_BAJA_DUDOSO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_BAJA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	  ------------------------------D_F_ALTA_DUDOSO_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_DUDOSO_ANIO'',
						  ''ANIO_ALTA_DUDOSO_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ALTA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_ALTA_DUDOSO_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_DUDOSO_TRIMESTRE'',
						  ''TRIMESTRE_ALTA_DUDOSO_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ALTA_DUDOSO_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ALTA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_ALTA_DUDOSO_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_DUDOSO_MES_ANIO'',
						  ''MES_ANIO_ALTA_DUDOSO_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ALTA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_ALTA_DUDOSO_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_DUDOSO_MES'',
						  ''MES_ALTA_DUDOSO_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ALTA_DUDOSO_ID INTEGER,
                            TRIMESTRE_ALTA_DUDOSO_ID INTEGER,
                            ANIO_ALTA_DUDOSO_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ALTA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_ALTA_DUDOSO_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_DUDOSO_DIA_SEMANA'',
						  ''DIA_SEMANA_ALTA_DUDOSO_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ALTA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_ALTA_DUDOSO_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ALTA_DUDOSO_DIA'',
						  ''DIA_ALTA_DUDOSO_ID DATE NOT NULL,
                            DIA_SEMANA_ALTA_DUDOSO_ID INTEGER,
                            MES_ALTA_DUDOSO_ID INTEGER,
                            TRIMESTRE_ALTA_DUDOSO_ID INTEGER,
                            ANIO_ALTA_DUDOSO_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ALTA_DUDOSO_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;



  ------------------------------D_F_INICIO_CE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_CE_ANIO'',
						  ''ANIO_INICIO_CE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INICIO_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_INICIO_CE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_CE_TRIMESTRE'',
						  ''TRIMESTRE_INICIO_CE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INICIO_CE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INICIO_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_CE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_CE_MES_ANIO'',
						  ''MES_ANIO_INICIO_CE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INICIO_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_CE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_CE_MES'',
						  ''MES_INICIO_CE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INICIO_CE_ID INTEGER,
                            TRIMESTRE_INICIO_CE_ID INTEGER,
                            ANIO_INICIO_CE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INICIO_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_CE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_CE_DIA_SEMANA'',
						  ''DIA_SEMANA_INICIO_CE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INICIO_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_CE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_CE_DIA'',
						  ''DIA_INICIO_CE_ID DATE NOT NULL,
                            DIA_SEMANA_INICIO_CE_ID INTEGER,
                            MES_INICIO_CE_ID INTEGER,
                            TRIMESTRE_INICIO_CE_ID INTEGER,
                            ANIO_INICIO_CE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INICIO_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	   
  ------------------------------D_F_INICIO_RE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_RE_ANIO'',
						  ''ANIO_INICIO_RE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INICIO_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_INICIO_RE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_RE_TRIMESTRE'',
						  ''TRIMESTRE_INICIO_RE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INICIO_RE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INICIO_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_RE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_RE_MES_ANIO'',
						  ''MES_ANIO_INICIO_RE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INICIO_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_RE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_RE_MES'',
						  ''MES_INICIO_RE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INICIO_RE_ID INTEGER,
                            TRIMESTRE_INICIO_RE_ID INTEGER,
                            ANIO_INICIO_RE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INICIO_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_RE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_RE_DIA_SEMANA'',
						  ''DIA_SEMANA_INICIO_RE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INICIO_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_RE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_RE_DIA'',
						  ''DIA_INICIO_RE_ID DATE NOT NULL,
                            DIA_SEMANA_INICIO_RE_ID INTEGER,
                            MES_INICIO_RE_ID INTEGER,
                            TRIMESTRE_INICIO_RE_ID INTEGER,
                            ANIO_INICIO_RE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INICIO_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	   
	   
	   
	     ------------------------------D_F_INICIO_DC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_DC_ANIO'',
						  ''ANIO_INICIO_DC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INICIO_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_INICIO_DC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_DC_TRIMESTRE'',
						  ''TRIMESTRE_INICIO_DC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INICIO_DC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INICIO_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_DC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_DC_MES_ANIO'',
						  ''MES_ANIO_INICIO_DC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INICIO_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_DC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_DC_MES'',
						  ''MES_INICIO_DC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INICIO_DC_ID INTEGER,
                            TRIMESTRE_INICIO_DC_ID INTEGER,
                            ANIO_INICIO_DC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INICIO_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_DC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_DC_DIA_SEMANA'',
						  ''DIA_SEMANA_INICIO_DC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INICIO_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_DC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_DC_DIA'',
						  ''DIA_INICIO_DC_ID DATE NOT NULL,
                            DIA_SEMANA_INICIO_DC_ID INTEGER,
                            MES_INICIO_DC_ID INTEGER,
                            TRIMESTRE_INICIO_DC_ID INTEGER,
                            ANIO_INICIO_DC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INICIO_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	     ------------------------------D_F_INICIO_FP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_FP_ANIO'',
						  ''ANIO_INICIO_FP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_INICIO_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_INICIO_FP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_FP_TRIMESTRE'',
						  ''TRIMESTRE_INICIO_FP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_INICIO_FP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_INICIO_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_FP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_FP_MES_ANIO'',
						  ''MES_ANIO_INICIO_FP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_INICIO_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_FP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_FP_MES'',
						  ''MES_INICIO_FP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_INICIO_FP_ID INTEGER,
                            TRIMESTRE_INICIO_FP_ID INTEGER,
                            ANIO_INICIO_FP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_INICIO_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_INICIO_FP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_FP_DIA_SEMANA'',
						  ''DIA_SEMANA_INICIO_FP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_INICIO_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_INICIO_FP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_INICIO_FP_DIA'',
						  ''DIA_INICIO_FP_ID DATE NOT NULL,
                            DIA_SEMANA_INICIO_FP_ID INTEGER,
                            MES_INICIO_FP_ID INTEGER,
                            TRIMESTRE_INICIO_FP_ID INTEGER,
                            ANIO_INICIO_FP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_INICIO_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
   ------------------------------D_F_FIN_CE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_CE_ANIO'',
						  ''ANIO_FIN_CE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FIN_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_FIN_CE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_CE_TRIMESTRE'',
						  ''TRIMESTRE_FIN_CE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FIN_CE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FIN_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_CE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_CE_MES_ANIO'',
						  ''MES_ANIO_FIN_CE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FIN_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_CE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_CE_MES'',
						  ''MES_FIN_CE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FIN_CE_ID INTEGER,
                            TRIMESTRE_FIN_CE_ID INTEGER,
                            ANIO_FIN_CE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FIN_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_CE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_CE_DIA_SEMANA'',
						  ''DIA_SEMANA_FIN_CE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FIN_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_CE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_CE_DIA'',
						  ''DIA_FIN_CE_ID DATE NOT NULL,
                            DIA_SEMANA_FIN_CE_ID INTEGER,
                            MES_FIN_CE_ID INTEGER,
                            TRIMESTRE_FIN_CE_ID INTEGER,
                            ANIO_FIN_CE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FIN_CE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	   
  ------------------------------D_F_FIN_RE_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_RE_ANIO'',
						  ''ANIO_FIN_RE_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FIN_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_FIN_RE_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_RE_TRIMESTRE'',
						  ''TRIMESTRE_FIN_RE_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FIN_RE_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FIN_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_RE_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_RE_MES_ANIO'',
						  ''MES_ANIO_FIN_RE_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FIN_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_RE_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_RE_MES'',
						  ''MES_FIN_RE_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FIN_RE_ID INTEGER,
                            TRIMESTRE_FIN_RE_ID INTEGER,
                            ANIO_FIN_RE_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FIN_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_RE_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_RE_DIA_SEMANA'',
						  ''DIA_SEMANA_FIN_RE_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FIN_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_RE_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_RE_DIA'',
						  ''DIA_FIN_RE_ID DATE NOT NULL,
                            DIA_SEMANA_FIN_RE_ID INTEGER,
                            MES_FIN_RE_ID INTEGER,
                            TRIMESTRE_FIN_RE_ID INTEGER,
                            ANIO_FIN_RE_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FIN_RE_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	   
	   
	   
	     ------------------------------D_F_FIN_DC_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_DC_ANIO'',
						  ''ANIO_FIN_DC_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FIN_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_FIN_DC_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_DC_TRIMESTRE'',
						  ''TRIMESTRE_FIN_DC_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_FIN_DC_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FIN_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_DC_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_DC_MES_ANIO'',
						  ''MES_ANIO_FIN_DC_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FIN_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_DC_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_DC_MES'',
						  ''MES_FIN_DC_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FIN_DC_ID INTEGER,
                            TRIMESTRE_FIN_DC_ID INTEGER,
                            ANIO_FIN_DC_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FIN_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_DC_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_DC_DIA_SEMANA'',
						  ''DIA_SEMANA_FIN_DC_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FIN_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_DC_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_DC_DIA'',
						  ''DIA_FIN_DC_ID DATE NOT NULL,
                            DIA_SEMANA_FIN_DC_ID INTEGER,
                            MES_FIN_DC_ID INTEGER,
                            TRIMESTRE_FIN_DC_ID INTEGER,
                            ANIO_FIN_DC_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FIN_DC_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	     ------------------------------D_F_FIN_FP_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_FP_ANIO'',
						  ''ANIO_FIN_FP_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_FIN_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_FIN_FP_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_FP_TRIMESTRE'',
						  ''TRIMESTRE_FIN_FP_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),

                            ANIO_FIN_FP_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_FIN_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_FP_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_FP_MES_ANIO'',
						  ''MES_ANIO_FIN_FP_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_FIN_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_FP_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_FP_MES'',
						  ''MES_FIN_FP_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_FIN_FP_ID INTEGER,
                            TRIMESTRE_FIN_FP_ID INTEGER,

                            ANIO_FIN_FP_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_FIN_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_FIN_FP_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_FP_DIA_SEMANA'',
						  ''DIA_SEMANA_FIN_FP_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_FIN_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_FIN_FP_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_FIN_FP_DIA'',
						  ''DIA_FIN_FP_ID DATE NOT NULL,
                            DIA_SEMANA_FIN_FP_ID INTEGER,

                            MES_FIN_FP_ID INTEGER,
                            TRIMESTRE_FIN_FP_ID INTEGER,

                            ANIO_FIN_FP_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_FIN_FP_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

	     ------------------------------D_F_ANOTA_PER_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANOTA_PER_ANIO'',
						  ''ANIO_ANOTA_PER_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_ANOTA_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_ANOTA_PER_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANOTA_PER_TRIMESTRE'',
						  ''TRIMESTRE_ANOTA_PER_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_ANOTA_PER_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_ANOTA_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_ANOTA_PER_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANOTA_PER_MES_ANIO'',
						  ''MES_ANIO_ANOTA_PER_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_ANOTA_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_ANOTA_PER_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANOTA_PER_MES'',
						  ''MES_ANOTA_PER_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_ANOTA_PER_ID INTEGER,
                            TRIMESTRE_ANOTA_PER_ID INTEGER,
                            ANIO_ANOTA_PER_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANOTA_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_ANOTA_PER_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANOTA_PER_DIA_SEMANA'',
						  ''DIA_SEMANA_ANOTA_PER_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_ANOTA_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_ANOTA_PER_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_ANOTA_PER_DIA'',
						  ''DIA_ANOTA_PER_ID DATE NOT NULL,
                            DIA_SEMANA_ANOTA_PER_ID INTEGER,
                            MES_ANOTA_PER_ID INTEGER,
                            TRIMESTRE_ANOTA_PER_ID INTEGER,
                            ANIO_ANOTA_PER_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_ANOTA_PER_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;
	
	
	     ------------------------------D_F_LLAMADA_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LLAMADA_ANIO'',
						  ''ANIO_LLAMADA_ID INTEGER NOT NULL,
                            ANIO_FECHA DATE,
                            ANIO_DURACION INTEGER,
                            ANIO_ANT_ID INTEGER,
                            PRIMARY KEY (ANIO_LLAMADA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

  ------------------------------D_F_LLAMADA_TRIMESTRE ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LLAMADA_TRIMESTRE'',
						  ''TRIMESTRE_LLAMADA_ID INTEGER NOT NULL,
                            TRIMESTRE_FECHA DATE,
                            TRIMESTRE_DESC VARCHAR2(45),
                            ANIO_LLAMADA_ID INTEGER,
                            TRIMESTRE_DURACION INTEGER,
                            TRIMESTRE_ANT_ID INTEGER,
                            TRIMESTRE_ULT_ANIO_ID INTEGER,
                            TRIMESTRE_DESC_EN VARCHAR2(45),
                            TRIMESTRE_DESC_DE VARCHAR2(45),
                            TRIMESTRE_DESC_FR VARCHAR2(45),
                            TRIMESTRE_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (TRIMESTRE_LLAMADA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_LLAMADA_MES_ANIO ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LLAMADA_MES_ANIO'',
						  ''MES_ANIO_LLAMADA_ID INTEGER NOT NULL,
                            MES_ANIO_DESC VARCHAR2(45),
                            MES_ANIO_DESC_EN VARCHAR2(45),
                            MES_ANIO_DESC_DE VARCHAR2(45),
                            MES_ANIO_DESC_FR VARCHAR2(45),
                            MES_ANIO_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_ANIO_LLAMADA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_LLAMADA_MES ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LLAMADA_MES'',
						  ''MES_LLAMADA_ID INTEGER NOT NULL,
                            MES_FECHA DATE,
                            MES_DESC VARCHAR2(45),
                            MES_ANIO_LLAMADA_ID INTEGER,
                            TRIMESTRE_LLAMADA_ID INTEGER,
                            ANIO_LLAMADA_ID INTEGER,
                            MES_DURACION INTEGER,
                            MES_ANT_ID INTEGER,
                            MES_ULT_TRIMESTRE_ID INTEGER,
                            MES_ULT_ANIO_ID INTEGER,
                            MES_DESC_EN VARCHAR2(45),
                            MES_DESC_DE VARCHAR2(45),
                            MES_DESC_FR VARCHAR2(45),
                            MES_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (MES_LLAMADA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

    ------------------------------D_F_LLAMADA_DIA_SEMANA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LLAMADA_DIA_SEMANA'',
						  ''DIA_SEMANA_LLAMADA_ID INTEGER NOT NULL,
                            DIA_SEMANA_DESC VARCHAR2(45),
                            DIA_SEMANA_DESC_EN VARCHAR2(45),
                            DIA_SEMANA_DESC_DE VARCHAR2(45),
                            DIA_SEMANA_DESC_FR VARCHAR2(45),
                            DIA_SEMANA_DESC_IT VARCHAR2(45),
                            PRIMARY KEY (DIA_SEMANA_LLAMADA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;

   ------------------------------D_F_LLAMADA_DIA ------------------------------
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''CREATE'', ''D_F_LLAMADA_DIA'',
						  ''DIA_LLAMADA_ID DATE NOT NULL,
                            DIA_SEMANA_LLAMADA_ID INTEGER,
                            MES_LLAMADA_ID INTEGER,
                            TRIMESTRE_LLAMADA_ID INTEGER,
                            ANIO_LLAMADA_ID INTEGER,
                            DIA_ANT_ID DATE,
                            DIA_ULT_MES_ID DATE,
                            DIA_ULT_TRIMESTRE_ID DATE,
                            DIA_ULT_ANIO_ID DATE,
                            PRIMARY KEY (DIA_LLAMADA_ID)'', 
                          :error); END;';
    execute immediate V_SQL USING OUT error;	
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  end;

END CREAR_DIM_FECHA_OTRAS;
