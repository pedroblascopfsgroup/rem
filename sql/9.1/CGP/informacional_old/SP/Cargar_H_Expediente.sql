-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_H_Expediente` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

SET NAMES UTF8 $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_H_Expediente`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_PRC: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Julio 2014
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_EXP
-- ===============================================================================================
 
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
declare max_dia_con_contratos date;
declare max_dia_semana date;
declare max_dia_mes date;
declare max_dia_trimestre date;
declare max_dia_anio date;
declare max_dia_carga date;
declare semana int;
declare mes int;
declare trimestre int;
declare anio int;
declare fecha date;
declare fecha_rellenar date;

declare l_last_row int default 0;
declare c_fecha_rellenar cursor for select distinct(DIA_ID) FROM D_F_DIA where DIA_ID between date_start and date_end;
declare c_fecha cursor for select distinct(DIA_ID) FROM D_F_DIA where DIA_ID between date_start and date_end; 
declare c_semanas cursor for select distinct SEMANA_H from TMP_FECHA order by 1;
declare c_meses cursor for select distinct MES_H from TMP_FECHA order by 1;
declare c_trimestre cursor for select distinct TRIMESTRE_H from TMP_FECHA order by 1;
declare c_anio cursor for select distinct ANIO_H from TMP_FECHA order by 1;
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
--                                      H_EXP
-- ----------------------------------------------------------------------------------------------
-- Borrado de los días a insertar
delete from H_EXP where DIA_ID between date_start and date_end;
delete from H_EXP_DET_KO where DIA_ID between date_start and date_end;
delete from H_EXP_DET_FACTURA where DIA_ID between date_start and date_end;

-- ------------------------------------------------------------------ BUCLE H_EXP -------------------------------------------------------------------
set l_last_row = 0; 

