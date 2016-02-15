-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_Dim_Expediente` $$


-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_Dim_Expediente`(OUT o_error_status varchar(500))
MY_BLOCK_DIM_EXP: BEGIN


-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que carga las tablas de la dimensión Expediente.
-- ===============================================================================================
 
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- DIMENSIÓN EXPEDIENTE 
  -- D_EXP_CEDENTE
	-- D_EXP_PROVEEDOR
	-- D_EXP_EST_ENTRADA
	-- D_EXP_EST_HERRAMIENTA
	-- D_EXP_FASE
	-- D_EXP_EST_VIDA
	-- D_EXP_EST_GESTION
	-- D_EXP_MOTIVO_FACTURA
	-- D_EXP_MOTIVO_KO
	-- D_EXP_TIPO_KO
	-- D_EXP_PROCURADOR
	-- D_EXP_TIPO_PROCEDIMIENTO
	-- D_EXP_PLAZA
	-- D_EXP_JUZGADO
	-- D_EXP_EST_FACTURA
	-- D_EXP_FACTURA
	-- D_EXP_EST_CONEXP
	-- D_EXP_SITUACION
	-- D_EXP

-- ===============================================================================================
 
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
--                                      D_EXP_ACTITUD
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_CEDENTE where CEDENTE_ID = -1) = 0) then
	insert into D_EXP_CEDENTE (CEDENTE_ID, CEDENTE_DESC, ENTIDAD_CEDENTE_ID) values (-1 , 'Desconocido', -1);
end if;


 insert into D_EXP_CEDENTE(CEDENTE_ID, CEDENTE_DESC, ENTIDAD_CEDENTE_ID)
    select distinct cce.CCE_ID, cce.CCE_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID FROM bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce
    										inner join (select 
																ENTIDAD_CEDENTE_ID,
																case
																when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																ELSE ENTIDAD_CEDENTE_DESC
																end cedente_conexp
														from D_ENTIDAD_CEDENTE
														) ccx ON trim(cce.cce_descripcion) = trim(ccx.cedente_conexp)
    											;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PROVEEDOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_PROVEEDOR where PROVEEDOR_ID = -1) = 0) then
	insert into D_EXP_PROVEEDOR (PROVEEDOR_ID, PROVEEDOR_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_PROVEEDOR(PROVEEDOR_ID, PROVEEDOR_DESC, ENTIDAD_CEDENTE_ID)
    select distinct pex.PEX_ID, pex.PEX_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.PEX_PROVEEDOR_EXPEDIENTE pex on exp.pex_id = pex.pex_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_EST_ENTRADA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_EST_ENTRADA where EST_ENTRADA_ID = -1) = 0) then
	insert into D_EXP_EST_ENTRADA (EST_ENTRADA_ID, EST_ENTRADA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_EST_ENTRADA(EST_ENTRADA_ID, EST_ENTRADA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct een.EEN_ID, een.EEN_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID 
    														FROM bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.EEN_ESTADO_ENTRADA een on exp.een_id = een.een_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_EST_HERRAMIENTA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_EST_HERRAMIENTA where EST_HERRAMIENTA_ID = -1) = 0) then
	insert into D_EXP_EST_HERRAMIENTA (EST_HERRAMIENTA_ID, EST_HERRAMIENTA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_EST_HERRAMIENTA(EST_HERRAMIENTA_ID, EST_HERRAMIENTA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct ehc.EHC_ID, ehc.EHC_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID 
    													FROM bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.EHC_ESTADO_HERRAMIENTA_CLIENTE ehc on exp.ehc_id = ehc.ehc_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_FASE
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_FASE where FASE_ID = -1) = 0) then
	insert into D_EXP_FASE (FASE_ID, FASE_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_FASE(FASE_ID, FASE_DESC, ENTIDAD_CEDENTE_ID)
    select distinct fae.FAE_ID, fae.FAE_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													FROM bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.FAE_FASE_EXPEDIENTE fae on exp.fae_id = fae.fae_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);



