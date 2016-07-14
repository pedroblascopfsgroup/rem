create or replace PROCEDURE CARGAR_DIM_FECHA_OTRAS (O_ERROR_STATUS OUT VARCHAR2) AS
-- ===============================================================================================
-- Autor: Jamie S?nchez-Cuenca Bellido
-- Fecha creaci?n: Junio 2014
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ?ltima modificaci?n: 02/02/2016

-- Motivos del cambio: D_F_FINALIZACION
-- Cliente: Recovery BI Bankia
--
-- Descripci?n: Procedimiento almancenado que carga las tablas de la dimensiones Fecha Posici?n
-- Vencida, Fecha Movimiento Dudoso, Fecha Creaci?n Asunto y Fecha Creaci?n Procedimiento.
-- ===============================================================================================

-- -------------------------------------------- ?NDICE -------------------------------------------
-- DIMENSI?N FECHA_CARGA_DATOS
    -- D_F_CARGA_DATOS_ANIO
    -- D_F_CARGA_DATOS_TRIMESTRE
    -- D_F_CARGA_DATOS_MES
    -- D_F_CARGA_DATOS_DIA
    -- D_F_CARGA_DATOS_DIA_SEMANA
    -- D_F_CARGA_DATOS_MES_ANIO

-- DIMENSI?N FECHA_POS_VENCIDA
    -- D_F_POS_VENCIDA_ANIO
    -- D_F_POS_VENCIDA_TRIMESTRE
    -- D_F_POS_VENCIDA_MES
    -- D_F_POS_VENCIDA_DIA
    -- D_F_POS_VENCIDA_DIA_SEMANA
    -- D_F_POS_VENCIDA_MES_ANIO

-- DIMENSI?N FECHA_SALDO_DUDOSO
    -- D_F_SALDO_DUDOSO_ANIO
    -- D_F_SALDO_DUDOSO_DIA_SEMANA
    -- D_F_SALDO_DUDOSO_DIA
    -- D_F_SALDO_DUDOSO_MES
    -- D_F_SALDO_DUDOSO_MES_ANIO
    -- D_F_SALDO_DUDOSO_TRIMESTRE

-- DIMENSI?N FECHA_CREACION_ASUNTO
    -- D_F_CREACION_ASUNTO_ANIO
    -- D_F_CREACION_ASUNTO_DIA_SEMANA
    -- D_F_CREACION_ASUNTO_DIA
    -- D_F_CREACION_ASUNTO_MES
    -- D_F_CREACION_ASUNTO_MES_ANIO
    -- D_F_CREACION_ASUNTO_TRIMESTRE

-- DIMENSI?N FECHA_CREACION_PROCEDIMIENTO
    -- D_F_CREACION_PRC_ANIO
    -- D_F_CREACION_PRC_DIA_SEMANA
    -- D_F_CREACION_PRC_DIA
    -- D_F_CREACION_PRC_MES
    -- D_F_CREACION_PRC_MES_ANIO
    -- D_F_CREACION_PRC_TRIMESTRE

-- DIMENSI?N FECHA_ULTIMA_TAREA_CREADA
    -- D_F_ULT_TAR_CRE_ANIO
    -- D_F_ULT_TAR_CRE_DIA_SEMANA
    -- D_F_ULT_TAR_CRE_DIA
    -- D_F_ULT_TAR_CRE_MES
    -- D_F_ULT_TAR_CRE_MES_ANIO
    -- D_F_ULT_TAR_CRE_TRIMESTRE

-- DIMENSI?N FECHA_ULTIMA_TAREA_FINALIZADA
    -- D_F_ULT_TAR_FIN_ANIO
    -- D_F_ULT_TAR_FIN_DIA_SEMANA
    -- D_F_ULT_TAR_FIN_DIA
    -- D_F_ULT_TAR_FIN_MES
    -- D_F_ULT_TAR_FIN_MES_ANIO
    -- D_F_ULT_TAR_FIN_TRIMESTRE

-- DIMENSI?N FECHA_ULTIMA_TAREA_ACTUALIZADA
    -- D_F_ULT_TAR_ACT_ANIO
    -- D_F_ULT_TAR_ACT_DIA_SEMANA
    -- D_F_ULT_TAR_ACT_DIA
    -- D_F_ULT_TAR_ACT_MES
    -- D_F_ULT_TAR_ACT_MES_ANIO
    -- D_F_ULT_TAR_ACT_TRIMESTRE

-- DIMENSI?N FECHA_ULTIMA_TAREA_PENDIENTE
    -- D_F_ULT_TAR_PEN_ANIO
    -- D_F_ULT_TAR_PEN_DIA_SEMANA
    -- D_F_ULT_TAR_PEN_DIA
    -- D_F_ULT_TAR_PEN_MES
    -- D_F_ULT_TAR_PEN_MES_ANIO
    -- D_F_ULT_TAR_PEN_TRIMESTRE

-- DIMENSI?N FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE
    -- D_F_VA_ULT_TAR_PEN_ANIO
    -- D_F_VA_ULT_TAR_PEN_DIA_SEMANA
    -- D_F_VA_ULT_TAR_PEN_DIA
    -- D_F_VA_ULT_TAR_PEN_MES
    -- D_F_VA_ULT_TAR_PEN_MES_ANIO
    -- D_F_VA_ULT_TAR_PEN_TRIMESTRE

-- DIMENSI?N FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA
    -- D_F_VA_ULT_TAR_FIN_ANIO
    -- D_F_VA_ULT_TAR_FIN_DIA_SEMANA
    -- D_F_VA_ULT_TAR_FIN_DIA
    -- D_F_VA_ULT_TAR_FIN_MES
    -- D_F_VA_ULT_TAR_FIN_MES_ANIO
    -- D_F_VA_ULT_TAR_FIN_TRIMESTRE

-- DIMENSI?N FECHA_COBRO
    -- D_F_COBRO_ANIO
    -- D_F_COBRO_DIA_SEMANA
    -- D_F_COBRO_DIA
    -- D_F_COBRO_MES
    -- D_F_COBRO_MES_ANIO
    -- D_F_COBRO_TRIMESTRE
    
    
-- DIMENSI?N FECHA_ACUERDO
    -- D_F_ACUERDO_ANIO
    -- D_F_ACUERDO_DIA_SEMANA
    -- D_F_ACUERDO_DIA
    -- D_F_ACUERDO_MES
    -- D_F_ACUERDO_MES_ANIO
    -- D_F_ACUERDO_TRIMESTRE 

-- DIMENSI?N FECHA_ACEPTACION
    -- D_F_ACEPTACION_ANIO
    -- D_F_ACEPTACION_DIA_SEMANA
    -- D_F_ACEPTACION_DIA
    -- D_F_ACEPTACION_MES
    -- D_F_ACEPTACION_MES_ANIO
    -- D_F_ACEPTACION_TRIMESTRE

-- DIMENSI?N FECHA_INTERPOSICION_DEMANDA
    -- D_F_INTER_DEM_ANIO
    -- D_F_INTER_DEM_DIA_SEMANA
    -- D_F_INTER_DEM_DIA
    -- D_F_INTER_DEM_MES
    -- D_F_INTER_DEM_MES_ANIO
    -- D_F_INTER_DEM_TRIMESTRE

-- DIMENSI?N FECHA_DECRETO_FINALIZACION
    -- D_F_DECRETO_FIN_ANIO
    -- D_F_DECRETO_FIN_DIA_SEMANA
    -- D_F_DECRETO_FIN_DIA
    -- D_F_DECRETO_FIN_MES
    -- D_F_DECRETO_FIN_MES_ANIO
    -- D_F_DECRETO_FIN_TRIMESTRE

-- DIMENSI?N FECHA_RESOLUCION_FIRME
    -- D_F_RESOL_FIRME_ANIO
    -- D_F_RESOL_FIRME_DIA_SEMANA
    -- D_F_RESOL_FIRME_DIA
    -- D_F_RESOL_FIRME_MES
    -- D_F_RESOL_FIRME_MES_ANIO
    -- D_F_RESOL_FIRME_TRIMESTRE

-- DIMENSI?N FECHA_SUBASTA
    -- D_F_SUBASTA_ANIO
    -- D_F_SUBASTA_DIA_SEMANA
    -- D_F_SUBASTA_DIA
    -- D_F_SUBASTA_MES
    -- D_F_SUBASTA_MES_ANIO
    -- D_F_SUBASTA_TRIMESTRE

-- DIMENSI?N FECHA_SUBASTA_EJECUCION_NOTARIAL
    -- D_F_SUB_EJEC_NOT_ANIO
    -- D_F_SUB_EJEC_NOT_DIA_SEMANA
    -- D_F_SUB_EJEC_NOT_DIA
    -- D_F_SUB_EJEC_NOT_MES
    -- D_F_SUB_EJEC_NOT_MES_ANIO
    -- D_F_SUB_EJEC_NOT_TRIMESTRE

-- DIMENSI?N FECHA_INICIO_APREMIO
    -- D_F_INICIO_APREMIO_ANIO
    -- D_F_INICIO_APREMIO_DIA_SEMANA
    -- D_F_INICIO_APREMIO_DIA
    -- D_F_INICIO_APREMIO_MES
    -- D_F_INICIO_APREMIO_MES_ANIO
    -- D_F_INICIO_APREMIO_TRIMESTRE

-- DIMENSI?N FECHA_ESTIMADA_COBRO
    -- D_F_ESTIMADA_COBRO_ANIO
    -- D_F_ESTIMADA_COBRO_DIA_SEMANA
    -- D_F_ESTIMADA_COBRO_DIA
    -- D_F_ESTIMADA_COBRO_MES
    -- D_F_ESTIMADA_COBRO_MES_ANIO
    -- D_F_ESTIMADA_COBRO_TRIMESTRE

-- DIMENSI?N FECHA_ULTIMA_ESTIMACION
    -- D_F_ULT_EST_ANIO
    -- D_F_ULT_EST_DIA_SEMANA
    -- D_F_ULT_EST_DIA
    -- D_F_ULT_EST_MES
    -- D_F_ULT_EST_MES_ANIO
    -- D_F_ULT_EST_TRIMESTRE

-- DIMENSI?N FECHA_LIQUIDACION
    -- D_F_LIQUIDACION_ANIO
    -- D_F_LIQUIDACION_TRIMESTRE
    -- D_F_LIQUIDACION_MES
    -- D_F_LIQUIDACION_DIA
    -- D_F_LIQUIDACION_DIA_SEMANA
    -- D_F_LIQUIDACION_MES_ANIO

-- DIMENSI?N FECHA_INSINUACION_FINAL_CREDITO
    -- D_F_INSI_FINAL_CRED_ANIO
    -- D_F_INSI_FINAL_CRED_TRIMESTRE
    -- D_F_INSI_FINAL_CRED_MES
    -- D_F_INSI_FINAL_CRED_DIA
    -- D_F_INSI_FINAL_CRED_DIA_SEMANA
    -- D_F_INSI_FINAL_CRED_MES_ANIO

-- DIMENSI?N FECHA_AUTO_APERTURA_CONVENIO
    -- D_F_AUTO_APERT_CONV_ANIO
    -- D_F_AUTO_APERT_CONV_TRIMESTRE
    -- D_F_AUTO_APERT_CONV_MES
    -- D_F_AUTO_APERT_CONV_DIA
    -- D_F_AUTO_APERT_CONV_DIA_SEMANA
    -- D_F_AUTO_APERT_CONV_MES_ANIO

-- DIMENSI?N FECHA_JUNTA_ACREEDORES
    -- D_F_JUNTA_ACREE_ANIO
    -- D_F_JUNTA_ACREE_TRIMESTRE
    -- D_F_JUNTA_ACREE_MES
    -- D_F_JUNTA_ACREE_DIA
    -- D_F_JUNTA_ACREE_DIA_SEMANA
    -- D_F_JUNTA_ACREE_MES_ANIO

-- DIMENSI?N FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION
    -- D_F_REG_RESOL_LIQ_ANIO
    -- D_F_REG_RESOL_LIQ_TRIMESTRE
    -- D_F_REG_RESOL_LIQ_MES
    -- D_F_REG_RESOL_LIQ_DIA
    -- D_F_REG_RESOL_LIQ_DIA_SEMANA
    -- D_F_REG_RESOL_LIQ_MES_ANIO

-- DIMENSI?N FECHA_CREACION_TAREA
    -- D_F_CREACION_TAREA_ANIO
    -- D_F_CREACION_TAREA_DIA_SEMANA
    -- D_F_CREACION_TAREA_DIA
    -- D_F_CREACION_TAREA_MES
    -- D_F_CREACION_TAREA_MES_ANIO
    -- D_F_CREACION_TAREA_TRIMESTRE

-- DIMENSI?N FECHA_FINALIZACION_TAREA
    -- D_F_FIN_TAREA_ANIO
    -- D_F_FIN_TAREA_DIA_SEMANA
    -- D_F_FIN_TAREA_DIA
    -- D_F_FIN_TAREA_MES
    -- D_F_FIN_TAREA_MES_ANIO
    -- D_F_FIN_TAREA_TRIMESTRE

-- DIMENSI?N FECHA_RECOGIDA_DOC_Y_ACEPTACION
    -- D_F_RECOG_DOC_ACEPT_ANIO
    -- D_F_RECOG_DOC_ACEPT_DIA_SEMANA
    -- D_F_RECOG_DOC_ACEPT_DIA
    -- D_F_RECOG_DOC_ACEPT_MES
    -- D_F_RECOG_DOC_ACEPT_MES_ANIO
    -- D_F_RECOG_DOC_ACEPT_TRIMESTRE

-- DIMENSI?N FECHA_REGISTRAR_TOMA_DECISION
    -- D_F_REG_DEC_ANIO
    -- D_F_REG_DEC_DIA_SEMANA
    -- D_F_REG_DEC_DIA
    -- D_F_REG_DEC_MES
    -- D_F_REG_DEC_MES_ANIO
    -- D_F_REG_DEC_TRIMESTRE

-- DIMENSI?N FECHA_RECEPCION_DOC_COMPLETA
    -- D_F_RECEP_DOC_ANIO
    -- D_F_RECEP_DOC_DIA_SEMANA
    -- D_F_RECEP_DOC_DIA
    -- D_F_RECEP_DOC_MES
    -- D_F_RECEP_DOC_MES_ANIO
    -- D_F_RECEP_DOC_TRIMESTRE

-- DIMENSI?N FECHA_CONTABLE_LITIGIO
    -- D_F_CONT_LIT_ANIO
    -- D_F_CONT_LIT_DIA_SEMANA
    -- D_F_CONT_LIT_DIA
    -- D_F_CONT_LIT_MES
    -- D_F_CONT_LIT_MES_ANIO
    -- D_F_CONT_LIT_TRIMESTRE

-- DIMENSI?N FECHA_DPS
    -- D_F_DPS_ANIO
    -- D_F_DPS_TRIMESTRE
    -- D_F_DPS_MES
    -- D_F_DPS_DIA
    -- D_F_DPS_DIA_SEMANA
    -- D_F_DPS_MES_ANIO