open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;    
   
 insert into H_EXP(
	    DIA_ID,  
	    FECHA_CARGA_DATOS,                                    
	    EXPEDIENTE_ID,                              
	    FECHA_PROVISION,
	    FECHA_ENTRADA, 
	    FECHA_DEVOLUCION, 
	    FECHA_ESCANEADO_FIN,
	    FECHA_PREP_ENVIO_PROCURADOR,
	    FECHA_ENVIO_PROCURADOR,
	    FECHA_DOCUMENTACION,
	    FECHA_PARALIZACION,  
	    -- Dimensiones
	    CEDENTE_ID,
	    PROVEEDOR_ID,
	    EST_ENTRADA_ID,
	    EST_HERRAMIENTA_ID,
	    FASE_ID,
	    EST_VIDA_ID,
	    EST_GESTION_ID,
	    PROCURADOR_ID,
	    TIPO_PROCEDIMIENTO_ID,
	    PLAZA_ID,
	    JUZGADO_ID,  
	    -- Métricas
	    NUM_EXPEDIENTES,  
	    NUM_EXP_INICIADOS,
	    IMPORTE_PROVISION,
	    DEVOLUCION,
	    IMPORTE_PRINCIPAL,
	    IMPORTE_LIQUIDACION,
	    BASE_IMPORTE, 
	    ENTIDAD_CEDENTE_ID,
	    DEJ_FECHA_DEMANDA,
	    DEJ_FECHA_ENVIO_DEMANDA,
	    DEJ_FECHA_DEMANDA_MES,
	    DEJ_FECHA_ENVIO_DEMANDA_MES,
	    DEJ_FECHA_DEMANDA_ANY,
	    DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    FECHA_ENTRADA_MES,
	    FECHA_ENTRADA_ANY,
	    DIAS_ENTRE_ENTRADA_ENVIO,
	    DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    DIAS_ENTRE_ENVIO_PRESEN,
	    DIAS_ENTRE_ENVIO_PRESEN_FES,
	    DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    MAX_FECHA_RES_KO,
	    DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    DIAS_ENTRE_ENVIO_PRESEN_ID,
	    /* DATOS DE FACTURA */
	    TIENE_FACTURA,
	    FACT_FECHA_FACTURA, 
  		FACT_FECHA_ENVIO, 
  		FACT_FECHA_RECLAMACION_PROCURADOR, 
  		FACT_FECHA_ENVIO_PROCURADOR, 
		-- Dimensiones
		FACTURA_ID,
		MOTIVO_FACTURA_ID, 
		EST_FACTURA_ID,
		-- Métricas
		NUM_FACTURA,
		FACT_BASE_IMP,
		FACT_DTO_MINUTA,
		FACT_IVA,
		FACT_IRPF,
		FACT_TOTAL_MINUTA,
		FACT_IMPORTE_LIQUIDACION,
		FACT_IMPORTE,
		FACT_TIPO_IVA,
		FACT_TIPO_RETENCION,
		FACT_IMPORTE_AJUSTE,
		FACT_IMP_PROVISION_PARCIAL,
		COL_DUMMY_FACT
		/* FIN DATOS DE FACTURA */
    )   
    select  distinct 
	    fecha A,      
	    fecha B, 
	    exp.exp_id,   
	    exp.exp_fecha_provision,                              
	    exp.exp_fecha_entrada,
	    exp.exp_fecha_devolucion,
	    exp.exp_escaneado_fecha_fin,
	    exp.exp_procu_fecha_prep_envio,
	    exp.exp_procu_fecha_envio,
	    exp.exp_fecha_docu,
	    exp.exp_fecha_para,  
	    -- Dimensiones
	    exp.ccc_id,
	    exp.pex_id,
	    exp.een_id,
	    exp.ehc_id,
	    exp.fae_id,
	    exp.ecv_id,
	    exp.ege_id,
	    dej.ppr_id,   
	    TPR_ID,
	    dej.pla_id,
	    dej.juz_id,  
	    -- Métricas   
	    1 C,    
	    exp.exp_iniciados,
	    exp.exp_imp_provision,
	    exp.exp_devolucion,
	    dej.DEJ_IMPORTE_DEMANDA,
	    exp.exp_importe_liquidacion,
	    exp.exp_base_imp,
	    ccx.ENTIDAD_CEDENTE_ID, 
	    dej.dej_fecha_presentacion,
	    dej.dej_fecha_envio,
	    MONTH(dej.dej_fecha_presentacion),
	    MONTH(dej.dej_fecha_envio),
	    YEAR(dej.dej_fecha_presentacion),
	    YEAR(dej.dej_fecha_envio),
	    MONTH(exp.exp_fecha_entrada),
	    YEAR(exp.exp_fecha_entrada),
	    DATEDIFF(dej.dej_fecha_envio,exp.exp_fecha_entrada) DIAS_ENTRE_ENTRADA_ENVIO,
	    (select count(*) from bi_cdd_conexp_datastage.HOL_HOLIDAYS where HOL_DIA between exp.exp_fecha_entrada and dej.dej_fecha_envio) DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    null,
	    DATEDIFF(dej.dej_fecha_presentacion,dej.dej_fecha_envio) DIAS_ENTRE_ENVIO_PRESEN,
	    (select count(*) from bi_cdd_conexp_datastage.HOL_HOLIDAYS where HOL_DIA between dej.dej_fecha_envio and dej.dej_fecha_presentacion) DIAS_ENTRE_ENVIO_PRESEN_FES,
	    null,
	    (select max(gko2.GKO_FECHA_RESOL)
				from bi_cdd_conexp_datastage.GKO_GESTION_KO gko2
	    		where gko2.exp_id = exp.exp_id) MAX_FECHA_RES_KO,
		null D,
		null E,
		/* Datos factura */
		if(fac.fac_id is null, 0, 1) H,
		fac.fac_fecha_factura, 
        fac.fac_fecha_envio, 
        fac.fac_fecha_recla_ppr, 
        fac.fac_fecha_recep_ppr, 
        -- Dimensiones
        fac.fac_id,
        mof_id, 
        if(fac.efa_id is null, -1, fac.efa_id) efa_id ,
        -- Métricas
        1 F,
        fac.fac_base_imp,
        fac.fac_dto_minuta,
        fac.fac_iva,
        fac.fac_irpf,
        fac.fac_total_minuta,
        fac.fac_importe_liquidacion,
        fac.fac_importe,
        fac.fac_tipo_iva,
        fac.fac_tipo_retencion,
        fac.fac_importe_ajuste,
        fac.fac_imp_provision_parcial,
        if(fac.fac_id is null, 0, 1) G
 from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
    inner join bi_cdd_conexp_datastage.DEJ_DEMANDA_JUDICIAL dej on exp.exp_id = dej.exp_id
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
					end cedente_conexp,
					ENTIDAD_CEDENTE_DESC
				from D_ENTIDAD_CEDENTE
				) ccx ON trim(cce.cce_descripcion) = trim(ccx.cedente_conexp)
	left join bi_cdd_conexp_datastage.FAC_FACTURACION fac on  exp.exp_id = fac.exp_id
  where fecha >= exp.exp_fecha_entrada
 ;
 
 -- Si MAX_FECHA_RES_KO modificamos DIAS_ENTRE_ENTRADA_ENVIO y DIAS_ENTRE_ENTRADA_ENVIO_FES.
  update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO = DATEDIFF(DEJ_FECHA_ENVIO_DEMANDA,MAX_FECHA_RES_KO),
  		DIAS_ENTRE_ENTRADA_ENVIO_FES = (select count(*) from bi_cdd_conexp_datastage.HOL_HOLIDAYS 
  										where HOL_DIA between MAX_FECHA_RES_KO and DEJ_FECHA_ENVIO_DEMANDA)
  	where MAX_FECHA_RES_KO is not null;
 
 -- Calculo fechas entre etapas EXP
  update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO_CALC = DIAS_ENTRE_ENTRADA_ENVIO - DIAS_ENTRE_ENTRADA_ENVIO_FES
  	where DEJ_FECHA_ENVIO_DEMANDA is not null;
  	
  update H_EXP
  	set DIAS_ENTRE_ENVIO_PRESEN_CALC = DIAS_ENTRE_ENVIO_PRESEN - DIAS_ENTRE_ENVIO_PRESEN_FES
  	where DEJ_FECHA_ENVIO_DEMANDA is not null and DEJ_FECHA_DEMANDA is not null;
  
 -- Calculo del ID de los atributos DIAS_ENTRE_ENTRADA_ENVIO_ID.
 	update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO_ID = -1
  	where DIAS_ENTRE_ENTRADA_ENVIO_CALC is null;
  	update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO_ID = 1
  	where DIAS_ENTRE_ENTRADA_ENVIO_CALC <= 3;
  	update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO_ID = 2
  	where DIAS_ENTRE_ENTRADA_ENVIO_CALC > 3 and  DIAS_ENTRE_ENTRADA_ENVIO_CALC <= 5;
  	update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO_ID = 3
  	where DIAS_ENTRE_ENTRADA_ENVIO_CALC > 5 and  DIAS_ENTRE_ENTRADA_ENVIO_CALC <= 10;
  	update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO_ID = 4
  	where DIAS_ENTRE_ENTRADA_ENVIO_CALC > 10 and  DIAS_ENTRE_ENTRADA_ENVIO_CALC <= 15;
  	update H_EXP
  	set DIAS_ENTRE_ENTRADA_ENVIO_ID = 5
  	where DIAS_ENTRE_ENTRADA_ENVIO_CALC > 15;
  	
 -- Calculo del ID de los atributos DIAS_ENTRE_ENVIO_PRESEN_ID.
 	update H_EXP
  	set DIAS_ENTRE_ENVIO_PRESEN_ID = -1
  	where DIAS_ENTRE_ENVIO_PRESEN_CALC is null;
  	update H_EXP
  	set DIAS_ENTRE_ENVIO_PRESEN_ID = 1
  	where DIAS_ENTRE_ENVIO_PRESEN_CALC <= 3;
  	update H_EXP
  	set DIAS_ENTRE_ENVIO_PRESEN_ID = 2
  	where DIAS_ENTRE_ENVIO_PRESEN_CALC > 3 and  DIAS_ENTRE_ENVIO_PRESEN_CALC <= 5;
  	update H_EXP
  	set DIAS_ENTRE_ENVIO_PRESEN_ID = 3
  	where DIAS_ENTRE_ENVIO_PRESEN_CALC > 5 and  DIAS_ENTRE_ENVIO_PRESEN_CALC <= 10;
  	update H_EXP
  	set DIAS_ENTRE_ENVIO_PRESEN_ID = 4
  	where DIAS_ENTRE_ENVIO_PRESEN_CALC > 10 and  DIAS_ENTRE_ENVIO_PRESEN_CALC <= 15;
  	update H_EXP
  	set DIAS_ENTRE_ENVIO_PRESEN_ID = 5
  	where DIAS_ENTRE_ENVIO_PRESEN_CALC > 15; 
   
