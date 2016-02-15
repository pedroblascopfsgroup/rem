-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Asunto` $$


-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8;

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Asunto`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_ASU: BEGIN


-- ===============================================================================================
-- Autor: Enrique Jiménez, PFS Group
-- Fecha creación: Octubre 2014
-- Responsable última modificación: 
-- Fecha última modificación:
-- Motivos del cambio: 
-- Cliente: CDD 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Asunto.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN ASUNTO
    -- D_ASU_DESPACHO
    -- D_ASU_DESPACHO_GESTOR
    -- D_ASU_ENTIDAD_GESTOR
    -- D_ASU_ESTADO
    -- D_ASU_GESTOR 
    -- D_ASU_NVL_DESPACHO
    -- D_ASU_NVL_DESPACHO_GESTOR
    -- D_ASU_OFI_DESPACHO 
    -- D_ASU_OFI_DESPACHO_GESTOR
    -- D_ASU_PROV_DESPACHO 
    -- D_ASU_PROV_DESPACHO_GESTOR
    -- D_ASU_TIPO_DESPACHO
    -- D_ASU_TIPO_DESPACHO_GESTOR
    -- D_ASU_ROL_GESTOR
    -- D_ASU_ZONA_DESPACHO 
    -- D_ASU_ZONA_DESPACHO_GESTOR
    -- D_ASU 

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
--                  D_ASU_DESPACHO / D_ASU_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
 
insert into D_ENTIDAD_CEDENTE(ENTIDAD_CEDENTE_ID, ENTIDAD_CEDENTE_DESC, ENTIDAD_CEDENTE_DESC_ALT)
	select -1, 'Desconocido', 'Desconocido' 
	FROM DUAL
	UNION 	
	select 1, 'ABANCA', 'ABANCA' 
	FROM DUAL
	UNION 
	select 2, 'BBVA', 'BBVA'
	FROM DUAL
	UNION 
	select 3, 'BANKIA', 'BANKIA' 
	FROM DUAL
	UNION 
	select 4, 'CAJAMAR', 'CAJAMAR' 
	FROM DUAL
; 

 
-- ----------------------------------------------------------------------------------------------
--                  D_ASU_DESPACHO / D_ASU_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_DESPACHO where DESPACHO_ID = -1) = 0) then
	insert into D_ASU_DESPACHO (DESPACHO_ID, DESPACHO_DESC, TIPO_DESPACHO_ID, ZONA_DESPACHO_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, -1, -1);
end if;

insert into D_ASU_DESPACHO(DESPACHO_ID, DESPACHO_DESC, TIPO_DESPACHO_ID, ZONA_DESPACHO_ID, ENTIDAD_CEDENTE_ID)
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 1 
	FROM bi_cdd_bng_datastage.DES_DESPACHO_EXTERNO
	UNION 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 2
	FROM bi_cdd_bbva_datastage.DES_DESPACHO_EXTERNO
	UNION 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 3 
	FROM bi_cdd_bankia_datastage.DES_DESPACHO_EXTERNO
	UNION 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 4
	FROM bi_cdd_cajamar_datastage.DES_DESPACHO_EXTERNO	
;


if ((select count(*) from D_ASU_DESPACHO_GESTOR where DESPACHO_GESTOR_ID = -1) = 0) then
	insert into D_ASU_DESPACHO_GESTOR (DESPACHO_GESTOR_ID, DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, -1, -1);
end if;

insert into D_ASU_DESPACHO_GESTOR(DESPACHO_GESTOR_ID, DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_ID, ENTIDAD_CEDENTE_ID)
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 1 
	FROM bi_cdd_bng_datastage.DES_DESPACHO_EXTERNO
	UNION 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 2 
	FROM bi_cdd_bbva_datastage.DES_DESPACHO_EXTERNO
	UNION 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 3
	FROM bi_cdd_bankia_datastage.DES_DESPACHO_EXTERNO
	UNION 
	select DES_ID, DES_DESPACHO, coalesce(DD_TDE_ID, -1), coalesce(ZON_ID, -1), 4
	FROM bi_cdd_cajamar_datastage.DES_DESPACHO_EXTERNO	
