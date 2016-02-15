-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_H_Contrato`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_CNT: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 12/06/2014
-- Motivos del cambio: actualiación al día (contratos de MOV_MOVIMIENTOS)
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_CONTRATO
-- ===============================================================================================
 
-- ===============================================================================================
--  					Declaracación de variables
-- ===============================================================================================
declare max_dia_h date;
declare max_dia_mov date;
declare penult_dia_mov date;
declare max_dia_con_contratos date;

declare max_dia_mes date;
declare max_dia_trimestre date;
declare max_dia_anio date;
declare max_dia_carga date;
declare max_dia_periodo_ant date;
declare max_mes_periodo_ant int;
declare max_trimestre_periodo_ant int;
declare max_anio_periodo_ant int;
declare primer_dia_mes date;
declare fecha_inicio_campana_recobro date;
declare fecha_recobro date;
declare fecha_especializada date;
declare mes int;
declare trimestre int;
declare anio int;
declare fecha date;
declare fecha_rellenar date;

declare l_last_row int default 0;
declare c_fecha cursor for select distinct (DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end;
declare c_fecha_rellenar cursor for select distinct(DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end;

declare c_fecha_en_recobro cursor for select distinct (DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end;
declare c_fecha_especializada cursor for select distinct (DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end;    

declare c_meses cursor for select distinct MES_ID from DIM_FECHA_DIA  where DIA_ID between date_start and date_end order by 1;
declare c_trimestre cursor for select distinct TRIMESTRE_ID from DIM_FECHA_DIA  where DIA_ID between date_start and date_end order by 1;
declare c_anio cursor for select distinct ANIO_ID from DIM_FECHA_DIA  where DIA_ID between date_start and date_end order by 1; 

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
--                                      H_CONTRATO
-- ----------------------------------------------------------------------------------------------
-- Borrado de los días a insertar
delete from H_CONTRATO where DIA_ID between date_start and date_end;

set max_dia_h = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.H_MOV_MOVIMIENTOS);
set max_dia_mov = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.MOV_MOVIMIENTOS);
set penult_dia_mov = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION < max_dia_mov);
	
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;

	-- Fecha de análisis en H_MOV_MOVIMIENTOS (fecha menor que el últimno día de H_MOV_MOVIMIENTOS o mayor que este pero menor que el penúltimo día de MOV_MOVIMIENTOS)
    if((fecha <= max_dia_h) or ((fecha > max_dia_h) and (fecha < penult_dia_mov))) then
        begin
            set max_dia_con_contratos = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.H_MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);

			insert into H_CONTRATO
               (DIA_ID,
                FECHA_CARGA_DATOS,
                CONTRATO_ID,  
                DIA_POS_VENCIDA_ID, 
                DIA_SALDO_DUDOSO_ID, 
                ESTADO_FINANCIERO_CONTRATO_ID,
                ESTADO_FINANCIERO_ANTERIOR_ID,
                ESTADO_CONTRATO_ID,  
                CONTRATO_JUDICIALIZADO_ID,
                CONTRATO_ESTADO_JUDICIALIZADO_ID,
                EN_GESTION_RECOBRO_ID,
                EN_GESTION_ESPECIALIZADA_ID,
                TRAMO_IRREGULARIDAD_FASES_ID,
                EN_CARTERA_ESTUDIO_ID,
                CONTRATO_CON_CAPITAL_FALLIDO_ID,
                NUM_CONTRATOS,
                NUM_DIAS_VENCIDOS,
                SALDO_TOTAL,
                POSICION_VIVA_NO_VENCIDA,
                POSICION_VIVA_VENCIDA,
                SALDO_DUDOSO,
                PROVISION,
                INTERESES_REMUNERATORIOS,
                INTERESES_MORATORIOS,
                COMISIONES,
                GASTOS,
                RIESGO,
                DEUDA_IRREGULAR,
                DISPUESTO,
                SALDO_PASIVO,
                RIESGO_GARANTIA,
                SALDO_EXCE,
                LIMITE_DESC,
                MOV_EXTRA_1,
                MOV_EXTRA_2,
                MOV_LTV_INI,
                MOV_LTV_FIN,
                DD_MX3_ID,
                DD_MX4_ID,
                CNT_LIMITE_INI,
                CNT_LIMITE_FIN,
                IMPORTE_A_RECLAMAR,
                DEUDA_EXIGIBLE,
                CAPITAL_FALLIDO
               )
              select fecha, 
                fecha,
                CNT_ID, 
                MOV_FECHA_POS_VENCIDA, 
                MOV_FECHA_DUDOSO, 
                coalesce(DD_EFC_ID,-1),
                coalesce(DD_EFC_ID_ANT,-1),
                coalesce(DD_ESC_ID,-1),
                0,
                -2,
                0,
                0,
                (case MOV_TRAMO_IRREGULARIDAD when 'A' then 1
                                              when 'B' then 2
                                              when 'C' then 3
                                              when 'D' then 4
                                              when 'E' then 5
                                              when 'F' then 6
                                              when 'G' then 7
                                              when 'H' then 8
                                              when 'X' then 9
                                              else -1 end),
                0,
                (case when MOV_CAPITAL_FALLIDO <= 0 then 0
                      when MOV_CAPITAL_FALLIDO > 0 then 1  
                      else -1 end),
                1,
                coalesce(datediff(MOV_FECHA_EXTRACCION, MOV_FECHA_POS_VENCIDA),0),
                MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA, 
                MOV_POS_VIVA_NO_VENCIDA, 
                MOV_POS_VIVA_VENCIDA, 
                MOV_SALDO_DUDOSO, 
                MOV_PROVISION, 
                MOV_INT_REMUNERATORIOS, 
                MOV_INT_MORATORIOS, 
                MOV_COMISIONES, 
                MOV_GASTOS, 
                MOV_RIESGO, 
                MOV_DEUDA_IRREGULAR, 
                MOV_DISPUESTO, 
                MOV_SALDO_PASIVO, 
                MOV_RIESGO_GARANT, 
                MOV_SALDO_EXCE, 
                MOV_LIMITE_DESC, 
                MOV_EXTRA_1, 
                MOV_EXTRA_2, 
                MOV_LTV_INI, 
                MOV_LTV_FIN,
                DD_MX3_ID,
                DD_MX4_ID,
                CNT_LIMITE_INI,
                CNT_LIMITE_FIN,
                MOV_POS_VIVA_VENCIDA + MOV_GASTOS +  MOV_INT_REMUNERATORIOS + MOV_INT_MORATORIOS + MOV_COMISIONES,
                MOV_DEUDA_EXIGIBLE,
                MOV_CAPITAL_FALLIDO
            from recovery_lindorff_datastage.H_MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION = max_dia_con_contratos and BORRADO = 0; 
         end;
         
    -- Fecha de análisis en MOV_MOVIMIENTOS - Penúltimo o último día
    elseif(fecha = penult_dia_mov or fecha = max_dia_mov) then
        begin			
            insert into H_CONTRATO
               (DIA_ID,
                FECHA_CARGA_DATOS,
                CONTRATO_ID,  
                DIA_POS_VENCIDA_ID, 
                DIA_SALDO_DUDOSO_ID, 
                ESTADO_FINANCIERO_CONTRATO_ID,
                ESTADO_FINANCIERO_ANTERIOR_ID,
                ESTADO_CONTRATO_ID,  
                CONTRATO_JUDICIALIZADO_ID,
                CONTRATO_ESTADO_JUDICIALIZADO_ID,
                EN_GESTION_RECOBRO_ID,
                EN_GESTION_ESPECIALIZADA_ID,
                EN_CARTERA_ESTUDIO_ID,
                NUM_CONTRATOS,
                NUM_DIAS_VENCIDOS,
                SALDO_TOTAL,
                POSICION_VIVA_NO_VENCIDA,
                POSICION_VIVA_VENCIDA,
                SALDO_DUDOSO,
                PROVISION,
                INTERESES_REMUNERATORIOS,
                INTERESES_MORATORIOS,
                COMISIONES,
                GASTOS,
                RIESGO,
                DEUDA_IRREGULAR,
                DISPUESTO,
                SALDO_PASIVO,
                RIESGO_GARANTIA,
                SALDO_EXCE,
                LIMITE_DESC,
                MOV_EXTRA_1,
                MOV_EXTRA_2,
                MOV_LTV_INI,
                MOV_LTV_FIN,
                DD_MX3_ID,
                DD_MX4_ID,
                CNT_LIMITE_INI,
                CNT_LIMITE_FIN,
                IMPORTE_A_RECLAMAR
               )
            select fecha, 
                fecha,
                mov.CNT_ID, 
                MOV_FECHA_POS_VENCIDA, 
                MOV_FECHA_DUDOSO, 
                coalesce(DD_EFC_ID,-1),
                coalesce(DD_EFC_ID_ANT,-1),
                coalesce(DD_ESC_ID,-1),
                0,
                -2,
                0,
                0,
                0,
                1,
                coalesce(datediff(MOV_FECHA_EXTRACCION, MOV_FECHA_POS_VENCIDA),0),
                MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA, 
                MOV_POS_VIVA_NO_VENCIDA, 
                MOV_POS_VIVA_VENCIDA, 
                MOV_SALDO_DUDOSO, 
                MOV_PROVISION, 
                MOV_INT_REMUNERATORIOS, 
                MOV_INT_MORATORIOS, 
                MOV_COMISIONES, 
                MOV_GASTOS, 
                MOV_RIESGO, 
                MOV_DEUDA_IRREGULAR, 
                MOV_DISPUESTO, 
                MOV_SALDO_PASIVO, 
                MOV_RIESGO_GARANT, 
                MOV_SALDO_EXCE, 
                MOV_LIMITE_DESC, 
                MOV_EXTRA_1, 
                MOV_EXTRA_2, 
                MOV_LTV_INI, 
                MOV_LTV_FIN,
                DD_MX3_ID,
                DD_MX4_ID,
                CNT_LIMITE_INI,
                CNT_LIMITE_FIN,
                MOV_POS_VIVA_VENCIDA + MOV_GASTOS +  MOV_INT_REMUNERATORIOS + MOV_INT_MORATORIOS + MOV_COMISIONES
                from recovery_lindorff_datastage.MOV_MOVIMIENTOS mov, recovery_lindorff_datastage.CNT_CONTRATOS cnt where mov.CNT_ID = cnt.CNT_ID and
                mov.MOV_FECHA_EXTRACCION = fecha and mov.BORRADO = 0;		
        end;
    end if;
	

    -- Contratos judicializados que han dejado de venir en H_MOV_MOVIMIENTOS
    truncate table TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES;
    insert into TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES (CONTRATO_ID)
    select CONTRATO_ID from H_PROCEDIMIENTO_DETALLE_CONTRATO h where dia_id = fecha and h.CONTRATO_ID not in (select CONTRATO_ID from H_CONTRATO where DIA_ID = fecha);
    
    
    RESTANTES: BEGIN
        declare fecha_restantes date;
        declare l_last_row_restantes int default 0;
        declare restantes_sin_fecha int; 
        declare c_fecha_restantes cursor for select distinct DIA_ID from H_CONTRATO order by 1 desc;
        declare continue HANDLER FOR NOT FOUND SET l_last_row_restantes = 1;  

        set l_last_row_restantes = 0; 
        
        open c_fecha_restantes;
        restantes_loop: loop
        fetch c_fecha_restantes into fecha_restantes;        
            if (l_last_row_restantes = 1) then leave read_loop; 
            end if;
            
            set restantes_sin_fecha = (select count(*) from TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES where ULTIMO_DIA_CONTRATO is null);
            if (restantes_sin_fecha = 0) then leave read_loop; 
            end if;
            
            truncate table TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX;
            insert into TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX (CONTRATO_ID, MOV_FECHA_EXTRACCION)
            select CNT_ID, MOV_FECHA_EXTRACCION from recovery_lindorff_datastage.H_MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION = fecha_restantes;
            
            update TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES tmpr, TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES_AUX aux set ULTIMO_DIA_CONTRATO = MOV_FECHA_EXTRACCION
                where aux.CONTRATO_ID = tmpr.CONTRATO_ID and aux.MOV_FECHA_EXTRACCION = fecha_restantes and ULTIMO_DIA_CONTRATO is null;
            
        end loop; 
        close c_fecha_restantes;
    END RESTANTES;
 
    insert into H_CONTRATO
        (DIA_ID,  
        CONTRATO_ID,  
        DIA_POS_VENCIDA_ID, 
        DIA_SALDO_DUDOSO_ID, 
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,  
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        EN_GESTION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        EN_CARTERA_ESTUDIO_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        NUM_CONTRATOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        IMPORTE_A_RECLAMAR,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO
        )
        select fecha, 
        CNT_ID, 
        MOV_FECHA_POS_VENCIDA, 
        MOV_FECHA_DUDOSO, 
        coalesce(DD_EFC_ID,-1),
        coalesce(DD_EFC_ID_ANT,-1),
        coalesce(DD_ESC_ID,-1),
        0,
        -2,
        0,
        0,
        (case MOV_TRAMO_IRREGULARIDAD when 'A' then 1
                                      when 'B' then 2
                                      when 'C' then 3
                                      when 'D' then 4
                                      when 'E' then 5
                                      when 'F' then 6
                                      when 'G' then 7
                                      when 'H' then 8
                                      when 'X' then 9
                                      else -1 end),
        0,
        (case when MOV_CAPITAL_FALLIDO <= 0 then 0
              when MOV_CAPITAL_FALLIDO > 0 then 1  
              else -1 end),
        1,
        coalesce(datediff(MOV_FECHA_EXTRACCION, MOV_FECHA_POS_VENCIDA),0),
        MOV_POS_VIVA_NO_VENCIDA + MOV_POS_VIVA_VENCIDA, 
        MOV_POS_VIVA_NO_VENCIDA, 
        MOV_POS_VIVA_VENCIDA, 
        MOV_SALDO_DUDOSO, 
        MOV_PROVISION, 
        MOV_INT_REMUNERATORIOS, 
        MOV_INT_MORATORIOS, 
        MOV_COMISIONES, 
        MOV_GASTOS, 
        MOV_RIESGO, 
        MOV_DEUDA_IRREGULAR, 
        MOV_DISPUESTO, 
        MOV_SALDO_PASIVO, 
        MOV_RIESGO_GARANT, 
        MOV_SALDO_EXCE, 
        MOV_LIMITE_DESC, 
        MOV_EXTRA_1, 
        MOV_EXTRA_2, 
        MOV_LTV_INI, 
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        MOV_POS_VIVA_VENCIDA + MOV_GASTOS +  MOV_INT_REMUNERATORIOS + MOV_INT_MORATORIOS + MOV_COMISIONES,
        MOV_DEUDA_EXIGIBLE,
        MOV_CAPITAL_FALLIDO
        from TEMP_CONTRATOS_JUDICIALIZADOS_RESTANTES res, recovery_lindorff_datastage.H_MOV_MOVIMIENTOS hmov where res.CONTRATO_ID = hmov.CNT_ID and
        hmov.MOV_FECHA_EXTRACCION = ULTIMO_DIA_CONTRATO and BORRADO = 0;     

end loop;
close c_fecha;



-- Rellenar los días que no tienen entradas de contratos. No ha existido ningún movimiento. La foto es la del día anterior.
set l_last_row = 0; 

open c_fecha_rellenar;
rellenar_loop: loop
fetch c_fecha_rellenar into fecha_rellenar;        
    if (l_last_row=1) then leave rellenar_loop; 
    end if;
    
    -- Si un día no ha habido movimiento copiamos dia anterior
    if((select count(DIA_ID) from H_CONTRATO where DIA_ID = fecha_rellenar) = 0) then 
    insert into H_CONTRATO
       (DIA_ID,
        CONTRATO_ID,  
        DIA_POS_VENCIDA_ID, 
        DIA_SALDO_DUDOSO_ID, 
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,  
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        EN_GESTION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        EN_CARTERA_ESTUDIO_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        NUM_CONTRATOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        IMPORTE_A_RECLAMAR,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO
       )
    select date_add(DIA_ID, INTERVAL 1 DAY),                             
        CONTRATO_ID,  
        DIA_POS_VENCIDA_ID, 
        DIA_SALDO_DUDOSO_ID, 
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,  
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        EN_GESTION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        EN_CARTERA_ESTUDIO_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        NUM_CONTRATOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        IMPORTE_A_RECLAMAR,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO
        from H_CONTRATO where DIA_ID = date_add(fecha_rellenar, INTERVAL -1 DAY);
    end if; 
end loop;
close c_fecha_rellenar;


-- HEREDADO DE UNNIM
/*
-- ------------------------------------------------------ SITUACION_CONTRATO_DETALLE_ID ------------------------------------------------------

-- -------------------------------- Actualizar Situación del contrato --------------------------------
-- -1 Desconocido, 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, 3 Vencido > 60 días, 4 Dudoso no litigio, 5 Dudoso Litigio, 6 Fallido Litigio, 7 Resto Fallido 

-- Truncar tablas temporales
truncate table TEMP_CONTRATO_SITUACION_FINANCIERA;
truncate table TEMP_CONTRATO_PROCEDIMIENTO_AUX;
truncate table TEMP_CONTRATO_PROCEDIMIENTO;

-- Cargar en TEMP_CONTRATO_SITUACION_FINANCIERA la relación de todos los contratos con estado financiero FALLIDO
insert into TEMP_CONTRATO_SITUACION_FINANCIERA (CONTRATO_ID, SITUACION_FINANCIERA_DESC)
    select CNT_ID, efc.DD_EFC_DESCRIPCION_LARGA FROM recovery_lindorff_datastage.CNT_CONTRATOS cnt 
    join recovery_lindorff_datastage.DD_EFC_ESTADO_FINAN_CNT efc on efc.DD_EFC_ID = cnt.DD_EFC_ID 
    where efc.DD_EFC_DESCRIPCION_LARGA='FALLIDO';

-- Todos los contratos fallidos los pongo a 10 (Resto Fallido)
update H_CONTRATO set SITUACION_CONTRATO_DETALLE_ID = 10 where CONTRATO_ID in (select CONTRATO_ID from TEMP_CONTRATO_SITUACION_FINANCIERA);

-- Tabla temporal para calcular si el contrato tiene asociado un procedimiento en litigio o no litigio
insert into TEMP_CONTRATO_PROCEDIMIENTO_AUX(CONTRATO_ID, PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC) 
    select CNT_ID, prc.PRC_ID, epr.DD_EPR_ID, epr.DD_EPR_DESCRIPCION FROM recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex 
    join recovery_lindorff_datastage.PRC_CEX prc_cex ON prc_cex.CEX_ID=cex.CEX_ID
    join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc ON prc_cex.PRC_ID = prc.PRC_ID
    join recovery_lindorff_datastage.DD_EPR_ESTADO_PROCEDIMIENTO epr on prc.DD_EPR_ID = epr.DD_EPR_ID;
    
-- Truncar la tabla TEMP_CONTRATO_SITUACION_FINANCIERA e incluir los estados de los contratos con procedimientos asociados
truncate table TEMP_CONTRATO_SITUACION_FINANCIERA;

insert into TEMP_CONTRATO_SITUACION_FINANCIERA (CONTRATO_ID, SITUACION_FINANCIERA_DESC)
    select distinct (CONTRATO_ID), efc.DD_EFC_DESCRIPCION_LARGA FROM TEMP_CONTRATO_PROCEDIMIENTO_AUX tmp
    join recovery_lindorff_datastage.CNT_CONTRATOS cnt on tmp.CONTRATO_ID = cnt.CNT_ID
    join recovery_lindorff_datastage.DD_EFC_ESTADO_FINAN_CNT efc on efc.DD_EFC_ID = cnt.DD_EFC_ID;
    
-- Join final. Tabla con los contratos, sus procedimientos asociados, el estado de este y el estado del contrato.
insert into TEMP_CONTRATO_PROCEDIMIENTO (CONTRATO_ID, PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, SITUACION_FINANCIERA_DESC) 
    select tmp.CONTRATO_ID, PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_DESC, SITUACION_FINANCIERA_DESC FROM TEMP_CONTRATO_PROCEDIMIENTO_AUX tmp
    join TEMP_CONTRATO_SITUACION_FINANCIERA tmp_f on tmp_f.CONTRATO_ID = tmp.CONTRATO_ID;

-- Contrato Judicializado (1 Judicializado, 0 No Judicializado)
update H_CONTRATO set CONTRATO_JUDICIALIZADO_ID = (case when CONTRATO_ID in (select CONTRATO_ID from TEMP_CONTRATO_PROCEDIMIENTO where ESTADO_PROCEDIMIENTO_DESC = 'Aceptado' or ESTADO_PROCEDIMIENTO_DESC = 'Derivado') then 1
                                                        else 0 end);

-- -------------------------------- SITUACION_CONTRATO: 9 Fallido Litigio, 10 Resto Fallido --------------------------------
-- De los contratos fallidos actualizo los que tienen procedimiento asociado (7 Fallido Litigio)
update H_CONTRATO set SITUACION_CONTRATO_DETALLE_ID = 9 where (SITUACION_CONTRATO_DETALLE_ID = 10) and CONTRATO_JUDICIALIZADO_ID = 1; 

-- -------------------------------- SITUACION_CONTRATO:  7 Dudoso no litigio, 8 Dudoso Litigio --------------------------------
update H_CONTRATO set SITUACION_CONTRATO_DETALLE_ID = (case when CONTRATO_JUDICIALIZADO_ID = 1 then 8
                                                            else 7
                                                       end) where SITUACION_CONTRATO_DETALLE_ID is null and  SALDO_DUDOSO > 0;
                                                                 
-- -------------------------------- SITUACION_CONTRATO: 1 Vencido < 30 Días No Litigio, 2 Vencido 30-60 Días No Litigio, 3 Vencido > 60 Días No Litigio ------------------------------
-- --------------------------------                   : 4 Vencido < 30 Días Litigio,    5 Vencido 30-60 Días Litigio,    6 Vencido > 60 Días Litigio    ------------------------------
update H_CONTRATO set SITUACION_CONTRATO_DETALLE_ID = (case when NUM_DIAS_VENCIDOS <= 30 then 1
                                                            when NUM_DIAS_VENCIDOS > 30 and NUM_DIAS_VENCIDOS <= 60 then 2
                                                            when NUM_DIAS_VENCIDOS > 60 then 3
                                                       end)                                                                  
                                                            where SITUACION_CONTRATO_DETALLE_ID is null and NUM_DIAS_VENCIDOS > 0 and CONTRATO_JUDICIALIZADO_ID = 0;

update H_CONTRATO set SITUACION_CONTRATO_DETALLE_ID = (case when NUM_DIAS_VENCIDOS <= 30 then 4
                                                            when NUM_DIAS_VENCIDOS > 30 and NUM_DIAS_VENCIDOS <= 60 then 5
                                                            when NUM_DIAS_VENCIDOS > 60 then 6
                                                       end)                                                           
                                                            where SITUACION_CONTRATO_DETALLE_ID is null and NUM_DIAS_VENCIDOS > 0 and CONTRATO_JUDICIALIZADO_ID = 1;
                                                                 
-- -------------------------------- SITUACION_CONTRATO: 0 Normal --------------------------------
update H_CONTRATO set SITUACION_CONTRATO_DETALLE_ID = 0 where SITUACION_CONTRATO_DETALLE_ID is null and POSICION_VIVA_VENCIDA <= 0 and DIA_POS_VENCIDA_ID is null or DIA_POS_VENCIDA_ID=DIA_ID;

-- El resto son desconocidos
update H_CONTRATO set SITUACION_CONTRATO_DETALLE_ID = -1 where SITUACION_CONTRATO_DETALLE_ID is null;


-- ------------------------------------------------------ CREDITOS_INSINUADOS ------------------------------------------------------ 
-- Calcular número de créditos insinuados asociados a un contrato y sus importes (Princpal externo, supervisor y final)
truncate table TEMP_CONTRATO_CREDITO_INSINUADO;
insert into TEMP_CONTRATO_CREDITO_INSINUADO 
        (CONTRATO_ID, 
         CREDITO_ID, 
         ESTADO_INSINUACION_CONTRATO_ID, 
         CREDITO_PRINCIPAL_EXTERNO, 
         CREDITO_PRINCIPAL_SUPERVISOR, 
         CREDITO_PRINCIPAL_FINAL,
         FECHA_CREDITO
        ) 
select cnt.CNT_ID, 
       cre.CRE_CEX_ID,
       cre.STD_CRE_ID,
       cre.CRE_PRINCIPAL_EXT,
       cre.CRE_PRINCIPAL_SUP,
       cre.CRE_PRINCIPAL_FINAL,
       date(cre.FECHACREAR)
from recovery_lindorff_datastage.CRE_PRC_CEX cre 
join recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex on cre.CRE_PRC_CEX_CEXID = cex.CEX_ID
join recovery_lindorff_datastage.CNT_CONTRATOS cnt on cnt.CNT_ID = cex.CNT_ID
where cre.BORRADO=0; 

-- A partir de la fecha que se insinúa el crédito
update H_CONTRATO h set NUM_CREDITOS_INSINUADOS = (select count(*) from TEMP_CONTRATO_CREDITO_INSINUADO tmp where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID >= tmp.FECHA_CREDITO);
update H_CONTRATO h set CREDITO_INSINUADO_PRINCIPAL_EXTERNO = (select sum(CREDITO_PRINCIPAL_EXTERNO) from TEMP_CONTRATO_CREDITO_INSINUADO tmp where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID >= tmp.FECHA_CREDITO);                                                          
update H_CONTRATO h set CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR = (select sum(CREDITO_PRINCIPAL_SUPERVISOR) from TEMP_CONTRATO_CREDITO_INSINUADO tmp where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID >= tmp.FECHA_CREDITO);
update H_CONTRATO h set CREDITO_INSINUADO_PRINCIPAL_FINAL = (select sum(CREDITO_PRINCIPAL_FINAL) from TEMP_CONTRATO_CREDITO_INSINUADO tmp where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID >= tmp.FECHA_CREDITO);
-- !!! MIRAR: un contrato puede tener creditos insinuados con estados de insinuación distintos al estar en varios expedientes.
update H_CONTRATO h set ESTADO_INSINUACION_CONTRATO_ID = (select ESTADO_INSINUACION_CONTRATO_ID from TEMP_CONTRATO_CREDITO_INSINUADO tmp where h.CONTRATO_ID = tmp.CONTRATO_ID and h.DIA_ID >= tmp.FECHA_CREDITO group by CONTRATO_ID);
*/


-- ------------------------------------------------------ SITUACION_RESPECTO_PERIODO_ANT_ID ------------------------------------------------------
truncate table TEMP_BAJA;

-- Calculamos las Fechas H (tabla hechos) y ANT (Periodo anterior)
truncate table TEMP_FECHA;
truncate table TEMP_FECHA_AUX;
insert into TEMP_FECHA (DIA_H) select distinct (DIA_ID) from DIM_FECHA_DIA where DIA_ID between date_start and date_end;
-- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
set max_dia_periodo_ant = (select max(DIA_ID) from H_CONTRATO where DIA_ID < date_start);
insert into TEMP_FECHA (DIA_H) select max_dia_periodo_ant;
insert into TEMP_FECHA_AUX (DIA_AUX) select DIA_H from TEMP_FECHA;
update TEMP_FECHA set DIA_ANT = (select MIN(DIA_AUX) from TEMP_FECHA_AUX where DIA_AUX > DIA_H);
update TEMP_FECHA set DIA_ANT = date_add(DIA_H, INTERVAL 1 DAY) where DIA_ANT is null;

-- Cargamos TEMP_H y TEMP_ANT
truncate table TEMP_H;
truncate table TEMP_ANT;

-- Incluimos en TEMP_H y TEMP_ANT el max_dia_periodo_ant para poder comparar con date_start
insert into TEMP_H (DIA_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
select DIA_ID, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
where DIA_ID = max_dia_periodo_ant; 

insert into TEMP_ANT (DIA_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
select DIA_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
where DIA_H = max_dia_periodo_ant;

set l_last_row = 0;  
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;

    -- TEMP_H - Contratos de cada periodo
    insert into TEMP_H (DIA_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
    select DIA_ID, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
    where DIA_ID = fecha; 
    
    -- TEMP_ANT - Contratos del periodo anterior (no tiene que haber contratos todos los días necesariamente). 
    insert into TEMP_ANT (DIA_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
    select DIA_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
    where DIA_H = fecha;
    
end loop;
close c_fecha;  

-- Actualizamos las fechas para poder comparar con TEMP_H en el mismo día. Ej. El día 30 TEMP_H tiene los contratos del día 30 y TEMP_ANT los del 29.
update TEMP_ANT ant, TEMP_FECHA fech set ant.DIA_ANT = fech.DIA_ANT where ant.DIA_ANT = fech.DIA_H;

set l_last_row = 0;  
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;

    truncate table TEMP_ALTA;
    truncate table TEMP_MANTIENE;

    -- TEMP_MANTIENE - Contratos que están en TEMP_H y en TEMP_ANT
    insert into TEMP_MANTIENE (DIA_ID, CONTRATO_ID) 
    select DIA_H, CONTRATO_H from TEMP_H join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and DIA_H = DIA_ANT
    where DIA_H = fecha; 

    -- TEMP_ALTA - Contratos que están en TEMP_H pero no en H_TEMP_ANT
    insert into TEMP_ALTA (DIA_ID, CONTRATO_ID) 
    select DIA_H, CONTRATO_H from TEMP_H left join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and DIA_H = DIA_ANT
    where DIA_H = fecha and CONTRATO_ANT is null;

    -- TEMP_BAJA - Contratos que están en TEMP_ANT pero no en TEMP_H. Incluye DIA_MOV para encontrar los contratos en H_CONTRATO
    insert into TEMP_BAJA (DIA_H, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)  
    select DIA_ANT, CONTRATO_ANT, ant.SITUACION_CONTRATO_DETALLE_ANT, ant.NUM_DIAS_VENCIDOS_PERIODO_ANT, ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT from TEMP_ANT ant left join TEMP_H on CONTRATO_H = CONTRATO_ANT and DIA_H = DIA_ANT 
    where DIA_ANT = fecha and CONTRATO_H is null and DIA_ANT is not null;


    -- SITUACION_RESPECTO_PERIODO_ANT_ID - 0 Mantiene, 1 Alta, 2 Baja
    update H_CONTRATO h, TEMP_MANTIENE man set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 0 where h.DIA_ID = fecha and h.DIA_ID = man.DIA_ID and h.CONTRATO_ID = man.CONTRATO_ID;
    update H_CONTRATO h, TEMP_ALTA alt set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 1 where h.DIA_ID = fecha and h.DIA_ID = alt.DIA_ID and h.CONTRATO_ID = alt.CONTRATO_ID;

--     UNNIM
--     -- SITUACION_ANTERIOR_CONTRATO_DETALLE_ID - 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
--     -- Si alta no tiene situación anterior.
--     update H_CONTRATO h set SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = -2 where h.DIA_ID = fecha and SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)
--     -- El resto adquiere el del periodo anterior                             
--     update H_CONTRATO h, TEMP_ANT ant set h.SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = ant.SITUACION_CONTRATO_DETALLE_ANT where h.DIA_ID = fecha and h.DIA_ID = ant.DIA_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and SITUACION_ANTERIOR_CONTRATO_DETALLE_ID is null;
    
    
    -- NUM_DIAS_VENCIDOS_PERIODO_ANT                           
    update H_CONTRATO h, TEMP_ANT ant set h.NUM_DIAS_VENCIDOS_PERIODO_ANT = ant.NUM_DIAS_VENCIDOS_PERIODO_ANT where h.DIA_ID = fecha and h.DIA_ID = ant.DIA_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT;


    -- TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT 
    -- Si alta no tiene situación anterior.
    update H_CONTRATO h set TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = -2 where h.DIA_ID = fecha and SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)
    -- El resto adquiere el del periodo anterior                              
    update H_CONTRATO h, TEMP_ANT ant set h.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where h.DIA_ID = fecha and h.DIA_ID = ant.DIA_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID is null;
                               

    -- ------------------------------------------------------ UPDATES ------------------------------------------------------
    -- Calcular clientes y expedientes asociados a cada contrato
    update H_CONTRATO set NUM_CLIENTES_ASOCIADOS = (select count(*) from recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS where CNT_ID = CONTRATO_ID) where DIA_ID = fecha;
    update H_CONTRATO set NUM_EXPEDIENTES_ASOCIADOS = (select count(*) from recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE where CNT_ID = CONTRATO_ID) where DIA_ID = fecha;


    -- Contrato en irregular
    update H_CONTRATO set CONTRATO_EN_IRREGULAR_ID = (case when NUM_DIAS_VENCIDOS <= 0 then 0
                                                           when NUM_DIAS_VENCIDOS > 0 then 1  
                                                           else -1 end) where DIA_ID = fecha; 

    -- Tramo Irregularidad - Fases (completa la carga incial)
    update H_CONTRATO set TRAMO_IRREGULARIDAD_FASES_ID = 0 where TRAMO_IRREGULARIDAD_FASES_ID = -1 and NUM_DIAS_VENCIDOS <= 0 and DIA_ID = fecha;
    -- Tramo Irregularidad - Días
    update H_CONTRATO set TRAMO_IRREGULARIDAD_DIAS_ID = (case when NUM_DIAS_VENCIDOS <= 0 then 0
                                                              when NUM_DIAS_VENCIDOS > 0 and NUM_DIAS_VENCIDOS <= 30 then 1
                                                              when NUM_DIAS_VENCIDOS > 30 and NUM_DIAS_VENCIDOS <= 60 then 2
                                                              when NUM_DIAS_VENCIDOS > 60 and NUM_DIAS_VENCIDOS <= 90 then 3
                                                              when NUM_DIAS_VENCIDOS > 90 and NUM_DIAS_VENCIDOS <= 120 then 4
                                                              when NUM_DIAS_VENCIDOS > 120 and timestampdiff(YEAR, DIA_POS_VENCIDA_ID, DIA_ID) <= 0 then 5
                                                              when timestampdiff(YEAR, DIA_POS_VENCIDA_ID, DIA_ID) > 0 and timestampdiff(YEAR, DIA_POS_VENCIDA_ID, DIA_ID) <= 2 then 6
                                                              when timestampdiff(YEAR, DIA_POS_VENCIDA_ID, DIA_ID) > 2 then 7
                                                              else -1 end) where DIA_ID = fecha; 
     
    update H_CONTRATO set TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = (case when NUM_DIAS_VENCIDOS_PERIODO_ANT <= 0 then 0
                                                              when NUM_DIAS_VENCIDOS_PERIODO_ANT > 0 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 30 then 1
                                                              when NUM_DIAS_VENCIDOS_PERIODO_ANT > 30 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 60 then 2
                                                              when NUM_DIAS_VENCIDOS_PERIODO_ANT > 60 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 90 then 3
                                                              when NUM_DIAS_VENCIDOS_PERIODO_ANT > 90 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 120 then 4
                                                              when NUM_DIAS_VENCIDOS_PERIODO_ANT > 120 and timestampdiff(YEAR, date_add(DIA_POS_VENCIDA_ID, INTERVAL -1 DAY), DIA_ID) <= 0 then 5
                                                              when timestampdiff(YEAR, date_add(DIA_POS_VENCIDA_ID, INTERVAL -1 DAY), DIA_ID) > 0 and timestampdiff(YEAR, date_add(DIA_POS_VENCIDA_ID, INTERVAL -1 DAY), DIA_ID) <= 2 then 6
                                                              when timestampdiff(YEAR, date_add(DIA_POS_VENCIDA_ID, INTERVAL -1 DAY), DIA_ID) > 2 then 7
                                                              else -1 end) where DIA_ID = fecha; 
                                                              
    update H_CONTRATO h, recovery_lindorff_datastage.CNT_CONTRATOS cnt set h.FECHA_CREACION_CONTRATO = date(cnt.FECHACREAR) where h.DIA_ID = fecha and h.CONTRATO_ID = cnt.CNT_ID;
    
    update H_CONTRATO h, H_PROCEDIMIENTO_DETALLE_CONTRATO cntdet set h.CONTRATO_JUDICIALIZADO_ID = 1 where h.DIA_ID = fecha and h.DIA_ID = cntdet.DIA_ID and h.CONTRATO_ID = cntdet.CONTRATO_ID;
    
  
    truncate table TEMP_CONTRATO_PROCEDIMIENTO_AUX;
    insert into TEMP_CONTRATO_PROCEDIMIENTO_AUX
        (CONTRATO_ID,
         PROCEDIMIENTO_ID,
         ESTADO_PROCEDIMIENTO_ID)
    select CONTRATO_ID, prc.PROCEDIMIENTO_ID, ESTADO_PROCEDIMIENTO_ID from H_PROCEDIMIENTO prc 
    join H_PROCEDIMIENTO_DETALLE_CONTRATO d on d.PROCEDIMIENTO_ID = prc.PROCEDIMIENTO_ID and d.DIA_ID = prc.DIA_ID
    join DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE tp on tp.TIPO_PROCEDIMIENTO_DETALLE_ID = prc.TIPO_PROCEDIMIENTO_DETALLE_ID 
    where prc.DIA_ID = fecha;
    
    update H_CONTRATO hc, TEMP_CONTRATO_PROCEDIMIENTO_AUX cpaux set hc.CONTRATO_ESTADO_JUDICIALIZADO_ID = (case cpaux.ESTADO_PROCEDIMIENTO_ID
                                                                                                   when '1' then 0 -- Judicializado No activo
                                                                                                   when '0' then 1 -- Judicializado Activo
                                                                                                   end) where hc.DIA_ID = fecha and hc.CONTRATO_ID = cpaux.CONTRATO_ID;

/*                                                              
    truncate table TEMP_CONTRATO_PROCEDIMIENTO_AUX;
    insert into TEMP_CONTRATO_PROCEDIMIENTO_AUX
        (CONTRATO_ID,
         PROCEDIMIENTO_ID,
         TIPO_PROCEDIMIENTO_AGRUPADO_ID)
    select CONTRATO_ID, prc.PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_AGRUPADO_ID from H_PROCEDIMIENTO prc 
    join H_PROCEDIMIENTO_DETALLE_CONTRATO d on d.PROCEDIMIENTO_ID = prc.PROCEDIMIENTO_ID and d.DIA_ID = prc.DIA_ID
    join DIM_PROCEDIMIENTO_TIPO_PROCEDIMIENTO_DETALLE tp on tp.TIPO_PROCEDIMIENTO_DETALLE_ID = prc.TIPO_PROCEDIMIENTO_DETALLE_ID 
    where prc.DIA_ID = fecha and ESTADO_PROCEDIMIENTO_ID = 0;

    truncate table TEMP_CONTRATO_PROCEDIMIENTO;
    insert into TEMP_CONTRATO_PROCEDIMIENTO (CONTRATO_ID) select distinct CONTRATO_ID from TEMP_CONTRATO_PROCEDIMIENTO_AUX;

    -- Contrato con procedimiento de tipo Litigio: 1	P. Monitorio, 2	ETNJ, 3	P. Hipotecario 4	P. Declarativo, 7	Resto
    update TEMP_CONTRATO_PROCEDIMIENTO cp, TEMP_CONTRATO_PROCEDIMIENTO_AUX cpaux set cp.LITIGIO = 1 where cpaux.TIPO_PROCEDIMIENTO_AGRUPADO_ID in (1,2,3,4,7) and cp.CONTRATO_ID = cpaux.CONTRATO_ID;
    -- Contrato con procedimiento de tipo Concurso: 5	Concurso
    update TEMP_CONTRATO_PROCEDIMIENTO cp, TEMP_CONTRATO_PROCEDIMIENTO_AUX cpaux set cp.CONCURSO = 1 where cpaux.TIPO_PROCEDIMIENTO_AGRUPADO_ID in (5) and cp.CONTRATO_ID = cpaux.CONTRATO_ID;

    -- TIPO_GESTION_CONTRATO_ID: 0	No Judicial, 1	Litigio, 2	Concurso, 3	Conjunta Litigio/Concurso
    update H_CONTRATO hc, TEMP_CONTRATO_PROCEDIMIENTO tcp set TIPO_GESTION_CONTRATO_ID = 3 where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcp.CONTRATO_ID and tcp.LITIGIO = 1 and tcp.CONCURSO = 1;
    update H_CONTRATO hc, TEMP_CONTRATO_PROCEDIMIENTO tcp set TIPO_GESTION_CONTRATO_ID = 2 where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcp.CONTRATO_ID and TIPO_GESTION_CONTRATO_ID is null and tcp.CONCURSO = 1;
    update H_CONTRATO hc, TEMP_CONTRATO_PROCEDIMIENTO tcp set TIPO_GESTION_CONTRATO_ID = 1 where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcp.CONTRATO_ID and TIPO_GESTION_CONTRATO_ID is null and tcp.LITIGIO = 1;
    update H_CONTRATO set TIPO_GESTION_CONTRATO_ID = 0 where DIA_ID = fecha and TIPO_GESTION_CONTRATO_ID is null;
*/
                                                              
   end loop;
   close c_fecha;  

-- ------------------------------------------------------ Fin bucle updates ------------------------------------------------------                                            


/*
-- ------------------------------------------------------ GESTIÓN RECOBRO ------------------------------------------------------                                            
-- Modelo Recobro
truncate table TEMP_CONTRATO_RECOBRO;
insert into TEMP_CONTRATO_RECOBRO (CONTRATO_ID, MODELO_RECOBRO_ID)
select CNT_ID, DD_MOR_ID from recovery_lindorff_datastage.PVR_LOAD_STATIC_DATA_CONTRATOS cnt
join recovery_lindorff_datastage.PVR_LOAD_STATIC_DATA_CLIENTES cli on cnt.PER_ID = cli.PER_ID;

set l_last_row = 0; 
open c_fecha_en_recobro;
read_loop: loop
fetch c_fecha_en_recobro into fecha_recobro;        
    if (l_last_row=1) then leave read_loop; 
    end if;
    
    update H_CONTRATO hc, recovery_lindorff_datastage.PVR_OPE_PROV_REC_OPERACION pvr set hc.EN_GESTION_RECOBRO_ID = 1 where hc.DIA_ID = fecha_recobro and hc.CONTRATO_ID = pvr.PVR_OPE_CNT_ID and date(pvr.PVR_OPE_FECHA_ALTA) <= hc.DIA_ID;
    update H_CONTRATO hc, recovery_lindorff_datastage.PVR_OPE_PROV_REC_OPERACION pvr set hc.FECHA_ALTA_GESTION_RECOBRO = date(pvr.PVR_OPE_FECHA_ALTA) where hc.DIA_ID = fecha_recobro and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = pvr.PVR_OPE_CNT_ID;
    update H_CONTRATO hc, recovery_lindorff_datastage.PVR_OPE_PROV_REC_OPERACION pvr set hc.FECHA_BAJA_GESTION_RECOBRO = date(pvr.PVR_OPE_FECHA_BAJA) where hc.DIA_ID = fecha_recobro and hc.EN_GESTION_RECOBRO_ID = 1 and PVR_OPE_FECHA_BAJA <= hc.DIA_ID and hc.CONTRATO_ID = pvr.PVR_OPE_CNT_ID;
    update H_CONTRATO hc, recovery_lindorff_datastage.PVR_OPE_PROV_REC_OPERACION pvr set hc.PROVEEDOR_RECOBRO_CONTRATO_ID = DD_PRE_ID where hc.DIA_ID = fecha_recobro and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = pvr.PVR_OPE_CNT_ID;
    -- Modelo Recobro
    update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tmp set hc.MODELO_RECOBRO_CONTRATO_ID = tmp.MODELO_RECOBRO_ID where hc.DIA_ID = fecha_recobro and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = tmp.CONTRATO_ID ;

end loop;
close c_fecha_en_recobro; 


-- Métricas DPS de cada día
update H_CONTRATO hc, recovery_lindorff_datastage.CNT_DPS_CONTRATOS dps set hc.NUM_DPS = 1 where hc.DIA_ID = date(dps.FECHA_REGULARIZACION) and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = dps.ID_CONTRATO;
update H_CONTRATO hc, recovery_lindorff_datastage.CNT_DPS_CONTRATOS dps set hc.DPS = dps.DPS_FINAL where hc.DIA_ID = date(dps.FECHA_REGULARIZACION) and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = dps.ID_CONTRATO;
update H_CONTRATO hc, recovery_lindorff_datastage.CNT_DPS_CONTRATOS dps set hc.DPS_CAPITAL = dps.DPS_CAPITAL where hc.DIA_ID = date(dps.FECHA_REGULARIZACION) and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = dps.ID_CONTRATO;
update H_CONTRATO hc, recovery_lindorff_datastage.CNT_DPS_CONTRATOS dps set hc.DPS_ICG = dps.DPS_ICG where hc.DIA_ID = date(dps.FECHA_REGULARIZACION) and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = dps.ID_CONTRATO;
update H_CONTRATO hc, recovery_lindorff_datastage.CNT_DPS_CONTRATOS dps set hc.SALDO_MAXIMO_GESTION = dps.DPS_MAXIMO where hc.DIA_ID = date(dps.FECHA_REGULARIZACION) and hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = dps.ID_CONTRATO;

-- Métricas Actuaciones de cada día
truncate table TEMP_CONTRATO_ACTIVIDAD;
insert into TEMP_CONTRATO_ACTIVIDAD (CONTRATO_ID, FECHA_ACTUACION, RESULTADO_ACTUACION_CONTRATO_ID)
select PVR_OPE_CNT_ID, date(ACE_FECHA_GESTION), coalesce(DD_RGT_ID, -1) from recovery_lindorff_datastage.PVR_OPE_PROV_REC_OPERACION ope
join recovery_lindorff_datastage.ACE_ACCIONES_EXTRAJUDICIALES ace on ope.PVR_OPE_ID_OPERACION = ace.PVR_OPE_ID_OPERACION where BORRADO=0;

update H_CONTRATO hc set NUM_ACTUACIONES_RECOBRO = (select count(*) from TEMP_CONTRATO_ACTIVIDAD tca where hc.EN_GESTION_RECOBRO_ID = 1 and hc.DIA_ID = tca.FECHA_ACTUACION and hc.CONTRATO_ID = tca.CONTRATO_ID);
update H_CONTRATO hc set NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL = (select count(*) from TEMP_CONTRATO_ACTIVIDAD tca where hc.EN_GESTION_RECOBRO_ID = 1 and hc.DIA_ID = tca.FECHA_ACTUACION and hc.CONTRATO_ID = tca.CONTRATO_ID  
                                                                                                                             and RESULTADO_ACTUACION_CONTRATO_ID in(21,9,8,1));
                                                                                                                             

    
-- Fecha cobro                                                         
update H_CONTRATO hc, recovery_lindorff_datastage.CNT_DPS_CONTRATOS dps set hc.FECHA_DPS = date(dps.FECHA_REGULARIZACION) where hc.EN_GESTION_RECOBRO_ID = 1 and hc.CONTRATO_ID = dps.ID_CONTRATO and hc.DIA_ID = date(dps.FECHA_REGULARIZACION);

-- NUM_DIAS_EN_GESTION_A_COBRO / TRAMO_DIAS_EN_GESTION_A_COBRO_ID
update H_CONTRATO set NUM_DIAS_EN_GESTION_A_COBRO = (datediff(FECHA_DPS, FECHA_ALTA_GESTION_RECOBRO)) where DIA_ID between date_start and date_end and EN_GESTION_RECOBRO_ID = 1;
update H_CONTRATO set TRAMO_DIAS_EN_GESTION_A_COBRO_ID = (case when NUM_DIAS_EN_GESTION_A_COBRO <= 5 then 0
                                                               when NUM_DIAS_EN_GESTION_A_COBRO > 5 and NUM_DIAS_EN_GESTION_A_COBRO <= 10 then 1
                                                               when NUM_DIAS_EN_GESTION_A_COBRO > 10 and NUM_DIAS_EN_GESTION_A_COBRO <= 15 then 2
                                                               when NUM_DIAS_EN_GESTION_A_COBRO > 15 and NUM_DIAS_EN_GESTION_A_COBRO <= 20 then 3
                                                               when NUM_DIAS_EN_GESTION_A_COBRO > 20 and NUM_DIAS_EN_GESTION_A_COBRO <= 25 then 4
                                                               when NUM_DIAS_EN_GESTION_A_COBRO > 25 then 5
                                                               else -3 end) where DIA_ID between date_start and date_end and EN_GESTION_RECOBRO_ID = 1;
update H_CONTRATO set TRAMO_DIAS_EN_GESTION_A_COBRO_ID = -2 where  DIA_ID between date_start and date_end and EN_GESTION_RECOBRO_ID = 0;

-- NUM_DIAS_IRREGULAR_A_COBRO / TRAMO_DIAS_IRREGULAR_A_COBRO_ID
update H_CONTRATO set NUM_DIAS_IRREGULAR_A_COBRO = (datediff(FECHA_DPS, DIA_POS_VENCIDA_ID)) where  DIA_ID between date_start and date_end and EN_GESTION_RECOBRO_ID = 1;
update H_CONTRATO set TRAMO_DIAS_IRREGULAR_A_COBRO_ID = (case when NUM_DIAS_IRREGULAR_A_COBRO <= 30 then 0
                                                              when NUM_DIAS_IRREGULAR_A_COBRO > 30 and NUM_DIAS_IRREGULAR_A_COBRO <= 60 then 1
                                                              when NUM_DIAS_IRREGULAR_A_COBRO > 60 and NUM_DIAS_IRREGULAR_A_COBRO <= 90 then 2
                                                              when NUM_DIAS_IRREGULAR_A_COBRO > 90 and timestampdiff(YEAR, DIA_POS_VENCIDA_ID, FECHA_DPS) <= 0 then 3
                                                              when timestampdiff(YEAR, DIA_POS_VENCIDA_ID, FECHA_DPS) > 0 and timestampdiff(YEAR, DIA_POS_VENCIDA_ID, FECHA_DPS) <= 2 then 4
                                                              when timestampdiff(YEAR, DIA_POS_VENCIDA_ID, FECHA_DPS) > 2 then 5
                                                              when EN_GESTION_RECOBRO_ID = 1 and NUM_DIAS_VENCIDOS <= 0 then -1
                                                              else -3 end) where DIA_ID between date_start and date_end and EN_GESTION_RECOBRO_ID = 1;  
update H_CONTRATO set TRAMO_DIAS_IRREGULAR_A_COBRO_ID = -2 where DIA_ID between date_start and date_end and  EN_GESTION_RECOBRO_ID = 0;

-- Métricas Acumuladas a nivel mes
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;

-- Acumulados Mes DPS asociados al contrato
truncate table TEMP_CONTRATO_DPS;
set primer_dia_mes = ADDDATE(LAST_DAY(SUBDATE(fecha, INTERVAL 1 MONTH)), 1);
insert into TEMP_CONTRATO_DPS (ID_CONTRATO, DPS_FINAL, DPS_CAPITAL, DPS_ICG) 
select ID_CONTRATO, DPS_FINAL, DPS_CAPITAL, DPS_ICG from recovery_lindorff_datastage.CNT_DPS_CONTRATOS 
where DATE(FECHA_REGULARIZACION) >= primer_dia_mes and DATE(FECHA_REGULARIZACION) <= fecha;

truncate table TEMP_CONTRATO_RECOBRO;
insert into TEMP_CONTRATO_RECOBRO (CONTRATO_ID) select distinct ID_CONTRATO from recovery_lindorff_datastage.CNT_DPS_CONTRATOS;

update TEMP_CONTRATO_RECOBRO tcr set NUM_DPS_ACUMULADO = (select count(*) from TEMP_CONTRATO_DPS dps where tcr.CONTRATO_ID = dps.ID_CONTRATO);
update TEMP_CONTRATO_RECOBRO tcr set DPS_ACUMULADO = (select sum(DPS_FINAL) from TEMP_CONTRATO_DPS dps where tcr.CONTRATO_ID = dps.ID_CONTRATO);
update TEMP_CONTRATO_RECOBRO tcr set DPS_CAPITAL_ACUMULADO = (select sum(DPS_CAPITAL) from TEMP_CONTRATO_DPS dps where tcr.CONTRATO_ID = dps.ID_CONTRATO);
update TEMP_CONTRATO_RECOBRO tcr set DPS_ICG_ACUMULADO = (select sum(DPS_ICG) from TEMP_CONTRATO_DPS dps where tcr.CONTRATO_ID = dps.ID_CONTRATO);
update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.NUM_DPS_ACUMULADO = tcr.NUM_DPS_ACUMULADO where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;
update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.DPS_ACUMULADO = tcr.DPS_ACUMULADO where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;
update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.DPS_CAPITAL_ACUMULADO = tcr.DPS_CAPITAL_ACUMULADO where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;
update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.DPS_ICG_ACUMULADO = tcr.DPS_ICG_ACUMULADO where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;
 
-- Acumulados Mes Actuaciones asociadas al contrato 
truncate table TEMP_CONTRATO_RECOBRO;
insert into TEMP_CONTRATO_RECOBRO (CONTRATO_ID) select distinct CNT_ID from recovery_lindorff_datastage.PVR_LOAD_STATIC_DATA_CONTRATOS; 

truncate table TEMP_CONTRATO_ACTIVIDAD;
insert into TEMP_CONTRATO_ACTIVIDAD (CONTRATO_ID, FECHA_COMPROMETIDA_PAGO, RESULTADO_ACTUACION_CONTRATO_ID)
select PVR_OPE_CNT_ID, date(ACE_FECHA_PAGO_COMPROMETIDO), DD_RGT_ID FROM recovery_lindorff_datastage.PVR_OPE_PROV_REC_OPERACION ope
join recovery_lindorff_datastage.ACE_ACCIONES_EXTRAJUDICIALES ace on ope.PVR_OPE_ID_OPERACION = ace.PVR_OPE_ID_OPERACION
where DATE(ACE_FECHA_GESTION) >= primer_dia_mes and DATE(ACE_FECHA_GESTION) <= fecha;

-- Asignación de prioridades: 1 NO CORRESPONDE CON EL DEUDOR - 10 PROMESA PAGO TOTAL
update TEMP_CONTRATO_ACTIVIDAD set PRIORIDAD_ACTUACION = (case when RESULTADO_ACTUACION_CONTRATO_ID = 7 then 1
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 6 then 2
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 3 then 3  
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 2 then 4  
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 4 then 5  
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 5 then 6  
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 1 then 7
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 21 then 8  
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 8 then 9  
                                                               when RESULTADO_ACTUACION_CONTRATO_ID = 9 then 10 
                                                               else -1 end); 

update TEMP_CONTRATO_RECOBRO tcr set FECHA_COMPROMETIDA_PAGO = (select max(FECHA_COMPROMETIDA_PAGO) from TEMP_CONTRATO_ACTIVIDAD tca where tcr.CONTRATO_ID = tca.CONTRATO_ID);
update TEMP_CONTRATO_RECOBRO tcr set MAX_PRIORIDAD_ACTUACION = (select max(PRIORIDAD_ACTUACION) from TEMP_CONTRATO_ACTIVIDAD tca where tcr.CONTRATO_ID = tca.CONTRATO_ID);
update TEMP_CONTRATO_RECOBRO tcr set RESULTADO_ACTUACION_CONTRATO_ID = (select RESULTADO_ACTUACION_CONTRATO_ID from TEMP_CONTRATO_ACTIVIDAD tca where tcr.CONTRATO_ID = tca.CONTRATO_ID and PRIORIDAD_ACTUACION = MAX_PRIORIDAD_ACTUACION group by RESULTADO_ACTUACION_CONTRATO_ID);
update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.FECHA_COMPROMETIDA_PAGO = tcr.FECHA_COMPROMETIDA_PAGO where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;
update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.RESULTADO_ACTUACION_CONTRATO_ID = tcr.RESULTADO_ACTUACION_CONTRATO_ID where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;


update TEMP_CONTRATO_RECOBRO tcr set NUM_ACTUACIONES_RECOBRO_ACUMULADO = (select count(*) from TEMP_CONTRATO_ACTIVIDAD tca where tcr.CONTRATO_ID = tca.CONTRATO_ID);
update TEMP_CONTRATO_RECOBRO tcr set NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO = (select count(*) from TEMP_CONTRATO_ACTIVIDAD tca where tcr.CONTRATO_ID = tca.CONTRATO_ID and tca.RESULTADO_ACTUACION_CONTRATO_ID in(21,9,8,1));

update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.NUM_ACTUACIONES_RECOBRO_ACUMULADO = tcr.NUM_ACTUACIONES_RECOBRO_ACUMULADO where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;
update H_CONTRATO hc, TEMP_CONTRATO_RECOBRO tcr set hc.NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO = tcr.NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO where hc.DIA_ID = fecha and hc.CONTRATO_ID = tcr.CONTRATO_ID;

end loop;
close c_fecha;   

update H_CONTRATO set CONTRATO_CON_DPS_ID = (case when NUM_DPS_ACUMULADO > 0 then 1
                                                   else 0 end) where DIA_ID between date_start and date_end;  
                                                   
update H_CONTRATO set CONTRATO_CON_ACTUACION_RECOBRO_ID = (case when NUM_ACTUACIONES_RECOBRO_ACUMULADO > 0 then 1
                                                                 else 0 end) where DIA_ID between date_start and date_end; 
                                                                 
 update H_CONTRATO set CONTRATO_CON_CONTACTO_UTIL_ID = (case when NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO > 0 then 1
                                                             else 0 end) where DIA_ID between date_start and date_end;
 
 
set fecha_inicio_campana_recobro = (select min(date(PVR_OPE_FECHA_ALTA)) from recovery_lindorff_datastage.PVR_OPE_PROV_REC_OPERACION);

truncate table H_CONTRATO_INICIO_CAMPANA_RECOBRO;
insert into H_CONTRATO_INICIO_CAMPANA_RECOBRO
        (FECHA_INICIO_CAMPANA_RECOBRO,
        CONTRATO_ID,
        ESTADO_FINANCIERO_CONTRATO_INICIO_CAMPANA_RECOBRO_ID,
        ESTADO_FINANCIERO_ANTERIOR_INICIO_CAMPANA_RECOBRO_ID,
        EN_GESTION_RECOBRO_INICIO_CAMPANA_RECOBRO_ID,
        TRAMO_IRREGULARIDAD_DIAS_INICIO_CAMPANA_RECOBRO_ID,
        TRAMO_IRREGULARIDAD_FASES_INICIO_CAMPANA_RECOBRO_ID,
        MODELO_RECOBRO_CONTRATO_INICIO_CAMPANA_RECOBRO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_INICIO_CAMPANA_RECOBRO_ID,
        CONTRATO_EN_IRREGULAR_INICIO_CAMPANA_RECOBRO_ID,
        NUM_CONTRATOS_INICIO_CAMPANA_RECOBRO,
        NUM_DIAS_VENCIDOS_INICIO_CAMPANA_RECOBRO,
        SALDO_TOTAL_INICIO_CAMPANA_RECOBRO,
        POSICION_VIVA_NO_VENCIDA_INICIO_CAMPANA_RECOBRO,
        POSICION_VIVA_VENCIDA_INICIO_CAMPANA_RECOBRO,
        SALDO_DUDOSO_INICIO_CAMPANA_RECOBRO,
        PROVISION_INICIO_CAMPANA_RECOBRO,
        INTERESES_REMUNERATORIOS_INICIO_CAMPANA_RECOBRO,
        INTERESES_MORATORIOS_INICIO_CAMPANA_RECOBRO,
        COMISIONES_INICIO_CAMPANA_RECOBRO,
        GASTOS_INICIO_CAMPANA_RECOBRO,
        RIESGO_INICIO_CAMPANA_RECOBRO,
        DEUDA_IRREGULAR_INICIO_CAMPANA_RECOBRO,
        DISPUESTO_INICIO_CAMPANA_RECOBRO,
        SALDO_PASIVO_INICIO_CAMPANA_RECOBRO,
        RIESGO_GARANTIA_INICIO_CAMPANA_RECOBRO,
        SALDO_EXCE_INICIO_CAMPANA_RECOBRO,
        IMPORTE_A_RECLAMAR_INICIO_CAMPANA_RECOBRO
        )
select fecha_inicio_campana_recobro,
        CONTRATO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        EN_GESTION_RECOBRO_ID,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        NUM_CONTRATOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        IMPORTE_A_RECLAMAR
FROM H_CONTRATO where DIA_ID=fecha_inicio_campana_recobro and EN_GESTION_RECOBRO_ID = 1 and SITUACION_RESPECTO_PERIODO_ANT_ID <>2;

-- -----------------------------------------------------  FIN GESTIÓN RECOBRO   -------------------------------------------------------------------------


-- ------------------------------------------------------ GESTIÓN ESPECIALIZADA ------------------------------------------------------                                            
-- Contratos en asuntos de Especializada y SAREB Especializada
truncate table TEMP_CONTRATO_ESPECIALIZADA;

insert into TEMP_CONTRATO_ESPECIALIZADA 
    (CONTRATO_ID, 
     SITUACION_ESPECIALIZADA_ID, 
     GESTOR_ESPECIALIZADA_ID,
     SUPERVISOR_N1_ESPECIALIZADA_ID,
     SUPERVISOR_N2_ESPECIALIZADA_ID)
select CNT_ID, 
    (case TIPO_PROCEDIMIENTO when 'ERROR 1' then 0
                             when 'LITIGIO' then 1
                             when 'CONCURSO' then 2
                             when 'A' then 3
                             when 'POSIBLE A' then 4
                             when 'V' then 5
                             when 'FALLIDO' then 6
                             else -1 end),
    coalesce(GESTOR_ESP_USD_ID, -1),
    coalesce(SUPERVISOR_N1_ESP_USD_ID, -1),
    coalesce(SUPERVISOR_N2_ESP_USD_ID, -1)
from recovery_lindorff_datastage.CARTERIZACION_ESPECIALIZADA; 


update TEMP_CONTRATO_ESPECIALIZADA tmp, recovery_lindorff_datastage.CARTERIZACION_ESPECIALIZADA ce set tmp.SUPERVISOR_N3_ESPECIALIZADA_ID = SUPERVISOR_N3_1_ESP_USD_ID
where tmp.CONTRATO_ID = ce.CNT_ID and tmp.SUPERVISOR_N3_ESPECIALIZADA_ID is null;

update TEMP_CONTRATO_ESPECIALIZADA tmp, recovery_lindorff_datastage.CARTERIZACION_ESPECIALIZADA ce set tmp.SUPERVISOR_N3_ESPECIALIZADA_ID = SUPERVISOR_N3_2_ESP_USD_ID
where tmp.CONTRATO_ID = ce.CNT_ID and tmp.SUPERVISOR_N3_ESPECIALIZADA_ID is null;

update TEMP_CONTRATO_ESPECIALIZADA tmp, recovery_lindorff_datastage.CARTERIZACION_ESPECIALIZADA ce set tmp.SUPERVISOR_N3_ESPECIALIZADA_ID = SUPERVISOR_N3_3_ESP_USD_ID
where tmp.CONTRATO_ID = ce.CNT_ID and tmp.SUPERVISOR_N3_ESPECIALIZADA_ID is null;

update TEMP_CONTRATO_ESPECIALIZADA tmp, recovery_lindorff_datastage.CARTERIZACION_ESPECIALIZADA ce set tmp.SUPERVISOR_N3_ESPECIALIZADA_ID = SUPERVISOR_N3_4_ESP_USD_ID
where tmp.CONTRATO_ID = ce.CNT_ID and tmp.SUPERVISOR_N3_ESPECIALIZADA_ID is null;


-- Previsiones
    truncate table TEMP_CONTRATO_PREVISIONES;
    insert into TEMP_CONTRATO_PREVISIONES
        (FECHA_PREVISION,
        CONTRATO_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
        )
    select date(PRE_FECHA_PREVISION),
        CNT_ID,
        PRE_REVISADO,
        (case DD_TIPO_PREVISION when 'Auto' then 0
                                when 'Manual' then 1
                                else -1 end),        
        PRE_SITUACION_INI,
        PRE_SITUACION_PREV_A,
        PRE_SITUACION_PREV_M,
        PRE_SITUACION_PREV_F,
        MPR_ID,
        PRE_IMPORTE_IRREGULAR_INI,
        PRE_IMPORTE_IRREGULAR_PREV_A,
        PRE_IMPORTE_IRREGULAR_PREV_M,
        PRE_IMPORTE_IRREGULAR_PREV_F,
        PRE_RIESGO_INI,
        PRE_RIESGO_PREV_A,
        PRE_RIESGO_PREV_M,
        PRE_RIESGO_PREV_F
from recovery_lindorff_datastage.PRE_PREVISIONES where BORRADO = 0;   
-- Siguiente previsión del contrato (Intervalo de vigencia de la previsión)
update TEMP_CONTRATO_PREVISIONES tmp set FECHA_SIG_PREVISION = (select min(date(PRE_FECHA_PREVISION)) from recovery_lindorff_datastage.PRE_PREVISIONES pre
                                                                where tmp.CONTRATO_ID = pre.CNT_ID and date(pre.PRE_FECHA_PREVISION) > tmp.FECHA_PREVISION);
update TEMP_CONTRATO_PREVISIONES tmp set FECHA_SIG_PREVISION = '3000-01-01' where FECHA_SIG_PREVISION is null;


set l_last_row = 0; 
open c_fecha_especializada;
read_loop: loop
fetch c_fecha_especializada into fecha_especializada;        
    if (l_last_row=1) then leave read_loop; 
    end if;
    
    update H_CONTRATO hc, TEMP_CONTRATO_ESPECIALIZADA ce set hc.EN_GESTION_ESPECIALIZADA_ID = 1 where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = ce.CONTRATO_ID;
    
    update H_CONTRATO hc, TEMP_CONTRATO_ESPECIALIZADA ce set hc.SITUACION_ESPECIALIZADA_ID = ce.SITUACION_ESPECIALIZADA_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = ce.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_ESPECIALIZADA ce set hc.GESTOR_ESPECIALIZADA_ID = ce.GESTOR_ESPECIALIZADA_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = ce.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_ESPECIALIZADA ce set hc.SUPERVISOR_N1_ESPECIALIZADA_ID = ce.SUPERVISOR_N1_ESPECIALIZADA_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = ce.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_ESPECIALIZADA ce set hc.SUPERVISOR_N2_ESPECIALIZADA_ID = ce.SUPERVISOR_N2_ESPECIALIZADA_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = ce.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_ESPECIALIZADA ce set hc.SUPERVISOR_N3_ESPECIALIZADA_ID = ce.SUPERVISOR_N3_ESPECIALIZADA_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = ce.CONTRATO_ID;
  
    -- Revisiones vigentes
    truncate table TEMP_CONTRATO_PREVISIONES_DIA;
    insert into TEMP_CONTRATO_PREVISIONES_DIA
        (CONTRATO_ID,
        FECHA_PREVISION,
        FECHA_SIG_PREVISION,
        CONTRATO_CON_PREVISION_REVISADA_ID,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
        )
    select * from TEMP_CONTRATO_PREVISIONES where fecha_especializada >= FECHA_PREVISION and fecha_especializada < FECHA_SIG_PREVISION;
   
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.FECHA_PREVISION = cp.FECHA_PREVISION where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.CONTRATO_CON_PREVISION_REVISADA_ID = cp.CONTRATO_CON_PREVISION_REVISADA_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.TIPO_PREVISION_ID = cp.TIPO_PREVISION_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.PREVISION_SITUACION_INICIAL_ID = cp.PREVISION_SITUACION_INICIAL_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.PREVISION_SITUACION_AUTOMATICO_ID = cp.PREVISION_SITUACION_AUTOMATICO_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.PREVISION_SITUACION_MANUAL_ID = cp.PREVISION_SITUACION_MANUAL_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.PREVISION_SITUACION_FINAL_ID = cp.PREVISION_SITUACION_FINAL_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.MOTIVO_PREVISION_ID = cp.MOTIVO_PREVISION_ID where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_IRREGULAR_PREVISION_INICIO = cp.IMPORTE_IRREGULAR_PREVISION_INICIO where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_IRREGULAR_PREVISION_AUTOMATICO = cp.IMPORTE_IRREGULAR_PREVISION_AUTOMATICO where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_IRREGULAR_PREVISION_MANUAL = cp.IMPORTE_IRREGULAR_PREVISION_MANUAL where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_IRREGULAR_PREVISION_FINAL = cp.IMPORTE_IRREGULAR_PREVISION_FINAL where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_RIESGO_PREVISION_INICIO = cp.IMPORTE_RIESGO_PREVISION_INICIO where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_RIESGO_PREVISION_AUTOMATICO = cp.IMPORTE_RIESGO_PREVISION_AUTOMATICO where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_RIESGO_PREVISION_MANUAL = cp.IMPORTE_RIESGO_PREVISION_MANUAL where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;
    update H_CONTRATO hc, TEMP_CONTRATO_PREVISIONES cp set hc.IMPORTE_RIESGO_PREVISION_FINAL = cp.IMPORTE_RIESGO_PREVISION_FINAL where hc.DIA_ID = fecha_especializada and hc.CONTRATO_ID = cp.CONTRATO_ID;

    update H_CONTRATO set TIPO_PREVISION_ID = -1 where DIA_ID = fecha_especializada and TIPO_PREVISION_ID is null;
    update H_CONTRATO set PREVISION_SITUACION_INICIAL_ID = -1 where DIA_ID = fecha_especializada and PREVISION_SITUACION_INICIAL_ID is null;
    update H_CONTRATO set PREVISION_SITUACION_AUTOMATICO_ID = -1 where DIA_ID = fecha_especializada and PREVISION_SITUACION_AUTOMATICO_ID is null;
    update H_CONTRATO set PREVISION_SITUACION_MANUAL_ID = -1 where DIA_ID = fecha_especializada and PREVISION_SITUACION_MANUAL_ID is null;
    update H_CONTRATO set PREVISION_SITUACION_FINAL_ID = -1 where DIA_ID = fecha_especializada and PREVISION_SITUACION_FINAL_ID is null;
    update H_CONTRATO set MOTIVO_PREVISION_ID = -1 where DIA_ID = fecha_especializada and MOTIVO_PREVISION_ID is null;
    update H_CONTRATO set CONTRATO_CON_PREVISION_REVISADA_ID = -1 where DIA_ID = fecha_especializada and CONTRATO_CON_PREVISION_REVISADA_ID is null;


    update H_CONTRATO set CONTRATO_CON_PREVISION_ID = 1 where DIA_ID = fecha_especializada and IMPORTE_IRREGULAR_PREVISION_INICIO is not null;
    update H_CONTRATO set CONTRATO_CON_PREVISION_ID = 0 where DIA_ID = fecha_especializada and EN_GESTION_ESPECIALIZADA_ID = 1 and CONTRATO_CON_PREVISION_ID is null;

end loop;
close c_fecha_especializada; 

-- -----------------------------------------------------  FIN GESTIÓN ESPECIALIZADA   -------------------------------------------------------------------------
*/

/* Estudios puntuales de subcarteras UGAS
-- ------------------------------------------------------ ESTUDIO CARTERA ------------------------------------------------------                                            
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;
    
update H_CONTRATO h, TEMP_ESTUDIO_CARTERA tmp set h.EN_CARTERA_ESTUDIO_ID = 1 where h.CONTRATO_ID = tmp.CONTRATO_ID and DIA_ID = fecha;

-- 0	Masiva / 1	Especializada / 2	Resto
update H_CONTRATO h, TEMP_ESTUDIO_CARTERA tmp set h.MODELO_GESTION_CARTERA_ID = 0 where DIA_ID = fecha and h.CONTRATO_ID = tmp.CONTRATO_ID and tmp.EN_MASIVA = 1;
update H_CONTRATO set MODELO_GESTION_CARTERA_ID = 1 where DIA_ID = fecha and EN_GESTION_ESPECIALIZADA_ID = 1;
update H_CONTRATO set MODELO_GESTION_CARTERA_ID = 2 where DIA_ID = fecha and MODELO_GESTION_CARTERA_ID is null;

-- UNIDAD_GESTION_CARTERA_ID
end loop;
close c_fecha; 
-- ----------------------------------------------------- FIN ESTUDIO CARTERA  -------------------------------------------------------------------------
*/


update TEMP_BAJA baj, TEMP_FECHA fech set baj.DIA_MOV = fech.DIA_H where baj.DIA_H = fech.DIA_ANT;

-- BAJAS DIA
 insert into H_CONTRATO
        (DIA_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        FECHA_PREVISION,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
   )
  select DIA_H, 
        DIA_H,
        h.CONTRATO_ID,
        -2,                                         -- SITUACION_CONTRATO_DETALLE_ID = Normalizado (Baja)
        SITUACION_CONTRATO_DETALLE_ANT,             -- 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
        2,                                          -- SITUACION_RESPECTO_PERIODO_ANT_ID = Baja
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,     
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        FECHA_PREVISION,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
  from H_CONTRATO h, TEMP_BAJA baj where h.DIA_ID = baj.DIA_MOV and h.CONTRATO_ID = baj.CONTRATO_ID;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_CONTRATO_MES
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------- TABLAS TEMPORALES ----------------------------------------
-- Calculamos las Fechas H (tabla hechos) y ANT (Periodo anterior)
truncate table TEMP_FECHA;
truncate table TEMP_FECHA_AUX;

insert into TEMP_FECHA_AUX (MES_AUX) select DISTINCT MES_ID from DIM_FECHA_DIA where DIA_ID between date_start and date_end;
-- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
insert into TEMP_FECHA_AUX (MES_AUX) select (select max(MES_ID) from H_CONTRATO_MES where MES_ID < (select min(MES_AUX) from TEMP_FECHA_AUX));

insert into TEMP_FECHA (DIA_H) select distinct(DIA_ID) from H_CONTRATO;
update TEMP_FECHA tf, DIM_FECHA_DIA d set tf.MES_H = d.MES_ID  where tf.DIA_H = d.DIA_ID;
delete from TEMP_FECHA where MES_H not in (select distinct MES_AUX from TEMP_FECHA_AUX);
update TEMP_FECHA set MES_ANT = (select MIN(MES_AUX) from TEMP_FECHA_AUX where MES_AUX > MES_H);

-- Truncamos el resto de tablas temporales
truncate table TEMP_H;
truncate table TEMP_ANT;
truncate table TEMP_MANTIENE;
truncate table TEMP_ALTA;
truncate table TEMP_BAJA;

set max_mes_periodo_ant = (select min(MES_H) from TEMP_FECHA);
set max_dia_periodo_ant = (select max(DIA_H) from TEMP_FECHA where MES_H = max_mes_periodo_ant);

-- Incluimos en TEMP_H y TEMP_ANT el max_dia_periodo_ant para poder comparar con date_start
-- TEMP_H - Contratos de cada periodo    
insert into TEMP_H (DIA_H, MES_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
select DIA_ID, max_mes_periodo_ant, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
where DIA_ID = max_dia_periodo_ant and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;

-- TEMP_ANT - Contratos del periodo anterior (no tiene que haber contratos todos los días necesariamente). 
insert into TEMP_ANT (DIA_ANT, MES_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
select DIA_H, MES_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
where DIA_H = max_dia_periodo_ant;


-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    
    -- Borrado de los meses a insertar
    delete from H_CONTRATO_MES where MES_ID = mes;
    
    insert into H_CONTRATO_MES
        (MES_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
        )
    select mes,
        max_dia_mes,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
    from H_CONTRATO where DIA_ID = max_dia_mes and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;

-- TEMP_H - Contratos de cada periodo    
insert into TEMP_H (DIA_H, MES_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
select DIA_ID, mes, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
where DIA_ID = max_dia_mes and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;

-- TEMP_ANT - Contratos del periodo anterior (no tiene que haber contratos todos los días necesariamente). 
insert into TEMP_ANT (DIA_ANT, MES_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
select DIA_H, MES_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
where DIA_H = max_dia_mes;

end loop c_meses_loop;
close c_meses;
    
-- Actualizamos las fechas para poder comparar con TEMP_H en el mismo día. Ej. El mes 6 TEMP_H tiene los contratos del mes 6 y TEMP_ANT los del 5.
update TEMP_ANT ant, TEMP_FECHA fech set ant.MES_ANT = fech.MES_ANT where ant.DIA_ANT = fech.DIA_H;

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- TEMP_MANTIENE - Contratos que están en TEMP_H y en TEMP_ANT  
    insert into TEMP_MANTIENE (MES_ID, CONTRATO_ID) 
    select MES_H, CONTRATO_H from TEMP_H join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and MES_H = MES_ANT
    where MES_H = mes;

    -- TEMP_ALTA - Contratos que están en TEMP_H pero no en H_TEMP_ANT
    insert into TEMP_ALTA (MES_ID, CONTRATO_ID) 
    select MES_H, CONTRATO_H from TEMP_H left join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and MES_H = MES_ANT
    where MES_H = mes and CONTRATO_ANT is null;
    
    -- TEMP_BAJA - Contratos que están en TEMP_ANT pero no en TEMP_H. Incluye DIA_MOV para encontrar los contratos en H_CONTRATO
    insert into TEMP_BAJA (MES_H, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)  
    select MES_ANT, CONTRATO_ANT, ant.SITUACION_CONTRATO_DETALLE_ANT, ant.NUM_DIAS_VENCIDOS_PERIODO_ANT, ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT from TEMP_ANT ant left join TEMP_H on CONTRATO_H = CONTRATO_ANT and MES_H = MES_ANT 
    where MES_ANT = mes and CONTRATO_H is null and MES_ANT is not null;


    -- SITUACION_RESPECTO_PERIODO_ANT_ID - 0 Mantiene, 1 Alta, 2 Baja
    update H_CONTRATO_MES h, TEMP_MANTIENE man set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 0 where h.MES_ID = mes and h.MES_ID = man.MES_ID and h.CONTRATO_ID = man.CONTRATO_ID;
    update H_CONTRATO_MES h, TEMP_ALTA alt set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 1 where h.MES_ID = mes and h.MES_ID = alt.MES_ID and h.CONTRATO_ID = alt.CONTRATO_ID;
    
--     UNNIM
--     -- SITUACION_ANTERIOR_CONTRATO_DETALLE_ID - 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
--     -- Si alta no tiene situación anterior.
--     update H_CONTRATO_MES h set SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = -2 where h.MES_ID = mes and SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)
--     -- El resto adquiere el del periodo anterior                                  
--     update H_CONTRATO_MES h, TEMP_ANT ant set h.SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = ant.SITUACION_CONTRATO_DETALLE_ANT where h.MES_ID = mes and h.MES_ID = ant.MES_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and SITUACION_ANTERIOR_CONTRATO_DETALLE_ID is null;
    
    
    -- NUM_DIAS_VENCIDOS_PERIODO_ANT                           
    update H_CONTRATO_MES h, TEMP_ANT ant set h.NUM_DIAS_VENCIDOS_PERIODO_ANT = ant.NUM_DIAS_VENCIDOS_PERIODO_ANT where h.MES_ID = mes and h.MES_ID = ant.MES_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT;

    -- TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT 
    -- Si alta no tiene situación anterior.
    update H_CONTRATO_MES h set TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = -2 where h.MES_ID = mes and SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)
    -- El resto adquiere el del periodo anterior                              
    update H_CONTRATO_MES h, TEMP_ANT ant set h.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where h.MES_ID = mes and h.MES_ID = ant.MES_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID is null;

end loop c_meses_loop;
close c_meses;


update TEMP_BAJA baj, TEMP_FECHA fech set baj.MES_MOV = fech.MES_H where baj.MES_H = fech.MES_ANT;


-- BAJAS MES 
    insert into H_CONTRATO_MES
        (MES_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
   )
  select MES_H, 
        FECHA_CARGA_DATOS,
        h.CONTRATO_ID,
        -2,                                         -- SITUACION_CONTRATO_DETALLE_ID = Normalizado (Baja)
        SITUACION_CONTRATO_DETALLE_ANT,             -- 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
        2,                                          -- SITUACION_RESPECTO_PERIODO_ANT_ID = Baja
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
  from H_CONTRATO_MES h, TEMP_BAJA baj where h.MES_ID = baj.MES_mov and h.CONTRATO_ID = baj.CONTRATO_ID;


update H_CONTRATO_MES set TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = (case when NUM_DIAS_VENCIDOS_PERIODO_ANT <= 0 then 0
                                                                          when NUM_DIAS_VENCIDOS_PERIODO_ANT > 0 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 30 then 1
                                                                          when NUM_DIAS_VENCIDOS_PERIODO_ANT > 30 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 60 then 2
                                                                          when NUM_DIAS_VENCIDOS_PERIODO_ANT > 60 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 90 then 3
                                                                          when NUM_DIAS_VENCIDOS_PERIODO_ANT > 90 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 120 then 4
                                                                          when NUM_DIAS_VENCIDOS_PERIODO_ANT > 120 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 365 then 5
                                                                          when NUM_DIAS_VENCIDOS_PERIODO_ANT > 365 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 1095 then 6
                                                                          when NUM_DIAS_VENCIDOS_PERIODO_ANT > 1095 then 7
                                                                          else -1 end); 
 
 
-- ----------------------------------------------------------------------------------------------
--                                      H_CONTRATO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------- TABLAS TEMPORALES ----------------------------------------
-- Calculamos las Fechas H (tabla hechos) y ANT (Periodo anterior)
truncate table TEMP_FECHA;
truncate table TEMP_FECHA_AUX;

insert into TEMP_FECHA_AUX (TRIMESTRE_AUX) select DISTINCT TRIMESTRE_ID from DIM_FECHA_DIA where DIA_ID between date_start and date_end;
-- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
insert into TEMP_FECHA_AUX (TRIMESTRE_AUX) select (select max(TRIMESTRE_ID) from H_CONTRATO_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TEMP_FECHA_AUX));

insert into TEMP_FECHA (DIA_H) select distinct(DIA_ID) from H_CONTRATO;
update TEMP_FECHA tf, DIM_FECHA_DIA d set tf.TRIMESTRE_H = d.TRIMESTRE_ID  where tf.DIA_H = d.DIA_ID;
delete from TEMP_FECHA where TRIMESTRE_H not in (select distinct TRIMESTRE_AUX from TEMP_FECHA_AUX);
update TEMP_FECHA set TRIMESTRE_ANT = (select MIN(TRIMESTRE_AUX) from TEMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);

-- Truncamos el resto de tablas temporales
truncate table TEMP_H;
truncate table TEMP_ANT;
truncate table TEMP_MANTIENE;
truncate table TEMP_ALTA;
truncate table TEMP_BAJA;

set max_trimestre_periodo_ant = (select min(TRIMESTRE_H) from TEMP_FECHA);
set max_dia_periodo_ant = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = max_trimestre_periodo_ant);

-- Incluimos en TEMP_H y TEMP_ANT el max_dia_periodo_ant para poder comparar con date_start
-- TEMP_H - Contratos de cada periodo    
insert into TEMP_H (DIA_H, TRIMESTRE_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
select DIA_ID, max_trimestre_periodo_ant, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
where DIA_ID = max_dia_periodo_ant and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;

-- TEMP_ANT - Contratos del periodo anterior (no tiene que haber contratos todos los días necesariamente). 
insert into TEMP_ANT (DIA_ANT, TRIMESTRE_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
select DIA_H, TRIMESTRE_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
where DIA_H = max_dia_periodo_ant;


-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    
    -- Borrado de los trimestres a insertar
    delete from H_CONTRATO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    
    insert into H_CONTRATO_TRIMESTRE
        (TRIMESTRE_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
        )
    select trimestre, 
        max_dia_trimestre,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
    from H_CONTRATO where DIA_ID = max_dia_trimestre and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;

    -- TEMP_H - Contratos de cada periodo    
    insert into TEMP_H (DIA_H, TRIMESTRE_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
    select DIA_ID, trimestre, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
    where DIA_ID = max_dia_trimestre and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;

    -- TEMP_ANT - Contratos del periodo anterior (no tiene que haber contratos todos los días necesariamente). 
    insert into TEMP_ANT (DIA_ANT, TRIMESTRE_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
    select DIA_H, TRIMESTRE_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
    where DIA_H = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;



-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;
    
    -- TEMP_MANTIENE - Contratos que están en TEMP_H y en TEMP_ANT  
    insert into TEMP_MANTIENE (TRIMESTRE_ID, CONTRATO_ID) 
    select TRIMESTRE_H, CONTRATO_H from TEMP_H join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and TRIMESTRE_H = TRIMESTRE_ANT
    where TRIMESTRE_H = trimestre;

    -- TEMP_ALTA - Contratos que están en TEMP_H pero no en H_TEMP_ANT
    insert into TEMP_ALTA (TRIMESTRE_ID, CONTRATO_ID) 
    select TRIMESTRE_H, CONTRATO_H from TEMP_H left join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and TRIMESTRE_H = TRIMESTRE_ANT
    where TRIMESTRE_H = trimestre and CONTRATO_ANT is null;
    
    -- TEMP_BAJA - Contratos que están en TEMP_ANT pero no en TEMP_H. Incluye DIA_MOV para encontrar los contratos en H_CONTRATO
    insert into TEMP_BAJA (TRIMESTRE_H, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)  
    select TRIMESTRE_ANT, CONTRATO_ANT, ant.SITUACION_CONTRATO_DETALLE_ANT, ant.NUM_DIAS_VENCIDOS_PERIODO_ANT, ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT from TEMP_ANT ant left join TEMP_H on CONTRATO_H = CONTRATO_ANT and TRIMESTRE_H = TRIMESTRE_ANT 
    where TRIMESTRE_ANT = trimestre and CONTRATO_H is null and TRIMESTRE_ANT is not null;

    -- SITUACION_RESPECTO_PERIODO_ANT_ID - 0 Mantiene, 1 Alta, 2 Baja
    update H_CONTRATO_TRIMESTRE h, TEMP_MANTIENE man set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 0 where h.TRIMESTRE_ID = man.TRIMESTRE_ID and h.CONTRATO_ID = man.CONTRATO_ID;
    update H_CONTRATO_TRIMESTRE h, TEMP_ALTA alt set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 1 where h.TRIMESTRE_ID = alt.TRIMESTRE_ID and h.CONTRATO_ID = alt.CONTRATO_ID;

    -- UNNIM
    -- -- SITUACION_ANTERIOR_CONTRATO_DETALLE_ID - 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
    -- -- Si alta no tiene situación anterior.
    -- update H_CONTRATO_TRIMESTRE h set SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = -2 where SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)
    -- -- El resto adquiere el del periodo anterior                                                                          
    -- update H_CONTRATO_TRIMESTRE h, TEMP_ANT ant set h.SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = ant.SITUACION_CONTRATO_DETALLE_ANT where h.TRIMESTRE_ID = ant.TRIMESTRE_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and SITUACION_ANTERIOR_CONTRATO_DETALLE_ID is null;

    -- NUM_DIAS_VENCIDOS_PERIODO_ANT                           
    update H_CONTRATO_TRIMESTRE h, TEMP_ANT ant set h.NUM_DIAS_VENCIDOS_PERIODO_ANT = ant.NUM_DIAS_VENCIDOS_PERIODO_ANT where h.TRIMESTRE_ID = ant.TRIMESTRE_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT;

    -- TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT 
    -- Si alta no tiene situación anterior.
    update H_CONTRATO_TRIMESTRE h set TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = -2 where SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)
    -- El resto adquiere el del periodo anterior                              
    update H_CONTRATO_TRIMESTRE h, TEMP_ANT ant set h.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where h.TRIMESTRE_ID = ant.TRIMESTRE_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID is null;
        
 end loop c_trimestre_loop;
close c_trimestre;


update TEMP_BAJA baj, TEMP_FECHA fech set baj.TRIMESTRE_MOV = fech.TRIMESTRE_H where baj.TRIMESTRE_H = fech.TRIMESTRE_ANT;


-- BAJAS TRIMESTRE 
    insert into H_CONTRATO_TRIMESTRE
        (TRIMESTRE_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
   )
  select TRIMESTRE_H,
        FECHA_CARGA_DATOS,
        h.CONTRATO_ID, 
        -2,                                         -- SITUACION_CONTRATO_DETALLE_ID = Normalizado (Baja)
        SITUACION_CONTRATO_DETALLE_ANT,             -- 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
        2,                                          -- SITUACION_RESPECTO_PERIODO_ANT_ID = Baja
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
  from H_CONTRATO_TRIMESTRE h, TEMP_BAJA baj where h.TRIMESTRE_ID = baj.TRIMESTRE_MOV and h.CONTRATO_ID = baj.CONTRATO_ID;
  

update H_CONTRATO_TRIMESTRE set TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = (case when NUM_DIAS_VENCIDOS_PERIODO_ANT <= 0 then 0
                                                                                when NUM_DIAS_VENCIDOS_PERIODO_ANT > 0 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 30 then 1
                                                                                when NUM_DIAS_VENCIDOS_PERIODO_ANT > 30 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 60 then 2
                                                                                when NUM_DIAS_VENCIDOS_PERIODO_ANT > 60 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 90 then 3
                                                                                when NUM_DIAS_VENCIDOS_PERIODO_ANT > 90 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 120 then 4
                                                                                when NUM_DIAS_VENCIDOS_PERIODO_ANT > 120 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 365 then 5
                                                                                when NUM_DIAS_VENCIDOS_PERIODO_ANT > 365 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 1095 then 6
                                                                                when NUM_DIAS_VENCIDOS_PERIODO_ANT > 1095 then 7
                                                                                else -1 end);


-- ----------------------------------------------------------------------------------------------
--                                      H_CONTRATO_ANIO
-- ----------------------------------------------------------------------------------------------

-- ----------------------------------- TABLAS TEMPORALES ----------------------------------------
-- Calculamos las Fechas H (tabla hechos) y ANT (Periodo anterior)
truncate table TEMP_FECHA;
truncate table TEMP_FECHA_AUX;

insert into TEMP_FECHA_AUX (ANIO_AUX) select DISTINCT ANIO_ID from DIM_FECHA_DIA where DIA_ID between date_start and date_end;
-- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
insert into TEMP_FECHA_AUX (ANIO_AUX) select (select max(ANIO_ID) from H_CONTRATO_ANIO where ANIO_ID < (select min(ANIO_AUX) from TEMP_FECHA_AUX));

insert into TEMP_FECHA (DIA_H) select distinct(DIA_ID) from H_CONTRATO;
update TEMP_FECHA tf, DIM_FECHA_DIA d set tf.ANIO_H = d.ANIO_ID  where tf.DIA_H = d.DIA_ID;
delete from TEMP_FECHA where ANIO_H not in (select distinct ANIO_AUX from TEMP_FECHA_AUX);
update TEMP_FECHA set ANIO_ANT = (select MIN(ANIO_AUX) from TEMP_FECHA_AUX where ANIO_AUX > ANIO_H);

-- Truncamos el resto de tablas temporales
truncate table TEMP_H;
truncate table TEMP_ANT;
truncate table TEMP_MANTIENE;
truncate table TEMP_ALTA;
truncate table TEMP_BAJA;

set max_anio_periodo_ant = (select min(ANIO_H) from TEMP_FECHA);
set max_dia_periodo_ant = (select max(DIA_H) from TEMP_FECHA where ANIO_H = max_anio_periodo_ant);

-- Incluimos en TEMP_H y TEMP_ANT el max_dia_periodo_ant para poder comparar con date_start
-- TEMP_H - Contratos de cada periodo    
insert into TEMP_H (DIA_H, ANIO_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
select DIA_ID, max_anio_periodo_ant, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
where DIA_ID = max_dia_periodo_ant and SITUACION_RESPECTO_PERIODO_ANT_ID <> 2;

-- TEMP_ANT - Contratos del periodo anterior (no tiene que haber contratos todos los días necesariamente). 
insert into TEMP_ANT (DIA_ANT, ANIO_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
select DIA_H, ANIO_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
where DIA_H = max_dia_periodo_ant;


-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);

    -- Borrado de los años a insertar
    delete from H_CONTRATO_ANIO where ANIO_ID = anio;

    insert into H_CONTRATO_ANIO
        (ANIO_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
        )
    select anio, 
        max_dia_anio,
        CONTRATO_ID,  
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
    from H_CONTRATO where DIA_ID = max_dia_anio and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;
    
    -- TEMP_H - Contratos de cada periodo    
    insert into TEMP_H (DIA_H, ANIO_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H) 
    select DIA_ID, ANIO, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ID, NUM_DIAS_VENCIDOS, TRAMO_IRREGULARIDAD_FASES_ID from H_CONTRATO 
    where DIA_ID = max_dia_anio and SITUACION_RESPECTO_PERIODO_ANT_ID<>2;

    -- TEMP_ANT - Contratos del periodo anterior (no tiene que haber contratos todos los días necesariamente). 
    insert into TEMP_ANT (DIA_ANT, ANIO_ANT, CONTRATO_ANT, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)
    select DIA_H, ANIO_H, CONTRATO_H, SITUACION_CONTRATO_DETALLE_H, NUM_DIAS_VENCIDOS_H, TRAMO_IRREGULARIDAD_FASES_H from TEMP_H 
    where DIA_H = max_dia_anio;

end loop c_anio_loop;
close c_anio;

-- Actualizamos las fechas para poder comparar con TEMP_H en el mismo día. Ej. El mes 6 TEMP_H tiene los contratos del mes 6 y TEMP_ANT los del 5.
update TEMP_ANT ant, TEMP_FECHA fech set ant.ANIO_ANT = fech.ANIO_ANT where ant.DIA_ANT = fech.DIA_H;

-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;
    
    -- TEMP_MANTIENE - Contratos que están en TEMP_H y en TEMP_ANT  
    insert into TEMP_MANTIENE (ANIO_ID, CONTRATO_ID) 
    select ANIO_H, CONTRATO_H from TEMP_H join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and ANIO_H = ANIO_ANT
    where ANIO_H = ANIO;

    -- TEMP_ALTA - Contratos que están en TEMP_H pero no en H_TEMP_ANT
    insert into TEMP_ALTA (ANIO_ID, CONTRATO_ID) 
    select ANIO_H, CONTRATO_H from TEMP_H left join TEMP_ANT on CONTRATO_H = CONTRATO_ANT and ANIO_H = ANIO_ANT
    where ANIO_H = ANIO and CONTRATO_ANT is null;
    
    -- TEMP_BAJA - Contratos que están en TEMP_ANT pero no en TEMP_H. Incluye DIA_MOV para encontrar los contratos en H_CONTRATO
    insert into TEMP_BAJA (ANIO_H, CONTRATO_ID, SITUACION_CONTRATO_DETALLE_ANT, NUM_DIAS_VENCIDOS_PERIODO_ANT, TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT)  
    select ANIO_ANT, CONTRATO_ANT, ant.SITUACION_CONTRATO_DETALLE_ANT, ant.NUM_DIAS_VENCIDOS_PERIODO_ANT, ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT from TEMP_ANT ant left join TEMP_H on CONTRATO_H = CONTRATO_ANT and ANIO_H = ANIO_ANT 
    where ANIO_ANT = ANIO and CONTRATO_H is null and ANIO_ANT is not null;

    -- SITUACION_RESPECTO_PERIODO_ANT_ID - 0 Mantiene, 1 Alta, 2 Baja
    update H_CONTRATO_ANIO h, TEMP_MANTIENE man set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 0 where h.ANIO_ID = man.ANIO_ID and h.CONTRATO_ID = man.CONTRATO_ID;
    update H_CONTRATO_ANIO h, TEMP_ALTA alt set h.SITUACION_RESPECTO_PERIODO_ANT_ID = 1 where h.ANIO_ID = alt.ANIO_ID and h.CONTRATO_ID = alt.CONTRATO_ID;

    -- UNNIM
    -- -- SITUACION_ANTERIOR_CONTRATO_DETALLE_ID - 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
    -- -- Si alta no tiene situación anterior.
    -- update H_CONTRATO_ANIO h set SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = -2 where SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)                                  
    -- -- El resto adquiere el del periodo anterior                                  
    -- update H_CONTRATO_ANIO h, TEMP_ANT ant set h.SITUACION_ANTERIOR_CONTRATO_DETALLE_ID = ant.SITUACION_CONTRATO_DETALLE_ANT where h.ANIO_ID = ant.ANIO_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and SITUACION_ANTERIOR_CONTRATO_DETALLE_ID is null;
     

    -- NUM_DIAS_VENCIDOS_PERIODO_ANT                           
    update H_CONTRATO_ANIO h, TEMP_ANT ant set h.NUM_DIAS_VENCIDOS_PERIODO_ANT = ant.NUM_DIAS_VENCIDOS_PERIODO_ANT where h.ANIO_ID = ant.ANIO_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT;

    -- TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT 
    -- Si alta no tiene situación anterior.
    update H_CONTRATO_ANIO h set TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = -2 where SITUACION_RESPECTO_PERIODO_ANT_ID = 1; -- No existe (Alta)
    -- El resto adquiere el del periodo anterior                              
    update H_CONTRATO_ANIO h, TEMP_ANT ant set h.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID = ant.TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT where h.ANIO_ID = ant.ANIO_ANT and h.CONTRATO_ID = ant.CONTRATO_ANT and TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID is null;

end loop c_anio_loop;
close c_anio;
            
            
update TEMP_BAJA baj, TEMP_FECHA fech set baj.ANIO_MOV = fech.ANIO_H where baj.ANIO_H = fech.ANIO_ANT;

-- BAJAS ANIO 
    insert into H_CONTRATO_ANIO
       (ANIO_ID,
        FECHA_CARGA_DATOS,
        CONTRATO_ID,
        SITUACION_CONTRATO_DETALLE_ID,
        SITUACION_ANTERIOR_CONTRATO_DETALLE_ID,
        SITUACION_RESPECTO_PERIODO_ANT_ID,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
   )
  select ANIO_H, 
        FECHA_CARGA_DATOS,
        h.CONTRATO_ID, 
        -2,                                         -- SITUACION_CONTRATO_DETALLE_ID = Normalizado (Baja)
        SITUACION_CONTRATO_DETALLE_ANT,             -- 0 Normal, 1 Vencido < 30 días, 2 Vencido 30-60 días, ...
        2,                                          -- SITUACION_RESPECTO_PERIODO_ANT_ID = Baja,
        DIA_POS_VENCIDA_ID,
        DIA_SALDO_DUDOSO_ID,
        ESTADO_FINANCIERO_CONTRATO_ID,
        ESTADO_FINANCIERO_ANTERIOR_ID,
        ESTADO_CONTRATO_ID,
        CONTRATO_JUDICIALIZADO_ID,
        CONTRATO_ESTADO_JUDICIALIZADO_ID,
        ESTADO_INSINUACION_CONTRATO_ID,
        EN_GESTION_RECOBRO_ID,
        FECHA_ALTA_GESTION_RECOBRO,
        FECHA_BAJA_GESTION_RECOBRO,
        FECHA_COMPROMETIDA_PAGO,
        FECHA_DPS,
        TRAMO_IRREGULARIDAD_DIAS_ID,
        TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID,
        TRAMO_IRREGULARIDAD_FASES_ID,
        TRAMO_IRREGULARIDAD_FASES_PERIODO_ANT_ID,
        TRAMO_DIAS_EN_GESTION_A_COBRO_ID,
        TRAMO_DIAS_IRREGULAR_A_COBRO_ID,
        RESULTADO_ACTUACION_CONTRATO_ID,
        MODELO_RECOBRO_CONTRATO_ID,
        PROVEEDOR_RECOBRO_CONTRATO_ID,
        CONTRATO_EN_IRREGULAR_ID,
        CONTRATO_CON_DPS_ID,
        CONTRATO_CON_CONTACTO_UTIL_ID,
        CONTRATO_CON_ACTUACION_RECOBRO_ID,
        EN_GESTION_ESPECIALIZADA_ID,
        CONTRATO_CON_PREVISION_ID,
        CONTRATO_CON_PREVISION_REVISADA_ID ,
        TIPO_PREVISION_ID,
        PREVISION_SITUACION_INICIAL_ID,
        PREVISION_SITUACION_AUTOMATICO_ID,
        PREVISION_SITUACION_MANUAL_ID,
        PREVISION_SITUACION_FINAL_ID,
        MOTIVO_PREVISION_ID,
        SITUACION_ESPECIALIZADA_ID,
        GESTOR_ESPECIALIZADA_ID,
        SUPERVISOR_N1_ESPECIALIZADA_ID,
        SUPERVISOR_N2_ESPECIALIZADA_ID,
        SUPERVISOR_N3_ESPECIALIZADA_ID,
        EN_CARTERA_ESTUDIO_ID,
        MODELO_GESTION_CARTERA_ID,
        UNIDAD_GESTION_CARTERA_ID,
        CONTRATO_CON_CAPITAL_FALLIDO_ID,
        TIPO_GESTION_CONTRATO_ID,
        FECHA_CREACION_CONTRATO,
        NUM_CONTRATOS,
        NUM_CLIENTES_ASOCIADOS,
        NUM_EXPEDIENTES_ASOCIADOS,
        NUM_DIAS_VENCIDOS,
        SALDO_TOTAL,
        POSICION_VIVA_NO_VENCIDA,
        POSICION_VIVA_VENCIDA,
        SALDO_DUDOSO,
        PROVISION,
        INTERESES_REMUNERATORIOS,
        INTERESES_MORATORIOS,
        COMISIONES,
        GASTOS,
        RIESGO,
        DEUDA_IRREGULAR,
        DISPUESTO,
        SALDO_PASIVO,
        RIESGO_GARANTIA,
        SALDO_EXCE,
        LIMITE_DESC,
        MOV_EXTRA_1,
        MOV_EXTRA_2,
        MOV_LTV_INI,
        MOV_LTV_FIN,
        DD_MX3_ID,
        DD_MX4_ID,
        CNT_LIMITE_INI,
        CNT_LIMITE_FIN,
        NUM_CREDITOS_INSINUADOS,
        CREDITO_INSINUADO_PRINCIPAL_EXTERNO,
        CREDITO_INSINUADO_PRINCIPAL_SUPERVISOR,
        CREDITO_INSINUADO_PRINCIPAL_FINAL,
        DEUDA_EXIGIBLE,
        CAPITAL_FALLIDO,
        NUM_DPS,
        NUM_DPS_ACUMULADO,
        DPS,
        DPS_CAPITAL,
        DPS_ICG,
        DPS_ACUMULADO,
        DPS_CAPITAL_ACUMULADO,
        DPS_ICG_ACUMULADO,
        SALDO_MAXIMO_GESTION,
        IMPORTE_A_RECLAMAR,
        NUM_DIAS_EN_GESTION_A_COBRO,
        NUM_DIAS_IRREGULAR_A_COBRO,
        NUM_ACTUACIONES_RECOBRO,
        NUM_ACTUACIONES_RECOBRO_ACUMULADO,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL,
        NUM_ACTUACIONES_RECOBRO_CON_CONTACTO_UTIL_ACUMULADO,
        IMPORTE_IRREGULAR_PREVISION_INICIO,
        IMPORTE_IRREGULAR_PREVISION_AUTOMATICO,
        IMPORTE_IRREGULAR_PREVISION_MANUAL,
        IMPORTE_IRREGULAR_PREVISION_FINAL,
        IMPORTE_RIESGO_PREVISION_INICIO,
        IMPORTE_RIESGO_PREVISION_AUTOMATICO,
        IMPORTE_RIESGO_PREVISION_MANUAL,
        IMPORTE_RIESGO_PREVISION_FINAL
  from H_CONTRATO_ANIO h, TEMP_BAJA baj where h.ANIO_ID = baj.ANIO_mov and h.CONTRATO_ID = baj.CONTRATO_ID;


update H_CONTRATO_ANIO set TRAMO_IRREGULARIDAD_DIAS_PERIODO_ANT_ID = (case when NUM_DIAS_VENCIDOS_PERIODO_ANT <= 0 then 0
                                                                           when NUM_DIAS_VENCIDOS_PERIODO_ANT > 0 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 30 then 1
                                                                           when NUM_DIAS_VENCIDOS_PERIODO_ANT > 30 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 60 then 2
                                                                           when NUM_DIAS_VENCIDOS_PERIODO_ANT > 60 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 90 then 3
                                                                           when NUM_DIAS_VENCIDOS_PERIODO_ANT > 90 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 120 then 4
                                                                           when NUM_DIAS_VENCIDOS_PERIODO_ANT > 120 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 365 then 5
                                                                           when NUM_DIAS_VENCIDOS_PERIODO_ANT > 365 and NUM_DIAS_VENCIDOS_PERIODO_ANT <= 1095 then 6
                                                                           when NUM_DIAS_VENCIDOS_PERIODO_ANT > 1095 then 7
                                                                           else -1 end);
                
                                                                          
                                                                     
END MY_BLOCK_H_CNT