-- EST_CONEXP_ID
    -- 1	En Curso
    -- 2	KO y Paralizado
    -- 3	Enviado a Procurador
    -- 4	Demanda Interpuesta
    -- 5	Facturado
    -- 6	Anulado
    -- 7	Devuelto
    -- 8	Insinuacion
    -- 9	Pdte. Insinuacion
    update H_EXP set EST_CONEXP_ID = (case when (EST_GESTION_ID = 3) and (EST_VIDA_ID = 1) and ((FASE_ID = 2) or (FASE_ID = 3) or (FASE_ID = 4) or (FASE_ID = 5)) then 1 
                                           when (EST_GESTION_ID = 4) and (EST_VIDA_ID = 1) then 2
                                           when (EST_GESTION_ID = 3) and (EST_VIDA_ID = 1) and (FASE_ID = 6) then 3
                                           when (EST_GESTION_ID = 3) AND (EST_VIDA_ID = 1) AND (FASE_ID = 7) then 4
                                           when EST_VIDA_ID = 3 then 5
                                           when EST_VIDA_ID = 4 then 6
                                           when EST_VIDA_ID = 2 then 7
                                           end) where DIA_ID = fecha and TIPO_PROCEDIMIENTO_ID!=5; 

	update H_EXP set EST_CONEXP_ID = (case when (EST_GESTION_ID = 3) and (EST_VIDA_ID = 1) and (FASE_ID = 7) then 8 
                                           when (EST_GESTION_ID = 4) and (EST_VIDA_ID = 1) then 9
                                           when (EST_GESTION_ID = 3) and (EST_VIDA_ID = 3) then 5
                                           when EST_VIDA_ID = 4 then 6
                                           when EST_VIDA_ID = 2 then 7
                                           end) where DIA_ID = fecha and TIPO_PROCEDIMIENTO_ID=5;
                                         
    update H_EXP set EST_CONEXP_ID = -1 where DIA_ID = fecha and EST_CONEXP_ID is null;
                                          
                                           
-- SITUACION_CONEXP_ID
    -- -1	Desconocido
    -- 1	Prejudicial
    -- 2	Judicial
    -- 3	Otra Situación
    update H_EXP set SITUACION_CONEXP_ID = (case when (EST_CONEXP_ID = 1) OR (EST_CONEXP_ID = 2)  then 1 
                                           when (EST_CONEXP_ID = 3) OR (EST_CONEXP_ID = 4) OR (EST_CONEXP_ID = 5)then 2
                                           when (EST_CONEXP_ID = 6) OR (EST_CONEXP_ID = 7) then 3
                                           else -1 end) where DIA_ID = fecha; 
                                           
	-- PLAZA_UNICO_ID = -2
	truncate table TMP_EXP_PL_UNICO;
	insert into TMP_EXP_PL_UNICO(EXPEDIENTE_ID)
    	select EXP.EXPEDIENTE_ID
		from H_EXP EXP 
			inner join (select PROCURADOR_ID, ENTIDAD_CEDENTE_ID, count(distinct PLAZA_ID) 
						from H_EXP EXP1
						group by PROCURADOR_ID, ENTIDAD_CEDENTE_ID having count(distinct PLAZA_ID)>1) LL
			on LL.PROCURADOR_ID=EXP.PROCURADOR_ID and LL.ENTIDAD_CEDENTE_ID=EXP.ENTIDAD_CEDENTE_ID
		where EXP.DIA_ID = fecha;                                       
                                           
	update H_EXP EXP
		set EXP.PLAZA_UNICO_ID = -2 
		where EXP.DIA_ID = fecha
		and EXP.EXPEDIENTE_ID in (select EXPEDIENTE_ID from TMP_EXP_PL_UNICO);
													
	-- PLAZA_UNICO_ID = solo una plaza
	truncate table TMP_EXP_PL_UNICO;
	insert into TMP_EXP_PL_UNICO(EXPEDIENTE_ID)                                    
    	select EXP.EXPEDIENTE_ID 
    	from H_EXP EXP
		where EXP.DIA_ID = fecha 
		AND EXP.PLAZA_UNICO_ID is null;                           
	
	update H_EXP EXP
		set EXP.PLAZA_UNICO_ID =  EXP.PLAZA_ID
		where EXP.DIA_ID = fecha
		and EXP.EXPEDIENTE_ID in (select EXPEDIENTE_ID from TMP_EXP_PL_UNICO);
                                           
    -- Detalle KO Día
    insert into H_EXP_DET_KO
    (	 
    	 DIA_ID,  
		 FECHA_CARGA_DATOS,                                 
		 EXPEDIENTE_ID, 
		 FECHA_ALTA_KO, 
		 FECHA_VENCIMIENTO_KO, 
		 FECHA_RESOLUCION_KO, 
		 -- Dimensiones
		 MOTIVO_KO_ID, 
		 -- Métricas
		 NUM_KO,
		 ENTIDAD_CEDENTE_ID
    )
    select  
	    fecha,      
	    fecha,
	    exp.exp_id,
	    gko.gko_fecha_alta,   
	    gko.gko_fecha_vto,
	    gko.gko_fecha_resoL,
	    -- Dimensiones
	    mko.mko_id,            
	    -- Métricas 
		1,
		ccx.ENTIDAD_CEDENTE_ID	 
    from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
	    inner join bi_cdd_conexp_datastage.GKO_GESTION_KO gko on gko.exp_id = exp.exp_id
	    inner join bi_cdd_conexp_datastage.MKO_MOTIVO_KO mko on gko.mko_id = mko.mko_id
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
				end cedente_conexp,
				ENTIDAD_CEDENTE_DESC
			from D_ENTIDAD_CEDENTE
			) ccx ON trim(cce.cce_descripcion) = trim(ccx.cedente_conexp)		    
    where fecha >= GKO_FECHA_ALTA and fecha <= GKO_FECHA_VTO;
    

    -- Detalle Factura
    insert into H_EXP_DET_FACTURA
    (
         DIA_ID,  
         FECHA_CARGA_DATOS,                                 
         EXPEDIENTE_ID, 
         FECHA_FACTURA, 
         FECHA_ENVIO, 
         FECHA_RECLAMACION_PROCURADOR, 
         FECHA_ENVIO_PROCURADOR, 
         -- Dimensiones
         FACTURA_ID,
         MOTIVO_FACTURA_ID, 
         EST_FACTURA_ID,
         -- Métricas
         NUM_FACTURA,
         FACT_BASE_IMP,
         FACT_DTO_MINUTA,
         FACT_IVA,
         FACT_IRPF,
         FACT_TOTAL_MINUTA,
         FACT_IMPORTE_LIQUIDACION,
         FACT_IMPORTE,
         FACT_TIPO_IVA,
         FACT_TIPO_RETENCION,
         FACT_IMPORTE_AJUSTE,
         FACT_IMP_PROVISION_PARCIAL,
         ENTIDAD_CEDENTE_ID,
         COL_DUMMY_FACT
    )
    select 
    	fecha,  
        fecha,                                 
        exp.exp_id, 
        fac_fecha_factura, 
        fac_fecha_envio, 
        fac_fecha_recla_ppr, 
        fac_fecha_recep_ppr, 
        -- Dimensiones
        fac_id,
        mof_id, 
        efa_id,
        -- Métricas
        1,
        fac_base_imp,
        fac_dto_minuta,
        fac_iva,
        fac_irpf,
        fac_total_minuta,
        fac_importe_liquidacion,
        fac_importe,
        fac_tipo_iva,
        fac_tipo_retencion,
        fac_importe_ajuste,
        fac_imp_provision_parcial,
        ccx.ENTIDAD_CEDENTE_ID,
        1
	from bi_cdd_conexp_datastage.EXP_EXPEDIENTE exp
		inner join bi_cdd_conexp_datastage.FAC_FACTURACION fac on  exp.exp_id = fac.exp_id
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
				end cedente_conexp,
				ENTIDAD_CEDENTE_DESC
			from D_ENTIDAD_CEDENTE
			) ccx ON trim(cce.cce_descripcion) = trim(ccx.cedente_conexp)	
     where fecha <= FAC_FECHA_FACTURA;
 
    

