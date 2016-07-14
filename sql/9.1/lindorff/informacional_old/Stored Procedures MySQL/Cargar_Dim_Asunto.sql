-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_Dim_Asunto`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_ASU: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Asunto.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN ASUNTO
    -- DIM_ASUNTO_DESPACHO
    -- DIM_ASUNTO_DESPACHO_GESTOR
    -- DIM_ASUNTO_ENTIDAD_GESTOR
    -- DIM_ASUNTO_ESTADO
    -- DIM_ASUNTO_GESTOR 
    -- DIM_ASUNTO_NIVEL_DESPACHO
    -- DIM_ASUNTO_NIVEL_DESPACHO_GESTOR
    -- DIM_ASUNTO_OFICINA_DESPACHO 
    -- DIM_ASUNTO_OFICINA_DESPACHO_GESTOR
    -- DIM_ASUNTO_PROVINCIA_DESPACHO 
    -- DIM_ASUNTO_PROVINCIA_DESPACHO_GESTOR
    -- DIM_ASUNTO_TIPO_DESPACHO
    -- DIM_ASUNTO_TIPO_DESPACHO_GESTOR
    -- DIM_ASUNTO_ROL_GESTOR
    -- DIM_ASUNTO_ZONA_DESPACHO 
    -- DIM_ASUNTO_ZONA_DESPACHO_GESTOR
    -- DIM_ASUNTO_ACUERDO
    -- DIM_ASUNTO_CONTRATO_FISICO
    -- DIM_ASUNTO 


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
--                    DIM_ASUNTO_DESPACHO / DIM_ASUNTO_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_DESPACHO where DESPACHO_ID = -1) = 0) then
	insert into DIM_ASUNTO_DESPACHO (DESPACHO_ID, DESPACHO_DESC, TIPO_DESPACHO_ID, ZONA_DESPACHO_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_ASUNTO_DESPACHO(DESPACHO_ID, DESPACHO_DESC, TIPO_DESPACHO_ID, ZONA_DESPACHO_ID)
    select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1) FROM recovery_lindorff_datastage.DES_DESPACHO_EXTERNO;


if ((select count(*) from DIM_ASUNTO_DESPACHO_GESTOR where DESPACHO_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_DESPACHO_GESTOR (DESPACHO_GESTOR_ID, DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into DIM_ASUNTO_DESPACHO_GESTOR(DESPACHO_GESTOR_ID, DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_ID)
    select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1) FROM recovery_lindorff_datastage.DES_DESPACHO_EXTERNO;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO_ENTIDAD_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_ENTIDAD_GESTOR where ENTIDAD_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_ENTIDAD_GESTOR (ENTIDAD_GESTOR_ID, ENTIDAD_GESTOR_DESC) values (-1, 'Desconocido');
end if;

 insert into DIM_ASUNTO_ENTIDAD_GESTOR(ENTIDAD_GESTOR_ID, ENTIDAD_GESTOR_DESC)
    select ID, DESCRIPCION FROM recovery_lindorff_datastage.ENTIDAD;   


-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO_ESTADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_ESTADO where ESTADO_ASUNTO_ID = -1) = 0) then
	insert into DIM_ASUNTO_ESTADO (ESTADO_ASUNTO_ID, ESTADO_ASUNTO_DESC, ESTADO_ASUNTO_DESC_ALT, ESTADO_ASUNTO_AGRUPADO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_ASUNTO_ESTADO(ESTADO_ASUNTO_ID, ESTADO_ASUNTO_DESC, ESTADO_ASUNTO_DESC_ALT)
    select DD_EAS_ID, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_EAS_ESTADO_ASUNTOS;   

update DIM_ASUNTO_ESTADO set ESTADO_ASUNTO_AGRUPADO_ID = 0 where ESTADO_ASUNTO_ID in (5, 6, 9, 21);
update DIM_ASUNTO_ESTADO set ESTADO_ASUNTO_AGRUPADO_ID = 1 where ESTADO_ASUNTO_ID in (0, 3, 8);
update DIM_ASUNTO_ESTADO set ESTADO_ASUNTO_AGRUPADO_ID = 2 where ESTADO_ASUNTO_AGRUPADO_ID is null;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO_ESTADO_AGRUPADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_ESTADO_AGRUPADO where ESTADO_ASUNTO_AGRUPADO_ID = -1) = 0) then
	insert into DIM_ASUNTO_ESTADO_AGRUPADO (ESTADO_ASUNTO_AGRUPADO_ID, ESTADO_ASUNTO_AGRUPADO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_ASUNTO_ESTADO_AGRUPADO where ESTADO_ASUNTO_AGRUPADO_ID = 0) = 0) then
	insert into DIM_ASUNTO_ESTADO_AGRUPADO (ESTADO_ASUNTO_AGRUPADO_ID, ESTADO_ASUNTO_AGRUPADO_DESC) values (0 ,'Inactivo');
end if;

if ((select count(*) from DIM_ASUNTO_ESTADO_AGRUPADO where ESTADO_ASUNTO_AGRUPADO_ID = 1) = 0) then
	insert into DIM_ASUNTO_ESTADO_AGRUPADO (ESTADO_ASUNTO_AGRUPADO_ID, ESTADO_ASUNTO_AGRUPADO_DESC) values (1 ,'Activo');
end if;

if ((select count(*) from DIM_ASUNTO_ESTADO_AGRUPADO where ESTADO_ASUNTO_AGRUPADO_ID = 2) = 0) then
	insert into DIM_ASUNTO_ESTADO_AGRUPADO (ESTADO_ASUNTO_AGRUPADO_ID, ESTADO_ASUNTO_AGRUPADO_DESC) values (2 ,'Otros Estados');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO_GESTOR
-- ----------------------------------------------------------------------------------------------
 insert into DIM_ASUNTO_GESTOR(GESTOR_ID, GESTOR_NOMBRE, GESTOR_APELLIDO1, GESTOR_APELLIDO2,  ENTIDAD_GESTOR_ID, DESPACHO_GESTOR_ID)  
    select usu.USU_ID, coalesce(usu.USU_NOMBRE, 'Desconocido'), coalesce(usu.USU_APELLIDO1, 'Desconocido'), coalesce(usu.USU_APELLIDO2, 'Desconocido'), usu.ENTIDAD_ID, usd.DES_ID 
	from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
	join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID group by usu.USU_ID;


-- ----------------------------------------------------------------------------------------------
--               DIM_ASUNTO_NIVEL_DESPACHO / DIM_ASUNTO_NIVEL_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_NIVEL_DESPACHO where NIVEL_DESPACHO_ID = -1) = 0) then
	insert into DIM_ASUNTO_NIVEL_DESPACHO (NIVEL_DESPACHO_ID, NIVEL_DESPACHO_DESC, NIVEL_DESPACHO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_ASUNTO_NIVEL_DESPACHO(NIVEL_DESPACHO_ID, NIVEL_DESPACHO_DESC, NIVEL_DESPACHO_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;

if ((select count(*) from DIM_ASUNTO_NIVEL_DESPACHO_GESTOR where NIVEL_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_NIVEL_DESPACHO_GESTOR (NIVEL_DESPACHO_GESTOR_ID, NIVEL_DESPACHO_GESTOR_DESC, NIVEL_DESPACHO_GESTOR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_ASUNTO_NIVEL_DESPACHO_GESTOR(NIVEL_DESPACHO_GESTOR_ID, NIVEL_DESPACHO_GESTOR_DESC, NIVEL_DESPACHO_GESTOR_DESC_ALT)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.NIV_NIVEL;


-- ----------------------------------------------------------------------------------------------
--               DIM_ASUNTO_OFICINA_DESPACHO / DIM_ASUNTO_OFICINA_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_OFICINA_DESPACHO where OFICINA_DESPACHO_ID = -1) = 0) then
	insert into DIM_ASUNTO_OFICINA_DESPACHO (OFICINA_DESPACHO_ID, OFICINA_DESPACHO_DESC, OFICINA_DESPACHO_DESC_ALT, PROVINCIA_DESPACHO_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_ASUNTO_OFICINA_DESPACHO(OFICINA_DESPACHO_ID, OFICINA_DESPACHO_DESC, PROVINCIA_DESPACHO_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;
    
    
if ((select count(*) from DIM_ASUNTO_OFICINA_DESPACHO_GESTOR where OFICINA_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_OFICINA_DESPACHO_GESTOR (OFICINA_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_DESC, OFICINA_DESPACHO_GESTOR_DESC_ALT, PROVINCIA_DESPACHO_GESTOR_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into DIM_ASUNTO_OFICINA_DESPACHO_GESTOR(OFICINA_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_DESC, PROVINCIA_DESPACHO_GESTOR_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID FROM recovery_lindorff_datastage.OFI_OFICINAS;


-- ----------------------------------------------------------------------------------------------
--               DIM_ASUNTO_PROVINCIA_DESPACHO / DIM_ASUNTO_PROVINCIA_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_PROVINCIA_DESPACHO where PROVINCIA_DESPACHO_ID = -1) = 0) then
	insert into DIM_ASUNTO_PROVINCIA_DESPACHO (PROVINCIA_DESPACHO_ID, PROVINCIA_DESPACHO_DESC, PROVINCIA_DESPACHO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_ASUNTO_PROVINCIA_DESPACHO(PROVINCIA_DESPACHO_ID, PROVINCIA_DESPACHO_DESC, PROVINCIA_DESPACHO_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;


if ((select count(*) from DIM_ASUNTO_PROVINCIA_DESPACHO_GESTOR where PROVINCIA_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_PROVINCIA_DESPACHO_GESTOR (PROVINCIA_DESPACHO_GESTOR_ID, PROVINCIA_DESPACHO_GESTOR_DESC, PROVINCIA_DESPACHO_GESTOR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_ASUNTO_PROVINCIA_DESPACHO_GESTOR(PROVINCIA_DESPACHO_GESTOR_ID, PROVINCIA_DESPACHO_GESTOR_DESC, PROVINCIA_DESPACHO_GESTOR_DESC_ALT)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_PRV_PROVINCIA;
    
  
-- ----------------------------------------------------------------------------------------------
--              DIM_ASUNTO_TIPO_DESPACHO / DIM_ASUNTO_TIPO_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_TIPO_DESPACHO where TIPO_DESPACHO_ID = -1) = 0) then
	insert into DIM_ASUNTO_TIPO_DESPACHO (TIPO_DESPACHO_ID, TIPO_DESPACHO_DESC, TIPO_DESPACHO_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_ASUNTO_TIPO_DESPACHO(TIPO_DESPACHO_ID, TIPO_DESPACHO_DESC, TIPO_DESPACHO_DESC_ALT)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDE_TIPO_DESPACHO;

if ((select count(*) from DIM_ASUNTO_TIPO_DESPACHO_GESTOR where TIPO_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_TIPO_DESPACHO_GESTOR (TIPO_DESPACHO_GESTOR_ID, TIPO_DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_ASUNTO_TIPO_DESPACHO_GESTOR(TIPO_DESPACHO_GESTOR_ID, TIPO_DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_DESC_ALT)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TDE_TIPO_DESPACHO;
    

-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO_ROL_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_ROL_GESTOR where ROL_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_ROL_GESTOR (ROL_GESTOR_ID, ROL_GESTOR_DESC, ROL_GESTOR_DESC_ALT) values (-1 ,'Desconocido', 'Desconocido');
end if;

 insert into DIM_ASUNTO_ROL_GESTOR(ROL_GESTOR_ID, ROL_GESTOR_DESC, ROL_GESTOR_DESC_ALT)
    select DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR;


-- ----------------------------------------------------------------------------------------------
--                      DIM_ASUNTO_ZONA_DESPACHO / DIM_ASUNTO_ZONA_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_ZONA_DESPACHO where ZONA_DESPACHO_ID = -1) = 0) then
	insert into DIM_ASUNTO_ZONA_DESPACHO (ZONA_DESPACHO_ID, ZONA_DESPACHO_DESC, ZONA_DESPACHO_DESC_ALT, NIVEL_DESPACHO_ID, OFICINA_DESPACHO_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_ASUNTO_ZONA_DESPACHO(ZONA_DESPACHO_ID, ZONA_DESPACHO_DESC, ZONA_DESPACHO_DESC_ALT, NIVEL_DESPACHO_ID, OFICINA_DESPACHO_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM recovery_lindorff_datastage.ZON_ZONIFICACION;


if ((select count(*) from DIM_ASUNTO_ZONA_DESPACHO_GESTOR where ZONA_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into DIM_ASUNTO_ZONA_DESPACHO_GESTOR (ZONA_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_DESC, ZONA_DESPACHO_GESTOR_DESC_ALT, NIVEL_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_ID) values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

 insert into DIM_ASUNTO_ZONA_DESPACHO_GESTOR(ZONA_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_DESC, ZONA_DESPACHO_GESTOR_DESC_ALT, NIVEL_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1) FROM recovery_lindorff_datastage.ZON_ZONIFICACION;


/*
-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO_ACUERDO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_ACUERDO where ACUERDO_ASUNTO_ID = -1) = 0) then
	insert into DIM_ASUNTO_ACUERDO (ACUERDO_ASUNTO_ID, PROCURADOR_ASUNTO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_ASUNTO_PROCURADOR where ACUERDO_ASUNTO_ID = 0) = 0) then
	insert into DIM_ASUNTO_ACUERDO (ACUERDO_ASUNTO_ID, PROCURADOR_ASUNTO_DESC) values (0 ,'Sin acuerdo');
end if;

if ((select count(*) from DIM_ASUNTO_PROCURADOR where ACUERDO_ASUNTO_ID = 1) = 0) then
	insert into DIM_ASUNTO_ACUERDO (ACUERDO_ASUNTO_ID, PROCURADOR_ASUNTO_DESC) values (1 ,'Acuerdo activo');
end if;


-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO_CONTRATO_FISICO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from DIM_ASUNTO_CONTRATO_FISICO where CONTRATO_FISICO_ASUNTO_ID = -1) = 0) then
	insert into DIM_ASUNTO_CONTRATO_FISICO (CONTRATO_FISICO_ASUNTO_ID, CONTRATO_FISICO_ASUNTO_DESC) values (-1 ,'Desconocido');
end if;

if ((select count(*) from DIM_ASUNTO_CONTRATO_FISICO where CONTRATO_FISICO_ASUNTO_ID = 0) = 0) then
	insert into DIM_ASUNTO_CONTRATO_FISICO (CONTRATO_FISICO_ASUNTO_ID, CONTRATO_FISICO_ASUNTO_DESC) values (0 ,'No');
end if;

if ((select count(*) from DIM_ASUNTO_CONTRATO_FISICO where CONTRATO_FISICO_ASUNTO_ID = 1) = 0) then
	insert into DIM_ASUNTO_CONTRATO_FISICO (CONTRATO_FISICO_ASUNTO_ID, CONTRATO_FISICO_ASUNTO_DESC) values (1 ,'Si');
end if;

*/
-- ----------------------------------------------------------------------------------------------
--                                      DIM_ASUNTO
-- ----------------------------------------------------------------------------------------------
  insert into DIM_ASUNTO
   (ASUNTO_ID,
    NOMBRE_ASUNTO,
    EXPEDIENTE_ID
-- ACUERDO_ASUNTO_ID,
-- CONTRATO_FISICO_ASUNTO_ID
   )
  select ASU_ID,
    coalesce(ASU_NOMBRE, 'Desconocido'),
    EXP_ID
	 -- 0,
   -- 0
from recovery_lindorff_datastage.ASU_ASUNTOS where BORRADO=0;

truncate table TEMP_DESPACHO_ASUNTO;
-- Tabla temporal con los despachos de los asuntos (Despacho del usuario "Gestor")
insert into TEMP_DESPACHO_ASUNTO (ASUNTO_ID, DESPACHO_ID)
    select gaa.ASU_ID, usd.DES_ID from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd
    join recovery_lindorff_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
    join recovery_lindorff_datastage.DES_DESPACHO_EXTERNO dext on dext.DES_ID = usd.DES_ID
    join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
    where tges.DD_TGE_DESCRIPCION = 'Gestor Externo';

update DIM_ASUNTO asu set DESPACHO_ID = coalesce((select DESPACHO_ID from TEMP_DESPACHO_ASUNTO tmp where asu.ASUNTO_ID = tmp.ASUNTO_ID), -1);
/*
-- Actualizamos la existencia de procurador
update DIM_ASUNTO set PROCURADOR_ASUNTO_ID = 1 where ASU_ID IN (
	select distinct asu_id from recovery_lindorff_datastage.gaa_gestor_adicional_asunto 
	where dd_tge_id = 4 and USD_ID is not null);

-- Actulizamos la existencia de acuerdo: Estados del acuerdo en que en algún momoento estuvo activo: Aceptado, Incumplido, Cerrado.
update DIM_ASUNTO set ACUERDO_ASUNTO_ID = 1 where ASU_ID in (
	select distinct asu_id from recovery_lindorff_datastage.acu_acuerdo_procedimientos 
	where dd_eac_id in (3, 5, 6)); 

-- Actualizamos la existencia de un contrato físico
update DIM_ASUNTO set ACUERDO_ASUNTO_ID = 1 where ASU_ID in (
	select distinct asu_id from recovery_lindorff_datastage.asu_asuntos asu
		join recovery_lindorff_datastage.cex_contratos_expediente cex on asu.EXP_ID = cex.EXP_ID
		join recovery_lindorff_datastage.cnt_contratos cnt on cex.CNT_ID = cnt.CNT_ID
		join recovery_lindorff_datastage.lin_lotes_nuevos lin on cnt.CNT_CONTRATO = lin.N_CASO 
	where lin.CON_CONTRATO = 'S');
*/

END MY_BLOCK_DIM_ASU