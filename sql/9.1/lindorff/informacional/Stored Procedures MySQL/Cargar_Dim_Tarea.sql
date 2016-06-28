-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Tarea`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_TAR: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Tarea.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN TAREA
    -- DIM_TAREA_ALERTA
    -- DIM_TAREA_AMBITO
    -- DIM_TAREA_CUMPLIMIENTO
    -- DIM_TAREA_ESTADO_PRORROGA
    -- DIM_TAREA_PENDIENTE_RESPUESTA
    -- DIM_TAREA_MOTIVO_PRORROGA
    -- DIM_TAREA_RESOLUCION_PRORROGA
    -- DIM_TAREA_REALIZACION
    -- DIM_TAREA_TIPO
    -- DIM_TAREA_TIPO_DETALLE 
    -- DIM_TAREA_GESTOR
    -- DIM_TAREA_SUPERVISOR
    -- DIM_TAREA_DESPACHO_GESTOR
    -- DIM_TAREA_DESPACHO_SUPERVISOR 
    -- DIM_TAREA_TIPO_DESPACHO_GESTOR 
    -- DIM_TAREA_TIPO_DESPACHO_SUPERVISOR 
    -- DIM_TAREA_ENTIDAD_GESTOR 
    -- DIM_TAREA_ENTIDAD_SUPERVISOR 
    -- DIM_TAREA_NIVEL_DESPACHO_GESTOR 
    -- DIM_TAREA_NIVEL_DESPACHO_SUPERVISOR
    -- DIM_TAREA_OFICINA_DESPACHO_GESTOR
    -- DIM_TAREA_OFICINA_DESPACHO_SUPERVISOR
    -- DIM_TAREA_PROVINCIA_DESPACHO_GESTOR
    -- DIM_TAREA_PROVINCIA_DESPACHO_SUPERVISOR
    -- DIM_TAREA_ZONA_DESPACHO_GESTOR
    -- DIM_TAREA_ZONA_DESPACHO_SUPERVISOR
    -- DIM_TAREA_DESCRIPCION
    -- DIM_TAREA_RESPONSABLE
    -- DIM_TAREA 

-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
declare max_id int;
declare tarea_desc varchar(100);
declare l_last_row int default 0;
declare c_tarea_desc cursor for select distinct TAR_TAREA FROM recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where PRC_ID IS NOT NULL order by 1;
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
--                                      DIM_TAREA_ALERTA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_ALERTA where TAREA_ALERTA_ID = 0) = 0) then
	insert into DIM_TAREA_ALERTA (TAREA_ALERTA_ID, TAREA_ALERTA_DESC) values (0, 'No Alerta');
end if;

if ((select count(*) from DIM_TAREA_ALERTA where TAREA_ALERTA_ID = 1) = 0) then
	insert into DIM_TAREA_ALERTA (TAREA_ALERTA_ID, TAREA_ALERTA_DESC) values (1, 'Alerta');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_AMBITO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_AMBITO where AMBITO_TAREA_ID = 0) = 0) then
	insert into DIM_TAREA_AMBITO (AMBITO_TAREA_ID, AMBITO_TAREA_DESC) values (0, 'Interno');
end if;

if ((select count(*) from DIM_TAREA_AMBITO where AMBITO_TAREA_ID = 1) = 0) then
	insert into DIM_TAREA_AMBITO (AMBITO_TAREA_ID, AMBITO_TAREA_DESC) values (1, 'Externo');
end if;


-- ----------------------------------------------------------------------------------------------
--                      DIM_TAREA_CUMPLIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_CUMPLIMIENTO where CUMPLIMIENTO_TAREA_ID = -2) = 0) then
	insert into DIM_TAREA_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) values (-2, 'Sin Fecha Vencimiento');
end if;

if ((select count(*) from DIM_TAREA_CUMPLIMIENTO where CUMPLIMIENTO_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) values (-1, 'No Finalizada');
end if;

if ((select count(*) from DIM_TAREA_CUMPLIMIENTO where CUMPLIMIENTO_TAREA_ID = 0) = 0) then
	insert into DIM_TAREA_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) values (0, 'En Plazo');
end if;

if ((select count(*) from DIM_TAREA_CUMPLIMIENTO where CUMPLIMIENTO_TAREA_ID = 1) = 0) then
	insert into DIM_TAREA_CUMPLIMIENTO (CUMPLIMIENTO_TAREA_ID, CUMPLIMIENTO_TAREA_DESC) values (1, 'Fuera De Plazo');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_ESTADO_PRORROGA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_ESTADO_PRORROGA where ESTADO_PRORROGA_ID = 0) = 0) then
	insert into DIM_TAREA_ESTADO_PRORROGA (ESTADO_PRORROGA_ID, ESTADO_PRORROGA_DESC) values (0, 'No Respondido');
end if;

if ((select count(*) from DIM_TAREA_ESTADO_PRORROGA where ESTADO_PRORROGA_ID = 1) = 0) then
	insert into DIM_TAREA_ESTADO_PRORROGA (ESTADO_PRORROGA_ID, ESTADO_PRORROGA_DESC) values (1, 'Respondido');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_MOTIVO_PRORROGA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_MOTIVO_PRORROGA where MOTIVO_PRORROGA_ID = -1) = 0) then
	insert into DIM_TAREA_MOTIVO_PRORROGA (MOTIVO_PRORROGA_ID, MOTIVO_PRORROGA_DESC, MOTIVO_PRORROGA_DESC_ALT) values (-1, 'Desconocido', 'Desconocido');
end if;

insert into DIM_TAREA_MOTIVO_PRORROGA(MOTIVO_PRORROGA_ID, MOTIVO_PRORROGA_DESC, MOTIVO_PRORROGA_DESC_ALT)
  select DD_CPR_ID, DD_CPR_DESCRIPCION, DD_CPR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_CPR_CAUSA_PRORROGA;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_PENDIENTE_RESPUESTA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_PENDIENTE_RESPUESTA where PENDIENTE_RESPUESTA_ID = 0) = 0) then
	insert into DIM_TAREA_PENDIENTE_RESPUESTA (PENDIENTE_RESPUESTA_ID, PENDIENTE_RESPUESTA_DESC) values (0, 'No En Espera');
end if;

if ((select count(*) from DIM_TAREA_PENDIENTE_RESPUESTA where PENDIENTE_RESPUESTA_ID = 1) = 0) then
	insert into DIM_TAREA_PENDIENTE_RESPUESTA (PENDIENTE_RESPUESTA_ID, PENDIENTE_RESPUESTA_DESC) values (1, 'En Espera');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_REALIZACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_REALIZACION where REALIZACION_TAREA_ID = 0) = 0) then
	insert into DIM_TAREA_REALIZACION (REALIZACION_TAREA_ID, REALIZACION_TAREA_DESC) values (0, 'Pendiente');
end if;

if ((select count(*) from DIM_TAREA_REALIZACION where REALIZACION_TAREA_ID = 1) = 0) then
	insert into DIM_TAREA_REALIZACION (REALIZACION_TAREA_ID, REALIZACION_TAREA_DESC) values (1, 'Finalizada');
end if;


-- ----------------------------------------------------------------------------------------------
--                                   DIM_TAREA_RESOLUCION_PRORROGA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_RESOLUCION_PRORROGA where RESOLUCION_PRORROGA_ID = -1) = 0) then
	insert into DIM_TAREA_RESOLUCION_PRORROGA (RESOLUCION_PRORROGA_ID, RESOLUCION_PRORROGA_DESC, RESOLUCION_PRORROGA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_TAREA_RESOLUCION_PRORROGA(RESOLUCION_PRORROGA_ID, RESOLUCION_PRORROGA_DESC, RESOLUCION_PRORROGA_DESC_ALT)
    select DD_RPR_ID, DD_RPR_DESCRIPCION, DD_RPR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_RPR_RAZON_PRORROGA;


-- ----------------------------------------------------------------------------------------------
--                                   DIM_TAREA_TIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_TIPO where TIPO_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_TIPO (TIPO_TAREA_ID, TIPO_TAREA_DESC, TIPO_TAREA_DESC_ALT) values (-1 ,'Desconocido', -1);
end if;

 insert into DIM_TAREA_TIPO(TIPO_TAREA_ID, TIPO_TAREA_DESC, TIPO_TAREA_DESC_ALT)
    select DD_TAR_ID, DD_TAR_DESCRIPCION, DD_TAR_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAR_TIPO_TAREA_BASE;
    
    
-- ----------------------------------------------------------------------------------------------
--                                  DIM_TAREA_TIPO_DETALLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_TIPO_DETALLE where TIPO_TAREA_DETALLE_ID = -1) = 0) then
	insert into DIM_TAREA_TIPO_DETALLE (TIPO_TAREA_DETALLE_ID, TIPO_TAREA_DETALLE_DESC, TIPO_TAREA_DETALLE_DESC_ALT, TIPO_TAREA_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_TAREA_TIPO_DETALLE(TIPO_TAREA_DETALLE_ID, TIPO_TAREA_DETALLE_DESC, TIPO_TAREA_DETALLE_DESC_ALT, TIPO_TAREA_ID)
    select DD_STA_ID, DD_STA_DESCRIPCION, DD_STA_DESCRIPCION_LARGA, DD_TAR_ID FROM recovery_lindorff_datastage.DD_STA_SUBTIPO_TAREA_BASE;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_GESTOR
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_GESTOR where GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_GESTOR(
    GESTOR_TAREA_ID,
    GESTOR_TAREA_NOMBRE_COMPLETO,
    GESTOR_TAREA_NOMBRE,
    GESTOR_TAREA_APELLIDO1,
    GESTOR_TAREA_APELLIDO2,
    ENTIDAD_GESTOR_TAREA_ID, 
    DESPACHO_GESTOR_TAREA_ID) values (-1 ,'Sin Gestor Asignado','Sin Gestor Asignado', 'Sin Gestor Asignado', 'Sin Gestor Asignado', -1, -1);
end if;

insert into DIM_TAREA_GESTOR (
    GESTOR_TAREA_ID,
    GESTOR_TAREA_NOMBRE_COMPLETO,
    GESTOR_TAREA_NOMBRE,
    GESTOR_TAREA_APELLIDO1,
    GESTOR_TAREA_APELLIDO2,
    ENTIDAD_GESTOR_TAREA_ID, 
    DESPACHO_GESTOR_TAREA_ID)
select usu.USU_ID,
    coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), 'Desconocido'),
    coalesce(usu.USU_NOMBRE, 'Desconocido'),
    coalesce(usu.USU_APELLIDO1, 'Desconocido'),
    coalesce(usu.USU_APELLIDO2, 'Desconocido'),
    usu.ENTIDAD_ID,
    usd.DES_ID 
from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
where tges.DD_TGE_DESCRIPCION = 'Gestor Externo' group by usu.USU_ID;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_SUPERVISOR where SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_SUPERVISOR(
    SUPERVISOR_TAREA_ID,
    SUPERVISOR_TAREA_NOMBRE_COMPLETO,
    SUPERVISOR_TAREA_NOMBRE,
    SUPERVISOR_TAREA_APELLIDO1,
    SUPERVISOR_TAREA_APELLIDO2,
    ENTIDAD_SUPERVISOR_TAREA_ID, 
    DESPACHO_SUPERVISOR_TAREA_ID) values (-1 ,'Sin Supervisor Asignado', 'Sin Supervisor Asignado', 'Sin Supervisor Asignado', 'Sin Supervisor Asignado', -1, -1);
end if;

insert into DIM_TAREA_SUPERVISOR (
    SUPERVISOR_TAREA_ID,
    SUPERVISOR_TAREA_NOMBRE_COMPLETO,
    SUPERVISOR_TAREA_NOMBRE,
    SUPERVISOR_TAREA_APELLIDO1,
    SUPERVISOR_TAREA_APELLIDO2,
    ENTIDAD_SUPERVISOR_TAREA_ID, 
    DESPACHO_SUPERVISOR_TAREA_ID)
select usu.USU_ID,
    coalesce(concat_ws('', usu.USU_NOMBRE, ' ', usu.USU_APELLIDO1, ' ', usu.USU_APELLIDO2), ' ', 'Desconocido'),
    coalesce(usu.USU_NOMBRE, 'Desconocido'),
    coalesce(usu.USU_APELLIDO1, 'Desconocido'),
    coalesce(usu.USU_APELLIDO2, 'Desconocido'),
    usu.ENTIDAD_ID,
    usd.DES_ID 
from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
where tges.DD_TGE_DESCRIPCION = 'Supervisor' group by usu.USU_ID;


-- ----------------------------------------------------------------------------------------------
--          DIM_TAREA_DESPACHO_GESTOR / DIM_TAREA_DESPACHO_SUPERVISOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_DESPACHO_GESTOR where DESPACHO_GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_DESPACHO_GESTOR (DESPACHO_GESTOR_TAREA_ID, DESPACHO_GESTOR_TAREA_DESC, TIPO_DESPACHO_GESTOR_TAREA_ID, ZONA_DESPACHO_GESTOR_TAREA_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_TAREA_DESPACHO_GESTOR(DESPACHO_GESTOR_TAREA_ID, DESPACHO_GESTOR_TAREA_DESC, TIPO_DESPACHO_GESTOR_TAREA_ID, ZONA_DESPACHO_GESTOR_TAREA_ID)
    select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1) FROM recovery_lindorff_datastage.DES_DESPACHO_EXTERNO;

if ((select count(*) from DIM_TAREA_DESPACHO_SUPERVISOR where DESPACHO_SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_DESPACHO_SUPERVISOR (DESPACHO_SUPERVISOR_TAREA_ID, DESPACHO_SUPERVISOR_TAREA_DESC, TIPO_DESPACHO_SUPERVISOR_TAREA_ID, ZONA_DESPACHO_SUPERVISOR_TAREA_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_TAREA_DESPACHO_SUPERVISOR(DESPACHO_SUPERVISOR_TAREA_ID, DESPACHO_SUPERVISOR_TAREA_DESC, TIPO_DESPACHO_SUPERVISOR_TAREA_ID, ZONA_DESPACHO_SUPERVISOR_TAREA_ID)
    select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1) FROM recovery_lindorff_datastage.DES_DESPACHO_EXTERNO;


-- ----------------------------------------------------------------------------------------------
--      DIM_TAREA_TIPO_DESPACHO_GESTOR / DIM_TAREA_TIPO_DESPACHO_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_TIPO_DESPACHO_GESTOR where TIPO_DESPACHO_GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_TIPO_DESPACHO_GESTOR (TIPO_DESPACHO_GESTOR_TAREA_ID, TIPO_DESPACHO_GESTOR_TAREA_DESC, TIPO_DESPACHO_GESTOR_TAREA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_TAREA_TIPO_DESPACHO_GESTOR(TIPO_DESPACHO_GESTOR_TAREA_ID, TIPO_DESPACHO_GESTOR_TAREA_DESC, TIPO_DESPACHO_GESTOR_TAREA_DESC_ALT)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDE_TIPO_DESPACHO;
    
if ((select count(*) from DIM_TAREA_TIPO_DESPACHO_SUPERVISOR where TIPO_DESPACHO_SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_TIPO_DESPACHO_SUPERVISOR (TIPO_DESPACHO_SUPERVISOR_TAREA_ID, TIPO_DESPACHO_SUPERVISOR_TAREA_DESC, TIPO_DESPACHO_SUPERVISOR_TAREA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_TAREA_TIPO_DESPACHO_SUPERVISOR(TIPO_DESPACHO_SUPERVISOR_TAREA_ID, TIPO_DESPACHO_SUPERVISOR_TAREA_DESC, TIPO_DESPACHO_SUPERVISOR_TAREA_DESC_ALT)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDE_TIPO_DESPACHO;
    

-- ----------------------------------------------------------------------------------------------
--            DIM_TAREA_ENTIDAD_GESTOR / DIM_TAREA_ENTIDAD_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_ENTIDAD_GESTOR where ENTIDAD_GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_ENTIDAD_GESTOR (ENTIDAD_GESTOR_TAREA_ID, ENTIDAD_GESTOR_TAREA_DESC) values (-1, 'Desconocido');
end if;

 insert into DIM_TAREA_ENTIDAD_GESTOR(ENTIDAD_GESTOR_TAREA_ID, ENTIDAD_GESTOR_TAREA_DESC)
    select ID, DESCRIPCION FROM recovery_lindorff_datastage.ENTIDAD;   
    
if ((select count(*) from DIM_TAREA_ENTIDAD_SUPERVISOR where ENTIDAD_SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_ENTIDAD_SUPERVISOR (ENTIDAD_SUPERVISOR_TAREA_ID, ENTIDAD_SUPERVISOR_TAREA_DESC) values (-1, 'Desconocido');
end if;

 insert into DIM_TAREA_ENTIDAD_SUPERVISOR(ENTIDAD_SUPERVISOR_TAREA_ID, ENTIDAD_SUPERVISOR_TAREA_DESC)
    select ID, DESCRIPCION FROM recovery_lindorff_datastage.ENTIDAD;      
    

-- ----------------------------------------------------------------------------------------------
--    DIM_TAREA_NIVEL_DESPACHO_GESTOR / DIM_TAREA_NIVEL_DESPACHO_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_NIVEL_DESPACHO_GESTOR where NIVEL_DESPACHO_GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_NIVEL_DESPACHO_GESTOR (NIVEL_DESPACHO_GESTOR_TAREA_ID, NIVEL_DESPACHO_GESTOR_TAREA_DESC, NIVEL_DESPACHO_GESTOR_TAREA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_TAREA_NIVEL_DESPACHO_GESTOR(NIVEL_DESPACHO_GESTOR_TAREA_ID, NIVEL_DESPACHO_GESTOR_TAREA_DESC, NIVEL_DESPACHO_GESTOR_TAREA_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;
    
if ((select count(*) from DIM_TAREA_NIVEL_DESPACHO_SUPERVISOR where NIVEL_DESPACHO_SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_NIVEL_DESPACHO_SUPERVISOR (NIVEL_DESPACHO_SUPERVISOR_TAREA_ID, NIVEL_DESPACHO_SUPERVISOR_TAREA_DESC, NIVEL_DESPACHO_SUPERVISOR_TAREA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_TAREA_NIVEL_DESPACHO_SUPERVISOR(NIVEL_DESPACHO_SUPERVISOR_TAREA_ID, NIVEL_DESPACHO_SUPERVISOR_TAREA_DESC, NIVEL_DESPACHO_SUPERVISOR_TAREA_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;
    

-- ----------------------------------------------------------------------------------------------
--   DIM_TAREA_OFICINA_DESPACHO_GESTOR / DIM_TAREA_OFICINA_DESPACHO_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_OFICINA_DESPACHO_GESTOR where OFICINA_DESPACHO_GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_OFICINA_DESPACHO_GESTOR (OFICINA_DESPACHO_GESTOR_TAREA_ID, OFICINA_DESPACHO_GESTOR_TAREA_DESC, OFICINA_DESPACHO_GESTOR_TAREA_DESC_ALT, PROVINCIA_DESPACHO_GESTOR_TAREA_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_TAREA_OFICINA_DESPACHO_GESTOR(OFICINA_DESPACHO_GESTOR_TAREA_ID, OFICINA_DESPACHO_GESTOR_TAREA_DESC, PROVINCIA_DESPACHO_GESTOR_TAREA_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;

if ((select count(*) from DIM_TAREA_OFICINA_DESPACHO_SUPERVISOR where OFICINA_DESPACHO_SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_OFICINA_DESPACHO_SUPERVISOR (OFICINA_DESPACHO_SUPERVISOR_TAREA_ID, OFICINA_DESPACHO_SUPERVISOR_TAREA_DESC, OFICINA_DESPACHO_SUPERVISOR_TAREA_DESC_ALT, PROVINCIA_DESPACHO_SUPERVISOR_TAREA_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_TAREA_OFICINA_DESPACHO_SUPERVISOR(OFICINA_DESPACHO_SUPERVISOR_TAREA_ID, OFICINA_DESPACHO_SUPERVISOR_TAREA_DESC, PROVINCIA_DESPACHO_SUPERVISOR_TAREA_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;
    
    
-- ----------------------------------------------------------------------------------------------
--  DIM_TAREA_PROVINCIA_DESPACHO_GESTOR / DIM_TAREA_PROVINCIA_DESPACHO_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------    
if ((select count(*) from DIM_TAREA_PROVINCIA_DESPACHO_GESTOR where PROVINCIA_DESPACHO_GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_PROVINCIA_DESPACHO_GESTOR (PROVINCIA_DESPACHO_GESTOR_TAREA_ID, PROVINCIA_DESPACHO_GESTOR_TAREA_DESC, PROVINCIA_DESPACHO_GESTOR_TAREA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_TAREA_PROVINCIA_DESPACHO_GESTOR(PROVINCIA_DESPACHO_GESTOR_TAREA_ID, PROVINCIA_DESPACHO_GESTOR_TAREA_DESC, PROVINCIA_DESPACHO_GESTOR_TAREA_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;

if ((select count(*) from DIM_TAREA_PROVINCIA_DESPACHO_SUPERVISOR where PROVINCIA_DESPACHO_SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_PROVINCIA_DESPACHO_SUPERVISOR (PROVINCIA_DESPACHO_SUPERVISOR_TAREA_ID, PROVINCIA_DESPACHO_SUPERVISOR_TAREA_DESC, PROVINCIA_DESPACHO_SUPERVISOR_TAREA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_TAREA_PROVINCIA_DESPACHO_SUPERVISOR(PROVINCIA_DESPACHO_SUPERVISOR_TAREA_ID, PROVINCIA_DESPACHO_SUPERVISOR_TAREA_DESC, PROVINCIA_DESPACHO_SUPERVISOR_TAREA_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;
    

-- ----------------------------------------------------------------------------------------------
--     DIM_TAREA_ZONA_DESPACHO_GESTOR / DIM_TAREA_ZONA_DESPACHO_SUPERVISOR 
-- ----------------------------------------------------------------------------------------------  
if ((select count(*) from DIM_TAREA_ZONA_DESPACHO_GESTOR where ZONA_DESPACHO_GESTOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_ZONA_DESPACHO_GESTOR (ZONA_DESPACHO_GESTOR_TAREA_ID, ZONA_DESPACHO_GESTOR_TAREA_DESC, ZONA_DESPACHO_GESTOR_TAREA_DESC_ALT, NIVEL_DESPACHO_GESTOR_TAREA_ID, OFICINA_DESPACHO_GESTOR_TAREA_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_TAREA_ZONA_DESPACHO_GESTOR(ZONA_DESPACHO_GESTOR_TAREA_ID, ZONA_DESPACHO_GESTOR_TAREA_DESC, ZONA_DESPACHO_GESTOR_TAREA_DESC_ALT, NIVEL_DESPACHO_GESTOR_TAREA_ID, OFICINA_DESPACHO_GESTOR_TAREA_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM recovery_lindorff_datastage.ZON_ZONIFICACION;

if ((select count(*) from DIM_TAREA_ZONA_DESPACHO_SUPERVISOR where ZONA_DESPACHO_SUPERVISOR_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_ZONA_DESPACHO_SUPERVISOR (ZONA_DESPACHO_SUPERVISOR_TAREA_ID, ZONA_DESPACHO_SUPERVISOR_TAREA_DESC, ZONA_DESPACHO_SUPERVISOR_TAREA_DESC_ALT, NIVEL_DESPACHO_SUPERVISOR_TAREA_ID, OFICINA_DESPACHO_SUPERVISOR_TAREA_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_TAREA_ZONA_DESPACHO_SUPERVISOR(ZONA_DESPACHO_SUPERVISOR_TAREA_ID, ZONA_DESPACHO_SUPERVISOR_TAREA_DESC, ZONA_DESPACHO_SUPERVISOR_TAREA_DESC_ALT, NIVEL_DESPACHO_SUPERVISOR_TAREA_ID, OFICINA_DESPACHO_SUPERVISOR_TAREA_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM recovery_lindorff_datastage.ZON_ZONIFICACION;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_DESCRIPCION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_DESCRIPCION where DESCRIPCION_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_DESCRIPCION (DESCRIPCION_TAREA_ID, DESCRIPCION_TAREA_DESC) values (-1, 'Desconocido');
end if;

set l_last_row = 0; 

open c_tarea_desc;
tarea_desc_loop: loop
fetch c_tarea_desc into tarea_desc;        
    if (l_last_row=1) then leave tarea_desc_loop; 
    end if;

set max_id = (select max(DESCRIPCION_TAREA_ID) from DIM_TAREA_DESCRIPCION) +1;
insert into DIM_TAREA_DESCRIPCION (DESCRIPCION_TAREA_ID, DESCRIPCION_TAREA_DESC)
values (max_id,tarea_desc);

end loop;
close c_tarea_desc;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA_RESPONSABLE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_TAREA_RESPONSABLE where RESPONSABLE_TAREA_ID = -1) = 0) then
	insert into DIM_TAREA_RESPONSABLE (RESPONSABLE_TAREA_ID, RESPONSABLE_TAREA_DESC) values (-1, 'Desconocido');
end if;

if ((select count(*) from DIM_TAREA_RESPONSABLE where RESPONSABLE_TAREA_ID = 0) = 0) then
	insert into DIM_TAREA_RESPONSABLE (RESPONSABLE_TAREA_ID, RESPONSABLE_TAREA_DESC) values (0, 'Gestor');
end if;

if ((select count(*) from DIM_TAREA_RESPONSABLE where RESPONSABLE_TAREA_ID = 1) = 0) then
	insert into DIM_TAREA_RESPONSABLE (RESPONSABLE_TAREA_ID, RESPONSABLE_TAREA_DESC) values (1, 'Supervisor');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_TAREA
-- ----------------------------------------------------------------------------------------------
  insert into DIM_TAREA
   (TAREA_ID,
    TAREA_EMISOR,
    DESCRIPCION_TAREA_ID,
    FECHA_INICIO_TAREA,
    FECHA_FIN_TAREA,
    FECHA_VENCIMIENTO_TAREA,
    FECHA_VENCIMIENTO_REAL_TAREA,
    TIPO_TAREA_DETALLE_ID,
    PENDIENTE_RESPUESTA_ID,
    TAREA_ALERTA_ID,
    CUMPLIMIENTO_TAREA_ID
   )
  select  TAR_ID,
    TAR_EMISOR,
    td.DESCRIPCION_TAREA_ID,
    date(TAR_FECHA_INI),
    date(TAR_FECHA_FIN),
    date(TAR_FECHA_VENC),
    date(TAR_FECHA_VENC_REAL),
    DD_STA_ID,
    TAR_EN_ESPERA,
    TAR_ALERTA,
    (case when datediff(date(TAR_FECHA_FIN),date(TAR_FECHA_VENC)) <= 0 then 0
          when datediff(date(TAR_FECHA_FIN),date(TAR_FECHA_VENC)) > 0 then 1
          when date(TAR_FECHA_VENC) is null then -2
          else -1 end)                                                                           
 from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tn
 join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on tn.PRC_ID = prc.PRC_ID
 join DIM_TAREA_DESCRIPCION td on tn.TAR_TAREA = td.DESCRIPCION_TAREA_DESC where prc.BORRADO=0;


  -- Tarea Externa o Interna
  update DIM_TAREA set AMBITO_TAREA_ID = (case when TAREA_ID in (select TAR_ID from recovery_lindorff_datastage.TEX_TAREA_EXTERNA) then 1
                                             else 0 end);

  insert into TEMP_TAREA_GESTOR (TAREA_ID, GESTOR_TAREA_ID)
  select tar.TAR_ID, usu.USU_ID from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
                    join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
                    join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
                    join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
                    join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on gaa.ASU_ID = prc.ASU_ID
                    join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on prc.PRC_ID = tar.PRC_ID
                    where tges.DD_TGE_DESCRIPCION = 'Gestor';

    
  insert into TEMP_TAREA_SUPERVISOR (TAREA_ID, SUPERVISOR_TAREA_ID)
  select tar.TAR_ID, usu.USU_ID from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
                    join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
                    join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
                    join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
                    join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on gaa.ASU_ID = prc.ASU_ID
                    join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on prc.PRC_ID = tar.PRC_ID
                    where tges.DD_TGE_DESCRIPCION = 'Supervisor';
                    
  update DIM_TAREA dprc set GESTOR_TAREA_ID = (select GESTOR_TAREA_ID from TEMP_TAREA_GESTOR tpg where dprc.TAREA_ID =  tpg.TAREA_ID);
  update DIM_TAREA set GESTOR_TAREA_ID = -1 where  GESTOR_TAREA_ID is null;
  update DIM_TAREA dprc set SUPERVISOR_TAREA_ID =(select coalesce(SUPERVISOR_TAREA_ID, -1) from TEMP_TAREA_SUPERVISOR tps where dprc.TAREA_ID = tps.TAREA_ID);
  update DIM_TAREA set SUPERVISOR_TAREA_ID = -1 where  SUPERVISOR_TAREA_ID is null;
  
END MY_BLOCK_DIM_TAR