end loop;
close c_fecha;
-- ---------------------------------------------------------------- FIN BUCLE H_EXP -----------------------------------------------------------------


-- ------------------------------------------------------------------ UPDATES H_EXP -----------------------------------------------------------------
/*
-- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_EXP);      
update H_EXP set FECHA_CARGA_DATOS = max_dia_carga;
update H_EXP_DET_KO set FECHA_CARGA_DATOS = max_dia_carga;
update H_EXP_DET_FACTURA set FECHA_CARGA_DATOS = max_dia_carga;
*/

-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_SEMANA
-- ----------------------------------------------------------------------------------------------
truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_EXP where DIA_ID between date_start and date_end;
update TMP_FECHA set SEMANA_H = (select SEMANA_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);

-- Bucle que recorre las semanas
set l_last_row = 0; 
open c_semanas;
c_semanas_loop: loop
fetch c_semanas INTO semana;        
    IF (l_last_row=1) THEN LEAVE c_semanas_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_EXP_SEMANA where SEMANA_ID = semana;
    delete from H_EXP_DET_KO_SEMANA where SEMANA_ID = semana;
    delete from H_EXP_DET_FACTURA_SEMANA where SEMANA_ID = semana;
    
    -- Insertado de meses (último día del mes disponible en H_EXP)
    set max_dia_semana = (select max(DIA_H) from TMP_FECHA where SEMANA_H = semana);
    insert into H_EXP_SEMANA
        (SEMANA_ID,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_PROVISION,
        FECHA_ENTRADA,
        FECHA_DEVOLUCION,
        FECHA_ESCANEADO_FIN,
        FECHA_PREP_ENVIO_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FECHA_DOCUMENTACION,
        FECHA_PARALIZACION,
        CEDENTE_ID,
        PROVEEDOR_ID,
        EST_ENTRADA_ID,
        EST_HERRAMIENTA_ID,
        FASE_ID,
        EST_VIDA_ID,
        EST_GESTION_ID,
        PROCURADOR_ID,
        TIPO_PROCEDIMIENTO_ID,
        PLAZA_ID,
        PLAZA_UNICO_ID,
        JUZGADO_ID,
        EST_CONEXP_ID,
        SITUACION_CONEXP_ID,
        NUM_EXPEDIENTES,
        NUM_EXP_INICIADOS,
        IMPORTE_PROVISION,
        DEVOLUCION,
        IMPORTE_PRINCIPAL,
        IMPORTE_LIQUIDACION,
        BASE_IMPORTE,
        ENTIDAD_CEDENTE_ID,
        DEJ_FECHA_DEMANDA,
   		DEJ_FECHA_ENVIO_DEMANDA,
   		DEJ_FECHA_DEMANDA_MES,
	    DEJ_FECHA_ENVIO_DEMANDA_MES,
	    DEJ_FECHA_DEMANDA_ANY,
	    DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    FECHA_ENTRADA_MES,
	    FECHA_ENTRADA_ANY,
	    DIAS_ENTRE_ENTRADA_ENVIO,
	    DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    DIAS_ENTRE_ENVIO_PRESEN,
	    DIAS_ENTRE_ENVIO_PRESEN_FES,
	    DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    MAX_FECHA_RES_KO,
	    DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    DIAS_ENTRE_ENVIO_PRESEN_ID,
	    SIT_CUADRE_CARTERA_ID,
	    TIENE_FACTURA,
	    FACT_FECHA_FACTURA, 
  		FACT_FECHA_ENVIO, 
  		FACT_FECHA_RECLAMACION_PROCURADOR, 
  		FACT_FECHA_ENVIO_PROCURADOR,  
		FACTURA_ID,
		MOTIVO_FACTURA_ID, 
		EST_FACTURA_ID,
		NUM_FACTURA,
		FACT_BASE_IMP,
		FACT_DTO_MINUTA,
		FACT_IVA,
		FACT_IRPF,
		FACT_TOTAL_MINUTA,
		FACT_IMPORTE_LIQUIDACION,
		FACT_IMPORTE,
		FACT_TIPO_IVA,
		FACT_TIPO_RETENCION,
		FACT_IMPORTE_AJUSTE,
		FACT_IMP_PROVISION_PARCIAL,
		COL_DUMMY_FACT
        )
    select distinct 
    	semana, 
        max_dia_semana,
        exp.EXPEDIENTE_ID,
        exp.FECHA_PROVISION,
        exp.FECHA_ENTRADA,
        exp.FECHA_DEVOLUCION,
        exp.FECHA_ESCANEADO_FIN,
        exp.FECHA_PREP_ENVIO_PROCURADOR,
        exp.FECHA_ENVIO_PROCURADOR,
        exp.FECHA_DOCUMENTACION,
        exp.FECHA_PARALIZACION,
        exp.CEDENTE_ID,
        exp.PROVEEDOR_ID,
        exp.EST_ENTRADA_ID,
        exp.EST_HERRAMIENTA_ID,
        exp.FASE_ID,
        exp.EST_VIDA_ID,
        exp.EST_GESTION_ID,
        exp.PROCURADOR_ID,
        exp.TIPO_PROCEDIMIENTO_ID,
        exp.PLAZA_ID,
        exp.PLAZA_UNICO_ID,
        exp.JUZGADO_ID,
        exp.EST_CONEXP_ID,
        exp.SITUACION_CONEXP_ID,
        exp.NUM_EXPEDIENTES,
        exp.NUM_EXP_INICIADOS,
        exp.IMPORTE_PROVISION,
        exp.DEVOLUCION,
        exp.IMPORTE_PRINCIPAL,
        exp.IMPORTE_LIQUIDACION,
        exp.BASE_IMPORTE,
        exp.ENTIDAD_CEDENTE_ID,
        exp.DEJ_FECHA_DEMANDA,
        exp.DEJ_FECHA_ENVIO_DEMANDA,
        exp.DEJ_FECHA_DEMANDA_MES,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_MES,
	    exp.DEJ_FECHA_DEMANDA_ANY,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    exp.FECHA_ENTRADA_MES,
	    exp.FECHA_ENTRADA_ANY,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    exp.DIAS_ENTRE_ENVIO_PRESEN,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_FES,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    exp.MAX_FECHA_RES_KO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_ID,
	    exp.SIT_CUADRE_CARTERA_ID,
	    exp.TIENE_FACTURA,
	    exp.FACT_FECHA_FACTURA, 
  		exp.FACT_FECHA_ENVIO, 
  		exp.FACT_FECHA_RECLAMACION_PROCURADOR, 
  		exp.FACT_FECHA_ENVIO_PROCURADOR,  
		exp.FACTURA_ID,
		exp.MOTIVO_FACTURA_ID, 
		exp.EST_FACTURA_ID,
		exp.NUM_FACTURA,
		exp.FACT_BASE_IMP,
		exp.FACT_DTO_MINUTA,
		exp.FACT_IVA,
		exp.FACT_IRPF,
		exp.FACT_TOTAL_MINUTA,
		exp.FACT_IMPORTE_LIQUIDACION,
		exp.FACT_IMPORTE,
		exp.FACT_TIPO_IVA,
		exp.FACT_TIPO_RETENCION,
		exp.FACT_IMPORTE_AJUSTE,
		exp.FACT_IMP_PROVISION_PARCIAL,
		exp.COL_DUMMY_FACT
    from H_EXP exp
