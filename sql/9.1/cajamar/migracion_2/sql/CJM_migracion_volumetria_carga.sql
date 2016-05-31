--/*
--##########################################
--## AUTOR=GUSTAVO MORA NAVARRO
--## FECHA_CREACION=20151103
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=XXXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Volcado en log de la volumetría de las tablas cargadas en el proceso de migración
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

    
    SELECT           'LOAD'      AS BLOQUE, 'MIG_BIENES' AS TABLA, count(*) from  CM01.MIG_BIENES
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCEDIMIENTOS_BIENES' AS TABLA, count(*) from  CM01.MIG_PROCEDIMIENTOS_BIENES
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_BIENES_ACTIVOS_ADJUDICADOS' AS TABLA, count(*) from  CM01.MIG_BIENES_ACTIVOS_ADJUDICADOS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_BIENES_CARGAS' AS TABLA, count(*) from  CM01.MIG_BIENES_CARGAS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_BIENES_OPERACIONES' AS TABLA, count(*) from  CM01.MIG_BIENES_OPERACIONES
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_BIENES_PERSONAS' AS TABLA, count(*) from  CM01.MIG_BIENES_PERSONAS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCEDIMIENTOS_OPERACIONES' AS TABLA, count(*) from  CM01.MIG_PROCEDIMIENTOS_OPERACIONES
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCEDIMIENTOS_DEMANDADOS' AS TABLA, count(*) from  CM01.MIG_PROCEDIMIENTOS_DEMANDADOS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCEDIMIENTOS_CABECERA' AS TABLA, count(*) from  CM01.MIG_PROCEDIMIENTOS_CABECERA
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCEDIMIENTOS_EMBARGOS' AS TABLA, count(*) from  CM01.MIG_PROCEDIMIENTOS_EMBARGOS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCEDIMIENTOS_SUBASTAS' AS TABLA, count(*) from  CM01.MIG_PROCEDIMIENTOS_SUBASTAS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCS_SUBASTAS_LOTES' AS TABLA, count(*) from  CM01.MIG_PROCS_SUBASTAS_LOTES
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCEDIMIENTOS_RECURSOS' AS TABLA, count(*) from  CM01.MIG_PROCEDIMIENTOS_RECURSOS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCS_SUBASTAS_LOTES_BIEN' AS TABLA, count(*) from  CM01.MIG_PROCS_SUBASTAS_LOTES_BIEN
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_CONCURSOS_CABECERA' AS TABLA, count(*) from  CM01.MIG_CONCURSOS_CABECERA
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_CONCURSOS_OPERACIONES' AS TABLA, count(*) from  CM01.MIG_CONCURSOS_OPERACIONES
--    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_ANOTACIONES' AS TABLA, count(*) from  CM01.MIG_ANOTACIONES
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_PROCS_OBSERVACIONES_TROZOS' AS TABLA, count(*) from  CM01.MIG_PROCS_OBSERVACIONES_TROZOS
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_EXPEDIENTES_OPERACIONES' AS TABLA, count(*) from  CM01.MIG_EXPEDIENTES_OPERACIONES
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_EXPEDIENTES_OBSERVACIONES' AS TABLA, count(*) from  CM01.MIG_EXPEDIENTES_OBSERVACIONES    
    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_EXPEDIENTES_CERTIFI_SALDO' AS TABLA, count(*) from  CM01.MIG_EXPEDIENTES_CERTIFI_SALDO
--    UNION ALL SELECT 'LOAD'      AS BLOQUE, 'MIG_EXPEDIENTES_OBSER_TROZOS' AS TABLA, count(*) from  CM01.MIG_EXPEDIENTES_OBSER_TROZOS
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'MIG_MAESTRA_HITOS'              AS TABLA, count(*) from CM01.MIG_MAESTRA_HITOS
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'MIG_MAESTRA_HITOS_VALORES'      AS TABLA, count(*) from CM01.MIG_MAESTRA_HITOS_VALORES
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'MIG_TMP_CNT_ID'                 AS TABLA, count(*) from CM01.MIG_TMP_CNT_ID 
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'MIG_TMP_PER_ID'                 AS TABLA, count(*) from CM01.MIG_TMP_PER_ID 
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'CLI_CLIENTES'                   AS TABLA, count(*) from CM01.CLI_CLIENTES WHERE USUARIOCREAR = 'MIGRA2CM01'                                             
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'CCL_CONTRATOS_CLIENTE'          AS TABLA, count(*) from CM01.CCL_CONTRATOS_CLIENTE WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'EXP_EXPEDIENTES'                AS TABLA, count(*) from CM01.EXP_EXPEDIENTES WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'PEX_PERSONAS_EXPEDIENTE'        AS TABLA, count(*) from CM01.PEX_PERSONAS_EXPEDIENTE WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'CEX_CONTRATOS_EXPEDIENTE'       AS TABLA, count(*) from CM01.CEX_CONTRATOS_EXPEDIENTE WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'ASU_ASUNTOS'                    AS TABLA, count(*) from CM01.ASU_ASUNTOS WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'PRC_PROCEDIMIENTOS'             AS TABLA, count(*) from CM01.PRC_PROCEDIMIENTOS WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'PRC_PER'                        AS TABLA, count(*) from CM01.PRC_PER 
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'PRC_CEX'                        AS TABLA, count(*) from CM01.PRC_CEX 
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'TAR_TAREAS_NOTIFICACIONES'      AS TABLA, count(*) from CM01.TAR_TAREAS_NOTIFICACIONES WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'TEX_TAREA_EXTERNA'              AS TABLA, count(*) from CM01.TEX_TAREA_EXTERNA WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'TEV_TAREA_EXTERNA_VALOR'        AS TABLA, count(*) from CM01.TEV_TAREA_EXTERNA_VALOR WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'SUB_SUBASTA'                    AS TABLA, count(*) from CM01.SUB_SUBASTA WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'LOS_LOTE_SUBASTA'               AS TABLA, count(*) from CM01.LOS_LOTE_SUBASTA WHERE USUARIOCREAR = 'MIGRA2CM01'                                         
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'LOB_LOTE_BIEN'                  AS TABLA, count(*) from CM01.LOB_LOTE_BIEN
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'PRB_PRC_BIE'                    AS TABLA, count(*) from CM01.PRB_PRC_BIE WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'GAA_GESTOR_ADICIONAL_ASUNTO'    AS TABLA, count(*) from CM01.GAA_GESTOR_ADICIONAL_ASUNTO WHERE USUARIOCREAR = 'MIGRA2CM01'
    UNION ALL SELECT 'MIGRACION' AS BLOQUE, 'GAH_GESTOR_ADICIONAL_HISTORICO' AS TABLA, count(*) from CM01.GAH_GESTOR_ADICIONAL_HISTORICO WHERE USUARIOCREAR = 'MIGRA2CM01';

EXIT;