-- DIMENSI?N FECHA_COMPROMETIDA_PAGO
    -- D_F_COMP_PAGO_ANIO
    -- D_F_COMP_PAGO_TRIMESTRE
    -- D_F_COMP_PAGO_MES
    -- D_F_COMP_PAGO_DIA
    -- D_F_COMP_PAGO_DIA_SEMANA
    -- D_F_COMP_PAGO_MES_ANIO

-- DIMENSI?N FECHA_ALTA_GESTION_RECOBRO
    -- D_F_ALTA_GEST_REC_ANIO
    -- D_F_ALTA_GEST_REC_TRIMESTRE
    -- D_F_ALTA_GEST_REC_MES
    -- D_F_ALTA_GEST_REC_DIA
    -- D_F_ALTA_GEST_REC_DIA_SEMANA
    -- D_F_ALTA_GEST_REC_MES_ANIO

-- DIMENSI?N FECHA_BAJA_GESTION_RECOBRO
    -- D_F_BAJA_GEST_REC_ANIO
    -- D_F_BAJA_GEST_REC_TRIMESTRE
    -- D_F_BAJA_GEST_REC_MES
    -- D_F_BAJA_GEST_REC_DIA
    -- D_F_BAJA_GEST_REC_DIA_SEMANA
    -- D_F_BAJA_GEST_REC_MES_ANIO

-- DIMENSI?N FECHA_ACTUACION_RECOBRO
    -- D_F_ACT_RECOBRO_ANIO
    -- D_F_ACT_RECOBRO_TRIMESTRE
    -- D_F_ACT_RECOBRO_MES
    -- D_F_ACT_RECOBRO_DIA
    -- D_F_ACT_RECOBRO_DIA_SEMANA
    -- D_F_ACT_RECOBRO_MES_ANIO

-- DIMENSI?N FECHA_PAGO_COMPROMETIDO
    -- D_F_PAGO_COMP_ANIO
    -- D_F_PAGO_COMP_TRIMESTRE
    -- D_F_PAGO_COMP_MES
    -- D_F_PAGO_COMP_DIA
    -- D_F_PAGO_COMP_DIA_SEMANA
    -- D_F_PAGO_COMP_MES_ANIO

-- DIMENSI?N FECHA_VENCIMIENTO_TAREA
    -- D_F_VENC_TAR_ANIO
    -- D_F_VENC_TAR_TRIMESTRE
    -- D_F_VENC_TAR_MES
    -- D_F_VENC_TAR_DIA
    -- D_F_VENC_TAR_DIA_SEMANA
    -- D_F_VENC_TAR_MES_ANIO

-- DIMENSI?N FECHA_CESION_REMATE
    -- D_F_CESION_REMATE_ANIO
    -- D_F_CESION_REMATE_TRIMESTRE
    -- D_F_CESION_REMATE_MES
    -- D_F_CESION_REMATE_DIA
    -- D_F_CESION_REMATE_DIA_SEMANA
    -- D_F_CESION_REMATE_MES_ANIO

-- DIMENSI?N FECHA_CREACION_EXPEDIENTE
    -- D_F_CREACION_EXP_ANIO
    -- D_F_CREACION_EXP_TRIMESTRE
    -- D_F_CREACION_EXP_MES
    -- D_F_CREACION_EXP_DIA
    -- D_F_CREACION_EXP_DIA_SEMANA
    -- D_F_CREACION_EXP_MES_ANIO

-- DIMENSI?N FECHA_ROTURA_EXPEDIENTE
    -- D_F_ROTURA_EXP_ANIO
    -- D_F_ROTURA_EXP_TRIMESTRE
    -- D_F_ROTURA_EXP_MES
    -- D_F_ROTURA_EXP_DIA
    -- D_F_ROTURA_EXP_DIA_SEMANA
    -- D_F_ROTURA_EXP_MES_ANIO

-- DIMENSI?N FECHA_CREACION_CONTRATO
    -- D_F_CREACION_CNT_ANIO
    -- D_F_CREACION_CNT_DIA_SEMANA
    -- D_F_CREACION_CNT_DIA
    -- D_F_CREACION_CNT_MES
    -- D_F_CREACION_CNT_MES_ANIO
    -- D_F_CREACION_CNT_TRIMESTRE

-- DIMENSI?N FECHA_SALIDA_AGENCIA_EXPEDIENTE
    -- D_F_SAL_AGENCIA_EXP_ANIO
    -- D_F_SAL_AGENCIA_EXP_TRIMESTRE
    -- D_F_SAL_AGENCIA_EXP_MES
    -- D_F_SAL_AGENCIA_EXP_DIA
    -- D_F_SAL_AGENCIA_EXP_DIA_SEMANA
    -- D_F_SAL_AGENCIA_EXP_MES_ANIO

-- DIMENSI?N FECHA_OFRECIMIENTO_PROPUESTA
    -- D_F_OFREC_PROP_ANIO
    -- D_F_OFREC_PROP_TRIMESTRE
    -- D_F_OFREC_PROP_MES
    -- D_F_OFREC_PROP_DIA
    -- D_F_OFREC_PROP_DIA_SEMANA
    -- D_F_OFREC_PROP_MES_ANIO

-- DIMENSI?N FECHA_FORMALIZACION_PROPUESTA
    -- D_F_FORM_PROPUESTA_ANIO
    -- D_F_FORM_PROPUESTA_TRIMESTRE
    -- D_F_FORM_PROPUESTA_MES
    -- D_F_FORM_PROPUESTA_DIA
    -- D_F_FORM_PROPUESTA_DIA_SEMANA
    -- D_F_FORM_PROPUESTA_MES_ANIO

-- DIMENSI?N FECHA_SANCION_PROPUESTA
    -- D_F_SANCION_PROP_ANIO
    -- D_F_SANCION_PROP_TRIMESTRE
    -- D_F_SANCION_PROP_MES
    -- D_F_SANCION_PROP_DIA
    -- D_F_SANCION_PROP_DIA_SEMANA
    -- D_F_SANCION_PROP_MES_ANIO

-- DIMENSI?N FECHA_ACTIVACION_INCIDENCIA
    -- D_F_ACTIVACION_INCI_ANIO
    -- D_F_ACTIVACION_INCI_TRIMESTRE
    -- D_F_ACTIVACION_INCI_MES
    -- D_F_ACTIVACION_INCI_DIA
    -- D_F_ACTIVACION_INCI_DIA_SEMANA
    -- D_F_ACTIVACION_INCI_MES_ANIO

-- DIMENSI?N FECHA_RESOLUCION_INCIDENCIA
    -- D_F_RESOL_INCI_ANIO
    -- D_F_RESOL_INCI_TRIMESTRE
    -- D_F_RESOL_INCI_MES
    -- D_F_RESOL_INCI_DIA
    -- D_F_RESOL_INCI_DIA_SEMANA
    -- D_F_RESOL_INCI_MES_ANIO

-- DIMENSI?N FECHA_ELEVACION_COMITE
    -- D_F_ELEV_COMITE_ANIO
    -- D_F_ELEV_COMITE_TRIMESTRE
    -- D_F_ELEV_COMITE_MES
    -- D_F_ELEV_COMITE_DIA
    -- D_F_ELEV_COMITE_DIA_SEMANA
    -- D_F_ELEV_COMITE_MES_ANIO

-- DIMENSI?N FECHA_ULTIMO_COBRO
    -- D_F_ULTIMO_COBRO_ANIO
    -- D_F_ULTIMO_COBRO_TRIMESTRE
    -- D_F_ULTIMO_COBRO_MES
    -- D_F_ULTIMO_COBRO_DIA
    -- D_F_ULTIMO_COBRO_DIA_SEMANA
    -- D_F_ULTIMO_COBRO_MES_ANIO

-- DIMENSI?N FECHA_ENT_AGENCIA_EXP
    -- D_F_ENT_AGENCIA_EXP_ANIO
    -- D_F_ENT_AGENCIA_EXP_TRIMESTRE
    -- D_F_ENT_AGENCIA_EXP_MES
    -- D_F_ENT_AGENCIA_EXP_DIA
    -- D_F_ENT_AGENCIA_EXP_DIA_SEMANA
    -- D_F_ENT_AGENCIA_EXP_MES_ANIO

-- DIMENSI?N FECHA_ALTA_CICLO_REC
    -- D_F_ALTA_CICLO_REC_ANIO
    -- D_F_ALTA_CICLO_REC_TRIMESTRE
    -- D_F_ALTA_CICLO_REC_MES
    -- D_F_ALTA_CICLO_REC_DIA
    -- D_F_ALTA_CICLO_REC_DIA_SEMANA
    -- D_F_ALTA_CICLO_REC_MES_ANIO

-- DIMENSI?N FECHA_BAJA_CICLO_REC
    -- D_F_BAJA_CICLO_REC_ANIO
    -- D_F_BAJA_CICLO_REC_TRIMESTRE
    -- D_F_BAJA_CICLO_REC_MES
    -- D_F_BAJA_CICLO_REC_DIA
    -- D_F_BAJA_CICLO_REC_DIA_SEMANA
    -- D_F_BAJA_CICLO_REC_MES_ANIO

-- DIMENSI?N FECHA_ALTA_EXP_CR
    -- D_F_ALTA_EXP_CR_ANIO
    -- D_F_ALTA_EXP_CR_TRIMESTRE
    -- D_F_ALTA_EXP_CR_MES
    -- D_F_ALTA_EXP_CR_DIA
    -- D_F_ALTA_EXP_CR_DIA_SEMANA
    -- D_F_ALTA_EXP_CR_MES_ANIO

-- DIMENSI?N FECHA_BAJA_EXP_CR
    -- D_F_BAJA_EXP_CR_ANIO
    -- D_F_BAJA_EXP_CR_TRIMESTRE
    -- D_F_BAJA_EXP_CR_MES
    -- D_F_BAJA_EXP_CR_DIA
    -- D_F_BAJA_EXP_CR_DIA_SEMANA
    -- D_F_BAJA_EXP_CR_MES_ANIO

-- DIMENSI?N FECHA_MEJOR_GESTION
    -- D_F_MEJOR_GESTION_ANIO
    -- D_F_MEJOR_GESTION_TRIMESTRE
    -- D_F_MEJOR_GESTION_MES
    -- D_F_MEJOR_GESTION_DIA
    -- D_F_MEJOR_GESTION_DIA_SEMANA
    -- D_F_MEJOR_GESTION_MES_ANIO

-- DIMENSI?N FECHA_PROPUESTA_ACU
    -- D_F_PROPUESTA_ACU_ANIO
    -- D_F_PROPUESTA_ACU_TRIMESTRE
    -- D_F_PROPUESTA_ACU_MES
    -- D_F_PROPUESTA_ACU_DIA
    -- D_F_PROPUESTA_ACU_DIA_SEMANA
    -- D_F_PROPUESTA_ACU_MES_ANIO

-- DIMENSI?N FECHA_INCIDENCIA
    -- D_F_INCIDENCIA_ANIO
    -- D_F_INCIDENCIA_TRIMESTRE
    -- D_F_INCIDENCIA_MES
    -- D_F_INCIDENCIA_DIA
    -- D_F_INCIDENCIA_DIA_SEMANA
    -- D_F_INCIDENCIA_MES_ANIO

-- DIMENSI?N FECHA_CANCELA_TAREA
    -- D_F_CANCELA_TAREA_ANIO
    -- D_F_CANCELA_TAREA_DIA_SEMANA
    -- D_F_CANCELA_TAREA_DIA
    -- D_F_CANCELA_TAREA_MES
    -- D_F_CANCELA_TAREA_MES_ANIO
    -- D_F_CANCELA_TAREA_TRIMESTRE

-- DIMENSI?N FECHA_CANCELA_ASUNTO
    -- D_F_CANCELA_ASUNTO_ANIO
    -- D_F_CANCELA_ASUNTO_DIA_SEMANA
    -- D_F_CANCELA_ASUNTO_DIA
    -- D_F_CANCELA_ASUNTO_MES
    -- D_F_CANCELA_ASUNTO_MES_ANIO
    -- D_F_CANCELA_ASUNTO_TRIMESTRE

-- DIMENSI?N FECHA_CREDITO_INSI
    -- D_F_CREDITO_INSI_ANIO
    -- D_F_CREDITO_INSI_DIA_SEMANA
    -- D_F_CREDITO_INSI_DIA
    -- D_F_CREDITO_INSI_MES
    -- D_F_CREDITO_INSI_MES_ANIO
    -- D_F_CREDITO_INSI_TRIMESTRE

-- DIMENSI?N FECHA_SOLIC_SUBASTA
    -- D_F_SOLIC_SUBASTA_ANIO
    -- D_F_SOLIC_SUBASTA_DIA_SEMANA
    -- D_F_SOLIC_SUBASTA_DIA
    -- D_F_SOLIC_SUBASTA_MES
    -- D_F_SOLIC_SUBASTA_MES_ANIO
    -- D_F_SOLIC_SUBASTA_TRIMESTRE

-- DIMENSI?N FECHA_CELEB_SUBASTA
    -- D_F_CELEB_SUBASTA_ANIO
    -- D_F_CELEB_SUBASTA_DIA_SEMANA
    -- D_F_CELEB_SUBASTA_DIA
    -- D_F_CELEB_SUBASTA_MES
    -- D_F_CELEB_SUBASTA_MES_ANIO
    -- D_F_CELEB_SUBASTA_TRIMESTRE

-- DIMENSIÓN FECHA_PARALIZACION
    -- D_F_PARALIZACION_ANIO
    -- D_F_PARALIZACION_DIA_SEMANA
    -- D_F_PARALIZACION_DIA
    -- D_F_PARALIZACION_MES
    -- D_F_PARALIZACION_MES_ANIO
    -- D_F_PARALIZACION_TRIMESTRE    











































































































































































































-- ===============================================================================================
--                  									Declaracaci?n de variables
-- ===============================================================================================

 i int;
 y NUMBER;
 DIAS NUMBER;
 num_years int;
 min_date DATE;
 max_date date;
 insert_date date;
 next_insert_date date;

-- A?o
 year_id int;
 year_date date;
 year_duration int;
 prev_year_id int;

-- Trimestre
 quarter_id int;
 quarter_date date;
 quarter_desc varchar(50);
 quarter_duration int;
 prev_quarter_id int;
 ly_quarter_id int;
 quarter_desc_de varchar(50);
 quarter_desc_en varchar(50);
 quarter_desc_fr varchar(50);
 quarter_desc_it varchar(50);
 first_day_actual_year date;
 number_of_quarter NUMBER;

-- Month
 month_id int;
 month_date date;
 month_desc varchar(50);
 month_duration int;
 prev_month_id int;
 lq_month_id int;
 ly_month_id int;
 month_desc_de varchar(50);
 month_desc_en varchar(50);
 month_desc_fr varchar(50);
 month_desc_it varchar(50);

-- Day
 day_date date;
 prev_day_date date;
 lm_day_date date;
 lq_day_date date;
 ly_day_date date;