-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_EST_VIDA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_EST_VIDA where EST_VIDA_ID = -1) = 0) then
	insert into D_EXP_EST_VIDA (EST_VIDA_ID, EST_VIDA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_EST_VIDA(EST_VIDA_ID, EST_VIDA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct ecv.ECV_ID, ecv.ECV_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													FROM bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.ECV_ESTADO_VIDA_EXPEDIENTE ecv on exp.ecv_id = ecv.ecv_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_EST_GESTION
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_EST_GESTION where EST_GESTION_ID = -1) = 0) then
	insert into D_EXP_EST_GESTION (EST_GESTION_ID, EST_GESTION_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_EST_GESTION(EST_GESTION_ID, EST_GESTION_DESC, ENTIDAD_CEDENTE_ID)
    select distinct ege.EGE_ID, ege.EGE_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													FROM bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.EGE_ESTADO_GESTION_EXPEDIENTE ege on exp.ege_id = ege.ege_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_MOTIVO_FACTURA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_MOTIVO_FACTURA where MOTIVO_FACTURA_ID = -1) = 0) then
	insert into D_EXP_MOTIVO_FACTURA (MOTIVO_FACTURA_ID, MOTIVO_FACTURA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_MOTIVO_FACTURA(MOTIVO_FACTURA_ID, MOTIVO_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct mof.MOF_ID, mof.MOF_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													FROM bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.MOF_MOTIVO_FACTURA mof on exp.mof_id = mof.mof_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_MOTIVO_KO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_MOTIVO_KO where MOTIVO_KO_ID = -1) = 0) then
	insert into D_EXP_MOTIVO_KO (MOTIVO_KO_ID, MOTIVO_KO_DESC, TIPO_KO_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into D_EXP_MOTIVO_KO(MOTIVO_KO_ID, MOTIVO_KO_DESC,TIPO_KO_ID, ENTIDAD_CEDENTE_ID)
    select distinct mko.MKO_ID, mko.MKO_DESCRIPCION, mko.TKO_ID, ccx.ENTIDAD_CEDENTE_ID
    															from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																	inner join bi_cdd_conexp_datastage.GKO_GESTION_KO gko on gko.exp_id = exp.exp_id
																	inner join bi_cdd_conexp_datastage.MKO_MOTIVO_KO mko on mko.mko_id = gko.mko_id
																	inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																	inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																			ENTIDAD_CEDENTE_ID,
																			case
																			when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																			when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																			when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																			when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																			ELSE ENTIDAD_CEDENTE_DESC
																			end cedente_conexp
																	from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																	) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp);

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_KO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_TIPO_KO where TIPO_KO_ID = -1) = 0) then
	insert into D_EXP_TIPO_KO (TIPO_KO_ID, TIPO_KO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_TIPO_KO(TIPO_KO_ID, TIPO_KO_DESC, ENTIDAD_CEDENTE_ID)
    select distinct tko.TKO_ID, tko.TKO_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.GKO_GESTION_KO gko on gko.exp_id = exp.exp_id
																inner join bi_cdd_conexp_datastage.MKO_MOTIVO_KO mko on mko.mko_id = gko.mko_id
																inner join bi_cdd_conexp_datastage.TKO_TIPO_KO tko on tko.tko_id = mko.tko_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
															inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
															;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PROCURADOR
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_PROCURADOR where PROCURADOR_ID = -1) = 0) then
	insert into D_EXP_PROCURADOR (PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_PROCURADOR(PROCURADOR_ID, PROCURADOR_NOMBRE, ENTIDAD_CEDENTE_ID)
    select distinct ppr.PPR_ID, ppr.PPR_NOMBRE, ccx.ENTIDAD_CEDENTE_ID
    													from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																inner join bi_cdd_conexp_datastage.PPR_PROCURADOR ppr on ppr.ppr_id = dej.ppr_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;
															


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIPO_PROCEDIMIENTO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_TIPO_PROCEDIMIENTO where TIPO_PROCEDIMIENTO_ID = -1) = 0) then
	insert into D_EXP_TIPO_PROCEDIMIENTO (TIPO_PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_TIPO_PROCEDIMIENTO(TIPO_PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_DESC, ENTIDAD_CEDENTE_ID)
    select distinct tpr.TPR_ID, tpr.TPR_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																	inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																	inner join bi_cdd_conexp_datastage.TPR_TIPO_PROCEDIMIENTO tpr on tpr.tpr_id = dej.tpr_id
																	inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																	inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																			ENTIDAD_CEDENTE_ID,
																			case
																			when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																			when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																			when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																			when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																			ELSE ENTIDAD_CEDENTE_DESC
																			end cedente_conexp
																	from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																	) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PLAZA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_PLAZA where PLAZA_ID = -1) = 0) then
	insert into D_EXP_PLAZA (PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

 insert into D_EXP_PLAZA(PLAZA_ID, PLAZA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct pla.PLA_ID, pla.PLA_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																inner join bi_cdd_conexp_datastage.PLA_PLAZAS pla on pla.pla_id = dej.pla_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PLAZA_UNICO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_PLAZA_UNICO where PLAZA_UNICO_ID = -1) = 0) then
	insert into D_EXP_PLAZA_UNICO (PLAZA_UNICO_ID, PLAZA_UNICO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

if ((select count(*) from D_EXP_PLAZA_UNICO where PLAZA_UNICO_ID = -2 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZA_UNICO (PLAZA_UNICO_ID, PLAZA_UNICO_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Varias Plazas', 1);
end if;
if ((select count(*) from D_EXP_PLAZA_UNICO where PLAZA_UNICO_ID = -2 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZA_UNICO (PLAZA_UNICO_ID, PLAZA_UNICO_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Varias Plazas', 2);
end if;
if ((select count(*) from D_EXP_PLAZA_UNICO where PLAZA_UNICO_ID = -2 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZA_UNICO (PLAZA_UNICO_ID, PLAZA_UNICO_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Varias Plazas', 3);
end if;
if ((select count(*) from D_EXP_PLAZA_UNICO where PLAZA_UNICO_ID = -2 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZA_UNICO (PLAZA_UNICO_ID, PLAZA_UNICO_DESC, ENTIDAD_CEDENTE_ID) values (-2 ,'Varias Plazas', 4);
end if;

insert into D_EXP_PLAZA_UNICO(PLAZA_UNICO_ID, PLAZA_UNICO_DESC, ENTIDAD_CEDENTE_ID)
    select distinct pla.PLA_ID, pla.PLA_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    													from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																inner join bi_cdd_conexp_datastage.PLA_PLAZAS pla on pla.pla_id = dej.pla_id
																inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																		ENTIDAD_CEDENTE_ID,
																		case
																		when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																		when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																		when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																		when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																		ELSE ENTIDAD_CEDENTE_DESC
																		end cedente_conexp
																from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;																
																
																
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_JUZGADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_JUZGADO where JUZGADO_ID = -1) = 0) then
	insert into D_EXP_JUZGADO (JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1, -1);
end if;

 insert into D_EXP_JUZGADO(JUZGADO_ID, JUZGADO_DESC, PLAZA_ID, ENTIDAD_CEDENTE_ID)
    select distinct juz.JUZ_ID, juz.JUZ_DESCRIPCION, juz.PLA_ID, ccx.ENTIDAD_CEDENTE_ID
																    from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																	inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on dej.exp_id = exp.exp_id
																	inner join bi_cdd_conexp_datastage.PLA_PLAZAS pla on pla.pla_id = dej.pla_id
																	inner join bi_cdd_conexp_datastage.JUZ_JUZGADOS juz on juz.pla_id = pla.pla_id
																	inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																	inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																inner join (select 
																			ENTIDAD_CEDENTE_ID,
																			case
																			when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																			when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																			when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																			when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																			ELSE ENTIDAD_CEDENTE_DESC
																			end cedente_conexp
																	from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																	) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_EST_FACTURA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_EST_FACTURA where EST_FACTURA_ID = -1) = 0) then
	insert into D_EXP_EST_FACTURA (EST_FACTURA_ID, EST_FACTURA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;
if ((select count(*) from D_EXP_EST_FACTURA where EST_FACTURA_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_FACTURA (EST_FACTURA_ID, EST_FACTURA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 1);
end if;
if ((select count(*) from D_EXP_EST_FACTURA where EST_FACTURA_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_FACTURA (EST_FACTURA_ID, EST_FACTURA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 2);
end if;
if ((select count(*) from D_EXP_EST_FACTURA where EST_FACTURA_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_FACTURA (EST_FACTURA_ID, EST_FACTURA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 3);
end if;
if ((select count(*) from D_EXP_EST_FACTURA where EST_FACTURA_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_FACTURA (EST_FACTURA_ID, EST_FACTURA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 4);
end if;


 insert into D_EXP_EST_FACTURA(EST_FACTURA_ID, EST_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct efa.EFA_ID, efa.EFA_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
    												from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																	inner join bi_cdd_conexp_datastage.FAC_FACTURACION fac on fac.exp_id = exp.exp_id
																	inner join bi_cdd_conexp_datastage.EFA_ESTADO_FACTURACION efa on efa.efa_id = fac.efa_id
																	inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																	inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																	inner join (select 
																				ENTIDAD_CEDENTE_ID,
																				case
																				when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																	when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																	when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																	when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																				ELSE ENTIDAD_CEDENTE_DESC
																				end cedente_conexp
																		from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																		) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																	;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_FACTURA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_FACTURA where FACTURA_ID = -1) = 0) then
	insert into D_EXP_FACTURA (FACTURA_ID, FACTURA_NUM_FAC, FACTURA_CONCEPTO, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

 insert into D_EXP_FACTURA(FACTURA_ID, FACTURA_NUM_FAC, FACTURA_CONCEPTO, ENTIDAD_CEDENTE_ID)
    select distinct fac.FAC_ID, fac.FAC_NUM_FACTURA, fac.FAC_CONCEPTO, ccx.ENTIDAD_CEDENTE_ID
    												from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
																	inner join bi_cdd_conexp_datastage.FAC_FACTURACION fac on fac.exp_id = exp.exp_id
																	inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
																	inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
																	inner join (select 
																				ENTIDAD_CEDENTE_ID,
																				case
																				when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
																	when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
																	when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
																	when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
																				ELSE ENTIDAD_CEDENTE_DESC
																				end cedente_conexp
																		from bi_cdd_dwh.D_ENTIDAD_CEDENTE
																		) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
																	;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_EST_CONEXP
-- ----------------------------------------------------------------------------------------------
-- ABANCA = 1
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'En Curso', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'KO y Paralizado', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Enviado a Procurador', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 4 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Demanda Interpuesta', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 5 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Facturado', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 6 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 6 ,'Anulado', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 7 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 7 ,'Devuelto', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 8 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 8 ,'Insinuacion', 1;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 9 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 9 ,'Pdte. Insinuacion', 1;
end if;


-- BBVA = 2
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'En Curso', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'KO y Paralizado', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Enviado a Procurador', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 4 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Demanda Interpuesta', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 5 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Facturado', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 6 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 6 ,'Anulado', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 7 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 7 ,'Devuelto', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 8 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 8 ,'Insinuacion', 2;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 9 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 9 ,'Pdte. Insinuacion', 2;
end if;

-- BANKIA = 3
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'En Curso', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'KO y Paralizado', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Enviado a Procurador', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 4 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Demanda Interpuesta', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 5 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Facturado', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 6 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 6 ,'Anulado', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 7 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 7 ,'Devuelto', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 8 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 8 ,'Insinuacion', 3;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 9 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 9 ,'Pdte. Insinuacion', 3;
end if;

-- CAJAMAR = 4
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'En Curso', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'KO y Paralizado', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Enviado a Procurador', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 4 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Demanda Interpuesta', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 5 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Facturado', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 6 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 6 ,'Anulado', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 7 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 7 ,'Devuelto', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 8 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 8 ,'Insinuacion', 4;
end if;
if ((select count(*) from D_EXP_EST_CONEXP where EST_CONEXP_ID = 9 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_EST_CONEXP (EST_CONEXP_ID, EST_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 9 ,'Pdte. Insinuacion', 4;
end if;



-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_SITUACION
-- ----------------------------------------------------------------------------------------------
-- ABANCA = 1
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 1;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Prejudicial', 1;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Judicial', 1;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Otra Situación', 1;
end if;
-- BBVA = 2
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 2;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Prejudicial', 2;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Judicial', 2;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Otra Situación', 2;
end if;
-- BANKIA = 3
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 3;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Prejudicial', 3;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Judicial', 3;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Otra Situación', 3;
end if;
-- CAJAMAR = 4
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 4;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Prejudicial', 4;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 2 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Judicial', 4;
end if;
if ((select count(*) from D_EXP_SITUACION where SITUACION_CONEXP_ID = 3 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_SITUACION (SITUACION_CONEXP_ID, SITUACION_CONEXP_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Otra Situación', 4;
end if;

-- ----------------------------------------------------------------------------------------------
--                                      D_CUADRE_CARTERA
-- Dimensión para Tabla Cuadre Cartera, es CROSS a Procedimientos y Expedientes
-- ----------------------------------------------------------------------------------------------
-- ABANCA = 1
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 1;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Correctos', 1;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 2 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Incorrectos', 1;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 3 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Despreciables', 1;
end if;
-- BBVA = 2
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 2;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Correctos', 2;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 2 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Incorrectos', 2;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 3 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Despreciables', 2;
end if;
-- BBVA = 3
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 3;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Correctos', 3;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 2 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Incorrectos', 3;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 3 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Despreciables', 3;
end if;
-- BBVA = 4
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 4;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'Correctos', 4;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 2 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Incorrectos', 4;
end if;
if ((select count(*) from D_CUADRE_CARTERA where CUADRE_CARTERA_ID = 3 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_CUADRE_CARTERA (CUADRE_CARTERA_ID, CUADRE_CARTERA_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Despreciables', 4;
end if;


 

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_EST_INICIO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_EST_INICIO where EST_INICIO_ID = -1) = 0) then
	insert into D_EXP_EST_INICIO (EST_INICIO_ID, EST_INICIO_CODIGO, EST_INICIO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', 'Desconocido', -1);
end if;

insert into D_EXP_EST_INICIO(EST_INICIO_ID, EST_INICIO_CODIGO, EST_INICIO_DESC, ENTIDAD_CEDENTE_ID)
    select distinct eex.EEX_ID, eex.EEX_CODIGO, eex.EEX_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
		from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
			inner join bi_cdd_conexp_datastage.EEX_ESTADO_EXPEDIENTE eex on eex.EEX_ID = exp.exp_iniciados
			inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
			inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
			inner join (select 
							ENTIDAD_CEDENTE_ID,
							case
							when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
							when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
							when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
							when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
							ELSE ENTIDAD_CEDENTE_DESC
							end cedente_conexp
						from bi_cdd_dwh.D_ENTIDAD_CEDENTE
				) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
			;

-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_ESCANEADO
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_ESCANEADO where ESCANEADO_ID = -1) = 0) then
	insert into D_EXP_ESCANEADO (ESCANEADO_ID, ESCANEADO_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

insert into D_EXP_ESCANEADO(ESCANEADO_ID, ESCANEADO_DESC, ENTIDAD_CEDENTE_ID)
    select distinct 
    		des.des_ID,des.des_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
		from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
			inner join bi_cdd_conexp_datastage.DES_DICCIONARIO_ESTADO des on des.des_id=exp.exp_escaneado_completo
			inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
			inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
			inner join (select 
							ENTIDAD_CEDENTE_ID,
							case
							when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
							when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
							when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
							when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
							ELSE ENTIDAD_CEDENTE_DESC
							end cedente_conexp
						from bi_cdd_dwh.D_ENTIDAD_CEDENTE
				) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
			;
			
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_CARTERA
-- ----------------------------------------------------------------------------------------------
if ((select count(*) from D_EXP_CARTERA where CARTERA_ID = -1) = 0) then
	insert into D_EXP_CARTERA (CARTERA_ID, CARTERA_DESC, ENTIDAD_CEDENTE_ID) values (-1 ,'Desconocido', -1);
end if;

insert into D_EXP_CARTERA(CARTERA_ID, CARTERA_DESC, ENTIDAD_CEDENTE_ID)
    select distinct 
    		ccc.ccc_id,ccc.ccc_DESCRIPCION, ccx.ENTIDAD_CEDENTE_ID
		from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
			inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
			inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
			inner join (select 
							ENTIDAD_CEDENTE_ID,
							case
							when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
							when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
							when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
							when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
							ELSE ENTIDAD_CEDENTE_DESC
							end cedente_conexp
						from bi_cdd_dwh.D_ENTIDAD_CEDENTE
				) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
			;


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PLAZO_ENT_ENV
-- ----------------------------------------------------------------------------------------------
-- ABANCA = 1
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 2 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 3 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 4 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 5 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 1;
end if;
-- BBVA = 2
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 2 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 3 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 4 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 5 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 2;
end if;
-- BANKIA = 3
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 2 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 3 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 4 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 5 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 3;
end if;
-- CAJAMAR = 4
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 2 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 3 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 4 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENT_ENV where DIAS_ENTRE_ENTRADA_ENVIO_ID = 5 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENT_ENV (DIAS_ENTRE_ENTRADA_ENVIO_ID, DIAS_ENTRE_ENTRADA_ENVIO_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 4;
end if;

			
-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_PLAZO_ENV_PRE
-- ----------------------------------------------------------------------------------------------
-- ABANCA = 1
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 2 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 3 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 4 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 1;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 5 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 1;
end if;			
-- BBVA = 2
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = -1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 1 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 2 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 3 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 4 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 2;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 5 AND ENTIDAD_CEDENTE_ID = 2) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 2;
end if;	
-- BANKIA = 3
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = -1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 1 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 2 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 3 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 4 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 3;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 5 AND ENTIDAD_CEDENTE_ID = 3) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 3;
end if;	
-- CAJAMAR = 4
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = -1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 1 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'<= 3 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 2 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 2 ,'Más de 3 días y <= 5 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 3 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 3 ,'Más de 5 días y <= 10 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 4 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 4 ,'Más de 10 días y <= 15 días', 4;
end if;
if ((select count(*) from D_EXP_PLAZO_ENV_PRE where DIAS_ENTRE_ENVIO_PRESEN_ID = 5 AND ENTIDAD_CEDENTE_ID = 4) = 0) then
	insert into D_EXP_PLAZO_ENV_PRE (DIAS_ENTRE_ENVIO_PRESEN_ID, DIAS_ENTRE_ENVIO_PRESEN_DESC, ENTIDAD_CEDENTE_ID)
	select 5 ,'Más de 15 días', 4;
end if;				


-- ----------------------------------------------------------------------------------------------
--                                      D_EXP_TIENE_FACTURA
-- ----------------------------------------------------------------------------------------------
-- ABANCA = 1
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 1;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 0 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 0 ,'NO', 1;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'SI', 1;
end if;
-- BBVA = 2
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 2;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 0 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 0 ,'NO', 2;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'SI', 2;
end if;
-- BANKIA = 3
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 3;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 0 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 0 ,'NO', 3;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'SI', 3;
end if;
-- CAJAMAR = 4
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = -1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select -1 ,'Desconocido', 4;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 0 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 0 ,'NO', 4;
end if;
if ((select count(*) from D_EXP_TIENE_FACTURA where TIENE_FACTURA = 1 AND ENTIDAD_CEDENTE_ID = 1) = 0) then
	insert into D_EXP_TIENE_FACTURA (TIENE_FACTURA, TIENE_FACTURA_DESC, ENTIDAD_CEDENTE_ID)
	select 1 ,'SI', 4;
end if;



-- ----------------------------------------------------------------------------------------------
--                                      D_EXP
-- ----------------------------------------------------------------------------------------------
  insert into D_EXP
   (EXPEDIENTE_ID,
    COD_CLIENTE,
    COD_RECOVERY,
    ENTIDAD_CEDENTE_ID
   )
  select distinct EXP_ID, 
        coalesce(EXP_COD_CLIENTE, 'Desconocido'),
        coalesce(EXP_COD_RECOVERY, 'Desconocido'),
        ccx.ENTIDAD_CEDENTE_ID
  from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
  		inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.ccc_id
		inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id
		inner join (select 
					ENTIDAD_CEDENTE_ID,
					case
					when ENTIDAD_CEDENTE_DESC = 'BBVA' then 'BBVA (UNNIM)'
					when ENTIDAD_CEDENTE_DESC = 'ABANCA' then 'NGB'
					when ENTIDAD_CEDENTE_DESC = 'BANKIA' then 'BANKIA'
					when ENTIDAD_CEDENTE_DESC = 'CAJAMAR' then 'CAJAMAR'
					ELSE ENTIDAD_CEDENTE_DESC
					end cedente_conexp
			from bi_cdd_dwh.D_ENTIDAD_CEDENTE
			) ccx ON trim(cce.CCE_DESCRIPCION) = trim(ccx.cedente_conexp)
		;


END MY_BLOCK_DIM_EXP