-- 		inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.CEDENTE_ID   
-- 		inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id   	 
    where DIA_ID = max_dia_semana
	;


-- Detalle Ko Semana
    insert into H_EXP_DET_KO_SEMANA
        (SEMANA_ID,  
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
        )
    select semana,    
        max_dia_semana,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
    from H_EXP_DET_KO 
    where DIA_ID = max_dia_semana
   ;
     

-- Detalle Factura Semana
    insert H_EXP_DET_FACTURA_SEMANA
        (SEMANA_ID,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
         )
    select semana,   
        max_dia_semana,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
    from H_EXP_DET_FACTURA 
    where DIA_ID = max_dia_semana
   ;
    
end loop c_semanas_loop;
close c_semanas;

-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_MES
-- ----------------------------------------------------------------------------------------------
truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_EXP where DIA_ID between date_start and date_end;
update TMP_FECHA set SEMANA_H = (select SEMANA_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);


-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;
    
    -- Borrado de los meses a insertar
    delete from H_EXP_MES where MES_ID = mes;
    delete from H_EXP_DET_KO_MES where MES_ID = mes;
    delete from H_EXP_DET_FACTURA_MES where MES_ID = mes;
    
    -- Insertado de meses (último día del mes disponible en H_EXP)
    set max_dia_mes = (select max(DIA_H) from TMP_FECHA where MES_H = mes);
    insert into H_EXP_MES
        (DIA_ID,
        MES_ID,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_PROVISION,
        FECHA_ENTRADA,
        FECHA_DEVOLUCION,
        FECHA_ESCANEADO_FIN,
        FECHA_PREP_ENVIO_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FECHA_DOCUMENTACION,
        FECHA_PARALIZACION,
        CEDENTE_ID,
        PROVEEDOR_ID,
        EST_ENTRADA_ID,
        EST_HERRAMIENTA_ID,
        FASE_ID,
        EST_VIDA_ID,
        EST_GESTION_ID,
        PROCURADOR_ID,
        TIPO_PROCEDIMIENTO_ID,
        PLAZA_ID,
        PLAZA_UNICO_ID,
        JUZGADO_ID,
        EST_CONEXP_ID,
        SITUACION_CONEXP_ID,
        NUM_EXPEDIENTES,
        NUM_EXP_INICIADOS,
        IMPORTE_PROVISION,
        DEVOLUCION,
        IMPORTE_PRINCIPAL,
        IMPORTE_LIQUIDACION,
        BASE_IMPORTE,
        ENTIDAD_CEDENTE_ID,
        DEJ_FECHA_DEMANDA,
        DEJ_FECHA_ENVIO_DEMANDA,
        DEJ_FECHA_DEMANDA_MES,
	    DEJ_FECHA_ENVIO_DEMANDA_MES,
	    DEJ_FECHA_DEMANDA_ANY,
	    DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    FECHA_ENTRADA_MES,
	    FECHA_ENTRADA_ANY,
	    DIAS_ENTRE_ENTRADA_ENVIO,
	    DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    DIAS_ENTRE_ENVIO_PRESEN,
	    DIAS_ENTRE_ENVIO_PRESEN_FES,
	    DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    MAX_FECHA_RES_KO,
	    DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    DIAS_ENTRE_ENVIO_PRESEN_ID,
	    SIT_CUADRE_CARTERA_ID,
	    TIENE_FACTURA,
	    FACT_FECHA_FACTURA, 
  		FACT_FECHA_ENVIO, 
  		FACT_FECHA_RECLAMACION_PROCURADOR, 
  		FACT_FECHA_ENVIO_PROCURADOR,  
		FACTURA_ID,
		MOTIVO_FACTURA_ID, 
		EST_FACTURA_ID,
		NUM_FACTURA,
		FACT_BASE_IMP,
		FACT_DTO_MINUTA,
		FACT_IVA,
		FACT_IRPF,
		FACT_TOTAL_MINUTA,
		FACT_IMPORTE_LIQUIDACION,
		FACT_IMPORTE,
		FACT_TIPO_IVA,
		FACT_TIPO_RETENCION,
		FACT_IMPORTE_AJUSTE,
		FACT_IMP_PROVISION_PARCIAL,
		COL_DUMMY_FACT
        )
    select distinct  
    	exp.DIA_ID,
    	mes, 
        max_dia_mes,
        EXPEDIENTE_ID,
        FECHA_PROVISION,
        FECHA_ENTRADA,
        FECHA_DEVOLUCION,
        FECHA_ESCANEADO_FIN,
        FECHA_PREP_ENVIO_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FECHA_DOCUMENTACION,
        FECHA_PARALIZACION,
        CEDENTE_ID,
        PROVEEDOR_ID,
        EST_ENTRADA_ID,
        EST_HERRAMIENTA_ID,
        FASE_ID,
        EST_VIDA_ID,
        EST_GESTION_ID,
        PROCURADOR_ID,
        TIPO_PROCEDIMIENTO_ID,
        PLAZA_ID,
        exp.PLAZA_UNICO_ID,
        JUZGADO_ID,
        EST_CONEXP_ID,
        SITUACION_CONEXP_ID,
        NUM_EXPEDIENTES,
        NUM_EXP_INICIADOS,
        IMPORTE_PROVISION,
        DEVOLUCION,
        IMPORTE_PRINCIPAL,
        IMPORTE_LIQUIDACION,
        BASE_IMPORTE,
        exp.ENTIDAD_CEDENTE_ID,
        exp.DEJ_FECHA_DEMANDA,
        exp.DEJ_FECHA_ENVIO_DEMANDA,
        exp.DEJ_FECHA_DEMANDA_MES,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_MES,
	    exp.DEJ_FECHA_DEMANDA_ANY,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    exp.FECHA_ENTRADA_MES,
	    exp.FECHA_ENTRADA_ANY,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    exp.DIAS_ENTRE_ENVIO_PRESEN,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_FES,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    exp.MAX_FECHA_RES_KO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_ID,
	    exp.SIT_CUADRE_CARTERA_ID,
	    exp.TIENE_FACTURA,
	    exp.FACT_FECHA_FACTURA, 
  		exp.FACT_FECHA_ENVIO, 
  		exp.FACT_FECHA_RECLAMACION_PROCURADOR, 
  		exp.FACT_FECHA_ENVIO_PROCURADOR,  
		exp.FACTURA_ID,
		exp.MOTIVO_FACTURA_ID, 
		exp.EST_FACTURA_ID,
		exp.NUM_FACTURA,
		exp.FACT_BASE_IMP,
		exp.FACT_DTO_MINUTA,
		exp.FACT_IVA,
		exp.FACT_IRPF,
		exp.FACT_TOTAL_MINUTA,
		exp.FACT_IMPORTE_LIQUIDACION,
		exp.FACT_IMPORTE,
		exp.FACT_TIPO_IVA,
		exp.FACT_TIPO_RETENCION,
		exp.FACT_IMPORTE_AJUSTE,
		exp.FACT_IMP_PROVISION_PARCIAL,
		exp.COL_DUMMY_FACT
    from H_EXP exp
