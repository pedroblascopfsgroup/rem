-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_H_Tarea_Finalizada`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_TAR: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos Tareas Finalizadas.
-- ===============================================================================================
 
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
declare fecha date;
declare fecha_rellenar date;
declare max_dia_carga date;

declare l_last_row int default 0;
declare c_fecha cursor for select distinct(DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end; 
declare c_fecha_rellenar cursor for select distinct(DIA_ID) FROM DIM_FECHA_DIA where DIA_ID between date_start and date_end; 
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
--                                      H_TAREA_FINALIZADA
-- ----------------------------------------------------------------------------------------------

truncate table TEMP_TAREA_JERARQUIA;
insert into TEMP_TAREA_JERARQUIA (
    DIA_ID,                               
    ITER,   
    FASE_ACTUAL
  ) 
select Fecha_Procedimiento,
    PJ_PADRE,
    PRC_ID
from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS_JERARQUIA where Fecha_Procedimiento between date_start and date_end;

-- Rellenar los días que no tienen entradas de procedimientos. No ha existido ningún movimiento. La foto es la del día anterior.
set l_last_row = 0; 

open c_fecha_rellenar;
rellenar_loop: loop
fetch c_fecha_rellenar into fecha_rellenar;        
    if (l_last_row=1) then leave rellenar_loop; 
    end if;
    
    -- Si un día no ha habido movimiento copiamos dia anterior
    if((select count(DIA_ID) from TEMP_TAREA_JERARQUIA where DIA_ID = fecha_rellenar) = 0) then 
    insert into TEMP_TAREA_JERARQUIA(
        DIA_ID,                               
        ITER,   
        FASE_ACTUAL
    )
    select date_add(DIA_ID, INTERVAL 1 DAY),                             
        ITER,   
        FASE_ACTUAL
        from TEMP_TAREA_JERARQUIA where DIA_ID = date_add(fecha_rellenar, INTERVAL -1 DAY);
    end if; 
    
end loop;
close c_fecha_rellenar;    

-- Obtenemos el último día cargado en el sistema
set max_dia_carga = (select max(DIA_ID) FROM H_PROCEDIMIENTO);

-- Borrado de los días a insertar
delete from H_TAREA_FINALIZADA where DIA_FINALIZACION_TAREA_ID between date_start and date_end;


-- Insertamos las tareas finalizadas de cada día
set l_last_row = 0; 

open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;
    
insert into H_TAREA_FINALIZADA
    (DIA_FINALIZACION_TAREA_ID,
    FECHA_CARGA_DATOS,
    TAREA_ID,
    FASE_ACTUAL_PROCEDIMIENTO,
    ASUNTO_ID,
    FECHA_CREACION_TAREA,
    FECHA_VENCIMIENTO_ORIGINAL_TAREA,
    FECHA_VENCIMIENTO_TAREA,
    RESPONSABLE_TAREA_ID,
    NUM_TAREAS_FINALIZADAS,
    DURACION_TAREA_FINALIZADA,
    NUM_DIAS_VENCIDO
    )
select date(TAR_FECHA_FIN),
    max_dia_carga,
    tar.TAR_ID, 
    tar.PRC_ID,
    tar.ASU_ID,
    date(TAR_FECHA_INI),
    date(TAR_FECHA_VENC_REAL),
    date(TAR_FECHA_VENC),
    TAP_SUPERVISOR,
    1,
    datediff(date(TAR_FECHA_FIN), date(TAR_FECHA_INI)),
    datediff(date(TAR_FECHA_FIN), date(TAR_FECHA_VENC))
from recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar 
join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
join recovery_lindorff_datastage.TAP_TAREA_PROCEDIMIENTO tap on tex.TAP_ID = tap.TAP_ID
where tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) = fecha and tar.DD_STA_ID not in (16, 26, 28, 41, 43, 44, 46, 47, 503) and tar.TAR_CODIGO <> 3;

-- Borramos las tareas de procedimientos borrados (No existen en Recovery)
delete from H_TAREA_FINALIZADA where DIA_FINALIZACION_TAREA_ID = fecha and FASE_ACTUAL_PROCEDIMIENTO in (select PRC_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where BORRADO=1);

update H_TAREA_FINALIZADA tar, TEMP_TAREA_JERARQUIA ttj set tar.PROCEDIMIENTO_ID = ttj.ITER where tar.DIA_FINALIZACION_TAREA_ID = fecha and tar.DIA_FINALIZACION_TAREA_ID = ttj.DIA_ID and tar.FASE_ACTUAL_PROCEDIMIENTO = ttj.FASE_ACTUAL;
update H_TAREA_FINALIZADA tar, H_PROCEDIMIENTO h set tar.TIPO_PROCEDIMIENTO_DETALLE_ID = h.TIPO_PROCEDIMIENTO_DETALLE_ID where tar.DIA_FINALIZACION_TAREA_ID = fecha and tar.DIA_FINALIZACION_TAREA_ID = h.DIA_ID and tar.PROCEDIMIENTO_ID = h.PROCEDIMIENTO_ID;
update H_TAREA_FINALIZADA tar, H_PROCEDIMIENTO h set tar.CARTERA_PROCEDIMIENTO_ID = h.CARTERA_PROCEDIMIENTO_ID where tar.DIA_FINALIZACION_TAREA_ID = fecha and tar.DIA_FINALIZACION_TAREA_ID = h.DIA_ID and tar.PROCEDIMIENTO_ID = h.PROCEDIMIENTO_ID;
update H_TAREA_FINALIZADA tar, H_PROCEDIMIENTO h set tar.PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID = h.PROPIETARIO_CONTRATO_PROCEDIMIENTO_ID where tar.DIA_FINALIZACION_TAREA_ID = fecha and tar.DIA_FINALIZACION_TAREA_ID = h.DIA_ID and tar.PROCEDIMIENTO_ID = h.PROCEDIMIENTO_ID;

update H_TAREA_FINALIZADA tar set GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID = (select GESTOR_EN_RECOVERY_PROCEDIMIENTO_ID 
                                                                         from DIM_PROCEDIMIENTO prc
                                                                         join DIM_PROCEDIMIENTO_GESTOR ges on prc.GESTOR_PROCEDIMIENTO_ID = ges.GESTOR_PROCEDIMIENTO_ID
                                                                         where tar.PROCEDIMIENTO_ID = prc.PROCEDIMIENTO_ID) where tar.DIA_FINALIZACION_TAREA_ID = fecha;
                                                                        
end loop;
close c_fecha;

END MY_BLOCK_H_TAR