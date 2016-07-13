DELIMITER $$
CREATE DEFINER=`lindorff`@`ba01` PROCEDURE `Cargar_H_Procedimiento`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_PRC: BEGIN











 



declare max_dia_h date;
declare max_dia_mov date;
declare penult_dia_mov date;
declare max_dia_con_contratos_h date;
declare max_dia_mes date;
declare max_dia_trimestre date;
declare max_dia_anio date;
declare max_dia_add_bi_h date;
declare max_dia_add_bi date;

declare mes int;
declare trimestre int;
declare anio int;
declare fecha date;
declare fecha_rellenar date;

declare l_last_row int default 0;

declare c_fecha_rellenar cursor for select distinct(DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end;
declare c_fecha cursor for select distinct(DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end; 

declare c_meses cursor for select distinct MES_H from TEMP_FECHA order by 1;
declare c_trimestre cursor for select distinct TRIMESTRE_H from TEMP_FECHA order by 1;
declare c_anio cursor for select distinct ANIO_H from TEMP_FECHA order by 1;
declare continue HANDLER FOR NOT FOUND SET l_last_row = 1;





DECLARE EXIT handler for 1062 set o_error_status := 'Error 1062: La tabla ya existe';
DECLARE EXIT handler for 1048 set o_error_status := 'Error 1048: Has intentado insertar un valor nulo'; 
DECLARE EXIT handler for 1318 set o_error_status := 'Error 1318: NÃºmero de parÃ¡metros incorrecto'; 




DECLARE EXIT handler for sqlexception set o_error_status:= 'Se ha producido un error en el proceso';



delete from H_PROCEDIMIENTO where DIA_ID between date_start and date_end;
delete from H_PROCEDIMIENTO_DETALLE_COBRO where DIA_ID between date_start and date_end;
delete from H_PROCEDIMIENTO_DETALLE_CONTRATO where DIA_ID between date_start and date_end;
delete from H_PROCEDIMIENTO_DETALLE_RESOLUCION where DIA_ID between date_start and date_end;


truncate table TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD;
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P01', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P02', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P03', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P04', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P15', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P16', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P17', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P21', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P32', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P36', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P37', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P38', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P39', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P40', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P41', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P43', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P44', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P45', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P46', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P47', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P48', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P49', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P50', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P51', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P52', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P53', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P55', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P70', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P72', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P76', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P78', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P79', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P80', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P85', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P94', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P05' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P06' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P07' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P08' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P09' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P10' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P1000' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P11' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P12' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P13' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P14' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P18' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P19' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P20' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P22' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P23' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P24' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P25' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P26' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P27' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P28' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P29' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P30' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P31' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P33' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P34' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P35' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P42' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P54' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P56' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P60' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P61' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P62' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P63' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P64' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P65' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P71' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P73' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P74' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P75' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P77' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P81' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P82' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P83' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P84' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P86' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P91' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P92' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P93' ,2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P95' ,2);


truncate table TEMP_PROCEDIMIENTO_JERARQUIA;
 insert into TEMP_PROCEDIMIENTO_JERARQUIA (
    DIA_ID,                               
    ITER,
    FASE_ACTUAL, 
    NIVEL,
    CONTEXTO,
    CODIGO_FASE_ACTUAL,
    PRIORIDAD_FASE,
    CANCELADO_FASE,
    ASU_ID
  ) 
select Fecha_Procedimiento,
    PJ_PADRE,
    PRC_ID,
    NIVEL,
    PATH_DERIVACION,
    PRC_TPO,
    coalesce(PRIORIDAD, 0),
    CANCEL_PRC,
    ASU_ID
from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
left join TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD on PRC_TPO = DD_TPO_CODIGO
where STR_TO_DATE(Fecha_Procedimiento, '%Y-%m-%d') between date_start and date_end; 


set l_last_row = 0; 

open c_fecha_rellenar;
rellenar_loop: loop
fetch c_fecha_rellenar into fecha_rellenar;        
    if (l_last_row=1) then leave rellenar_loop; 
    end if;
    
    
    if((select count(DIA_ID) from TEMP_PROCEDIMIENTO_JERARQUIA where DIA_ID = fecha_rellenar) = 0) then 
    insert into TEMP_PROCEDIMIENTO_JERARQUIA(
        DIA_ID,                               
        ITER,   
        FASE_ACTUAL, 
        NIVEL,
        CONTEXTO,
        CODIGO_FASE_ACTUAL,   
        PRIORIDAD_FASE,
        CANCELADO_FASE,
        ASU_ID 
        )
    select date_add(DIA_ID, INTERVAL 1 DAY),                             
        ITER,   
        FASE_ACTUAL, 
        NIVEL,
        CONTEXTO,
        CODIGO_FASE_ACTUAL,   
        PRIORIDAD_FASE,
        CANCELADO_FASE,
        ASU_ID
        from TEMP_PROCEDIMIENTO_JERARQUIA where DIA_ID = date_add(fecha_rellenar, INTERVAL -1 DAY);
    end if; 
    
end loop;
close c_fecha_rellenar;






truncate table TEMP_PROCEDIMIENTO_COBROS;
insert into TEMP_PROCEDIMIENTO_COBROS (FECHA_COBRO, CONTRATO, IMPORTE, TIPO_COBRO_DETALLE_ID)
select date(CPA_FECHA), CNT_ID, CPA_IMPORTE, DD_SCP_ID from recovery_lindorff_datastage.CPA_COBROS_PAGOS;




truncate table TEMP_PROCEDIMIENTO_CARTERA;
insert into TEMP_PROCEDIMIENTO_CARTERA (CONTRATO, CARTERA)
select cnt.CNT_ID, car.car_id from recovery_lindorff_datastage.CNT_CONTRATOS cnt join recovery_lindorff_datastage.CAR_CARTERA car on car.OFICINA = cnt.OFI_ID;




truncate table TEMP_PROCEDIMIENTO_CEDENTE;
insert into TEMP_PROCEDIMIENTO_CEDENTE (CONTRATO, CEDENTE)
select CNT_ID, IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 34;



truncate table TEMP_PROCEDIMIENTO_PROPIETARIO;
insert into TEMP_PROCEDIMIENTO_PROPIETARIO (CONTRATO, PROPIETARIO)
select CNT_ID, IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 33;




truncate table TEMP_PROCEDIMIENTO_REFERENCIA;
insert into TEMP_PROCEDIMIENTO_REFERENCIA (CONTRATO, REFERENCIA_ASUNTO)
select CNT_ID, IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 31;




truncate table TEMP_PROCEDIMIENTO_SEGMENTO;
insert into TEMP_PROCEDIMIENTO_SEGMENTO (CONTRATO, SEGMENTO)
select CNT_ID, IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 42;




truncate table TEMP_PROCEDIMIENTO_SOCIO;
insert into TEMP_PROCEDIMIENTO_SOCIO (CONTRATO, SOCIO)
select CNT_ID, IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 43;





truncate table TEMP_PROCEDIMIENTO_TITULAR;
insert into TEMP_PROCEDIMIENTO_TITULAR (PROCEDIMIENTO, CONTRATO, TITULAR_PROCEDIMIENTO)
select PRC_ID, cex.CNT_ID, p.PER_ID from recovery_lindorff_datastage.PER_PERSONAS p
join recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS cpe on p.PER_ID = cpe.PER_ID
join recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex on cpe.CNT_ID = cex.CNT_ID
join recovery_lindorff_datastage.PRC_CEX prcex on prcex.CEX_ID = cex.CEX_ID
where DD_TIN_ID = 303 and CPE_ORDEN = 0 and cex.CEX_PASE = 1
group by PRC_ID;






truncate table TEMP_PROCEDIMIENTO_DEMANDADO;
insert into TEMP_PROCEDIMIENTO_DEMANDADO (PROCEDIMIENTO, CONTRATO, DEMANDADO)
select prcper.PRC_ID, CNT_ID, prcper.PER_ID from recovery_lindorff_datastage.CPE_CONTRATOS_PERSONAS cpe
join recovery_lindorff_datastage.PRC_PER prcper on cpe.PER_ID = prcper.PER_ID 
where (cpe.DD_TIN_ID = 305 or cpe.DD_TIN_ID = 306) and (CPE_ORDEN = 1 or CPE_ORDEN = 2);



set l_last_row = 0; 

open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;
    
   
    truncate TEMP_PROCEDIMIENTO_DETALLE;
    insert into TEMP_PROCEDIMIENTO_DETALLE(ITER) select distinct ITER from TEMP_PROCEDIMIENTO_JERARQUIA WHERE DIA_ID = fecha;

    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set MAX_PRIORIDAD = (select max(PRIORIDAD_FASE) from TEMP_PROCEDIMIENTO_JERARQUIA pj where pj.DIA_ID = fecha and pj.ITER = pd.ITER);
    
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set PRIORIDAD_PROCEDIMIENTO = (select MAX_PRIORIDAD from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    update TEMP_PROCEDIMIENTO_DETALLE pd set FASE_MAX_PRIORIDAD = (select max(FASE_ACTUAL) from TEMP_PROCEDIMIENTO_JERARQUIA pj where pj.DIA_ID = fecha and pj.ITER = pd.ITER and pj.PRIORIDAD_PROCEDIMIENTO = pj.PRIORIDAD_FASE);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FASE_MAX_PRIORIDAD = (select FASE_MAX_PRIORIDAD from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set NUM_FASES = (select count(*) from TEMP_PROCEDIMIENTO_JERARQUIA pj where pj.DIA_ID = fecha and pj.ITER = pd.ITER);
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set CANCELADO_FASE = (select sum(CANCELADO_FASE) from TEMP_PROCEDIMIENTO_JERARQUIA pj where pj.DIA_ID = fecha and pj.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_DETALLE set CANCELADO_PROCEDIMIENTO = (case when NUM_FASES = CANCELADO_FASE then 1 else 0 end);
    
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set CANCELADO_PROCEDIMIENTO = (select CANCELADO_PROCEDIMIENTO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set NUM_FASES = (select NUM_FASES from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    
    truncate table TEMP_PROCEDIMIENTO_TAREA;
    insert into TEMP_PROCEDIMIENTO_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA) 
    select tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA from TEMP_PROCEDIMIENTO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        where DIA_ID = fecha and date(tar.TAR_FECHA_INI) <= fecha and tar.DD_STA_ID not in (16, 26, 28, 41, 43, 44, 46, 47, 503) and tar.TAR_CODIGO <> 3;
    
	
    truncate TEMP_PROCEDIMIENTO_AUTO_PRORROGAS;
    insert into TEMP_PROCEDIMIENTO_AUTO_PRORROGAS (TAREA, FECHA_AUTO_PRORROGA) select tex.TAR_ID, date(mej.FECHACREAR) from recovery_lindorff_datastage.MEJ_REG_REGISTRO mej
                                                                  join recovery_lindorff_datastage.MEJ_IRG_INFO_REGISTRO info on mej.REG_ID = info.REG_ID
                                                                  join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on info.IRG_VALOR = tex.TEX_ID
                                                                  where mej.DD_TRG_ID = 4 and info.IRG_CLAVE = 'tarId' and date(mej.FECHACREAR) <= fecha;
    
    update TEMP_PROCEDIMIENTO_TAREA pt set  FECHA_AUTO_PRORROGA = (select coalesce(max(FECHA_AUTO_PRORROGA), '0000-00-00 00:00:00') from TEMP_PROCEDIMIENTO_AUTO_PRORROGAS tpa where tpa.TAREA = pt.TAREA);  
    update TEMP_PROCEDIMIENTO_TAREA pt set FECHA_PRORROGA = (select coalesce(max(FECHACREAR), '0000-00-00 00:00:00') from recovery_lindorff_datastage.SPR_SOLICITUD_PRORROGA spr where spr.TAR_ID = pt.TAREA and date(spr.FECHACREAR) <= fecha);
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ULTIMA_TAREA_CREADA = (select max(FECHA_INI) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha and FECHA_INI<>'0000-00-00 00:00:00');
    update TEMP_PROCEDIMIENTO_DETALLE pd set ULTIMA_TAREA_CREADA = (select max(TAREA) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and tp.FECHA_INI = pd.FECHA_ULTIMA_TAREA_CREADA);
   
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ULTIMA_TAREA_FINALIZADA = (select max(FECHA_FIN) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_FIN) <= fecha and FECHA_FIN<>'0000-00-00 00:00:00');
    update TEMP_PROCEDIMIENTO_DETALLE pd set ULTIMA_TAREA_FINALIZADA = (select max(TAREA) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and tp.FECHA_FIN = pd.FECHA_ULTIMA_TAREA_FINALIZADA);
   
    update TEMP_PROCEDIMIENTO_TAREA set FECHA_ACTUALIZACION = FECHA_INI where date(FECHA_INI) <= fecha;
    update TEMP_PROCEDIMIENTO_TAREA set FECHA_ACTUALIZACION = FECHA_FIN where FECHA_FIN >= FECHA_ACTUALIZACION and date(FECHA_FIN) <= fecha;
    update TEMP_PROCEDIMIENTO_TAREA set FECHA_ACTUALIZACION = FECHA_PRORROGA where FECHA_PRORROGA >= FECHA_ACTUALIZACION and date(FECHA_PRORROGA) <= fecha;
    update TEMP_PROCEDIMIENTO_TAREA set FECHA_ACTUALIZACION = FECHA_AUTO_PRORROGA where FECHA_PRORROGA >= FECHA_ACTUALIZACION and date(FECHA_AUTO_PRORROGA) <= fecha;
                                                                       
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ULTIMA_TAREA_ACTUALIZADA = (select max(FECHA_ACTUALIZACION) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and tp.FECHA_ACTUALIZACION<>'0000-00-00 00:00:00');
    update TEMP_PROCEDIMIENTO_DETALLE pd set ULTIMA_TAREA_ACTUALIZADA = (select max(TAREA) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and tp.FECHA_ACTUALIZACION = pd.FECHA_ULTIMA_TAREA_ACTUALIZADA);
    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ULTIMA_TAREA_PENDIENTE = (select max(FECHA_INI) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and (date(tp.FECHA_INI) <= fecha and FECHA_INI<>'0000-00-00 00:00:00') and (FECHA_FIN = '0000-00-00 00:00:00' or date(tp.FECHA_FIN) > fecha));
    update TEMP_PROCEDIMIENTO_DETALLE pd set ULTIMA_TAREA_PENDIENTE = (select max(TAREA) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and tp.FECHA_INI = pd.FECHA_ULTIMA_TAREA_PENDIENTE and tp.FECHA_FIN = '0000-00-00 00:00:00');
    
    
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set ULTIMA_TAREA_CREADA = (select ULTIMA_TAREA_CREADA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;  
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ULTIMA_TAREA_CREADA = (select FECHA_ULTIMA_TAREA_CREADA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;   
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set ULTIMA_TAREA_FINALIZADA = (select ULTIMA_TAREA_FINALIZADA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;  
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ULTIMA_TAREA_FINALIZADA = (select FECHA_ULTIMA_TAREA_FINALIZADA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;   
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set ULTIMA_TAREA_ACTUALIZADA = (select ULTIMA_TAREA_ACTUALIZADA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;  
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ULTIMA_TAREA_ACTUALIZADA = (select FECHA_ULTIMA_TAREA_ACTUALIZADA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;   
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set ULTIMA_TAREA_PENDIENTE = (select ULTIMA_TAREA_PENDIENTE from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;  
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ULTIMA_TAREA_PENDIENTE = (select FECHA_ULTIMA_TAREA_PENDIENTE from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;   
    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set FASE_ACTUAL = (select (FASE) from TEMP_PROCEDIMIENTO_TAREA pt where pt.ITER = pd.ITER and pt.TAREA = pd.ULTIMA_TAREA_CREADA);
    update TEMP_PROCEDIMIENTO_DETALLE pd set FASE_ACTUAL = (select max(FASE_ACTUAL) from TEMP_PROCEDIMIENTO_JERARQUIA pj where pj.DIA_ID = fecha and pj.ITER = pd.ITER)
                                                             where FASE_ACTUAL is null;
    
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set ULTIMA_FASE = (select FASE_ACTUAL from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ULTIMA_TAREA_PENDIENTE_FA = (select max(FECHA_INI) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and pd.FASE_ACTUAL = tp.FASE and (date(tp.FECHA_INI) <= fecha and FECHA_INI<>'0000-00-00 00:00:00') and (FECHA_FIN = '0000-00-00 00:00:00' or date(tp.FECHA_FIN) > fecha));
    update TEMP_PROCEDIMIENTO_DETALLE pd set ULTIMA_TAREA_PENDIENTE_FA = (select max(TAREA) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and pd.FASE_ACTUAL = tp.FASE and tp.FECHA_INI = pd.FECHA_ULTIMA_TAREA_PENDIENTE_FA and tp.FECHA_FIN = '0000-00-00 00:00:00');
    
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ULTIMA_TAREA_PENDIENTE_FA = (select FECHA_ULTIMA_TAREA_PENDIENTE_FA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set ULTIMA_TAREA_PENDIENTE_FA = (select ULTIMA_TAREA_PENDIENTE_FA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;  
    
    
    
    truncate table TEMP_PROCEDIMIENTO_TAREA;
    insert into TEMP_PROCEDIMIENTO_TAREA (ITER, FASE, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_PROCEDIMIENTO_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecPresentacionDemanda';  
        
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_INTERPOSICION_DEMANDA = (select max(FECHA_FORMULARIO) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_INTERPOSICION_DEMANDA = (select FECHA_INTERPOSICION_DEMANDA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
	
    truncate table TEMP_PROCEDIMIENTO_TAREA;
    insert into TEMP_PROCEDIMIENTO_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA ,TAP_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
    from TEMP_PROCEDIMIENTO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where DIA_ID = fecha and date(tar.TAR_FECHA_INI) <= fecha and tev.TEV_NOMBRE IN ('fecha') and tex.tap_id in (1004, 10000000000200);
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ACEPTACION = (select max(FECHA_FORMULARIO) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha and FECHA_FIN <> '0000-00-00 00:00:00');
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ACEPTACION = (select FECHA_ACEPTACION from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 

    
	
    truncate table TEMP_PROCEDIMIENTO_TAREA;
    insert into TEMP_PROCEDIMIENTO_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA) 
    select tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA
    from TEMP_PROCEDIMIENTO_JERARQUIA tpj
    join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        where DIA_ID = fecha and date(tar.TAR_FECHA_INI) <= fecha and TAR_TAREA = 'Recogida de documentaciÃ³n y aceptaciÃ³n' and tar.TAR_FECHA_FIN is not null;
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_RECOGIDA_DOC_Y_ACEPTACION = (select max(FECHA_FIN) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_RECOGIDA_DOC_Y_ACEPTACION = (select FECHA_RECOGIDA_DOC_Y_ACEPTACION from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 

    
	
    truncate table TEMP_PROCEDIMIENTO_TAREA;
    insert into TEMP_PROCEDIMIENTO_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA) 
    select tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA
    from TEMP_PROCEDIMIENTO_JERARQUIA tpj
    join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        where DIA_ID = fecha and date(tar.TAR_FECHA_INI) <= fecha and TAR_TAREA = 'Registrar toma de decisiÃ³n' and tar.TAR_FECHA_FIN is not null;
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_REGISTRAR_TOMA_DECISION = (select max(FECHA_FIN) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_REGISTRAR_TOMA_DECISION = (select FECHA_REGISTRAR_TOMA_DECISION from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 

    
	
    truncate table TEMP_PROCEDIMIENTO_TAREA;
    insert into TEMP_PROCEDIMIENTO_TAREA (ITER, FASE, TAREA, FECHA_INI, FECHA_FIN, DESCRIPCION_TAREA, TAP_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_FECHA_INI, coalesce(tar.TAR_FECHA_FIN, '0000-00-00 00:00:00'), tar.TAR_TAREA ,TAP_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
    from TEMP_PROCEDIMIENTO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where DIA_ID = fecha and date(tar.TAR_FECHA_INI) <= fecha and tev.TEV_NOMBRE IN ('fecha') and tex.tap_id in (1004, 10000000000200);
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_RECEPCION_DOC_COMPLETA = (select max(FECHA_FORMULARIO) from TEMP_PROCEDIMIENTO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha and FECHA_FIN <> '0000-00-00 00:00:00');
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_RECEPCION_DOC_COMPLETA = (select FECHA_RECEPCION_DOC_COMPLETA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 

    
    
    
    truncate table TEMP_PROCEDIMIENTO_CONTRATO;
    
    
    set max_dia_h = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.H_MOV_MOVIMIENTOS);
    set max_dia_mov = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.MOV_MOVIMIENTOS);
    set penult_dia_mov = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION < max_dia_mov);
	set max_dia_con_contratos_h = (select max(MOV_FECHA_EXTRACCION) from recovery_lindorff_datastage.H_MOV_MOVIMIENTOS where MOV_FECHA_EXTRACCION <= fecha);
	
    
    if((fecha <= max_dia_h) or ((fecha > max_dia_h) and (fecha < penult_dia_mov))) then
        begin
            
            insert into TEMP_PROCEDIMIENTO_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
            select prc.PRC_ID, h_mov.CNT_ID, cex.CEX_ID, h_mov.MOV_POS_VIVA_VENCIDA, h_mov.MOV_POS_VIVA_NO_VENCIDA, h_mov.MOV_EXTRA_1, h_mov.MOV_FECHA_POS_VENCIDA 
                from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc
                join recovery_lindorff_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                join recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                join recovery_lindorff_datastage.H_MOV_MOVIMIENTOS h_mov on cex.CNT_ID = h_mov.CNT_ID
                where MOV_FECHA_EXTRACCION = max_dia_con_contratos_h;
                
            
            insert into TEMP_PROCEDIMIENTO_CONTRATO (ITER, CONTRATO, CEX_ID, MAX_MOV_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
            select prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, max(mov.MOV_ID), mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA 
                from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc
                join recovery_lindorff_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                join recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                join recovery_lindorff_datastage.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
                where MOV_FECHA_EXTRACCION <= penult_dia_mov and MOV_FECHA_EXTRACCION <= fecha 
				group by prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA
				having count(*) >= 2;	
         end;
         
    
    elseif(fecha = penult_dia_mov or fecha = max_dia_mov) then
        begin
            
            insert into TEMP_PROCEDIMIENTO_CONTRATO (ITER, CONTRATO, CEX_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
            select prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA 
                from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc
                join recovery_lindorff_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                join recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                join recovery_lindorff_datastage.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
                where MOV_FECHA_EXTRACCION = fecha;
                
            
            insert into TEMP_PROCEDIMIENTO_CONTRATO (ITER, CONTRATO, CEX_ID, MAX_MOV_ID, SALDO_VENCIDO, SALDO_NO_VENCIDO, INGRESOS_PENDIENTES_APLICAR, FECHA_POS_VENCIDA)
            select prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, max(mov.MOV_ID), mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA 
                from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc
                join recovery_lindorff_datastage.ASU_ASUNTOS asu on prc.ASU_ID = asu.ASU_ID 
                join recovery_lindorff_datastage.CEX_CONTRATOS_EXPEDIENTE cex on asu.EXP_ID = cex.EXP_ID
                join recovery_lindorff_datastage.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
                where MOV_FECHA_EXTRACCION <= penult_dia_mov and MOV_FECHA_EXTRACCION <= fecha 
				group by prc.PRC_ID, mov.CNT_ID, cex.CEX_ID, mov.MOV_POS_VIVA_VENCIDA, mov.MOV_POS_VIVA_NO_VENCIDA, mov.MOV_EXTRA_1, mov.MOV_FECHA_POS_VENCIDA 
				having count(*) >= 2;
        end;
    end if;
    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc set GARANTIA_CONTRATO = (select DD_GC1_ID from recovery_lindorff_datastage.CNT_CONTRATOS cnt where tpc.CONTRATO = cnt.CNT_ID);
    update TEMP_PROCEDIMIENTO_CONTRATO tpc set GARANTIA_CONTRATO = (case when GARANTIA_CONTRATO in (10, 1, 2, 6, 3, 4, 8, 9, 5, 22, 7, 24, 11, 12, 13) then 1 else 0 end); 
    update TEMP_PROCEDIMIENTO_DETALLE pd set GARANTIA_CONTRATO = (select sum(GARANTIA_CONTRATO) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_DETALLE pd set GARANTIA_CONTRATO = (case when GARANTIA_CONTRATO >=1 then 1 else 0 end);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set GARANTIA_CONTRATO = (select GARANTIA_CONTRATO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
     
    update TEMP_PROCEDIMIENTO_DETALLE pd set SALDO_VENCIDO = (select sum(SALDO_VENCIDO) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_DETALLE pd set SALDO_NO_VENCIDO = (select sum(SALDO_NO_VENCIDO) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_DETALLE pd set INGRESOS_PENDIENTES_APLICAR = (select sum(INGRESOS_PENDIENTES_APLICAR) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_DETALLE pd set NUM_CONTRATOS = (select count(*) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set SALDO_VENCIDO = (select SALDO_VENCIDO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set SALDO_NO_VENCIDO = (select SALDO_NO_VENCIDO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set INGRESOS_PENDIENTES_APLICAR = (select INGRESOS_PENDIENTES_APLICAR from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set NUM_CONTRATOS = (select NUM_CONTRATOS from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set SUBTOTAL = (select INGRESOS_PENDIENTES_APLICAR from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 

	
	
	set max_dia_add_bi_h = (select max(IAB_FECHA_VALOR) from recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI_H where IAB_FECHA_VALOR <= fecha);
    set max_dia_add_bi = (select max(IAB_FECHA_VALOR) from recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI);
	
    
     
    if(fecha <= max_dia_add_bi_h) then
          update TEMP_PROCEDIMIENTO_CONTRATO tpc, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI_H extbi set tpc.RESTANTE_TOTAL = CAST(REPLACE(extbi.IAB_VALOR, ',', '.') AS DECIMAL(14,2)) where extbi.DD_IFB_ID = 5 and extbi.IAB_FECHA_VALOR = fecha and tpc.CONTRATO = extbi.IAB_ID_UNIDAD_GESTION;
    
    elseif(fecha = max_dia_add_bi) then
             update TEMP_PROCEDIMIENTO_CONTRATO tpc, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI extbi set tpc.RESTANTE_TOTAL = CAST(REPLACE(extbi.IAB_VALOR, ',', '.') AS DECIMAL(14,2)) where extbi.DD_IFB_ID = 5 and extbi.IAB_FECHA_VALOR = fecha and tpc.CONTRATO = extbi.IAB_ID_UNIDAD_GESTION;
    end if;
	update TEMP_PROCEDIMIENTO_DETALLE pd set RESTANTE_TOTAL = (select sum(RESTANTE_TOTAL) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set RESTANTE_TOTAL = (select RESTANTE_TOTAL from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
 


    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc set NUM_DIAS_VENCIDO = (datediff(fecha, FECHA_POS_VENCIDA));
    update TEMP_PROCEDIMIENTO_DETALLE pd set NUM_DIAS_VENCIDO = (select max(NUM_DIAS_VENCIDO) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set NUM_DIAS_VENCIDO = (select NUM_DIAS_VENCIDO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ULTIMA_POSICION_VENCIDA = (select min(FECHA_POS_VENCIDA) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ULTIMA_POSICION_VENCIDA = (select FECHA_ULTIMA_POSICION_VENCIDA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 

    
	
	
    
    
    
    truncate table TEMP_PROCEDIMIENTO_ESTIMACION;
    insert into TEMP_PROCEDIMIENTO_ESTIMACION (ITER, FASE, FECHA_ESTIMACION, IRG_CLAVE, IRG_VALOR)
    select tpj.ITER, tpj.FASE_ACTUAL, info.FECHACREAR, IRG_CLAVE, IRG_VALOR
    from TEMP_PROCEDIMIENTO_JERARQUIA tpj
    join recovery_lindorff_datastage.MEJ_REG_REGISTRO mej on mej.TRG_EIN_ID = tpj.FASE_ACTUAL
    join recovery_lindorff_datastage.MEJ_IRG_INFO_REGISTRO info on mej.REG_ID = info.REG_ID
    where DIA_ID =  fecha and date(info.FECHACREAR) <= fecha 
    and DD_TRG_ID = 3 and IRG_CLAVE IN ('estNew', 'estNew', 'estOld', 'plaNew', 'plaOld','pplNew', 'pplOld');
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_ULTIMA_ESTIMACION = (select date(max(FECHA_ESTIMACION)) from TEMP_PROCEDIMIENTO_ESTIMACION pe  where pd.ITER = pe.ITER and date(pe.FECHA_ESTIMACION) <= fecha );
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_ULTIMA_ESTIMACION = (select FECHA_ULTIMA_ESTIMACION from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc, TEMP_PROCEDIMIENTO_CARTERA tmpcar set tpc.CARTERA = tmpcar.CARTERA where tpc.CONTRATO = tmpcar.CONTRATO;
    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd, (select ITER from (select ITER, count(distinct CARTERA) num_carteras_distintas from TEMP_PROCEDIMIENTO_CONTRATO pc group by ITER) as aux 
                                                             where aux.num_carteras_distintas > 1) tpc set pd.CARTERA = -2
                                                             where pd.ITER = tpc.ITER;
    update TEMP_PROCEDIMIENTO_DETALLE pd set CARTERA = (select distinct pc.CARTERA from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER) where CARTERA is null;
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set CARTERA = (select CARTERA from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc, TEMP_PROCEDIMIENTO_CEDENTE tmpc set tpc.CEDENTE = tmpc.CEDENTE where tpc.CONTRATO = tmpc.CONTRATO;
    update TEMP_PROCEDIMIENTO_DETALLE pd set CEDENTE = (select distinct pc.CEDENTE from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set CEDENTE = (select CEDENTE from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha;  
    
    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc, TEMP_PROCEDIMIENTO_PROPIETARIO tmpp set tpc.PROPIETARIO = tmpp.PROPIETARIO where tpc.CONTRATO = tmpp.CONTRATO;
    update TEMP_PROCEDIMIENTO_DETALLE pd set PROPIETARIO = (select distinct pc.PROPIETARIO from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set PROPIETARIO = (select PROPIETARIO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 

    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc set tpc.SEGMENTO = (select SEGMENTO_CONTRATO_PROCEDIMIENTO_ID 
                                                               from TEMP_PROCEDIMIENTO_SEGMENTO tmpseg
                                                               join DIM_PROCEDIMIENTO_SEGMENTO_CONTRATO dims on  tmpseg.SEGMENTO = dims.SEGMENTO_CONTRATO_PROCEDIMIENTO_DESC
                                                               where  tpc.CONTRATO = tmpseg.CONTRATO);            
    update TEMP_PROCEDIMIENTO_DETALLE pd set SEGMENTO = (select distinct pc.SEGMENTO from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set SEGMENTO = (select SEGMENTO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc set tpc.SOCIO = (select SOCIO_CONTRATO_PROCEDIMIENTO_ID 
                                                            from TEMP_PROCEDIMIENTO_SOCIO tmpsoc
                                                            join DIM_PROCEDIMIENTO_SOCIO_CONTRATO dims on  tmpsoc.SOCIO = dims.SOCIO_CONTRATO_PROCEDIMIENTO_DESC
                                                            where  tpc.CONTRATO = tmpsoc.CONTRATO);                                                         
    update TEMP_PROCEDIMIENTO_DETALLE pd set SOCIO = (select distinct pc.SOCIO from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set SOCIO = (select SOCIO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    
    


truncate table TEMP_PROCEDIMIENTO_SEGMENTO;
insert into TEMP_PROCEDIMIENTO_SEGMENTO (CONTRATO, SEGMENTO)
select CNT_ID, IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 42;




truncate table TEMP_PROCEDIMIENTO_SOCIO;
insert into TEMP_PROCEDIMIENTO_SOCIO (CONTRATO, SOCIO)
select CNT_ID, IAC_VALUE from recovery_lindorff_datastage.EXT_IAC_INFO_ADD_CONTRATO where DD_IFC_ID = 43;


    
    update TEMP_PROCEDIMIENTO_CONTRATO tpc set FECHA_CONTABLE_LITIGIO = (select FECHA_CONTABLE_LITIGIO from TEMP_PROCEDIMIENTO_FECHA_CONTABLE_LITIGIO pc where tpc.CONTRATO = pc.CONTRATO);
    update TEMP_PROCEDIMIENTO_DETALLE pd set FECHA_CONTABLE_LITIGIO = (select min(FECHA_CONTABLE_LITIGIO) from TEMP_PROCEDIMIENTO_CONTRATO pc where pc.ITER = pd.ITER);
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set FECHA_CONTABLE_LITIGIO = (select FECHA_CONTABLE_LITIGIO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    update TEMP_PROCEDIMIENTO_DETALLE pd set TITULAR_PROCEDIMIENTO = (select (TITULAR_PROCEDIMIENTO) from TEMP_PROCEDIMIENTO_TITULAR pc where pc.PROCEDIMIENTO = pd.FASE_ACTUAL);
    update TEMP_PROCEDIMIENTO_DETALLE pd set TITULAR_PROCEDIMIENTO = -1 where TITULAR_PROCEDIMIENTO is null; 
    update TEMP_PROCEDIMIENTO_JERARQUIA pj set TITULAR_PROCEDIMIENTO = (select TITULAR_PROCEDIMIENTO from TEMP_PROCEDIMIENTO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    
    
    
    truncate table TEMP_PROCEDIMIENTO_USUARIOS;
    insert into TEMP_PROCEDIMIENTO_USUARIOS (PROCEDIMIENTO_ID, PROCURADOR, FECHA_DESDE) 
    select prc.PRC_ID, usu.USU_ID, gah.GAH_FECHA_DESDE from recovery_lindorff_datastage.USD_USUARIOS_DESPACHOS usd 
                join recovery_lindorff_datastage.USU_USUARIOS usu on usd.USU_ID = usu.USU_ID     
                join recovery_lindorff_datastage.GAH_GESTOR_ADICIONAL_HISTORICO gah on gah.GAH_GESTOR_ID = usd.USD_ID
                join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges on gah.GAH_TIPO_GESTOR_ID = tges.DD_TGE_ID
                join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on gah.GAH_ASU_ID = prc.ASU_ID
                where tges.DD_TGE_DESCRIPCION = 'Procurador' and gah.GAH_FECHA_DESDE <= fecha;
    
    truncate table TEMP_PROCEDIMIENTO_USUARIOS_AUX;
    insert into TEMP_PROCEDIMIENTO_USUARIOS_AUX(PROCEDIMIENTO_ID, MAX_FECHA)
    select PROCEDIMIENTO_ID, max(FECHA_DESDE) from TEMP_PROCEDIMIENTO_USUARIOS group by PROCEDIMIENTO_ID;
    
    update TEMP_PROCEDIMIENTO_USUARIOS usu, TEMP_PROCEDIMIENTO_USUARIOS_AUX aux set usu.FECHA_VALIDA = MAX_FECHA where aux.PROCEDIMIENTO_ID = usu.PROCEDIMIENTO_ID;

    
    
    
    truncate table TEMP_PROCEDIMIENTO_RESOLUCIONES;
    
    insert into TEMP_PROCEDIMIENTO_RESOLUCIONES (PROCEDIMIENTO_ID, BPM_IPT_ID, FECHA_RESOLUCION, FECHA_CREAR_INPUT, USUARIO_CREAR, TIPO_RESOLUCION_ID)
    select ipt.prc_id,
           ipt.BPM_IPT_ID,
           case when dip.BPM_DIP_VALOR is null then date(ipt.FECHACREAR)
                else date_format(str_to_date(dip.BPM_DIP_VALOR, '%d/%m/%Y'), '%Y-%m-%d') 
           end as BPM_DIP_VALOR,
           ipt.FECHACREAR,
           ipt.USUARIOCREAR,
           ipt.BPM_DD_TIN_ID
    from recovery_lindorff_datastage.BPM_IPT_INPUT ipt
    join recovery_lindorff_datastage.TABLA_FECHAS_NOTIFICACION tfn on tfn.BPM_DD_TIN_ID=ipt.BPM_DD_TIN_ID
    left join recovery_lindorff_datastage.BPM_DIP_DATOS_INPUT dip on dip.BPM_DIP_NOMBRE = tfn.BPM_IDT_NOMBRE and dip.BPM_IPT_ID = ipt.BPM_IPT_ID
    where ipt.BORRADO =0 and dip.BORRADO =0 and ipt.FECHACREAR <= fecha;
    
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, recovery_lindorff_datastage.USU_USUARIOS usu set res.GESTOR_RESOLUCION = coalesce(USU_ID, -1) where res.USUARIO_CREAR = usu.USU_USERNAME;
    update TEMP_PROCEDIMIENTO_RESOLUCIONES set GESTOR_RESOLUCION = -1 where GESTOR_RESOLUCION is null;

    truncate table TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX;
    insert into TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX(PROCEDIMIENTO_ID, MAX_FECHA) 
    select PROCEDIMIENTO_ID, max(FECHA_RESOLUCION) from TEMP_PROCEDIMIENTO_RESOLUCIONES group by PROCEDIMIENTO_ID;

    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX aux set res.MAX_FECHA_RESOLUCION = MAX_FECHA where aux.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID;

    
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, recovery_lindorff_datastage.BPM_DIP_DATOS_INPUT bpm set res.MOTIVO_INADMISION_RESOLUCION_ID = bpm.BPM_DIP_VALOR where res.BPM_IPT_ID = bpm.BPM_IPT_ID  and res.TIPO_RESOLUCION_ID in (90, 91) and BPM_DIP_NOMBRE = 'd_motivoInadmision';
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, recovery_lindorff_datastage.DD_MIN_MOTIVOS_INADMISION dd set res.MOTIVO_INADMISION_RESOLUCION_ID = dd.DD_MIN_ID where res.MOTIVO_INADMISION_RESOLUCION_ID = dd.DD_MIN_CODIGO and res.TIPO_RESOLUCION_ID in (90, 91);
    update TEMP_PROCEDIMIENTO_RESOLUCIONES set MOTIVO_INADMISION_RESOLUCION_ID = -2 where TIPO_RESOLUCION_ID in (90, 91) and MOTIVO_INADMISION_RESOLUCION_ID is null;
    
    truncate table TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX;
    insert into TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX(PROCEDIMIENTO_ID, MAX_FECHA) 
    select PROCEDIMIENTO_ID, max(FECHA_RESOLUCION) from TEMP_PROCEDIMIENTO_RESOLUCIONES where TIPO_RESOLUCION_ID in (90, 91) group by PROCEDIMIENTO_ID;
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX aux set res.MAX_FECHA_INADMISION = MAX_FECHA where aux.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and res.TIPO_RESOLUCION_ID in (90, 91);

    
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, recovery_lindorff_datastage.BPM_DIP_DATOS_INPUT bpm set res.MOTIVO_ARCHIVO_RESOLUCION_ID = bpm.BPM_DIP_VALOR where res.BPM_IPT_ID = bpm.BPM_IPT_ID  and res.TIPO_RESOLUCION_ID in (130, 131) and BPM_DIP_NOMBRE = 'd_motivoArchivo';
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, recovery_lindorff_datastage.DD_MAR_MOTIVOS_ARCHIVO dd set res.MOTIVO_ARCHIVO_RESOLUCION_ID = dd.DD_MAR_ID where res.MOTIVO_ARCHIVO_RESOLUCION_ID = dd.DD_MAR_CODIGO and res.TIPO_RESOLUCION_ID in (130, 131);
    update TEMP_PROCEDIMIENTO_RESOLUCIONES set MOTIVO_ARCHIVO_RESOLUCION_ID = -2 where TIPO_RESOLUCION_ID in (130, 131) and MOTIVO_ARCHIVO_RESOLUCION_ID is null;

    truncate table TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX;
    insert into TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX(PROCEDIMIENTO_ID, MAX_FECHA) 
    select PROCEDIMIENTO_ID, max(FECHA_RESOLUCION) from TEMP_PROCEDIMIENTO_RESOLUCIONES where TIPO_RESOLUCION_ID in (130, 131)group by PROCEDIMIENTO_ID;
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX aux set res.MAX_FECHA_ARCHIVO = MAX_FECHA where aux.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and res.TIPO_RESOLUCION_ID in (130, 131);

    
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, recovery_lindorff_datastage.BPM_DIP_DATOS_INPUT bpm set res.REQUERIMIENTO_PREVIO_RESOLUCION_ID = bpm.BPM_DIP_VALOR where res.BPM_IPT_ID = bpm.BPM_IPT_ID  and res.TIPO_RESOLUCION_ID in (46) and BPM_DIP_NOMBRE = 'd_tipoRequerimiento';
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, recovery_lindorff_datastage.DD_RPR_REQUERIMIENTO_PREVIO dd set res.REQUERIMIENTO_PREVIO_RESOLUCION_ID = dd.DD_RPR_ID where res.REQUERIMIENTO_PREVIO_RESOLUCION_ID = dd.DD_RPR_CODIGO and res.TIPO_RESOLUCION_ID in (46);
    update TEMP_PROCEDIMIENTO_RESOLUCIONES set REQUERIMIENTO_PREVIO_RESOLUCION_ID = -2 where TIPO_RESOLUCION_ID in (46) and REQUERIMIENTO_PREVIO_RESOLUCION_ID is null;

    truncate table TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX;
    insert into TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX(PROCEDIMIENTO_ID, MAX_FECHA) 
    select PROCEDIMIENTO_ID, max(FECHA_RESOLUCION) from TEMP_PROCEDIMIENTO_RESOLUCIONES where TIPO_RESOLUCION_ID in (46) group by PROCEDIMIENTO_ID;
    update TEMP_PROCEDIMIENTO_RESOLUCIONES res, TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX aux set res.MAX_FECHA_REQUERIMIENTO_PREVIO = MAX_FECHA where aux.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and res.TIPO_RESOLUCION_ID in (46);
  
  /***** EN PRUEBAS. INICIO DE: Fechas de interposición  y procurador de monitorio, etj, etnj, ordinario y verbal *****/



truncate recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION;
insert into recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION (ITER,FASE_ACTUAL,FECHA_INTERPOSICION,CODIGO_FASE_ACTUAL,ASU_ID)
select  tpj.ITER,
tpj.FASE_ACTUAL,
STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') AS FECHA_INTERPOSICION,
tpj.CODIGO_FASE_ACTUAL,
tpj.ASU_ID
from recovery_lindorff_dwh.TEMP_PROCEDIMIENTO_JERARQUIA tpj
join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva 
on tpj.FASE_ACTUAL = gva.PRC_ID 
where CODIGO_FASE_ACTUAL in('P70','P72','P76','P79','P80') and DIA_ID =fecha and date(gva.FECHACREAR) <=fecha
and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecPresentacionDemanda';

		
update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION fid
        left join
    recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc ON fid.FASE_ACTUAL = prc.PRC_ID 
set 
    fid.FECHACREAR = prc.FECHACREAR;


truncate table recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX;
INSERT INTO recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX(ITER,ASU_ID)
SELECT distinct ITER, ASU_ID FROM recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION;


		
update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION b ON a.iter = b.iter 
set 
    a.FECHA_INTERPOSICION_MONITORIO = b.FECHA_INTERPOSICION
where
    b.CODIGO_FASE_ACTUAL = 'P70';


update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION b ON a.iter = b.iter 
set 
    a.FECHA_INTERPOSICION_ETJ = b.FECHA_INTERPOSICION
where
    b.CODIGO_FASE_ACTUAL = 'P72';


update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION b ON a.iter = b.iter 
set 
    a.FECHA_INTERPOSICION_ETNJ = b.FECHA_INTERPOSICION
where
    b.CODIGO_FASE_ACTUAL = 'P76';


update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION b ON a.iter = b.iter 
set 
    a.FECHA_INTERPOSICION_ORDINARIO = b.FECHA_INTERPOSICION
where
    b.CODIGO_FASE_ACTUAL = 'P79';

update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION b ON a.iter = b.iter 
set 
    a.FECHA_INTERPOSICION_VERBAL = b.FECHA_INTERPOSICION
where
    b.CODIGO_FASE_ACTUAL = 'P80';

update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX
set PROCURADOR_MONITORIO=0,PROCURADOR_ETJ=0,PROCURADOR_ETNJ=0,PROCURADOR_ORDINARIO=0,PROCURADOR_VERBAL=0;
		
truncate table recovery_lindorff_dwh.TEMP_PROCURADOR;

INSERT INTO recovery_lindorff_dwh.TEMP_PROCURADOR
(ASU_ID,ITER,PRC_ID,FECHA_PROCURADOR_DESDE,FECHA_PROCURADOR_HASTA,FECHA_CREAR_PROCEDIMIENTO,TIPO_PROCEDIMIENTO,PROCURADOR,GESTOR,FECHA_INTERPOSICION,FECHA_CREAR_INTERPOSICION)
select 
    fid.ASU_ID,fid.ITER,fid.FASE_ACTUAL, gah.GAH_FECHA_DESDE as fecha_desde,
(case 
when gah.GAH_FECHA_HASTA is not null
 then gah.GAH_FECHA_HASTA
else fecha
end) as Fecha_hasta,date_format(fid.FECHACREAR, '%Y-%m-%d') as FechaCrear, fid.CODIGO_FASE_ACTUAL as tipo_procedimiento,0,
tges.DD_TGE_DESCRIPCION,
fid.FECHA_INTERPOSICION,
(case  when date_format(fid.FECHACREAR, '%Y-%m-%d')> fid.FECHA_INTERPOSICION -- en algunos casos, por la migracion, 
then fid.FECHA_INTERPOSICION
else date_format(fid.FECHACREAR, '%Y-%m-%d')
end) as FechaCrearInterposcion
from recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION fid 
left join recovery_lindorff_datastage.GAH_GESTOR_ADICIONAL_HISTORICO gah ON gah.GAH_ASU_ID = fid.ASU_ID
left join recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges ON gah.GAH_TIPO_GESTOR_ID = tges.DD_TGE_ID
where gah.GAH_FECHA_DESDE <= fecha and tges.DD_TGE_DESCRIPCION = 'Procurador'
group by fid.FASE_ACTUAL;

		
UPDATE recovery_lindorff_dwh.TEMP_PROCURADOR tpr
        join
    recovery_lindorff_datastage.GAH_GESTOR_ADICIONAL_HISTORICO gah ON gah.GAH_ASU_ID = tpr.ASU_ID
        join
    recovery_lindorff_datastage.DD_TGE_TIPO_GESTOR tges ON gah.GAH_TIPO_GESTOR_ID = tges.DD_TGE_ID 
SET 
    tpr.PROCURADOR = 1,
    tpr.GESTOR = tges.DD_TGE_DESCRIPCION
WHERE
    tpr.FECHA_PROCURADOR_DESDE <= tpr.FECHA_CREAR_PROCEDIMIENTO
        AND tpr.FECHA_CREAR_PROCEDIMIENTO <= tpr.FECHA_PROCURADOR_HASTA
        and tges.DD_TGE_DESCRIPCION = 'Procurador';


update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_PROCURADOR tpr ON a.ITER = tpr.ITER 
set 
    a.PROCURADOR_MONITORIO = tpr.PROCURADOR
where
    tpr.TIPO_PROCEDIMIENTO = 'P70';


update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_PROCURADOR tpr ON a.ITER = tpr.ITER 
set 
    a.PROCURADOR_ETJ = tpr.PROCURADOR
where
    tpr.TIPO_PROCEDIMIENTO = 'P72';

update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_PROCURADOR tpr ON a.ITER = tpr.ITER
set 
    a.PROCURADOR_ETNJ = tpr.PROCURADOR
where
    tpr.TIPO_PROCEDIMIENTO = 'P76';

update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_PROCURADOR tpr ON a.ITER = tpr.ITER 
set 
    a.PROCURADOR_ORDINARIO = tpr.PROCURADOR
where
    tpr.TIPO_PROCEDIMIENTO = 'P79';

update recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX a
        join
    recovery_lindorff_dwh.TEMP_PROCURADOR tpr ON a.ITER = tpr.ITER 
set 
    a.PROCURADOR_VERBAL = tpr.PROCURADOR
where
    tpr.TIPO_PROCEDIMIENTO = 'P80';


/***** EN PRUEBAS. FIN DE: Fechas de interposición  y procurador de monitorio, etj, etnj, ordinario y verbal *****/


    insert into H_PROCEDIMIENTO
    (DIA_ID,    
	   FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FASE_ACTUAL,
     ULTIMA_TAREA_CREADA,
     ULTIMA_TAREA_FINALIZADA,
     ULTIMA_TAREA_ACTUALIZADA,
     ULTIMA_TAREA_PENDIENTE,
     ULTIMA_TAREA_PENDIENTE_FA,
     FECHA_CONTABLE_LITIGIO,
     FECHA_ULTIMA_TAREA_CREADA,
     FECHA_ULTIMA_TAREA_FINALIZADA, 
     FECHA_ULTIMA_TAREA_ACTUALIZADA,  
     FECHA_ULTIMA_TAREA_PENDIENTE,
     FECHA_ULTIMA_TAREA_PENDIENTE_FA,
     FECHA_ACEPTACION,
     FECHA_RECOGIDA_DOC_Y_ACEPTACION,
     FECHA_REGISTRAR_TOMA_DECISION,
     FECHA_RECEPCION_DOC_COMPLETA,
     FECHA_INTERPOSICION_DEMANDA,
     FECHA_ULTIMA_POSICION_VENCIDA,
     FECHA_ULTIMA_ESTIMACION,
     ASUNTO_ID,                                
     FASE_MAX_PRIORIDAD, 
     CONTEXTO_FASE,
     NIVEL,
     ESTADO_PROCEDIMIENTO_ID,               
     CONTRATO_GARANTIA_REAL_ASOCIADO_ID,
     CARTERA_PROCEDIMIENTO_ID,
     CEDENTE_CONTRATO_PROCEDIMIENTO_ID,
     PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID,
     SEGMENTO_CONTRATO_PROCEDIMIENTO_ID,
     SOCIO_CONTRATO_PROCEDIMIENTO_ID,
     TITULAR_PROCEDIMIENTO_ID,
     REFERENCIA_ASUNTO,
     PROCEDIMIENTO_CON_COBRO_ID,
     PROCEDIMIENTO_CON_PROCURADOR_ID,
     PROCEDIMIENTO_CON_RESOLUCION_ID,
     PROCEDIMIENTO_CON_IMPULSO_ID,
	 PROCURADOR_MONITORIO_ID,
	 PROCURADOR_ETJ_ID,
	 PROCURADOR_ETNJ_ID,
	 PROCURADOR_ORDINARIO_ID,
	 PROCURADOR_VERBAL_ID,
     NUM_PROCEDIMIENTOS,
     NUM_FASES,
     NUM_DIAS_DESDE_ULT_ACTUALIZACION,
     NUM_MAX_DIAS_CONTRATO_VENCIDO,
     NUM_CONTRATOS,
     SALDO_ACTUAL_VENCIDO,            
     SALDO_ACTUAL_NO_VENCIDO,
     SALDO_CONCURSOS_VENCIDO,
     SALDO_CONCURSOS_NO_VENCIDO,
     INGRESOS_PENDIENTES_APLICAR,
     RESTANTE_TOTAL,
     DURACION_ULT_TAREA_PENDIENTE            
    )
    select fecha,      						 
     fecha,  								        
     ITER,   
     FASE_ACTUAL,
     ULTIMA_TAREA_CREADA,
     ULTIMA_TAREA_FINALIZADA,
     ULTIMA_TAREA_ACTUALIZADA,
     ULTIMA_TAREA_PENDIENTE,
     ULTIMA_TAREA_PENDIENTE_FA,
     FECHA_CONTABLE_LITIGIO,
     FECHA_ULTIMA_TAREA_CREADA,
     FECHA_ULTIMA_TAREA_FINALIZADA, 
     FECHA_ULTIMA_TAREA_ACTUALIZADA,
     FECHA_ULTIMA_TAREA_PENDIENTE,
     FECHA_ULTIMA_TAREA_PENDIENTE_FA,
     FECHA_ACEPTACION,
     FECHA_RECOGIDA_DOC_Y_ACEPTACION,
     FECHA_REGISTRAR_TOMA_DECISION,
     FECHA_RECEPCION_DOC_COMPLETA,
     FECHA_INTERPOSICION_DEMANDA,
     FECHA_ULTIMA_POSICION_VENCIDA,
     FECHA_ULTIMA_ESTIMACION,
     ASU_ID,
     FASE_MAX_PRIORIDAD,
     CONTEXTO,
     NIVEL, 
     CANCELADO_PROCEDIMIENTO,
     GARANTIA_CONTRATO,
     coalesce(CARTERA, -1),
     coalesce(CEDENTE, -1),
     coalesce(PROPIETARIO, -1),
     coalesce(SEGMENTO, -1),
     coalesce(SOCIO, -1),
     TITULAR_PROCEDIMIENTO,
     coalesce(REFERENCIA_ASUNTO, 'Desconocido') ,
     0,
     0,
     0,
     0,
	 0,
	 0,
	 0,
	 0,
	 0,
     1,
     NUM_FASES,
     datediff(fecha, FECHA_ULTIMA_TAREA_ACTUALIZADA),
     NUM_DIAS_VENCIDO,
     NUM_CONTRATOS,
     SALDO_VENCIDO,         
     SALDO_NO_VENCIDO,
     SALDO_CONCURSOS_VENCIDO,
     SALDO_CONCURSOS_NO_VENCIDO,
     INGRESOS_PENDIENTES_APLICAR,
     RESTANTE_TOTAL,
     datediff(fecha, FECHA_ULTIMA_TAREA_PENDIENTE)
    from TEMP_PROCEDIMIENTO_JERARQUIA where DIA_ID = fecha and FASE_ACTUAL = ULTIMA_FASE;

    
    
	
    
    update H_PROCEDIMIENTO h, recovery_lindorff_datastage.ASU_ASUNTOS asu set h.FECHA_CREACION_ASUNTO = date(asu.FECHACREAR) where h.ASUNTO_ID = asu.ASU_ID and DIA_ID = fecha;
	
    
    insert into H_PROCEDIMIENTO_DETALLE_COBRO 
    (DIA_ID,   
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,   
     ASUNTO_ID,
     CONTRATO_ID,
     FECHA_COBRO,
     FECHA_ASUNTO,
     TIPO_COBRO_DETALLE_ID,
     NUM_COBROS,
     IMPORTE_COBRO,
     NUM_DIAS_CREACION_ASUNTO_A_COBRO)
    select DIA_ID, 
     DIA_ID,
     PROCEDIMIENTO_ID, 
     ASUNTO_ID,
     pcnt.CONTRATO,  
     FECHA_COBRO, 
     FECHA_CREACION_ASUNTO,
     TIPO_COBRO_DETALLE_ID, 
     1, 
     IMPORTE,
     datediff(FECHA_COBRO, FECHA_CREACION_ASUNTO) 
    from TEMP_PROCEDIMIENTO_CONTRATO pcnt
    join TEMP_PROCEDIMIENTO_COBROS pcob on pcnt.CONTRATO = pcob.CONTRATO and pcob.contrato is not null
    join H_PROCEDIMIENTO h on h.PROCEDIMIENTO_ID = pcnt.ITER 
    where DIA_ID = fecha and FECHA_COBRO <= fecha;
    
    
    
    insert into H_PROCEDIMIENTO_DETALLE_CONTRATO
    (DIA_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     CONTRATO_ID,
     NUM_CONTRATOS_PROCEDIMIENTO)
    select fecha, 
     fecha,
     pd.ITER, 
     prc.ASU_ID, 
     pc.CONTRATO, 
     1 
     from TEMP_PROCEDIMIENTO_DETALLE pd
     join TEMP_PROCEDIMIENTO_CONTRATO pc on  pc.ITER = pd.ITER
     join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on pc.ITER = prc.PRC_ID;
    
    
    
    insert into H_PROCEDIMIENTO_DETALLE_RESOLUCION
    (DIA_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     GESTOR_RESOLUCION_ID,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     NUM_RESOLUCIONES,
	 RESOLUCION_ID)
    select fecha,
     fecha,
     tpj.ITER,
     ASU_ID,
     GESTOR_RESOLUCION,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     1,
	 tr.BPM_IPT_ID
    from TEMP_PROCEDIMIENTO_RESOLUCIONES tr
    join TEMP_PROCEDIMIENTO_JERARQUIA tpj on tr.PROCEDIMIENTO_ID = tpj.FASE_ACTUAL
    where DIA_ID = fecha;
    
 truncate table TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX2;

 insert into recovery_lindorff_dwh.TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX2(PROCEDIMIENTO_ID, MAX_FECHA_RESOLUCION) 
    select PROCEDIMIENTO_ID, max(FECHA_RESOLUCION) from recovery_lindorff_dwh.H_PROCEDIMIENTO_DETALLE_RESOLUCION 
where DIA_ID=fecha group by PROCEDIMIENTO_ID;



UPDATE recovery_lindorff_dwh.TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX2 a
set MAX_RESOLUCION_ID =
(select max(b.RESOLUCION_ID) from recovery_lindorff_dwh.H_PROCEDIMIENTO_DETALLE_RESOLUCION  b
 where a.PROCEDIMIENTO_ID=b.PROCEDIMIENTO_ID and b.FECHA_RESOLUCION=a.MAX_FECHA_RESOLUCION 
and DIA_ID=fecha group by PROCEDIMIENTO_ID);



UPDATE recovery_lindorff_dwh.TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX2 a
set TIPO_RESOLUCION_ID =
(select b.TIPO_RESOLUCION_ID from recovery_lindorff_dwh.TEMP_PROCEDIMIENTO_RESOLUCIONES  b
 where a.MAX_RESOLUCION_ID= b.BPM_IPT_ID AND b.FECHA_RESOLUCION=a.MAX_FECHA_RESOLUCION );






if(fecha <= max_dia_add_bi_h) then
	begin
		update H_PROCEDIMIENTO h, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI_H extbi set h.ESTADO_ASUNTO_ID = extbi.IAB_VALOR where extbi.DD_IFB_ID = 1 and extbi.IAB_FECHA_VALOR = fecha and h.ASUNTO_ID = extbi.IAB_ID_UNIDAD_GESTION and DIA_ID = fecha;
		update H_PROCEDIMIENTO h, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI_H extbi set h.NUMERO_AUTO = coalesce(extbi.IAB_VALOR, 'Desconocido') where extbi.DD_IFB_ID = 3 and extbi.IAB_FECHA_VALOR = fecha and h.FASE_ACTUAL = extbi.IAB_ID_UNIDAD_GESTION and DIA_ID = fecha;
		update H_PROCEDIMIENTO h, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI_H extbi set h.SALDO_RECUPERACION = CAST(REPLACE(extbi.IAB_VALOR, ',', '.') AS DECIMAL(14,2)) where extbi.DD_IFB_ID = 4 and extbi.IAB_FECHA_VALOR = fecha and h.FASE_MAX_PRIORIDAD = extbi.IAB_ID_UNIDAD_GESTION and DIA_ID = fecha;
	end;

elseif(fecha = max_dia_add_bi) then
	begin
		update H_PROCEDIMIENTO h, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI extbi set h.ESTADO_ASUNTO_ID = extbi.IAB_VALOR where extbi.DD_IFB_ID = 1 and extbi.IAB_FECHA_VALOR = fecha and h.ASUNTO_ID = extbi.IAB_ID_UNIDAD_GESTION and DIA_ID = fecha;
		update H_PROCEDIMIENTO h, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI extbi set h.NUMERO_AUTO = coalesce(extbi.IAB_VALOR, 'Desconocido') where extbi.DD_IFB_ID = 3 and extbi.IAB_FECHA_VALOR = fecha and h.FASE_ACTUAL = extbi.IAB_ID_UNIDAD_GESTION and DIA_ID = fecha;
		update H_PROCEDIMIENTO h, recovery_lindorff_datastage.EXT_IAB_INFO_ADD_BI extbi set h.SALDO_RECUPERACION = CAST(REPLACE(extbi.IAB_VALOR, ',', '.') AS DECIMAL(14,2)) where extbi.DD_IFB_ID = 4 and extbi.IAB_FECHA_VALOR = fecha and h.FASE_MAX_PRIORIDAD = extbi.IAB_ID_UNIDAD_GESTION and DIA_ID = fecha;
	end;
end if;

update H_PROCEDIMIENTO h, DIM_ASUNTO_ESTADO est set h.ESTADO_ASUNTO_AGRUPADO_ID = est.ESTADO_ASUNTO_AGRUPADO_ID where h.ESTADO_ASUNTO_ID = est.ESTADO_ASUNTO_ID and DIA_ID = fecha;


update H_PROCEDIMIENTO set PORCENTAJE_RECUPERACION = (select PRC_PORCENTAJE_RECUPERACION from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;
update H_PROCEDIMIENTO set PLAZO_RECUPERACION = (select PRC_PLAZO_RECUPERACION from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;

update H_PROCEDIMIENTO set ESTIMACIÓN_RECUPERACION = (SALDO_RECUPERACION * (PORCENTAJE_RECUPERACION/100)) where DIA_ID = fecha;

update H_PROCEDIMIENTO set SALDO_ORIGINAL_VENCIDO = (select PRC_SALDO_ORIGINAL_VENCIDO from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;
update H_PROCEDIMIENTO set SALDO_ORIGINAL_NO_VENCIDO = (select PRC_SALDO_ORIGINAL_NO_VENCIDO from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;
	
	

update H_PROCEDIMIENTO set SALDO_ACTUAL_TOTAL = SALDO_ACTUAL_VENCIDO + SALDO_ACTUAL_NO_VENCIDO where DIA_ID = fecha;
update H_PROCEDIMIENTO set SALDO_CONCURSOS_TOTAL = SALDO_CONCURSOS_VENCIDO + SALDO_CONCURSOS_NO_VENCIDO where DIA_ID = fecha;
 
  

update H_PROCEDIMIENTO set TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID = (case when SALDO_ACTUAL_TOTAL < 1000000 then 0
                                                                 else 1 end) where DIA_ID = fecha;                                                        


update H_PROCEDIMIENTO set TRAMO_SALDO_TOTAL_CONCURSO_ID = (case when SALDO_CONCURSOS_TOTAL < 1000000 then 0
                                                                 when SALDO_CONCURSOS_TOTAL >= 1000000 then 1
                                                                 else -2 end) where DIA_ID = fecha;
                                                                 
update H_PROCEDIMIENTO set TRAMO_DIAS_CONTRATO_VENCIDO_ID = (case when NUM_MAX_DIAS_CONTRATO_VENCIDO <=30 then 0
                                                                  when NUM_MAX_DIAS_CONTRATO_VENCIDO >30 and NUM_MAX_DIAS_CONTRATO_VENCIDO <= 60 then 1
                                                                  when NUM_MAX_DIAS_CONTRATO_VENCIDO >60 and NUM_MAX_DIAS_CONTRATO_VENCIDO <= 90 then 2
                                                                  when NUM_MAX_DIAS_CONTRATO_VENCIDO >60 and NUM_MAX_DIAS_CONTRATO_VENCIDO > 90 then 3
                                                                  else -2 end) where DIA_ID = fecha;  


update H_PROCEDIMIENTO set FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA = (select (TAR_FECHA_VENC_REAL) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_FINALIZADA) where DIA_ID = fecha;
update H_PROCEDIMIENTO set FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA = (select (TAR_FECHA_VENC) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_FINALIZADA) where DIA_ID = fecha;




update H_PROCEDIMIENTO set NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA = (datediff(FECHA_ULTIMA_TAREA_FINALIZADA, FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA)) where DIA_ID = fecha;                               
update H_PROCEDIMIENTO set NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA = (datediff(FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA, FECHA_ULTIMA_TAREA_FINALIZADA)) where DIA_ID = fecha;                      
update H_PROCEDIMIENTO set NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA = (datediff(FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA, FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA)) where DIA_ID = fecha;          


update H_PROCEDIMIENTO set CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID = (case when NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA >= 0 then 0
                                                                           when NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA < 0 then 1
                                                                           when NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA is null and FECHA_ULTIMA_TAREA_FINALIZADA is not null then -1
                                                                           else -2 end) where DIA_ID = fecha; 



update H_PROCEDIMIENTO set FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE = (select (TAR_FECHA_VENC_REAL) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_PENDIENTE) where DIA_ID = fecha;
update H_PROCEDIMIENTO set FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE = (select (TAR_FECHA_VENC) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_PENDIENTE) where DIA_ID = fecha;
update H_PROCEDIMIENTO set NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE = (datediff(DIA_ID, FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE)) where DIA_ID = fecha;                                                     
update H_PROCEDIMIENTO set NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE = (datediff(FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE, DIA_ID)) where DIA_ID = fecha;                                            
update H_PROCEDIMIENTO set NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE = (datediff(FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE, FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE)) where DIA_ID = fecha;          


update H_PROCEDIMIENTO set CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID = (case when NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE >= 0 then 0
                                                                          when NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE < 0 then 1
                                                                          when NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE is null and ULTIMA_TAREA_PENDIENTE is not null then -1
                                                                          else -2 end) where DIA_ID = fecha; 





update H_PROCEDIMIENTO set FASE_ANTERIOR = (select PRC_PRC_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ESTADO_FASE_ACTUAL_ID = (select DD_EPR_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ESTADO_FASE_ANTERIOR_ID = (select DD_EPR_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) where DIA_ID = fecha;
update H_PROCEDIMIENTO set TIPO_PROCEDIMIENTO_DETALLE_ID = (select DD_TPO_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_MAX_PRIORIDAD) where DIA_ID = fecha;
update H_PROCEDIMIENTO set FASE_ACTUAL_DETALLE_ID = (select DD_TPO_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;
update H_PROCEDIMIENTO set FASE_ANTERIOR_DETALLE_ID = (select DD_TPO_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID = (select (DD_STA_ID) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_CREADA) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID = (select DD_STA_ID from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_FINALIZADA) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID = (select (DD_STA_ID) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_ACTUALIZADA) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID = (select (DD_STA_ID) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_PENDIENTE) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID = (select (DD_STA_ID) from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES where TAR_ID = ULTIMA_TAREA_PENDIENTE_FA) where DIA_ID = fecha;

update H_PROCEDIMIENTO set ULTIMA_TAREA_CREADA_DESCRIPCION_ID = (select td.ULTIMA_TAREA_CREADA_DESCRIPCION_ID from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                                                                join DIM_PROCEDIMIENTO_ULTIMA_TAREA_CREADA_DESCRIPCION td on tn.TAR_TAREA = td.ULTIMA_TAREA_CREADA_DESCRIPCION_DESC 
                                                                                                where TAR_ID = ULTIMA_TAREA_CREADA) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID = (select td.ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                                                                join DIM_PROCEDIMIENTO_ULTIMA_TAREA_FINALIZADA_DESCRIPCION td on tn.TAR_TAREA = td.ULTIMA_TAREA_FINALIZADA_DESCRIPCION_DESC 
                                                                                                where TAR_ID = ULTIMA_TAREA_FINALIZADA) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID = (select td.ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                                                                join DIM_PROCEDIMIENTO_ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION td on tn.TAR_TAREA = td.ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_DESC 
                                                                                                where TAR_ID = ULTIMA_TAREA_ACTUALIZADA) where DIA_ID = fecha;
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID = (select td.ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                                                                join DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_DESCRIPCION td on tn.TAR_TAREA = td.ULTIMA_TAREA_PENDIENTE_DESCRIPCION_DESC 
                                                                                                where TAR_ID = ULTIMA_TAREA_PENDIENTE) where DIA_ID = fecha;        
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID = (select td.ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tn
                                                                                                join DIM_PROCEDIMIENTO_ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION td on tn.TAR_TAREA = td.ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_DESC 
                                                                                                where TAR_ID = ULTIMA_TAREA_PENDIENTE_FA) where DIA_ID = fecha;  

update H_PROCEDIMIENTO set ESTADO_FASE_ANTERIOR_ID = -2 where DIA_ID = fecha and ESTADO_FASE_ANTERIOR_ID is null;
update H_PROCEDIMIENTO set FASE_ANTERIOR_DETALLE_ID =  -2 where DIA_ID = fecha and FASE_ANTERIOR_DETALLE_ID is null;


update H_PROCEDIMIENTO set ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_CREADA_DESCRIPCION_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_CREADA_DESCRIPCION_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID is null;
update H_PROCEDIMIENTO set ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID = -2 where DIA_ID = fecha and ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID is null;



update H_PROCEDIMIENTO set FECHA_CREACION_PROCEDIMIENTO = (select FECHACREAR from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = PROCEDIMIENTO_ID) where DIA_ID = fecha;
update H_PROCEDIMIENTO set FECHA_CREACION_FASE_MAX_PRIORIDAD = (select FECHACREAR from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_MAX_PRIORIDAD) where DIA_ID = fecha;
update H_PROCEDIMIENTO set FECHA_CREACION_FASE_ANTERIOR = (select FECHACREAR from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ANTERIOR) where DIA_ID = fecha;
update H_PROCEDIMIENTO set FECHA_CREACION_FASE_ACTUAL = (select FECHACREAR from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;


update H_PROCEDIMIENTO set NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO = (datediff(FECHA_ULTIMA_POSICION_VENCIDA, FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;

update H_PROCEDIMIENTO set TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID = (case when NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO > 0 and NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO <= 30 then 0 
                                                                                           when NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO > 30 and NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO <= 60 then 1
                                                                                           when NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO > 60 and NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO <= 90 then 2
                                                                                           when NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO > 90 and NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO <= 120 then 3
                                                                                           when NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO > 120 and NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO <= 150 then 4
                                                                                           when NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO > 150 and NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO <= 180 then 5
                                                                                           when NUM_MAX_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO > 180 then 6
                                                                                           else -2 end) where DIA_ID = fecha; 


update H_PROCEDIMIENTO set NUM_DIAS_DESDE_ULT_ACTUALIZACION = (select datediff(DIA_ID, FECHA_CREACION_FASE_ACTUAL)) where DIA_ID = fecha and NUM_DIAS_DESDE_ULT_ACTUALIZACION is null;                                                         

update H_PROCEDIMIENTO set TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = (case when NUM_DIAS_DESDE_ULT_ACTUALIZACION <=30 then 0
                                                                                    when NUM_DIAS_DESDE_ULT_ACTUALIZACION >30 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 60 then 1
                                                                                    when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 90 then 2
                                                                                    when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION > 90 then 3
                                                                                    else -1 end) where DIA_ID = fecha;     


update H_PROCEDIMIENTO set PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA = (datediff(FECHA_INTERPOSICION_DEMANDA, FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;     
update H_PROCEDIMIENTO set PLAZO_CREACION_ASUNTO_A_ACEPTACION = (datediff(FECHA_ACEPTACION, FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;         
update H_PROCEDIMIENTO set PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA = (datediff(FECHA_INTERPOSICION_DEMANDA, FECHA_ACEPTACION)) where DIA_ID = fecha;     

update H_PROCEDIMIENTO set TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = (case when PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA > 0 and PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA <= 10 then 0 
                                                                                         when PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA > 10 and PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA <= 20 then 1
                                                                                         When PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA > 20 and PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA <= 30 then 2
                                                                                         when PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA > 30 then 3
                                                                                         else -1 end) where DIA_ID = fecha; 
                                                                                         
update H_PROCEDIMIENTO set TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID = (case when PLAZO_CREACION_ASUNTO_A_ACEPTACION > 0 and PLAZO_CREACION_ASUNTO_A_ACEPTACION <= 5 then 0 
                                                                              when PLAZO_CREACION_ASUNTO_A_ACEPTACION > 5 and PLAZO_CREACION_ASUNTO_A_ACEPTACION <= 10 then 1
                                                                              when PLAZO_CREACION_ASUNTO_A_ACEPTACION > 10 and PLAZO_CREACION_ASUNTO_A_ACEPTACION <= 20 then 2
                                                                              when PLAZO_CREACION_ASUNTO_A_ACEPTACION > 20 then 3
                                                                              else -1 end) where DIA_ID = fecha; 
                                                                              
update H_PROCEDIMIENTO set TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID = (case when PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA > 0 and PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA <= 5 then 0 
                                                                                           when PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA > 5 and PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA <= 10 then 1
                                                                                           when PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA > 10 and PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA <= 20 then 2
                                                                                           when PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA > 20 then 3
                                                                                           else -1 end) where DIA_ID = fecha; 

update H_PROCEDIMIENTO set PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION = (datediff(FECHA_RECOGIDA_DOC_Y_ACEPTACION, FECHA_CREACION_ASUNTO)) where DIA_ID = fecha;  
update H_PROCEDIMIENTO set PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION = (datediff(FECHA_REGISTRAR_TOMA_DECISION, FECHA_RECOGIDA_DOC_Y_ACEPTACION)) where DIA_ID = fecha;  
update H_PROCEDIMIENTO set PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA = (datediff(FECHA_RECEPCION_DOC_COMPLETA, FECHA_RECOGIDA_DOC_Y_ACEPTACION)) where DIA_ID = fecha;  


update H_PROCEDIMIENTO set TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID = (case when PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION > 0 and PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION <= 5 then 0 
                                                                                        when PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION > 5 and PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION <= 10 then 1
                                                                                        when PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION > 10 and PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION <= 20 then 2
                                                                                        when PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION > 20 then 3
                                                                                        else -1 end) where DIA_ID = fecha; 

update H_PROCEDIMIENTO set TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID = (case when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION > 0 and PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION <= 5 then 0 
                                                                                                when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION > 5 and PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION <= 10 then 1
                                                                                                when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION > 10 and PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION <= 20 then 2
                                                                                                when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION > 20 then 3
                                                                                                else -1 end) where DIA_ID = fecha; 

update H_PROCEDIMIENTO set TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID = (case when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA > 0 and PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA <= 5 then 0 
                                                                                               when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA > 5 and PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA <= 10 then 1
                                                                                               when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA > 10 and PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA <= 20 then 2
                                                                                               when PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA > 20 then 3
                                                                                               else -1 end) where DIA_ID = fecha; 


update H_PROCEDIMIENTO set FECHA_ULTIMA_ESTIMACION = (FECHA_CREACION_PROCEDIMIENTO) where DIA_ID = fecha and FECHA_ULTIMA_ESTIMACION is null;
update H_PROCEDIMIENTO set FECHA_ESTIMADA_COBRO = (date_add(FECHA_ULTIMA_ESTIMACION, INTERVAL PLAZO_RECUPERACION MONTH)) where DIA_ID = fecha;

update H_PROCEDIMIENTO h set h.FECHA_ULTIMO_COBRO = (select max(cobro.FECHA_COBRO) from H_PROCEDIMIENTO_DETALLE_COBRO cobro where h.DIA_ID = fecha and cobro.DIA_ID = fecha and h.PROCEDIMIENTO_ID = cobro.PROCEDIMIENTO_ID) where h.DIA_ID = fecha;


update H_PROCEDIMIENTO set NUM_DIAS_DESDE_ULTIMA_ESTIMACION = (select datediff(DIA_ID, FECHA_ULTIMA_ESTIMACION)) where DIA_ID = fecha;


update H_PROCEDIMIENTO set ACTUALIZACION_ESTIMACIONES_ID = (case when timestampdiff(MONTH, FECHA_ULTIMA_ESTIMACION, DIA_ID) >= 6 then 0
                                                                 when timestampdiff(MONTH, FECHA_ULTIMA_ESTIMACION, DIA_ID) < 6 and timestampdiff(MONTH, FECHA_ULTIMA_ESTIMACION, DIA_ID) >= 0 then 1
                                                                 else -1 end) where DIA_ID = fecha;

update H_PROCEDIMIENTO h, H_PROCEDIMIENTO_DETALLE_COBRO cobro set h.PROCEDIMIENTO_CON_COBRO_ID = 1 where h.DIA_ID = fecha and h.DIA_ID = cobro.DIA_ID and h.PROCEDIMIENTO_ID = cobro.PROCEDIMIENTO_ID;


update H_PROCEDIMIENTO h, TEMP_PROCEDIMIENTO_USUARIOS usu set h.PROCURADOR_PROCEDIMIENTO_ID = coalesce(usu.PROCURADOR, -1) where h.DIA_ID = fecha and h.FASE_ACTUAL = usu.PROCEDIMIENTO_ID and FECHA_DESDE = FECHA_VALIDA;
update H_PROCEDIMIENTO set PROCURADOR_PROCEDIMIENTO_ID = -1 where DIA_ID = fecha and PROCURADOR_PROCEDIMIENTO_ID is null;

update H_PROCEDIMIENTO h set h.PROCEDIMIENTO_CON_PROCURADOR_ID = 1 where h.DIA_ID = fecha and h.PROCURADOR_PROCEDIMIENTO_ID is not null and h.PROCURADOR_PROCEDIMIENTO_ID not in(-1, 20344);




update H_PROCEDIMIENTO h, H_PROCEDIMIENTO_DETALLE_RESOLUCION res set h.PROCEDIMIENTO_CON_RESOLUCION_ID = 1 where h.DIA_ID = fecha and h.DIA_ID = res.DIA_ID and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID;
update H_PROCEDIMIENTO h, H_PROCEDIMIENTO_DETALLE_RESOLUCION res set h.PROCEDIMIENTO_CON_IMPULSO_ID = 1 where h.DIA_ID = fecha and h.DIA_ID = res.DIA_ID and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and TIPO_RESOLUCION_ID in (135, 387);

-- update H_PROCEDIMIENTO h set h.FECHA_ULTIMA_RESOLUCION = (select max(res.FECHA_RESOLUCION) from H_PROCEDIMIENTO_DETALLE_RESOLUCION res where h.DIA_ID = fecha and res.DIA_ID = fecha and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID) where DIA_ID = fecha;
update H_PROCEDIMIENTO h set h.FECHA_ULTIMO_IMPULSO = (select max(res.FECHA_RESOLUCION) from H_PROCEDIMIENTO_DETALLE_RESOLUCION res where h.DIA_ID = fecha and res.DIA_ID = fecha and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and TIPO_RESOLUCION_ID in (135, 387)) where DIA_ID = fecha;
update H_PROCEDIMIENTO h set h.FECHA_ULTIMA_INADMISION = (select max(res.FECHA_RESOLUCION) from H_PROCEDIMIENTO_DETALLE_RESOLUCION res where h.DIA_ID = fecha and res.DIA_ID = fecha and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and res.TIPO_RESOLUCION_ID in (90, 91)) where DIA_ID = fecha;
update H_PROCEDIMIENTO h set h.FECHA_ULTIMO_ARCHIVO = (select max(res.FECHA_RESOLUCION) from H_PROCEDIMIENTO_DETALLE_RESOLUCION res where h.DIA_ID = fecha and res.DIA_ID = fecha and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and res.TIPO_RESOLUCION_ID in (130, 131)) where DIA_ID = fecha;
update H_PROCEDIMIENTO h set h.FECHA_ULTIMO_REQUERIMIENTO_PREVIO = (select max(res.FECHA_RESOLUCION) from H_PROCEDIMIENTO_DETALLE_RESOLUCION res where h.DIA_ID = fecha and res.DIA_ID = fecha and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and res.TIPO_RESOLUCION_ID in (46)) where DIA_ID = fecha;

update recovery_lindorff_dwh.H_PROCEDIMIENTO h, recovery_lindorff_dwh.TEMP_PROCEDIMIENTO_RESOLUCIONES_AUX2 res set h.TIPO_ULTIMA_RESOLUCION_ID = res.TIPO_RESOLUCION_ID ,h.FECHA_ULTIMA_RESOLUCION=res.MAX_FECHA_RESOLUCION where  h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and h.DIA_ID=fecha;  
-- update H_PROCEDIMIENTO h, H_PROCEDIMIENTO_DETALLE_RESOLUCION res set h.TIPO_ULTIMA_RESOLUCION_ID = res.TIPO_RESOLUCION_ID where h.DIA_ID = fecha and res.DIA_ID = fecha and h.PROCEDIMIENTO_ID = res.PROCEDIMIENTO_ID and FECHA_RESOLUCION = FECHA_ULTIMA_RESOLUCION;
update H_PROCEDIMIENTO set TIPO_ULTIMA_RESOLUCION_ID = -2 where DIA_ID = fecha and TIPO_ULTIMA_RESOLUCION_ID is null;
update H_PROCEDIMIENTO h, TEMP_PROCEDIMIENTO_RESOLUCIONES res set h.MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID = res.MOTIVO_INADMISION_RESOLUCION_ID where h.DIA_ID = fecha and h.FASE_ACTUAL = res.PROCEDIMIENTO_ID and FECHA_RESOLUCION = MAX_FECHA_INADMISION;
update H_PROCEDIMIENTO set MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID = -3 where DIA_ID = fecha and MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID is null;
update H_PROCEDIMIENTO h, TEMP_PROCEDIMIENTO_RESOLUCIONES res set h.MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID = res.MOTIVO_ARCHIVO_RESOLUCION_ID where h.DIA_ID = fecha and h.FASE_ACTUAL = res.PROCEDIMIENTO_ID and FECHA_RESOLUCION = MAX_FECHA_ARCHIVO;
update H_PROCEDIMIENTO set MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID = -3 where DIA_ID = fecha and MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID is null;
update H_PROCEDIMIENTO h, TEMP_PROCEDIMIENTO_RESOLUCIONES res set h.REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID = res.REQUERIMIENTO_PREVIO_RESOLUCION_ID where h.DIA_ID = fecha and h.FASE_ACTUAL = res.PROCEDIMIENTO_ID and FECHA_RESOLUCION = MAX_FECHA_REQUERIMIENTO_PREVIO;
update H_PROCEDIMIENTO set REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID = -3 where DIA_ID = fecha and REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID is null;


update H_PROCEDIMIENTO set RESULTADO_ULTIMO_IMPULSO_ID = (case when FECHA_ULTIMA_RESOLUCION <= FECHA_ULTIMO_IMPULSO then 0 
                                                               when FECHA_ULTIMA_RESOLUCION > FECHA_ULTIMO_IMPULSO then 1
                                                               when FECHA_ULTIMO_IMPULSO is null then -2
                                                               else -1 end) where DIA_ID = fecha; 


update H_PROCEDIMIENTO set NUM_DIAS_DESDE_ULTIMA_RESOLUCION = (select datediff(DIA_ID, FECHA_ULTIMA_RESOLUCION)) where DIA_ID = fecha;
update H_PROCEDIMIENTO set NUM_DIAS_DESDE_ULTIMO_IMPULSO = (select datediff(DIA_ID, FECHA_ULTIMO_IMPULSO)) where DIA_ID = fecha;

update H_PROCEDIMIENTO set TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID = (case when NUM_DIAS_DESDE_ULTIMA_RESOLUCION >= 0 and NUM_DIAS_DESDE_ULTIMA_RESOLUCION <= 59 then 0 
                                                                         when NUM_DIAS_DESDE_ULTIMA_RESOLUCION >= 60 and NUM_DIAS_DESDE_ULTIMA_RESOLUCION <= 89 then 1
                                                                         when NUM_DIAS_DESDE_ULTIMA_RESOLUCION >= 90 and NUM_DIAS_DESDE_ULTIMA_RESOLUCION <= 119 then 2
                                                                         when NUM_DIAS_DESDE_ULTIMA_RESOLUCION >= 120 and NUM_DIAS_DESDE_ULTIMA_RESOLUCION <= 149 then 3
                                                                         when NUM_DIAS_DESDE_ULTIMA_RESOLUCION >= 150 and NUM_DIAS_DESDE_ULTIMA_RESOLUCION <= 270 then 4
                                                                         when NUM_DIAS_DESDE_ULTIMA_RESOLUCION > 270 then 5
                                                                         when NUM_DIAS_DESDE_ULTIMA_RESOLUCION is null then -2
                                                                         else -1 end) where DIA_ID = fecha; 
                                                                         
update H_PROCEDIMIENTO set TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID = (case when NUM_DIAS_DESDE_ULTIMO_IMPULSO >= 0 and NUM_DIAS_DESDE_ULTIMO_IMPULSO <= 59 then 0 
                                                                         when NUM_DIAS_DESDE_ULTIMO_IMPULSO >= 60 and NUM_DIAS_DESDE_ULTIMO_IMPULSO <= 89 then 1
                                                                         when NUM_DIAS_DESDE_ULTIMO_IMPULSO >= 90 and NUM_DIAS_DESDE_ULTIMO_IMPULSO <= 119 then 2
                                                                         when NUM_DIAS_DESDE_ULTIMO_IMPULSO >= 120 and NUM_DIAS_DESDE_ULTIMO_IMPULSO <= 149 then 3
                                                                         when NUM_DIAS_DESDE_ULTIMO_IMPULSO >= 150 and NUM_DIAS_DESDE_ULTIMO_IMPULSO <= 270 then 4
                                                                         when NUM_DIAS_DESDE_ULTIMO_IMPULSO > 270 then 5
                                                                         when NUM_DIAS_DESDE_ULTIMO_IMPULSO is null then -2
                                                                         else -1 end) where DIA_ID = fecha;  


update H_PROCEDIMIENTO set JUZGADO_ID = (select coalesce(DD_JUZ_ID, -1) from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_ACTUAL) where DIA_ID = fecha;



update recovery_lindorff_dwh.H_PROCEDIMIENTO a
        join
    recovery_lindorff_dwh.TEMP_FECHA_INTERPOSICION_PROCURADOR_AUX b ON a.PROCEDIMIENTO_ID = b.ITER
set 
	a.FECHA_INTERPOSICION_MONITORIO=b.FECHA_INTERPOSICION_MONITORIO,a.FECHA_INTERPOSICION_ETJ=b.FECHA_INTERPOSICION_ETJ,
	a.FECHA_INTERPOSICION_ETNJ=b.FECHA_INTERPOSICION_ETNJ,a.FECHA_INTERPOSICION_ORDINARIO=b.FECHA_INTERPOSICION_ORDINARIO,
	a.FECHA_INTERPOSICION_VERBAL=b.FECHA_INTERPOSICION_VERBAL,a.PROCURADOR_MONITORIO_ID = b.PROCURADOR_MONITORIO,
	a.PROCURADOR_ETJ_ID = b.PROCURADOR_ETJ,a.PROCURADOR_ETNJ_ID = b.PROCURADOR_ETNJ,
	a.PROCURADOR_ORDINARIO_ID = b.PROCURADOR_ORDINARIO,a.PROCURADOR_VERBAL_ID = b.PROCURADOR_VERBAL
where
    a.DIA_ID = fecha;


    
end loop read_loop;
close c_fecha;






truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_PROCEDIMIENTO where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);


set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    
    delete from H_PROCEDIMIENTO_MES where MES_ID = mes;
    delete from H_PROCEDIMIENTO_DETALLE_COBRO_MES where MES_ID = mes;
    delete from H_PROCEDIMIENTO_DETALLE_CONTRATO_MES where MES_ID = mes;
    delete from H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES where MES_ID = mes;
    
    
    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_PROCEDIMIENTO_MES
        (MES_ID,   
        FECHA_CARGA_DATOS,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULTIMA_TAREA_CREADA,
        ULTIMA_TAREA_FINALIZADA,
        ULTIMA_TAREA_ACTUALIZADA,
        ULTIMA_TAREA_PENDIENTE,
        ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIORIDAD,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULTIMA_TAREA_CREADA, 
        FECHA_ULTIMA_TAREA_FINALIZADA, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA,
        FECHA_ULTIMA_TAREA_PENDIENTE,
        FECHA_ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPTACION,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
		FECHA_INTERPOSICION_MONITORIO,
		FECHA_INTERPOSICION_ETJ,
		FECHA_INTERPOSICION_ETNJ,
		FECHA_INTERPOSICION_ORDINARIO,
		FECHA_INTERPOSICION_VERBAL,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        FECHA_ULTIMO_COBRO,
        FECHA_ULTIMA_RESOLUCION, 
        FECHA_ULTIMO_IMPULSO,
        FECHA_ULTIMA_INADMISION, 
        FECHA_ULTIMO_ARCHIVO,
        FECHA_ULTIMO_REQUERIMIENTO_PREVIO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DETALLE_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_CREADA_DESCRIPCION_ID, 
        ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID,
        ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_ASUNTO_ID,
        ESTADO_ASUNTO_AGRUPADO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID,
        TRAMO_SALDO_TOTAL_CONCURSO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,  
        TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID,
        TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID,
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, 
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID,
        CONTRATO_GARANTIA_REAL_ASOCIADO_ID,
        ACTUALIZACION_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        CEDENTE_CONTRATO_PROCEDIMIENTO_ID,
        PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID,
        SEGMENTO_CONTRATO_PROCEDIMIENTO_ID,
        SOCIO_CONTRATO_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        REFERENCIA_ASUNTO,
        PROCEDIMIENTO_CON_COBRO_ID,
        PROCURADOR_PROCEDIMIENTO_ID,
        PROCEDIMIENTO_CON_PROCURADOR_ID,
        PROCEDIMIENTO_CON_RESOLUCION_ID,
        PROCEDIMIENTO_CON_IMPULSO_ID,
        TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID,
        TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID,
        RESULTADO_ULTIMO_IMPULSO_ID,
        JUZGADO_ID,
        NUMERO_AUTO,
        TIPO_ULTIMA_RESOLUCION_ID,
        MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID ,
        MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID,
        REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID,
		PROCURADOR_MONITORIO_ID,
		PROCURADOR_ETJ_ID,
		PROCURADOR_ETNJ_ID,
		PROCURADOR_ORDINARIO_ID,
		PROCURADOR_VERBAL_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        NUM_DIAS_DESDE_ULT_ACTUALIZACION,
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        PLAZO_RECUPERACION,
        SALDO_RECUPERACION,
        ESTIMACIÓN_RECUPERACION,
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        RESTANTE_TOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA,          
        
        DURACION_ULT_TAREA_PENDIENTE,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE,          
        
        PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA,  
        PLAZO_CREACION_ASUNTO_A_ACEPTACION,   
        PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA,
        PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA,
        NUM_DIAS_DESDE_ULTIMA_ESTIMACION,
        NUM_DIAS_DESDE_ULTIMA_RESOLUCION,
        NUM_DIAS_DESDE_ULTIMO_IMPULSO
        )
    select mes, 
        max_dia_mes,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULTIMA_TAREA_CREADA,
        ULTIMA_TAREA_FINALIZADA,
        ULTIMA_TAREA_ACTUALIZADA,
        ULTIMA_TAREA_PENDIENTE,
        ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIORIDAD,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULTIMA_TAREA_CREADA, 
        FECHA_ULTIMA_TAREA_FINALIZADA, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULTIMA_TAREA_PENDIENTE,
        FECHA_ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPTACION,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
		FECHA_INTERPOSICION_MONITORIO,
		FECHA_INTERPOSICION_ETJ,
		FECHA_INTERPOSICION_ETNJ,
		FECHA_INTERPOSICION_ORDINARIO,
		FECHA_INTERPOSICION_VERBAL,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        FECHA_ULTIMO_COBRO,
        FECHA_ULTIMA_RESOLUCION, 
        FECHA_ULTIMO_IMPULSO,
        FECHA_ULTIMA_INADMISION, 
        FECHA_ULTIMO_ARCHIVO,
        FECHA_ULTIMO_REQUERIMIENTO_PREVIO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DETALLE_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_CREADA_DESCRIPCION_ID, 
        ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID,
        ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_ASUNTO_ID,
        ESTADO_ASUNTO_AGRUPADO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID,
        TRAMO_SALDO_TOTAL_CONCURSO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,  
        TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID,
        TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID,
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, 
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID,
        CONTRATO_GARANTIA_REAL_ASOCIADO_ID,
        ACTUALIZACION_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        CEDENTE_CONTRATO_PROCEDIMIENTO_ID,
        PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID,
        SEGMENTO_CONTRATO_PROCEDIMIENTO_ID,
        SOCIO_CONTRATO_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        REFERENCIA_ASUNTO,
        PROCEDIMIENTO_CON_COBRO_ID,
        PROCURADOR_PROCEDIMIENTO_ID,
        PROCEDIMIENTO_CON_PROCURADOR_ID,
        PROCEDIMIENTO_CON_RESOLUCION_ID,
        PROCEDIMIENTO_CON_IMPULSO_ID,
        TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID,
        TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID,
        RESULTADO_ULTIMO_IMPULSO_ID,
        JUZGADO_ID,
        NUMERO_AUTO,
        TIPO_ULTIMA_RESOLUCION_ID,
        MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID ,
        MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID,
        REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID,
		PROCURADOR_MONITORIO_ID,
		PROCURADOR_ETJ_ID,
		PROCURADOR_ETNJ_ID,
		PROCURADOR_ORDINARIO_ID,
		PROCURADOR_VERBAL_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        datediff(max_dia_mes, FECHA_ULTIMA_TAREA_ACTUALIZADA),
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        PLAZO_RECUPERACION,
        SALDO_RECUPERACION,
        ESTIMACIÓN_RECUPERACION,
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        RESTANTE_TOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA,          
        
        datediff(max_dia_mes, FECHA_ULTIMA_TAREA_PENDIENTE),
        NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE,          
        
        PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA,  
        PLAZO_CREACION_ASUNTO_A_ACEPTACION,   
        PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA,
        PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA,
        NUM_DIAS_DESDE_ULTIMA_ESTIMACION,
        NUM_DIAS_DESDE_ULTIMA_RESOLUCION,
        NUM_DIAS_DESDE_ULTIMO_IMPULSO
    from H_PROCEDIMIENTO where DIA_ID = max_dia_mes;

    
    update H_PROCEDIMIENTO_MES set NUM_DIAS_DESDE_ULT_ACTUALIZACION = (select datediff(max_dia_mes, FECHA_CREACION_FASE_ACTUAL)) where NUM_DIAS_DESDE_ULT_ACTUALIZACION is null;                                                         
    
    update H_PROCEDIMIENTO_MES set TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = (case when NUM_DIAS_DESDE_ULT_ACTUALIZACION <=30 then 0
                                                                                            when NUM_DIAS_DESDE_ULT_ACTUALIZACION >30 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 60 then 1
                                                                                            when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 90 then 2
                                                                                            when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION > 90 then 3
                                                                                            else -1 end);  
    
    insert into H_PROCEDIMIENTO_DETALLE_COBRO_MES
        (MES_ID,  
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,   
         ASUNTO_ID,
         CONTRATO_ID,
         FECHA_COBRO,
         FECHA_ASUNTO,
         TIPO_COBRO_DETALLE_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         NUM_DIAS_CREACION_ASUNTO_A_COBRO
        )
    select mes,    
         max_dia_mes,
         PROCEDIMIENTO_ID,   
         ASUNTO_ID,
         CONTRATO_ID,
         FECHA_COBRO,
         FECHA_ASUNTO,
         TIPO_COBRO_DETALLE_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         NUM_DIAS_CREACION_ASUNTO_A_COBRO
    from H_PROCEDIMIENTO_DETALLE_COBRO where DIA_ID = max_dia_mes;
     
     
    
    insert into H_PROCEDIMIENTO_DETALLE_CONTRATO_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO
         )
    select mes,   
         max_dia_mes,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO
    from H_PROCEDIMIENTO_DETALLE_CONTRATO where DIA_ID = max_dia_mes;
    
    
    
    insert into H_PROCEDIMIENTO_DETALLE_RESOLUCION_MES
    (MES_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     GESTOR_RESOLUCION_ID,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     NUM_RESOLUCIONES)
    select mes,
     max_dia_mes,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     GESTOR_RESOLUCION_ID,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     NUM_RESOLUCIONES
    from H_PROCEDIMIENTO_DETALLE_RESOLUCION where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;






set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    
    delete from H_PROCEDIMIENTO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    delete from H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    delete from H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE where TRIMESTRE_ID = trimestre;
    delete from H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE where TRIMESTRE_ID = trimestre;
    
    
    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_PROCEDIMIENTO_TRIMESTRE
        (TRIMESTRE_ID,   
        FECHA_CARGA_DATOS,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULTIMA_TAREA_CREADA,
        ULTIMA_TAREA_FINALIZADA,
        ULTIMA_TAREA_ACTUALIZADA,
        ULTIMA_TAREA_PENDIENTE,
        ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIORIDAD,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULTIMA_TAREA_CREADA, 
        FECHA_ULTIMA_TAREA_FINALIZADA, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULTIMA_TAREA_PENDIENTE,
        FECHA_ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPTACION,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
		FECHA_INTERPOSICION_MONITORIO,
		FECHA_INTERPOSICION_ETJ,
		FECHA_INTERPOSICION_ETNJ,
		FECHA_INTERPOSICION_ORDINARIO,
		FECHA_INTERPOSICION_VERBAL,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        FECHA_ULTIMO_COBRO,
        FECHA_ULTIMA_RESOLUCION, 
        FECHA_ULTIMO_IMPULSO,
        FECHA_ULTIMA_INADMISION, 
        FECHA_ULTIMO_ARCHIVO,
        FECHA_ULTIMO_REQUERIMIENTO_PREVIO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DETALLE_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_CREADA_DESCRIPCION_ID, 
        ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID,
        ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_ASUNTO_ID,
        ESTADO_ASUNTO_AGRUPADO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID,
        TRAMO_SALDO_TOTAL_CONCURSO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,  
        TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID,
        TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID,
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, 
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID,
        CONTRATO_GARANTIA_REAL_ASOCIADO_ID,
        ACTUALIZACION_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        CEDENTE_CONTRATO_PROCEDIMIENTO_ID,
        PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID,
        SEGMENTO_CONTRATO_PROCEDIMIENTO_ID,
        SOCIO_CONTRATO_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        REFERENCIA_ASUNTO,
        PROCEDIMIENTO_CON_COBRO_ID,
        PROCURADOR_PROCEDIMIENTO_ID,
        PROCEDIMIENTO_CON_PROCURADOR_ID,
        PROCEDIMIENTO_CON_RESOLUCION_ID,
        PROCEDIMIENTO_CON_IMPULSO_ID,
        TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID,
        TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID,
        RESULTADO_ULTIMO_IMPULSO_ID,
        JUZGADO_ID,
        NUMERO_AUTO,
        TIPO_ULTIMA_RESOLUCION_ID,
        MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID ,
        MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID,
        REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID,
		PROCURADOR_MONITORIO_ID,
		PROCURADOR_ETJ_ID,
		PROCURADOR_ETNJ_ID,
		PROCURADOR_ORDINARIO_ID,
		PROCURADOR_VERBAL_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        NUM_DIAS_DESDE_ULT_ACTUALIZACION,
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        PLAZO_RECUPERACION,
        SALDO_RECUPERACION,
        ESTIMACIÓN_RECUPERACION,
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        RESTANTE_TOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA,          
        
        DURACION_ULT_TAREA_PENDIENTE,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE,          
        
        PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA,  
        PLAZO_CREACION_ASUNTO_A_ACEPTACION,   
        PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA,
        PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA,
        NUM_DIAS_DESDE_ULTIMA_ESTIMACION,
        NUM_DIAS_DESDE_ULTIMA_RESOLUCION,
        NUM_DIAS_DESDE_ULTIMO_IMPULSO
        )
    select trimestre, 
        max_dia_trimestre,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULTIMA_TAREA_CREADA,
        ULTIMA_TAREA_FINALIZADA,
        ULTIMA_TAREA_ACTUALIZADA,
        ULTIMA_TAREA_PENDIENTE,
        ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIORIDAD,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULTIMA_TAREA_CREADA, 
        FECHA_ULTIMA_TAREA_FINALIZADA, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULTIMA_TAREA_PENDIENTE,
        FECHA_ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPTACION,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
		FECHA_INTERPOSICION_MONITORIO,
		FECHA_INTERPOSICION_ETJ,
		FECHA_INTERPOSICION_ETNJ,
		FECHA_INTERPOSICION_ORDINARIO,
		FECHA_INTERPOSICION_VERBAL,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        FECHA_ULTIMO_COBRO,
        FECHA_ULTIMA_RESOLUCION, 
        FECHA_ULTIMO_IMPULSO,
        FECHA_ULTIMA_INADMISION, 
        FECHA_ULTIMO_ARCHIVO,
        FECHA_ULTIMO_REQUERIMIENTO_PREVIO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DETALLE_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_CREADA_DESCRIPCION_ID, 
        ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID,
        ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_ASUNTO_ID,
        ESTADO_ASUNTO_AGRUPADO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID,
        TRAMO_SALDO_TOTAL_CONCURSO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,  
        TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID,
        TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID,
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, 
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID,
        CONTRATO_GARANTIA_REAL_ASOCIADO_ID,
        ACTUALIZACION_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        CEDENTE_CONTRATO_PROCEDIMIENTO_ID,
        PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID,
        SEGMENTO_CONTRATO_PROCEDIMIENTO_ID,
        SOCIO_CONTRATO_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        REFERENCIA_ASUNTO,
        PROCEDIMIENTO_CON_COBRO_ID,
        PROCURADOR_PROCEDIMIENTO_ID,
        PROCEDIMIENTO_CON_PROCURADOR_ID,
        PROCEDIMIENTO_CON_RESOLUCION_ID,
        PROCEDIMIENTO_CON_IMPULSO_ID,
        TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID,
        TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID,
        RESULTADO_ULTIMO_IMPULSO_ID,
        JUZGADO_ID,
        NUMERO_AUTO,
        TIPO_ULTIMA_RESOLUCION_ID,
        MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID ,
        MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID,
        REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID,
		PROCURADOR_MONITORIO_ID,
		PROCURADOR_ETJ_ID,
		PROCURADOR_ETNJ_ID,
		PROCURADOR_ORDINARIO_ID,
		PROCURADOR_VERBAL_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        datediff(max_dia_trimestre, FECHA_ULTIMA_TAREA_ACTUALIZADA),
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        PLAZO_RECUPERACION,
        SALDO_RECUPERACION,
        ESTIMACIÓN_RECUPERACION,
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        RESTANTE_TOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA,          
        
        datediff(max_dia_trimestre, FECHA_ULTIMA_TAREA_PENDIENTE),
        NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE,          
        
        PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA,  
        PLAZO_CREACION_ASUNTO_A_ACEPTACION,   
        PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA,
        PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA,
        NUM_DIAS_DESDE_ULTIMA_ESTIMACION,
        NUM_DIAS_DESDE_ULTIMA_RESOLUCION,
        NUM_DIAS_DESDE_ULTIMO_IMPULSO
    from H_PROCEDIMIENTO where DIA_ID = max_dia_trimestre;


update H_PROCEDIMIENTO_TRIMESTRE set NUM_DIAS_DESDE_ULT_ACTUALIZACION = (select datediff(max_dia_trimestre, FECHA_CREACION_FASE_ACTUAL)) where NUM_DIAS_DESDE_ULT_ACTUALIZACION is null;                                                         

update H_PROCEDIMIENTO_TRIMESTRE set TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = (case when NUM_DIAS_DESDE_ULT_ACTUALIZACION <=30 then 0
                                                                                              when NUM_DIAS_DESDE_ULT_ACTUALIZACION >30 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 60 then 1
                                                                                              when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 90 then 2
                                                                                              when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION > 90 then 3
                                                                                              else -1 end);  
    
    insert into H_PROCEDIMIENTO_DETALLE_COBRO_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,   
         ASUNTO_ID,
         CONTRATO_ID,
         FECHA_COBRO,
         FECHA_ASUNTO,
         TIPO_COBRO_DETALLE_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         NUM_DIAS_CREACION_ASUNTO_A_COBRO
        )
    select trimestre,
         max_dia_trimestre,
         PROCEDIMIENTO_ID,   
         ASUNTO_ID,
         CONTRATO_ID,
         FECHA_COBRO,
         FECHA_ASUNTO,
         TIPO_COBRO_DETALLE_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         NUM_DIAS_CREACION_ASUNTO_A_COBRO 
    from H_PROCEDIMIENTO_DETALLE_COBRO where DIA_ID = max_dia_trimestre;
    
    
    
    insert into H_PROCEDIMIENTO_DETALLE_CONTRATO_TRIMESTRE
        (TRIMESTRE_ID, 
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO)
    select trimestre, 
         max_dia_trimestre,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO
     from H_PROCEDIMIENTO_DETALLE_CONTRATO where DIA_ID = max_dia_trimestre;
     

    
    insert into H_PROCEDIMIENTO_DETALLE_RESOLUCION_TRIMESTRE
    (TRIMESTRE_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     GESTOR_RESOLUCION_ID,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     NUM_RESOLUCIONES)
    select trimestre,
     max_dia_trimestre,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     GESTOR_RESOLUCION_ID,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     NUM_RESOLUCIONES
    from H_PROCEDIMIENTO_DETALLE_RESOLUCION where DIA_ID = max_dia_trimestre;
    
    
end loop c_trimestre_loop;
close c_trimestre;






set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    
    delete from H_PROCEDIMIENTO_ANIO where ANIO_ID = anio;
    delete from H_PROCEDIMIENTO_DETALLE_COBRO_ANIO where ANIO_ID = anio;
    delete from H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO where ANIO_ID = anio;
    delete from H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO where ANIO_ID = anio;
    
    
    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_PROCEDIMIENTO_ANIO
        (ANIO_ID,      
        FECHA_CARGA_DATOS,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULTIMA_TAREA_CREADA,
        ULTIMA_TAREA_FINALIZADA,
        ULTIMA_TAREA_ACTUALIZADA,
        ULTIMA_TAREA_PENDIENTE,
        ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIORIDAD,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULTIMA_TAREA_CREADA, 
        FECHA_ULTIMA_TAREA_FINALIZADA, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULTIMA_TAREA_PENDIENTE,
        FECHA_ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPTACION,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
		FECHA_INTERPOSICION_MONITORIO,
		FECHA_INTERPOSICION_ETJ,
		FECHA_INTERPOSICION_ETNJ,
		FECHA_INTERPOSICION_ORDINARIO,
		FECHA_INTERPOSICION_VERBAL,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        FECHA_ULTIMO_COBRO,
        FECHA_ULTIMA_RESOLUCION, 
        FECHA_ULTIMO_IMPULSO,
        FECHA_ULTIMA_INADMISION, 
        FECHA_ULTIMO_ARCHIVO,
        FECHA_ULTIMO_REQUERIMIENTO_PREVIO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DETALLE_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_CREADA_DESCRIPCION_ID, 
        ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID,
        ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_ASUNTO_ID,
        ESTADO_ASUNTO_AGRUPADO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID,
        TRAMO_SALDO_TOTAL_CONCURSO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,  
        TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID,
        TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID,
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, 
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID,
        CONTRATO_GARANTIA_REAL_ASOCIADO_ID,
        ACTUALIZACION_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        CEDENTE_CONTRATO_PROCEDIMIENTO_ID,
        PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID,
        SEGMENTO_CONTRATO_PROCEDIMIENTO_ID,
        SOCIO_CONTRATO_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        REFERENCIA_ASUNTO,
        PROCEDIMIENTO_CON_COBRO_ID,
        PROCURADOR_PROCEDIMIENTO_ID,
        PROCEDIMIENTO_CON_PROCURADOR_ID,
        PROCEDIMIENTO_CON_RESOLUCION_ID,
        PROCEDIMIENTO_CON_IMPULSO_ID,
        TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID,
        TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID,
        RESULTADO_ULTIMO_IMPULSO_ID,
        JUZGADO_ID,
        NUMERO_AUTO,
        TIPO_ULTIMA_RESOLUCION_ID,
        MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID ,
        MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID,
        REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID,
		PROCURADOR_MONITORIO_ID,
		PROCURADOR_ETJ_ID,
		PROCURADOR_ETNJ_ID,
		PROCURADOR_ORDINARIO_ID,
		PROCURADOR_VERBAL_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        NUM_DIAS_DESDE_ULT_ACTUALIZACION,
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        PLAZO_RECUPERACION,
        SALDO_RECUPERACION,
        ESTIMACIÓN_RECUPERACION,
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        RESTANTE_TOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA,          
        
        DURACION_ULT_TAREA_PENDIENTE,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE,          
        
        PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA,  
        PLAZO_CREACION_ASUNTO_A_ACEPTACION,   
        PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA,
        PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA,
        NUM_DIAS_DESDE_ULTIMA_ESTIMACION,
        NUM_DIAS_DESDE_ULTIMA_RESOLUCION,
        NUM_DIAS_DESDE_ULTIMO_IMPULSO
        )
    select anio,   
        max_dia_anio,
        PROCEDIMIENTO_ID,
        FASE_MAX_PRIORIDAD,
        FASE_ANTERIOR,
        FASE_ACTUAL,
        ULTIMA_TAREA_CREADA,
        ULTIMA_TAREA_FINALIZADA,
        ULTIMA_TAREA_ACTUALIZADA,
        ULTIMA_TAREA_PENDIENTE,
        ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_CREACION_ASUNTO,
        FECHA_CONTABLE_LITIGIO,
        FECHA_CREACION_PROCEDIMIENTO,
        FECHA_CREACION_FASE_MAX_PRIORIDAD,
        FECHA_CREACION_FASE_ANTERIOR, 
        FECHA_CREACION_FASE_ACTUAL, 
        FECHA_ULTIMA_TAREA_CREADA, 
        FECHA_ULTIMA_TAREA_FINALIZADA, 
        FECHA_ULTIMA_TAREA_ACTUALIZADA, 
        FECHA_ULTIMA_TAREA_PENDIENTE,
        FECHA_ULTIMA_TAREA_PENDIENTE_FA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_FINALIZADA, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_FINALIZADA,
        FECHA_VENCIMIENTO_ORIGINAL_ULT_TAREA_PENDIENTE, 
        FECHA_VENCIMIENTO_ACTUAL_ULT_TAREA_PENDIENTE,
        FECHA_ACEPTACION,
        FECHA_RECOGIDA_DOC_Y_ACEPTACION,
        FECHA_REGISTRAR_TOMA_DECISION,
        FECHA_RECEPCION_DOC_COMPLETA,
        FECHA_INTERPOSICION_DEMANDA,
		FECHA_INTERPOSICION_MONITORIO,
		FECHA_INTERPOSICION_ETJ,
		FECHA_INTERPOSICION_ETNJ,
		FECHA_INTERPOSICION_ORDINARIO,
		FECHA_INTERPOSICION_VERBAL,
        FECHA_ULTIMA_POSICION_VENCIDA,
        FECHA_ULTIMA_ESTIMACION,
        FECHA_ESTIMADA_COBRO,
        FECHA_ULTIMO_COBRO,
        FECHA_ULTIMA_RESOLUCION, 
        FECHA_ULTIMO_IMPULSO,
        FECHA_ULTIMA_INADMISION, 
        FECHA_ULTIMO_ARCHIVO,
        FECHA_ULTIMO_REQUERIMIENTO_PREVIO,
        CONTEXTO_FASE,
        NIVEL,
        ASUNTO_ID,
        TIPO_PROCEDIMIENTO_DETALLE_ID,
        FASE_ACTUAL_DETALLE_ID,
        FASE_ANTERIOR_DETALLE_ID,
        ULTIMA_TAREA_CREADA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_CREADA_DESCRIPCION_ID, 
        ULTIMA_TAREA_FINALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_FINALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_ACTUALIZADA_TIPO_DETALLE_ID,
        ULTIMA_TAREA_ACTUALIZADA_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_TIPO_DETALLE_ID,
        ULTIMA_TAREA_PENDIENTE_DESCRIPCION_ID,
        ULTIMA_TAREA_PENDIENTE_FA_TIPO_DETALLE_ID, 
        ULTIMA_TAREA_PENDIENTE_FA_DESCRIPCION_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_FINALIZADA_ID,
        CUMPLIMIENTO_ULTIMA_TAREA_PENDIENTE_ID,
        ESTADO_PROCEDIMIENTO_ID,
        ESTADO_ASUNTO_ID,
        ESTADO_ASUNTO_AGRUPADO_ID,
        ESTADO_FASE_ACTUAL_ID,
        ESTADO_FASE_ANTERIOR_ID,
        TRAMO_SALDO_TOTAL_PROCEDIMIENTO_ID,
        TRAMO_SALDO_TOTAL_CONCURSO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_ID,
        TRAMO_DIAS_CONTRATO_VENCIDO_RESPECTO_CREACION_ASUNTO_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,  
        TRAMO_DIAS_CREACION_ASUNTO_A_ACEPTACION_ID,
        TRAMO_DIAS_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA_ID,
        TRAMO_DIAS_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPT_ID,
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_REGISTRAR_TOMA_DECISION_ID, 
        TRAMO_DIAS_RECOGIDA_DOC_Y_ACEPT_A_RECEPCION_DOC_COMPLETA_ID,
        CONTRATO_GARANTIA_REAL_ASOCIADO_ID,
        ACTUALIZACION_ESTIMACIONES_ID,
        CARTERA_PROCEDIMIENTO_ID,
        CEDENTE_CONTRATO_PROCEDIMIENTO_ID,
        PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID,
        SEGMENTO_CONTRATO_PROCEDIMIENTO_ID,
        SOCIO_CONTRATO_PROCEDIMIENTO_ID,
        TITULAR_PROCEDIMIENTO_ID,
        REFERENCIA_ASUNTO,
        PROCEDIMIENTO_CON_COBRO_ID,
        PROCURADOR_PROCEDIMIENTO_ID,
        PROCEDIMIENTO_CON_PROCURADOR_ID,
        PROCEDIMIENTO_CON_RESOLUCION_ID,
        PROCEDIMIENTO_CON_IMPULSO_ID,
        TRAMO_DIAS_DESDE_ULTIMA_RESOLUCION_ID,
        TRAMO_DIAS_DESDE_ULTIMO_IMPULSO_ID,
        RESULTADO_ULTIMO_IMPULSO_ID,
        JUZGADO_ID,
        NUMERO_AUTO,
        TIPO_ULTIMA_RESOLUCION_ID,
        MOTIVO_INADMISION_ULTIMA_RESOLUCION_ID ,
        MOTIVO_ARCHIVO_ULTIMA_RESOLUCION_ID,
        REQUERIMIENTO_PREVIO_ULTIMA_RESOLUCION_ID,
		PROCURADOR_MONITORIO_ID,
		PROCURADOR_ETJ_ID,
		PROCURADOR_ETNJ_ID,
		PROCURADOR_ORDINARIO_ID,
		PROCURADOR_VERBAL_ID,
        NUM_PROCEDIMIENTOS,
        NUM_CONTRATOS,
        NUM_FASES,
        datediff(max_dia_anio, FECHA_ULTIMA_TAREA_ACTUALIZADA),
        NUM_MAX_DIAS_CONTRATO_VENCIDO,
        PORCENTAJE_RECUPERACION,
        PLAZO_RECUPERACION,
        SALDO_RECUPERACION,
        ESTIMACIÓN_RECUPERACION,
        SALDO_ORIGINAL_VENCIDO,
        SALDO_ORIGINAL_NO_VENCIDO,
        SALDO_ACTUAL_VENCIDO,
        SALDO_ACTUAL_NO_VENCIDO,
        SALDO_ACTUAL_TOTAL,
        SALDO_CONCURSOS_VENCIDO,
        SALDO_CONCURSOS_NO_VENCIDO,
        SALDO_CONCURSOS_TOTAL,
        INGRESOS_PENDIENTES_APLICAR,
        SUBTOTAL,
        RESTANTE_TOTAL,
        DURACION_ULT_TAREA_FINALIZADA,
        NUM_DIAS_EXCEDIDO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_FINALIZADA,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_FINALIZADA,          
        
        datediff(max_dia_anio, FECHA_ULTIMA_TAREA_PENDIENTE),
        NUM_DIAS_EXCEDIDO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_HASTA_VENCIMIENTO_ULT_TAREA_PENDIENTE,
        NUM_DIAS_PRORROGADOS_ULT_TAREA_PENDIENTE,         
        
        PLAZO_CREACION_ASUNTO_A_INTERPOSICION_DEMANDA,  
        PLAZO_CREACION_ASUNTO_A_ACEPTACION,   
        PLAZO_ACEPTACION_ASUNTO_A_INTERPOSICION_DEMANDA,
        PLAZO_CREACION_ASUNTO_A_RECOGIDA_DOC_Y_ACEPTACION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_REGISTRAR_TOMA_DECISION,
        PLAZO_RECOGIDA_DOC_Y_ACEPTACION_A_RECEPCION_DOC_COMPLETA,
        NUM_DIAS_DESDE_ULTIMA_ESTIMACION,
        NUM_DIAS_DESDE_ULTIMA_RESOLUCION,
        NUM_DIAS_DESDE_ULTIMO_IMPULSO
    from H_PROCEDIMIENTO where DIA_ID = max_dia_anio;


update H_PROCEDIMIENTO_ANIO set NUM_DIAS_DESDE_ULT_ACTUALIZACION = (select datediff(max_dia_anio, FECHA_CREACION_FASE_ACTUAL)) where NUM_DIAS_DESDE_ULT_ACTUALIZACION is null;                                                         

update H_PROCEDIMIENTO_ANIO set TRAMO_DIAS_ULTIMA_ACTUALIZACION_PROCEDIMIENTO_ID = (case when NUM_DIAS_DESDE_ULT_ACTUALIZACION <=30 then 0
                                                                                         when NUM_DIAS_DESDE_ULT_ACTUALIZACION >30 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 60 then 1
                                                                                         when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION <= 90 then 2
                                                                                         when NUM_DIAS_DESDE_ULT_ACTUALIZACION >60 and NUM_DIAS_DESDE_ULT_ACTUALIZACION > 90 then 3
                                                                                         else -1 end);  
    
    insert into H_PROCEDIMIENTO_DETALLE_COBRO_ANIO
        (ANIO_ID, 
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,   
         ASUNTO_ID,
         CONTRATO_ID,
         FECHA_COBRO,
         FECHA_ASUNTO,
         TIPO_COBRO_DETALLE_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         NUM_DIAS_CREACION_ASUNTO_A_COBRO
        )
    select anio,  
         max_dia_anio,
         PROCEDIMIENTO_ID,   
         ASUNTO_ID,
         CONTRATO_ID,
         FECHA_COBRO,
         FECHA_ASUNTO,
         TIPO_COBRO_DETALLE_ID,
         NUM_COBROS,
         IMPORTE_COBRO,
         NUM_DIAS_CREACION_ASUNTO_A_COBRO  
    from H_PROCEDIMIENTO_DETALLE_COBRO where DIA_ID = max_dia_anio;
    
    
    
    insert into H_PROCEDIMIENTO_DETALLE_CONTRATO_ANIO
        (ANIO_ID,   
         FECHA_CARGA_DATOS,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO)
    select anio, 
         max_dia_anio,
         PROCEDIMIENTO_ID,
         ASUNTO_ID,
         CONTRATO_ID,
         NUM_CONTRATOS_PROCEDIMIENTO
    from H_PROCEDIMIENTO_DETALLE_CONTRATO where DIA_ID = max_dia_anio;
     
         
    
    insert into H_PROCEDIMIENTO_DETALLE_RESOLUCION_ANIO
    (ANIO_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     GESTOR_RESOLUCION_ID,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     NUM_RESOLUCIONES)
    select anio,
     max_dia_anio,
     PROCEDIMIENTO_ID,
     ASUNTO_ID,
     GESTOR_RESOLUCION_ID,
     FECHA_RESOLUCION,
     TIPO_RESOLUCION_ID,
     MOTIVO_INADMISION_RESOLUCION_ID,
     MOTIVO_ARCHIVO_RESOLUCION_ID,
     REQUERIMIENTO_PREVIO_RESOLUCION_ID,
     NUM_RESOLUCIONES
    from H_PROCEDIMIENTO_DETALLE_RESOLUCION where DIA_ID = max_dia_anio;
    
end loop c_anio_loop;
close c_anio;

END MY_BLOCK_H_PRC$$
DELIMITER ;