;



-- ----------------------------------------------------------------------------------------------
--                                          D_ASU_ENTIDAD_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_ENTIDAD_GESTOR where ENTIDAD_GESTOR_ID = -1) = 0) then
	insert into D_ASU_ENTIDAD_GESTOR (ENTIDAD_GESTOR_ID, ENTIDAD_GESTOR_DESC, ENTIDAD_CEDENTE_ID) values (-1, 'Desconocido', -1);
end if;

insert into D_ASU_ENTIDAD_GESTOR(ENTIDAD_GESTOR_ID, ENTIDAD_GESTOR_DESC, ENTIDAD_CEDENTE_ID)
	SELECT  (@rownum:=@rownum+1) AS rownum, DESCRIPCION, ENTIDAD FROM (
	select  (@rownum:=0) r, DESCRIPCION, 1 ENTIDAD FROM bi_cdd_bng_datastage.ENTIDAD   
	UNION 
	select (@rownum:=0) r, DESCRIPCION, 2 ENTIDAD FROM bi_cdd_bbva_datastage.ENTIDAD
	UNION 
	select (@rownum:=0) r, DESCRIPCION, 2 ENTIDAD FROM bi_cdd_bankia_datastage.ENTIDAD
	UNION 
	select (@rownum:=0) r, DESCRIPCION, 3 ENTIDAD FROM bi_cdd_cajamar_datastage.ENTIDAD	
) DD;


