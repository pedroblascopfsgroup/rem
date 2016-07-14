-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`ba01` PROCEDURE `Crear_Indices_Hechos_Datawarehouse`(OUT o_error_status varchar(500))
MY_BLOCK_IND: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 26/03/2015
-- Motivos del cambio: segmento y socio
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que crea índices en las tablas del datawarehouse
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


-- -------------------------------------------- ÍNDICE -------------------------------------------
-- ÍNDICES DE HECHOS DE ACTUACIÓN RECOBRO

-- ÍNDICES DE HECHOS DE CONTRATO
    -- H_CONTRATO
    -- H_CONTRATO_INICIO_CAMPANA_RECOBRO
    -- TEMP_FECHA
    -- TEMP_H
    -- TEMP_ANT
    -- TEMP_MANTIENE
    -- TEMP_ALTA
    -- TEMP_BAJA
    -- TEMP_CONTRATO_PROCEDIMIENTO
    -- TEMP_CONTRATO_SITUACION_FINANCIERA
    -- TEMP_CONTRATO_CREDITO_INSINUADO
    -- TEMP_CONTRATO_RECOBRO
    -- TEMP_CONTRATO_DPS
    -- TEMP_CONTRATO_ACTIVIDAD
    -- TEMP_CONTRATO_ESPECIALIZADA
    -- TEMP_CONTRATO_PREVISIONES
    -- TEMP_CONTRATO_PREVISIONES_DIA
    -- TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES
    -- TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX
    -- TEMP_LOAN_INFORMATION
    -- TEMP_ESTUDIO_CARTERA
    -- TEMP_EN_MASIVA
    
-- ÍNDICES DE HECHOS DE PROCEDIMIENTOS
    -- H_PROCEDIMIENTO
    -- H_PROCEDIMIENTO_DETALLE_COBRO
    -- H_PROCEDIMIENTO_DETALLE_CONTRATO
    -- H_PROCEDIMIENTO_DETALLE_RESOLUCION
    -- TEMP_PROCEDIMIENTO_JERARQUIA
    -- TEMP_PROCEDIMIENTO_DETALLE
    -- TEMP_PROCEDIMIENTO_TAREA
    -- TEMP_PROCEDIMIENTO_CONTRATO
    -- TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO
    -- TEMP_PROCEDIMIENTO_AUTO_PRORROGAS
    -- TEMP_PROCEDIMIENTO_COBROS
    -- TEMP_PROCEDIMIENTO_ESTIMACION
    -- TEMP_PROCEDIMIENTO_CARTERA
    -- TEMP_PROCEDIMIENTO_CEDENTE
    -- TEMP_PROCEDIMIENTO_PROPIETARIO
    -- TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO
    -- TEMP_PROCEDIMIENTO_TITULAR
    -- TEMP_PROCEDIMIENTO_DEMANDADO
    -- TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI
    -- TEMP_PROCEDIMIENTO_USUARIOS
    -- TEMP_PROCEDIMIENTO_RESOLUCIONES
    -- TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX
    -- TEMP_PROCEDIMIENTO_REFERENCIA
    -- TEMP_PROCEDIMIENTO_SEGMENTO 
    -- TEMP_PROCEDIMIENTO_SOCIO
    -- TEMP_FECHA_INTERPOSICION
    -- TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX
    -- TEMP_PROCURADOR
    
-- ÍNDICES DE HECHOS DE PROCEDIMIENTOS ESPECÍFICOS
    -- TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA
    -- TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE
    -- TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION
    -- TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO
    -- H_CONCURSO
    -- TEMP_CONCURSO_JERARQUIA
    -- TEMP_CONCURSO_DETALLE
    -- TEMP_CONCURSO_TAREA
    -- H_DECLARATIVO
    -- TEMP_DECLARATIVO_JERARQUIA
    -- TEMP_DECLARATIVO_DETALLE
    -- TEMP_DECLARATIVO_TAREA
    -- H_EJECUCION_ORDINARIA
    -- TEMP_EJECUCION_ORDINARIA_JERARQUIA
    -- TEMP_EJECUCION_ORDINARIA_DETALLE
    -- TEMP_EJECUCION_ORDINARIA_TAREA
    -- H_HIPOTECARIO
    -- TEMP_HIPOTECARIO_JERARQUIA
    -- TEMP_HIPOTECARIO_DETALLE
    -- TEMP_HIPOTECARIO_TAREA
    -- H_MONITORIO
    -- TEMP_MONITORIO_JERARQUIA
    -- TEMP_MONITORIO_DETALLE
    -- TEMP_MONITORIO_RESOLUCION
    -- H_ETJ
    -- TEMP_ETJ_JERARQUIA
    -- TEMP_ETJ_DETALLE
    -- TEMP_ETJ_RESOLUCION
    -- H_EJECUCION_NOTARIAL
    -- TEMP_EJECUCION_NOTARIAL_JERARQUIA
    -- TEMP_EJECUCION_NOTARIAL_DETALLE
    -- TEMP_EJECUCION_NOTARIAL_TAREA

-- ÍNDICES DE HECHOS DE TAREAS FINALIZADAS
    -- H_TAREA_FINALIZADA
    -- TEMP_TAREA_JERARQUIA


