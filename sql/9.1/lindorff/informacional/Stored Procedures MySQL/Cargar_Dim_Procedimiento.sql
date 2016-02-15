-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Procedimiento`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_PRC: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 26/03/2015
-- Motivos del cambio: segmento y socio
-- Cliente: Recovery BI Lindorff 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Procedimiento.
-- ===============================================================================================
  
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN PROCEDIMIENTO
    -- DIM_PROCEDIMIENTO_JUZGADO
    -- DIM_PROCEDIMIENTO_PLAZA 
    -- DIM_PROCEDIMIENTO_TIPO_RECLAMACION
    -- DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO
    -- DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO 
    -- DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE
    -- DIM_PROCEDIMIENTO_FASE_ACTUAL
    -- DIM_PROCEDIMIENTO_FASE_ACTUAL_DETALLE
    -- DIM_PROCEDIMIENTO_FASE_ANTERIOR
    -- DIM_PROCEDIMIENTO_FASE_ANTERIOR_DETALLE
    -- DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO
    -- DIM_PROCEDIMIENTO_ESTADO_FASE_ACTUAL
    -- DIM_PROCEDIMIENTO_ESTADO_FASE_ANTERIOR
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO_DETALLE
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION
    -- DIM_PROCEDIMIENTO_GESTOR
    -- DIM_PROCEDIMIENTO_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_GESTOR_EN_RECOVERY
    -- DIM_PROCEDIMIENTO_GESTOR_RESOLUCION_EN_RECOVERY
    -- DIM_PROCEDIMIENTO_SUPERVISOR
    -- DIM_PROCEDIMIENTO_DESPACHO_GESTOR
    -- DIM_PROCEDIMIENTO_DESPACHO_SUPERVISOR 
    -- DIM_PROCEDIMIENTO_DESPACHO_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR 
    -- DIM_PROCEDIMIENTO_TIPO_DESPACHO_SUPERVISOR 
    -- DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_ENTIDAD_GESTOR 
    -- DIM_PROCEDIMIENTO_ENTIDAD_SUPERVISOR 
    -- DIM_PROCEDIMIENTO_ENTIDAD_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR 
    -- DIM_PROCEDIMIENTO_NIVEL_DESPACHO_SUPERVISOR
    -- DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR
    -- DIM_PROCEDIMIENTO_OFICINA_DESPACHO_SUPERVISOR
    -- DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR
    -- DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_SUPERVISOR
    -- DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR
    -- DIM_PROCEDIMIENTO_ZONA_DESPACHO_SUPERVISOR
    -- DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR_RESOLUCION
    -- DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL
    -- DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO
    -- DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA
    -- DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO
    -- DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL
    -- DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO
    -- DIM_PROCEDIMIENTO_COBRO_TIPO_DETALLE
    -- DIM_PROCEDIMIENTO_COBRO_TIPO
    -- DIM_PROCEDIMIENTO_CON_COBRO
    -- DIM_PROCEDIMIENTO_TIPO_RESOLUCION
    -- DIM_PROCEDIMIENTO_TIPO_ULTIMA_RESOLUCION
    -- DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES
    -- DIM_PROCEDIMIENTO_CARTERA
    -- DIM_PROCEDIMIENTO_TIPO_CARTERA
    -- DIM_PROCEDIMIENTO_CEDENTE_CONTRATO
    -- DIM_PROCEDIMIENTO_PROPIETARIO_CONTRATO
    -- DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO
    -- DIM_PROCEDIMIENTO_SOCIO_CONTRATO
    -- DIM_PROCEDIMIENTO_TITULAR
    -- DIM_PROCEDIMIENTO_CON_PROCURADOR
    -- DIM_PROCEDIMIENTO_PROCURADOR
    -- DIM_PROCEDIMIENTO_CON_RESOLUCION
    -- DIM_PROCEDIMIENTO_CON_IMPULSO
    -- DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION
    -- DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO    
    -- DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION
    -- DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION
    -- DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION
    -- DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION
    -- DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION
    -- DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION
    -- DIM_PROCEDIMIENTO
    -- DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO
    -- DIM_PROCEDIMIENTO_PROCURADOR_ETJ
    -- DIM_PROCEDIMIENTO_PROCURADOR_ETNJ
    -- DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO
    -- DIM_PROCEDIMIENTO_PROCURADOR_VERBAL


-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
declare max_id int;
declare tarea_desc varchar(100);
declare segmento_desc varchar(100);
declare socio_desc varchar(100);
declare l_last_row int default 0;
declare c_tarea_desc cursor for select distinct TAR_TAREA from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where PRC_ID IS NOT NULL order by 1;
declare c_segmento_desc cursor for select distinct IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 42 order by 1;
declare c_socio_desc cursor for select distinct IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 43 order by 1;
declare continue HANDLER FOR NOT FOUND SET l_last_row = 1;  


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


-- ----------------------------------------------------------------------------------------------
--                            DIM_PROCEDIMIENTO_JUZGADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_JUZGADO where JUZGADO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_JUZGADO (JUZGADO_ID, JUZGADO_DESC, JUZGADO_DESC_ALT, PLAZA_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_JUZGADO(JUZGADO_ID, JUZGADO_DESC, JUZGADO_DESC_ALT, PLAZA_ID)
    select DD_JUZ_ID, DD_JUZ_DESCRIPCION, DD_JUZ_DESCRIPCION_LARGA, DD_PLA_ID FROM recovery_lindorff_datastage.DD_JUZ_JUZGADOS_PLAZA;
            

-- ----------------------------------------------------------------------------------------------
--                            DIM_PROCEDIMIENTO_PLAZA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_PLAZA where PLAZA_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_PLAZA (PLAZA_ID, PLAZA_DESC, PLAZA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_PLAZA(PLAZA_ID, PLAZA_DESC, PLAZA_DESC_ALT)
    select DD_PLA_ID, DD_PLA_DESCRIPCION, DD_PLA_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PLA_PLAZAS;


-- ----------------------------------------------------------------------------------------------
--                          DIM_PROCEDIMIENTO_TIPO_RECLAMACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_RECLAMACION where TIPO_RECLAMACION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_RECLAMACION (TIPO_RECLAMACION_ID, TIPO_RECLAMACION_DESC, TIPO_RECLAMACION_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_TIPO_RECLAMACION(TIPO_RECLAMACION_ID, TIPO_RECLAMACION_DESC, TIPO_RECLAMACION_DESC_ALT)
    select DD_TRE_ID, DD_TRE_DESCRIPCION, DD_TRE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TRE_TIPO_RECLAMACION;



-- ----------------------------------------------------------------------------------------------
--                          DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (1 ,'P. Monitorio');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (2 ,'P. Ejecución Titulo Judicial');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (3 ,'P. Ejecución Título No Judicial');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (4 ,'P. Verbal');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (5 ,'P. Verbal Desde Monitorio');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 6) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (6 ,'P. Ordinario');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 7) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (7 ,'Precontencioso');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = 8) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (8 ,'Resto');
end if;

-- De momento no hay
/*
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = xxx) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (xxx ,'Hipotecario');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = xxx) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (xxx ,'Concurso');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO where TIPO_PROCEDIMIENTO_AGRUPADO_ID = xxx) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_AGRUPADO (TIPO_PROCEDIMIENTO_AGRUPADO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_DESC) values (xxx ,'P. Cambiario');
end if;


*/

-- ----------------------------------------------------------------------------------------------
--                          DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO where TIPO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO (TIPO_PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_DESC, TIPO_PROCEDIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO(TIPO_PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_DESC, TIPO_PROCEDIMIENTO_DESC_ALT)
    select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION;

    
-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE where TIPO_PROCEDIMIENTO_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE (TIPO_PROCEDIMIENTO_DETALLE_ID, TIPO_PROCEDIMIENTO_DETALLE_DESC, TIPO_PROCEDIMIENTO_DETALLE_DESC_ALT, TIPO_PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE(TIPO_PROCEDIMIENTO_DETALLE_ID, TIPO_PROCEDIMIENTO_DETALLE_DESC, TIPO_PROCEDIMIENTO_DETALLE_DESC_ALT, TIPO_PROCEDIMIENTO_ID)
    select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID FROM recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO;


-- 1 - P. Monitorio
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 1 where TIPO_PROCEDIMIENTO_DETALLE_ID in (1148);
-- 2 - P. Ejecución Titulo Judicial
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 2 where TIPO_PROCEDIMIENTO_DETALLE_ID in (1249);
-- 3 - P. Ejecución Título No Judicial
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 3 where TIPO_PROCEDIMIENTO_DETALLE_ID in (1441);
-- 4 - P. Verbal
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 4 where TIPO_PROCEDIMIENTO_DETALLE_ID in (1543);
-- 5 - P. Verbal Desde Monitorio
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 5 where TIPO_PROCEDIMIENTO_DETALLE_ID in (1541);
-- 6 - P. Ordinario
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 6 where TIPO_PROCEDIMIENTO_DETALLE_ID in (1542);
-- 7 - Precontencioso 
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 7 where TIPO_PROCEDIMIENTO_DETALLE_ID in (1248);
-- 8 - Resto 
update DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE set TIPO_PROCEDIMIENTO_AGRUPADO_ID = 8 where TIPO_PROCEDIMIENTO_AGRUPADO_ID is null;

-- xxx - P. Hipotecario
-- xxx - P. Concurso
-- xxx - P. Cambiario

-- ----------------------------------------------------------------------------------------------
--                             DIM_PROCEDIMIENTO_FASE_ACTUAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_ACTUAL where FASE_ACTUAL_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_ACTUAL (FASE_ACTUAL_ID, FASE_ACTUAL_DESC, FASE_ACTUAL_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_FASE_ACTUAL(FASE_ACTUAL_ID, FASE_ACTUAL_DESC, FASE_ACTUAL_DESC_ALT)
    select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION;


	-- ----------------------------------------------------------------------------------------------
--                           DIM_PROCEDIMIENTO_FASE_ACTUAL_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_ACTUAL_DETALLE where FASE_ACTUAL_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_ACTUAL_DETALLE (FASE_ACTUAL_DETALLE_ID, FASE_ACTUAL_DETALLE_DESC, FASE_ACTUAL_DETALLE_DESC_ALT, FASE_ACTUAL_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_FASE_ACTUAL_DETALLE(FASE_ACTUAL_DETALLE_ID, FASE_ACTUAL_DETALLE_DESC, FASE_ACTUAL_DETALLE_DESC_ALT, FASE_ACTUAL_ID)
    select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID FROM recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO;
    
  
-- ----------------------------------------------------------------------------------------------
--                          DIM_PROCEDIMIENTO_FASE_ANTERIOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_ANTERIOR where FASE_ANTERIOR_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_ANTERIOR (FASE_ANTERIOR_ID, FASE_ANTERIOR_DESC, FASE_ANTERIOR_DESC_ALT) values (-2 ,'No Aplica (Iter)', 'No Aplica (Iter)');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_FASE_ANTERIOR where FASE_ANTERIOR_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_ANTERIOR (FASE_ANTERIOR_ID, FASE_ANTERIOR_DESC, FASE_ANTERIOR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_FASE_ANTERIOR(FASE_ANTERIOR_ID, FASE_ANTERIOR_DESC, FASE_ANTERIOR_DESC_ALT)
    select DD_TAC_ID, DD_TAC_DESCRIPCION, DD_TAC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_FASE_ANTERIOR_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_ANTERIOR_DETALLE where FASE_ANTERIOR_DETALLE_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_ANTERIOR_DETALLE (FASE_ANTERIOR_DETALLE_ID, FASE_ANTERIOR_DETALLE_DESC, FASE_ANTERIOR_DETALLE_DESC_ALT, FASE_ANTERIOR_ID) values (-2 ,'No Aplica (Iter)', 'No Aplica (Iter)', -2);
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_FASE_ANTERIOR_DETALLE where FASE_ANTERIOR_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_ANTERIOR_DETALLE (FASE_ANTERIOR_DETALLE_ID, FASE_ANTERIOR_DETALLE_DESC, FASE_ANTERIOR_DETALLE_DESC_ALT, FASE_ANTERIOR_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_FASE_ANTERIOR_DETALLE(FASE_ANTERIOR_DETALLE_ID, FASE_ANTERIOR_DETALLE_DESC, FASE_ANTERIOR_DETALLE_DESC_ALT, FASE_ANTERIOR_ID)
    select DD_TPO_ID, DD_TPO_DESCRIPCION, DD_TPO_DESCRIPCION_LARGA, DD_TAC_ID FROM recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO;
    
    
-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO where ESTADO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO where ESTADO_PROCEDIMIENTO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC) values (0,'Activo');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO where ESTADO_PROCEDIMIENTO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_ESTADO_PROCEDIMIENTO (ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC) values (1 ,'No Activo');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ESTADO_FASE_ACTUAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ESTADO_FASE_ACTUAL where ESTADO_FASE_ACTUAL_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ESTADO_FASE_ACTUAL (ESTADO_FASE_ACTUAL_ID, ESTADO_FASE_ACTUAL_DESC, ESTADO_FASE_ACTUAL_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ESTADO_FASE_ACTUAL(ESTADO_FASE_ACTUAL_ID, ESTADO_FASE_ACTUAL_DESC, ESTADO_FASE_ACTUAL_DESC_ALT)
    select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EPR_ESTADO_PROCEDIMIENTO;
    

-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ESTADO_FASE_ANTERIOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ESTADO_FASE_ANTERIOR where ESTADO_FASE_ANTERIOR_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ESTADO_FASE_ANTERIOR (ESTADO_FASE_ANTERIOR_ID, ESTADO_FASE_ANTERIOR_DESC, ESTADO_FASE_ANTERIOR_DESC_ALT) values (-2 ,'No Aplica (Iter)', 'No Aplica (Iter)');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ESTADO_FASE_ANTERIOR where ESTADO_FASE_ANTERIOR_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ESTADO_FASE_ANTERIOR (ESTADO_FASE_ANTERIOR_ID, ESTADO_FASE_ANTERIOR_DESC, ESTADO_FASE_ANTERIOR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ESTADO_FASE_ANTERIOR(ESTADO_FASE_ANTERIOR_ID, ESTADO_FASE_ANTERIOR_DESC, ESTADO_FASE_ANTERIOR_DESC_ALT)
    select DD_EPR_ID, DD_EPR_DESCRIPCION, DD_EPR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EPR_ESTADO_PROCEDIMIENTO;
  

-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO where ULTIMA_TAREA_CREADA_TIPO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO (ULTIMA_TAREA_CREADA_TIPO_ID, ULTIMA_TAREA_CREADA_TIPO_DESC, ULTIMA_TAREA_CREADA_TIPO_DESC_ALT) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO where ULTIMA_TAREA_CREADA_TIPO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO (ULTIMA_TAREA_CREADA_TIPO_ID, ULTIMA_TAREA_CREADA_TIPO_DESC, ULTIMA_TAREA_CREADA_TIPO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO(ULTIMA_TAREA_CREADA_TIPO_ID, ULTIMA_TAREA_CREADA_TIPO_DESC, ULTIMA_TAREA_CREADA_TIPO_DESC_ALT)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAR_TIPO_TAREA_BASE;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO_DETALLE where ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO_DETALLE (ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, ULTIMA_TAREA_CREADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_CREADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_CREADA_TIPO_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2);
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO_DETALLE where ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO_DETALLE (ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, ULTIMA_TAREA_CREADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_CREADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_CREADA_TIPO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_TIPO_DETALLE(ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, ULTIMA_TAREA_CREADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_CREADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_CREADA_TIPO_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID FROM recovery_lindorff_datastage.DD_STA_SUBTIPO_TAREA_BASE;
    
    
-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION where ULTIMA_TAREA_CREADA_DESCRIPCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION (ULTIMA_TAREA_CREADA_DESCRIPCION_ID, ULTIMA_TAREA_CREADA_DESCRIPCION_DESC) values (-2 ,'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION where ULTIMA_TAREA_CREADA_DESCRIPCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION (ULTIMA_TAREA_CREADA_DESCRIPCION_ID, ULTIMA_TAREA_CREADA_DESCRIPCION_DESC) values (-1, 'Desconocido');
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULTIMA_TAREA_CREADA_DESCRIPCION_ID) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION) +1;
insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION (ULTIMA_TAREA_CREADA_DESCRIPCION_ID, ULTIMA_TAREA_CREADA_DESCRIPCION_DESC)
values (max_id,tarea_desc);

end loop;
close c_tarea_desc;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO where ULTIMA_TAREA_FINALIZADA_TIPO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO (ULTIMA_TAREA_FINALIZADA_TIPO_ID, ULTIMA_TAREA_FINALIZADA_TIPO_DESC, ULTIMA_TAREA_FINALIZADA_TIPO_DESC_ALT) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO where ULTIMA_TAREA_FINALIZADA_TIPO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO (ULTIMA_TAREA_FINALIZADA_TIPO_ID, ULTIMA_TAREA_FINALIZADA_TIPO_DESC, ULTIMA_TAREA_FINALIZADA_TIPO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO(ULTIMA_TAREA_FINALIZADA_TIPO_ID, ULTIMA_TAREA_FINALIZADA_TIPO_DESC, ULTIMA_TAREA_FINALIZADA_TIPO_DESC_ALT)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAR_TIPO_TAREA_BASE;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE where ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE (ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID, ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_FINALIZADA_TIPO_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2);
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE where ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE (ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID, ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_FINALIZADA_TIPO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE(ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID, ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_FINALIZADA_TIPO_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID FROM recovery_lindorff_datastage.DD_STA_SUBTIPO_TAREA_BASE;
    

-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION where ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION (ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID, ULTIMA_TAREA_FINALIZADA_DESCRIPCION_DESC) values (-2 ,'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION where ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION (ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID, ULTIMA_TAREA_FINALIZADA_DESCRIPCION_DESC) values (-1, 'Desconocido');
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION) +1;
insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION (ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID, ULTIMA_TAREA_FINALIZADA_DESCRIPCION_DESC)
values (max_id,tarea_desc);

end loop;
close c_tarea_desc;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO where ULTIMA_TAREA_ACTUALIZADA_TIPO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO (ULTIMA_TAREA_ACTUALIZADA_TIPO_ID, ULTIMA_TAREA_ACTUALIZADA_TIPO_DESC, ULTIMA_TAREA_ACTUALIZADA_TIPO_DESC_ALT) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO where ULTIMA_TAREA_ACTUALIZADA_TIPO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO (ULTIMA_TAREA_ACTUALIZADA_TIPO_ID, ULTIMA_TAREA_ACTUALIZADA_TIPO_DESC, ULTIMA_TAREA_ACTUALIZADA_TIPO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO(ULTIMA_TAREA_ACTUALIZADA_TIPO_ID, ULTIMA_TAREA_ACTUALIZADA_TIPO_DESC, ULTIMA_TAREA_ACTUALIZADA_TIPO_DESC_ALT)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAR_TIPO_TAREA_BASE;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE where ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE (ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID, ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_ACTUALIZADA_TIPO_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2);
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE where ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE (ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID, ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_ACTUALIZADA_TIPO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE(ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID, ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_DESC, ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_ACTUALIZADA_TIPO_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID FROM recovery_lindorff_datastage.DD_STA_SUBTIPO_TAREA_BASE;
    

-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION where ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION (ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID, ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_DESC) values (-2 ,'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION where ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION (ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID, ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_DESC) values (-1, 'Desconocido');
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION) +1;
insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION (ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID, ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_DESC)
values (max_id,tarea_desc);

end loop;
close c_tarea_desc;



-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO where ULTIMA_TAREA_PENDIENTE_TIPO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO (ULTIMA_TAREA_PENDIENTE_TIPO_ID, ULTIMA_TAREA_PENDIENTE_TIPO_DESC, ULTIMA_TAREA_PENDIENTE_TIPO_DESC_ALT) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO where ULTIMA_TAREA_PENDIENTE_TIPO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO (ULTIMA_TAREA_PENDIENTE_TIPO_ID, ULTIMA_TAREA_PENDIENTE_TIPO_DESC, ULTIMA_TAREA_PENDIENTE_TIPO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO(ULTIMA_TAREA_PENDIENTE_TIPO_ID, ULTIMA_TAREA_PENDIENTE_TIPO_DESC, ULTIMA_TAREA_PENDIENTE_TIPO_DESC_ALT)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAR_TIPO_TAREA_BASE;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE where ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE (ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID, ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_DESC, ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_PENDIENTE_TIPO_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2);
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE where ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE (ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID, ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_DESC, ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_PENDIENTE_TIPO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE(ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID, ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_DESC, ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_PENDIENTE_TIPO_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID FROM recovery_lindorff_datastage.DD_STA_SUBTIPO_TAREA_BASE;
    
    
-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION where ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION (ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID, ULTIMA_TAREA_PENDIENTE_DESCRIPCION_DESC) values (-2 ,'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION where ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION (ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID, ULTIMA_TAREA_PENDIENTE_DESCRIPCION_DESC) values (-1, 'Desconocido');
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION) +1;
insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION (ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID, ULTIMA_TAREA_PENDIENTE_DESCRIPCION_DESC)
values (max_id,tarea_desc);

end loop;
close c_tarea_desc;




-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO where ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO (ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DESC, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DESC_ALT) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO where ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO (ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DESC, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO(ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DESC, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DESC_ALT)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAR_TIPO_TAREA_BASE;


-- ----------------------------------------------------------------------------------------------
--                                    DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE where ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE (ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_DESC, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID) values (-2 ,'Ninguna Tarea Asociada', 'Ninguna Tarea Asociada', -2);
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE where ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE (ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_DESC, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE(ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_DESC, ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_DESC_ALT, ULTIMA_TAREA_PENDIENTE_FA_TIPO_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID FROM recovery_lindorff_datastage.DD_STA_SUBTIPO_TAREA_BASE;
    
    
-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION where ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION (ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID, ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_DESC) values (-2 ,'Ninguna Tarea Asociada');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION where ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION (ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID, ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_DESC) values (-1, 'Desconocido');
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION) +1;
insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION (ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID, ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_DESC)
values (max_id,tarea_desc);

end loop;
close c_tarea_desc;

-- ----------------------------------------------------------------------------------------------
--                                 DIM_PROCEDIMIENTO_GESTOR
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_GESTOR where GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_GESTOR(
    GESTOR_PROCEDIMIENTO_ID,
    GESTOR_PROCEDIMIENTO_NOMBRE_COMPLETO,
    GESTOR_PROCEDIMIENTO_NOMBRE,
    GESTOR_PROCEDIMIENTO_APELLIDO1,
    GESTOR_PROCEDIMIENTO_APELLIDO2,
    ENTIDAD_GESTOR_PROCEDIMIENTO_ID, 
    DESPACHO_GESTOR_PROCEDIMIENTO_ID) values (-1 ,'Sin Gestor Asignado','Sin Gestor Asignado', 'Sin Gestor Asignado', 'Sin Gestor Asignado', -1, -1);
end if;

insert into DIM_PROCEDIMIENTO_GESTOR (
    GESTOR_PROCEDIMIENTO_ID,
    GESTOR_PROCEDIMIENTO_NOMBRE_COMPLETO,
    GESTOR_PROCEDIMIENTO_NOMBRE,
    GESTOR_PROCEDIMIENTO_APELLIDO1,
    GESTOR_PROCEDIMIENTO_APELLIDO2,
    ENTIDAD_GESTOR_PROCEDIMIENTO_ID, 
    DESPACHO_GESTOR_PROCEDIMIENTO_ID
    )
select usu.USU_ID,
    coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), 'Desconocido'),
    coalesce(usu.USU_NOMBRE, 'Desconocido'),
    coalesce(usu.USU_APELLIDO1, 'Desconocido'),
    coalesce(usu.USU_APELLIDO2, 'Desconocido'),
    usu.ENTIDAD_ID,
    coalesce(usd.DES_ID, -1)
    from recovery_lindorff_datastage.USU_USUARIOS usu
    left join recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd on usd.USU_ID = usu.USU_ID        
join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
where tges.DD_TGE_DESCRIPCION = 'Gestor Externo' group by usu.USU_ID;

update DIM_PROCEDIMIENTO_GESTOR set GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID = 1;


-- ----------------------------------------------------------------------------------------------
--                                 DIM_PROCEDIMIENTO_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_GESTOR_RESOLUCION where GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_GESTOR_RESOLUCION(
    GESTOR_RESOLUCION_ID,
    GESTOR_RESOLUCION_NOMBRE_COMPLETO,
    GESTOR_RESOLUCION_NOMBRE,
    GESTOR_RESOLUCION_APELLIDO1,
    GESTOR_RESOLUCION_APELLIDO2,
    ENTIDAD_GESTOR_RESOLUCION_ID, 
    DESPACHO_GESTOR_RESOLUCION_ID) values (-1 ,'Sin Gestor Asignado','Sin Gestor Asignado', 'Sin Gestor Asignado', 'Sin Gestor Asignado', -1, -1);
end if;

insert into DIM_PROCEDIMIENTO_GESTOR_RESOLUCION (
    GESTOR_RESOLUCION_ID,
    GESTOR_RESOLUCION_NOMBRE_COMPLETO,
    GESTOR_RESOLUCION_NOMBRE,
    GESTOR_RESOLUCION_APELLIDO1,
    GESTOR_RESOLUCION_APELLIDO2,
    ENTIDAD_GESTOR_RESOLUCION_ID, 
    DESPACHO_GESTOR_RESOLUCION_ID
    )
select usu.USU_ID,
    coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), 'Desconocido'),
    coalesce(usu.USU_NOMBRE, 'Desconocido'),
    coalesce(usu.USU_APELLIDO1, 'Desconocido'),
    coalesce(usu.USU_APELLIDO2, 'Desconocido'),
    usu.ENTIDAD_ID,
    coalesce(usd.DES_ID, -1)
    from recovery_lindorff_datastage.USU_USUARIOS usu
    left join recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd on usd.USU_ID = usu.USU_ID     
group by usu.USU_ID;

update DIM_PROCEDIMIENTO_GESTOR_RESOLUCION set GESTOR_RESOLUCION_EN_RECOVERY_ID = 1;


-- ----------------------------------------------------------------------------------------------
--     DIM_PROCEDIMIENTO_GESTOR_EN_RECOVERY / DIM_PROCEDIMIENTO_GESTOR_RESOLUCION_EN_RECOVERY
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_GESTOR_EN_RECOVERY where GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_GESTOR_EN_RECOVERY (GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID, GESTOR_EN_RECOVERY_PROCEDIMIENTO_DESC) values (0 ,'No Usa Recovery');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_GESTOR_EN_RECOVERY where GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_GESTOR_EN_RECOVERY (GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID, GESTOR_EN_RECOVERY_PROCEDIMIENTO_DESC) values (1 ,'Usa Recovery');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_GESTOR_RESOLUCION_EN_RECOVERY where GESTOR_RESOLUCION_EN_RECOVERY_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_GESTOR_RESOLUCION_EN_RECOVERY (GESTOR_RESOLUCION_EN_RECOVERY_ID, GESTOR_RESOLUCION_EN_RECOVERY_DESC) values (0 ,'No Usa Recovery');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_GESTOR_RESOLUCION_EN_RECOVERY where GESTOR_RESOLUCION_EN_RECOVERY_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_GESTOR_RESOLUCION_EN_RECOVERY (GESTOR_RESOLUCION_EN_RECOVERY_ID, GESTOR_RESOLUCION_EN_RECOVERY_DESC) values (1 ,'Usa Recovery');
end if;


-- ----------------------------------------------------------------------------------------------
--                           DIM_PROCEDIMIENTO_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_SUPERVISOR where SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_SUPERVISOR(
    SUPERVISOR_PROCEDIMIENTO_ID,
    SUPERVISOR_PROCEDIMIENTO_NOMBRE_COMPLETO,
    SUPERVISOR_PROCEDIMIENTO_NOMBRE,
    SUPERVISOR_PROCEDIMIENTO_APELLIDO1,
    SUPERVISOR_PROCEDIMIENTO_APELLIDO2,
    ENTIDAD_SUPERVISOR_PROCEDIMIENTO_ID, 
    DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID) values (-1 ,'Sin Supervisor Asignado', 'Sin Supervisor Asignado', 'Sin Supervisor Asignado', 'Sin Supervisor Asignado', -1, -1);
end if;

insert into DIM_PROCEDIMIENTO_SUPERVISOR (
    SUPERVISOR_PROCEDIMIENTO_ID,
    SUPERVISOR_PROCEDIMIENTO_NOMBRE_COMPLETO,
    SUPERVISOR_PROCEDIMIENTO_NOMBRE,
    SUPERVISOR_PROCEDIMIENTO_APELLIDO1,
    SUPERVISOR_PROCEDIMIENTO_APELLIDO2,
    ENTIDAD_SUPERVISOR_PROCEDIMIENTO_ID, 
    DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID)
select usu.USU_ID,
    coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), ' ', 'Desconocido'),
    coalesce(usu.USU_NOMBRE, 'Desconocido'),
    coalesce(usu.USU_APELLIDO1, 'Desconocido'),
    coalesce(usu.USU_APELLIDO2, 'Desconocido'),
    usu.ENTIDAD_ID,
    coalesce(usd.DES_ID, -1)
    from recovery_lindorff_datastage.USU_USUARIOS usu
    left join recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd on usd.USU_ID = usu.USU_ID        
join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
where tges.DD_TGE_DESCRIPCION = 'Supervisor' group by usu.USU_ID;

-- ----------------------------------------------------------------------------------------------
--          DIM_PROCEDIMIENTO_DESPACHO_GESTOR / DIM_PROCEDIMIENTO_DESPACHO_SUPERVISOR / DIM_PROCEDIMIENTO_DESPACHO_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_DESPACHO_GESTOR where DESPACHO_GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_DESPACHO_GESTOR (DESPACHO_GESTOR_PROCEDIMIENTO_ID, DESPACHO_GESTOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_PROCEDIMIENTO_DESPACHO_GESTOR(DESPACHO_GESTOR_PROCEDIMIENTO_ID, DESPACHO_GESTOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_ID)
    select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1) FROM recovery_lindorff_datastage.DES_DESPACHO_EXTERNO;

if ((select count(*) from DIM_PROCEDIMIENTO_DESPACHO_SUPERVISOR where DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_DESPACHO_SUPERVISOR (DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_PROCEDIMIENTO_DESPACHO_SUPERVISOR(DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID)
    select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1) FROM recovery_lindorff_datastage.DES_DESPACHO_EXTERNO;

if ((select count(*) from DIM_PROCEDIMIENTO_DESPACHO_GESTOR_RESOLUCION where DESPACHO_GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_DESPACHO_GESTOR_RESOLUCION (DESPACHO_GESTOR_RESOLUCION_ID, DESPACHO_GESTOR_RESOLUCION_DESC, TIPO_DESPACHO_GESTOR_RESOLUCION_ID, ZONA_DESPACHO_GESTOR_RESOLUCION_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_PROCEDIMIENTO_DESPACHO_GESTOR_RESOLUCION(DESPACHO_GESTOR_RESOLUCION_ID, DESPACHO_GESTOR_RESOLUCION_DESC, TIPO_DESPACHO_GESTOR_RESOLUCION_ID, ZONA_DESPACHO_GESTOR_RESOLUCION_ID)
    select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1) FROM recovery_lindorff_datastage.DES_DESPACHO_EXTERNO;
    
-- ----------------------------------------------------------------------------------------------
--      DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR / DIM_PROCEDIMIENTO_TIPO_DESPACHO_SUPERVISOR / DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR where TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR (TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_ID, TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR(TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_ID, TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDE_TIPO_DESPACHO;
    
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_DESPACHO_SUPERVISOR where TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_DESPACHO_SUPERVISOR (TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_TIPO_DESPACHO_SUPERVISOR(TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, TIPO_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDE_TIPO_DESPACHO;
    
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR_RESOLUCION where TIPO_DESPACHO_GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR_RESOLUCION (TIPO_DESPACHO_GESTOR_RESOLUCION_ID, TIPO_DESPACHO_GESTOR_RESOLUCION_DESC, TIPO_DESPACHO_GESTOR_RESOLUCION_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_TIPO_DESPACHO_GESTOR_RESOLUCION(TIPO_DESPACHO_GESTOR_RESOLUCION_ID, TIPO_DESPACHO_GESTOR_RESOLUCION_DESC, TIPO_DESPACHO_GESTOR_RESOLUCION_DESC_ALT)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDE_TIPO_DESPACHO;
    

-- ----------------------------------------------------------------------------------------------
--     DIM_PROCEDIMIENTO_ENTIDAD_GESTOR / DIM_PROCEDIMIENTO_ENTIDAD_SUPERVISOR / DIM_PROCEDIMIENTO_ENTIDAD_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ENTIDAD_GESTOR where ENTIDAD_GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ENTIDAD_GESTOR (ENTIDAD_GESTOR_PROCEDIMIENTO_ID, ENTIDAD_GESTOR_PROCEDIMIENTO_DESC) values (-1, 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ENTIDAD_GESTOR(ENTIDAD_GESTOR_PROCEDIMIENTO_ID, ENTIDAD_GESTOR_PROCEDIMIENTO_DESC)
    select ID, DESCRIPCION FROM recovery_lindorff_datastage.ENTIDAD;   
    
if ((select count(*) from DIM_PROCEDIMIENTO_ENTIDAD_SUPERVISOR where ENTIDAD_SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ENTIDAD_SUPERVISOR (ENTIDAD_SUPERVISOR_PROCEDIMIENTO_ID, ENTIDAD_SUPERVISOR_PROCEDIMIENTO_DESC) values (-1, 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ENTIDAD_SUPERVISOR(ENTIDAD_SUPERVISOR_PROCEDIMIENTO_ID, ENTIDAD_SUPERVISOR_PROCEDIMIENTO_DESC)
    select ID, DESCRIPCION FROM recovery_lindorff_datastage.ENTIDAD;      
    
if ((select count(*) from DIM_PROCEDIMIENTO_ENTIDAD_GESTOR_RESOLUCION where ENTIDAD_GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ENTIDAD_GESTOR_RESOLUCION (ENTIDAD_GESTOR_RESOLUCION_ID, ENTIDAD_GESTOR_RESOLUCION_DESC) values (-1, 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_ENTIDAD_GESTOR_RESOLUCION(ENTIDAD_GESTOR_RESOLUCION_ID, ENTIDAD_GESTOR_RESOLUCION_DESC)
    select ID, DESCRIPCION FROM recovery_lindorff_datastage.ENTIDAD;      
    
    
-- ----------------------------------------------------------------------------------------------
--    DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR / DIM_PROCEDIMIENTO_NIVEL_DESPACHO_SUPERVISOR / DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR where NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR (NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_ID, NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR(NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_ID, NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;
    
if ((select count(*) from DIM_PROCEDIMIENTO_NIVEL_DESPACHO_SUPERVISOR where NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_NIVEL_DESPACHO_SUPERVISOR (NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_NIVEL_DESPACHO_SUPERVISOR(NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;

    
if ((select count(*) from DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR_RESOLUCION where NIVEL_DESPACHO_GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR_RESOLUCION (NIVEL_DESPACHO_GESTOR_RESOLUCION_ID, NIVEL_DESPACHO_GESTOR_RESOLUCION_DESC, NIVEL_DESPACHO_GESTOR_RESOLUCION_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_NIVEL_DESPACHO_GESTOR_RESOLUCION(NIVEL_DESPACHO_GESTOR_RESOLUCION_ID, NIVEL_DESPACHO_GESTOR_RESOLUCION_DESC, NIVEL_DESPACHO_GESTOR_RESOLUCION_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;

-- ----------------------------------------------------------------------------------------------
--   DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR / DIM_PROCEDIMIENTO_OFICINA_DESPACHO_SUPERVISOR / DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR where OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR (OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT, PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR(OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;

if ((select count(*) from DIM_PROCEDIMIENTO_OFICINA_DESPACHO_SUPERVISOR where OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_OFICINA_DESPACHO_SUPERVISOR (OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT, PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_OFICINA_DESPACHO_SUPERVISOR(OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;

if ((select count(*) from DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR_RESOLUCION where OFICINA_DESPACHO_GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR_RESOLUCION (OFICINA_DESPACHO_GESTOR_RESOLUCION_ID, OFICINA_DESPACHO_GESTOR_RESOLUCION_DESC, OFICINA_DESPACHO_GESTOR_RESOLUCION_DESC_ALT, PROVINCIA_DESPACHO_GESTOR_RESOLUCION_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_PROCEDIMIENTO_OFICINA_DESPACHO_GESTOR_RESOLUCION(OFICINA_DESPACHO_GESTOR_RESOLUCION_ID, OFICINA_DESPACHO_GESTOR_RESOLUCION_DESC, PROVINCIA_DESPACHO_GESTOR_RESOLUCION_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;
    
    
-- ----------------------------------------------------------------------------------------------
--  DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR / DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_SUPERVISOR / DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------    
if ((select count(*) from DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR where PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR (PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_ID, PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR(PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_ID, PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, PROVINCIA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;

if ((select count(*) from DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_SUPERVISOR where PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_SUPERVISOR (PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_SUPERVISOR(PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, PROVINCIA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;
    
if ((select count(*) from DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR_RESOLUCION where PROVINCIA_DESPACHO_GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR_RESOLUCION (PROVINCIA_DESPACHO_GESTOR_RESOLUCION_ID, PROVINCIA_DESPACHO_GESTOR_RESOLUCION_DESC, PROVINCIA_DESPACHO_GESTOR_RESOLUCION_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_PROCEDIMIENTO_PROVINCIA_DESPACHO_GESTOR_RESOLUCION(PROVINCIA_DESPACHO_GESTOR_RESOLUCION_ID, PROVINCIA_DESPACHO_GESTOR_RESOLUCION_DESC, PROVINCIA_DESPACHO_GESTOR_RESOLUCION_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;
    
    
-- ----------------------------------------------------------------------------------------------
--     DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR / DIM_PROCEDIMIENTO_ZONA_DESPACHO_SUPERVISOR / DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR_RESOLUCION
-- ----------------------------------------------------------------------------------------------  
if ((select count(*) from DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR where ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR (ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT, NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR(ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC, ZONA_DESPACHO_GESTOR_PROCEDIMIENTO_DESC_ALT, NIVEL_DESPACHO_GESTOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_GESTOR_PROCEDIMIENTO_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM recovery_lindorff_datastage.ZON_ZONIFICACION;

if ((select count(*) from DIM_PROCEDIMIENTO_ZONA_DESPACHO_SUPERVISOR where ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ZONA_DESPACHO_SUPERVISOR (ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT, NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_PROCEDIMIENTO_ZONA_DESPACHO_SUPERVISOR(ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC, ZONA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_DESC_ALT, NIVEL_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID, OFICINA_DESPACHO_SUPERVISOR_PROCEDIMIENTO_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM recovery_lindorff_datastage.ZON_ZONIFICACION;

if ((select count(*) from DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR_RESOLUCION where ZONA_DESPACHO_GESTOR_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR_RESOLUCION (ZONA_DESPACHO_GESTOR_RESOLUCION_ID, ZONA_DESPACHO_GESTOR_RESOLUCION_DESC, ZONA_DESPACHO_GESTOR_RESOLUCION_DESC_ALT, NIVEL_DESPACHO_GESTOR_RESOLUCION_ID, OFICINA_DESPACHO_GESTOR_RESOLUCION_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_PROCEDIMIENTO_ZONA_DESPACHO_GESTOR_RESOLUCION(ZONA_DESPACHO_GESTOR_RESOLUCION_ID, ZONA_DESPACHO_GESTOR_RESOLUCION_DESC, ZONA_DESPACHO_GESTOR_RESOLUCION_DESC_ALT, NIVEL_DESPACHO_GESTOR_RESOLUCION_ID, OFICINA_DESPACHO_GESTOR_RESOLUCION_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM recovery_lindorff_datastage.ZON_ZONIFICACION;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL where TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL (TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID, TRAMO_SALDO_TOTAL_PROCEDIMIENTO_DESC) values (-1 ,'Saldo Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL where TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL (TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID, TRAMO_SALDO_TOTAL_PROCEDIMIENTO_DESC) values (0,'< 1MM €');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL where TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL (TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID, TRAMO_SALDO_TOTAL_PROCEDIMIENTO_DESC) values (1 ,'>= 1 MM €');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO where TRAMO_SALDO_TOTAL_CONCURSO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO (TRAMO_SALDO_TOTAL_CONCURSO_ID, TRAMO_SALDO_TOTAL_CONCURSO_DESC) values (-2 ,'Concursado Sin Riesgo Directo');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO where TRAMO_SALDO_TOTAL_CONCURSO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO (TRAMO_SALDO_TOTAL_CONCURSO_ID, TRAMO_SALDO_TOTAL_CONCURSO_DESC) values (-1 ,'Saldo Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO where TRAMO_SALDO_TOTAL_CONCURSO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO (TRAMO_SALDO_TOTAL_CONCURSO_ID, TRAMO_SALDO_TOTAL_CONCURSO_DESC) values (0,'< 1MM €');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO where TRAMO_SALDO_TOTAL_CONCURSO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_SALDO_TOTAL_CONCURSO (TRAMO_SALDO_TOTAL_CONCURSO_ID, TRAMO_SALDO_TOTAL_CONCURSO_DESC) values (1 ,'>= 1 MM €');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION where TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION (TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID, TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION where TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION (TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID, TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_DESC) values (0 ,'<= 30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION where TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION (TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID, TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_DESC) values (1,'31 - 60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION where TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION (TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID, TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_DESC) values (2 ,'61 - 90 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION where TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ULTIMA_ACTUALIZACION (TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID, TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_DESC) values (3 ,'> 90 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO where TRAMO_DIAS_CONTRATO_VENCIDO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO (TRAMO_DIAS_CONTRATO_VENCIDO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_DESC) values (-2 ,'Ningún Contrato Asociado Vencido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO where TRAMO_DIAS_CONTRATO_VENCIDO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO (TRAMO_DIAS_CONTRATO_VENCIDO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO where TRAMO_DIAS_CONTRATO_VENCIDO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO (TRAMO_DIAS_CONTRATO_VENCIDO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_DESC) values (0 ,'<= 30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO where TRAMO_DIAS_CONTRATO_VENCIDO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO (TRAMO_DIAS_CONTRATO_VENCIDO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_DESC) values (1,'31 - 60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO where TRAMO_DIAS_CONTRATO_VENCIDO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO (TRAMO_DIAS_CONTRATO_VENCIDO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_DESC) values (2 ,'61 - 90 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO where TRAMO_DIAS_CONTRATO_VENCIDO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO (TRAMO_DIAS_CONTRATO_VENCIDO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_DESC) values (3 ,'> 90 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (-2 ,'Ningún Contrato Asociado Vencido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (0 ,'0- 30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (5,'151-180 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO where TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = 6) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CONTRATO_VENCIDO_CREACION_ASUNTO (TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID, TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_DESC) values (6,'>180 Días');
end if;



-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID, CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_DESC) values (-2, 'Ninguna Tarea Pendiente Asocidada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID, CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_DESC) values (-1, 'Última Tarea Pendiente Sin Fecha de Vencimiento');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID, CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_DESC) values (0, 'En Plazo');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID, CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_DESC) values (1, 'Fuera De Plazo');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID, CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_DESC) values (-2, 'Ninguna Tarea Finalizada Asocidada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID, CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_DESC) values (-1, 'Última Tarea Finalizada Sin Fecha de Vencimiento');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID, CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_DESC) values (0, 'En Plazo');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO where CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_CUMPLIMIENTO (CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID, CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_DESC) values (1, 'Fuera De Plazo');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS where TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS (TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID, TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS where TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS (TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID, TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_DESC) values (0 ,'<= 365 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS where TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS (TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID, TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_DESC) values (1,'> 365 Días');
end if;



-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION where TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION (TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID, TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION where TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION (TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID, TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_DESC) values (0 ,'<= 365 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION where TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION (TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID, TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_DESC) values (1,'> 365 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (0 ,'0-10 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (1,'11-20 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (2,'21-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (3,'> 30 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION where TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION (TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID, TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION where TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION (TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID, TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION where TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION (TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID, TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION where TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION (TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID, TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION where TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION (TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID, TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT where TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT (TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID, TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT where TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT (TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID, TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT where TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT (TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID, TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT where TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT (TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID, TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT where TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_CREACION_ASUNTO_A_RECOG_DOC_Y_ACEPT (TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID, TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGIS_TD (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC where TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEP_DC (TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID, TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_DESC) values (3,'> 20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (0 ,'0-5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (1,'6-10 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (2,'11-20 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA where TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERP_DEMANDA (TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID, TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_DESC) values (3,'>20 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME where TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME (TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME where TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME (TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME where TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME (TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME where TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME (TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME where TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME (TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME where TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME (TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME where TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_DECL_A_RESOL_FIRME (TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_DESC) values (5,'> 150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_ORD_A_INICIO_APREMIO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_DESC) values (5,'> 150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA where TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA (TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA where TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA (TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_DESC) values (0 ,'0-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA where TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA (TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA where TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA (TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA where TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA (TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA where TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA (TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA where TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_HIP_A_SUBASTA (TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_DESC) values (5,'> 150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (0 ,'Pendiente Interposición');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (1,'Demanda Presentada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (2,'Subasta Solicitada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (3,'Subasta Señalada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (4,'Subasta Celebrada: Pendiente Cesión de Remate');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (5,'Subasta Celebrada: Con Cesión de Remate');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 6) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (6,'Subasta Celebrada: Pendiente Adjudicación');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 7) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (7,'Subasta Celebrada: Pendiente Posesión');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 8) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (8,'Subasta Celebrada: Posesión Realizada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO where FASE_SUBASTA_HIPOTECARIO_ID = 9) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_HIPOTECARIO (FASE_SUBASTA_HIPOTECARIO_ID, FASE_SUBASTA_HIPOTECARIO_DESC) values (9,'Otros');
end if;

-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_DESC) values (0 ,'0- 30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_DESC) values (1,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_DESC) values (2,'61-90 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_DESC) values (3,'91-120 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_DESC) values (4,'121-150 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_DECRETO_FIN (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_DESC) values (5,'>150 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_DESC) values (0 ,'0- 5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_DESC) values (1,'6-15 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_DESC) values (2,'16-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_DESC) values (3,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA where TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERP_DEMANDA_MON_A_ADMI_DEMANDA (TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_DESC) values (4,'>60 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO where TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO (TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID, TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO where TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO (TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID, TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_DESC) values (0 ,'0- 5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO where TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO (TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID, TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_DESC) values (1,'6-15 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO where TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO (TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID, TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_DESC) values (2,'16-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO where TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO (TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID, TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_DESC) values (3,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO where TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_ADMI_DEMANDA_MON_A_REQUERIMIENTO (TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID, TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_DESC) values (4,'>60 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN where TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN (TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID, TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN where TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN (TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID, TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_DESC) values (0 ,'0- 5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN where TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN (TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID, TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_DESC) values (1,'6-15 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN where TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN (TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID, TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_DESC) values (2,'16-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN where TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN (TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID, TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_DESC) values (3,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN where TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FIN (TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID, TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_DESC) values (4,'>60 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_DESC) values (0 ,'0- 5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_DESC) values (1,'6-15 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_DESC) values (2,'16-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_DESC) values (3,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO where TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO (TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID, TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_DESC) values (4,'>60 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION where TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION (TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID, TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION where TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION (TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID, TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_DESC) values (0 ,'0- 5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION where TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION (TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID, TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_DESC) values (1,'6-15 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION where TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION (TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID, TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_DESC) values (2,'16-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION where TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION (TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID, TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_DESC) values (3,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION where TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION (TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID, TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_DESC) values (4,'>60 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO where TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO (TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID, TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_DESC) values (-1 ,'Número Días Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO where TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO (TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID, TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_DESC) values (0 ,'0- 5 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO where TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO (TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID, TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_DESC) values (1,'6-15 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO where TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO (TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID, TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_DESC) values (2,'16-30 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO where TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO (TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID, TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_DESC) values (3,'31-60 Días');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO where TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO (TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID, TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_DESC) values (4,'>60 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (0 ,'Demanda Presentada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (1,'Subasta Solicitada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (2,'Subasta Señalada');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (3,'Subasta Celebrada: Pendiente Cesión de remate');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (4,'Subasta Celebrada: Con Cesión de Remate');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (5,'Subasta Celebrada: Pendiente Adjudicación');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL where FASE_SUBASTA_EJECUCION_NOTARIAL_ID = 6) = 0) then
	insert into DIM_PROCEDIMIENTO_FASE_SUBASTA_EJECUCION_NOTARIAL (FASE_SUBASTA_EJECUCION_NOTARIAL_ID, FASE_SUBASTA_EJECUCION_NOTARIAL_DESC) values (6,'Otros');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO where CONTRATO_GARANTIA_REAL_ASOCIADO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO (CONTRATO_GARANTIA_REAL_ASOCIADO_ID, CONTRATO_GARANTIA_REAL_ASOCIADO_DESC) values (-1, 'Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO where CONTRATO_GARANTIA_REAL_ASOCIADO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO (CONTRATO_GARANTIA_REAL_ASOCIADO_ID, CONTRATO_GARANTIA_REAL_ASOCIADO_DESC) values (0, 'Contrato Garantía Real No Asociado');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO where CONTRATO_GARANTIA_REAL_ASOCIADO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_CONTRATO_GARANTIA_REAL_ASOCIADO (CONTRATO_GARANTIA_REAL_ASOCIADO_ID, CONTRATO_GARANTIA_REAL_ASOCIADO_DESC) values (1, 'Contrato Garantía Real Asociado');
end if;


-- ----------------------------------------------------------------------------------------------
--                                 DIM_PROCEDIMIENTO_COBRO_TIPO_DETALLE 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_COBRO_TIPO_DETALLE where TIPO_COBRO_DETALLE_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_COBRO_TIPO_DETALLE (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID) values (-1 ,'Desconocido', -1);
end if;

insert into DIM_PROCEDIMIENTO_COBRO_TIPO_DETALLE (TIPO_COBRO_DETALLE_ID, TIPO_COBRO_DETALLE_DESC, TIPO_COBRO_ID)
	select DD_SCP_ID, DD_SCP_DESCRIPCION, DD_TCP_ID from recovery_lindorff_datastage.DD_SCP_SUBTIPO_COBRO_PAGO;


-- ----------------------------------------------------------------------------------------------
--                                 DIM_PROCEDIMIENTO_COBRO_TIPO - DD_TCP_TIPO_COBRO_PAGO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_COBRO_TIPO where TIPO_COBRO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_COBRO_TIPO (TIPO_COBRO_ID, TIPO_COBRO_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_COBRO_TIPO (TIPO_COBRO_ID, TIPO_COBRO_DESC)
    select DD_TCP_ID, DD_TCP_DESCRIPCION from recovery_lindorff_datastage.DD_TCP_TIPO_COBRO_PAGO;

-- ----------------------------------------------------------------------------------------------
-- 								                	DIM_PROCEDIMIENTO_CON_COBRO 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_CON_COBRO where PROCEDIMIENTO_CON_COBRO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_COBRO (PROCEDIMIENTO_CON_COBRO_ID, PROCEDIMIENTO_CON_COBRO_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_CON_COBRO where PROCEDIMIENTO_CON_COBRO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_COBRO (PROCEDIMIENTO_CON_COBRO_ID, PROCEDIMIENTO_CON_COBRO_DESC) values (0 ,'Sin Cobro');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_CON_COBRO where PROCEDIMIENTO_CON_COBRO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_COBRO (PROCEDIMIENTO_CON_COBRO_ID, PROCEDIMIENTO_CON_COBRO_DESC) values (1, 'Con Cobro');
end if;

-- ----------------------------------------------------------------------------------------------
--                                 DIM_PROCEDIMIENTO_TIPO_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_RESOLUCION where TIPO_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_RESOLUCION (TIPO_RESOLUCION_ID, TIPO_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_TIPO_RESOLUCION (TIPO_RESOLUCION_ID, TIPO_RESOLUCION_DESC)
	select BPM_DD_TIN_ID, BPM_DD_TIN_DESCRIPCION from recovery_lindorff_datastage.BPM_DD_TIN_TIPO_INPUT;


-- ----------------------------------------------------------------------------------------------
--                                 DIM_PROCEDIMIENTO_TIPO_ULTIMA_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_ULTIMA_RESOLUCION where TIPO_ULTIMA_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_ULTIMA_RESOLUCION (TIPO_ULTIMA_RESOLUCION_ID, TIPO_ULTIMA_RESOLUCION_DESC) values (-2 ,'Sin Resolución');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_ULTIMA_RESOLUCION where TIPO_ULTIMA_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_ULTIMA_RESOLUCION (TIPO_ULTIMA_RESOLUCION_ID, TIPO_ULTIMA_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_TIPO_ULTIMA_RESOLUCION (TIPO_ULTIMA_RESOLUCION_ID, TIPO_ULTIMA_RESOLUCION_DESC)
	select BPM_DD_TIN_ID, BPM_DD_TIN_DESCRIPCION from recovery_lindorff_datastage.BPM_DD_TIN_TIPO_INPUT;


-- ----------------------------------------------------------------------------------------------
--                                 DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES where ACTUALIZACION_ESTIMACIONES_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES (ACTUALIZACION_ESTIMACIONES_ID, ACTUALIZACION_ESTIMACIONES_DESC) values (-1 ,'Desconocido');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES where ACTUALIZACION_ESTIMACIONES_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES (ACTUALIZACION_ESTIMACIONES_ID, ACTUALIZACION_ESTIMACIONES_DESC) values (0 ,'No Actualizada En Último Semestre');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES where ACTUALIZACION_ESTIMACIONES_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_ACTUALIZACION_ESTIMACIONES (ACTUALIZACION_ESTIMACIONES_ID, ACTUALIZACION_ESTIMACIONES_DESC) values (1, 'Actualizada En Último Semestre');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PROCEDIMIENTO_CARTERA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_CARTERA where CARTERA_PROCEDIMIENTO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_CARTERA (CARTERA_PROCEDIMIENTO_ID, CARTERA_PROCEDIMIENTO_DESC, TIPO_CARTERA_PROCEDIMIENTO_ID) values (-2 ,'Compartida', 'Compartida');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CARTERA where CARTERA_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_CARTERA (CARTERA_PROCEDIMIENTO_ID, CARTERA_PROCEDIMIENTO_DESC, TIPO_CARTERA_PROCEDIMIENTO_ID) values (-1 ,'Desconocido', 'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_CARTERA (CARTERA_PROCEDIMIENTO_ID, CARTERA_PROCEDIMIENTO_DESC, TIPO_CARTERA_PROCEDIMIENTO_ID)
    select CAR_ID, CAR_DESCRIPCION, TIPO_CARTERA_ID from recovery_lindorff_datastage.CAR_CARTERA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PROCEDIMIENTO_TIPO_CARTERA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_CARTERA where TIPO_CARTERA_PROCEDIMIENTO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_CARTERA (TIPO_CARTERA_PROCEDIMIENTO_ID, TIPO_CARTERA_PROCEDIMIENTO_DESC) values (-2 ,'Compartida');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TIPO_CARTERA where TIPO_CARTERA_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TIPO_CARTERA (TIPO_CARTERA_PROCEDIMIENTO_ID, TIPO_CARTERA_PROCEDIMIENTO_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_TIPO_CARTERA (TIPO_CARTERA_PROCEDIMIENTO_ID, TIPO_CARTERA_PROCEDIMIENTO_DESC)
    select TIPO_CARTERA_ID, TIPO_CARTERA_DESCRIPCION from recovery_lindorff_datastage.DD_TCA_TIPO_CARTERA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PROCEDIMIENTO_CEDENTE_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_CEDENTE_CONTRATO where CEDENTE_CONTRATO_PROCEDIMIENTO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_CEDENTE_CONTRATO (CEDENTE_CONTRATO_PROCEDIMIENTO_ID, CEDENTE_CONTRATO_PROCEDIMIENTO_DESC) values (-2 ,'Compartido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CEDENTE_CONTRATO where CEDENTE_CONTRATO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_CEDENTE_CONTRATO (CEDENTE_CONTRATO_PROCEDIMIENTO_ID, CEDENTE_CONTRATO_PROCEDIMIENTO_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_CEDENTE_CONTRATO (CEDENTE_CONTRATO_PROCEDIMIENTO_ID, CEDENTE_CONTRATO_PROCEDIMIENTO_DESC)
    select DD_ENC_ID, DD_ENC_DESCRIPCION FROM recovery_lindorff_datastage.DD_ENC_ENTIDADES_CEDENTES;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PROCEDIMIENTO_PROPIETARIO_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_PROPIETARIO_CONTRATO where PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_PROPIETARIO_CONTRATO (PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID, PROPIETARIO_CONTRATO_PROCEDIMIENTO_DESC) values (-2 ,'Compartido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROPIETARIO_CONTRATO where PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_PROPIETARIO_CONTRATO (PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID, PROPIETARIO_CONTRATO_PROCEDIMIENTO_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_PROPIETARIO_CONTRATO (PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID, PROPIETARIO_CONTRATO_PROCEDIMIENTO_DESC)
    select DD_ENP_ID, DD_ENP_DESCRIPCION FROM recovery_lindorff_datastage.DD_ENP_ENTIDADES_PROPIETARIAS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO where SEGMENTO_CONTRATO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO (SEGMENTO_CONTRATO_PROCEDIMIENTO_ID, SEGMENTO_CONTRATO_PROCEDIMIENTO_DESC) values (-1 ,'Desconocido');
end if;


set l_last_row = 0; 

open c_segmento_desc;
segmento_desc_loop: loop
fetch c_segmento_desc into segmento_desc;        
    if (l_last_row=1) then leave segmento_desc_loop; 
    end if;

    set max_id = (select max(SEGMENTO_CONTRATO_PROCEDIMIENTO_ID) from DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO) + 1;
    insert into DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO (SEGMENTO_CONTRATO_PROCEDIMIENTO_ID, SEGMENTO_CONTRATO_PROCEDIMIENTO_DESC)
    values (max_id, segmento_desc);

end loop;
close c_segmento_desc;



-- ----------------------------------------------------------------------------------------------
--                                      DIM_PROCEDIMIENTO_SOCIO_CONTRATO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_SOCIO_CONTRATO where SOCIO_CONTRATO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_SOCIO_CONTRATO (SOCIO_CONTRATO_PROCEDIMIENTO_ID, SOCIO_CONTRATO_PROCEDIMIENTO_DESC) values (-1 ,'Desconocido');
end if;

set l_last_row = 0; 

open c_socio_desc;
socio_desc_loop: loop
fetch c_socio_desc into socio_desc;        
    if (l_last_row=1) then leave socio_desc_loop; 
    end if;

set max_id = (select max(SOCIO_CONTRATO_PROCEDIMIENTO_ID) from DIM_PROCEDIMIENTO_SOCIO_CONTRATO) + 1;
insert into DIM_PROCEDIMIENTO_SOCIO_CONTRATO (SOCIO_CONTRATO_PROCEDIMIENTO_ID, SOCIO_CONTRATO_PROCEDIMIENTO_DESC)
values (max_id, socio_desc);

end loop;
close c_socio_desc;
    -- DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO
    -- 
-- ----------------------------------------------------------------------------------------------
--                                      DIM_PROCEDIMIENTO_TITULAR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TITULAR where TITULAR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TITULAR (TITULAR_PROCEDIMIENTO_ID, TITULAR_PROCEDIMIENTO_DESC, DOCUMENTO_ID, NOMBRE, APELLIDO_1, APELLIDO_2) values (-1 , -1, 'Desconocido', 'Desconocido', 'Desconocido', 'Desconocido');
end if;

-- Insert del primer titular del contrato de pase
insert into DIM_PROCEDIMIENTO_TITULAR (TITULAR_PROCEDIMIENTO_ID, TITULAR_PROCEDIMIENTO_DESC, DOCUMENTO_ID, NOMBRE, APELLIDO_1, APELLIDO_2)
select p.PER_ID, 
       PER_COD_CLIENTE_ENTIDAD, 
       coalesce(PER_DOC_ID, 'Desconocido'), 
       coalesce(PER_NOMBRE, 'Desconocido'), 
       coalesce(PER_APELLIDO1, 'Desconocido'), 
       coalesce(PER_APELLIDO2, 'Desconocido')
from recovery_lindorff_datastage.PER_PERSONAS p
join recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS cpe on p.PER_ID = cpe.PER_ID
join recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex on cpe.CNT_ID = cex.CNT_ID
where DD_TIN_ID = 1 and CPE_ORDEN = 1 and cex.CEX_PASE = 1
group by p.PER_ID;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_CON_PROCURADOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_CON_PROCURADOR where PROCEDIMIENTO_CON_PROCURADOR_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_PROCURADOR (PROCEDIMIENTO_CON_PROCURADOR_ID, PROCEDIMIENTO_CON_PROCURADOR_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CON_PROCURADOR where PROCEDIMIENTO_CON_PROCURADOR_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_PROCURADOR (PROCEDIMIENTO_CON_PROCURADOR_ID, PROCEDIMIENTO_CON_PROCURADOR_DESC) values (0,'Sin Procurador');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CON_PROCURADOR where PROCEDIMIENTO_CON_PROCURADOR_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_PROCURADOR (PROCEDIMIENTO_CON_PROCURADOR_ID, PROCEDIMIENTO_CON_PROCURADOR_DESC) values (1 ,'Con Procurador');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_PROCURADOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR where PROCURADOR_PROCEDIMIENTO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_PROCURADOR(
    PROCURADOR_PROCEDIMIENTO_ID,
    PROCURADOR_PROCEDIMIENTO_NOMBRE_COMPLETO,
    PROCURADOR_PROCEDIMIENTO_NOMBRE,
    PROCURADOR_PROCEDIMIENTO_APELLIDO1,
    PROCURADOR_PROCEDIMIENTO_APELLIDO2) 
    values (-1 ,'Sin Procurador Asignado','Sin Procurador Asignado', 'Sin Procurador Asignado', 'Sin Procurador Asignado');
end if;

insert into DIM_PROCEDIMIENTO_PROCURADOR (
    PROCURADOR_PROCEDIMIENTO_ID,
    PROCURADOR_PROCEDIMIENTO_NOMBRE_COMPLETO,
    PROCURADOR_PROCEDIMIENTO_NOMBRE,
    PROCURADOR_PROCEDIMIENTO_APELLIDO1,
    PROCURADOR_PROCEDIMIENTO_APELLIDO2
    )
select usu.USU_ID,
    coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), 'Desconocido'),
    coalesce(usu.USU_NOMBRE, 'Desconocido'),
    coalesce(usu.USU_APELLIDO1, 'Desconocido'),
    coalesce(usu.USU_APELLIDO2, 'Desconocido')
    from recovery_lindorff_datastage.USU_USUARIOS usu
    left join recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd on usd.USU_ID = usu.USU_ID        
    join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
    join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
    where tges.DD_TGE_DESCRIPCION = 'Procurador' group by usu.USU_ID;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_CON_RESOLUCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_CON_RESOLUCION where PROCEDIMIENTO_CON_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_RESOLUCION (PROCEDIMIENTO_CON_RESOLUCION_ID, PROCEDIMIENTO_CON_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CON_RESOLUCION where PROCEDIMIENTO_CON_RESOLUCION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_RESOLUCION (PROCEDIMIENTO_CON_RESOLUCION_ID, PROCEDIMIENTO_CON_RESOLUCION_DESC) values (0,'Sin Resolución');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CON_RESOLUCION where PROCEDIMIENTO_CON_RESOLUCION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_RESOLUCION (PROCEDIMIENTO_CON_RESOLUCION_ID, PROCEDIMIENTO_CON_RESOLUCION_DESC) values (1 ,'Con Resolución');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_CON_IMPULSO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_CON_IMPULSO where PROCEDIMIENTO_CON_IMPULSO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_IMPULSO (PROCEDIMIENTO_CON_IMPULSO_ID, PROCEDIMIENTO_CON_IMPULSO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CON_IMPULSO where PROCEDIMIENTO_CON_IMPULSO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_IMPULSO (PROCEDIMIENTO_CON_IMPULSO_ID, PROCEDIMIENTO_CON_IMPULSO_DESC) values (0,'Sin Impulso');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_CON_IMPULSO where PROCEDIMIENTO_CON_IMPULSO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_CON_IMPULSO (PROCEDIMIENTO_CON_IMPULSO_ID, PROCEDIMIENTO_CON_IMPULSO_DESC) values (1 ,'Con Impulso');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO where RESULTADO_ULTIMO_IMPULSO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO (RESULTADO_ULTIMO_IMPULSO_ID, RESULTADO_ULTIMO_IMPULSO_DESC) values (-2 ,'Sin Impulso');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO where RESULTADO_ULTIMO_IMPULSO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO (RESULTADO_ULTIMO_IMPULSO_ID, RESULTADO_ULTIMO_IMPULSO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO where RESULTADO_ULTIMO_IMPULSO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO (RESULTADO_ULTIMO_IMPULSO_ID, RESULTADO_ULTIMO_IMPULSO_DESC) values (0,'Negativo');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO where RESULTADO_ULTIMO_IMPULSO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_RESULTADO_ULTIMO_IMPULSO (RESULTADO_ULTIMO_IMPULSO_ID, RESULTADO_ULTIMO_IMPULSO_DESC) values (1 ,'Positivo');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (-2 ,'Sin Resolución');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (0,'0-59 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (1 ,'60-89 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (2 ,'90-119 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (3 ,'120-149 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (4 ,'150-269 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION where TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION (TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID, TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_DESC) values (5 ,'>=270 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (-2 ,'Sin Impulso');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = 0) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (0,'0-59 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = 1) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (1 ,'60-89 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = 2) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (2 ,'90-119 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = 3) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (3 ,'120-149 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = 4) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (4 ,'150-269 Días');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO where TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = 5) = 0) then
	insert into DIM_PROCEDIMIENTO_TRAMO_DIAS_DESDE_ULTIMO_IMPULSO (TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID, TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_DESC) values (5 ,'>=270 Días');
end if;


-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION where MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID = -3) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION (MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID, MOTIVO_INADMISION_ULTIMA_RESOLUCION_DESC) values (-3 ,'');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION where MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION (MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID, MOTIVO_INADMISION_ULTIMA_RESOLUCION_DESC) values (-2 ,'No Informado');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION where MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION (MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID, MOTIVO_INADMISION_ULTIMA_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_ULTIMA_RESOLUCION (MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID, MOTIVO_INADMISION_ULTIMA_RESOLUCION_DESC)
	select DD_MIN_ID, DD_MIN_DESCRIPCION from recovery_lindorff_datastage.DD_MIN_MOTIVOS_INADMISION;


-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION where MOTIVO_INADMISION_RESOLUCION_ID = -3) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION (MOTIVO_INADMISION_RESOLUCION_ID, MOTIVO_INADMISION_RESOLUCION_DESC) values (-3 ,'');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION where MOTIVO_INADMISION_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION (MOTIVO_INADMISION_RESOLUCION_ID, MOTIVO_INADMISION_RESOLUCION_DESC) values (-2 ,'No Informado');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION where MOTIVO_INADMISION_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION (MOTIVO_INADMISION_RESOLUCION_ID, MOTIVO_INADMISION_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_MOTIVO_INADMISION_RESOLUCION (MOTIVO_INADMISION_RESOLUCION_ID, MOTIVO_INADMISION_RESOLUCION_DESC)
	select DD_MIN_ID, DD_MIN_DESCRIPCION from recovery_lindorff_datastage.DD_MIN_MOTIVOS_INADMISION;


-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION where MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID = -3) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION (MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID, MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_DESC) values (-3 ,'');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION where MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION (MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID, MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_DESC) values (-2 ,'No Informado');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION where MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION (MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID, MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_ULTIMA_RESOLUCION (MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID, MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_DESC)
	select DD_MAR_ID, DD_MAR_DESCRIPCION from recovery_lindorff_datastage.DD_MAR_MOTIVOS_ARCHIVO;
	

-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION where MOTIVO_ARCHIVO_RESOLUCION_ID = -3) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION (MOTIVO_ARCHIVO_RESOLUCION_ID, MOTIVO_ARCHIVO_RESOLUCION_DESC) values (-3 ,'');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION where MOTIVO_ARCHIVO_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION (MOTIVO_ARCHIVO_RESOLUCION_ID, MOTIVO_ARCHIVO_RESOLUCION_DESC) values (-2 ,'No Informado');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION where MOTIVO_ARCHIVO_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION (MOTIVO_ARCHIVO_RESOLUCION_ID, MOTIVO_ARCHIVO_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_MOTIVO_ARCHIVO_RESOLUCION (MOTIVO_ARCHIVO_RESOLUCION_ID, MOTIVO_ARCHIVO_RESOLUCION_DESC)
	select DD_MAR_ID, DD_MAR_DESCRIPCION from recovery_lindorff_datastage.DD_MAR_MOTIVOS_ARCHIVO;
    
    
-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION where REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID = -3) = 0) then
	insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION (REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID, REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_DESC) values (-3 ,'');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION where REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION (REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID, REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_DESC) values (-2 ,'No Informado');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION where REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION (REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID, REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION (REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID, REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_DESC)
	select DD_RPR_ID, DD_RPR_DESCRIPCION from recovery_lindorff_datastage.DD_RPR_REQUERIMIENTO_PREVIO;
	

-- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION where REQUERIMIENTO_PREVIO_RESOLUCION_ID = -3) = 0) then
	insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION (REQUERIMIENTO_PREVIO_RESOLUCION_ID, REQUERIMIENTO_PREVIO_RESOLUCION_DESC) values (-3 ,'');
end if;
if ((select count(*) from DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION where REQUERIMIENTO_PREVIO_RESOLUCION_ID = -2) = 0) then
	insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION (REQUERIMIENTO_PREVIO_RESOLUCION_ID, REQUERIMIENTO_PREVIO_RESOLUCION_DESC) values (-2 ,'No Informado');
end if;    
if ((select count(*) from DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION where REQUERIMIENTO_PREVIO_RESOLUCION_ID = -1) = 0) then
	insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION (REQUERIMIENTO_PREVIO_RESOLUCION_ID, REQUERIMIENTO_PREVIO_RESOLUCION_DESC) values (-1 ,'Desconocido');
end if;

insert into DIM_PROCEDIMIENTO_REQUERIMIENTO_PREVIO_RESOLUCION (REQUERIMIENTO_PREVIO_RESOLUCION_ID, REQUERIMIENTO_PREVIO_RESOLUCION_DESC)
	select DD_RPR_ID, DD_RPR_DESCRIPCION from recovery_lindorff_datastage.DD_RPR_REQUERIMIENTO_PREVIO;


-- ----------------------------------------------------------------------------------------------
--             DIM_PROCEDIMIENTO (Usamos el ID de la primera fase del procedimiento)
-- ----------------------------------------------------------------------------------------------
  insert into DIM_PROCEDIMIENTO    
   (PROCEDIMIENTO_ID,
    ASUNTO_ID,
    TIPO_RECLAMACION_ID
   )
  select PRC_ID,
    ASU_ID,
    coalesce(DD_TRE_ID, -1)
  from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_PRC_ID is null;
  
  
  insert into TEMP_PROCEDIMIENTO_GESTOR (PROCEDIMIENTO_ID, GESTOR_PROCEDIMIENTO_ID)
  select prc.PRC_ID, usu.USU_ID from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
                    join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
                    join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
                    join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
                    join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on gaa.ASU_ID = prc.ASU_ID
                    where tges.DD_TGE_DESCRIPCION = 'Gestor Externo';

    
  insert into TEMP_PROCEDIMIENTO_SUPERVISOR (PROCEDIMIENTO_ID, SUPERVISOR_PROCEDIMIENTO_ID)
  select prc.PRC_ID, usu.USU_ID from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
                    join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
                    join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
                    join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
                    join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on gaa.ASU_ID = prc.ASU_ID
                    where tges.DD_TGE_DESCRIPCION = 'Supervisor';
                    
  update DIM_PROCEDIMIENTO dprc set GESTOR_PROCEDIMIENTO_ID = (select GESTOR_PROCEDIMIENTO_ID from TEMP_PROCEDIMIENTO_GESTOR tpg where dprc.PROCEDIMIENTO_ID =  tpg.PROCEDIMIENTO_ID);
  update DIM_PROCEDIMIENTO set GESTOR_PROCEDIMIENTO_ID = -1 where  GESTOR_PROCEDIMIENTO_ID is null;
  update DIM_PROCEDIMIENTO dprc set SUPERVISOR_PROCEDIMIENTO_ID =(select coalesce(SUPERVISOR_PROCEDIMIENTO_ID, -1) from TEMP_PROCEDIMIENTO_SUPERVISOR tps where dprc.PROCEDIMIENTO_ID = tps.PROCEDIMIENTO_ID);
  update DIM_PROCEDIMIENTO set SUPERVISOR_PROCEDIMIENTO_ID = -1 where  SUPERVISOR_PROCEDIMIENTO_ID is null;
  
  
  -- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO 
-- ------------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO where PROCURADOR_MONITORIO_ID = -1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO (PROCURADOR_MONITORIO_ID, PROCURADOR_MONITORIO_DESC) values (-1,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO where PROCURADOR_MONITORIO_ID = 0) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO (PROCURADOR_MONITORIO_ID, PROCURADOR_MONITORIO_DESC) values (0,'Sin Procurador Asignado');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO where PROCURADOR_MONITORIO_ID = 1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_MONITORIO (PROCURADOR_MONITORIO_ID, PROCURADOR_MONITORIO_DESC) values (1,'Con Procurador Asignado');

end if;

  -- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_PROCURADOR_ETJ 
-- ------------------------------------------------------------------------------------------------

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ETJ where PROCURADOR_ETJ_ID = -1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ETJ (PROCURADOR_ETJ_ID, PROCURADOR_ETJ_DESC) values (-1,'Desconocido');
  end if;
if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ETJ where PROCURADOR_ETJ_ID = 0) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ETJ (PROCURADOR_ETJ_ID, PROCURADOR_ETJ_DESC) values (0,'Sin Procurador Asignado');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ETJ where PROCURADOR_ETJ_ID = 1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ETJ (PROCURADOR_ETJ_ID, PROCURADOR_ETJ_DESC) values (1,'Con Procurador Asignado');

end if;


  -- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_PROCURADOR_ETNJ 
-- ------------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ETNJ where PROCURADOR_ETNJ_ID = -1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ETNJ (PROCURADOR_ETNJ_ID, PROCURADOR_ETNJ_DESC) values (-1,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ETNJ where PROCURADOR_ETNJ_ID = 0) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ETNJ (PROCURADOR_ETNJ_ID, PROCURADOR_ETNJ_DESC) values (0,'Sin Procurador Asignado');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ETNJ where PROCURADOR_ETNJ_ID = 1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ETNJ (PROCURADOR_ETNJ_ID, PROCURADOR_ETNJ_DESC) values (1,'Con Procurador Asignado');

end if;


  -- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO 
-- ------------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO where PROCURADOR_ORDINARIO_ID = -1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO (PROCURADOR_ORDINARIO_ID, PROCURADOR_ORDINARIO_DESC) values (-1,'Desconocido');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO where PROCURADOR_ORDINARIO_ID = 0) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO (PROCURADOR_ORDINARIO_ID, PROCURADOR_ORDINARIO_DESC) values (0,'Sin Procurador Asignado');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO where PROCURADOR_ORDINARIO_ID = 1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_ORDINARIO (PROCURADOR_ORDINARIO_ID, PROCURADOR_ORDINARIO_DESC) values (1,'Con Procurador Asignado');

end if;

  -- ----------------------------------------------------------------------------------------------
--                       DIM_PROCEDIMIENTO_PROCURADOR_VERBAL 
-- ------------------------------------------------------------------------------------------------
if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_VERBAL where PROCURADOR_VERBAL_ID = -1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_VERBAL (PROCURADOR_VERBAL_ID, PROCURADOR_VERBAL_DESC) values (-1,'Desconocido');

end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_VERBAL where PROCURADOR_VERBAL_ID = 0) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_VERBAL (PROCURADOR_VERBAL_ID, PROCURADOR_VERBAL_DESC) values (0,'Sin Procurador Asignado');
end if;

if ((select count(*) from DIM_PROCEDIMIENTO_PROCURADOR_VERBAL where PROCURADOR_VERBAL_ID = 1) = 0) then 
	insert into DIM_PROCEDIMIENTO_PROCURADOR_VERBAL (PROCURADOR_VERBAL_ID, PROCURADOR_VERBAL_DESC) values (1,'Con Procurador Asignado');

end if;


  
END MY_BLOCK_DIM_PRC