-- ----------------------------------------------------------------------------------------------
--                                        D_ASU_ESTADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_ESTADO where ESTADO_ASUNTO_ID = -1) = 0) then
	insert into D_ASU_ESTADO (ESTADO_ASUNTO_ID, ESTADO_ASUNTO_DESC, ESTADO_ASUNTO_DESC_ALT, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_ESTADO(ESTADO_ASUNTO_ID, ESTADO_ASUNTO_DESC, ESTADO_ASUNTO_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select DD_EAS_ID, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_EAS_ESTADO_ASUNTOS  
	UNION 
	select DD_EAS_ID, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, 2
	FROM bi_cdd_bbva_datastage.DD_EAS_ESTADO_ASUNTOS
	UNION 
	select DD_EAS_ID, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_EAS_ESTADO_ASUNTOS
	UNION 
	select DD_EAS_ID, DD_EAS_DESCRIPCION, DD_EAS_DESCRIPCION_LARGA, 4
	FROM bi_cdd_cajamar_datastage.DD_EAS_ESTADO_ASUNTOS
;


-- ----------------------------------------------------------------------------------------------
--             <<OK>>                          D_ASU_GESTOR
-- ----------------------------------------------------------------------------------------------
insert into D_ASU_GESTOR(GESTOR_ID, GESTOR_NOMBRE, GESTOR_APELLIDO1, GESTOR_APELLIDO2,  ENTIDAD_GESTOR_ID, DESPACHO_GESTOR_ID, ENTIDAD_CEDENTE_ID)  
	select 	usu.USU_ID, 
			coalesce(usu.USU_NOMBRE, 'Desconocido'), 
			coalesce(usu.USU_APELLIDO1, 'Desconocido'), 
			coalesce(usu.USU_APELLIDO2, 'Desconocido', 'Desconocido'), 
			usu.ENTIDAD_ID, 
			usd.DES_ID , 
			1
	from bi_cdd_bng_datastage.USD_USUARIOS_DESPACHOS usd 
		join bi_cdd_bng_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID 
	group by usu.USU_ID
	UNION
	SELECT 	usu2.USU_ID, 
			coalesce(usu2.USU_NOMBRE, 'Desconocido'), 
			coalesce(usu2.USU_APELLIDO1, 'Desconocido'), 
			coalesce(usu2.USU_APELLIDO2, 'Desconocido', 'Desconocido'), 
			usu2.ENTIDAD_ID, 
			usd2.DES_ID, 
			2 
	from bi_cdd_bbva_datastage.USD_USUARIOS_DESPACHOS usd2 
		join bi_cdd_bbva_datastage.USU_USUARIOS usu2 on usd2.USU_ID = usu2.USU_ID 
	group by usu2.USU_ID
	UNION
	SELECT 	usu3.USU_ID, 
			coalesce(usu3.USU_NOMBRE, 'Desconocido'), 
			coalesce(usu3.USU_APELLIDO1, 'Desconocido'), 
			coalesce(usu3.USU_APELLIDO2, 'Desconocido', 'Desconocido'), 
			usu3.ENTIDAD_ID, 
			usd3.DES_ID, 
			3 
	from bi_cdd_bankia_datastage.USD_USUARIOS_DESPACHOS usd3 
		join bi_cdd_bankia_datastage.USU_USUARIOS usu3 on usd3.USU_ID = usu3.USU_ID 
	group by usu3.USU_ID	
	UNION
	SELECT 	usu4.USU_ID, 
			coalesce(usu4.USU_NOMBRE, 'Desconocido'), 
			coalesce(usu4.USU_APELLIDO1, 'Desconocido'), 
			coalesce(usu4.USU_APELLIDO2, 'Desconocido', 'Desconocido'), 
			usu4.ENTIDAD_ID, 
			usd4.DES_ID, 
			4 
	from bi_cdd_cajamar_datastage.USD_USUARIOS_DESPACHOS usd4 
		join bi_cdd_cajamar_datastage.USU_USUARIOS usu4 on usd4.USU_ID = usu4.USU_ID 
	group by usu4.USU_ID	
;


-- ----------------------------------------------------------------------------------------------
--         <<OK>>        D_ASU_NVL_DESPACHO / D_ASU_NVL_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_NVL_DESPACHO where NIVEL_DESPACHO_ID = -1) = 0) then
	insert into D_ASU_NVL_DESPACHO (NIVEL_DESPACHO_ID, NIVEL_DESPACHO_DESC, NIVEL_DESPACHO_DESC_ALT, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_NVL_DESPACHO(NIVEL_DESPACHO_ID, NIVEL_DESPACHO_DESC, NIVEL_DESPACHO_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.NIV_NIVEL
	UNION
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 2 
    FROM bi_cdd_bbva_datastage.NIV_NIVEL
	UNION
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 3 
    FROM bi_cdd_bankia_datastage.NIV_NIVEL
	UNION
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 4 
    FROM bi_cdd_cajamar_datastage.NIV_NIVEL
;


if ((select count(*) from D_ASU_NVL_DESPACHO_GESTOR where NIVEL_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into D_ASU_NVL_DESPACHO_GESTOR (NIVEL_DESPACHO_GESTOR_ID, NIVEL_DESPACHO_GESTOR_DESC, NIVEL_DESPACHO_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID)
	 values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_NVL_DESPACHO_GESTOR(NIVEL_DESPACHO_GESTOR_ID, NIVEL_DESPACHO_GESTOR_DESC, NIVEL_DESPACHO_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.NIV_NIVEL
	UNION
	select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.NIV_NIVEL
	UNION
	select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.NIV_NIVEL
	UNION
	select NIV_ID, NIV_DESCRIPCION, NIV_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.NIV_NIVEL
;


-- ----------------------------------------------------------------------------------------------
--         <<OK>>        D_ASU_OFI_DESPACHO / D_ASU_OFI_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_OFI_DESPACHO where OFICINA_DESPACHO_ID = -1) = 0) then	
	insert into D_ASU_OFI_DESPACHO (OFICINA_DESPACHO_ID, OFICINA_DESPACHO_DESC, OFICINA_DESPACHO_DESC_ALT, PROVINCIA_DESPACHO_ID, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

insert into D_ASU_OFI_DESPACHO(OFICINA_DESPACHO_ID, OFICINA_DESPACHO_DESC, PROVINCIA_DESPACHO_ID, ENTIDAD_CEDENTE_ID)
	select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 1 
	FROM bi_cdd_bng_datastage.OFI_OFICINAS
	UNION
	select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 2 
	FROM bi_cdd_bbva_datastage.OFI_OFICINAS
	UNION
	select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 3 
	FROM bi_cdd_bankia_datastage.OFI_OFICINAS
	UNION
	select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 4 
	FROM bi_cdd_cajamar_datastage.OFI_OFICINAS		
;
    
    
if ((select count(*) from D_ASU_OFI_DESPACHO_GESTOR where OFICINA_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into D_ASU_OFI_DESPACHO_GESTOR (OFICINA_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_DESC, OFICINA_DESPACHO_GESTOR_DESC_ALT, PROVINCIA_DESPACHO_GESTOR_ID, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1, -1);
end if;

insert into D_ASU_OFI_DESPACHO_GESTOR(OFICINA_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_DESC, PROVINCIA_DESPACHO_GESTOR_ID, ENTIDAD_CEDENTE_ID)
    select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 1 
    FROM bi_cdd_bng_datastage.OFI_OFICINAS
	UNION
	select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 2 
	FROM bi_cdd_bbva_datastage.OFI_OFICINAS
	UNION
	select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 3 
	FROM bi_cdd_bankia_datastage.OFI_OFICINAS
	UNION
	select OFI_ID, OFI_NOMBRE, DD_PRV_ID, 4 
	FROM bi_cdd_cajamar_datastage.OFI_OFICINAS	
;


-- ----------------------------------------------------------------------------------------------
--       <<OK>>        D_ASU_PROV_DESPACHO / D_ASU_PROV_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_PROV_DESPACHO where PROVINCIA_DESPACHO_ID = -1) = 0) then
	insert into D_ASU_PROV_DESPACHO (PROVINCIA_DESPACHO_ID, PROVINCIA_DESPACHO_DESC, PROVINCIA_DESPACHO_DESC_ALT, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_PROV_DESPACHO(PROVINCIA_DESPACHO_ID, PROVINCIA_DESPACHO_DESC, PROVINCIA_DESPACHO_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_PRV_PROVINCIA
	UNION 
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 2 
    FROM bi_cdd_bbva_datastage.DD_PRV_PROVINCIA
	UNION 
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 3 
    FROM bi_cdd_bankia_datastage.DD_PRV_PROVINCIA
	UNION 
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 4 
    FROM bi_cdd_cajamar_datastage.DD_PRV_PROVINCIA        
;

if ((select count(*) from D_ASU_PROV_DESPACHO_GESTOR where PROVINCIA_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into D_ASU_PROV_DESPACHO_GESTOR (PROVINCIA_DESPACHO_GESTOR_ID, PROVINCIA_DESPACHO_GESTOR_DESC, PROVINCIA_DESPACHO_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_PROV_DESPACHO_GESTOR(PROVINCIA_DESPACHO_GESTOR_ID, PROVINCIA_DESPACHO_GESTOR_DESC, PROVINCIA_DESPACHO_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_PRV_PROVINCIA
	UNION
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 2 
    FROM bi_cdd_bbva_datastage.DD_PRV_PROVINCIA
	UNION
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 3 
    FROM bi_cdd_bankia_datastage.DD_PRV_PROVINCIA
	UNION
    select DD_PRV_ID, DD_PRV_DESCRIPCION, DD_PRV_DESCRIPCION_LARGA, 4 
    FROM bi_cdd_cajamar_datastage.DD_PRV_PROVINCIA
;
    
  
-- ----------------------------------------------------------------------------------------------
--          <<OK>>     D_ASU_TIPO_DESPACHO / D_ASU_TIPO_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_TIPO_DESPACHO where TIPO_DESPACHO_ID = -1) = 0) then
	insert into D_ASU_TIPO_DESPACHO (TIPO_DESPACHO_ID, TIPO_DESPACHO_DESC, TIPO_DESPACHO_DESC_ALT, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_TIPO_DESPACHO(TIPO_DESPACHO_ID, TIPO_DESPACHO_DESC, TIPO_DESPACHO_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TDE_TIPO_DESPACHO		
;

if ((select count(*) from D_ASU_TIPO_DESPACHO_GESTOR where TIPO_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into D_ASU_TIPO_DESPACHO_GESTOR (TIPO_DESPACHO_GESTOR_ID, TIPO_DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_TIPO_DESPACHO_GESTOR(TIPO_DESPACHO_GESTOR_ID, TIPO_DESPACHO_GESTOR_DESC, TIPO_DESPACHO_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TDE_TIPO_DESPACHO
	UNION
	select DD_TDE_ID, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TDE_TIPO_DESPACHO
;
    
-- ----------------------------------------------------------------------------------------------
--              <<OK>>                         D_ASU_ROL_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_ROL_GESTOR where ROL_GESTOR_ID = -1) = 0) then
	insert into D_ASU_ROL_GESTOR (ROL_GESTOR_ID, ROL_GESTOR_DESC, ROL_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_ASU_ROL_GESTOR(ROL_GESTOR_ID, ROL_GESTOR_DESC, ROL_GESTOR_DESC_ALT, ENTIDAD_CEDENTE_ID)
    select DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, 1 
    FROM bi_cdd_bng_datastage.DD_TGE_TIPO_GESTOR
	UNION
	select DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, 2 
	FROM bi_cdd_bbva_datastage.DD_TGE_TIPO_GESTOR
	UNION
	select DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, 3 
	FROM bi_cdd_bankia_datastage.DD_TGE_TIPO_GESTOR
	UNION
	select DD_TGE_ID, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA, 4 
	FROM bi_cdd_cajamar_datastage.DD_TGE_TIPO_GESTOR
;


-- ----------------------------------------------------------------------------------------------
--                      D_ASU_ZONA_DESPACHO / D_ASU_ZONA_DESPACHO_GESTOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_ASU_ZONA_DESPACHO where ZONA_DESPACHO_ID = -1) = 0) then
	insert into D_ASU_ZONA_DESPACHO (ZONA_DESPACHO_ID, ZONA_DESPACHO_DESC, ZONA_DESPACHO_DESC_ALT, NIVEL_DESPACHO_ID, OFICINA_DESPACHO_ID, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1, -1, -1);
end if;

insert into D_ASU_ZONA_DESPACHO(ZONA_DESPACHO_ID, ZONA_DESPACHO_DESC, ZONA_DESPACHO_DESC_ALT, NIVEL_DESPACHO_ID, OFICINA_DESPACHO_ID, ENTIDAD_CEDENTE_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 1 
    FROM bi_cdd_bng_datastage.ZON_ZONIFICACION
	UNION
	select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 2 
	FROM bi_cdd_bbva_datastage.ZON_ZONIFICACION
	UNION
	select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 3 
	FROM bi_cdd_bankia_datastage.ZON_ZONIFICACION
	UNION
	select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 4 
	FROM bi_cdd_cajamar_datastage.ZON_ZONIFICACION
;


if ((select count(*) from D_ASU_ZONA_DESPACHO_GESTOR where ZONA_DESPACHO_GESTOR_ID = -1) = 0) then
	insert into D_ASU_ZONA_DESPACHO_GESTOR (ZONA_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_DESC, ZONA_DESPACHO_GESTOR_DESC_ALT, NIVEL_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_ID, ENTIDAD_CEDENTE_ID) 
	values (-1 ,'Desconocido', 'Desconocido', -1, -1, -1);
end if;

insert into D_ASU_ZONA_DESPACHO_GESTOR(ZONA_DESPACHO_GESTOR_ID, ZONA_DESPACHO_GESTOR_DESC, ZONA_DESPACHO_GESTOR_DESC_ALT, NIVEL_DESPACHO_GESTOR_ID, OFICINA_DESPACHO_GESTOR_ID, ENTIDAD_CEDENTE_ID)
    select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 1 
    FROM bi_cdd_bng_datastage.ZON_ZONIFICACION	
	UNION
	select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 2 
	FROM bi_cdd_bbva_datastage.ZON_ZONIFICACION
	UNION
	select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 3 
	FROM bi_cdd_bankia_datastage.ZON_ZONIFICACION
	UNION
	select ZON_ID, ZON_DESCRIPCION, ZON_DESCRIPCION_LARGA, NIV_ID, coalesce(OFI_ID, -1), 4 
	FROM bi_cdd_cajamar_datastage.ZON_ZONIFICACION		
;

-- ----------------------------------------------------------------------------------------------
--                                      D_ASU
-- ----------------------------------------------------------------------------------------------
  insert into D_ASU
   (ASUNTO_ID,
    NOMBRE_ASUNTO,
    ESTADO_ASUNTO_ID,
    EXPEDIENTE_ID,
	ENTIDAD_CEDENTE_ID
   )
  select ASU_ID,
    coalesce(ASU_NOMBRE, 'Desconocido'),
    DD_EAS_ID,
    EXP_ID,
	1
  from bi_cdd_bng_datastage.ASU_ASUNTOS 
  where BORRADO=0
  UNION
  select ASU_ID,
    coalesce(ASU_NOMBRE, 'Desconocido'),
    DD_EAS_ID,
    EXP_ID,
	2
  from bi_cdd_bbva_datastage.ASU_ASUNTOS 
  where BORRADO=0
  UNION
  select ASU_ID,
    coalesce(ASU_NOMBRE, 'Desconocido'),
    DD_EAS_ID,
    EXP_ID,
	3
  from bi_cdd_bankia_datastage.ASU_ASUNTOS 
  where BORRADO=0
  UNION
  select ASU_ID,
    coalesce(ASU_NOMBRE, 'Desconocido'),
    DD_EAS_ID,
    EXP_ID,
	4
  from bi_cdd_cajamar_datastage.ASU_ASUNTOS 
  where BORRADO=0    
;



truncate table TEMP_DESPACHO_ASUNTO;


-- Tabla temporal con los despachos de los asuntos (Despacho del usuario "Gestor")
insert into TEMP_DESPACHO_ASUNTO (ASUNTO_ID, DESPACHO_ID)
    select gaa.ASU_ID, usd.DES_ID 
	from bi_cdd_bng_datastage.USD_USUARIOS_DESPACHOS usd
		join bi_cdd_bng_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_bng_datastage.DES_DESPACHO_EXTERNO dext on dext.DES_ID = usd.DES_ID
		join bi_cdd_bng_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
    where tges.DD_TGE_DESCRIPCION = 'Gestor'
union    
	select gaa.ASU_ID, usd.DES_ID 
	from bi_cdd_bbva_datastage.USD_USUARIOS_DESPACHOS usd
		join bi_cdd_bbva_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_bbva_datastage.DES_DESPACHO_EXTERNO dext on dext.DES_ID = usd.DES_ID
		join bi_cdd_bbva_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
    where tges.DD_TGE_DESCRIPCION = 'Gestor'
union    
	select gaa.ASU_ID, usd.DES_ID 
	from bi_cdd_bankia_datastage.USD_USUARIOS_DESPACHOS usd
		join bi_cdd_bankia_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_bankia_datastage.DES_DESPACHO_EXTERNO dext on dext.DES_ID = usd.DES_ID
		join bi_cdd_bankia_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
    where tges.DD_TGE_DESCRIPCION = 'Gestor'
union    
	select gaa.ASU_ID, usd.DES_ID 
	from bi_cdd_cajamar_datastage.USD_USUARIOS_DESPACHOS usd
		join bi_cdd_cajamar_datastage.GAA_GESTOR_ADICIONAL_ASUNTO gaa on gaa.USD_ID = usd.USD_ID
		join bi_cdd_cajamar_datastage.DES_DESPACHO_EXTERNO dext on dext.DES_ID = usd.DES_ID
		join bi_cdd_cajamar_datastage.DD_TGE_TIPO_GESTOR tges on gaa.DD_TGE_ID = tges.DD_TGE_ID
    where tges.DD_TGE_DESCRIPCION = 'Gestor'        
;

update D_ASU asu set asu.DESPACHO_ID = coalesce((select DESPACHO_ID from TEMP_DESPACHO_ASUNTO tmp where asu.ASUNTO_ID = tmp.ASUNTO_ID), -1);


END MY_BLOCK_DIM_ASU