-- 		inner join bi_cdd_conexp_datastage.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.CEDENTE_ID  
-- 		inner join bi_cdd_conexp_datastage.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id  
    where DIA_ID = max_dia_mes
    ;
    

-- Detalle KO Mes
    insert into H_EXP_DET_KO_MES
        (MES_ID,  
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
        )
    select mes,    
        max_dia_mes,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
    from H_EXP_DET_KO where DIA_ID = max_dia_mes;
     

-- Detalle Factura Mes
    insert H_EXP_DET_FACTURA_MES
        (MES_ID,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
         )
    select mes,   
        max_dia_mes,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
    from H_EXP_DET_FACTURA where DIA_ID = max_dia_mes;


end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_EXP where DIA_ID between date_start and date_end;
update TMP_FECHA set SEMANA_H = (select SEMANA_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);

-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los trimestres a insertar
    delete from H_EXP_TRIMESTRE where TRIMESTRE_ID = trimestre;
    delete from H_EXP_DET_KO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    delete from H_EXP_DET_FACTURA_TRIMESTRE where TRIMESTRE_ID = trimestre;
    
    -- Insertado de trimestes (último día del trimestre disponible en H_EXP)
    set max_dia_trimestre = (select max(DIA_H) from TMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_EXP_TRIMESTRE
        (
        TRIMESTRE_ID,   
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_PROVISION,
        FECHA_ENTRADA,
        FECHA_DEVOLUCION,
        FECHA_ESCANEADO_FIN,
        FECHA_PREP_ENVIO_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FECHA_DOCUMENTACION,
        FECHA_PARALIZACION,
        CEDENTE_ID,
        PROVEEDOR_ID,
        EST_ENTRADA_ID,
        EST_HERRAMIENTA_ID,
        FASE_ID,
        EST_VIDA_ID,
        EST_GESTION_ID,
        PROCURADOR_ID,
        TIPO_PROCEDIMIENTO_ID,
        PLAZA_ID,
        PLAZA_UNICO_ID,
        JUZGADO_ID,
        EST_CONEXP_ID,
        SITUACION_CONEXP_ID,
        NUM_EXPEDIENTES,
        NUM_EXP_INICIADOS,
        IMPORTE_PROVISION,
        DEVOLUCION,
        IMPORTE_PRINCIPAL,
        IMPORTE_LIQUIDACION,
        BASE_IMPORTE,
        ENTIDAD_CEDENTE_ID,
        DEJ_FECHA_DEMANDA,
        DEJ_FECHA_ENVIO_DEMANDA,
        DEJ_FECHA_DEMANDA_MES,
	    DEJ_FECHA_ENVIO_DEMANDA_MES,
	    DEJ_FECHA_DEMANDA_ANY,
	    DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    FECHA_ENTRADA_MES,
	    FECHA_ENTRADA_ANY,
	    DIAS_ENTRE_ENTRADA_ENVIO,
	    DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    DIAS_ENTRE_ENVIO_PRESEN,
	    DIAS_ENTRE_ENVIO_PRESEN_FES,
	    DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    MAX_FECHA_RES_KO,
	    DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    DIAS_ENTRE_ENVIO_PRESEN_ID,
	    SIT_CUADRE_CARTERA_ID,
	    TIENE_FACTURA,
	    FACT_FECHA_FACTURA, 
  		FACT_FECHA_ENVIO, 
  		FACT_FECHA_RECLAMACION_PROCURADOR, 
  		FACT_FECHA_ENVIO_PROCURADOR,  
		FACTURA_ID,
		MOTIVO_FACTURA_ID, 
		EST_FACTURA_ID,
		NUM_FACTURA,
		FACT_BASE_IMP,
		FACT_DTO_MINUTA,
		FACT_IVA,
		FACT_IRPF,
		FACT_TOTAL_MINUTA,
		FACT_IMPORTE_LIQUIDACION,
		FACT_IMPORTE,
		FACT_TIPO_IVA,
		FACT_TIPO_RETENCION,
		FACT_IMPORTE_AJUSTE,
		FACT_IMP_PROVISION_PARCIAL,
		COL_DUMMY_FACT
        )
    select distinct  
    	trimestre, 
        max_dia_trimestre,
        EXPEDIENTE_ID,
        FECHA_PROVISION,
        FECHA_ENTRADA,
        FECHA_DEVOLUCION,
        FECHA_ESCANEADO_FIN,
        FECHA_PREP_ENVIO_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FECHA_DOCUMENTACION,
        FECHA_PARALIZACION,
        CEDENTE_ID,
        PROVEEDOR_ID,
        EST_ENTRADA_ID,
        EST_HERRAMIENTA_ID,
        FASE_ID,
        EST_VIDA_ID,
        EST_GESTION_ID,
        PROCURADOR_ID,
        TIPO_PROCEDIMIENTO_ID,
        PLAZA_ID,
        PLAZA_UNICO_ID,
        JUZGADO_ID,
        EST_CONEXP_ID,
        SITUACION_CONEXP_ID,
        NUM_EXPEDIENTES,
        NUM_EXP_INICIADOS,
        IMPORTE_PROVISION,
        DEVOLUCION,
        IMPORTE_PRINCIPAL,
        IMPORTE_LIQUIDACION,
        BASE_IMPORTE,
        exp.ENTIDAD_CEDENTE_ID,
        exp.DEJ_FECHA_DEMANDA,
        exp.DEJ_FECHA_ENVIO_DEMANDA,
        exp.DEJ_FECHA_DEMANDA_MES,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_MES,
	    exp.DEJ_FECHA_DEMANDA_ANY,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    exp.FECHA_ENTRADA_MES,
	    exp.FECHA_ENTRADA_ANY,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    exp.DIAS_ENTRE_ENVIO_PRESEN,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_FES,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    exp.MAX_FECHA_RES_KO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_ID,
	    exp.SIT_CUADRE_CARTERA_ID,
	    exp.TIENE_FACTURA,
	    exp.FACT_FECHA_FACTURA, 
  		exp.FACT_FECHA_ENVIO, 
  		exp.FACT_FECHA_RECLAMACION_PROCURADOR, 
  		exp.FACT_FECHA_ENVIO_PROCURADOR,  
		exp.FACTURA_ID,
		exp.MOTIVO_FACTURA_ID, 
		exp.EST_FACTURA_ID,
		exp.NUM_FACTURA,
		exp.FACT_BASE_IMP,
		exp.FACT_DTO_MINUTA,
		exp.FACT_IVA,
		exp.FACT_IRPF,
		exp.FACT_TOTAL_MINUTA,
		exp.FACT_IMPORTE_LIQUIDACION,
		exp.FACT_IMPORTE,
		exp.FACT_TIPO_IVA,
		exp.FACT_TIPO_RETENCION,
		exp.FACT_IMPORTE_AJUSTE,
		exp.FACT_IMP_PROVISION_PARCIAL,
		exp.COL_DUMMY_FACT
    from H_EXP exp
--	 	inner join `bi_cdd_conexp_datastage`.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.CEDENTE_ID  
--		inner join `bi_cdd_conexp_datastage`.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id    
    where DIA_ID = max_dia_trimestre
    ;


    -- Detalle KO Trimestre
    insert into H_EXP_DET_KO_TRIMESTRE
        (TRIMESTRE_ID,
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
        )
    select trimestre,
        max_dia_trimestre,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
    from H_EXP_DET_KO 
    where DIA_ID = max_dia_trimestre
   ;
    
    
-- Detalle Factura Mes
    insert into H_EXP_DET_FACTURA_TRIMESTRE
        (TRIMESTRE_ID, 
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
        )
    select trimestre, 
        max_dia_trimestre,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
     from H_EXP_DET_FACTURA 
     where DIA_ID = max_dia_trimestre
     ;


end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_ANIO
-- ----------------------------------------------------------------------------------------------
truncate table TMP_FECHA;
insert into TMP_FECHA (DIA_H) select distinct DIA_ID from H_EXP where DIA_ID between date_start and date_end;
update TMP_FECHA set SEMANA_H = (select SEMANA_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set MES_H = (select MES_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from D_F_DIA fecha where DIA_H = DIA_ID);
update TMP_FECHA set ANIO_H = (select ANIO_ID from D_F_DIA fecha where DIA_H = DIA_ID);

-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los años a insertar
    delete from H_EXP_ANIO where ANIO_ID = anio;
    delete from H_EXP_DET_KO_ANIO where ANIO_ID = anio;
    delete from H_EXP_DET_FACTURA_ANIO where ANIO_ID = anio;
    
    -- Insertado de años (último día del año disponible en H_EXP)
    set max_dia_anio = (select max(DIA_H) from TMP_FECHA where ANIO_H = anio);
    insert into H_EXP_ANIO
        (ANIO_ID,      
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_PROVISION,
        FECHA_ENTRADA,
        FECHA_DEVOLUCION,
        FECHA_ESCANEADO_FIN,
        FECHA_PREP_ENVIO_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FECHA_DOCUMENTACION,
        FECHA_PARALIZACION,
        CEDENTE_ID,
        PROVEEDOR_ID,
        EST_ENTRADA_ID,
        EST_HERRAMIENTA_ID,
        FASE_ID,
        EST_VIDA_ID,
        EST_GESTION_ID,
        PROCURADOR_ID,
        TIPO_PROCEDIMIENTO_ID,
        PLAZA_ID,
        PLAZA_UNICO_ID,
        JUZGADO_ID,
        EST_CONEXP_ID,
        SITUACION_CONEXP_ID,
        NUM_EXPEDIENTES,
        NUM_EXP_INICIADOS,
        IMPORTE_PROVISION,
        DEVOLUCION,
        IMPORTE_PRINCIPAL,
        IMPORTE_LIQUIDACION,
        BASE_IMPORTE,
        ENTIDAD_CEDENTE_ID,
        DEJ_FECHA_DEMANDA,
        DEJ_FECHA_ENVIO_DEMANDA,
        DEJ_FECHA_DEMANDA_MES,
	    DEJ_FECHA_ENVIO_DEMANDA_MES,
	    DEJ_FECHA_DEMANDA_ANY,
	    DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    FECHA_ENTRADA_MES,
	    FECHA_ENTRADA_ANY,
	    DIAS_ENTRE_ENTRADA_ENVIO,
	    DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    DIAS_ENTRE_ENVIO_PRESEN,
	    DIAS_ENTRE_ENVIO_PRESEN_FES,
	    DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    MAX_FECHA_RES_KO,
	    DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    DIAS_ENTRE_ENVIO_PRESEN_ID,
	    SIT_CUADRE_CARTERA_ID,
	    TIENE_FACTURA,
	    FACT_FECHA_FACTURA, 
  		FACT_FECHA_ENVIO, 
  		FACT_FECHA_RECLAMACION_PROCURADOR, 
  		FACT_FECHA_ENVIO_PROCURADOR,  
		FACTURA_ID,
		MOTIVO_FACTURA_ID, 
		EST_FACTURA_ID,
		NUM_FACTURA,
		FACT_BASE_IMP,
		FACT_DTO_MINUTA,
		FACT_IVA,
		FACT_IRPF,
		FACT_TOTAL_MINUTA,
		FACT_IMPORTE_LIQUIDACION,
		FACT_IMPORTE,
		FACT_TIPO_IVA,
		FACT_TIPO_RETENCION,
		FACT_IMPORTE_AJUSTE,
		FACT_IMP_PROVISION_PARCIAL,
		COL_DUMMY_FACT
        )
    select distinct  
    	anio,   
        max_dia_anio,
        EXPEDIENTE_ID,
        FECHA_PROVISION,
        FECHA_ENTRADA,
        FECHA_DEVOLUCION,
        FECHA_ESCANEADO_FIN,
        FECHA_PREP_ENVIO_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FECHA_DOCUMENTACION,
        FECHA_PARALIZACION,
        CEDENTE_ID,
        PROVEEDOR_ID,
        EST_ENTRADA_ID,
        EST_HERRAMIENTA_ID,
        FASE_ID,
        EST_VIDA_ID,
        EST_GESTION_ID,
        PROCURADOR_ID,
        TIPO_PROCEDIMIENTO_ID,
        PLAZA_ID,
        PLAZA_UNICO_ID,
        JUZGADO_ID,
        EST_CONEXP_ID,
        SITUACION_CONEXP_ID,
        NUM_EXPEDIENTES,
        NUM_EXP_INICIADOS,
        IMPORTE_PROVISION,
        DEVOLUCION,
        IMPORTE_PRINCIPAL,
        IMPORTE_LIQUIDACION,
        BASE_IMPORTE,
        exp.ENTIDAD_CEDENTE_ID,
        exp.DEJ_FECHA_DEMANDA,
        exp.DEJ_FECHA_ENVIO_DEMANDA,
        exp.DEJ_FECHA_DEMANDA_MES,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_MES,
	    exp.DEJ_FECHA_DEMANDA_ANY,
	    exp.DEJ_FECHA_ENVIO_DEMANDA_ANY,
	    exp.FECHA_ENTRADA_MES,
	    exp.FECHA_ENTRADA_ANY,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_FES,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_CALC,
	    exp.DIAS_ENTRE_ENVIO_PRESEN,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_FES,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_CALC,
	    exp.MAX_FECHA_RES_KO,
	    exp.DIAS_ENTRE_ENTRADA_ENVIO_ID,
	    exp.DIAS_ENTRE_ENVIO_PRESEN_ID,
	    exp.SIT_CUADRE_CARTERA_ID,
	    exp.TIENE_FACTURA,
	    exp.FACT_FECHA_FACTURA, 
  		exp.FACT_FECHA_ENVIO, 
  		exp.FACT_FECHA_RECLAMACION_PROCURADOR, 
  		exp.FACT_FECHA_ENVIO_PROCURADOR,  
		exp.FACTURA_ID,
		exp.MOTIVO_FACTURA_ID, 
		exp.EST_FACTURA_ID,
		exp.NUM_FACTURA,
		exp.FACT_BASE_IMP,
		exp.FACT_DTO_MINUTA,
		exp.FACT_IVA,
		exp.FACT_IRPF,
		exp.FACT_TOTAL_MINUTA,
		exp.FACT_IMPORTE_LIQUIDACION,
		exp.FACT_IMPORTE,
		exp.FACT_TIPO_IVA,
		exp.FACT_TIPO_RETENCION,
		exp.FACT_IMPORTE_AJUSTE,
		exp.FACT_IMP_PROVISION_PARCIAL,
		exp.COL_DUMMY_FACT
    from H_EXP exp
--     	inner join `bi_cdd_conexp_datastage`.CCC_CARTERA_CLIENTE_CEDENTE ccc on ccc.ccc_id = exp.CEDENTE_ID  
--		inner join `bi_cdd_conexp_datastage`.CCE_CLIENTE_CEDENTE cce on cce.cce_id = ccc.cce_id   
    where DIA_ID = max_dia_anio
    ;


    -- Detalle KO Año
    insert into H_EXP_DET_KO_ANIO
        (ANIO_ID, 
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
        )
    select anio,  
        max_dia_anio,
        EXPEDIENTE_ID,
        FECHA_ALTA_KO,
        FECHA_VENCIMIENTO_KO,
        FECHA_RESOLUCION_KO,
        MOTIVO_KO_ID,
        NUM_KO,
        ENTIDAD_CEDENTE_ID
    from H_EXP_DET_KO 
    where DIA_ID = max_dia_anio
    ;
    

    -- Detalle Factura Mes
    insert into H_EXP_DET_FACTURA_ANIO
        (ANIO_ID,   
        FECHA_CARGA_DATOS,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
        )
    select anio, 
        max_dia_anio,
        EXPEDIENTE_ID,
        FECHA_FACTURA,
        FECHA_ENVIO,
        FECHA_RECLAMACION_PROCURADOR,
        FECHA_ENVIO_PROCURADOR,
        FACTURA_ID,
        MOTIVO_FACTURA_ID,
        EST_FACTURA_ID,
        NUM_FACTURA,
        FACT_BASE_IMP,
        FACT_DTO_MINUTA,
        FACT_IVA,
        FACT_IRPF,
        FACT_TOTAL_MINUTA,
        FACT_IMPORTE_LIQUIDACION,
        FACT_IMPORTE,
        FACT_TIPO_IVA,
        FACT_TIPO_RETENCION,
        FACT_IMPORTE_AJUSTE,
        FACT_IMP_PROVISION_PARCIAL,
        ENTIDAD_CEDENTE_ID,
        COL_DUMMY_FACT
    from H_EXP_DET_FACTURA 
    where DIA_ID = max_dia_anio
    ;

end loop c_anio_loop;
close c_anio;

END MY_BLOCK_H_PRC