-- Month of year
 month_of_year_id int;
 month_of_year_desc varchar(50);
 month_of_year_desc_en varchar(50);
 month_of_year_desc_de varchar(50);
 month_of_year_desc_fr varchar(50);
 month_of_year_desc_it varchar(50);

-- Day of week
 day_of_week_id int;
 day_of_week_desc varchar(50);
 day_of_week_desc_de varchar(50);
 day_of_week_desc_en varchar(50);
 day_of_week_desc_fr varchar(50);
 day_of_week_desc_it varchar(50);

V_NOMBRE VARCHAR2(50) := 'CARGAR_DIM_FECHA_OTRAS';

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;


-- ----------------------------------------------------------------------------------------------
--
--         ********************   DIMENSION ANIO   ********************
--
-- ----------------------------------------------------------------------------------------------

  i := 1;
  num_years := 60;
  min_date := TO_DATE('1969-01-01','RRRR-MM-DD');

   WHILE (i <= num_years) LOOP

		insert_date := ADD_MONTHS(min_date, (i*12));
 		-- YEAR_ID
 		year_id := TO_CHAR(insert_date, 'RRRR');
 		-- YEAR_DATE
 		year_date := insert_date;
 		-- YEAR_DURATION
 		year_duration := (TO_DATE('01/01-'||(year_id+1),'DD/MM/RRRR') - year_date);
    --  PREV_YEAR
 		prev_year_id := year_id - 1;

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CARGA_DATOS_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CARGA_DATOS_ANIO
      (ANIO_CARGA_DATOS_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_POS_VENCIDA_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_POS_VENCIDA_ANIO
      (ANIO_POS_VENCIDA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                              D_F_SALDO_DUDOSO_ANIO
-- ----------------------------------------------------------------------------------------------


		insert into D_F_SALDO_DUDOSO_ANIO
      (ANIO_SALDO_DUDOSO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_CREACION_ASUNTO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_ASUNTO_ANIO
      (ANIO_CREACION_ASUNTO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_CANCELA_ASUNTO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CANCELA_ASUNTO_ANIO
      (ANIO_CANCELA_ASUNTO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_SOLIC_SUBASTA_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SOLIC_SUBASTA_ANIO
      (ANIO_SOLIC_SUBASTA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_CELEB_SUBASTA_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CELEB_SUBASTA_ANIO
      (ANIO_CELEB_SUBASTA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_CREACION_PRC_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_PRC_ANIO
      (ANIO_CREACION_PRC_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);


-- ----------------------------------------------------------------------------------------------
--                        D_F_ULT_TAR_CRE_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_CRE_ANIO
      (ANIO_ULT_TAR_CRE_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                            D_F_ULT_TAR_FIN_ANIO
-- ----------------------------------------------------------------------------------------------


		insert into D_F_ULT_TAR_FIN_ANIO
      (ANIO_ULT_TAR_FIN_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                         D_F_ULT_TAR_ACT_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_ACT_ANIO
      (ANIO_ULT_TAR_ACT_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                           D_F_ULT_TAR_PEN_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_PEN_ANIO
      (ANIO_ULT_TAR_PEN_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                    D_F_VA_ULT_TAR_PEN_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_PEN_ANIO
      (ANIO_VA_ULT_TAR_PEN_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_VA_ULT_TAR_FIN_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_FIN_ANIO
      (ANIO_VA_ULT_TAR_FIN_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COBRO_ANIO
      (ANIO_COBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

    -- ----------------------------------------------------------------------------------------------
--                  D_F_ACUERDO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACUERDO_ANIO
      (ANIO_ACUERDO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_ACEPTACION_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACEPTACION_ANIO
      (ANIO_ACEPTACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_INTER_DEM_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INTER_DEM_ANIO
      (ANIO_INTER_DEM_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_DECRETO_FIN_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DECRETO_FIN_ANIO
      (ANIO_DECRETO_FIN_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RESOL_FIRME_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RESOL_FIRME_ANIO
      (ANIO_RESOL_FIRME_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_SUBASTA_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUBASTA_ANIO
      (ANIO_SUBASTA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_SUB_EJEC_NOT_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUB_EJEC_NOT_ANIO
      (ANIO_SUB_EJEC_NOT_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_INICIO_APREMIO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INICIO_APREMIO_ANIO
      (ANIO_INICIO_APREMIO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);


-- ----------------------------------------------------------------------------------------------
--                  D_F_ESTIMADA_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ESTIMADA_COBRO_ANIO
      (ANIO_ESTIMADA_COBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_ULT_EST_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_EST_ANIO
      (ANIO_ULT_EST_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_LIQUIDACION_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_LIQUIDACION_ANIO
      (ANIO_LIQUIDACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_INSI_FINAL_CRED_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INSI_FINAL_CRED_ANIO
      (ANIO_INSI_FINAL_CRED_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_AUTO_APERT_CONV_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_AUTO_APERT_CONV_ANIO
      (ANIO_AUTO_APERT_CONV_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_REG_RESOL_LIQ_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_RESOL_LIQ_ANIO
      (ANIO_REG_RESOL_LIQ_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_CREACION_TAREA_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_TAREA_ANIO
      (ANIO_CREACION_TAREA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_FIN_TAREA_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FIN_TAREA_ANIO
      (ANIO_FIN_TAREA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RECOG_DOC_ACEPT_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECOG_DOC_ACEPT_ANIO
      (ANIO_RECOG_DOC_ACEPT_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_REG_DEC_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_DEC_ANIO
      (ANIO_FECHA_REG_DEC_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RECEP_DOC_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECEP_DOC_ANIO
      (ANIO_FECHA_RECEP_DOC_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_CONT_LIT_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CONT_LIT_ANIO
      (ANIO_FECHA_CONT_LIT_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_DPS_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DPS_ANIO
      (ANIO_DPS_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_COMP_PAGO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COMP_PAGO_ANIO
      (ANIO_COMP_PAGO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_GEST_REC_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ALTA_GEST_REC_ANIO
      (ANIO_ALTA_GEST_REC_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_GEST_REC_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_BAJA_GEST_REC_ANIO
      (ANIO_BAJA_GEST_REC_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACT_RECOBRO_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACT_RECOBRO_ANIO
      (ANIO_ACT_RECOBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_PAGO_COMP_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_PAGO_COMP_ANIO
      (ANIO_PAGO_COMP_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_VENC_TAR_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VENC_TAR_ANIO
      (ANIO_VENC_TAR_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CESION_REMATE_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CESION_REMATE_ANIO
      (ANIO_CESION_REMATE_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CREACION_EXP_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_EXP_ANIO
      (ANIO_CREACION_EXP_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ROTURA_EXP_ANIO
-- ----------------------------------------------------------------------------------------------

  IF year_id > 2012 AND year_id < 2023 THEN

    insert into D_F_ROTURA_EXP_ANIO
      (ANIO_ROTURA_EXP_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

  END IF;

-- ----------------------------------------------------------------------------------------------
--                             D_F_CREACION_CNT_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_CNT_ANIO
      (ANIO_CREACION_CNT_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SAL_AGENCIA_EXP_ANIO
-- ----------------------------------------------------------------------------------------------

  IF year_id > 2012 AND year_id < 2023 THEN

		insert into D_F_SAL_AGENCIA_EXP_ANIO
      (ANIO_SAL_AGENCIA_EXP_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

  END IF;

-- ----------------------------------------------------------------------------------------------
--                                      D_F_OFREC_PROP_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_OFREC_PROP_ANIO
      (ANIO_OFREC_PROP_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_FORM_PROPUESTA_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_FORM_PROPUESTA_ANIO
      (ANIO_FORM_PROPUESTA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SANCION_PROP_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_SANCION_PROP_ANIO
      (ANIO_SANCION_PROP_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACTIVACION_INCI_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACTIVACION_INCI_ANIO
      (ANIO_ACTIVACION_INCI_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_RESOL_INCI_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RESOL_INCI_ANIO
      (ANIO_RESOL_INCI_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ELEV_COMITE_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ELEV_COMITE_ANIO
      (ANIO_ELEV_COMITE_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULTIMO_COBRO_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ULTIMO_COBRO_ANIO
      (ANIO_ULTIMO_COBRO_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ENT_AGENCIA_EXP_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ENT_AGENCIA_EXP_ANIO
      (ANIO_ENT_AGENCIA_EXP_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_CICLO_REC_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_CICLO_REC_ANIO
      (ANIO_ALTA_CICLO_REC_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_CICLO_REC_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_CICLO_REC_ANIO
      (ANIO_BAJA_CICLO_REC_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_EXP_CR_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_EXP_CR_ANIO
      (ANIO_ALTA_EXP_CR_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_EXP_CR_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_EXP_CR_ANIO
      (ANIO_BAJA_EXP_CR_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_MEJOR_GESTION_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_MEJOR_GESTION_ANIO
      (ANIO_MEJOR_GESTION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_PROPUESTA_ACU_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_PROPUESTA_ACU_ANIO
      (ANIO_PROPUESTA_ACU_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_INCIDENCIA_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_INCIDENCIA_ANIO
      (ANIO_INCIDENCIA_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_CREDITO_INSI_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREDITO_INSI_ANIO
      (ANIO_CREDITO_INSI_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);
      
-- ----------------------------------------------------------------------------------------------
--                             D_F_PARALIZACION_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_PARALIZACION_ANIO
      (ANIO_PARALIZACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);      
            

-- ----------------------------------------------------------------------------------------------
--                             D_F_FINALIZACION_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FINALIZACION_ANIO
      (ANIO_FINALIZACION_ID,
		   ANIO_FECHA,
			 ANIO_DURACION,
			 ANIO_ANT_ID
			)
		 values
			(year_id,
			 year_date,
			 year_duration,
			 prev_year_id
			);  			























































































































































































































































































































































































































































































































































































































































































































































































































































   i := (i + 1);

   END LOOP;

   COMMIT;

-- ----------------------------------------------------------------------------------------------
--
--         ********************   DIMENSION TRIMESTRE   ********************
--
-- ----------------------------------------------------------------------------------------------


  i := 1;
  min_date := TO_DATE('1969-10-01','RRRR-MM-DD');
  insert_date := NULL;

  WHILE (i <= num_years*4) LOOP

     year_id := TO_NUMBER(TO_CHAR(NVL(next_insert_date,min_date),'RRRR'));

     first_day_actual_year := TO_DATE('01-01-'||TO_CHAR(year_id), 'DD/MM/RRRR');

     insert_date := NVL(next_insert_date,min_date);

     quarter_date := insert_date;

     next_insert_date := ADD_MONTHS(min_date, (i*3));

	-- TRIMESTRE_ID
 	 	 quarter_id := TO_CHAR(year_id) || TO_CHAR(insert_date,'Q');

  -- TRIMESTRE_DESC
     quarter_desc := TO_CHAR(year_id) || ' ' || TO_CHAR(insert_date,'Q') || ' ?Tr';

  -- TRIMESTRE_DESC_EN
		 quarter_desc_en := TO_CHAR(year_id) || ' ' || TO_CHAR(insert_date,'Q') || 'Q';

  -- TRIMESTRE_DESC_DE
     quarter_desc_de := quarter_desc_en;

  -- TRIMESTRE_DESC_FR
		 quarter_desc_fr := quarter_desc_en;

	-- TRIMESTRE_DESC_IT
		 quarter_desc_it := quarter_desc_en;

	-- TRIMESTRE_DURACION
		 quarter_duration :=  (next_insert_date - insert_date);

  -- TRIMESTRE_ANT_ID
     SELECT DECODE(MONTHS_BETWEEN(next_insert_date,first_day_actual_year),0,1,MONTHS_BETWEEN(next_insert_date,first_day_actual_year)/3)
     INTO number_of_quarter
     FROM DUAL;

     SELECT DECODE(number_of_quarter,1, TO_CHAR(year_id - 1) || '4', TO_CHAR(year_id) || TO_CHAR((number_of_quarter-1)))
     INTO prev_quarter_id
     FROM DUAL;

  -- TRIMESTRE_ULT_ANIO_ID
     ly_quarter_id := TO_CHAR(year_id - 1) || TO_CHAR(insert_date,'Q');

-- ----------------------------------------------------------------------------------------------
--                                  D_F_CARGA_DATOS_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CARGA_DATOS_TRIMESTRE
       (TRIMESTRE_CARGA_DATOS_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CARGA_DATOS_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                  D_F_POS_VENCIDA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_POS_VENCIDA_TRIMESTRE
       (TRIMESTRE_POS_VENCIDA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_POS_VENCIDA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_SALDO_DUDOSO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------


    insert into D_F_SALDO_DUDOSO_TRIMESTRE
       (TRIMESTRE_SALDO_DUDOSO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SALDO_DUDOSO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_CREACION_ASUNTO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_ASUNTO_TRIMESTRE
       (TRIMESTRE_CREACION_ASUNTO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_ASUNTO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_CANCELA_ASUNTO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CANCELA_ASUNTO_TRIMESTRE
       (TRIMESTRE_CANCELA_ASUNTO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CANCELA_ASUNTO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_SOLIC_SUBASTA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SOLIC_SUBASTA_TRIMESTRE
       (TRIMESTRE_SOLIC_SUBASTA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SOLIC_SUBASTA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_CELEB_SUBASTA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CELEB_SUBASTA_TRIMESTRE
       (TRIMESTRE_CELEB_SUBASTA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CELEB_SUBASTA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                        D_F_CREACION_PRC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_PRC_TRIMESTRE
       (TRIMESTRE_CREACION_PRC_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_PRC_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                      D_F_ULT_TAR_CRE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_CRE_TRIMESTRE
       (TRIMESTRE_ULT_TAR_CRE_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULT_TAR_CRE_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_ULT_TAR_FIN_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_FIN_TRIMESTRE
       (TRIMESTRE_ULT_TAR_FIN_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULT_TAR_FIN_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                      D_F_ULT_TAR_ACT_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_ACT_TRIMESTRE
       (TRIMESTRE_ULT_TAR_ACT_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULT_TAR_ACT_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                      D_F_ULT_TAR_PEN_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_PEN_TRIMESTRE
       (TRIMESTRE_ULT_TAR_PEN_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULT_TAR_PEN_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_VA_ULT_TAR_PEN_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_VA_ULT_TAR_PEN_TRIMESTRE
       (TRIMESTRE_VA_ULT_TAR_PEN_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_VA_ULT_TAR_PEN_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_VA_ULT_TAR_FIN_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_VA_ULT_TAR_FIN_TRIMESTRE
       (TRIMESTRE_VA_ULT_TAR_FIN_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_VA_ULT_TAR_FIN_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_COBRO_TRIMESTRE
       (TRIMESTRE_COBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_COBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                  D_F_ACUERDO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACUERDO_TRIMESTRE
       (TRIMESTRE_ACUERDO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ACUERDO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


 


-- ----------------------------------------------------------------------------------------------
--                  D_F_ACEPTACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACEPTACION_TRIMESTRE
       (TRIMESTRE_ACEPTACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ACEPTACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_INTER_DEM_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_INTER_DEM_TRIMESTRE
       (TRIMESTRE_INTER_DEM_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INTER_DEM_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_DECRETO_FIN_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_DECRETO_FIN_TRIMESTRE
       (TRIMESTRE_DECRETO_FIN_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_DECRETO_FIN_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RESOL_FIRME_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RESOL_FIRME_TRIMESTRE
       (TRIMESTRE_RESOL_FIRME_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_RESOL_FIRME_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_SUBASTA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SUBASTA_TRIMESTRE
       (TRIMESTRE_SUBASTA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SUBASTA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_SUB_EJEC_NOT_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SUB_EJEC_NOT_TRIMESTRE
       (TRIMESTRE_SUB_EJEC_NOT_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SUB_EJEC_NOT_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_INICIO_APREMIO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_INICIO_APREMIO_TRIMESTRE
       (TRIMESTRE_INICIO_APREMIO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INICIO_APREMIO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_ESTIMADA_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ESTIMADA_COBRO_TRIMESTRE
       (TRIMESTRE_ESTIMADA_COBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ESTIMADA_COBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_ULT_EST_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_EST_TRIMESTRE
       (TRIMESTRE_ULT_EST_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULT_EST_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_LIQUIDACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_LIQUIDACION_TRIMESTRE
       (TRIMESTRE_LIQUIDACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_LIQUIDACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_INSI_FINAL_CRED_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_INSI_FINAL_CRED_TRIMESTRE
       (TRIMESTRE_INSI_FINAL_CRED_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INSI_FINAL_CRED_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_AUTO_APERT_CONV_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_AUTO_APERT_CONV_TRIMESTRE
       (TRIMESTRE_AUTO_APERT_CONV_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_AUTO_APERT_CONV_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_JUNTA_ACREE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_JUNTA_ACREE_TRIMESTRE
       (TRIMESTRE_JUNTA_ACREE_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_JUNTA_ACREE_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_REG_RESOL_LIQ_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_REG_RESOL_LIQ_TRIMESTRE
       (TRIMESTRE_REG_RESOL_LIQ_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_REG_RESOL_LIQ_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_CREACION_TAREA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_TAREA_TRIMESTRE
       (TRIMESTRE_CREACION_TAREA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_TAREA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_FIN_TAREA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_FIN_TAREA_TRIMESTRE
       (TRIMESTRE_FIN_TAREA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FIN_TAREA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RECOG_DOC_ACEPT_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RECOG_DOC_ACEPT_TRIMESTRE
       (TRIMESTRE_RECOG_DOC_ACEPT_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_RECOG_DOC_ACEPT_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_REG_DEC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_REG_DEC_TRIMESTRE
       (TRIMESTRE_FECHA_REG_DEC_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FECHA_REG_DEC_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RECEP_DOC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RECEP_DOC_TRIMESTRE
       (TRIMESTRE_FECHA_RECEP_DOC_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FECHA_RECEP_DOC_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_CONT_LIT_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CONT_LIT_TRIMESTRE
       (TRIMESTRE_FECHA_CONT_LIT_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FECHA_CONT_LIT_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_DPS_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_DPS_TRIMESTRE
       (TRIMESTRE_DPS_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_DPS_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_COMP_PAGO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_COMP_PAGO_TRIMESTRE
       (TRIMESTRE_COMP_PAGO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_COMP_PAGO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ALTA_GEST_REC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ALTA_GEST_REC_TRIMESTRE
       (TRIMESTRE_ALTA_GEST_REC_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ALTA_GEST_REC_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_BAJA_GEST_REC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_BAJA_GEST_REC_TRIMESTRE
       (TRIMESTRE_BAJA_GEST_REC_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_BAJA_GEST_REC_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                  D_F_ACT_RECOBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACT_RECOBRO_TRIMESTRE
       (TRIMESTRE_ACT_RECOBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ACT_RECOBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_PAGO_COMP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_PAGO_COMP_TRIMESTRE
       (TRIMESTRE_PAGO_COMP_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_PAGO_COMP_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_VENC_TAR_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_VENC_TAR_TRIMESTRE
       (TRIMESTRE_VENC_TAR_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_VENC_TAR_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_CESION_REMATE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CESION_REMATE_TRIMESTRE
       (TRIMESTRE_CESION_REMATE_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CESION_REMATE_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_CREACION_EXP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_EXP_TRIMESTRE
       (TRIMESTRE_CREACION_EXP_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_EXP_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ROTURA_EXP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

  IF year_id > 2012 AND year_id < 2023 THEN

      insert into D_F_ROTURA_EXP_TRIMESTRE
       (TRIMESTRE_ROTURA_EXP_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ROTURA_EXP_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

   END IF;

-- ----------------------------------------------------------------------------------------------
--                        D_F_CREACION_CNT_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_CNT_TRIMESTRE
       (TRIMESTRE_CREACION_CNT_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREACION_CNT_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_SAL_AGENCIA_EXP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SAL_AGENCIA_EXP_TRIMESTRE
       (TRIMESTRE_SAL_AGENCIA_EXP_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SAL_AGENCIA_EXP_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_OFREC_PROP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_OFREC_PROP_TRIMESTRE
       (TRIMESTRE_OFREC_PROP_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_OFREC_PROP_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                  D_F_FORM_PROPUESTA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_FORM_PROPUESTA_TRIMESTRE
       (TRIMESTRE_FORM_PROPUESTA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FORM_PROPUESTA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_SANCION_PROP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SANCION_PROP_TRIMESTRE
       (TRIMESTRE_SANCION_PROP_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_SANCION_PROP_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ACTIVACION_INCI_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACTIVACION_INCI_TRIMESTRE
       (TRIMESTRE_ACTIVACION_INCI_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ACTIVACION_INCI_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                  D_F_RESOL_INCI_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RESOL_INCI_TRIMESTRE
       (TRIMESTRE_RESOL_INCI_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_RESOL_INCI_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ELEV_COMITE_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ELEV_COMITE_TRIMESTRE
       (TRIMESTRE_ELEV_COMITE_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ELEV_COMITE_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ULTIMO_COBRO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULTIMO_COBRO_TRIMESTRE
       (TRIMESTRE_ULTIMO_COBRO_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ULTIMO_COBRO_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ENT_AGENCIA_EXP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
    insert into D_F_ENT_AGENCIA_EXP_TRIMESTRE
       (TRIMESTRE_ENT_AGENCIA_EXP_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ENT_AGENCIA_EXP_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ALTA_CICLO_REC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
    insert into D_F_ALTA_CICLO_REC_TRIMESTRE
       (TRIMESTRE_ALTA_CICLO_REC_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ALTA_CICLO_REC_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_BAJA_CICLO_REC_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
    insert into D_F_BAJA_CICLO_REC_TRIMESTRE
       (TRIMESTRE_BAJA_CICLO_REC_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_BAJA_CICLO_REC_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_ALTA_EXP_CR_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
    insert into D_F_ALTA_EXP_CR_TRIMESTRE
       (TRIMESTRE_ALTA_EXP_CR_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_ALTA_EXP_CR_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_BAJA_EXP_CR_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
    insert into D_F_BAJA_EXP_CR_TRIMESTRE
       (TRIMESTRE_BAJA_EXP_CR_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_BAJA_EXP_CR_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                  D_F_MEJOR_GESTION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_MEJOR_GESTION_TRIMESTRE
       (TRIMESTRE_MEJOR_GESTION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_MEJOR_GESTION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_PROPUESTA_ACU_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_PROPUESTA_ACU_TRIMESTRE
       (TRIMESTRE_PROPUESTA_ACU_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_PROPUESTA_ACU_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                  D_F_INCIDENCIA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_INCIDENCIA_TRIMESTRE
       (TRIMESTRE_INCIDENCIA_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_INCIDENCIA_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_CREDITO_INSI_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREDITO_INSI_TRIMESTRE
       (TRIMESTRE_CREDITO_INSI_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_CREDITO_INSI_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);
      
      -- ----------------------------------------------------------------------------------------------
--                        D_F_PARALIZACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_PARALIZACION_TRIMESTRE
       (TRIMESTRE_PARALIZACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_PARALIZACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);        

			
-- ----------------------------------------------------------------------------------------------
--                        D_F_FINALIZACION_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

    insert into D_F_FINALIZACION_TRIMESTRE
       (TRIMESTRE_FINALIZACION_ID,
        TRIMESTRE_FECHA,
        TRIMESTRE_DESC,
        ANIO_FINALIZACION_ID,
        TRIMESTRE_DURACION,
        TRIMESTRE_ANT_ID,
        TRIMESTRE_ULT_ANIO_ID,
        TRIMESTRE_DESC_EN,
        TRIMESTRE_DESC_DE,
        TRIMESTRE_DESC_FR,
        TRIMESTRE_DESC_IT
			)
		 values
			(quarter_id,
			 quarter_date,
		 	 quarter_desc,
 			 year_id,
 			 quarter_duration,
 			 prev_quarter_id,
 			 ly_quarter_id,
 			 quarter_desc_en,
 			 quarter_desc_de,
 		 	 quarter_desc_fr,
 			 quarter_desc_it
			);    


    




























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































  i := (i+1);

  END LOOP;

  COMMIT;

-- ----------------------------------------------------------------------------------------------
--
--         ********************   DIMENSION MES   ********************
--
-- ----------------------------------------------------------------------------------------------

 min_date := TO_DATE('1970-01-01','RRRR-MM-DD');

 i := 1;

 insert_date := NULL;

 next_insert_date := NULL;

  WHILE (i <= num_years*12) LOOP


     year_id := TO_NUMBER(TO_CHAR(NVL(next_insert_date,min_date),'RRRR'));

     first_day_actual_year := TO_DATE('01-01-'||TO_CHAR(year_id), 'DD/MM/RRRR');

     insert_date := NVL(next_insert_date,min_date);

     next_insert_date := ADD_MONTHS(min_date, i);

     month_id := TO_CHAR(year_id) ||LPAD(TO_CHAR(insert_date,'MM'),2,'0');

     month_date := insert_date;

 		 month_desc := TO_CHAR(insert_date,'Month','NLS_DATE_LANGUAGE = Spanish') || ' ' || year_id;

		 month_of_year_id := TO_NUMBER(TO_CHAR(insert_date,'MM'));

	-- TRIMESTRE_ID

	 	 quarter_id := TO_CHAR(year_id) || TO_CHAR(insert_date,'Q');

   	 month_duration := (next_insert_date - insert_date);

		 prev_month_id := TO_CHAR(ADD_MONTHS(insert_date, -1),'RRRRMM');

		 lq_month_id := TO_CHAR(ADD_MONTHS(insert_date, -3),'RRRRMM');

  	 ly_month_id := TO_CHAR(ADD_MONTHS(insert_date, -12),'RRRRMM');

	   month_desc_en := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = English') || ' ' || year_id;
		 month_desc_de := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = German') || ' ' || year_id;
		 month_desc_fr := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = French') || ' ' || year_id;
		 month_desc_it := TO_CHAR(insert_date,'Month', 'NLS_DATE_LANGUAGE = Italian') || ' ' || year_id;


-- ----------------------------------------------------------------------------------------------
--                                      D_F_CARGA_DATOS_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CARGA_DATOS_MES
      (MES_CARGA_DATOS_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CARGA_DATOS_ID,
			 TRIMESTRE_CARGA_DATOS_ID,
			 ANIO_CARGA_DATOS_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_POS_VENCIDA_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_POS_VENCIDA_MES
      (MES_POS_VENCIDA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_POS_VENCIDA_ID,
			 TRIMESTRE_POS_VENCIDA_ID,
			 ANIO_POS_VENCIDA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                               D_F_SALDO_DUDOSO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SALDO_DUDOSO_MES
      (MES_SALDO_DUDOSO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SALDO_DUDOSO_ID,
			 TRIMESTRE_SALDO_DUDOSO_ID,
			 ANIO_SALDO_DUDOSO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_CREACION_ASUNTO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_ASUNTO_MES
      (MES_CREACION_ASUNTO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_ASUNTO_ID,
			 TRIMESTRE_CREACION_ASUNTO_ID,
			 ANIO_CREACION_ASUNTO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_CANCELA_ASUNTO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CANCELA_ASUNTO_MES
      (MES_CANCELA_ASUNTO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CANCELA_ASUNTO_ID,
			 TRIMESTRE_CANCELA_ASUNTO_ID,
			 ANIO_CANCELA_ASUNTO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_SOLIC_SUBASTA_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SOLIC_SUBASTA_MES
      (MES_SOLIC_SUBASTA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SOLIC_SUBASTA_ID,
			 TRIMESTRE_SOLIC_SUBASTA_ID,
			 ANIO_SOLIC_SUBASTA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                             D_F_CELEB_SUBASTA_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CELEB_SUBASTA_MES
      (MES_CELEB_SUBASTA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CELEB_SUBASTA_ID,
			 TRIMESTRE_CELEB_SUBASTA_ID,
			 ANIO_CELEB_SUBASTA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                           D_F_CREACION_PRC_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_PRC_MES
      (MES_CREACION_PRC_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_PRC_ID,
			 TRIMESTRE_CREACION_PRC_ID,
			 ANIO_CREACION_PRC_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                      D_F_ULT_TAR_CRE_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_CRE_MES
      (MES_ULT_TAR_CRE_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULT_TAR_CRE_ID,
			 TRIMESTRE_ULT_TAR_CRE_ID,
			 ANIO_ULT_TAR_CRE_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                       D_F_ULT_TAR_FIN_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_FIN_MES
      (MES_ULT_TAR_FIN_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULT_TAR_FIN_ID,
			 TRIMESTRE_ULT_TAR_FIN_ID,
			 ANIO_ULT_TAR_FIN_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                         D_F_ULT_TAR_ACT_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_ACT_MES
      (MES_ULT_TAR_ACT_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULT_TAR_ACT_ID,
			 TRIMESTRE_ULT_TAR_ACT_ID,
			 ANIO_ULT_TAR_ACT_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                         D_F_ULT_TAR_PEN_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_TAR_PEN_MES
      (MES_ULT_TAR_PEN_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULT_TAR_PEN_ID,
			 TRIMESTRE_ULT_TAR_PEN_ID,
			 ANIO_ULT_TAR_PEN_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                    D_F_VA_ULT_TAR_PEN_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_VA_ULT_TAR_PEN_MES
      (MES_VA_ULT_TAR_PEN_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_VA_ULT_TAR_PEN_ID,
			 TRIMESTRE_VA_ULT_TAR_PEN_ID,
			 ANIO_VA_ULT_TAR_PEN_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_VA_ULT_TAR_FIN_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_VA_ULT_TAR_FIN_MES
      (MES_VA_ULT_TAR_FIN_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_VA_ULT_TAR_FIN_ID,
			 TRIMESTRE_VA_ULT_TAR_FIN_ID,
			 ANIO_VA_ULT_TAR_FIN_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_COBRO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_COBRO_MES
      (MES_COBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_COBRO_ID,
			 TRIMESTRE_COBRO_ID,
			 ANIO_COBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);


 -- ----------------------------------------------------------------------------------------------
--                   D_F_ACUERDO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACUERDO_MES
      (MES_ACUERDO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ACUERDO_ID,
			 TRIMESTRE_ACUERDO_ID,
			 ANIO_ACUERDO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
      


-- ----------------------------------------------------------------------------------------------
--                   D_F_ACEPTACION_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACEPTACION_MES
      (MES_ACEPTACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ACEPTACION_ID,
			 TRIMESTRE_ACEPTACION_ID,
			 ANIO_ACEPTACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_INTER_DEM_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_INTER_DEM_MES
      (MES_INTER_DEM_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INTER_DEM_ID,
			 TRIMESTRE_INTER_DEM_ID,
			 ANIO_INTER_DEM_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_DECRETO_FIN_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_DECRETO_FIN_MES
      (MES_DECRETO_FIN_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_DECRETO_FIN_ID,
			 TRIMESTRE_DECRETO_FIN_ID,
			 ANIO_DECRETO_FIN_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_RESOL_FIRME_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RESOL_FIRME_MES
      (MES_RESOL_FIRME_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_RESOL_FIRME_ID,
			 TRIMESTRE_RESOL_FIRME_ID,
			 ANIO_RESOL_FIRME_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_SUBASTA_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SUBASTA_MES
      (MES_SUBASTA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SUBASTA_ID,
			 TRIMESTRE_SUBASTA_ID,
			 ANIO_SUBASTA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_SUB_EJEC_NOT_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SUB_EJEC_NOT_MES
      (MES_SUB_EJEC_NOT_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SUB_EJEC_NOT_ID,
			 TRIMESTRE_SUB_EJEC_NOT_ID,
			 ANIO_SUB_EJEC_NOT_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_INICIO_APREMIO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_INICIO_APREMIO_MES
      (MES_INICIO_APREMIO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INICIO_APREMIO_ID,
			 TRIMESTRE_INICIO_APREMIO_ID,
			 ANIO_INICIO_APREMIO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_ESTIMADA_COBRO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ESTIMADA_COBRO_MES
      (MES_ESTIMADA_COBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ESTIMADA_COBRO_ID,
			 TRIMESTRE_ESTIMADA_COBRO_ID,
			 ANIO_ESTIMADA_COBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_ULT_EST_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULT_EST_MES
      (MES_ULT_EST_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULT_EST_ID,
			 TRIMESTRE_ULT_EST_ID,
			 ANIO_ULT_EST_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_LIQUIDACION_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_LIQUIDACION_MES
      (MES_LIQUIDACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_LIQUIDACION_ID,
			 TRIMESTRE_LIQUIDACION_ID,
			 ANIO_LIQUIDACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_INSI_FINAL_CRED_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_INSI_FINAL_CRED_MES
      (MES_INSI_FINAL_CRED_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INSI_FINAL_CRED_ID,
			 TRIMESTRE_INSI_FINAL_CRED_ID,
			 ANIO_INSI_FINAL_CRED_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_AUTO_APERT_CONV_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_AUTO_APERT_CONV_MES
      (MES_AUTO_APERT_CONV_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_AUTO_APERT_CONV_ID,
			 TRIMESTRE_AUTO_APERT_CONV_ID,
			 ANIO_AUTO_APERT_CONV_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_JUNTA_ACREE_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_JUNTA_ACREE_MES
      (MES_JUNTA_ACREE_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_JUNTA_ACREE_ID,
			 TRIMESTRE_JUNTA_ACREE_ID,
			 ANIO_JUNTA_ACREE_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_REG_RESOL_LIQ_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_REG_RESOL_LIQ_MES
      (MES_REG_RESOL_LIQ_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_REG_RESOL_LIQ_ID,
			 TRIMESTRE_REG_RESOL_LIQ_ID,
			 ANIO_REG_RESOL_LIQ_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_CREACION_TAREA_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_TAREA_MES
      (MES_CREACION_TAREA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_TAREA_ID,
			 TRIMESTRE_CREACION_TAREA_ID,
			 ANIO_CREACION_TAREA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_FIN_TAREA_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_FIN_TAREA_MES
      (MES_FIN_TAREA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FIN_TAREA_ID,
			 TRIMESTRE_FIN_TAREA_ID,
			 ANIO_FIN_TAREA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_RECOG_DOC_ACEPT_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RECOG_DOC_ACEPT_MES
      (MES_RECOG_DOC_ACEPT_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_RECOG_DOC_ACEPT_ID,
			 TRIMESTRE_RECOG_DOC_ACEPT_ID,
			 ANIO_RECOG_DOC_ACEPT_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_REG_DEC_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_REG_DEC_MES
      (MES_FECHA_REG_DEC_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FECHA_REG_DEC_ID,
			 TRIMESTRE_FECHA_REG_DEC_ID,
			 ANIO_FECHA_REG_DEC_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_RECEP_DOC_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RECEP_DOC_MES
      (MES_FECHA_RECEP_DOC_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FECHA_RECEP_DOC_ID,
			 TRIMESTRE_FECHA_RECEP_DOC_ID,
			 ANIO_FECHA_RECEP_DOC_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_CONT_LIT_MES
-- ----------------------------------------------------------------------------------------------


    insert into D_F_CONT_LIT_MES
      (MES_FECHA_CONT_LIT_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FECHA_CONT_LIT_ID,
			 TRIMESTRE_FECHA_CONT_LIT_ID,
			 ANIO_FECHA_CONT_LIT_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_DPS_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_DPS_MES
      (MES_DPS_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_DPS_ID,
			 TRIMESTRE_DPS_ID,
			 ANIO_DPS_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_COMP_PAGO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_COMP_PAGO_MES
      (MES_COMP_PAGO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_COMP_PAGO_ID,
			 TRIMESTRE_COMP_PAGO_ID,
			 ANIO_COMP_PAGO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_GEST_REC_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ALTA_GEST_REC_MES
      (MES_ALTA_GEST_REC_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ALTA_GEST_REC_ID,
			 TRIMESTRE_ALTA_GEST_REC_ID,
			 ANIO_ALTA_GEST_REC_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_GEST_REC_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_BAJA_GEST_REC_MES
      (MES_BAJA_GEST_REC_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_BAJA_GEST_REC_ID,
			 TRIMESTRE_BAJA_GEST_REC_ID,
			 ANIO_BAJA_GEST_REC_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACT_RECOBRO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACT_RECOBRO_MES
      (MES_ACT_RECOBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ACT_RECOBRO_ID,
			 TRIMESTRE_ACT_RECOBRO_ID,
			 ANIO_ACT_RECOBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_PAGO_COMP_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_PAGO_COMP_MES
      (MES_PAGO_COMP_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_PAGO_COMP_ID,
			 TRIMESTRE_PAGO_COMP_ID,
			 ANIO_PAGO_COMP_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_VENC_TAR_MES
-- ----------------------------------------------------------------------------------------------


    insert into D_F_VENC_TAR_MES
      (MES_VENC_TAR_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_VENC_TAR_ID,
			 TRIMESTRE_VENC_TAR_ID,
			 ANIO_VENC_TAR_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CESION_REMATE_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CESION_REMATE_MES
      (MES_CESION_REMATE_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CESION_REMATE_ID,
			 TRIMESTRE_CESION_REMATE_ID,
			 ANIO_CESION_REMATE_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CREACION_EXP_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_EXP_MES
      (MES_CREACION_EXP_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_EXP_ID,
			 TRIMESTRE_CREACION_EXP_ID,
			 ANIO_CREACION_EXP_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_ROTURA_EXP_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ROTURA_EXP_MES
      (MES_ROTURA_EXP_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ROTURA_EXP_ID,
			 TRIMESTRE_ROTURA_EXP_ID,
			 ANIO_ROTURA_EXP_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                             D_F_CREACION_CNT_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREACION_CNT_MES
      (MES_CREACION_CNT_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREACION_CNT_ID,
			 TRIMESTRE_CREACION_CNT_ID,
			 ANIO_CREACION_CNT_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SAL_AGENCIA_EXP_MES
-- ----------------------------------------------------------------------------------------------

   IF year_id > 2012 AND year_id < 2023 THEN

          insert into D_F_SAL_AGENCIA_EXP_MES
      (MES_SAL_AGENCIA_EXP_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SAL_AGENCIA_EXP_ID,
			 TRIMESTRE_SAL_AGENCIA_EXP_ID,
			 ANIO_SAL_AGENCIA_EXP_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

   END IF;

-- ----------------------------------------------------------------------------------------------
--                                      D_F_OFREC_PROP_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_OFREC_PROP_MES
      (MES_OFREC_PROP_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_OFREC_PROP_ID,
			 TRIMESTRE_OFREC_PROP_ID,
			 ANIO_OFREC_PROP_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_FORM_PROPUESTA_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_FORM_PROPUESTA_MES
      (MES_FORM_PROPUESTA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FORM_PROPUESTA_ID,
			 TRIMESTRE_FORM_PROPUESTA_ID,
			 ANIO_FORM_PROPUESTA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SANCION_PROP_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_SANCION_PROP_MES
      (MES_SANCION_PROP_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_SANCION_PROP_ID,
			 TRIMESTRE_SANCION_PROP_ID,
			 ANIO_SANCION_PROP_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACTIVACION_INCI_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ACTIVACION_INCI_MES
      (MES_ACTIVACION_INCI_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ACTIVACION_INCI_ID,
			 TRIMESTRE_ACTIVACION_INCI_ID,
			 ANIO_ACTIVACION_INCI_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_RESOL_INCI_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_RESOL_INCI_MES
      (MES_RESOL_INCI_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_RESOL_INCI_ID,
			 TRIMESTRE_RESOL_INCI_ID,
			 ANIO_RESOL_INCI_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ELEV_COMITE_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ELEV_COMITE_MES
      (MES_ELEV_COMITE_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ELEV_COMITE_ID,
			 TRIMESTRE_ELEV_COMITE_ID,
			 ANIO_ELEV_COMITE_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULTIMO_COBRO_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_ULTIMO_COBRO_MES
      (MES_ULTIMO_COBRO_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ULTIMO_COBRO_ID,
			 TRIMESTRE_ULTIMO_COBRO_ID,
			 ANIO_ULTIMO_COBRO_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);



-- ----------------------------------------------------------------------------------------------
--                                      D_F_ENT_AGENCIA_EXP_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_ENT_AGENCIA_EXP_MES
      (MES_ENT_AGENCIA_EXP_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ENT_AGENCIA_EXP_ID,
			 TRIMESTRE_ENT_AGENCIA_EXP_ID,
			 ANIO_ENT_AGENCIA_EXP_ID,
			 MES_DURACION,
   		     MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		     month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_CICLO_REC_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_ALTA_CICLO_REC_MES
      (MES_ALTA_CICLO_REC_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ALTA_CICLO_REC_ID,
			 TRIMESTRE_ALTA_CICLO_REC_ID,
			 ANIO_ALTA_CICLO_REC_ID,
			 MES_DURACION,
   		     MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		     month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_CICLO_REC_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_BAJA_CICLO_REC_MES
      (MES_BAJA_CICLO_REC_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_BAJA_CICLO_REC_ID,
			 TRIMESTRE_BAJA_CICLO_REC_ID,
			 ANIO_BAJA_CICLO_REC_ID,
			 MES_DURACION,
   		     MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		     month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_EXP_CR_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_ALTA_EXP_CR_MES
      (MES_ALTA_EXP_CR_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_ALTA_EXP_CR_ID,
			 TRIMESTRE_ALTA_EXP_CR_ID,
			 ANIO_ALTA_EXP_CR_ID,
			 MES_DURACION,
   		     MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		     month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_EXP_CR_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_BAJA_EXP_CR_MES
      (MES_BAJA_EXP_CR_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_BAJA_EXP_CR_ID,
			 TRIMESTRE_BAJA_EXP_CR_ID,
			 ANIO_BAJA_EXP_CR_ID,
			 MES_DURACION,
   		     MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		     month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_MEJOR_GESTION_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_MEJOR_GESTION_MES
      (MES_MEJOR_GESTION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_MEJOR_GESTION_ID,
			 TRIMESTRE_MEJOR_GESTION_ID,
			 ANIO_MEJOR_GESTION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_PROPUESTA_ACU_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_PROPUESTA_ACU_MES
      (MES_PROPUESTA_ACU_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_PROPUESTA_ACU_ID,
			 TRIMESTRE_PROPUESTA_ACU_ID,
			 ANIO_PROPUESTA_ACU_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_INCIDENCIA_MES
-- ----------------------------------------------------------------------------------------------
    insert into D_F_INCIDENCIA_MES
      (MES_INCIDENCIA_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_INCIDENCIA_ID,
			 TRIMESTRE_INCIDENCIA_ID,
			 ANIO_INCIDENCIA_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
-- ----------------------------------------------------------------------------------------------
--                             D_F_CREDITO_INSI_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_CREDITO_INSI_MES
      (MES_CREDITO_INSI_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_CREDITO_INSI_ID,
			 TRIMESTRE_CREDITO_INSI_ID,
			 ANIO_CREDITO_INSI_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);
      
-- ----------------------------------------------------------------------------------------------
--                             D_F_PARALIZACION_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_PARALIZACION_MES
      (MES_PARALIZACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_PARALIZACION_ID,
			 TRIMESTRE_PARALIZACION_ID,
			 ANIO_PARALIZACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);      


-- ----------------------------------------------------------------------------------------------
--                             D_F_FINALIZACION_MES
-- ----------------------------------------------------------------------------------------------

    insert into D_F_FINALIZACION_MES
      (MES_FINALIZACION_ID,
	 		 MES_FECHA,
 			 MES_DESC,
			 MES_ANIO_FINALIZACION_ID,
			 TRIMESTRE_FINALIZACION_ID,
			 ANIO_FINALIZACION_ID,
			 MES_DURACION,
   		 MES_ANT_ID,
			 MES_ULT_TRIMESTRE_ID,
			 MES_ULT_ANIO_ID,
			 MES_DESC_EN,
			 MES_DESC_DE,
			 MES_DESC_FR,
			 MES_DESC_IT
			)
		 values
			(month_id,
       month_date,
 			 month_desc,
 			 month_of_year_id,
 			 quarter_id,
 			 year_id,
 			 month_duration,
 			 prev_month_id,
			 lq_month_id,
			 ly_month_id,
		   month_desc_en,
			 month_desc_de,
			 month_desc_fr,
			 month_desc_it
			);      





















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































		i := (i+1);

  END LOOP;

  COMMIT;

-- ----------------------------------------------------------------------------------------------
--
--         ********************   DIMENSION DIA   ********************
--
-- ----------------------------------------------------------------------------------------------

 insert_date := NULL;

 next_insert_date := NULL;

  y := 1;

  WHILE (y <= num_years) LOOP

      year_id := TO_NUMBER(TO_CHAR(NVL(insert_date,min_date),'RRRR')); --YEAR_ID

      first_day_actual_year := TO_DATE('01-01-'||TO_CHAR(year_id), 'DD/MM/RRRR');

    --Averiguamos si el a?o es bisiesto:
      DIAS := (ADD_MONTHS(NVL(insert_date,min_date),12) - NVL(insert_date,min_date));

      i := 0;

      WHILE (i < DIAS) LOOP

        insert_date := first_day_actual_year + (i);

        day_date := insert_date;

        day_of_week_id := TO_CHAR(insert_date, 'D'); -- DIA DE LA SEMANA (DOMINGO=7)

        month_id := TO_CHAR(insert_date, 'RRRRMM');

    --TRIMESTRE_ID:

        quarter_id := TO_CHAR(year_id) || TO_CHAR(insert_date,'Q');

        prev_day_date := insert_date - 1;

        lm_day_date := ADD_MONTHS(insert_date, -1);

        lq_day_date := ADD_MONTHS(insert_date, -3);

        ly_day_date := ADD_MONTHS(insert_date, -12);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_CARGA_DATOS_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CARGA_DATOS_DIA
      (DIA_CARGA_DATOS_ID,
       DIA_SEMANA_CARGA_DATOS_ID,
       MES_CARGA_DATOS_ID,
       TRIMESTRE_CARGA_DATOS_ID,
       ANIO_CARGA_DATOS_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_POS_VENCIDA_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_POS_VENCIDA_DIA
      (DIA_POS_VENCIDA_ID,
       DIA_SEMANA_POS_VENCIDA_ID,
       MES_POS_VENCIDA_ID,
       TRIMESTRE_POS_VENCIDA_ID,
       ANIO_POS_VENCIDA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                 D_F_SALDO_DUDOSO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SALDO_DUDOSO_DIA
      (DIA_SALDO_DUDOSO_ID,
       DIA_SEMANA_SALDO_DUDOSO_ID,
       MES_SALDO_DUDOSO_ID,
       TRIMESTRE_SALDO_DUDOSO_ID,
       ANIO_SALDO_DUDOSO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                           D_F_CREACION_ASUNTO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_ASUNTO_DIA
      (DIA_CREACION_ASUNTO_ID,
       DIA_SEMANA_CREACION_ASUNTO_ID,
       MES_CREACION_ASUNTO_ID,
       TRIMESTRE_CREACION_ASUNTO_ID,
       ANIO_CREACION_ASUNTO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                           D_F_CANCELA_ASUNTO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CANCELA_ASUNTO_DIA
      (DIA_CANCELA_ASUNTO_ID,
       DIA_SEMANA_CANCELA_ASUNTO_ID,
       MES_CANCELA_ASUNTO_ID,
       TRIMESTRE_CANCELA_ASUNTO_ID,
       ANIO_CANCELA_ASUNTO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                           D_F_SOLIC_SUBASTA_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SOLIC_SUBASTA_DIA
      (DIA_SOLIC_SUBASTA_ID,
       DIA_SEMANA_SOLIC_SUBASTA_ID,
       MES_SOLIC_SUBASTA_ID,
       TRIMESTRE_SOLIC_SUBASTA_ID,
       ANIO_SOLIC_SUBASTA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                           D_F_CELEB_SUBASTA_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CELEB_SUBASTA_DIA
      (DIA_CELEB_SUBASTA_ID,
       DIA_SEMANA_CELEB_SUBASTA_ID,
       MES_CELEB_SUBASTA_ID,
       TRIMESTRE_CELEB_SUBASTA_ID,
       ANIO_CELEB_SUBASTA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


-- ----------------------------------------------------------------------------------------------
--                        D_F_CREACION_PRC_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_PRC_DIA
      (DIA_CREACION_PRC_ID,
       DIA_SEMANA_CREACION_PRC_ID,
       MES_CREACION_PRC_ID,
       TRIMESTRE_CREACION_PRC_ID,
       ANIO_CREACION_PRC_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_ULT_TAR_CRE_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_CRE_DIA
      (DIA_ULT_TAR_CRE_ID,
       DIA_SEMANA_ULT_TAR_CRE_ID,
       MES_ULT_TAR_CRE_ID,
       TRIMESTRE_ULT_TAR_CRE_ID,
       ANIO_ULT_TAR_CRE_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_ULT_TAR_FIN_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_FIN_DIA
      (DIA_ULT_TAR_FIN_ID,
       DIA_SEMANA_ULT_TAR_FIN_ID,
       MES_ULT_TAR_FIN_ID,
       TRIMESTRE_ULT_TAR_FIN_ID,
       ANIO_ULT_TAR_FIN_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_ULT_TAR_ACT_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_ACT_DIA
      (DIA_ULT_TAR_ACT_ID,
       DIA_SEMANA_ULT_TAR_ACT_ID,
       MES_ULT_TAR_ACT_ID,
       TRIMESTRE_ULT_TAR_ACT_ID,
       ANIO_ULT_TAR_ACT_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_ULT_TAR_PEN_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_PEN_DIA
      (DIA_ULT_TAR_PEN_ID,
       DIA_SEMANA_ULT_TAR_PEN_ID,
       MES_ULT_TAR_PEN_ID,
       TRIMESTRE_ULT_TAR_PEN_ID,
       ANIO_ULT_TAR_PEN_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                     D_F_VA_ULT_TAR_PEN_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_PEN_DIA
      (DIA_VA_ULT_TAR_PEN_ID,
       DIA_SEMANA_VA_ULT_TAR_PEN_ID,
       MES_VA_ULT_TAR_PEN_ID,
       TRIMESTRE_VA_ULT_TAR_PEN_ID,
       ANIO_VA_ULT_TAR_PEN_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_VA_ULT_TAR_FIN_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_FIN_DIA
      (DIA_VA_ULT_TAR_FIN_ID,
       DIA_SEMANA_VA_ULT_TAR_FIN_ID,
       MES_VA_ULT_TAR_FIN_ID,
       TRIMESTRE_VA_ULT_TAR_FIN_ID,
       ANIO_VA_ULT_TAR_FIN_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_COBRO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COBRO_DIA
      (DIA_COBRO_ID,
       DIA_SEMANA_COBRO_ID,
       MES_COBRO_ID,
       TRIMESTRE_COBRO_ID,
       ANIO_COBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


      -- ----------------------------------------------------------------------------------------------
--                  D_F_ACUERDO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACUERDO_DIA
      (DIA_ACUERDO_ID,
       DIA_SEMANA_ACUERDO_ID,
       MES_ACUERDO_ID,
       TRIMESTRE_ACUERDO_ID,
       ANIO_ACUERDO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_ACEPTACION_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACEPTACION_DIA
      (DIA_ACEPTACION_ID,
       DIA_SEMANA_ACEPTACION_ID,
       MES_ACEPTACION_ID,
       TRIMESTRE_ACEPTACION_ID,
       ANIO_ACEPTACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_INTER_DEM_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INTER_DEM_DIA
      (DIA_INTER_DEM_ID,
       DIA_SEMANA_INTER_DEM_ID,
       MES_INTER_DEM_ID,
       TRIMESTRE_INTER_DEM_ID,
       ANIO_INTER_DEM_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_DECRETO_FIN_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DECRETO_FIN_DIA
      (DIA_DECRETO_FIN_ID,
       DIA_SEMANA_DECRETO_FIN_ID,
       MES_DECRETO_FIN_ID,
       TRIMESTRE_DECRETO_FIN_ID,
       ANIO_DECRETO_FIN_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RESOL_FIRME_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RESOL_FIRME_DIA
      (DIA_RESOL_FIRME_ID,
       DIA_SEMANA_RESOL_FIRME_ID,
       MES_RESOL_FIRME_ID,
       TRIMESTRE_RESOL_FIRME_ID,
       ANIO_RESOL_FIRME_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_SUBASTA_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUBASTA_DIA
      (DIA_SUBASTA_ID,
       DIA_SEMANA_SUBASTA_ID,
       MES_SUBASTA_ID,
       TRIMESTRE_SUBASTA_ID,
       ANIO_SUBASTA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_SUB_EJEC_NOT_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUB_EJEC_NOT_DIA
      (DIA_SUB_EJEC_NOT_ID,
       DIA_SEMANA_SUB_EJEC_NOT_ID,
       MES_SUB_EJEC_NOT_ID,
       TRIMESTRE_SUB_EJEC_NOT_ID,
       ANIO_SUB_EJEC_NOT_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_INICIO_APREMIO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INICIO_APREMIO_DIA
      (DIA_INICIO_APREMIO_ID,
       DIA_SEMANA_INICIO_APREMIO_ID,
       MES_INICIO_APREMIO_ID,
       TRIMESTRE_INICIO_APREMIO_ID,
       ANIO_INICIO_APREMIO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_ESTIMADA_COBRO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ESTIMADA_COBRO_DIA
      (DIA_ESTIMADA_COBRO_ID,
       DIA_SEMANA_ESTIMADA_COBRO_ID,
       MES_ESTIMADA_COBRO_ID,
       TRIMESTRE_ESTIMADA_COBRO_ID,
       ANIO_ESTIMADA_COBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_ULT_EST_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_EST_DIA
      (DIA_ULT_EST_ID,
       DIA_SEMANA_ULT_EST_ID,
       MES_ULT_EST_ID,
       TRIMESTRE_ULT_EST_ID,
       ANIO_ULT_EST_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_LIQUIDACION_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_LIQUIDACION_DIA
      (DIA_LIQUIDACION_ID,
       DIA_SEMANA_LIQUIDACION_ID,
       MES_LIQUIDACION_ID,
       TRIMESTRE_LIQUIDACION_ID,
       ANIO_LIQUIDACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_INSI_FINAL_CRED_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INSI_FINAL_CRED_DIA
      (DIA_INSI_FINAL_CRED_ID,
       DIA_SEMANA_INSI_FINAL_CRED_ID,
       MES_INSI_FINAL_CRED_ID,
       TRIMESTRE_INSI_FINAL_CRED_ID,
       ANIO_INSI_FINAL_CRED_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_AUTO_APERT_CONV_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_AUTO_APERT_CONV_DIA
      (DIA_AUTO_APERT_CONV_ID,
       DIA_SEMANA_AUTO_APERT_CONV_ID,
       MES_AUTO_APERT_CONV_ID,
       TRIMESTRE_AUTO_APERT_CONV_ID,
       ANIO_AUTO_APERT_CONV_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_JUNTA_ACREE_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_JUNTA_ACREE_DIA
      (DIA_JUNTA_ACREE_ID,
       DIA_SEMANA_JUNTA_ACREE_ID,
       MES_JUNTA_ACREE_ID,
       TRIMESTRE_JUNTA_ACREE_ID,
       ANIO_JUNTA_ACREE_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_REG_RESOL_LIQ_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_RESOL_LIQ_DIA
      (DIA_REG_RESOL_LIQ_ID,
       DIA_SEMANA_REG_RESOL_LIQ_ID,
       MES_REG_RESOL_LIQ_ID,
       TRIMESTRE_REG_RESOL_LIQ_ID,
       ANIO_REG_RESOL_LIQ_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_CREACION_TAREA_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_TAREA_DIA
      (DIA_CREACION_TAREA_ID,
       DIA_SEMANA_CREACION_TAREA_ID,
       MES_CREACION_TAREA_ID,
       TRIMESTRE_CREACION_TAREA_ID,
       ANIO_CREACION_TAREA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_FIN_TAREA_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FIN_TAREA_DIA
      (DIA_FIN_TAREA_ID,
       DIA_SEMANA_FIN_TAREA_ID,
       MES_FIN_TAREA_ID,
       TRIMESTRE_FIN_TAREA_ID,
       ANIO_FIN_TAREA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RECOG_DOC_ACEPT_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECOG_DOC_ACEPT_DIA
      (DIA_RECOG_DOC_ACEPT_ID,
       DIA_SEMANA_RECOG_DOC_ACEPT_ID,
       MES_RECOG_DOC_ACEPT_ID,
       TRIMESTRE_RECOG_DOC_ACEPT_ID,
       ANIO_RECOG_DOC_ACEPT_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_REG_DEC_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_DEC_DIA
      (DIA_FECHA_REG_DEC_ID,
       DIA_SEMANA_FECHA_REG_DEC_ID,
       MES_FECHA_REG_DEC_ID,
       TRIMESTRE_FECHA_REG_DEC_ID,
       ANIO_FECHA_REG_DEC_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_RECEP_DOC_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECEP_DOC_DIA
      (DIA_FECHA_RECEP_DOC_ID,
       DIA_SEMANA_FECHA_RECEP_DOC_ID,
       MES_FECHA_RECEP_DOC_ID,
       TRIMESTRE_FECHA_RECEP_DOC_ID,
       ANIO_FECHA_RECEP_DOC_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_CONT_LIT_DIA
-- ----------------------------------------------------------------------------------------------


		insert into D_F_CONT_LIT_DIA
      (DIA_FECHA_CONT_LIT_ID,
       DIA_SEMANA_FECHA_CONT_LIT_ID,
       MES_FECHA_CONT_LIT_ID,
       TRIMESTRE_FECHA_CONT_LIT_ID,
       ANIO_FECHA_CONT_LIT_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_DPS_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DPS_DIA
      (DIA_DPS_ID,
       DIA_SEMANA_DPS_ID,
       MES_DPS_ID,
       TRIMESTRE_DPS_ID,
       ANIO_DPS_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_COMP_PAGO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COMP_PAGO_DIA
      (DIA_COMP_PAGO_ID,
       DIA_SEMANA_COMP_PAGO_ID,
       MES_COMP_PAGO_ID,
       TRIMESTRE_COMP_PAGO_ID,
       ANIO_COMP_PAGO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_GEST_REC_DIA
-- ----------------------------------------------------------------------------------------------


		insert into D_F_ALTA_GEST_REC_DIA
      (DIA_ALTA_GEST_REC_ID,
       DIA_SEMANA_ALTA_GEST_REC_ID,
       MES_ALTA_GEST_REC_ID,
       TRIMESTRE_ALTA_GEST_REC_ID,
       ANIO_ALTA_GEST_REC_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_GEST_REC_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_BAJA_GEST_REC_DIA
      (DIA_BAJA_GEST_REC_ID,
       DIA_SEMANA_BAJA_GEST_REC_ID,
       MES_BAJA_GEST_REC_ID,
       TRIMESTRE_BAJA_GEST_REC_ID,
       ANIO_BAJA_GEST_REC_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACT_RECOBRO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACT_RECOBRO_DIA
      (DIA_ACT_RECOBRO_ID,
       DIA_SEMANA_ACT_RECOBRO_ID,
       MES_ACT_RECOBRO_ID,
       TRIMESTRE_ACT_RECOBRO_ID,
       ANIO_ACT_RECOBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_PAGO_COMP_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_PAGO_COMP_DIA
      (DIA_PAGO_COMP_ID,
       DIA_SEMANA_PAGO_COMP_ID,
       MES_PAGO_COMP_ID,
       TRIMESTRE_PAGO_COMP_ID,
       ANIO_PAGO_COMP_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_VENC_TAR_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VENC_TAR_DIA
      (DIA_VENC_TAR_ID,
       DIA_SEMANA_VENC_TAR_ID,
       MES_VENC_TAR_ID,
       TRIMESTRE_VENC_TAR_ID,
       ANIO_VENC_TAR_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CESION_REMATE_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CESION_REMATE_DIA
      (DIA_CESION_REMATE_ID,
       DIA_SEMANA_CESION_REMATE_ID,
       MES_CESION_REMATE_ID,
       TRIMESTRE_CESION_REMATE_ID,
       ANIO_CESION_REMATE_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CREACION_EXP_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_EXP_DIA
      (DIA_CREACION_EXP_ID,
       DIA_SEMANA_CREACION_EXP_ID,
       MES_CREACION_EXP_ID,
       TRIMESTRE_CREACION_EXP_ID,
       ANIO_CREACION_EXP_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ROTURA_EXP_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ROTURA_EXP_DIA
      (DIA_ROTURA_EXP_ID,
       DIA_SEMANA_ROTURA_EXP_ID,
       MES_ROTURA_EXP_ID,
       TRIMESTRE_ROTURA_EXP_ID,
       ANIO_ROTURA_EXP_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                           D_F_CREACION_CNT_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_CNT_DIA
      (DIA_CREACION_CNT_ID,
       DIA_SEMANA_CREACION_CNT_ID,
       MES_CREACION_CNT_ID,
       TRIMESTRE_CREACION_CNT_ID,
       ANIO_CREACION_CNT_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_SAL_AGENCIA_EXP_DIA
-- ----------------------------------------------------------------------------------------------

    IF year_id > 2012 AND year_id < 2023 THEN

        		insert into D_F_SAL_AGENCIA_EXP_DIA
      (DIA_SAL_AGENCIA_EXP_ID,
       DIA_SEMANA_SAL_AGENCIA_EXP_ID,
       MES_SAL_AGENCIA_EXP_ID,
       TRIMESTRE_SAL_AGENCIA_EXP_ID,
       ANIO_SAL_AGENCIA_EXP_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

   END IF;

-- ----------------------------------------------------------------------------------------------
--                                      D_F_OFREC_PROP_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_OFREC_PROP_DIA
      (DIA_OFREC_PROP_ID,
       DIA_SEMANA_OFREC_PROP_ID,
       MES_OFREC_PROP_ID,
       TRIMESTRE_OFREC_PROP_ID,
       ANIO_OFREC_PROP_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_FORM_PROPUESTA_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FORM_PROPUESTA_DIA
      (DIA_FORM_PROPUESTA_ID,
       DIA_SEMANA_FORM_PROPUESTA_ID,
       MES_FORM_PROPUESTA_ID,
       TRIMESTRE_FORM_PROPUESTA_ID,
       ANIO_FORM_PROPUESTA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SANCION_PROP_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SANCION_PROP_DIA
      (DIA_SANCION_PROP_ID,
       DIA_SEMANA_SANCION_PROP_ID,
       MES_SANCION_PROP_ID,
       TRIMESTRE_SANCION_PROP_ID,
       ANIO_SANCION_PROP_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACTIVACION_INCI_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACTIVACION_INCI_DIA
      (DIA_ACTIVACION_INCI_ID,
       DIA_SEMANA_ACTIVACION_INCI_ID,
       MES_ACTIVACION_INCI_ID,
       TRIMESTRE_ACTIVACION_INCI_ID,
       ANIO_ACTIVACION_INCI_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_RESOL_INCI_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RESOL_INCI_DIA
      (DIA_RESOL_INCI_ID,
       DIA_SEMANA_RESOL_INCI_ID,
       MES_RESOL_INCI_ID,
       TRIMESTRE_RESOL_INCI_ID,
       ANIO_RESOL_INCI_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ELEV_COMITE_DIA
-- ----------------------------------------------------------------------------------------------


		insert into D_F_ELEV_COMITE_DIA
      (DIA_ELEV_COMITE_ID,
       DIA_SEMANA_ELEV_COMITE_ID,
       MES_ELEV_COMITE_ID,
       TRIMESTRE_ELEV_COMITE_ID,
       ANIO_ELEV_COMITE_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULTIMO_COBRO_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULTIMO_COBRO_DIA
      (DIA_ULTIMO_COBRO_ID,
       DIA_SEMANA_ULTIMO_COBRO_ID,
       MES_ULTIMO_COBRO_ID,
       TRIMESTRE_ULTIMO_COBRO_ID,
       ANIO_ULTIMO_COBRO_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ENT_AGENCIA_EXP_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ENT_AGENCIA_EXP_DIA
      (DIA_ENT_AGENCIA_EXP_ID,
       DIA_SEMANA_ENT_AGENCIA_EXP_ID,
       MES_ENT_AGENCIA_EXP_ID,
       TRIMESTRE_ENT_AGENCIA_EXP_ID,
       ANIO_ENT_AGENCIA_EXP_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_CICLO_REC_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_CICLO_REC_DIA
      (DIA_ALTA_CICLO_REC_ID,
       DIA_SEMANA_ALTA_CICLO_REC_ID,
       MES_ALTA_CICLO_REC_ID,
       TRIMESTRE_ALTA_CICLO_REC_ID,
       ANIO_ALTA_CICLO_REC_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_CICLO_REC_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_CICLO_REC_DIA
      (DIA_BAJA_CICLO_REC_ID,
       DIA_SEMANA_BAJA_CICLO_REC_ID,
       MES_BAJA_CICLO_REC_ID,
       TRIMESTRE_BAJA_CICLO_REC_ID,
       ANIO_BAJA_CICLO_REC_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_EXP_CR_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_EXP_CR_DIA
      (DIA_ALTA_EXP_CR_ID,
       DIA_SEMANA_ALTA_EXP_CR_ID,
       MES_ALTA_EXP_CR_ID,
       TRIMESTRE_ALTA_EXP_CR_ID,
       ANIO_ALTA_EXP_CR_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_EXP_CR_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_EXP_CR_DIA
      (DIA_BAJA_EXP_CR_ID,
       DIA_SEMANA_BAJA_EXP_CR_ID,
       MES_BAJA_EXP_CR_ID,
       TRIMESTRE_BAJA_EXP_CR_ID,
       ANIO_BAJA_EXP_CR_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID
			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_MEJOR_GESTION_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_MEJOR_GESTION_DIA
      (DIA_MEJOR_GESTION_ID,
       DIA_SEMANA_MEJOR_GESTION_ID,
       MES_MEJOR_GESTION_ID,
       TRIMESTRE_MEJOR_GESTION_ID,
       ANIO_MEJOR_GESTION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_PROPUESTA_ACU_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_PROPUESTA_ACU_DIA
      (DIA_PROPUESTA_ACU_ID,
       DIA_SEMANA_PROPUESTA_ACU_ID,
       MES_PROPUESTA_ACU_ID,
       TRIMESTRE_PROPUESTA_ACU_ID,
       ANIO_PROPUESTA_ACU_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_INCIDENCIA_DIA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_INCIDENCIA_DIA
      (DIA_INCIDENCIA_ID,
       DIA_SEMANA_INCIDENCIA_ID,
       MES_INCIDENCIA_ID,
       TRIMESTRE_INCIDENCIA_ID,
       ANIO_INCIDENCIA_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);

-- ----------------------------------------------------------------------------------------------
--                           D_F_CREDITO_INSI_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREDITO_INSI_DIA
      (DIA_CREDITO_INSI_ID,
       DIA_SEMANA_CREDITO_INSI_ID,
       MES_CREDITO_INSI_ID,
       TRIMESTRE_CREDITO_INSI_ID,
       ANIO_CREDITO_INSI_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);
      
      -- ----------------------------------------------------------------------------------------------
--                           D_F_PARALIZACION_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_PARALIZACION_DIA
      (DIA_PARALIZACION_ID,
       DIA_SEMANA_PARALIZACION_ID,
       MES_PARALIZACION_ID,
       TRIMESTRE_PARALIZACION_ID,
       ANIO_PARALIZACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);       


-- ----------------------------------------------------------------------------------------------
--                           D_F_FINALIZACION_DIA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FINALIZACION_DIA
      (DIA_FINALIZACION_ID,
       DIA_SEMANA_FINALIZACION_ID,
       MES_FINALIZACION_ID,
       TRIMESTRE_FINALIZACION_ID,
       ANIO_FINALIZACION_ID ,
       DIA_ANT_ID,
       DIA_ULT_MES_ID,
       DIA_ULT_TRIMESTRE_ID,
       DIA_ULT_ANIO_ID

			)
		 values
			(day_date,
			 day_of_week_id,
			 month_id,
			 quarter_id,
			 year_id,
			 prev_day_date,
			 lm_day_date,
			 lq_day_date,
			 ly_day_date
			);       































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































       i:= (i+1);

       END LOOP;

       insert_date := insert_date + 1;

       y:= (y+1);

   END LOOP;

   COMMIT;

-- ----------------------------------------------------------------------------------------------
--
--         ********************   DIMENSION DIA_SEMANA   ********************
--
-- ----------------------------------------------------------------------------------------------

   i := 0;

   insert_date := TO_DATE('02/06/2014','DD/MM/RRRR');

   WHILE (i < 7 ) LOOP

     day_of_week_id := i;
     day_of_week_desc := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = Spanish');
     day_of_week_desc_en := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = English');
     day_of_week_desc_de := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = German');
     day_of_week_desc_fr := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = French');
     day_of_week_desc_it := TO_CHAR(insert_date + i,'DAY', 'NLS_DATE_LANGUAGE = Italian');

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CARGA_DATOS_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CARGA_DATOS_DIA_SEMANA
      (DIA_SEMANA_CARGA_DATOS_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_POS_VENCIDA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_POS_VENCIDA_DIA_SEMANA
      (DIA_SEMANA_POS_VENCIDA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                            D_F_SALDO_DUDOSO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SALDO_DUDOSO_DIA_SEMANA
      (DIA_SEMANA_SALDO_DUDOSO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CREACION_ASUNTO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_ASUNTO_DIA_SEMANA
      (DIA_SEMANA_CREACION_ASUNTO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CANCELA_ASUNTO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CANCELA_ASUNTO_DIA_SEMANA
      (DIA_SEMANA_CANCELA_ASUNTO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_SOLIC_SUBASTA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SOLIC_SUBASTA_DIA_SEMANA
      (DIA_SEMANA_SOLIC_SUBASTA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CELEB_SUBASTA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CELEB_SUBASTA_DIA_SEMANA
      (DIA_SEMANA_CELEB_SUBASTA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                          D_F_CREACION_PRC_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_PRC_DIA_SEMANA
      (DIA_SEMANA_CREACION_PRC_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                         D_F_ULT_TAR_CRE_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_CRE_DIA_SEMANA
      (DIA_SEMANA_ULT_TAR_CRE_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                         D_F_ULT_TAR_FIN_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_FIN_DIA_SEMANA
      (DIA_SEMANA_ULT_TAR_FIN_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                      D_F_ULT_TAR_ACT_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_ACT_DIA_SEMANA
      (DIA_SEMANA_ULT_TAR_ACT_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                       D_F_ULT_TAR_PEN_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_PEN_DIA_SEMANA
      (DIA_SEMANA_ULT_TAR_PEN_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                  D_F_VA_ULT_TAR_PEN_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_PEN_DIA_SEMANA
      (DIA_SEMANA_VA_ULT_TAR_PEN_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_VA_ULT_TAR_FIN_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_FIN_DIA_SEMANA
      (DIA_SEMANA_VA_ULT_TAR_FIN_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_COBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COBRO_DIA_SEMANA
      (DIA_SEMANA_COBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);


 -- ----------------------------------------------------------------------------------------------
--                D_F_ACUERDO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACUERDO_DIA_SEMANA
      (DIA_SEMANA_ACUERDO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);  
-- ----------------------------------------------------------------------------------------------
--                D_F_ACEPTACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACEPTACION_DIA_SEMANA
      (DIA_SEMANA_ACEPTACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_INTER_DEM_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INTER_DEM_DIA_SEMANA
      (DIA_SEMANA_INTER_DEM_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_DECRETO_FIN_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DECRETO_FIN_DIA_SEMANA
      (DIA_SEMANA_DECRETO_FIN_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_RESOL_FIRME_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------+

		insert into D_F_RESOL_FIRME_DIA_SEMANA
      (DIA_SEMANA_RESOL_FIRME_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_SUBASTA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUBASTA_DIA_SEMANA
      (DIA_SEMANA_SUBASTA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_SUB_EJEC_NOT_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUB_EJEC_NOT_DIA_SEMANA
      (DIA_SEMANA_SUB_EJEC_NOT_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_INICIO_APREMIO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INICIO_APREMIO_DIA_SEMANA
      (DIA_SEMANA_INICIO_APREMIO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_ESTIMADA_COBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ESTIMADA_COBRO_DIA_SEMANA
      (DIA_SEMANA_ESTIMADA_COBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_ULT_EST_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_EST_DIA_SEMANA
      (DIA_SEMANA_ULT_EST_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_LIQUIDACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_LIQUIDACION_DIA_SEMANA
      (DIA_SEMANA_LIQUIDACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_INSI_FINAL_CRED_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INSI_FINAL_CRED_DIA_SEMANA
      (DIA_SEMANA_INSI_FINAL_CRED_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_AUTO_APERT_CONV_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_AUTO_APERT_CONV_DIA_SEMANA
      (DIA_SEMANA_AUTO_APERT_CONV_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_JUNTA_ACREE_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_JUNTA_ACREE_DIA_SEMANA
      (DIA_SEMANA_JUNTA_ACREE_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_REG_RESOL_LIQ_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_RESOL_LIQ_DIA_SEMANA
      (DIA_SEMANA_REG_RESOL_LIQ_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_CREACION_TAREA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_TAREA_DIA_SEMANA
      (DIA_SEMANA_CREACION_TAREA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_FIN_TAREA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FIN_TAREA_DIA_SEMANA
      (DIA_SEMANA_FIN_TAREA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_RECOG_DOC_ACEPT_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECOG_DOC_ACEPT_DIA_SEMANA
      (DIA_SEMANA_RECOG_DOC_ACEPT_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_REG_DEC_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_DEC_DIA_SEMANA
      (DIA_SEMANA_FECHA_REG_DEC_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_RECEP_DOC_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECEP_DOC_DIA_SEMANA
      (DIA_SEMANA_FECHA_RECEP_DOC_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                D_F_CONT_LIT_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CONT_LIT_DIA_SEMANA
      (DIA_SEMANA_FECHA_CONT_LIT_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_DPS_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DPS_DIA_SEMANA
      (DIA_SEMANA_DPS_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_COMP_PAGO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COMP_PAGO_DIA_SEMANA
      (DIA_SEMANA_COMP_PAGO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_GEST_REC_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ALTA_GEST_REC_DIA_SEMANA
      (DIA_SEMANA_ALTA_GEST_REC_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_GEST_REC_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_BAJA_GEST_REC_DIA_SEMANA
      (DIA_SEMANA_BAJA_GEST_REC_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACT_RECOBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACT_RECOBRO_DIA_SEMANA
      (DIA_SEMANA_ACT_RECOBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_PAGO_COMP_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_PAGO_COMP_DIA_SEMANA
      (DIA_SEMANA_PAGO_COMP_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_VENC_TAR_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VENC_TAR_DIA_SEMANA
      (DIA_SEMANA_VENC_TAR_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CESION_REMATE_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CESION_REMATE_DIA_SEMANA
      (DIA_SEMANA_CESION_REMATE_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CREACION_EXP_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_EXP_DIA_SEMANA
      (DIA_SEMANA_CREACION_EXP_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ROTURA_EXP_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ROTURA_EXP_DIA_SEMANA
      (DIA_SEMANA_ROTURA_EXP_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CREACION_CNT_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_CNT_DIA_SEMANA
      (DIA_SEMANA_CREACION_CNT_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SAL_AGENCIA_EXP_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SAL_AGENCIA_EXP_DIA_SEMANA
      (DIA_SEMANA_SAL_AGENCIA_EXP_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_OFREC_PROP_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_OFREC_PROP_DIA_SEMANA
      (DIA_SEMANA_OFREC_PROP_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_FORM_PROPUESTA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FORM_PROPUESTA_DIA_SEMANA
      (DIA_SEMANA_FORM_PROPUESTA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SANCION_PROP_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SANCION_PROP_DIA_SEMANA
      (DIA_SEMANA_SANCION_PROP_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACTIVACION_INCI_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACTIVACION_INCI_DIA_SEMANA
      (DIA_SEMANA_ACTIVACION_INCI_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_RESOL_INCI_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RESOL_INCI_DIA_SEMANA
      (DIA_SEMANA_RESOL_INCI_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ELEV_COMITE_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ELEV_COMITE_DIA_SEMANA
      (DIA_SEMANA_ELEV_COMITE_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULTIMO_COBRO_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULTIMO_COBRO_DIA_SEMANA
      (DIA_SEMANA_ULTIMO_COBRO_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ENT_AGENCIA_EXP_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ENT_AGENCIA_EXP_DIA_SEMANA
      (DIA_SEMANA_ENT_AGENCIA_EXP_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_CICLO_REC_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_CICLO_REC_DIA_SEMANA
      (DIA_SEMANA_ALTA_CICLO_REC_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_CICLO_REC_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_CICLO_REC_DIA_SEMANA
      (DIA_SEMANA_BAJA_CICLO_REC_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_EXP_CR_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_EXP_CR_DIA_SEMANA
      (DIA_SEMANA_ALTA_EXP_CR_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_EXP_CR_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_EXP_CR_DIA_SEMANA
      (DIA_SEMANA_BAJA_EXP_CR_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_MEJOR_GESTION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_MEJOR_GESTION_DIA_SEMANA
      (DIA_SEMANA_MEJOR_GESTION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_PROPUESTA_ACU_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_PROPUESTA_ACU_DIA_SEMANA
      (DIA_SEMANA_PROPUESTA_ACU_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_INCIDENCIA_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
		insert into D_F_INCIDENCIA_DIA_SEMANA
      (DIA_SEMANA_INCIDENCIA_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CREDITO_INSI_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREDITO_INSI_DIA_SEMANA
      (DIA_SEMANA_CREDITO_INSI_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);
      




	insert into D_F_PARALIZACION_DIA_SEMANA
      (DIA_SEMANA_PARALIZACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);      


-- ----------------------------------------------------------------------------------------------
--                          D_F_FINALIZACION_DIA_SEMANA
-- ----------------------------------------------------------------------------------------------
      
	insert into D_F_FINALIZACION_DIA_SEMANA
      (DIA_SEMANA_FINALIZACION_ID,
       DIA_SEMANA_DESC,
       DIA_SEMANA_DESC_EN,
       DIA_SEMANA_DESC_DE,
       DIA_SEMANA_DESC_FR,
       DIA_SEMANA_DESC_IT
			)
		 values
			(day_of_week_id,
			 day_of_week_desc,
			 day_of_week_desc_en,
			 day_of_week_desc_de,
			 day_of_week_desc_fr,
			 day_of_week_desc_it
			);      


























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































      i := (i + 1);

   END LOOP;

   COMMIT;


-- ----------------------------------------------------------------------------------------------
--
--         ********************   DIMENSION MES_A?O    ********************
--
-- ----------------------------------------------------------------------------------------------

   i := 1;

   insert_date := TO_DATE('01/12/1969','DD/MM/RRRR');

   WHILE (i <= 12 ) LOOP

     month_of_year_id := i;
     month_of_year_desc := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = Spanish');
     month_of_year_desc_en := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = English');
     month_of_year_desc_de := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = German');
     month_of_year_desc_fr := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = French');
     month_of_year_desc_it := TO_CHAR(ADD_MONTHS(insert_date, i),'MONTH', 'NLS_DATE_LANGUAGE = Italian');


-- ----------------------------------------------------------------------------------------------
--                                      D_F_CARGA_DATOS_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CARGA_DATOS_MES_ANIO
      (MES_ANIO_CARGA_DATOS_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_POS_VENCIDA_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_POS_VENCIDA_MES_ANIO
      (MES_ANIO_POS_VENCIDA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_SALDO_DUDOSO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SALDO_DUDOSO_MES_ANIO
      (MES_ANIO_SALDO_DUDOSO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CREACION_ASUNTO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_ASUNTO_MES_ANIO
      (MES_ANIO_CREACION_ASUNTO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CANCELA_ASUNTO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CANCELA_ASUNTO_MES_ANIO
      (MES_ANIO_CANCELA_ASUNTO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_SOLIC_SUBASTA_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SOLIC_SUBASTA_MES_ANIO
      (MES_ANIO_SOLIC_SUBASTA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CELEB_SUBASTA_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CELEB_SUBASTA_MES_ANIO
      (MES_ANIO_CELEB_SUBASTA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                       D_F_CREACION_PRC_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_PRC_MES_ANIO
      (MES_ANIO_CREACION_PRC_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_ULT_TAR_CRE_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_CRE_MES_ANIO
      (MES_ANIO_ULT_TAR_CRE_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                          D_F_ULT_TAR_FIN_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_FIN_MES_ANIO
      (MES_ANIO_ULT_TAR_FIN_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                        D_F_ULT_TAR_ACT_MES_ANIO
-- ----------------------------------------------------------------------------------------------


		insert into D_F_ULT_TAR_ACT_MES_ANIO
      (MES_ANIO_ULT_TAR_ACT_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                       D_F_ULT_TAR_PEN_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_TAR_PEN_MES_ANIO
      (MES_ANIO_ULT_TAR_PEN_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                   D_F_VA_ULT_TAR_PEN_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_PEN_MES_ANIO
      (MES_ANIO_VA_ULT_TAR_PEN_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--              D_F_VA_ULT_TAR_FIN_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VA_ULT_TAR_FIN_MES_ANIO
      (MES_ANIO_VA_ULT_TAR_FIN_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_COBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COBRO_MES_ANIO
      (MES_ANIO_COBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

     -- ----------------------------------------------------------------------------------------------
--              D_F_ACUERDO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACUERDO_MES_ANIO
      (MES_ANIO_ACUERDO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--              D_F_ACEPTACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACEPTACION_MES_ANIO
      (MES_ANIO_ACEPTACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_INTER_DEM_MES_ANIO
-- ----------------------------------------------------------------------------------------------

      		insert into D_F_INTER_DEM_MES_ANIO
      (MES_ANIO_INTER_DEM_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_DECRETO_FIN_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DECRETO_FIN_MES_ANIO
      (MES_ANIO_DECRETO_FIN_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_RESOL_FIRME_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RESOL_FIRME_MES_ANIO
      (MES_ANIO_RESOL_FIRME_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_SUBASTA_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUBASTA_MES_ANIO
      (MES_ANIO_SUBASTA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_SUB_EJEC_NOT_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SUB_EJEC_NOT_MES_ANIO
      (MES_ANIO_SUB_EJEC_NOT_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_INICIO_APREMIO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INICIO_APREMIO_MES_ANIO
      (MES_ANIO_INICIO_APREMIO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_ULT_EST_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULT_EST_MES_ANIO
      (MES_ANIO_ULT_EST_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_LIQUIDACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_LIQUIDACION_MES_ANIO
      (MES_ANIO_LIQUIDACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_INSI_FINAL_CRED_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_INSI_FINAL_CRED_MES_ANIO
      (MES_ANIO_INSI_FINAL_CRED_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_AUTO_APERT_CONV_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_AUTO_APERT_CONV_MES_ANIO
      (MES_ANIO_AUTO_APERT_CONV_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_JUNTA_ACREE_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_JUNTA_ACREE_MES_ANIO
      (MES_ANIO_JUNTA_ACREE_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_REG_RESOL_LIQ_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_RESOL_LIQ_MES_ANIO
      (MES_ANIO_REG_RESOL_LIQ_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_CREACION_TAREA_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_TAREA_MES_ANIO
      (MES_ANIO_CREACION_TAREA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_FIN_TAREA_MES_ANIO
-- ----------------------------------------------------------------------------------------------


		insert into D_F_FIN_TAREA_MES_ANIO
      (MES_ANIO_FIN_TAREA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_RECOG_DOC_ACEPT_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECOG_DOC_ACEPT_MES_ANIO
      (MES_ANIO_RECOG_DOC_ACEPT_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--              D_F_REG_DEC_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_REG_DEC_MES_ANIO
      (MES_ANIO_FECHA_REG_DEC_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_RECEP_DOC_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RECEP_DOC_MES_ANIO
      (MES_ANIO_FECHA_RECEP_DOC_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--              D_F_CONT_LIT_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CONT_LIT_MES_ANIO
      (MES_ANIO_FECHA_CONT_LIT_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

      -- ----------------------------------------------------------------------------------------------
--                                      D_F_DPS_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_DPS_MES_ANIO
      (MES_ANIO_DPS_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_COMP_PAGO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_COMP_PAGO_MES_ANIO
      (MES_ANIO_COMP_PAGO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_GEST_REC_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ALTA_GEST_REC_MES_ANIO
      (MES_ANIO_ALTA_GEST_REC_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_GEST_REC_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_BAJA_GEST_REC_MES_ANIO
      (MES_ANIO_BAJA_GEST_REC_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACT_RECOBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACT_RECOBRO_MES_ANIO
      (MES_ANIO_ACT_RECOBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_PAGO_COMP_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_PAGO_COMP_MES_ANIO
      (MES_ANIO_PAGO_COMP_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_VENC_TAR_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_VENC_TAR_MES_ANIO
      (MES_ANIO_VENC_TAR_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CESION_REMATE_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CESION_REMATE_MES_ANIO
      (MES_ANIO_CESION_REMATE_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_CREACION_EXP_MES_ANIO
-- ----------------------------------------------------------------------------------------------


		insert into D_F_CREACION_EXP_MES_ANIO
      (MES_ANIO_CREACION_EXP_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ROTURA_EXP_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ROTURA_EXP_MES_ANIO
      (MES_ANIO_ROTURA_EXP_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CREACION_CNT_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREACION_CNT_MES_ANIO
      (MES_ANIO_CREACION_CNT_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SAL_AGENCIA_EXP_MES_ANIO
-- ----------------------------------------------------------------------------------------------



		insert into D_F_SAL_AGENCIA_EXP_MES_ANIO
      (MES_ANIO_SAL_AGENCIA_EXP_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_OFREC_PROP_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_OFREC_PROP_MES_ANIO
      (MES_ANIO_OFREC_PROP_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_FORM_PROPUESTA_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FORM_PROPUESTA_MES_ANIO
      (MES_ANIO_FORM_PROPUESTA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_SANCION_PROP_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_SANCION_PROP_MES_ANIO
      (MES_ANIO_SANCION_PROP_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ACTIVACION_INCI_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ACTIVACION_INCI_MES_ANIO
      (MES_ANIO_ACTIVACION_INCI_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_RESOL_INCI_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_RESOL_INCI_MES_ANIO
      (MES_ANIO_RESOL_INCI_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ELEV_COMITE_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ELEV_COMITE_MES_ANIO
      (MES_ANIO_ELEV_COMITE_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ULTIMO_COBRO_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_ULTIMO_COBRO_MES_ANIO
      (MES_ANIO_ULTIMO_COBRO_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ENT_AGENCIA_EXP_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ENT_AGENCIA_EXP_MES_ANIO
      (MES_ANIO_ENT_AGENCIA_EXP_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_CICLO_REC_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_CICLO_REC_MES_ANIO
      (MES_ANIO_ALTA_CICLO_REC_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_CICLO_REC_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_CICLO_REC_MES_ANIO
      (MES_ANIO_BAJA_CICLO_REC_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_ALTA_EXP_CR_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_ALTA_EXP_CR_MES_ANIO
      (MES_ANIO_ALTA_EXP_CR_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_BAJA_EXP_CR_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_BAJA_EXP_CR_MES_ANIO
      (MES_ANIO_BAJA_EXP_CR_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_MEJOR_GESTION_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_MEJOR_GESTION_MES_ANIO
      (MES_ANIO_MEJOR_GESTION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                                      D_F_PROPUESTA_ACU_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_PROPUESTA_ACU_MES_ANIO
      (MES_ANIO_PROPUESTA_ACU_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);


-- ----------------------------------------------------------------------------------------------
--                                      D_F_INCIDENCIA_MES_ANIO
-- ----------------------------------------------------------------------------------------------
		insert into D_F_INCIDENCIA_MES_ANIO
      (MES_ANIO_INCIDENCIA_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);

-- ----------------------------------------------------------------------------------------------
--                          D_F_CREDITO_INSI_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_CREDITO_INSI_MES_ANIO
      (MES_ANIO_CREDITO_INSI_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);
      
      -- ----------------------------------------------------------------------------------------------
--                          D_F_PARALIZACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_PARALIZACION_MES_ANIO
      (MES_ANIO_PARALIZACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);      



-- ----------------------------------------------------------------------------------------------
--                          D_F_FINALIZACION_MES_ANIO
-- ----------------------------------------------------------------------------------------------

		insert into D_F_FINALIZACION_MES_ANIO
      (MES_ANIO_FINALIZACION_ID,
       MES_ANIO_DESC,
       MES_ANIO_DESC_EN,
       MES_ANIO_DESC_DE,
       MES_ANIO_DESC_FR,
       MES_ANIO_DESC_IT
			)
		 values
			(month_of_year_id,
			 month_of_year_desc,
			 month_of_year_desc_en,
		 	 month_of_year_desc_de,
		 	 month_of_year_desc_fr,
		 	 month_of_year_desc_it
			);      











































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































      i := i + 1;

    END LOOP;

    COMMIT;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN

     O_ERROR_STATUS := 'ERROR DE CLAVE DUPLICADA';


  WHEN OTHERS THEN

     O_ERROR_STATUS := 'SE HAN PRODUCIDO ERRORES EN EL PROCESO';

END CARGAR_DIM_FECHA_OTRAS;

