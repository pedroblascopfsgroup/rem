--/*
--##########################################
--## AUTOR=JAVIER DIAZ RAMOS
--## FECHA_CREACION=20150921
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=EXIM-12383
--## PRODUCTO=NO
--## 
--## Finalidad: Limpieza del entorno #ESQUEMA#
--## INSTRUCCIONES: Se puede relanzar las veces que sea necesario
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET TIMING ON;
DECLARE
    V_MSQL VARCHAR(32000);   
 
   TYPE T_TABLAS IS TABLE OF VARCHAR2(150);
   TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;
    
    
--/*
--##########################################
--## Configuraciones a rellenar
--##########################################
--*/


   V_#ESQUEMA# T_ARRAY_TABLAS := T_ARRAY_TABLAS(
                        T_TABLAS('#ESQUEMA#','ACC_ACUERDO_CONTRATO'),
                        T_TABLAS('#ESQUEMA#','ACE_ACCIONES_EXTRAJUDICIALES'),
                        T_TABLAS('#ESQUEMA#','ACU_ACUERDO_PROCEDIMIENTOS'),
		        T_TABLAS('#ESQUEMA#','AEA_ACTUACIO_EXPLOR_ACUERDO'),
                        T_TABLAS('#ESQUEMA#','ADC_ADECUACIONES_CNT'),
                        T_TABLAS('#ESQUEMA#','AEX_ANTECEDENTESEXTERNOS'),
                        T_TABLAS('#ESQUEMA#','ANA_ANALIS_ACUERDO'),
                        T_TABLAS('#ESQUEMA#','ANE_ANALISIS_EXTERNA'),
                        T_TABLAS('#ESQUEMA#','ANT_ANTECEDENTES'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ABC_DIRPER_CONSOL'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ABI_CIRBE_CONSOL'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ABI_DIRECC_CONSOL'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ABI_DIRECC_CONSOL2'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ABI_DIRECC_CONSOL3'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ABI_DIRECC_CONSOL_REJ'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ACE_ACCEXTJUD'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ACE_ACCEXTJUD_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ACP_COBPAG_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ACP_COBROS_PAGOS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ADE_ADECUACIONES'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ADE_ADECUA_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_EFC_EFECTOS_CNT'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_EFC_EFEC_CNT_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_EFP_EFEC_PER'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_EFP_EFEC_PER_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_OFI_OFICINAS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_OFI_OFICINAS_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_REC_RECIBOS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_REC_RECIBOS_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_RME_RESULMENSA'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_RME_RESULMENSA_REJECT'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_TEL_TELEFONOS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_TEL_TELEFONOS_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ZON_PEF_USU'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ZON_PEF_USU_REJECTS'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ZON_ZONIFICACION'),
                        T_TABLAS('#ESQUEMA#','APR_AUX_ZON_ZONIFICA_REJECTS'),
                        T_TABLAS('#ESQUEMA#','ARP_ARQ_RECOBRO_PERSONA'),
                        T_TABLAS('#ESQUEMA#','ARP_ARQ_RECOBRO_PERSONA_SIM'),
                        T_TABLAS('#ESQUEMA#','BATCH_DATOS_CNT'),
                        T_TABLAS('#ESQUEMA#','BATCH_DATOS_CNT_INFO'),
                        T_TABLAS('#ESQUEMA#','BATCH_DATOS_CNT_PER'),
                        T_TABLAS('#ESQUEMA#','BATCH_DATOS_GCL'),
                        T_TABLAS('#ESQUEMA#','BATCH_DATOS_PER'),
                        T_TABLAS('#ESQUEMA#','BATCH_DATOS_SALIDA'),
                        T_TABLAS('#ESQUEMA#','BATCH_QUERY_TIMERS'),
                        T_TABLAS('#ESQUEMA#','BATCH_RCF_ENTRADA'),
                        T_TABLAS('#ESQUEMA#','BIE_ADICIONAL'),
                        T_TABLAS('#ESQUEMA#','BIE_BIEN'),
			T_TABLAS('#ESQUEMA#','BIE_ADJ_ADJUDICACION'),
			T_TABLAS('#ESQUEMA#','BIE_CAR_CARGAS'),
                        T_TABLAS('#ESQUEMA#','BIE_DATOS_REGISTRALES'),
                        T_TABLAS('#ESQUEMA#','BIE_LOCALIZACION'),
                        T_TABLAS('#ESQUEMA#','BIE_PER'),
                        T_TABLAS('#ESQUEMA#','BIE_VALORACIONES'),
			T_TABLAS('#ESQUEMA#','LOB_LOTE_BIEN'),
                        T_TABLAS('#ESQUEMA#','CAU_CONTROL_ACCESO_USUARIOS'),
                        T_TABLAS('#ESQUEMA#','CEX_CONTRATOS_EXPEDIENTE'),
                        T_TABLAS('#ESQUEMA#','CFI_CONFIGURACION_INFORMES'),
                        T_TABLAS('#ESQUEMA#','CIR_CIRBE'),          	
                        T_TABLAS('#ESQUEMA#','CNT_CONTRATOS'),
			T_TABLAS('#ESQUEMA#','BIE_CNT'),
			T_TABLAS('#ESQUEMA#','TEA_CNT'),
                        T_TABLAS('#ESQUEMA#','CNT_PRECALCULO_ARQ'),
                        T_TABLAS('#ESQUEMA#','CNT_PRECALCULO_PERSISTENCIA'),
                        T_TABLAS('#ESQUEMA#','CNV_AUX_ACUERDOS'),
                        T_TABLAS('#ESQUEMA#','CNV_AUX_EXCLUIDOS'),
                        T_TABLAS('#ESQUEMA#','CPA_COBROS_PAGOS'),
                        T_TABLAS('#ESQUEMA#','CPE_CONTRATOS_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','CPP_CODIGO_POSTAL_PLAZA'),
                        T_TABLAS('#ESQUEMA#','CRC_CICLO_RECOBRO_CNT'),
                        T_TABLAS('#ESQUEMA#','CRE_CICLO_RECOBRO_EXP'),
                        T_TABLAS('#ESQUEMA#','CRP_CICLO_RECOBRO_PER'),
                        T_TABLAS('#ESQUEMA#','DATA_RULE_ENGINE_ANTERIOR'),
                        T_TABLAS('#ESQUEMA#','DIJ_DIRECCION_JUZGADO'),
                        T_TABLAS('#ESQUEMA#','DIR_DIRECCIONES'),
                        T_TABLAS('#ESQUEMA#','DIR_PER'),
                        T_TABLAS('#ESQUEMA#','ECO_EXCEPTUACION_CONTRATO'),
                        T_TABLAS('#ESQUEMA#','EFC_EFECTOS_CNT'),
                        T_TABLAS('#ESQUEMA#','EFC_EFECTOS_CNT_DUB'),
                        T_TABLAS('#ESQUEMA#','EFP_EFECTOS_PER'),
                        T_TABLAS('#ESQUEMA#','EFP_EFECTOS_PER_DUB'),
                        T_TABLAS('#ESQUEMA#','EXC_EXCEPTUACION'),
                        T_TABLAS('#ESQUEMA#','EXP_EXPEDIENTES'),
                        T_TABLAS('#ESQUEMA#','EXR_EXPEDIENTE_RECOBRO'),
                        T_TABLAS('#ESQUEMA#','EXT_IAC_INFO_ADD_CONTRATO'),
                        T_TABLAS('#ESQUEMA#','EXT_ICC_INFO_EXTRA_CLI'),
                        T_TABLAS('#ESQUEMA#','FRC_FICHEROS_CARGADOS'),
                        T_TABLAS('#ESQUEMA#','GAE_GESTOR_ADD_EXPEDIENTE'),
                        T_TABLAS('#ESQUEMA#','GAL_GRUPO_ALERTA'),
                        T_TABLAS('#ESQUEMA#','GCL_GRUPOS_CLIENTES'),
                        T_TABLAS('#ESQUEMA#','GEE_GESTOR_ENTIDAD'),
                        T_TABLAS('#ESQUEMA#','GEH_GESTOR_ENTIDAD_HIST'),
                        T_TABLAS('#ESQUEMA#','GEH_GESTOR_EXPEDIENTE_HIST'),
                        T_TABLAS('#ESQUEMA#','GRC_GRUPO_CARGA'),
                        T_TABLAS('#ESQUEMA#','HAC_HISTORICO_ACCESOS'),
                        T_TABLAS('#ESQUEMA#','HS_TMP_REC_EXP_AGE_CNT_EXC'),
                        T_TABLAS('#ESQUEMA#','H_RECOBRO_DETALLE_FACTURA'),
                        T_TABLAS('#ESQUEMA#','H_RECOBRO_DETALLE_FACTURA_CO'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_ADECUACIONES'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_CONTRATOS'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_CONTRATOS_BAJAS'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_CONTRATOS_PERSO'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_DIRECCIONES'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_DISPOSICIONES'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_EFECTOS'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_EFECTOS_PERSONA'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_PALANCAS'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_RECIBOS'),
                        T_TABLAS('#ESQUEMA#','H_REC_FICHERO_TELEFONOS'),
                        T_TABLAS('#ESQUEMA#','H_TMP_REC_EXP_AGE_CNT_EXC'),
                        T_TABLAS('#ESQUEMA#','IEX_INCIDENCIA_EXPEDIENTE'),
                        T_TABLAS('#ESQUEMA#','INC_INCIDENCIAS_BATCH'),
                        T_TABLAS('#ESQUEMA#','ING_INGRESO'),
                        T_TABLAS('#ESQUEMA#','IPA_INFORME_PARRAFOS'),
                        T_TABLAS('#ESQUEMA#','LOAD_CICLOS_NUSE_STAGE_1'),
                        T_TABLAS('#ESQUEMA#','MEJ_IRG_INFO_REGISTRO'),
                        T_TABLAS('#ESQUEMA#','MEJ_REG_REGISTRO'),
                        T_TABLAS('#ESQUEMA#','MOV_MOVIMIENTOS'),
                        T_TABLAS('#ESQUEMA#','PER_GCL'),
                        T_TABLAS('#ESQUEMA#','PER_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','PER_PRECALCULO_ARQ'),
                        T_TABLAS('#ESQUEMA#','PER_PRECALCULO_PERSISTENCIA'),
                        T_TABLAS('#ESQUEMA#','PEX_PERSONAS_EXPEDIENTE'),
                        T_TABLAS('#ESQUEMA#','PFS_PROC_FAC_SUBCARTERA'),
                        T_TABLAS('#ESQUEMA#','PRF_PARRAFOS'),
                        T_TABLAS('#ESQUEMA#','PRF_PROCESO_FACTURACION'),
                        T_TABLAS('#ESQUEMA#','PVB_PARRAFOS_VARIABLES'),
                        T_TABLAS('#ESQUEMA#','REA_RECOBRO_ADJUNTOS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_ADECUACIONES'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_CONTRATOS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_CONTRATOS_BAJAS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_CONTRATOS_PERSONA'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_DIRECCIONES'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_EFECTOS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_EFECTOS_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_PALANCAS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_RECIBOS'),
                        T_TABLAS('#ESQUEMA#','REC_FICHERO_TELEFONOS'),
                        T_TABLAS('#ESQUEMA#','REC_RECIBOS'),
                        T_TABLAS('#ESQUEMA#','REC_RECIBOS_DUB'),
                        T_TABLAS('#ESQUEMA#','RES_ACE_RESULTADOS_MENSAJERIA'),
                        T_TABLAS('#ESQUEMA#','TAR_TAREAS_NOTIFICACIONES'),
                        T_TABLAS('#ESQUEMA#','TEL_PER'),
                        T_TABLAS('#ESQUEMA#','TEL_TELEFONOS'),
                        T_TABLAS('#ESQUEMA#','TIT_TITULO'),
                        T_TABLAS('#ESQUEMA#','TMP_ARA_AGENCIA_REPARTO_AUX'),
                        T_TABLAS('#ESQUEMA#','TMP_ARA_SUBCARTERA_REPARTO_AU'),
                        T_TABLAS('#ESQUEMA#','TMP_ARP_ARQ_RECOBRO_PERSONA'),
                        T_TABLAS('#ESQUEMA#','TMP_CICLOS_RECOBRO_PTES'),
                        T_TABLAS('#ESQUEMA#','TMP_CNT_CONTRATOS'),
                        T_TABLAS('#ESQUEMA#','TMP_CNT_PER'),
                        T_TABLAS('#ESQUEMA#','TMP_CNT_PER_VALIDAS'),
                        T_TABLAS('#ESQUEMA#','TMP_CRC_NUEVOS'),
                        T_TABLAS('#ESQUEMA#','TMP_CRE_NUEVOS'),
                        T_TABLAS('#ESQUEMA#','TMP_CRP_NUEVOS'),
                        T_TABLAS('#ESQUEMA#','TMP_DIRECCIONES'),
                        T_TABLAS('#ESQUEMA#','TMP_GAE_GAGER'),
                        T_TABLAS('#ESQUEMA#','TMP_GCL_GRUPOS_CLIENTES'),
                        T_TABLAS('#ESQUEMA#','TMP_PER_ARQUETIPO'),
                        T_TABLAS('#ESQUEMA#','TMP_PER_FILTRADAS'),
                        T_TABLAS('#ESQUEMA#','TMP_PER_GCL'),
                        T_TABLAS('#ESQUEMA#','TMP_PER_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES_ARQ_REC'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES_ARQ_REC_EX'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES_ARQ_REC_PR'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES_DES_ARQ'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES_DES_ARQ_OR'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES_DES_ARQ_RE'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CNT_LIBRES_PER_ARQ'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CONTRATOS_BAJA'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CONTRATOS_BAJA_MOT'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_CONTRATOS_CONS_BAJA'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_DATA_RULE_ENGINE'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_ACTIVOS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_AGE_CNT'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_AGE_CNT_EXC'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_AGE_MAR'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_AGE_MAR_EXC'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_AGE_MAR_GES'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_AGE_MAR_SUB'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_ASIG_CARTERA'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_CANCELADOS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_DESNORMALIZADO'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_DESNORMALIZADO_AR'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_EXTINCION'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_EXTINCION_RA'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_EXTINCION_RU'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_MARCADO_RA'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_REARQUETIPADO'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_REPARTO_AGENCIAS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_REPARTO_CAR'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_REPARTO_CAR_VRE'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_REPARTO_SUB'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_ROTACION'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_SIN_CONTRATOS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_SIN_CONTRATOS_SUB'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_SIN_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_SIN_PERSONAS_SUB'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_SIN_RIESGOS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_EXP_SIN_RIESGOS_SUB'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_FICHERO_CONTRATOS'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_NUEVOS_CLI'),
                        T_TABLAS('#ESQUEMA#','TMP_REC_REPARTO_DIA_ANTERIOR'),
                        T_TABLAS('#ESQUEMA#','TMP_SAGER_INFO'),
                        T_TABLAS('#ESQUEMA#','AAA_ACTITUD_APTITUD_ACTUACION'),
                        T_TABLAS('#ESQUEMA#','ADJ_ADJUNTOS'),
                        T_TABLAS('#ESQUEMA#','ASU_ASUNTOS'),
			T_TABLAS('#ESQUEMA#','TEA_TERMINOS_ACUERDO'),
                        T_TABLAS('#ESQUEMA#','CCL_CONTRATOS_CLIENTE'),
                        T_TABLAS('#ESQUEMA#','CLI_CLIENTES'),
                        T_TABLAS('#ESQUEMA#','CPE_CORREOS_PENDIENTES'),
                        T_TABLAS('#ESQUEMA#','DPR_DECISIONES_PROCEDIMIENTOS'),
                        T_TABLAS('#ESQUEMA#','EMP_NMBEMBARGOS_PROCEDIMIENTOS'),
                        T_TABLAS('#ESQUEMA#','EPE_EXCEPTUACION_PERSONA'),
                        T_TABLAS('#ESQUEMA#','GAA_GESTOR_ADICIONAL_ASUNTO'),
                        T_TABLAS('#ESQUEMA#','GAH_GESTOR_ADICIONAL_HISTORICO'),
                        T_TABLAS('#ESQUEMA#','IAC_EXTRA_DIRECCIONES'),
                        T_TABLAS('#ESQUEMA#','ITA_INPUTS_TAREAS'),
                        T_TABLAS('#ESQUEMA#','LIN_ASUNTOS_NUEVOS'),
                        T_TABLAS('#ESQUEMA#','LIN_ASUNTOS_NUEVOS_JUD'),
                        T_TABLAS('#ESQUEMA#','LIN_ASUNTOS_PARA_CREAR'),
                        T_TABLAS('#ESQUEMA#','LIN_ENVIOS_TASAS'),
                        T_TABLAS('#ESQUEMA#','LOT_LOTE'),
                        T_TABLAS('#ESQUEMA#','MIGRACION_LUCANIA_DEPUR'),
                        T_TABLAS('#ESQUEMA#','PRC_CEX'),
                        T_TABLAS('#ESQUEMA#','PRC_PER'),
                        T_TABLAS('#ESQUEMA#','PRC_PROCEDIMIENTOS'),
			T_TABLAS('#ESQUEMA#','PRB_PRC_BIE'),
			T_TABLAS('#ESQUEMA#','SUB_SUBASTA'),
			T_TABLAS('#ESQUEMA#','LOS_LOTE_SUBASTA'),
                        T_TABLAS('#ESQUEMA#','PRD_PROCEDIMIENTOS_DERIVADOS'),
                        T_TABLAS('#ESQUEMA#','RPR_PRC_TOMA_DECISION'),
                        T_TABLAS('#ESQUEMA#','RSP_RESITUAR_PROCEDIMIENTO_BK'),
                        T_TABLAS('#ESQUEMA#','SCD_SEGUIMIENTO_CAMPANYA_DIC'),
                        T_TABLAS('#ESQUEMA#','SIDHI_REL_CABECERA_TPO'),
                        T_TABLAS('#ESQUEMA#','SINC_CONTRATO_LETRADO_PFS'),
                        T_TABLAS('#ESQUEMA#','TER_TAREA_EXTERNA_RECUPERACION'),
                        T_TABLAS('#ESQUEMA#','TEX_TAREA_EXTERNA'),
			T_TABLAS('#ESQUEMA#','TEV_TAREA_EXTERNA_VALOR'),
                        T_TABLAS('#ESQUEMA#','TMP_ACE_ACC_EXTRAJUD'),
                        T_TABLAS('#ESQUEMA#','TMP_ADJUNTOS_PTE'),
                        T_TABLAS('#ESQUEMA#','TMP_ARQUETIPADO_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','TMP_CLI_CLIENTES'),
                        T_TABLAS('#ESQUEMA#','TMP_COMPROBAR_DIRECCIONES'),
                        T_TABLAS('#ESQUEMA#','TMP_DIRECCIONES_JUZGADOS'),
                        T_TABLAS('#ESQUEMA#','TMP_FECHASMAYOR_SIT_VALOR'),
                        T_TABLAS('#ESQUEMA#','TMP_FECHAS_CONTRATOS'),
                        T_TABLAS('#ESQUEMA#','TMP_FECHAS_SITUACION_VALOR'),
                        T_TABLAS('#ESQUEMA#','TMP_GAL_TABLA_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','TMP_IAC_VALUE'),
                        T_TABLAS('#ESQUEMA#','TMP_INSTRUCCIONES_TAREAS_DEMO'),
                        T_TABLAS('#ESQUEMA#','TMP_JUZGADOS_DECANO'),
                        T_TABLAS('#ESQUEMA#','TMP_PERSONAS_RIESGO'),
                        T_TABLAS('#ESQUEMA#','TMP_PER_NOMINA_PARO_PENSION'),
                        T_TABLAS('#ESQUEMA#','TMP_PESOS_TPO_ID'),
                        T_TABLAS('#ESQUEMA#','TMP_PLAZOS_DEMO'),
                        T_TABLAS('#ESQUEMA#','TMP_PRIORIDAD_ARQ_PERSONAS'),
                        T_TABLAS('#ESQUEMA#','VCA_VALIDACION_CARGA_ANTERIOR'),
			T_TABLAS('#ESQUEMA#','MINIRECOVERY_PROC_VIVOS'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_RECURSOS'),
			T_TABLAS('#ESQUEMA#','ITI_ITINERARIOS'),
			T_TABLAS('#ESQUEMA#','MIG_CONCURSOS_CABECERA'),
			T_TABLAS('#ESQUEMA#','MIG_BIENES_CARGAS'),
			T_TABLAS('#ESQUEMA#','MINIRECOVERY_CARGAS_BIENES_OLD'),
			T_TABLAS('#ESQUEMA#','MINIRECOVERY_CNT_PROC_VIVOS_A'),
			T_TABLAS('#ESQUEMA#','MINIRECOVERY_CNT_PROC_VIVOS'),
			T_TABLAS('#ESQUEMA#','MINIRECOVERY_STOCK_BIENES'),
			T_TABLAS('#ESQUEMA#','MIG_CONCURSOS_OPERACIONES'),
			T_TABLAS('#ESQUEMA#','MIG_PROCS_SUBASTAS_LOTES'),
			T_TABLAS('#ESQUEMA#','MIG_PROCS_SUBASTA_LOTES_BIENES'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_OPERACIONES'),
			T_TABLAS('#ESQUEMA#','MIG_BIENES_ACTIVOS_ADJUDICADOS'),
			T_TABLAS('#ESQUEMA#','MINIRECOVERY_PER_PROC_VIVOS'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_EMBARGOS'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_CABECERA'),
			T_TABLAS('#ESQUEMA#','PRC_PROCEDIMIENTOS_DEL'),
			T_TABLAS('#ESQUEMA#','MIG_TMP_CNT_ID'),
			T_TABLAS('#ESQUEMA#','MIG_BIE_TMP_CNT_ID'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_BIENES_DV9'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_BIENES_V9'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_BIENES'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_BIENES_DAT'),
			T_TABLAS('#ESQUEMA#','MIG_BIE_TMP_PER_ID'),
			T_TABLAS('#ESQUEMA#','MIG_BIENES_OPERACIONES'),
			T_TABLAS('#ESQUEMA#','MIG_BIENES_PERSONAS'),
			T_TABLAS('#ESQUEMA#','BIE_ADICIONAL_OLD'),
			T_TABLAS('#ESQUEMA#','MIG_BIENES'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_SUBASTAS'),
			T_TABLAS('#ESQUEMA#','MIG_TMP_PER_ID'),
			T_TABLAS('#ESQUEMA#','MIG_PROCEDIMIENTOS_DEMANDADOS'),
			T_TABLAS('#ESQUEMA#','H_REC_FICHERO_CONTRATOS_PERSON'),
			T_TABLAS('#ESQUEMA#','REC_FICHERO_CONTRATOS_PERSONAS'),
			T_TABLAS('#ESQUEMA#','CNV_AUX_ACUERDOS_LRC'),
			T_TABLAS('#ESQUEMA#','APR_AUX_ABC_BIECNT_CONSOL'),
			T_TABLAS('#ESQUEMA#','MIG_MAESTRA_HITOS'),
			T_TABLAS('#ESQUEMA#','TAR_TAREAS_NOTIFICACIONES_BK'),
			T_TABLAS('#ESQUEMA#','MIG_PROCS_OBSERVACIONES'),
			T_TABLAS('#ESQUEMA#','TEV_TAREA_EXTERNA_VALOR_BAK'),
			T_TABLAS('#ESQUEMA#','MIG_MAESTRA_HITOS_VALORES'),
			T_TABLAS('#ESQUEMA#','DATA_RULE_ENGINE_PER_NIV'),
			T_TABLAS('#ESQUEMA#','DATA_RULE_ENGINE_CNT_NIV'),
			T_TABLAS('#ESQUEMA#','H_ARP_ARQ_RECOBRO_PERSONA'),
			T_TABLAS('#ESQUEMA#','DATA_RULE_ENGINE'),
			T_TABLAS('#ESQUEMA#','INF_INB_INFORME_BIENES'),
			T_TABLAS('#ESQUEMA#','RCF_AGE_AGENCIAS'),     
			T_TABLAS('#ESQUEMA#','BIE_SUI_SUBASTA_INSTRUCCIONES'),
			T_TABLAS('#ESQUEMA#','ADA_ADJUNTOS_ASUNTOS'),
			T_TABLAS('#ESQUEMA#','CRE_PRC_CEX'),
			T_TABLAS('#ESQUEMA#','RCF_TCF_TIPO_COBRO_FACTURA'),
			T_TABLAS('#ESQUEMA#','RCR_RECURSOS_PROCEDIMIENTOS'),
			T_TABLAS('#ESQUEMA#','ARQ_ARQUETIPOS'),
			T_TABLAS('#ESQUEMA#','COV_CONVENIOS'),
			T_TABLAS('#ESQUEMA#','BIE_TEA'),
			T_TABLAS('#ESQUEMA#','ANC_ANALISIS_CONTRATOS'),
			T_TABLAS('#ESQUEMA#','EST_ESTADOS'),
			T_TABLAS('#ESQUEMA#','REE_REGLAS_ELEVACION_ESTADO'),
			T_TABLAS('#ESQUEMA#','COV_CONVENIOS_CREDITOS')
                        );
						




--/*
--##########################################
--## FIN Configuraciones a rellenar
--##########################################
--*/  
 -- Vble. para loop
   V_TEMP_TABLAS  T_TABLAS;
 -- Vble. para almacenar esquema
   V_TEMP_ESQUEMA  VARCHAR(30);
 --  F T_ARRAY_TABLAS;ZON_PEF_USU


--##########################################
--## PROCEDIMIENTOS
--##########################################

PROCEDURE "PRO_ANALIZA"("P_OWNER" IN VARCHAR2, "P_TABLA" IN VARCHAR2 ) IS
       L_PARTITIONED VARCHAR2(3);
       BEGIN
        DBMS_OUTPUT.PUT_LINE('Analizando tabla : '||P_OWNER||'.'||P_TABLA);
         L_PARTITIONED:=NULL;
         BEGIN
           SELECT PARTITIONED INTO L_PARTITIONED
           FROM all_tables WHERE TABLE_NAME=Upper(P_TABLA) AND ROWNUM=1 AND OWNER =Upper(P_OWNER);
         EXCEPTION WHEN others THEN
           L_PARTITIONED:=NULL;
         END;

           IF L_PARTITIONED = 'YES' THEN
             DBMS_STATS.gather_table_stats(OWNNAME => Upper(P_OWNER), TABNAME => Upper(p_tabla),
               DEGREE => 14, ESTIMATE_PERCENT  => 20, METHOD_OPT => 'FOR ALL INDEXED COLUMNS SIZE 10',
               GRANULARITY => 'PARTITION', CASCADE => TRUE);
             DBMS_STATS.gather_table_stats(OWNNAME => Upper(P_OWNER), TABNAME => Upper(p_tabla),
               DEGREE => 14, ESTIMATE_PERCENT  => 20, METHOD_OPT => 'FOR ALL INDEXED COLUMNS SIZE 10',
               GRANULARITY => 'GLOBAL', CASCADE => TRUE);
           ELSE
               DBMS_STATS.gather_table_stats(OWNNAME => Upper(P_OWNER), TABNAME => Upper(p_tabla),
             DEGREE => 14, ESTIMATE_PERCENT  => 20, METHOD_OPT => 'FOR ALL COLUMNS size 1',
             GRANULARITY => 'GLOBAL', CASCADE => TRUE);
           END IF;

        EXCEPTION WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE('ERROR al pasar estadisticas' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );

       end;


BEGIN

dbms_output.enable(1000000);

--##########################################
--## DESACTIVAR RESTRICCIONES DE CLAVE AJENA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_#ESQUEMA#.FIRST .. V_#ESQUEMA#.LAST
   LOOP
      BEGIN
        V_TEMP_TABLAS := V_#ESQUEMA#(I);
        
        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
        LOOP
            BEGIN
                
                   DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );    
                   EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        
            END;    
        END LOOP;    
        
     EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     END;
   END LOOP;
   COMMIT;   

--##########################################
--## DESACTIVAR RESTRICCIONES DE CLAVE PRIMARIA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );-----------------------------------------------------------
   FOR I IN V_#ESQUEMA#.FIRST .. V_#ESQUEMA#.LAST
   LOOP
      BEGIN
        V_TEMP_TABLAS := V_#ESQUEMA#(I);
        
        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
        LOOP
            BEGIN
                
                   DBMS_OUTPUT.PUT_LINE('Desactivando : '|| J.table_name ||'.'|| J.constraint_name );    
                   EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME || ' CASCADE ';        
            END;    
        END LOOP;    
        
     EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERROR al desactivar la constraint ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     END;
   END LOOP;
   COMMIT;   



--##########################################
--## TRUNCADO DE TABLAS
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**Truncamos tablas**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_#ESQUEMA#.FIRST .. V_#ESQUEMA#.LAST
   LOOP
      begin
        V_TEMP_TABLAS := V_#ESQUEMA#(I);
        DBMS_OUTPUT.PUT_LINE('Truncando tabla : '||V_TEMP_TABLAS(1)||'.'||V_TEMP_TABLAS(2));   
        V_MSQL := 'TRUNCATE TABLE '||V_TEMP_TABLAS(1)||'.'||V_TEMP_TABLAS(2);
        EXECUTE IMMEDIATE V_MSQL;
        
        PRO_ANALIZA(V_TEMP_TABLAS(1),V_TEMP_TABLAS(2));  --ANALIZAMOS LA TABLA
        
        V_TEMP_ESQUEMA := V_TEMP_TABLAS(1); -- GUARDAMOS EL ESQUEMA EN USO
        
     exception when others then
       DBMS_OUTPUT.PUT_LINE('ERROR al truncar la tabla ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     end;
   END LOOP; --LOOP #ESQUEMA#
   COMMIT;   

--##########################################
--## ACTUACIONES ESPECIALES #ESQUEMA#;
--##########################################

   DBMS_OUTPUT.PUT_LINE('******************************' );
   DBMS_OUTPUT.PUT_LINE('** Actuaciones especiales ****' );
   DBMS_OUTPUT.PUT_LINE('******************************' );

  begin-----------------------------------------------------------
      -- Limpiamos la tabla de ranking y subcarteras
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_SUR_SUBCARTERA_RANKING');
      DELETE FROM RCF_SUR_SUBCARTERA_RANKING;
      
      -- Limpiamos la tabla de relaciones de subcarteras y agencias
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_SUA_SUBCARTERA_AGENCIAS');
      DELETE FROM RCF_SUA_SUBCARTERA_AGENCIAS;
      
      -- Limpiamos la tabla de procesos de facturaci?n
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla PFS_PROC_FAC_SUBCARTERA');
      DELETE FROM PFS_PROC_FAC_SUBCARTERA;
      
      -- Limpiamos la tabla de subcarteras
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla PFS_PROC_FAC_SUBCARTERA');
      DELETE FROM RCF_SCA_SUBCARTERA;
      
      -- Limpiamos la tabla de relaciones de esquemas y carteras
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_ESC_ESQUEMA_CARTERAS');
      DELETE FROM RCF_ESC_ESQUEMA_CARTERAS;
      
      -- Limpiamos la tabla de metas volantes
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_MVL_META_VOLANTE');
      DELETE FROM RCF_MVL_META_VOLANTE;
      
      -- Limpiamos la tabla de modelos de metas volantes
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_ITV_ITI_METAS_VOLANTES');
      DELETE FROM RCF_ITV_ITI_METAS_VOLANTES;
      
      -- Limpiamos la tabla de tarifas de cobro por tramos de facturaci?n
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_TCT_TARIF_COBRO_TRAMO');
      DELETE FROM RCF_TCT_TARIF_COBRO_TRAMO;
      
      -- Limpiamos la tabla de tramos de facturaci?n
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_TRF_TRAMO_FACTURACION');
      DELETE FROM RCF_TRF_TRAMO_FACTURACION;
      
      -- Limpiamos la tabla de tarifas por conceptos de cobros
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_TCC_TARIFAS_CONCEP_COBRO');
      DELETE FROM RCF_TCC_TARIFAS_CONCEP_COBRO;
      
      -- Limpiamos la tabla de tipos de cobros de facturaci?n
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_TCF_TIPO_COBRO_FACTURA');
      DELETE FROM RCF_TCF_TIPO_COBRO_FACTURA;
      
      -- Limpiamos la tabla de correctores de facturaci?n
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_COF_CORRECTOR_FACTURA');
      DELETE FROM RCF_COF_CORRECTOR_FACTURA;
      
      -- Limpiamos la tabla de modelos de facturaci?n
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_MFA_MODELOS_FACTURACION');
      DELETE FROM RCF_MFA_MODELOS_FACTURACION;
      
      -- Limpiamos la tabla de modelos de pol?ticas de acuerdos
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_POA_POLITICA_ACUERDOS');
      DELETE FROM RCF_POA_POLITICA_ACUERDOS;
      
      -- Limpiamos la tabla de pol?ticas de acuerdos y palancas
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_PAA_POL_ACUERDOS_PALANCAS');-----------------------------------------------------------
      DELETE FROM RCF_PAA_POL_ACUERDOS_PALANCAS;
      
      -- Limpiamos la tabla de simulaciones de esquemas
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_ESS_ESQUEMA_SIMULACION');
      DELETE FROM RCF_ESS_ESQUEMA_SIMULACION;
      
      -- Limpiamos la tabla de esquemas
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_ESQ_ESQUEMA');
      DELETE FROM RCF_ESQ_ESQUEMA;
      
      -- Limpiamos la tabla de carteras
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_CAR_CARTERA');
      DELETE FROM RCF_CAR_CARTERA;
      
      -- Limpiamos la tabla de variables de ranking
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_MRV_MODELO_RANKING_VARS');
      DELETE FROM RCF_MRV_MODELO_RANKING_VARS;
      
      -- Limpiamos la tabla de modelos de ranking
      DBMS_OUTPUT.PUT_LINE('---Borrando la tabla RCF_MOR_MODELO_RANKING');
      DELETE FROM RCF_MOR_MODELO_RANKING;
	  
	  -- OJO:> Excepción en la limpieza de Usuarios, dejamos una estructura mínima para el arranque.
	  DBMS_OUTPUT.PUT_LINE('---Borrando la tabla USD_USUARIOS_DESPACHOS salvo las relaciones vinculadas a los des-----------------------------------------------------------pachos de BANKMASTER');
	  DELETE FROM USD_USUARIOS_DESPACHOS USD WHERE USD.DES_ID <> 1; -- AND USD.USU_ID NOT IN (SELECT DISTINCT USU_ID FROM #ESQUEMA_MASTER#.USU_USUARIOS WHERE USU_USERNAME LIKE '%BANKMASTER%');
    DELETE FROM USD_USUARIOS_DESPACHOS USD WHERE USD.USU_ID NOT IN (SELECT DISTINCT USU_ID FROM #ESQUEMA_MASTER#.USU_USUARIOS WHERE USU_USERNAME LIKE '%BANKMASTER%');
	  
	  DBMS_OUTPUT.PUT_LINE('---Borrando la tabla DES_DESPACHO_EXTERNO salvo el despacho de BANKMASTER');
	  DELETE FROM DES_DESPACHO_EXTERNO DES WHERE DES.DES_ID <> 1;


	  DBMS_OUTPUT.PUT_LINE('---Borrando la tabla ZON_PEF_USU salvo la zona a la que pertenece el usuario');
    DELETE FROM ZON_PEF_USU WHERE USU_ID NOT IN (SELECT DISTINCT USU_ID FROM #ESQUEMA_MASTER#.USU_USUARIOS WHERE USU_USERNAME LIKE '%BANKMASTER%');
    
	  DBMS_OUTPUT.PUT_LINE('---Borrando la tabla COM_COMITES salvo la zona a la que pertenece el usuario');
    DELETE FROM COM_COMITES WHERE ZON_ID NOT IN (SELECT ZON_ID FROM ZON_PEF_USU);                
    DBMS_OUTPUT.PUT_LINE('---Borrando la tabla ZON_ZONIFICACION salvo la zona a la que pertenece el usuario');

    DELETE FROM ZON_ZONIFICACION WHERE ZON_ID NOT IN (SELECT ZON_ID FROM ZON_PEF_USU);    
    
    DBMS_OUTPUT.PUT_LINE('---Borrando la tabla OFI_OFICINAS salvo la zona a la que pertenece el usuario');
    DELETE FROM OFI_OFICINAS WHERE OFI_ID NOT IN (SELECT ZON.OFI_ID FROM ZON_ZONIFICACION ZON INNER JOIN ZON_PEF_USU ZPU ON ZON.ZON_ID = ZPU.ZON_ID ); 
    
    
--	DBMS_OUTPUT.PUT_LINE('---Borrando la tabla GRU_GRUPOS_USUARIOS salvo la zona a la que pertenece el usuario');
--    DELETE FROM #ESQUEMA_MASTER#.GRU_GRUPOS_USUARIOS WHERE USU_ID_USUARIO NOT IN (SELECT DISTINCT USU_ID FROM #ESQUEMA_MASTER#.USU_USUARIOS WHERE USU_USERNAME LIKE '%BANKMASTER%');    

--	DBMS_OUTPUT.PUT_LINE('---Borrando la tabla USU_USUARIOS salvo el usuario de BANKMASTER');
--	DELETE FROM #ESQUEMA_MASTER#.USU_USUARIOS WHERE USU_USERNAME NOT LIKE '%BANKMASTER%';

    COMMIT;
      
    exception when others then
     DBMS_OUTPUT.PUT_LINE('ERROR al borrar la tabla ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    end;



--##########################################
--## DROPEO DE TABLAS TMP_MOV_201*
--##########################################

   
   FOR I IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE TABLE_NAME LIKE 'TMP_MOV_201%' AND OWNER = '#ESQUEMA#')
   LOOP
     BEGIN
        DBMS_OUTPUT.PUT_LINE('DROP TABLE : #ESQUEMA#.'|| I.TABLE_NAME );
        
            V_MSQL :='DROP TABLE #ESQUEMA#.'|| I.TABLE_NAME ||' PURGE';
            EXECUTE IMMEDIATE V_MSQL;                 
     EXCEPTION WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('ERROR AL BORRAR LA TABLA ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     END;
   END LOOP I;
   COMMIT;

--##########################################
--## REFRESCAMOS LAS VISTAS MATERIALIZADAS- SOLO EN #ESQUEMA#
--##########################################


   FOR I IN (select OBJECT_NAME from user_objects obj , all_tables allt where obj.object_type='MATERIALIZED VIEW'
              and obj.object_name = allt.table_name and allt.owner = '#ESQUEMA#')
   LOOP
    begin
   DBMS_OUTPUT.PUT_LINE('Refresco vista : '||I.OBJECT_NAME );
           DBMS_MVIEW.REFRESH (I.OBJECT_NAME );
     exception when others then
       DBMS_OUTPUT.PUT_LINE('ERROR al refrescar la vista materializada ' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
     END;
   END LOOP I;
   COMMIT;

--##########################################
--## ACTIVAMOS DE NUEVO RESTRICCIONES DE CLAVE PRIMARIA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_#ESQUEMA#.FIRST .. V_#ESQUEMA#.LAST
   LOOP
        V_TEMP_TABLAS := V_#ESQUEMA#(I);
        
        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P'
                  AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
        LOOP
            BEGIN              
                       DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );    
                       EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        

                        --##########################################
                        --## ACTIVAMOS DE NUEVO RESTRICCIONES EN CASCADA
                        --##########################################

                       FOR H IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE R_CONSTRAINT_NAME=J.CONSTRAINT_NAME )
                        LOOP
                            BEGIN              
                                DBMS_OUTPUT.PUT_LINE('Activando : '|| H.table_name ||'.'|| H.constraint_name );    
                                EXECUTE IMMEDIATE 'ALTER TABLE ' || H.TABLE_NAME || ' ENABLE CONSTRAINT ' || H.CONSTRAINT_NAME;
                              
                            EXCEPTION WHEN OTHERS THEN
                                DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
                            END;
                        END LOOP H;            
                      
         EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
         END;
        END LOOP;            
   END LOOP;
   COMMIT;   

--##########################################
--## ACTIVAMOS DE NUEVO RESTRICCIONES DE CLAVE AJENA
--##########################################

   DBMS_OUTPUT.PUT_LINE('********************' );
   DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
   DBMS_OUTPUT.PUT_LINE('********************' );
   FOR I IN V_#ESQUEMA#.FIRST .. V_#ESQUEMA#.LAST
   LOOP
        V_TEMP_TABLAS := V_#ESQUEMA#(I);
        
        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R'
                  AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2) AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
        LOOP
            BEGIN              
                       DBMS_OUTPUT.PUT_LINE('Activando : '|| J.table_name ||'.'|| J.constraint_name );    
                       EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                       
         EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
         END;
        END LOOP;            
   END LOOP;
   COMMIT;   

--##########################################
--## LISTADO RESTRICCIONES NO ACTIVADAS
--##########################################

   DBMS_OUTPUT.PUT_LINE('*******************************' );
   DBMS_OUTPUT.PUT_LINE('**FALTA ACTIVAR RESTRICCIONES**' );
   DBMS_OUTPUT.PUT_LINE('*******************************' );

        FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM USER_CONSTRAINTS WHERE  STATUS='DISABLED'
                AND TRUNC(LAST_CHANGE) = TRUNC(SYSDATE))
        LOOP
            BEGIN              
                DBMS_OUTPUT.PUT_LINE('Activación extra : '|| J.table_name ||'.'|| J.constraint_name );    
                 EXECUTE IMMEDIATE 'ALTER TABLE ' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
                       
         EXCEPTION WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('ERROR al activar la constraint' || TO_CHAR(SQLCODE) || ' ' || SQLERRM );
         END;
        END LOOP;            


   DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO' );



EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE( TO_CHAR(SQLCODE) || ' ' || SQLERRM );

 
END;
/

EXIT;



