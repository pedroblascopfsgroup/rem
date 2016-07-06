-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `Cargar_H_Prc_Cobros` $$

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`bi_cdd`@`62.15.160.14` PROCEDURE `Cargar_H_Prc_Cobros`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_PCR_COBROS: BEGIN

-- ===============================================================================================
-- Autor: Joaquín Arnal, PFS Group
-- Fecha creación: Marzo 2015
-- Responsable última modificación: 
-- Fecha última modificación: 
-- Motivos del cambio: 
-- Cliente: Recovery BI Central de Demandas 
--
-- Descripción: Procedimiento almacenado que carga las tablas hechos H_PRC_DET_COBRO
-- ===============================================================================================
 
-- ===============================================================================================
--                  				Declaracación de variables
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
--                                      H_PRC_DET_COBRO
-- ----------------------------------------------------------------------------------------------

-- Borrado de los días a insertar
delete from H_PRC_DET_COBRO where DIA_ID between date_start and date_end;

-- ------------------------------------ BUCLE POR DIAS -------------------------------------------
set l_last_row = 0; 

open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if; 
	
    insert into H_PRC_DET_COBRO
    (
		DIA_ID,
		FECHA_CARGA_DATOS,
		ID_COBRO,
		PROCEDIMIENTO_ID,
		ASUNTO_ID,
		CONTRATO_ID,
		FECHA_COBRO,
		FECHA_ASUNTO,
		TIPO_PAGO_ID, -- DD_TCP_ID
		SUBTIPO_PAGO_ID, -- DD_SCP_ID
		ESTADO_PAGO_ID, -- DD_ECP_ID
		NUM_COBROS,
		IMPORTE_COBRO,
		NUM_DIAS_CREACION_ASU_COBRO,
		ENTIDAD_CEDENTE_ID
    )
    SELECT HH.* 
	FROM ( 
	    SELECT 
	      fecha A,
	      fecha B,
	      CPA.CPA_ID,
	      if(CPA.PRC_ID is null, -1, CPA.PRC_ID) PRC_ID,
	      CPA.ASU_ID,
	      if(CPA.CNT_ID is null, -1, CPA.CNT_ID) CNT_ID,
	      CPA.CPA_FECHA,
	      ASU.FECHACREAR,
	      if(CPA.DD_TCP_ID is null, -1, CPA.DD_TCP_ID) DD_TCP_ID,
		  if(CPA.DD_SCP_ID is null, -1, CPA.DD_SCP_ID) DD_SCP_ID,
		  if(CPA.DD_ECP_ID is null, -1, CPA.DD_ECP_ID) DD_ECP_ID,
	      1 C,
	      CPA.CPA_IMPORTE,
	      DATEDIFF(CPA.FECHACREAR,ASU.FECHACREAR),      
	      1 D -- UGAS
	    FROM bi_cdd_bng_datastage.CPA_COBROS_PAGOS CPA
	    	 join bi_cdd_bng_datastage.ASU_ASUNTOS ASU on ASU.ASU_ID=CPA.ASU_ID
	    WHERE CPA.FECHACREAR <= fecha
	    UNION
	    SELECT 
	      fecha A,
	      fecha B,
	      CPA.CPA_ID,
	      if(CPA.PRC_ID is null, -1, CPA.PRC_ID) PRC_ID,
	      CPA.ASU_ID,
	      if(CPA.CNT_ID is null, -1, CPA.CNT_ID) CNT_ID,
	      CPA.CPA_FECHA,
	      ASU.FECHACREAR,
	      if(CPA.DD_TCP_ID is null, -1, CPA.DD_TCP_ID) DD_TCP_ID,
		  if(CPA.DD_SCP_ID is null, -1, CPA.DD_SCP_ID) DD_SCP_ID,
		  if(CPA.DD_ECP_ID is null, -1, CPA.DD_ECP_ID) DD_ECP_ID,
	      1 C,
	      CPA.CPA_IMPORTE,
	      DATEDIFF(CPA.FECHACREAR,ASU.FECHACREAR),      
	      2 D -- BBVA
	    FROM bi_cdd_bbva_datastage.CPA_COBROS_PAGOS CPA
	    	 join bi_cdd_bbva_datastage.ASU_ASUNTOS ASU on ASU.ASU_ID=CPA.ASU_ID
	    WHERE CPA.FECHACREAR <= fecha
	    UNION
	    SELECT 
	      fecha A,
	      fecha B,
	      CPA.CPA_ID,
	      if(CPA.PRC_ID is null, -1, CPA.PRC_ID) PRC_ID,
	      CPA.ASU_ID,
	      if(CPA.CNT_ID is null, -1, CPA.CNT_ID) CNT_ID,
	      CPA.CPA_FECHA,
	      ASU.FECHACREAR,
	      if(CPA.DD_TCP_ID is null, -1, CPA.DD_TCP_ID) DD_TCP_ID,
		  if(CPA.DD_SCP_ID is null, -1, CPA.DD_SCP_ID) DD_SCP_ID,
		  if(CPA.DD_ECP_ID is null, -1, CPA.DD_ECP_ID) DD_ECP_ID,
	      1 C,
	      CPA.CPA_IMPORTE,
	      DATEDIFF(CPA.FECHACREAR,ASU.FECHACREAR),     
	      3 D -- BANKIA
	    FROM bi_cdd_bankia_datastage.CPA_COBROS_PAGOS CPA
	    	 join bi_cdd_bankia_datastage.ASU_ASUNTOS ASU on ASU.ASU_ID=CPA.ASU_ID
	    WHERE CPA.FECHACREAR <= fecha
	    UNION
	    SELECT 
	      fecha A,
	      fecha B,
	      CPA.CPA_ID,
	      if(CPA.PRC_ID is null, -1, CPA.PRC_ID) PRC_ID,
	      CPA.ASU_ID,
	      if(CPA.CNT_ID is null, -1, CPA.CNT_ID) CNT_ID,
	      CPA.CPA_FECHA,
	      ASU.FECHACREAR,
	      if(CPA.DD_TCP_ID is null, -1, CPA.DD_TCP_ID) DD_TCP_ID,
		  if(CPA.DD_SCP_ID is null, -1, CPA.DD_SCP_ID) DD_SCP_ID,
		  if(CPA.DD_ECP_ID is null, -1, CPA.DD_ECP_ID) DD_ECP_ID,
	      1 C,
	      CPA.CPA_IMPORTE,
	      DATEDIFF(CPA.FECHACREAR,ASU.FECHACREAR),     
	      4 D -- CAJAMAR
	    FROM bi_cdd_cajamar_datastage.CPA_COBROS_PAGOS CPA
	    	 join bi_cdd_cajamar_datastage.ASU_ASUNTOS ASU on ASU.ASU_ID=CPA.ASU_ID
	    WHERE CPA.FECHACREAR <= fecha
	   ) HH
	;
     
