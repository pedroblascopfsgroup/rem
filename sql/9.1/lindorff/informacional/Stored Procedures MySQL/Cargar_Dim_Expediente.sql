-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Expediente`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_EXP: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Expediente.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN EXPEDIENTE 
    -- DIM_EXPEDIENTE_ACTITUD
    -- DIM_EXPEDIENTE_AMBITO_EXPEDIENTE 
    -- DIM_EXPEDIENTE_ARQUETIPO
    -- DIM_EXPEDIENTE_CAUSA_IMPAGO 
    -- DIM_EXPEDIENTE_COMITE 
    -- DIM_EXPEDIENTE_DECISION 
    -- DIM_EXPEDIENTE_ENTIDAD_INFORMACION 
    -- DIM_EXPEDIENTE_ESTADO_EXPEDIENTE
    -- DIM_EXPEDIENTE_ESTADO_ITINERARIO 
    -- DIM_EXPEDIENTE_ITINERARIO
    -- DIM_EXPEDIENTE_NIVEL   
    -- DIM_EXPEDIENTE_OFICINA 
    -- DIM_EXPEDIENTE_PROPUESTA 
    -- DIM_EXPEDIENTE_PROVINCIA 
    -- DIM_EXPEDIENTE_SESION 
    -- DIM_EXPEDIENTE_TIPO_ITINERARIO 
    -- DIM_EXPEDIENTE_ZONA 
    -- DIM_EXPEDIENTE


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
--                                      DIM_EXPEDIENTE_ACTITUD
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_ACTITUD where ACTITUD_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_ACTITUD (ACTITUD_ID, ACTITUD_DESC, ACTITUD_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_ACTITUD(ACTITUD_ID, ACTITUD_DESC, ACTITUD_DESC_ALT)
    select DD_TAA_ID, DD_TAA_DESCRIPCION, DD_TAA_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TAA_TIPO_AYUDA_ACTUACION;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_AMBITO_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_AMBITO_EXPEDIENTE where AMBITO_EXPEDIENTE_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_AMBITO_EXPEDIENTE (AMBITO_EXPEDIENTE_EXPEDIENTE_ID, AMBITO_EXPEDIENTE_EXPEDIENTE_DESC, AMBITO_EXPEDIENTE_EXPEDIENTE_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_AMBITO_EXPEDIENTE(AMBITO_EXPEDIENTE_EXPEDIENTE_ID, AMBITO_EXPEDIENTE_EXPEDIENTE_DESC, AMBITO_EXPEDIENTE_EXPEDIENTE_DESC_ALT)
    select DD_AEX_ID, DD_AEX_DESCRIPCION, DD_AEX_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_AEX_AMBITOS_EXPEDIENTE;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_ARQUETIPO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_ARQUETIPO where ARQUETIPO_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_ARQUETIPO (ARQUETIPO_EXPEDIENTE_ID, ARQUETIPO_EXPEDIENTE_DESC, ITINERARIO_EXPEDIENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into DIM_EXPEDIENTE_ARQUETIPO(ARQUETIPO_EXPEDIENTE_ID, ARQUETIPO_EXPEDIENTE_DESC, ITINERARIO_EXPEDIENTE_ID)
    select ARQ_ID, ARQ_NOMBRE, ITI_ID FROM recovery_lindorff_datastage.ARQ_ARQUETIPOS;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_CAUSA_IMPAGO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_CAUSA_IMPAGO where CAUSA_IMPAGO_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_CAUSA_IMPAGO (CAUSA_IMPAGO_ID, CAUSA_IMPAGO_DESC, CAUSA_IMPAGO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_CAUSA_IMPAGO(CAUSA_IMPAGO_ID, CAUSA_IMPAGO_DESC, CAUSA_IMPAGO_DESC_ALT)
    select DD_CIM_ID, DD_CIM_DESCRIPCION, DD_CIM_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_CIM_CAUSAS_IMPAGO;
    
        
-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_COMITE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_COMITE where COMITE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_COMITE (COMITE_ID, COMITE_DESC, ZONA_EXPEDIENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into DIM_EXPEDIENTE_COMITE(COMITE_ID, COMITE_DESC, ZONA_EXPEDIENTE_ID)
    select COM_ID, COM_NOMBRE, ZON_ID FROM recovery_lindorff_datastage.COM_COMITES;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_DECISION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_DECISION where DECISION_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_DECISION (DECISION_ID, DECISION_DESC, SESION_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into DIM_EXPEDIENTE_DECISION(DECISION_ID, DECISION_DESC, SESION_ID)
    select DCO_ID, DCO_OBSERVACIONES, SES_ID FROM recovery_lindorff_datastage.DCO_DECISION_COMITE;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_ENTIDAD_INFORMACION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_ENTIDAD_INFORMACION where ENTIDAD_INFORMACION_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_ENTIDAD_INFORMACION (ENTIDAD_INFORMACION_ID, ENTIDAD_INFORMACION_DESC, ENTIDAD_INFORMACION_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_ENTIDAD_INFORMACION(ENTIDAD_INFORMACION_ID, ENTIDAD_INFORMACION_DESC, ENTIDAD_INFORMACION_DESC_ALT)
    select DD_EIN_ID, DD_EIN_DESCRIPCION, DD_EIN_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EIN_ENTIDAD_INFORMACION;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_ESTADO_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_ESTADO_EXPEDIENTE where ESTADO_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_ESTADO_EXPEDIENTE (ESTADO_EXPEDIENTE_ID, ESTADO_EXPEDIENTE_DESC, ESTADO_EXPEDIENTE_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_ESTADO_EXPEDIENTE(ESTADO_EXPEDIENTE_ID, ESTADO_EXPEDIENTE_DESC, ESTADO_EXPEDIENTE_DESC_ALT)
    select DD_EEX_ID, DD_EEX_DESCRIPCION, DD_EEX_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EEX_ESTADO_EXPEDIENTE;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_ESTADO_ITINERARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_ESTADO_ITINERARIO where ESTADO_ITINERARIO_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_ESTADO_ITINERARIO (ESTADO_ITINERARIO_ID, ESTADO_ITINERARIO_DESC, ESTADO_ITINERARIO_DESC_ALT, ENTIDAD_INFORMACION_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_EXPEDIENTE_ESTADO_ITINERARIO(ESTADO_ITINERARIO_ID, ESTADO_ITINERARIO_DESC, ESTADO_ITINERARIO_DESC_ALT, ENTIDAD_INFORMACION_ID)
    select DD_EST_ID, DD_EST_DESCRIPCION, DD_EST_DESCRIPCION_LARGA, DD_EIN_ID FROM recovery_lindorff_datastage.DD_EST_ESTADOS_ITINERARIOS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_ITINERARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_ITINERARIO where ITINERARIO_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_ITINERARIO (ITINERARIO_EXPEDIENTE_ID, ITINERARIO_EXPEDIENTE_DESC, TIPO_ITINERARIO_EXPEDIENTE_ID, AMBITO_EXPEDIENTE_EXPEDIENTE_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_EXPEDIENTE_ITINERARIO(ITINERARIO_EXPEDIENTE_ID, ITINERARIO_EXPEDIENTE_DESC, TIPO_ITINERARIO_EXPEDIENTE_ID, AMBITO_EXPEDIENTE_EXPEDIENTE_ID)
    select ITI_ID, ITI_NOMBRE, DD_TIT_ID, DD_AEX_ID FROM recovery_lindorff_datastage.ITI_ITINERARIOS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_NIVEL
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_NIVEL where NIVEL_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_NIVEL (NIVEL_EXPEDIENTE_ID, NIVEL_EXPEDIENTE_DESC, NIVEL_EXPEDIENTE_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_NIVEL(NIVEL_EXPEDIENTE_ID, NIVEL_EXPEDIENTE_DESC, NIVEL_EXPEDIENTE_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_OFICINA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_OFICINA where OFICINA_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_OFICINA (OFICINA_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_DESC, OFICINA_EXPEDIENTE_DESC_ALT, PROVINCIA_EXPEDIENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_EXPEDIENTE_OFICINA(OFICINA_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_DESC, PROVINCIA_EXPEDIENTE_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_PROPUESTA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_PROPUESTA where PROPUESTA_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_PROPUESTA (PROPUESTA_ID, PROPUESTA_DESC, PROPUESTA_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_PROPUESTA(PROPUESTA_ID, PROPUESTA_DESC, PROPUESTA_DESC_ALT)
    select DD_PRA_ID, DD_PRA_DESCRIPCION, DD_PRA_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRA_PROPUESTA_AAA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_PROVINCIA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_PROVINCIA where PROVINCIA_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_PROVINCIA (PROVINCIA_EXPEDIENTE_ID, PROVINCIA_EXPEDIENTE_DESC, PROVINCIA_EXPEDIENTE_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_PROVINCIA(PROVINCIA_EXPEDIENTE_ID, PROVINCIA_EXPEDIENTE_DESC, PROVINCIA_EXPEDIENTE_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_SESION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_SESION where SESION_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_SESION (SESION_ID, SESION_FECHA_INICIO, SESION_FECHA_FIN, COMITE_ID) values (-1 ,'1900-01-01', '1900-01-01', -1);
end if;

 insert into DIM_EXPEDIENTE_SESION(SESION_ID, SESION_FECHA_INICIO, SESION_FECHA_FIN, COMITE_ID)
    select SES_ID, SES_FECHA_INI, SES_FECHA_FIN, COM_ID FROM recovery_lindorff_datastage.SES_SESIONES_COMITE;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_TIPO_ITINERARIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_TIPO_ITINERARIO where TIPO_ITINERARIO_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_TIPO_ITINERARIO (TIPO_ITINERARIO_EXPEDIENTE_ID, TIPO_ITINERARIO_EXPEDIENTE_DESC, TIPO_ITINERARIO_EXPEDIENTE_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_EXPEDIENTE_TIPO_ITINERARIO(TIPO_ITINERARIO_EXPEDIENTE_ID, TIPO_ITINERARIO_EXPEDIENTE_DESC, TIPO_ITINERARIO_EXPEDIENTE_DESC_ALT)
    select DD_TIT_ID, DD_TIT_DESCRIPCION, DD_TIT_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TIT_TIPO_ITINERARIOS;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE_ZONA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_EXPEDIENTE_ZONA where ZONA_EXPEDIENTE_ID = -1) = 0) then
	insert into DIM_EXPEDIENTE_ZONA (ZONA_EXPEDIENTE_ID, ZONA_EXPEDIENTE_DESC, ZONA_EXPEDIENTE_DESC_ALT, NIVEL_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_EXPEDIENTE_ZONA(ZONA_EXPEDIENTE_ID, ZONA_EXPEDIENTE_DESC, ZONA_EXPEDIENTE_DESC_ALT, NIVEL_EXPEDIENTE_ID, OFICINA_EXPEDIENTE_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, OFI_ID FROM recovery_lindorff_datastage.ZON_ZONIFICACION;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_EXPEDIENTE
-- ----------------------------------------------------------------------------------------------
  insert into DIM_EXPEDIENTE
   (EXPEDIENTE_ID,
    EXPEDIENTE_DESC,
 -- ACTITUD_ID,
    ARQUETIPO_EXPEDIENTE_ID,
 -- CAUSA_IMPAGO_ID,
    COMITE_ID,
    DECISION_ID,
    ESTADO_EXPEDIENTE_ID,
    ESTADO_ITINERARIO_ID,
    OFICINA_EXPEDIENTE_ID
 -- PROPUESTA_ID
   )
  select EXP_ID, 
        coalesce(EXP_DESCRIPCION, 'Desconocido'),
     -- coalesce(DD_TAA_ID, -1),
        coalesce(ARQ_ID, -1),
     -- coalesce(DD_CIM_ID, -1),
        coalesce(COM_ID, -1),
        coalesce(DCO_ID, -1),
        coalesce(DD_EEX_ID, -1),
        coalesce(DD_EST_ID, -1),
        coalesce(OFI_ID, -1)
     -- coalesce(DD_PRA_ID, -1)
  from recovery_lindorff_datastage.EXP_EXPEDIENTES;


END MY_BLOCK_DIM_EXP