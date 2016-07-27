-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Crear_Indices_Datastage_Recovery_BBVA` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Crear_Indices_Datastage_Recovery_BBVA`(OUT o_error_status varchar(500))
MY_BLOCK_IND: BEGIN

-- ===============================================================================================
-- Autor: Enrique Jiménez, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: Joaquin Arnal, PFS Group
-- Fecha última modificación: 18-11-2014
-- Motivos del cambio: Incluir indice PRC_PROCEDIMIENTOS_IX_2
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que crea índices en las tablas del datastage
-- ===============================================================================================

DECLARE HAY INT;
DECLARE HAY_TABLA INT;




DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: Número de parámetros incorrecto'; 




DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CPE_CONTRATOS_PERSONAS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics  where table_name = 'CPE_CONTRATOS_PERSONAS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CPE_CONTRATO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX CPE_CONTRATO_IX on bi_cdd_bbva_datastage.CPE_CONTRATOS_PERSONAS (CNT_ID, PER_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE CPE_CONTRATO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CPE_CONTRATO_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CPE_CONTRATOS_PERSONAS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CPE_CONTRATOS_PERSONAS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CPE_CONTRATO_PER_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX CPE_CONTRATO_PER_IX on bi_cdd_bbva_datastage.CPE_CONTRATOS_PERSONAS (PER_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE CPE_CONTRATO_PER_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CPE_CONTRATO_PER_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CEX_CONTRATOS_EXPEDIENTE' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CEX_CONTRATOS_EXPEDIENTE' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CEX_CONTRATOS_EXPEDIENTE_CNT_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX CEX_CONTRATOS_EXPEDIENTE_CNT_IX on bi_cdd_bbva_datastage.CEX_CONTRATOS_EXPEDIENTE (CNT_ID, CEX_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE CEX_CONTRATOS_EXPEDIENTE_CNT_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CEX_CONTRATOS_EXPEDIENTE_CNT_IX. Nº [', HAY, ']');
 end if;


 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CEX_CONTRATOS_EXPEDIENTE' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CEX_CONTRATOS_EXPEDIENTE' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CEX_CONTRATOS_EXPEDIENTE_EXP_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX CEX_CONTRATOS_EXPEDIENTE_EXP_IX on bi_cdd_bbva_datastage.CEX_CONTRATOS_EXPEDIENTE (EXP_ID, CEX_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE CEX_CONTRATOS_EXPEDIENTE_EXP_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CEX_CONTRATOS_EXPEDIENTE_EXP_IX. Nº [', HAY, ']');
 end if;




/* select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CRE_PRC_CEX' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CRE_PRC_CEX_CEX_IX';
if (HAY < 1) then 
    CREATE INDEX CRE_PRC_CEX_CEX_IX on bi_cdd_bbva_datastage.CRE_PRC_CEX (CRE_PRC_CEX_CEXID);
    set o_error_status:= concat('Se ha insertado el INDICE CRE_PRC_CEX_CEX_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE CRE_PRC_CEX_CEX_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CRE_PRC_CEX' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CRE_PRC_CEX_PRC_IX';
if (HAY < 1) then 
    CREATE INDEX CRE_PRC_CEX_PRC_IX on bi_cdd_bbva_datastage.CRE_PRC_CEX (CRE_PRC_CEX_PRCID);
    set o_error_status:= concat('Se ha insertado el INDICE CRE_PRC_CEX_PRC_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE CRE_PRC_CEX_PRC_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRC_PER' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRC_PER_IX';
if (HAY < 1) then 
    CREATE INDEX PRC_PER_IX on bi_cdd_bbva_datastage.PRC_PER (PRC_ID, PER_ID);
    set o_error_status:= concat('Se ha insertado el INDICE PRC_PER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE PRC_PER_IX. Nº [', HAY, ']');
end if;
*/

/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRC_PER' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRC_PER_PER_IX';
if (HAY < 1) then 
    CREATE INDEX PRC_PER_PER_IX on bi_cdd_bbva_datastage.PRC_PER (PER_ID);
    set o_error_status:= concat('Se ha insertado el INDICE PRC_PER_PER_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE PRC_PER_PER_IX. Nº [', HAY, ']');
end if;
*/


 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'MOV_MOVIMIENTOS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX MOV_MOVIMIENTOS_IX on bi_cdd_bbva_datastage.MOV_MOVIMIENTOS (MOV_FECHA_EXTRACCION, CNT_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE MOV_MOVIMIENTOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE MOV_MOVIMIENTOS_IX. Nº [', HAY, ']');
 end if;


 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'MOV_MOVIMIENTOS_MOV_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX MOV_MOVIMIENTOS_MOV_IX on bi_cdd_bbva_datastage.MOV_MOVIMIENTOS (CNT_ID, MOV_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE MOV_MOVIMIENTOS_MOV_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE MOV_MOVIMIENTOS_MOV_IX. Nº [', HAY, ']');
 end if;



