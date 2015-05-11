-- ----------------------------------------------------------------------------
-- SCRIPTS DE MIGRACIÓN DE NUSE A RECOVERY
-- ORDEN DEL SCRIPT: 1
-- SCRIPT: Limpieza de la configuración de Recobro
-- AUTOR: Guillem Pascual Serra   
-- EMPRESA: PFSGROUP
-- -----------------------------------------------------------------------------

-- Limpiamos la tabla de control de procedimientos
DELETE FROM CCP_CONTROL_CALIDAD_PROC;

-- Limpiamos la tabla de control de accesos
DELETE FROM CCA_CONTROL_CALIDAD;

-- Limpiamos la tabla de historico de accesos
DELETE FROM HAC_HISTORICO_ACCESOS;

-- Limpiamos la tabla de relaciones entre personas y expedientes
DELETE FROM PEX_PERSONAS_EXPEDIENTE;

-- Limpiamos la tabla de ciclos de recobro de personas
DELETE FROM CRP_CICLO_RECOBRO_PER;

-- Limpiamos la tabla de ciclos de recobro de contratos
DELETE FROM CRC_CICLO_RECOBRO_CNT;

-- Limpiamos la tabla de ciclos de recobro de notificaciones
DELETE FROM CRT_CICLO_RECOBRO_TAREA_NOTI;

-- Limpiamos la tabla de ciclos de recobro de expedientes
DELETE FROM CRE_CICLO_RECOBRO_EXP;

-- Limpiamos la tabla de relaciones de contratos y expedientes
DELETE FROM CEX_CONTRATOS_EXPEDIENTE;

-- Limpiamos la tabla de tareas y notificaciones
DELETE FROM TAR_TAREAS_NOTIFICACIONES;

-- Limpiamos la tabla de expedientes de recobro
DELETE FROM EXR_EXPEDIENTE_RECOBRO;

-- Limpiamos la tabla de expedientes
DELETE FROM EXP_EXPEDIENTES;

-- Limpiamos la tabla de ranking y subcarteras
DELETE FROM RCF_SUR_SUBCARTERA_RANKING;

-- Limpiamos la tabla de relaciones de subcarteras y agencias
DELETE FROM RCF_SUA_SUBCARTERA_AGENCIAS;  

-- Limpiamos la tabla de procesos de facturación
DELETE FROM PFS_PROC_FAC_SUBCARTERA;

-- Limpiamos la tabla de subcarteras
DELETE FROM RCF_SCA_SUBCARTERA;

-- Limpiamos la tabla de relaciones de esquemas y carteras
DELETE FROM RCF_ESC_ESQUEMA_CARTERAS;

-- Limpiamos la tabla de metas volantes
DELETE FROM RCF_MVL_META_VOLANTE;

-- Limpiamos la tabla de modelos de metas volantes 
DELETE FROM RCF_ITV_ITI_METAS_VOLANTES;

-- Limpiamos la tabla de tarifas de cobro por tramos de facturación
DELETE FROM RCF_TCT_TARIF_COBRO_TRAMO;

-- Limpiamos la tabla de tramos de facturación
DELETE FROM RCF_TRF_TRAMO_FACTURACION;

-- Limpiamos la tabla de tarifas por conceptos de cobros
DELETE FROM RCF_TCC_TARIFAS_CONCEP_COBRO;

-- Limpiamos la tabla de tipos de cobros de facturación
DELETE FROM RCF_TCF_TIPO_COBRO_FACTURA;

-- Limpiamos la tabla de correctores de facturación
DELETE FROM RCF_COF_CORRECTOR_FACTURA;

-- Limpiamos la tabla de modelos de facturación
DELETE FROM RCF_MFA_MODELOS_FACTURACION;

-- Limpiamos la tabla de modelos de políticas de acuerdos
DELETE FROM RCF_POA_POLITICA_ACUERDOS;

-- Limpiamos la tabla de políticas de acuerdos y palancas
DELETE FROM RCF_PAA_POL_ACUERDOS_PALANCAS;

-- Limpiamos la tabla de las agencias de recobro
DELETE FROM RCF_AGE_AGENCIAS;

-- Limpiamos la tabla de simulaciones de esquemas
DELETE FROM RCF_ESS_ESQUEMA_SIMULACION;

-- Limpiamos la tabla de esquemas
DELETE FROM RCF_ESQ_ESQUEMA;

-- Limpiamos la tabla de carteras
DELETE FROM RCF_CAR_CARTERA;

-- Limpiamos la tabla de variables de ranking
DELETE FROM RCF_MRV_MODELO_RANKING_VARS;

-- Limpiamos la tabla de modelos de ranking
DELETE FROM RCF_MOR_MODELO_RANKING;

COMMIT;


















