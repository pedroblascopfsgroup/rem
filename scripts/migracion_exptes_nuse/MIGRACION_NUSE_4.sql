-- ----------------------------------------------------------------------------
-- SCRIPTS DE MIGRACIÓN DE NUSE A RECOVERY
-- ORDEN DEL SCRIPT: 4
-- SCRIPT: Eliminación de la tabla de carga de datos de NUSE
-- AUTOR: Guillem Pascual Serra   
-- EMPRESA: PFSGROUP
-- -----------------------------------------------------------------------------

-- AQUI SE PUEDEN METER LOS ÍNDICES CREADOS DURANTE EL PROCESO DE MIGRACIÓN

-- Eliminamos la tabla donde hemos cargado los datos provenientes de NUSE
--DROP TABLE LOAD_CICLOS_NUSE_STAGE_1;

-- Eliminamos la tabla donde hemos cargado los datos provenientes de NUSE filtrados
DROP TABLE LOAD_CICLOS_NUSE_STAGE_2 PURGE;

-- Eliminamos la tabla temporal que contiene los expedientes y los contratos
DROP TABLE TMP_MIGRACION_NUSE_1 PURGE;

-- Eliminamos la tabla temporal que contiene los expedientes y sus personas
DROP TABLE TMP_MIGRACION_NUSE_2 PURGE;

-- Eliminamos la tabla temporal que contiene los ciclos de recobro de los expedientes
DROP TABLE TMP_MIGRACION_NUSE_3 PURGE;

-- Eliminamos la tabla temporal que contiene los ciclos de recobro de los expedientes y sus importes
DROP TABLE TMP_MIGRACION_NUSE_4 PURGE;

-- Eliminamos la tabla temporal que contiene los ciclos de recobro de los contratos
DROP TABLE TMP_MIGRACION_NUSE_5 PURGE;

-- Eliminamos la tabla temporal que contiene los ciclos de recobro de los personas
DROP TABLE TMP_MIGRACION_NUSE_6 PURGE;

-- Eliminamos la tabla temporal que contiene los nuevos id de expedientes
DROP TABLE TMP_NUSE_EXP_ID_NUEVOS PURGE;

COMMIT;