end loop;
close c_fecha;
-- ------------------------------- FIN BUCLE H_PRC_DET_COBRO  -----------------------------------

-- ----------------------------------------------------------------------------------------------
--                                      H_PRC_DET_COBRO_MES
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
    delete from H_PRC_DET_COBRO_MES where MES_ID = mes;
    
    -- Insertado de meses (último día del mes disponible en H_EXP)
    set max_dia_mes = (select max(DIA_H) from TMP_FECHA where MES_H = mes);
    
    -- Insertado de meses (último día del mes disponible en H_EXP)
    set max_dia_mes = (select max(DIA_H) from TMP_FECHA where MES_H = mes);
    insert into H_PRC_DET_COBRO_MES
        (DIA_ID,
        MES_ID,
		FECHA_CARGA_DATOS,
		ID_COBRO,
		PROCEDIMIENTO_ID,
		ASUNTO_ID,
		CONTRATO_ID,
		FECHA_COBRO,
		FECHA_ASUNTO,
		TIPO_PAGO_ID, -- DD_TCP_ID
		SUBTIPO_PAGO_ID, -- DD_SCP_ID
		ESTADO_PAGO_ID, -- DD_ECP_ID
		NUM_COBROS,
		IMPORTE_COBRO,
		NUM_DIAS_CREACION_ASU_COBRO,
		ENTIDAD_CEDENTE_ID
        )
    select distinct  
    	cob.DIA_ID,
    	mes, 
        max_dia_mes,
		cob.ID_COBRO,
		cob.PROCEDIMIENTO_ID,
		cob.ASUNTO_ID,
		cob.CONTRATO_ID,
		cob.FECHA_COBRO,
		cob.FECHA_ASUNTO,
		cob.TIPO_PAGO_ID,
		cob.SUBTIPO_PAGO_ID,
		cob.ESTADO_PAGO_ID,
		cob.NUM_COBROS,
		cob.IMPORTE_COBRO,
		cob.NUM_DIAS_CREACION_ASU_COBRO,
		cob.ENTIDAD_CEDENTE_ID
    from H_PRC_DET_COBRO cob
    where DIA_ID = max_dia_mes
    ;
   
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_PRC_DET_COBRO_TRIMESTRE
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
    delete from H_PRC_DET_COBRO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    
    -- Insertado de trimestes (último día del trimestre disponible en H_EXP)
    set max_dia_trimestre = (select max(DIA_H) from TMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_PRC_DET_COBRO_TRIMESTRE
        (
        TRIMESTRE_ID,   
        FECHA_CARGA_DATOS,
        ID_COBRO,
		PROCEDIMIENTO_ID,
		ASUNTO_ID,
		CONTRATO_ID,
		FECHA_COBRO,
		FECHA_ASUNTO,
		TIPO_PAGO_ID, -- DD_TCP_ID
		SUBTIPO_PAGO_ID, -- DD_SCP_ID
		ESTADO_PAGO_ID, -- DD_ECP_ID
		NUM_COBROS,
		IMPORTE_COBRO,
		NUM_DIAS_CREACION_ASU_COBRO,
		ENTIDAD_CEDENTE_ID       
        )
    select distinct  
    	trimestre, 
        max_dia_trimestre,
        cob.ID_COBRO,
		cob.PROCEDIMIENTO_ID,
		cob.ASUNTO_ID,
		cob.CONTRATO_ID,
		cob.FECHA_COBRO,
		cob.FECHA_ASUNTO,
		cob.TIPO_PAGO_ID,
		cob.SUBTIPO_PAGO_ID,
		cob.ESTADO_PAGO_ID,
		cob.NUM_COBROS,
		cob.IMPORTE_COBRO,
		cob.NUM_DIAS_CREACION_ASU_COBRO,
		cob.ENTIDAD_CEDENTE_ID
    from H_PRC_DET_COBRO cob
    where DIA_ID = max_dia_trimestre
    ;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_PRC_DET_COBRO_ANIO
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
    delete from H_PRC_DET_COBRO_ANIO where ANIO_ID = anio;
    
    -- Insertado de años (último día del año disponible en H_EXP)
    set max_dia_anio = (select max(DIA_H) from TMP_FECHA where ANIO_H = anio);
    insert into H_PRC_DET_COBRO_ANIO
        (ANIO_ID,      
        FECHA_CARGA_DATOS,
        ID_COBRO,
		PROCEDIMIENTO_ID,
		ASUNTO_ID,
		CONTRATO_ID,
		FECHA_COBRO,
		FECHA_ASUNTO,
		TIPO_PAGO_ID, -- DD_TCP_ID
		SUBTIPO_PAGO_ID, -- DD_SCP_ID
		ESTADO_PAGO_ID, -- DD_ECP_ID
		NUM_COBROS,
		IMPORTE_COBRO,
		NUM_DIAS_CREACION_ASU_COBRO,
		ENTIDAD_CEDENTE_ID
        )
    select distinct  
    	anio,   
        max_dia_anio,
        cob.ID_COBRO,
		cob.PROCEDIMIENTO_ID,
		cob.ASUNTO_ID,
		cob.CONTRATO_ID,
		cob.FECHA_COBRO,
		cob.FECHA_ASUNTO,
		cob.TIPO_PAGO_ID,
		cob.SUBTIPO_PAGO_ID,
		cob.ESTADO_PAGO_ID,
		cob.NUM_COBROS,
		cob.IMPORTE_COBRO,
		cob.NUM_DIAS_CREACION_ASU_COBRO,
		cob.ENTIDAD_CEDENTE_ID
    from H_PRC_DET_COBRO cob
    where DIA_ID = max_dia_anio
    ;

end loop c_anio_loop;
close c_anio;

    
END MY_BLOCK_H_PCR_COBROS