-- ----------------------------------------------------------------------------------------------
--
--                                    ÍNDICES DE HECHOS DE ACTUACIÓN RECOBRO
--
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_ACTUACION_RECOBRO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_ACTUACION_RECOBRO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_ACTUACION_RECOBRO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_ACTUACION_RECOBRO_IX ON H_ACTUACION_RECOBRO (DIA_ACTUACION_RECOBRO, ACTUACION_RECOBRO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_ACTUACION_RECOBRO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_ACTUACION_RECOBRO_IX. Nº [', HAY, ']');
end if;


-- ----------------------------------------------------------------------------------------------
--
--                                    ÍNDICES DE HECHOS DE CONTRATO
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                                    H_CONTRATO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_IX ON H_CONTRATO (DIA_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_CNT_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_CNT_IX ON H_CONTRATO (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_CNT_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_CNT_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONTRATO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONTRATO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_MES_IX ON H_CONTRATO_MES (MES_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONTRATO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONTRATO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_TRIMESTRE_IX ON H_CONTRATO_TRIMESTRE (TRIMESTRE_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONTRATO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics Where table_name = 'H_CONTRATO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_ANIO_IX ON H_CONTRATO_ANIO (ANIO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_CONTRATO_INICIO_CAMPANA_RECOBRO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables  where table_name = 'H_CONTRATO_INICIO_CAMPANA_RECOBRO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONTRATO_INICIO_CAMPANA_RECOBRO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_INICIO_CAMPANA_RECOBRO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_INICIO_CAMPANA_RECOBRO_IX ON H_CONTRATO_INICIO_CAMPANA_RECOBRO (FECHA_INICIO_CAMPANA_RECOBRO, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_INICIO_CAMPANA_RECOBRO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_INICIO_CAMPANA_RECOBRO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONTRATO_INICIO_CAMPANA_RECOBRO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONTRATO_INICIO_CAMPANA_RECOBRO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_INICIO_CAMPANA_RECOBRO_CNT_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
     CREATE INDEX H_CONTRATO_INICIO_CAMPANA_RECOBRO_CNT_IX ON H_CONTRATO_INICIO_CAMPANA_RECOBRO (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_INICIO_CAMPANA_RECOBRO_CNT_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_INICIO_CAMPANA_RECOBRO_CNT_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_FECHA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_DIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_DIA_IX ON TEMP_FECHA (DIA_H, DIA_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_DIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_DIA_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_MES_IX ON TEMP_FECHA (MES_H, MES_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_TRIMESTRE_IX ON TEMP_FECHA (TRIMESTRE_H, TRIMESTRE_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_FECHA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_ANIO_IX ON TEMP_FECHA (ANIO_H, ANIO_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_H
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_H_DIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_H_DIA_IX ON TEMP_H (DIA_H, CONTRATO_H);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_H_DIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_H_DIA_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_H_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_H_MES_IX ON TEMP_H (MES_H, CONTRATO_H);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_H_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_H_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_H_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_H_TRIMESTRE_IX ON TEMP_H (TRIMESTRE_H, CONTRATO_H);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_H_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_H_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_H' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_H_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_H_ANIO_IX ON TEMP_H (ANIO_H, CONTRATO_H);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_H_ANIO_IX. Nº [', HAY, ']');
else 
	set o_error_status:= concat('Ya existe el INDICE TEMP_H_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_ANT
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ANT_DIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ANT_DIA_IX ON TEMP_ANT (DIA_ANT, CONTRATO_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ANT_DIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ANT_DIA_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ANT_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ANT_MES_IX ON TEMP_ANT (MES_ANT, CONTRATO_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ANT_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ANT_MES_IX. Nº [', HAY, ']');
end if;
 
 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ANT_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ANT_TRIMESTRE_IX ON TEMP_ANT (TRIMESTRE_ANT, CONTRATO_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ANT_TRIMESTRE_IX. Nº [', HAY, ']');
else 
	set o_error_status:= concat('Ya existe el INDICE TEMP_ANT_TRIMESTRE_IX. Nº [', HAY, ']');
end if;
 
 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ANT' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ANT_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ANT_ANIO_IX ON TEMP_ANT (ANIO_ANT, CONTRATO_ANT);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ANT_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ANT_ANIO_IX. Nº [', HAY, ']');
end if;
 
-- ----------------------------------------------------------------------------------------------
--                                    TEMP_MANTIENE
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MANTIENE_DIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MANTIENE_DIA_IX ON TEMP_MANTIENE (DIA_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MANTIENE_DIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MANTIENE_DIA_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MANTIENE_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MANTIENE_MES_IX ON TEMP_MANTIENE (MES_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MANTIENE_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MANTIENE_MES_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MANTIENE_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MANTIENE_TRIMESTRE_IX ON TEMP_MANTIENE (TRIMESTRE_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MANTIENE_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MANTIENE_TRIMESTRE_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MANTIENE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MANTIENE_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MANTIENE_ANIO_IX ON TEMP_MANTIENE (ANIO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MANTIENE_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MANTIENE_ANIO_IX. Nº [', HAY, ']');
end if; 

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_ALTA
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ALTA_DIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ALTA_DIA_IX ON TEMP_ALTA (DIA_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ALTA_DIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ALTA_DIA_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ALTA_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ALTA_MES_IX ON TEMP_ALTA (MES_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ALTA_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ALTA_MES_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ALTA_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ALTA_TRIMESTRE_IX ON TEMP_ALTA (TRIMESTRE_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ALTA_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ALTA_TRIMESTRE_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ALTA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ALTA_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ALTA_ANIO_IX ON TEMP_ALTA (ANIO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ALTA_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ALTA_ANIO_IX. Nº [', HAY, ']');
end if; 

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_BAJA
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_BAJA_DIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_BAJA_DIA_IX ON TEMP_BAJA (DIA_MOV, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_BAJA_DIA_IX. Nº [', HAY, ']');
else 
	set o_error_status:= concat('Ya existe el INDICE TEMP_BAJA_DIA_IX. Nº [', HAY, ']');
end if; 
 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_BAJA_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_BAJA_MES_IX ON TEMP_BAJA (MES_MOV, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_BAJA_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_BAJA_MES_IX. Nº [', HAY, ']');
end if;  

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_BAJA_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_BAJA_TRIMESTRE_IX ON TEMP_BAJA (TRIMESTRE_MOV, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_BAJA_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_BAJA_TRIMESTRE_IX. Nº [', HAY, ']');
end if;  

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_BAJA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_BAJA_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_BAJA_ANIO_IX ON TEMP_BAJA (ANIO_MOV, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_BAJA_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_BAJA_ANIO_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_PROCEDIMIENTO
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_PROCEDIMIENTO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_PROCEDIMIENTO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_PROCEDIMIENTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_PROCEDIMIENTO_IX ON TEMP_CONTRATO_PROCEDIMIENTO (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_PROCEDIMIENTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_PROCEDIMIENTO_IX. Nº [', HAY, ']');
end if;   

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_PROCEDIMIENTO_AUX
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_PROCEDIMIENTO_AUX' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_PROCEDIMIENTO_AUX' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_PROCEDIMIENTO_AUX_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_PROCEDIMIENTO_AUX_IX ON TEMP_CONTRATO_PROCEDIMIENTO_AUX (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_PROCEDIMIENTO_AUX_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_PROCEDIMIENTO_AUX_IX. Nº [', HAY, ']');
end if;   

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_SITUACION_FINANCIERA
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_SITUACION_FINANCIERA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_SITUACION_FINANCIERA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONTRATO_SITUACION_FINANCIERA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONTRATO_SITUACION_FINANCIERA_IX ON TEMP_CONTRATO_SITUACION_FINANCIERA (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONTRATO_SITUACION_FINANCIERA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONTRATO_SITUACION_FINANCIERA_IX. Nº [', HAY, ']');
end if;   

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_CREDITO_INSINUADO
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_CREDITO_INSINUADO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_CREDITO_INSINUADO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_CREDITO_INSINUADO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_CREDITO_INSINUADO_IX ON TEMP_CONTRATO_CREDITO_INSINUADO (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_CREDITO_INSINUADO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_CREDITO_INSINUADO_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_RECOBRO
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_RECOBRO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_RECOBRO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_RECOBRO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_RECOBRO_IX ON TEMP_CONTRATO_RECOBRO (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_RECOBRO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_RECOBRO_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_DPS
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_DPS' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_DPS' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_DPS_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_DPS_IX ON TEMP_CONTRATO_DPS (ID_CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_DPS. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_DPS. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_ACTIVIDAD
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_ACTIVIDAD' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_ACTIVIDAD' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_ACTIVIDAD_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_ACTIVIDAD_IX ON TEMP_CONTRATO_ACTIVIDAD (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_ACTIVIDAD_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_ACTIVIDAD_IX. Nº [', HAY, ']');
end if;  

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_ACTIVIDAD' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_ACTIVIDAD' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_ACTIVIDAD_FECHA_ACTUACION_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_ACTIVIDAD_FECHA_ACTUACION_IX ON TEMP_CONTRATO_ACTIVIDAD (FECHA_ACTUACION, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_ACTIVIDAD_FECHA_ACTUACION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_ACTIVIDAD_FECHA_ACTUACION_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_ESPECIALIZADA
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_ESPECIALIZADA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_ESPECIALIZADA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_ESPECIALIZADA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_ESPECIALIZADA_IX ON TEMP_CONTRATO_ESPECIALIZADA (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_ESPECIALIZADA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_ESPECIALIZADA_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_PREVISIONES
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_PREVISIONES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_PREVISIONES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_PREVISIONES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_PREVISIONES_IX ON TEMP_CONTRATO_PREVISIONES (FECHA_PREVISION, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_PREVISIONES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_PREVISIONES_IX. Nº [', HAY, ']');
end if;  

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_PREVISIONES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_PREVISIONES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_PREVISIONES_CNT_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_PREVISIONES_CNT_IX ON TEMP_CONTRATO_PREVISIONES (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_PREVISIONES_CNT_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_PREVISIONES_CNT_IX. Nº [', HAY, ']');
end if;   

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATO_PREVISIONES_DIA
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATO_PREVISIONES_DIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATO_PREVISIONES_DIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATO_PREVISIONES_DIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATO_PREVISIONES_DIA_IX ON TEMP_CONTRATO_PREVISIONES_DIA (FECHA_PREVISION, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATO_PREVISIONES_DIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATO_PREVISIONES_DIA_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_IX ON TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_IX. Nº [', HAY, ']');
end if;   

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX_IX ON TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_LOAN_INFORMATION
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_LOAN_INFORMATION_CCC_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_LOAN_INFORMATION_CCC_IX ON TEMP_LOAN_INFORMATION (CCC);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_LOAN_INFORMATION_CCC_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_LOAN_INFORMATION_CCC_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_LOAN_INFORMATION_CCC_RIESGO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_LOAN_INFORMATION_CCC_RIESGO_IX ON TEMP_LOAN_INFORMATION (CCC_RIESGO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_LOAN_INFORMATION_CCC_RIESGO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_LOAN_INFORMATION_CCC_RIESGO_IX. Nº [', HAY, ']');
end if; 
 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_LOAN_INFORMATION_NUC_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_LOAN_INFORMATION_NUC_IX ON TEMP_LOAN_INFORMATION (NUC);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_LOAN_INFORMATION_NUC_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_LOAN_INFORMATION_NUC_IX. Nº [', HAY, ']');
end if; 
 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_LOAN_INFORMATION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_LOAN_INFORMATION_NUC_RIESGO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_LOAN_INFORMATION_NUC_RIESGO_IX ON TEMP_LOAN_INFORMATION (NUC_RIESGO); 
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_LOAN_INFORMATION_NUC_RIESGO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_LOAN_INFORMATION_NUC_RIESGO_IX. Nº [', HAY, ']');
end if; 

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_ESTUDIO_CARTERA
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ESTUDIO_CARTERA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ESTUDIO_CARTERA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ESTUDIO_CARTERA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ESTUDIO_CARTERA_IX ON TEMP_ESTUDIO_CARTERA (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ESTUDIO_CARTERA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ESTUDIO_CARTERA_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ESTUDIO_CARTERA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ESTUDIO_CARTERA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ESTUDIO_CARTERA_NUC_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ESTUDIO_CARTERA_NUC_IX ON TEMP_ESTUDIO_CARTERA (NUC);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ESTUDIO_CARTERA_NUC_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ESTUDIO_CARTERA_NUC_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ESTUDIO_CARTERA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ESTUDIO_CARTERA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ESTUDIO_CARTERA_NUC_RIESGO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ESTUDIO_CARTERA_NUC_RIESGO_IX ON TEMP_ESTUDIO_CARTERA (NUC_RIESGO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ESTUDIO_CARTERA_NUC_RIESGO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ESTUDIO_CARTERA_NUC_RIESGO_IX. Nº [', HAY, ']');
end if; 

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_EN_MASIVA
-- ---------------------------------------------------------------------------------------------- 
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EN_MASIVA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EN_MASIVA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EN_MASIVA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EN_MASIVA_IX ON TEMP_EN_MASIVA (CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EN_MASIVA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EN_MASIVA_IX. Nº [', HAY, ']');
end if; 


-- ----------------------------------------------------------------------------------------------
--
--                                    ÍNDICES DE HECHOS DE PROCEDIMIENTOS
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                                    H_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PROCEDIMIENTO'  and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_IX ON H_PROCEDIMIENTO (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO'   and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_FASE_ACTUAL_IX ON H_PROCEDIMIENTO (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO'   and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_ASUNTO_IX ON H_PROCEDIMIENTO (DIA_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_ASUNTO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PROCEDIMIENTO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_MES_IX ON H_PROCEDIMIENTO_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_MES_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_PROCEDIMIENTO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_MES_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_MES_ASUNTO_IX ON H_PROCEDIMIENTO_MES (MES_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_MES_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_MES_ASUNTO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_TRIMESTRE_IX ON H_PROCEDIMIENTO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_TRIMESTRE_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_TRIMESTRE_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_TRIMESTRE_ASUNTO_IX ON H_PROCEDIMIENTO_TRIMESTRE (TRIMESTRE_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_ANIO_IX ON H_PROCEDIMIENTO_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_ANIO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_ANIO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_ANIO_ASUNTO_IX ON H_PROCEDIMIENTO_ANIO (ANIO_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_ANIO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_ANIO_ASUNTO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_PROCEDIMIENTO_DETALLE_COBRO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_IX ON H_PROCEDIMIENTO_DETALLE_COBRO (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_COBRO (DIA_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_ASUNTO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_MES_IX ON H_PROCEDIMIENTO_DETALLE_COBRO_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_MES_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_MES_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_MES_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_COBRO_MES (MES_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_MES_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_MES_ASUNTO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_IX ON H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE (TRIMESTRE_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_IX ON H_PROCEDIMIENTO_DETALLE_COBRO_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_COBRO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_COBRO_ANIO (ANIO_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_COBRO_ANIO_ASUNTO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_PROCEDIMIENTO_DETALLE_CONTRATO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO (DIA_ID, PROCEDIMIENTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO (DIA_ID, ASUNTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_ASUNTO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO_MES (MES_ID, PROCEDIMIENTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO_MES (MES_ID, ASUNTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_MES_ASUNTO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE (TRIMESTRE_ID, ASUNTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO (ANIO_ID, PROCEDIMIENTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO (ANIO_ID, ASUNTO_ID, CONTRATO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO_ASUNTO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_PROCEDIMIENTO_DETALLE_RESOLUCION
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION (DIA_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_ASUNTO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES (MES_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES_ASUNTO_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE (TRIMESTRE_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE_ASUNTO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_ASUNTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_ASUNTO_IX ON H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO (ANIO_ID, ASUNTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_ASUNTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO_ASUNTO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_JERARQUIA_ITER_IX ON TEMP_PROCEDIMIENTO_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_JERARQUIA_FASE_ACTUAL_IX ON TEMP_PROCEDIMIENTO_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_JERARQUIA_ULTIMA_FASE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_JERARQUIA_ULTIMA_FASE_IX ON TEMP_PROCEDIMIENTO_JERARQUIA (DIA_ID, ULTIMA_FASE);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_JERARQUIA_ULTIMA_FASE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_JERARQUIA_ULTIMA_FASE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_DETALLE_IX ON TEMP_PROCEDIMIENTO_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_TAREA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_TAREA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_TAREA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_TAREA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_TAREA_IX ON TEMP_PROCEDIMIENTO_TAREA (ITER, TAREA);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_TAREA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_TAREA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_CONTRATO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_CONTRATO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_CONTRATO_IX ON TEMP_PROCEDIMIENTO_CONTRATO (ITER, CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_CONTRATO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_CONTRATO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_CONTRATO_CEX_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_CONTRATO_CEX_IX ON TEMP_PROCEDIMIENTO_CONTRATO (CEX_ID, CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_CONTRATO_CEX_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_CONTRATO_CEX_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO_IX ON TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO (ITER, CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_CONCURSO_CONTRATO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_AUTO_PRORROGAS
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_AUTO_PRORROGAS' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_AUTO_PRORROGAS' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_AUTO_PRORROGAS_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_AUTO_PRORROGAS_IX ON TEMP_PROCEDIMIENTO_AUTO_PRORROGAS (TAREA);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_AUTO_PRORROGAS_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_AUTO_PRORROGAS_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_COBROS
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_COBROS' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_COBROS' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_COBROS_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_COBROS_IX ON TEMP_PROCEDIMIENTO_COBROS (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_COBROS_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_COBROS_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_ESTIMACION
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_ESTIMACION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_ESTIMACION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_ESTIMACION_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_ESTIMACION_IX ON TEMP_PROCEDIMIENTO_ESTIMACION (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_ESTIMACION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_ESTIMACION_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_CARTERA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_CARTERA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_CARTERA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_CARTERA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_CARTERA_IX ON TEMP_PROCEDIMIENTO_CARTERA (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_CARTERA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_CARTERA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_CEDENTE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_CEDENTE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_CEDENTE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_CEDENTE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_CEDENTE_IX ON TEMP_PROCEDIMIENTO_CEDENTE (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_CEDENTE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_CEDENTE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_PROPIETARIO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_PROPIETARIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TEMP_PROCEDIMIENTO_PROPIETARIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_PROPIETARIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_PROPIETARIO_IX ON TEMP_PROCEDIMIENTO_PROPIETARIO (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_PROPIETARIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_PROPIETARIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO_IX ON TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_TITULAR
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_TITULAR' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_TITULAR' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_TITULAR_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_TITULAR_IX ON TEMP_PROCEDIMIENTO_TITULAR (PROCEDIMIENTO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_TITULAR_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_TITULAR_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_DEMANDADO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_DEMANDADO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_DEMANDADO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_DEMANDADO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_DEMandADO_IX ON TEMP_PROCEDIMIENTO_DEMANDADO (PROCEDIMIENTO, CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_DEMANDADO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_DEMANDADO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI_IX ON TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI (FECHA_VALOR, UNIDAD_GESTION);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_EXTRAS_RECOVERY_BI_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_USUARIOS
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_USUARIOS' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_USUARIOS' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_USUARIOS_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_USUARIOS_IX ON TEMP_PROCEDIMIENTO_USUARIOS (PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_USUARIOS_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_USUARIOS_IX. Nº [', HAY, ']');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_RESOLUCIONES
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_RESOLUCIONES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_RESOLUCIONES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_RESOLUCIONES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_RESOLUCIONES_IX ON TEMP_PROCEDIMIENTO_RESOLUCIONES (PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_RESOLUCIONES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_RESOLUCIONES_BPM_IPT_ID_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_RESOLUCIONES_BPM_IPT_ID_IX ON TEMP_PROCEDIMIENTO_RESOLUCIONES (BPM_IPT_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_BPM_IPT_ID_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_BPM_IPT_ID_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_RESOLUCIONES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_RESOLUCIONES_USUARIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_RESOLUCIONES_USUARIO_IX ON TEMP_PROCEDIMIENTO_RESOLUCIONES (USUARIO_CREAR);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_USUARIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_USUARIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX_IX ON TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX (PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_REFERENCIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_REFERENCIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TEMP_PROCEDIMIENTO_REFERENCIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_REFERENCIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_REFERENCIA_IX ON TEMP_PROCEDIMIENTO_REFERENCIA (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_REFERENCIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_REFERENCIA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_SEGMENTO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_SEGMENTO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TEMP_PROCEDIMIENTO_SEGMENTO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_SEGMENTO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_SEGMENTO_IX ON TEMP_PROCEDIMIENTO_SEGMENTO (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_SEGMENTO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_SEGMENTO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_SOCIO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_SOCIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'TEMP_PROCEDIMIENTO_SOCIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_SOCIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_SOCIO_IX ON TEMP_PROCEDIMIENTO_SOCIO (CONTRATO);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_SOCIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_SOCIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--
--                         ÍNDICES DE HECHOS DE PROCEDIMIENTOS ESPECÍFICOS
--
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables  where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_ITER_IX ON TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_FASE_ACTUAL_IX ON TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE_IX ON TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION_IX ON TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION (FASE_ACTUAL); 
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO_IX ON TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO (FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO_IX. Nº [', HAY, ']');
end if;  

-- ----------------------------------------------------------------------------------------------
--                                    H_CONCURSO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONCURSO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONCURSO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONCURSO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONCURSO_IX ON H_CONCURSO (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONCURSO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONCURSO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONCURSO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONCURSO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONCURSO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONCURSO_MES_IX ON H_CONCURSO_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONCURSO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONCURSO_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONCURSO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONCURSO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONCURSO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONCURSO_TRIMESTRE_IX ON H_CONCURSO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONCURSO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONCURSO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_CONCURSO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_CONCURSO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_CONCURSO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_CONCURSO_ANIO_IX ON H_CONCURSO_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_CONCURSO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_CONCURSO_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONCURSO_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONCURSO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONCURSO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONCURSO_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONCURSO_JERARQUIA_ITER_IX ON TEMP_CONCURSO_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONCURSO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONCURSO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if; 

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONCURSO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONCURSO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONCURSO_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONCURSO_JERARQUIA_FASE_ACTUAL_IX ON TEMP_CONCURSO_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONCURSO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONCURSO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONCURSO_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONCURSO_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONCURSO_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONCURSO_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONCURSO_DETALLE_IX ON TEMP_CONCURSO_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONCURSO_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONCURSO_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_CONCURSO_TAREA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_CONCURSO_TAREA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_CONCURSO_TAREA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_CONCURSO_TAREA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_CONCURSO_TAREA_IX ON TEMP_CONCURSO_TAREA (ITER, TAREA);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_CONCURSO_TAREA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_CONCURSO_TAREA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_DECLARATIVO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_DECLARATIVO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_DECLARATIVO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_DECLARATIVO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_DECLARATIVO_IX ON H_DECLARATIVO (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_DECLARATIVO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_DECLARATIVO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_DECLARATIVO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_DECLARATIVO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_DECLARATIVO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_DECLARATIVO_MES_IX ON H_DECLARATIVO_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_DECLARATIVO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_DECLARATIVO_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_DECLARATIVO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_DECLARATIVO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_DECLARATIVO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_DECLARATIVO_TRIMESTRE_IX ON H_DECLARATIVO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_DECLARATIVO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_DECLARATIVO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_DECLARATIVO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_DECLARATIVO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_DECLARATIVO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_DECLARATIVO_ANIO_IX ON H_DECLARATIVO_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_DECLARATIVO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_DECLARATIVO_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_DECLARATIVO_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_DECLARATIVO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_DECLARATIVO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_DECLARATIVO_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_DECLARATIVO_JERARQUIA_ITER_IX ON TEMP_DECLARATIVO_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_DECLARATIVO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_DECLARATIVO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_DECLARATIVO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_DECLARATIVO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_DECLARATIVO_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_DECLARATIVO_JERARQUIA_FASE_ACTUAL_IX ON TEMP_DECLARATIVO_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_DECLARATIVO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_DECLARATIVO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_DECLARATIVO_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_DECLARATIVO_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_DECLARATIVO_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_DECLARATIVO_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_DECLARATIVO_DETALLE_IX ON TEMP_DECLARATIVO_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_DECLARATIVO_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_DECLARATIVO_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_DECLARATIVO_TAREA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_DECLARATIVO_TAREA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_DECLARATIVO_TAREA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_DECLARATIVO_TAREA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_DECLARATIVO_TAREA_IX ON TEMP_DECLARATIVO_TAREA (ITER, TAREA);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_DECLARATIVO_TAREA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_DECLARATIVO_TAREA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_EJECUCION_ORDINARIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_ORDINARIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EJECUCION_ORDINARIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_ORDINARIA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_ORDINARIA_IX ON H_EJECUCION_ORDINARIA (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_ORDINARIA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_ORDINARIA_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_ORDINARIA_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EJECUCION_ORDINARIA_MES'
     and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_ORDINARIA_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_ORDINARIA_MES_IX ON H_EJECUCION_ORDINARIA_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_ORDINARIA_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_ORDINARIA_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_ORDINARIA_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EJECUCION_ORDINARIA_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_ORDINARIA_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_ORDINARIA_TRIMESTRE_IX ON H_EJECUCION_ORDINARIA_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_ORDINARIA_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_ORDINARIA_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_ORDINARIA_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EJECUCION_ORDINARIA_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_ORDINARIA_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_ORDINARIA_ANIO_IX ON H_EJECUCION_ORDINARIA_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_ORDINARIA_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_ORDINARIA_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_EJECUCION_ORDINARIA_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_ORDINARIA_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_ORDINARIA_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_ORDINARIA_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_ORDINARIA_JERARQUIA_ITER_IX ON TEMP_EJECUCION_ORDINARIA_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_ORDINARIA_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_ORDINARIA_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_ORDINARIA_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_ORDINARIA_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_ORDINARIA_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_ORDINARIA_JERARQUIA_FASE_ACTUAL_IX ON TEMP_EJECUCION_ORDINARIA_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_ORDINARIA_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_ORDINARIA_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_EJECUCION_ORDINARIA_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_ORDINARIA_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_ORDINARIA_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_ORDINARIA_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_ORDINARIA_DETALLE_IX ON TEMP_EJECUCION_ORDINARIA_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_ORDINARIA_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_ORDINARIA_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_EJECUCION_ORDINARIA_TAREA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_ORDINARIA_TAREA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_ORDINARIA_TAREA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_ORDINARIA_TAREA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_ORDINARIA_TAREA_IX ON TEMP_EJECUCION_ORDINARIA_TAREA (ITER, TAREA);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_ORDINARIA_TAREA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_ORDINARIA_TAREA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_HIPOTECARIO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_HIPOTECARIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_HIPOTECARIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_HIPOTECARIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_HIPOTECARIO_IX ON H_HIPOTECARIO (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_HIPOTECARIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_HIPOTECARIO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_HIPOTECARIO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_HIPOTECARIO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_HIPOTECARIO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_HIPOTECARIO_MES_IX ON H_HIPOTECARIO_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_HIPOTECARIO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_HIPOTECARIO_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_HIPOTECARIO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_HIPOTECARIO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_HIPOTECARIO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_HIPOTECARIO_TRIMESTRE_IX ON H_HIPOTECARIO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_HIPOTECARIO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_HIPOTECARIO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_HIPOTECARIO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_HIPOTECARIO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_HIPOTECARIO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_HIPOTECARIO_TRIMESTRE_IX ON H_HIPOTECARIO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_HIPOTECARIO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_HIPOTECARIO_ANIO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_HIPOTECARIO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_HIPOTECARIO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_HIPOTECARIO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_HIPOTECARIO_ANIO_IX ON H_HIPOTECARIO_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_HIPOTECARIO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_HIPOTECARIO_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_HIPOTECARIO_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_HIPOTECARIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_HIPOTECARIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_HIPOTECARIO_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_HIPOTECARIO_JERARQUIA_ITER_IX ON TEMP_HIPOTECARIO_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_HIPOTECARIO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_HIPOTECARIO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_HIPOTECARIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_HIPOTECARIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_HIPOTECARIO_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_HIPOTECARIO_JERARQUIA_FASE_ACTUAL_IX ON TEMP_HIPOTECARIO_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_HIPOTECARIO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_HIPOTECARIO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_HIPOTECARIO_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_HIPOTECARIO_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_HIPOTECARIO_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_HIPOTECARIO_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_HIPOTECARIO_DETALLE_IX ON TEMP_HIPOTECARIO_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_HIPOTECARIO_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_HIPOTECARIO_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_HIPOTECARIO_TAREA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_HIPOTECARIO_TAREA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_HIPOTECARIO_TAREA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_HIPOTECARIO_TAREA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_HIPOTECARIO_TAREA_IX ON TEMP_HIPOTECARIO_TAREA (ITER, TAREA);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_HIPOTECARIO_TAREA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_HIPOTECARIO_TAREA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_MONITORIO
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_MONITORIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_MONITORIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_MONITORIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_MONITORIO_IX ON H_MONITORIO (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_MONITORIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_MONITORIO_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_MONITORIO_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_MONITORIO_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_MONITORIO_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_MONITORIO_MES_IX ON H_MONITORIO_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_MONITORIO_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_MONITORIO_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_MONITORIO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_MONITORIO_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_MONITORIO_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_MONITORIO_TRIMESTRE_IX ON H_MONITORIO_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_MONITORIO_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_MONITORIO_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_MONITORIO_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_MONITORIO_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_MONITORIO_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_MONITORIO_ANIO_IX ON H_MONITORIO_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_MONITORIO_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_MONITORIO_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_MONITORIO_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MONITORIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MONITORIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MONITORIO_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MONITORIO_JERARQUIA_ITER_IX ON TEMP_MONITORIO_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MONITORIO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MONITORIO_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MONITORIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MONITORIO_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MONITORIO_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MONITORIO_JERARQUIA_FASE_ACTUAL_IX ON TEMP_MONITORIO_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MONITORIO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MONITORIO_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_MONITORIO_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MONITORIO_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MONITORIO_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MONITORIO_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MONITORIO_DETALLE_IX ON TEMP_MONITORIO_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MONITORIO_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MONITORIO_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_MONITORIO_RESOLUCION
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_MONITORIO_RESOLUCION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_MONITORIO_RESOLUCION'and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_MONITORIO_RESOLUCION_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_MONITORIO_RESOLUCION_IX ON TEMP_MONITORIO_RESOLUCION (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_MONITORIO_RESOLUCION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_MONITORIO_RESOLUCION_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_ETJ
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_ETJ' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_ETJ' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_ETJ_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_ETJ_IX ON H_ETJ (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_ETJ_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_ETJ_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_ETJ_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_ETJ_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_ETJ_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_ETJ_MES_IX ON H_ETJ_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_ETJ_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_ETJ_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_ETJ_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_ETJ_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_ETJ_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_ETJ_TRIMESTRE_IX ON H_ETJ_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_ETJ_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_ETJ_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_ETJ_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_ETJ_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_ETJ_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_ETJ_ANIO_IX ON H_ETJ_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_ETJ_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_ETJ_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_ETJ_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ETJ_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ETJ_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ETJ_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ETJ_JERARQUIA_ITER_IX ON TEMP_ETJ_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ETJ_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ETJ_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ETJ_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ETJ_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ETJ_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ETJ_JERARQUIA_FASE_ACTUAL_IX ON TEMP_ETJ_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ETJ_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ETJ_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_ETJ_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ETJ_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ETJ_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ETJ_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ETJ_DETALLE_IX ON TEMP_ETJ_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ETJ_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ETJ_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_ETJ_RESOLUCION
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_ETJ_RESOLUCION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_ETJ_RESOLUCION'and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_ETJ_RESOLUCION_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_ETJ_RESOLUCION_IX ON TEMP_ETJ_RESOLUCION (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_ETJ_RESOLUCION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_ETJ_RESOLUCION_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    H_EJECUCION_NOTARIAL
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_NOTARIAL' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EJECUCION_NOTARIAL' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_NOTARIAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_NOTARIAL_IX ON H_EJECUCION_NOTARIAL (DIA_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_NOTARIAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_NOTARIAL_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_NOTARIAL_MES' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EJECUCION_NOTARIAL_MES' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_NOTARIAL_MES_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_NOTARIAL_MES_IX ON H_EJECUCION_NOTARIAL_MES (MES_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_NOTARIAL_MES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_NOTARIAL_MES_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_NOTARIAL_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_EJECUCION_NOTARIAL_TRIMESTRE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_NOTARIAL_TRIMESTRE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_NOTARIAL_TRIMESTRE_IX ON H_EJECUCION_NOTARIAL_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_NOTARIAL_TRIMESTRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_NOTARIAL_TRIMESTRE_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_EJECUCION_NOTARIAL_ANIO' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'H_EJECUCION_NOTARIAL_ANIO' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_EJECUCION_NOTARIAL_ANIO_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_EJECUCION_NOTARIAL_ANIO_IX ON H_EJECUCION_NOTARIAL_ANIO (ANIO_ID, PROCEDIMIENTO_ID);
    set o_error_status:= concat('Se ha insertado el INDICE H_EJECUCION_NOTARIAL_ANIO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE H_EJECUCION_NOTARIAL_ANIO_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_EJECUCION_NOTARIAL_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_NOTARIAL_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_NOTARIAL_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_NOTARIAL_JERARQUIA_ITER_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_NOTARIAL_JERARQUIA_ITER_IX ON TEMP_EJECUCION_NOTARIAL_JERARQUIA (DIA_ID, ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_NOTARIAL_JERARQUIA_ITER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_NOTARIAL_JERARQUIA_ITER_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_NOTARIAL_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_NOTARIAL_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_NOTARIAL_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_NOTARIAL_JERARQUIA_FASE_ACTUAL_IX ON TEMP_EJECUCION_NOTARIAL_JERARQUIA (DIA_ID, FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_NOTARIAL_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_NOTARIAL_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_EJECUCION_NOTARIAL_DETALLE
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_NOTARIAL_DETALLE' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_NOTARIAL_DETALLE' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_NOTARIAL_DETALLE_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_NOTARIAL_DETALLE_IX ON TEMP_EJECUCION_NOTARIAL_DETALLE (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_NOTARIAL_DETALLE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_NOTARIAL_DETALLE_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_EJECUCION_NOTARIAL_TAREA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_EJECUCION_NOTARIAL_TAREA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_EJECUCION_NOTARIAL_TAREA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_EJECUCION_NOTARIAL_TAREA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_EJECUCION_NOTARIAL_TAREA_IX ON TEMP_EJECUCION_NOTARIAL_TAREA (ITER, TAREA);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_EJECUCION_NOTARIAL_TAREA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_EJECUCION_NOTARIAL_TAREA_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--
--                                    ÍNDICES DE HECHOS DE TAREAS FINALIZADAS
--
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
--                                    H_TAREA_FINALIZADA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_TAREA_FINALIZADA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_TAREA_FINALIZADA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_TAREA_FINALIZADA_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_TAREA_FINALIZADA_IX ON H_TAREA_FINALIZADA (DIA_FINALIZACION_TAREA_ID, TAREA_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAREA_FINALIZADA_IX. Nº [', HAY, ']');
else 
	set o_error_status:= concat('Ya existe el INDICE H_TAREA_FINALIZADA_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_TAREA_FINALIZADA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_TAREA_FINALIZADA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'H_TAREA_FINALIZADA_PRC_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX H_TAREA_FINALIZADA_PRC_IX ON H_TAREA_FINALIZADA (DIA_FINALIZACION_TAREA_ID, PROCEDIMIENTO_ID);
	set o_error_status:= concat('Se ha insertado el INDICE H_TAREA_FINALIZADA_PRC_IX. Nº [', HAY, ']');
else 
	set o_error_status:= concat('Ya existe el INDICE H_TAREA_FINALIZADA_PRC_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_TAREA_JERARQUIA
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_TAREA_JERARQUIA' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_TAREA_JERARQUIA' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_TAREA_JERARQUIA_FASE_ACTUAL_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
	CREATE INDEX TEMP_TAREA_JERARQUIA_FASE_ACTUAL_IX ON TEMP_TAREA_JERARQUIA (DIA_ID, FASE_ACTUAL);
	set o_error_status:= concat('Se ha insertado el INDICE TEMP_TAREA_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
else 
	set o_error_status:= concat('Ya existe el INDICE TEMP_TAREA_JERARQUIA_FASE_ACTUAL_IX. Nº [', HAY, ']');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    TEMP_FECHA_INTERPOSICION
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA_INTERPOSICION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_FECHA_INTERPOSICION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_INTERPOSICION_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_INTERPOSICION_IX ON TEMP_FECHA_INTERPOSICION (FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_INTERPOSICION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_INTERPOSICION_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA_INTERPOSICION' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_FECHA_INTERPOSICION' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_INTERPOSICION_ASU_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_INTERPOSICION_IX ON TEMP_FECHA_INTERPOSICION (FASE_ACTUAL);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_INTERPOSICION_ASU_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_INTERPOSICION_ASU_IX. Nº [', HAY, ']');
end if;

-- ----------------------------------------------------------------------------------------------
--                                    TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_INTERPOSICION_AUX_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_INTERPOSICION_AUX_IX ON TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX (ITER);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_INTERPOSICION_AUX_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_INTERPOSICION_AUX_IX. Nº [', HAY, ']');
end if;

select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX_ASU_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX_ASU_IX ON TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX (ASU_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX_ASU_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX_ASU_IX. Nº [', HAY, ']');
end if;


-- ----------------------------------------------------------------------------------------------
--                                    TEMP_PROCURADOR
-- ----------------------------------------------------------------------------------------------
select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEMP_PROCURADOR' and table_schema = 'recovery_lindorff_dwh';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEMP_PROCURADOR' and table_schema = 'recovery_lindorff_dwh' and INDEX_NAME = 'TEMP_PROCURADOR_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEMP_PROCURADOR_IX ON TEMP_PROCURADOR (PRC_ID);
    set o_error_status:= concat('Se ha insertado el INDICE TEMP_PROCURADOR_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE TEMP_PROCURADOR_IX. Nº [', HAY, ']');
end if;

END MY_BLOCK_IND