select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'H_MOV_MOVIMIENTOS_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_MOV_MOVIMIENTOS_IX on bi_cdd_bbva_datastage.H_MOV_MOVIMIENTOS (MOV_FECHA_EXTRACCION, CNT_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE H_MOV_MOVIMIENTOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE H_MOV_MOVIMIENTOS_IX. Nº [', HAY, ']');
end if;


select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'H_MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'H_MOV_MOVIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'H_MOV_MOVIMIENTOS_MOV_IX';
if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX H_MOV_MOVIMIENTOS_MOV_IX on bi_cdd_bbva_datastage.H_MOV_MOVIMIENTOS (CNT_ID, MOV_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE H_MOV_MOVIMIENTOS_MOV_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE H_MOV_MOVIMIENTOS_MOV_IX. Nº [', HAY, ']');
end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PRC_PROCEDIMIENTOS_JERARQUIA' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRC_PROCEDIMIENTOS_JERARQUIA' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRC_PROCEDIMIENTOS_JERARQUIA_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX PRC_PROCEDIMIENTOS_JERARQUIA_IX on bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS_JERARQUIA (Fecha_Procedimiento, PRC_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE PRC_PROCEDIMIENTOS_JERARQUIA_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PRC_PROCEDIMIENTOS_JERARQUIA_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PER_PERSONAS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PER_PERSONAS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PER_PERSONAS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX PER_PERSONAS_IX on bi_cdd_bbva_datastage.PER_PERSONAS (PER_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE PER_PERSONAS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PER_PERSONAS_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CNT_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CNT_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CNT_CONTRATOS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX CNT_CONTRATOS_IX on bi_cdd_bbva_datastage.CNT_CONTRATOS (CNT_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE CNT_CONTRATOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CNT_CONTRATOS_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CNT_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CNT_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CNT_CONTRATOS_EXTRACION_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX CNT_CONTRATOS_EXTRACION_IX on bi_cdd_bbva_datastage.CNT_CONTRATOS (CNT_FECHA_EXTRACCION, CNT_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE CNT_CONTRATOS_EXTRACION_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CNT_CONTRATOS_EXTRACION_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PRC_CEX' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRC_CEX' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRC_CEX_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX PRC_CEX_IX on bi_cdd_bbva_datastage.PRC_CEX (CEX_ID, PRC_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE PRC_CEX_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PRC_CEX_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PRC_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRC_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRC_PROCEDIMIENTOS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX PRC_PROCEDIMIENTOS_IX on bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS (PRC_ID, ASU_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE PRC_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PRC_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
 end if;


/* Incluido el 2014-11-18 */
 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PRC_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRC_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRC_PROCEDIMIENTOS_IX_2';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX PRC_PROCEDIMIENTOS_IX_2 on bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS (ASU_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE PRC_PROCEDIMIENTOS_IX_2. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PRC_PROCEDIMIENTOS_IX_2. Nº [', HAY, ']');
 end if;


 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'DD_TPO_TIPO_PROCEDIMIENTO' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DD_TPO_TIPO_PROCEDIMIENTO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'DD_TPO_TIPO_PROCEDIMIENTO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX DD_TPO_TIPO_PROCEDIMIENTO_IX on bi_cdd_bbva_datastage.DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE DD_TPO_TIPO_PROCEDIMIENTO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE DD_TPO_TIPO_PROCEDIMIENTO_IX. Nº [', HAY, ']');
 end if; 



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'ASU_ASUNTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'ASU_ASUNTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'ASU_ASUNTOS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX ASU_ASUNTOS_IX on bi_cdd_bbva_datastage.ASU_ASUNTOS (ASU_ID, EXP_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE ASU_ASUNTOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE ASU_ASUNTOS_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TAR_TAREAS_NOTIFICACIONES' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TAR_TAREAS_NOTIFICACIONES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'TAR_TAREAS_NOTIFICACIONES_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TAR_TAREAS_NOTIFICACIONES_IX on bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES (TAR_ID, PRC_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE TAR_TAREAS_NOTIFICACIONES_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE TAR_TAREAS_NOTIFICACIONES_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TAR_TAREAS_NOTIFICACIONES' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TAR_TAREAS_NOTIFICACIONES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'TAR_TAREAS_NOTIFICACIONES_TIPO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TAR_TAREAS_NOTIFICACIONES_TIPO_IX on bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES (TAR_ID, DD_STA_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE TAR_TAREAS_NOTIFICACIONES_TIPO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE TAR_TAREAS_NOTIFICACIONES_TIPO_IX. Nº [', HAY, ']');
 end if;


 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TAR_TAREAS_NOTIFICACIONES' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TAR_TAREAS_NOTIFICACIONES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'TAR_PRC_ID_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TAR_PRC_ID_IX on bi_cdd_bbva_datastage.TAR_TAREAS_NOTIFICACIONES (PRC_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE TAR_PRC_ID_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE TAR_PRC_ID_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEX_TAREA_EXTERNA' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEX_TAREA_EXTERNA' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'TEX_TAREA_EXTERNAS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEX_TAREA_EXTERNAS_IX on bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA (TAR_ID, TEX_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE TEX_TAREA_EXTERNAS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE TEX_TAREA_EXTERNAS_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEX_TAREA_EXTERNA' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEX_TAREA_EXTERNA' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'TEX_TAREA_EXTERNAS_TEX_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEX_TAREA_EXTERNAS_TEX_IX on bi_cdd_bbva_datastage.TEX_TAREA_EXTERNA (TEX_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE TEX_TAREA_EXTERNAS_TEX_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE TEX_TAREA_EXTERNAS_TEX_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'TEV_TAREA_EXTERNA_VALOR' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'TEV_TAREA_EXTERNA_VALOR' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'TEV_TAREA_EXTERNA_VALOR_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX TEV_TAREA_EXTERNA_VALOR_IX on bi_cdd_bbva_datastage.TEV_TAREA_EXTERNA_VALOR (TEX_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE TEV_TAREA_EXTERNA_VALOR_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE TEV_TAREA_EXTERNA_VALOR_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'MEJ_REG_REGISTRO' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'MEJ_REG_REGISTRO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'MEJ_REG_REGISTRO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX MEJ_REG_REGISTRO_IX on bi_cdd_bbva_datastage.MEJ_REG_REGISTRO (REG_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE MEJ_REG_REGISTRO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE MEJ_REG_REGISTRO_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'MEJ_IRG_INFO_REGISTRO' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'MEJ_IRG_INFO_REGISTRO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'MEJ_IRG_INFO_REGISTRO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX MEJ_IRG_INFO_REGISTRO_IX on bi_cdd_bbva_datastage.MEJ_IRG_INFO_REGISTRO (REG_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE MEJ_IRG_INFO_REGISTRO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE MEJ_IRG_INFO_REGISTRO_IX. Nº [', HAY, ']');
 end if;


 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'USD_USUARIOS_DESPACHOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'USD_USUARIOS_DESPACHOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'USD_USUARIOS_DESPACHOS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX USD_USUARIOS_DESPACHOS_IX on bi_cdd_bbva_datastage.USD_USUARIOS_DESPACHOS (USD_ID, USU_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE USD_USUARIOS_DESPACHOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE USD_USUARIOS_DESPACHOS_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'GAA_GESTOR_ADICIONAL_ASUNTO' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'GAA_GESTOR_ADICIONAL_ASUNTO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX GAA_GESTOR_ADICIONAL_ASUNTO_IX on bi_cdd_bbva_datastage.GAA_GESTOR_ADICIONAL_ASUNTO (USD_ID, DD_TGE_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE GAA_GESTOR_ADICIONAL_ASUNTO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE GAA_GESTOR_ADICIONAL_ASUNTO_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'GAA_GESTOR_ADICIONAL_ASUNTO' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'GAA_GESTOR_ADICIONAL_ASUNTO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'GAA_GESTOR_ADICIONAL_ASUNTO_ASU_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX GAA_GESTOR_ADICIONAL_ASUNTO_ASU_IX on bi_cdd_bbva_datastage.GAA_GESTOR_ADICIONAL_ASUNTO (ASU_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE GAA_GESTOR_ADICIONAL_ASUNTO_ASU_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE GAA_GESTOR_ADICIONAL_ASUNTO_ASU_IX. Nº [', HAY, ']');
 end if;


/*

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'GAH_GESTOR_ADICIONAL_HISTORICO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'GAH_GESTOR_ADICIONAL_HISTORICO_IX';
if (HAY < 1) then 
    CREATE INDEX GAH_GESTOR_ADICIONAL_HISTORICO_IX on bi_cdd_bbva_datastage.GAH_GESTOR_ADICIONAL_HISTORICO (GAH_GESTOR_ID, GAH_TIPO_GESTOR_ID);
    set o_error_status:= concat('Se ha insertado el INDICE GAH_GESTOR_ADICIONAL_HISTORICO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE GAH_GESTOR_ADICIONAL_HISTORICO_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'GAH_GESTOR_ADICIONAL_HISTORICO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'GAH_GESTOR_ADICIONAL_HISTORICO_ASU_IX';
if (HAY < 1) then 
    CREATE INDEX GAH_GESTOR_ADICIONAL_HISTORICO_ASU_IX on bi_cdd_bbva_datastage.GAH_GESTOR_ADICIONAL_HISTORICO (GAH_ASU_ID);
    set o_error_status:= concat('Se ha insertado el INDICE GAH_GESTOR_ADICIONAL_HISTORICO_ASU_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE GAH_GESTOR_ADICIONAL_HISTORICO_ASU_IX. Nº [', HAY, ']');
end if;

*/

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'USU_USUARIOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'USU_USUARIOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'USU_USUARIOS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX USU_USUARIOS_IX on bi_cdd_bbva_datastage.USU_USUARIOS (USU_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE USU_USUARIOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE USU_USUARIOS_IX. Nº [', HAY, ']');
 end if;



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'EXT_IAC_INFO_ADD_CONTRATO' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'EXT_IAC_INFO_ADD_CONTRATO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'EXT_IAC_INFO_ADD_CONTRATO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX EXT_IAC_INFO_ADD_CONTRATO_IX on bi_cdd_bbva_datastage.EXT_IAC_INFO_ADD_CONTRATO (IAC_VALUE_COBRO);
--    set o_error_status:= concat('Se ha insertado el INDICE EXT_IAC_INFO_ADD_CONTRATO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE EXT_IAC_INFO_ADD_CONTRATO_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'EXT_IAC_INFO_ADD_CONTRATO' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'EXT_IAC_INFO_ADD_CONTRATO' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'EXT_IAC_INFO_ADD_CONTRATO_CNT_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX EXT_IAC_INFO_ADD_CONTRATO_CNT_IX on bi_cdd_bbva_datastage.EXT_IAC_INFO_ADD_CONTRATO (CNT_ID); 
--    set o_error_status:= concat('Se ha insertado el INDICE EXT_IAC_INFO_ADD_CONTRATO_CNT_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE EXT_IAC_INFO_ADD_CONTRATO_CNT_IX. Nº [', HAY, ']');
 end if;



/*
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DPR_DECISIONES_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'DPR_DECISIONES_PROCEDIMIENTOS_IX';
if (HAY < 1) then 
    CREATE INDEX DPR_DECISIONES_PROCEDIMIENTOS_IX on bi_cdd_bbva_datastage.DPR_DECISIONES_PROCEDIMIENTOS (PRC_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE DPR_DECISIONES_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE DPR_DECISIONES_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
end if;




select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'RCR_RECURSOS_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'RCR_RECURSOS_PROCEDIMIENTOS_IX';
if (HAY < 1) then 
    CREATE INDEX RCR_RECURSOS_PROCEDIMIENTOS_IX on bi_cdd_bbva_datastage.RCR_RECURSOS_PROCEDIMIENTOS (PRC_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE RCR_RECURSOS_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE RCR_RECURSOS_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
end if;

*/


/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PVR_OPE_PROV_REC_OPERACION' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PVR_OPE_PROV_REC_OPERACION_IX';
if (HAY < 1) then 
    CREATE INDEX PVR_OPE_PROV_REC_OPERACION_IX on bi_cdd_bbva_datastage.PVR_OPE_PROV_REC_OPERACION (PVR_OPE_CNT_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE PVR_OPE_PROV_REC_OPERACION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE PVR_OPE_PROV_REC_OPERACION_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PVR_OPE_PROV_REC_OPERACION' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PVR_OPE_PROV_REC_OPERACION_ALTA_IX';
if (HAY < 1) then 
    CREATE INDEX PVR_OPE_PROV_REC_OPERACION_ALTA_IX on bi_cdd_bbva_datastage.PVR_OPE_PROV_REC_OPERACION (PVR_OPE_FECHA_ALTA, PVR_OPE_CNT_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE PVR_OPE_PROV_REC_OPERACION_ALTA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE PVR_OPE_PROV_REC_OPERACION_ALTA_IX. Nº [', HAY, ']');
end if;
*/



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CNT_DPS_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CNT_DPS_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CNT_DPS_CONTRATOS_IX';
 if (HAY_TABLA > 1 && HAY < 1) then 
	CREATE INDEX CNT_DPS_CONTRATOS_IX on bi_cdd_bbva_datastage.CNT_DPS_CONTRATOS (FECHA_REGULARIZACIon, CONTRATO); 
-- set o_error_status:= concat('Se ha insertado el INDICE CNT_DPS_CONTRATOS_IX. Nº [', HAY, ']');
-- else 
-- 	set o_error_status:= concat('Ya existe el INDICE CNT_DPS_CONTRATOS_IX o NO HAY TABLA. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CNT_DPS_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CNT_DPS_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CNT_DPS_CONTRATOS_OPE_IX';
 if (HAY_TABLA > 1 && HAY < 1) then 
    CREATE INDEX CNT_DPS_CONTRATOS_OPE_IX on bi_cdd_bbva_datastage.CNT_DPS_CONTRATOS (PVR_OPE_ID_OPERACION); 
--    set o_error_status:= concat('Se ha insertado el INDICE CNT_DPS_CONTRATOS_OPE_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CNT_DPS_CONTRATOS_OPE_IX. Nº [', HAY, ']');
 end if;




/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PVR_LOAD_STATIC_DATA_CONTRATOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PVR_LOAD_STATIC_DATA_CONTRATOS_IX';
if (HAY < 1) then 
    CREATE INDEX PVR_LOAD_STATIC_DATA_CONTRATOS_IX on bi_cdd_bbva_datastage.PVR_LOAD_STATIC_DATA_CONTRATOS (PER_ID, CNT_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE PVR_LOAD_STATIC_DATA_CONTRATOS_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE PVR_LOAD_STATIC_DATA_CONTRATOS_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PVR_LOAD_STATIC_DATA_CLIENTES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PVR_LOAD_STATIC_DATA_CLIENTES_IX';
if (HAY < 1) then 
    CREATE INDEX PVR_LOAD_STATIC_DATA_CLIENTES_IX on bi_cdd_bbva_datastage.PVR_LOAD_STATIC_DATA_CLIENTES (PER_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE PVR_LOAD_STATIC_DATA_CLIENTES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE PVR_LOAD_STATIC_DATA_CLIENTES_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'ACE_ACCIONES_EXTRAJUDICIALES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'ACE_ACCIONES_EXTRAJUDICIALES_IX';
if (HAY < 1) then 
    CREATE INDEX ACE_ACCIONES_EXTRAJUDICIALES_IX on bi_cdd_bbva_datastage.ACE_ACCIONES_EXTRAJUDICIALES (PVR_OPE_ID_OPERACION); 
    set o_error_status:= concat('Se ha insertado el INDICE ACE_ACCIONES_EXTRAJUDICIALES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE ACE_ACCIONES_EXTRAJUDICIALES_IX. Nº [', HAY, ']');
end if;
*/



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PRE_PREVISIONES' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRE_PREVISIONES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRE_PREVISIONES_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX PRE_PREVISIONES_IX on bi_cdd_bbva_datastage.PRE_PREVISIONES (CNT_ID); 
--    set o_error_status:= concat('Se ha insertado el INDICE PRE_PREVISIONES_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PRE_PREVISIONES_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PRE_PREVISIONES' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRE_PREVISIONES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRE_PREVISIONES_FECHA_PREVISION_IX';
 if (HAY < 1 && HAY_TABLA > 0) then
    CREATE INDEX PRE_PREVISIONES_FECHA_PREVISION_IX on bi_cdd_bbva_datastage.PRE_PREVISIONES (PRE_FECHA_PREVISION); 
--    set o_error_status:= concat('Se ha insertado el INDICE PRE_PREVISIONES_FECHA_PREVISION_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PRE_PREVISIONES_FECHA_PREVISION_IX. Nº [', HAY, ']');
 end if;




 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'CARTERIZACION_ESPECIALIZADA' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CARTERIZACION_ESPECIALIZADA'  and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CARTERIZACION_ESPECIALIZADA_IX';
 if (HAY < 1 && HAY_TABLA > 0) then
    CREATE INDEX CARTERIZACION_ESPECIALIZADA_IX on bi_cdd_bbva_datastage.CARTERIZACION_ESPECIALIZADA (CNT_ID); 
--    set o_error_status:= concat('Se ha insertado el INDICE CARTERIZACION_ESPECIALIZADA_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE CARTERIZACION_ESPECIALIZADA_IX. Nº [', HAY, ']');
 end if;



/*
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CAR_CARTERA' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CAR_CARTERA_IX';
if (HAY < 1) then 
    CREATE INDEX CAR_CARTERA_IX on bi_cdd_bbva_datastage.CAR_CARTERA (CAR_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE CAR_CARTERA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE CAR_CARTERA_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CAR_CARTERA' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CAR_CARTERA_DESCRIPCION_IX';
if (HAY < 1) then 
    CREATE INDEX CAR_CARTERA_DESCRIPCION_IX on bi_cdd_bbva_datastage.CAR_CARTERA (CAR_DESCRIPCION); 
    set o_error_status:= concat('Se ha insertado el INDICE CAR_CARTERA_DESCRIPCION_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE CAR_CARTERA_DESCRIPCION_IX. Nº [', HAY, ']');
end if;

*/


/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'LOT_LOTE' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'LOT_LOTE_IX';
if (HAY < 1) then 
    CREATE INDEX LOT_LOTE_IX on bi_cdd_bbva_datastage.LOT_LOTE (LOT_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE LOT_LOTE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE LOT_LOTE_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'LOT_LOTE' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'LOT_LOTE_CARTERA_IX';
if (HAY < 1) then 
    CREATE INDEX LOT_LOTE_CARTERA_IX on bi_cdd_bbva_datastage.LOT_LOTE (CAR_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE LOT_LOTE_CARTERA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE LOT_LOTE_CARTERA_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DD_ENP_ENTIDADES_PROPIETARIAS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'DD_ENP_ENTIDADES_PROP_IX';
if (HAY < 1) then 
    CREATE INDEX DD_ENP_ENTIDADES_PROP_IX on bi_cdd_bbva_datastage.DD_ENP_ENTIDADES_PROPIETARIAS (DD_ENP_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE DD_ENP_ENTIDADES_PROP_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE DD_ENP_ENTIDADES_PROP_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DD_ENC_ENTIDADES_CEDENTES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'DD_ENC_ENTIDADES_CEDENTES_IX';
if (HAY < 1) then 
    CREATE INDEX DD_ENC_ENTIDADES_CEDENTES_IX on bi_cdd_bbva_datastage.DD_ENC_ENTIDADES_CEDENTES (DD_ENC_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE DD_ENC_ENTIDADES_CEDENTES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE DD_ENC_ENTIDADES_CEDENTES_IX. Nº [', HAY, ']');
end if;*/


 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'OFI_OFICINAS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'OFI_OFICINAS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'OFI_OFICINAS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX OFI_OFICINAS_IX on bi_cdd_bbva_datastage.OFI_OFICINAS (OFI_ID); 
--    set o_error_status:= concat('Se ha insertado el INDICE OFI_OFICINAS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE OFI_OFICINAS_IX. Nº [', HAY, ']');
 end if;



/*
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CPA_COBROS_PAGOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CPA_COBROS_PAGOS_IX';
if (HAY < 1) then 
    CREATE INDEX CPA_COBROS_PAGOS_IX on bi_cdd_bbva_datastage.CPA_COBROS_PAGOS (CPA_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE CPA_COBROS_PAGOS_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE CPA_COBROS_PAGOS_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'CPA_COBROS_PAGOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'CPA_COBROS_PAGOS_FECHA_IX';
if (HAY < 1) then 
    CREATE INDEX CPA_COBROS_PAGOS_FECHA_IX on bi_cdd_bbva_datastage.CPA_COBROS_PAGOS (CPA_FECHA); 
    set o_error_status:= concat('Se ha insertado el INDICE CPA_COBROS_PAGOS_FECHA_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE CPA_COBROS_PAGOS_FECHA_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'ITA_INPUTS_TAREAS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'ITA_INPUTS_TAREAS_BPM_IPT_IX';
if (HAY < 1) then 
    CREATE INDEX ITA_INPUTS_TAREAS_BPM_IPT_IX on bi_cdd_bbva_datastage.ITA_INPUTS_TAREAS (BPM_IPT_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE ITA_INPUTS_TAREAS_BPM_IPT_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE ITA_INPUTS_TAREAS_BPM_IPT_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'ITA_INPUTS_TAREAS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'ITA_INPUTS_TAREAS_TEX_IX';
if (HAY < 1) then 
    CREATE INDEX ITA_INPUTS_TAREAS_TEX_IX on bi_cdd_bbva_datastage.ITA_INPUTS_TAREAS (TEX_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE ITA_INPUTS_TAREAS_TEX_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE ITA_INPUTS_TAREAS_TEX_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'BPM_DIP_DATOS_INPUT' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'BPM_DIP_DATOS_INPUT_BPM_IPT_IX';
if (HAY < 1) then 
    CREATE INDEX BPM_DIP_DATOS_INPUT_BPM_IPT_IX on bi_cdd_bbva_datastage.BPM_DIP_DATOS_INPUT (BPM_IPT_ID); 
    set o_error_status:= concat('Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_BPM_IPT_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE BPM_DIP_DATOS_INPUT_BPM_IPT_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'BPM_DIP_DATOS_INPUT' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX';
if (HAY < 1) then 
    CREATE INDEX BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX on bi_cdd_bbva_datastage.BPM_DIP_DATOS_INPUT (BPM_DIP_NOMBRE); 
    set o_error_status:= concat('Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE BPM_DIP_DATOS_INPUT_DIP_NOMBRE_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'BPM_DIP_DATOS_INPUT' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'BPM_DIP_DATOS_INPUT_DIP_VALOR_IX';
if (HAY < 1) then 
    CREATE INDEX BPM_DIP_DATOS_INPUT_DIP_VALOR_IX on bi_cdd_bbva_datastage.BPM_DIP_DATOS_INPUT (BPM_DIP_VALOR); 
    set o_error_status:= concat('Se ha insertado el INDICE BPM_DIP_DATOS_INPUT_DIP_VALOR_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE BPM_DIP_DATOS_INPUT_DIP_VALOR_IX. Nº [', HAY, ']');
end if;
*/



 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'ACU_ACUERDOS_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'ACU_ACUERDOS_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX ACU_ACUERDOS_PROCEDIMIENTOS_IX on bi_cdd_bbva_datastage.ACU_ACUERDOS_PROCEDIMIENTOS (ACU_ID); 
--    set o_error_status:= concat('Se ha insertado el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
 end if;

 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'ACU_ACUERDOS_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'ACU_ACUERDOS_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX on bi_cdd_bbva_datastage.ACU_ACUERDOS_PROCEDIMIENTOS (ASU_ID); 
--    set o_error_status:= concat('Se ha insertado el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX. Nº [', HAY, ']');
 end if;




/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'LIN_LOTES_NUEVOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'LIN_LOTES_NUEVOS_NUMERO_CASO_IX';
if (HAY < 1) then 
    CREATE INDEX LIN_LOTES_NUEVOS_NUMERO_CASO_IX on bi_cdd_bbva_datastage.LIN_LOTES_NUEVOS (N_CASO); 
    set o_error_status:= concat('Se ha insertado el INDICE LIN_LOTES_NUEVOS_NUMERO_CASO_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE LIN_LOTES_NUEVOS_NUMERO_CASO_IX. Nº [', HAY, ']');
end if;
*/



/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'BPM_IPT_INPUT' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'BPM_IPT_INPUT_IX';
if (HAY < 1) then 
    CREATE INDEX BPM_IPT_INPUT_IX on bi_cdd_bbva_datastage.BPM_IPT_INPUT (PRC_ID);
    set o_error_status:= concat('Se ha insertado el INDICE BPM_IPT_INPUT_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE BPM_IPT_INPUT_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'BPM_IPT_INPUT' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'BPM_IPT_INPUT_ID_IX';
if (HAY < 1) then 
    CREATE INDEX BPM_IPT_INPUT_ID_IX on bi_cdd_bbva_datastage.BPM_IPT_INPUT (BPM_IPT_ID);
    set o_error_status:= concat('Se ha insertado el INDICE BPM_IPT_INPUT_ID_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE BPM_IPT_INPUT_ID_IX. Nº [', HAY, ']');
end if;

select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'BPM_IPT_INPUT' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'BPM_IPT_INPUT_USUARIOCREAR_IX';
if (HAY < 1) then 
    CREATE INDEX BPM_IPT_INPUT_USUARIOCREAR_IX on bi_cdd_bbva_datastage.BPM_IPT_INPUT (FECHACREAR, USUARIOCREAR);
    set o_error_status:= concat('Se ha insertado el INDICE BPM_IPT_INPUT_USUARIOCREAR_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE BPM_IPT_INPUT_USUARIOCREAR_IX. Nº [', HAY, ']');
end if;
*/




/*select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'BPM_GVA_GRUPOS_VALORES' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'BPM_GVA_GRUPOS_VALORES_IX';
if (HAY < 1) then 
    CREATE INDEX BPM_GVA_GRUPOS_VALORES_IX on bi_cdd_bbva_datastage.BPM_GVA_GRUPOS_VALORES (PRC_ID);
    set o_error_status:= concat('Se ha insertado el INDICE BPM_GVA_GRUPOS_VALORES_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE BPM_GVA_GRUPOS_VALORES_IX. Nº [', HAY, ']');
end if;
*/



/*
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'EXT_IAB_INFO_ADD_BI_H' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'EXT_IAB_INFO_ADD_BI_H_IX';
if (HAY < 1) then 
    CREATE INDEX EXT_IAB_INFO_ADD_BI_H_IX on bi_cdd_bbva_datastage.EXT_IAB_INFO_ADD_BI_H (IAB_FECHA_VALOR, IAB_ID_UNIDAD_GESTION);
    set o_error_status:= concat('Se ha insertado el INDICE EXT_IAB_INFO_ADD_BI_H_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE EXT_IAB_INFO_ADD_BI_H_IX. Nº [', HAY, ']');
end if;
*/


/*
select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'EXT_IAB_INFO_ADD_BI' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'EXT_IAB_INFO_ADD_BI_IX';
if (HAY < 1) then 
    CREATE INDEX EXT_IAB_INFO_ADD_BI_IX on bi_cdd_bbva_datastage.EXT_IAB_INFO_ADD_BI (IAB_FECHA_VALOR, IAB_ID_UNIDAD_GESTION);
    set o_error_status:= concat('Se ha insertado el INDICE EXT_IAB_INFO_ADD_BI_IX. Nº [', HAY, ']');
else 
    set o_error_status:= concat('Ya existe el INDICE EXT_IAB_INFO_ADD_BI_IX. Nº [', HAY, ']');
end if;
*/

/* Incluido el 2014-12-06 */
 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'SPR_SOLICITUD_PRORROGA' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'SPR_SOLICITUD_PRORROGA' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'SPR_SOLICITUD_PRORROGA_IX';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX SPR_SOLICITUD_PRORROGA_IX on bi_cdd_bbva_datastage.SPR_SOLICITUD_PRORROGA (TAR_ID, FECHACREAR); 
--    set o_error_status:= concat('Se ha insertado el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE ACU_ACUERDOS_PROCEDIMIENTOS_ASUNTO_IX. Nº [', HAY, ']');
 end if;

/* Incluido el 2014-12-06 */
 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'DPR_DECISIONES_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'DPR_DECISIONES_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'DPR_DECISIONES_PROCEDIMIENTOS_IX';
 if (HAY < 1) then 
    CREATE INDEX DPR_DECISIONES_PROCEDIMIENTOS_IX on bi_cdd_bbva_datastage.DPR_DECISIONES_PROCEDIMIENTOS (PRC_ID); 
--    set o_error_status:= concat('Se ha insertado el INDICE DPR_DECISIONES_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE DPR_DECISIONES_PROCEDIMIENTOS_IX. Nº [', HAY, ']');
 end if;

/* Incluido el 2014-12-06 */
 select count(table_name) into HAY_TABLA from information_schema.tables where table_name = 'PRC_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage';
 select count(INDEX_NAME) into HAY from information_schema.statistics where table_name = 'PRC_PROCEDIMIENTOS' and table_schema = 'bi_cdd_bbva_datastage' and INDEX_NAME = 'PRC_PROCEDIMIENTOS_IX_3';
 if (HAY < 1 && HAY_TABLA > 0) then 
    CREATE INDEX PRC_PROCEDIMIENTOS_IX_3 on bi_cdd_bbva_datastage.PRC_PROCEDIMIENTOS (PRC_ID);
--    set o_error_status:= concat('Se ha insertado el INDICE PRC_PROCEDIMIENTOS_IX_3. Nº [', HAY, ']');
-- else 
--    set o_error_status:= concat('Ya existe el INDICE PRC_PROCEDIMIENTOS_IX_3. Nº [', HAY, ']');
 end if;

END MY_BLOCK_IND
