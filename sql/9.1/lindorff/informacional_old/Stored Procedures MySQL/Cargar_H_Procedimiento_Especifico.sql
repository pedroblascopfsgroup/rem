-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`lindorff`@`62.15.160.2` PROCEDURE `Cargar_H_Procedimiento_Especifico`(IN date_start Date, IN date_end Date, OUT o_error_status varchar(500))
MY_BLOCK_H_PRC_ESP: BEGIN

-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Septiembre 2013
-- Responsable última modificación: Gonzalo Martín, PFS Group
-- Fecha última modificación: 10/12/2013
-- Motivos del cambio: SP Lindorff v0
-- Cliente: Recovery BI Lindorff  
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos Concurso, Declarativo, 
--              Ejecución Ordinaria, Hipotecario, Monitorio y Ejecución notarial.
-- ===============================================================================================
-- -------------------------------------------- ÍNDICE -------------------------------------------
-- PROCEDIMIENTOS ESPECÍFICOS
    -- CONCURSOS
    -- DECLARATIVO
    -- EJECUCION_ORDINARIA
    -- HIPOTECARIO
    -- MONITORIO
    -- ETJ
    -- EJECUCION_NOTARIAL
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
declare max_dia_con_contratos date;
declare max_dia_mes date;
declare max_dia_trimestre date;
declare max_dia_anio date;
declare max_dia_carga date;
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


-- -------------------PRIORIDADES PROCEDIMIENTOS (migrado a Lindorff)----------------
truncate table TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD;
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P95', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P94', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P93', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P92', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P91', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P83', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P82', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P81', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P80', 2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P79', 2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P78', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P77', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P76', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P75', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P74', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P73', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P72', 1);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P71', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P70', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P65', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P64', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P63', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P62', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P61', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P60', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P56', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P55', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P54', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P53', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P52', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P51', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P50', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P49', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P48', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P47', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P46', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P45', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P44', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P43', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P42', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P41', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P40', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P39', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P38', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P37', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P36', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P35', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P34', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P33', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P32', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P31', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P30', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P29', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P28', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P27', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P26', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P25', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P24', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P23', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P22', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P21', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P20', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P19', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P18', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P17', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P16', 1);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P15', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P14', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P13', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P12', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P11', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P1000', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P10', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P09', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P08', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P07', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P06', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P05', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P04', 2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P03', 2);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P02', 3);
insert into TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD (DD_TPO_CODIGO, PRIORIDAD) values ('P01', 3);

truncate table TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA;
insert into TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA (
    DIA_ID,                               
    ITER,   
    FASE_ACTUAL, 
    NIVEL,
    CONTEXTO,
    CODIGO_FASE_ACTUAL,   
    PRIORIDAD_FASE,
    ASUNTO
  ) 
select Fecha_Procedimiento,
    PJ_PADRE,
    PRC_ID,
    NIVEL,
    PATH_DERIVACION,
    PRC_TPO,  
    coalesce(PRIORIDAD, 0),
    ASU_ID
from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS_JERARQUIA
left join TEMP_PROCEDIMIENTO_CODIGO_PRIORIDAD on PRC_TPO = DD_TPO_CODIGO
where Fecha_Procedimiento between date_start and date_end;

-- Rellenar los días que no tienen entradas de procedimientos. No ha existido ningún movimiento. La foto es la del día anterior.
set l_last_row = 0; 

open c_fecha_rellenar;
rellenar_loop: loop
fetch c_fecha_rellenar into fecha_rellenar;        
    if (l_last_row=1) then leave rellenar_loop; 
    end if;
    
    -- Si un día no ha habido movimiento copiamos dia anterior
    if((select count(DIA_ID) from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA where DIA_ID = fecha_rellenar) = 0) then 
    insert into TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA(
        DIA_ID,                               
        ITER,   
        FASE_ACTUAL, 
        NIVEL,
        CONTEXTO,
        CODIGO_FASE_ACTUAL,   
        PRIORIDAD_FASE,
        ASUNTO
    )
    select date_add(DIA_ID, INTERVAL 1 DAY),                             
        ITER,   
        FASE_ACTUAL, 
        NIVEL,
        CONTEXTO,
        CODIGO_FASE_ACTUAL,   
        PRIORIDAD_FASE,
        ASUNTO
        from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA where DIA_ID = date_add(fecha_rellenar, INTERVAL -1 DAY);
    end if;  
    
    -- Update fase actual paralizada, fase finalizada en función de las decisiones asociadas
    -- Fase Actual Paralizada
    truncate table TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION;
    insert into TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION (FASE_ACTUAL, FASE_PARALIZADA, FASE_FINALIZADA, FECHA_HASTA)
    select PRC_ID, DPR_PARALIZA, DPR_FINALIZA, max(date(DPR_FECHA_PARA)) from recovery_lindorff_datastage.DPR_DECISIONES_PROCEDIMIENTOS 
    where (DD_EDE_ID = 2 and DPR_PARALIZA = 1) and date(FECHACREAR) <= fecha_rellenar
    group by PRC_ID;
    update TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA pj set FASE_PARALIZADA = (select FASE_PARALIZADA from TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION pd where pd.FASE_PARALIZADA = 1 and pd.FASE_ACTUAL = pj.FASE_ACTUAL and pj.DIA_ID <= pd.FECHA_HASTA) 
                                                                                                    where DIA_ID = fecha_rellenar;
    -- Fase Actual Finalizada
    truncate table TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION;
    insert into TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION (FASE_ACTUAL, FASE_PARALIZADA, FASE_FINALIZADA, FECHA_HASTA)
    select PRC_ID, DPR_PARALIZA, DPR_FINALIZA, max(date(DPR_FECHA_PARA)) from recovery_lindorff_datastage.DPR_DECISIONES_PROCEDIMIENTOS 
    where (DD_EDE_ID = 2 and DPR_FINALIZA = 1) and date(FECHACREAR) <= fecha_rellenar
    group by PRC_ID;
    update TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA pj set FASE_FINALIZADA = (select FASE_FINALIZADA from TEMP_PROCEDIMIENTO_ESPECIFICO_DECISION pd where pd.FASE_FINALIZADA = 1 and pd.FASE_ACTUAL = pj.FASE_ACTUAL) 
                                                                                                    where DIA_ID = fecha_rellenar;
    -- Fase Actual con Recurso sin resolución
    truncate table TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO;
    insert into TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO (FASE_ACTUAL, FASE_CON_RECURSO, FECHA_RESOLUCION)
    select PRC_ID, 1, max(date(RCR_FECHA_RESOLUCION)) from recovery_lindorff_datastage.RCR_RECURSOS_PROCEDIMIENTOS 
    where date(RCR_FECHA_RECURSO) <= fecha_rellenar and RCR_FECHA_RESOLUCION is not null
    group by PRC_ID;
    update TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA pj set FASE_CON_RECURSO = (select FASE_CON_RECURSO from TEMP_PROCEDIMIENTO_ESPECIFICO_RECURSO pd where pd.FASE_CON_RECURSO = 1 and pd.FASE_ACTUAL = pj.FASE_ACTUAL) 
                                                                                                      where DIA_ID = fecha_rellenar; 
end loop;
close c_fecha_rellenar;


-- Bucle que recorre los días. Para cada día calculo el tipo de procedimiento (máximo valor de las actuaciones que lo conforman)
set l_last_row = 0; 

open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;
   
   -- Tabla auxiliar con el detalle diario. Reinicio para cada día
    truncate TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE;
    insert into TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE(ITER) select distinct ITER from  TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA WHERE DIA_ID = fecha;

    -- -------------------------------------------- FASE MAX PRIORIDAD -------------------------------------------- -------------------------------------
    -- Calculamos la máxima prioridad del procedimiento en la fecha.
    update TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE pd set MAX_PRIORIDAD = (select max(PRIORIDAD_FASE) from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA pj where pj.DIA_ID = fecha and pj.ITER = pd.ITER);
    -- Asignamos la prioridad a todos las actuaciones del procedimiento.
    update TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA pj set PRIORIDAD_PROCEDIMIENTO = (select MAX_PRIORIDAD from TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    update TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE pd set FASE_MAX_PRIORIDAD = (select max(FASE_ACTUAL) from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA pj where pj.DIA_ID = fecha and pj.ITER = pd.ITER and pj.PRIORIDAD_PROCEDIMIENTO = pj.PRIORIDAD_FASE);
    update TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA pj set FASE_MAX_PRIORIDAD = (select FASE_MAX_PRIORIDAD from TEMP_PROCEDIMIENTO_ESPECIFICO_DETALLE pd where pd.ITER = pj.ITER) where DIA_ID = fecha; 
    
    end loop;
close c_fecha;
-- Calcular tipo de procedimiento
update TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA set TIPO_PROCEDIMIENTO_DETALLE = (select DD_TPO_ID from recovery_lindorff_datastage.PRC_PROCEDIMIENTOS where PRC_ID = FASE_MAX_PRIORIDAD);

/*
-- =========================================================================================================================================
--                  					          CONCURSOS (migrado a Lindorff) 
-- Ahora mismo no hay instancias de procedimientos de concursos en Lindorff así que no aplica, se mantiene por si acaso
-- =========================================================================================================================================
truncate table TEMP_CONCURSO_JERARQUIA;

if((select count(*) from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
    where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
    join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
    where DD_TAC_DESCRIPCION= 'Concursal'))>0) then

insert into TEMP_CONCURSO_JERARQUIA select * from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
                                    where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
                                                                         join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                                                                         where DD_TAC_DESCRIPCION= 'Concursal');

-- Bucle para las taras e inclusión en H_CONCURSO                                                                          
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;  
    
    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    truncate TEMP_CONCURSO_DETALLE;
    insert into TEMP_CONCURSO_DETALLE(ITER) select distinct ITER from  TEMP_CONCURSO_JERARQUIA WHERE DIA_ID = fecha;
    
    -- FECHA_AUTO_FASE_COMUN
    -- TAP_ID: 411 P23_registrarPublicacionBOE  FASE: T. fase común ordinario / TAP_ID: 419 P24_registrarPublicacionBOE  FASE: T. fase común abreviado
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and  -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fechaAuto' and tex.tap_id in (411, 419);
    update TEMP_CONCURSO_DETALLE cd set FECHA_AUTO_FASE_COMUN = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_LIQUIDACION
    -- Fecha de inicio de la fase T. fase de liquidación
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, date(prc.FECHACREAR)
        from TEMP_CONCURSO_JERARQUIA tpj 
        join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on tpj.FASE_ACTUAL = prc.PRC_ID
        where  DIA_ID = fecha and  date(prc.FECHACREAR) <= fecha and prc.DD_TPO_ID=150 and prc.BORRADO=0;
    update TEMP_CONCURSO_DETALLE cd set FECHA_LIQUIDACION = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
        
    -- FECHA_PUBLICACION_BOE
    -- TAP_ID: 411 P23_registrarPublicacionBOE FASE: T. fase común ordinario / TAP_ID: 419 P24_registrarPublicacionBOE FASE: T. fase común abreviado 
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (411, 419);
    update TEMP_CONCURSO_DETALLE cd set FECHA_PUBLICACION_BOE = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_INSINUACION_FINAL_CREDITO
    -- TAP_ID: 1102	P23_registrarFinFaseComun FASE: Registrar resolución finalización fase común / TAP_ID: 1106	P24_registrarFinFaseComun FASE: Registrar resolución finalización fase común
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (1106, 1102);
    update TEMP_CONCURSO_DETALLE cd set FECHA_INSINUACION_FINAL_CREDITO = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
 
    -- FECHA_AUTO_APERTURA_CONVENIO
    -- TAP_ID: 449 P29_autoApertura  FASE: T. fase convenio
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fechaFase' and tex.tap_id in (449);
    update TEMP_CONCURSO_DETALLE cd set FECHA_AUTO_APERTURA_CONVENIO = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_REGISTRAR_IAC
    -- TAP_ID: 416 P23_informeAdministracionConcursal  FASE: Registrar informe administración concursal TAP_ID: 424 P24_informeAdministracionConcursal 
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (416, 424);
    update TEMP_CONCURSO_DETALLE cd set FECHA_REGISTRAR_IAC = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_INTERPOSICION_DEMANDA_
    -- TAP_ID: 427 P25_interposicionDemanda  FASE: T. demanda incidental 
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (427);
    update TEMP_CONCURSO_DETALLE cd set FECHA_INTERPOSICION_DEMANDA = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_JUNTA_ACREEDORES
    -- TAP_ID: 456 P29_registrarResultado  FASE: T. fase convenio 	
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fechaJunta' and tex.tap_id in (456);
    update TEMP_CONCURSO_DETALLE cd set FECHA_JUNTA_ACREEDORES = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
   
    -- FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION
    -- TAP_ID: 456 P31_aperturaFase  FASE: T. fase liquidación 	
    truncate table TEMP_CONCURSO_TAREA;
    insert into TEMP_CONCURSO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_CONCURSO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (467);
    update TEMP_CONCURSO_DETALLE cd set FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION = (select date(max(FECHA_FORMULARIO)) from TEMP_CONCURSO_TAREA ct where cd.ITER = ct.ITER);
    
    -- Borrado de los días a insertar
    delete from H_CONCURSO where DIA_ID = fecha;    

    -- Insertamos en H_CONCURSO sólo el registro que tiene la última actuación
    insert into H_CONCURSO
    (DIA_ID,                               
     PROCEDIMIENTO_ID, 
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,        
     NUM_CONCURSOS,
     PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS,
     PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION, 
     PLAZO_PUBLICACION_BOE_A_INSINUACION_CREDITO, 
     PLAZO_AUTO_FASE_COMUN_A_AUTO_APERTURA_CONVENIO, 
     PLAZO_REGISTRAR_IAC_A_INTERPOSICION_DEMANDA, 
     PLAZO_AUTO_APERTURA_CONVENIO_A_JUNTA_ACREEDORES,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO
    )
    select fecha,                               
     ITER,   
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,  
     1,
     datediff(fecha, FECHA_AUTO_FASE_COMUN),
     datediff(FECHA_LIQUIDACION, FECHA_AUTO_FASE_COMUN),
     datediff(FECHA_INSINUACION_FINAL_CREDITO, FECHA_PUBLICACION_BOE),
     datediff(FECHA_AUTO_APERTURA_CONVENIO, FECHA_AUTO_FASE_COMUN),
     datediff(FECHA_INTERPOSICION_DEMANDA, FECHA_REGISTRAR_IAC),
     datediff(FECHA_JUNTA_ACREEDORES, FECHA_AUTO_APERTURA_CONVENIO),
     datediff(FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION, FECHA_AUTO_FASE_COMUN),
     datediff(FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION, FECHA_AUTO_FASE_COMUN)
    from TEMP_CONCURSO_DETALLE;
    
    -- PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO -> Procedimiento que NO pasa por T. fase convenio (148)
    update H_CONCURSO set PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO = null 
    where DIA_ID = fecha and PROCEDIMIENTO_ID in (select  tpj.ITER from TEMP_CONCURSO_JERARQUIA tpj 
                                   join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on tpj.FASE_ACTUAL = prc.PRC_ID
                                   where  DIA_ID = fecha and  date(prc.FECHACREAR) <= fecha  and prc.DD_TPO_ID=148 and prc.BORRADO=0);
                                                                                                                               
    -- PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO -> Procedimiento que pasa por T. fase convenio (148)
    update H_CONCURSO set PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO = null 
    where DIA_ID = fecha and PROCEDIMIENTO_ID not in (select  tpj.ITER from TEMP_CONCURSO_JERARQUIA tpj 
                                   join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on tpj.FASE_ACTUAL = prc.PRC_ID
                                   where  DIA_ID = fecha  and  date(prc.FECHACREAR) <= fecha  and prc.DD_TPO_ID=148 and prc.BORRADO=0);
    end loop;
close c_fecha;


update H_CONCURSO set TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID = (case when PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS <= 365 then 0 
                                                                           when PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS > 365 then 1  
                                                                           else -1 end); 
update H_CONCURSO set TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID = (case when PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION <= 365 then 0 
                                                                           when PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION > 365 then 1  
                                                                           else -1 end);   
                                                                           
-- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_CONCURSO);      
update H_CONCURSO set FECHA_CARGA_DATOS = max_dia_carga;

-- ----------------------------------------------------------------------------------------------
--                                      H_CONCURSO_MES
-- ----------------------------------------------------------------------------------------------
truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_CONCURSO where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_CONCURSO_MES where MES_ID = mes;   

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_CONCURSO_MES
    (MES_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,   
     TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID,
     TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID,
     NUM_CONCURSOS,
     PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS,
     PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION, 
     PLAZO_PUBLICACION_BOE_A_INSINUACION_CREDITO, 
     PLAZO_AUTO_FASE_COMUN_A_AUTO_APERTURA_CONVENIO, 
     PLAZO_REGISTRAR_IAC_A_INTERPOSICION_DEMANDA, 
     PLAZO_AUTO_APERTURA_CONVENIO_A_JUNTA_ACREEDORES,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO
    )
    select mes,
     max_dia_mes,
     PROCEDIMIENTO_ID, 
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,  
     TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID,
     TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID,
     NUM_CONCURSOS,
     PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS,
     PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION, 
     PLAZO_PUBLICACION_BOE_A_INSINUACION_CREDITO, 
     PLAZO_AUTO_FASE_COMUN_A_AUTO_APERTURA_CONVENIO, 
     PLAZO_REGISTRAR_IAC_A_INTERPOSICION_DEMANDA, 
     PLAZO_AUTO_APERTURA_CONVENIO_A_JUNTA_ACREEDORES,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO
    from H_CONCURSO where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_CONCURSO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_CONCURSO_TRIMESTRE where TRIMESTRE_ID = trimestre;  

    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_CONCURSO_TRIMESTRE
    (TRIMESTRE_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,   
     TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID,
     TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID,
     NUM_CONCURSOS,
     PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS,
     PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION, 
     PLAZO_PUBLICACION_BOE_A_INSINUACION_CREDITO, 
     PLAZO_AUTO_FASE_COMUN_A_AUTO_APERTURA_CONVENIO, 
     PLAZO_REGISTRAR_IAC_A_INTERPOSICION_DEMANDA, 
     PLAZO_AUTO_APERTURA_CONVENIO_A_JUNTA_ACREEDORES,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO
    )
    select trimestre, 
     max_dia_trimestre,
     PROCEDIMIENTO_ID, 
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,  
     TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID,
     TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID,
     NUM_CONCURSOS,
     PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS,
     PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION, 
     PLAZO_PUBLICACION_BOE_A_INSINUACION_CREDITO, 
     PLAZO_AUTO_FASE_COMUN_A_AUTO_APERTURA_CONVENIO, 
     PLAZO_REGISTRAR_IAC_A_INTERPOSICION_DEMANDA, 
     PLAZO_AUTO_APERTURA_CONVENIO_A_JUNTA_ACREEDORES,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO
    from H_CONCURSO where DIA_ID = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_CONCURSO_ANIO
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_CONCURSO_ANIO where ANIO_ID = anio; 

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_CONCURSO_ANIO
    (ANIO_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,   
     TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID,
     TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID,
     NUM_CONCURSOS,
     PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS,
     PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION, 
     PLAZO_PUBLICACION_BOE_A_INSINUACION_CREDITO, 
     PLAZO_AUTO_FASE_COMUN_A_AUTO_APERTURA_CONVENIO, 
     PLAZO_REGISTRAR_IAC_A_INTERPOSICION_DEMANDA, 
     PLAZO_AUTO_APERTURA_CONVENIO_A_JUNTA_ACREEDORES,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO
    )
    select anio,    
     max_dia_anio,
     PROCEDIMIENTO_ID, 
     FECHA_AUTO_FASE_COMUN,
     FECHA_LIQUIDACION,
     FECHA_PUBLICACION_BOE,
     FECHA_INSINUACION_FINAL_CREDITO, 
     FECHA_AUTO_APERTURA_CONVENIO, 
     FECHA_REGISTRAR_IAC, 
     FECHA_INTERPOSICION_DEMANDA, 
     FECHA_JUNTA_ACREEDORES,                     
     FECHA_REGISTRAR_RESOLUCION_APERTURA_LIQUIDACION,  
     TRAMO_DIAS_AUTO_FASE_COMUN_A_DIA_ANALISIS_ID,
     TRAMO_DIAS_AUTO_FASE_COMUN_A_LIQUIDACION_ID,
     NUM_CONCURSOS,
     PLAZO_AUTO_FASE_COMUN_A_DIA_ANALISIS,
     PLAZO_AUTO_FASE_COMUN_A_LIQUIDACION, 
     PLAZO_PUBLICACION_BOE_A_INSINUACION_CREDITO, 
     PLAZO_AUTO_FASE_COMUN_A_AUTO_APERTURA_CONVENIO, 
     PLAZO_REGISTRAR_IAC_A_INTERPOSICION_DEMANDA, 
     PLAZO_AUTO_APERTURA_CONVENIO_A_JUNTA_ACREEDORES,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_DIRECTO,
     PLAZO_AUTO_FASE_COMUN_A_REG_RESOL_APERTURA_LIQUIDACION_CONVENIO
    from H_CONCURSO where DIA_ID = max_dia_anio;

end loop c_anio_loop;
close c_anio;


-- =========================================================================================================================================
--                  			DECLARATIVO (migrado a Lindorff)
-- OJO: porque aquí coexistiran el nuevo modelo de BPM con el anterior modelo
-- =========================================================================================================================================
truncate table TEMP_DECLARATIVO_JERARQUIA;
insert into TEMP_DECLARATIVO_JERARQUIA select * from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
	   where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
											join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
											where DD_TPO_DESCRIPCION = 'P. verbal' or DD_TPO_DESCRIPCION = 'P. ordinario' or
												  DD_TPO_DESCRIPCION = 'Procedimiento verbal' or DD_TPO_DESCRIPCION = 'Procedimiento ordinario' or
												  DD_TPO_DESCRIPCION = 'Procedimiento verbal desde Monitorio');
-- Bucle para las taras e inclusión en H_DECLARATIVO                                                                          
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;  
    
    -- ------------------ TAREAS ASOCIADAS -----------------------------------------------------------------------------
    -- Calculo las fechas de los hitos a medir
    truncate TEMP_DECLARATIVO_DETALLE;
    insert into TEMP_DECLARATIVO_DETALLE(ITER) select distinct ITER from  TEMP_DECLARATIVO_JERARQUIA WHERE DIA_ID = fecha;
        
    -- FECHA_INTERPOSICION_DEMANDA_DECLARATIVO - MODELO HIBRIDO ---------------------------------------------------------
    -- MODELO LINDORFF: TAP_ID: 10000000001231 P79_InterposicionDemanda / TAP_ID: 10000000001242 P80_InterposicionDemanda
	truncate table TEMP_DECLARATIVO_TAREA;
	insert into TEMP_DECLARATIVO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, BPM_DIP_NOMBRE, STR_TO_DATE(BPM_DIP_VALOR, '%d/%m/%YY')
        from TEMP_DECLARATIVO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
		join recovery_lindorff_datastage.ITA_INPUTS_TAREAS ita on tex.TEX_ID = ita.TEX_ID
		join recovery_lindorff_datastage.BPM_DIP_DATOS_INPUT dip on ita.BPM_IPT_ID = dip.BPM_IPT_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        BPM_DIP_NOMBRE in ('d_fecPresentacionDemanda') and tex.tap_id in (10000000001231, 10000000001242);

	-- MODELO GENÉRICO: TAP_ID: 301	P03_InterposicionDemanda (P. ordinario) / TAP_ID: 256	P04_InterposicionDemanda (P. verbal)
	if((select count(*) from TEMP_DECLARATIVO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE in ('fechainterposicion', 'fecha') and tex.tap_id in (301, 256)) > 0) then 	
    insert into TEMP_DECLARATIVO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_DECLARATIVO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE in ('fechainterposicion', 'fecha') and tex.tap_id in (301, 256);
    end if;

	update TEMP_DECLARATIVO_DETALLE cd set FECHA_INTERPOSICION_DEMANDA_DECLARATIVO = (select date(max(FECHA_FORMULARIO)) from TEMP_DECLARATIVO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_RESOLUCION_FIRME - MODELO HIBRIDO ---------------------------------------------------------
    -- MODELO LINDORFF: TAP_ID: 10000000001236 P79_ResolucionFirme / TAP_ID: 10000000001247 P80_ResolucionFirme / TAP_ID: 10000000001228 P78_ResolucionFirme
	truncate table TEMP_DECLARATIVO_TAREA;
	insert into TEMP_DECLARATIVO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, BPM_DIP_NOMBRE, STR_TO_DATE(BPM_DIP_VALOR, '%d/%m/%YY')
        from TEMP_DECLARATIVO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
		join recovery_lindorff_datastage.ITA_INPUTS_TAREAS ita on tex.TEX_ID = ita.TEX_ID
		join recovery_lindorff_datastage.BPM_DIP_DATOS_INPUT dip on ita.BPM_IPT_ID = dip.BPM_IPT_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        BPM_DIP_NOMBRE in ('d_fecResolucionSent') and tex.tap_id in (10000000001236, 10000000001247, 10000000001228);

	-- MODELO GENÉRICO: TAP_ID: 308	P03_ResolucionFirme (P. ordinario) / TAP_ID: 262	P04_ResolucionFirme (P. verbal)   
	if((select count(*) from TEMP_DECLARATIVO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (308, 262))>0) then	
	insert into TEMP_DECLARATIVO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_DECLARATIVO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (308, 262);
    end if;

	update TEMP_DECLARATIVO_DETALLE cd set FECHA_RESOLUCION_FIRME = (select date(max(FECHA_FORMULARIO)) from TEMP_DECLARATIVO_TAREA ct where cd.ITER = ct.ITER);
    
    -- Borrado de los días a insertar
    delete from H_DECLARATIVO where DIA_ID = fecha;

    -- Insertamos en H_DECLARATIVO sólo el registro que tiene la última actuación
    insert into H_DECLARATIVO
    (DIA_ID,                               
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO, 
     FECHA_RESOLUCION_FIRME,
     NUM_DECLARATIVOS,
     PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME
    )
    select fecha,                               
     ITER, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO,
     FECHA_RESOLUCION_FIRME,  
     1,
     datediff(FECHA_RESOLUCION_FIRME, FECHA_INTERPOSICION_DEMANDA_DECLARATIVO)  
    from TEMP_DECLARATIVO_DETALLE;
    end loop;
close c_fecha;


update H_DECLARATIVO set TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID = (case when PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME > 0 and PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME <= 30 then 0 
                                                                                             when PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME > 30 and PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME <= 60 then 1
                                                                                             when PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME > 60 and PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME <= 90 then 2
                                                                                             when PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME > 90 and PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME <= 120 then 3
                                                                                             when PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME > 120 and PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME <= 150 then 4
                                                                                             when PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME > 150 then 5
                                                                                             else -1 end); 
                                                                                             
-- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_DECLARATIVO);      
update H_DECLARATIVO set FECHA_CARGA_DATOS = max_dia_carga;

-- ----------------------------------------------------------------------------------------------
--                                      H_DECLARATIVO_MES
-- ----------------------------------------------------------------------------------------------
truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_DECLARATIVO where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_DECLARATIVO_MES where MES_ID = mes;

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_DECLARATIVO_MES
    (MES_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO, 
     FECHA_RESOLUCION_FIRME,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID,
     NUM_DECLARATIVOS,
     PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME
    )
    select mes,   
     max_dia_mes,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO, 
     FECHA_RESOLUCION_FIRME,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID,
     NUM_DECLARATIVOS,
     PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME
    from H_DECLARATIVO where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_DECLARATIVO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_DECLARATIVO_TRIMESTRE where TRIMESTRE_ID = trimestre; 

    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_DECLARATIVO_TRIMESTRE
    (TRIMESTRE_ID, 
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO, 
     FECHA_RESOLUCION_FIRME,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID,
     NUM_DECLARATIVOS,
     PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME
    )
    select trimestre, 
     max_dia_trimestre,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO, 
     FECHA_RESOLUCION_FIRME,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID,
     NUM_DECLARATIVOS,
     PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME
    from H_DECLARATIVO where DIA_ID = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_DECLARATIVO_ANIO
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_DECLARATIVO_ANIO where ANIO_ID = anio; 

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_DECLARATIVO_ANIO
    (ANIO_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO, 
     FECHA_RESOLUCION_FIRME,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID,
     NUM_DECLARATIVOS,
     PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME
    )
    select anio, 
     max_dia_anio,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_DECLARATIVO, 
     FECHA_RESOLUCION_FIRME,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME_ID,
     NUM_DECLARATIVOS,
     PLAZO_INTERPOSICION_DEMANDA_DECL_A_RESOLUCION_FIRME
    from H_DECLARATIVO where DIA_ID = max_dia_anio;

end loop c_anio_loop;
close c_anio;

*/

/*
-- =========================================================================================================================================
--                  					 EJECUCIONES (migrado a Lindorff)
-- OJO: porque aquí coexistiran el nuevo modelo de BPM con el anterior modelo
-- =========================================================================================================================================
truncate table TEMP_EJECUCION_ORDINARIA_JERARQUIA;
insert into TEMP_EJECUCION_ORDINARIA_JERARQUIA select * from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
                                               where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
                                                                                    join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                                                                                    where DD_TPO_DESCRIPCION = 'P. Ej. de título no judicial' or  DD_TPO_DESCRIPCION = 'P. Ej. de Título Judicial' or
																						  DD_TPO_DESCRIPCION = 'Ejecución Título No Judicial' or DD_TPO_DESCRIPCION = 'Ejecución Título Judicial' or
																						  DD_TPO_DESCRIPCION ='Trámite averiguación desde ETNJ' or DD_TPO_DESCRIPCION = 'Trámite averiguación por demandado' or
																						  DD_TPO_DESCRIPCION ='Trámite de oposición' or DD_TPO_DESCRIPCION = 'Trámite de embargo de bienes' or DD_TPO_DESCRIPCION = 'Trámite de embargo de salario');
-- Bucle para las taras e inclusión en H_EJECUCION_ORDINARIA                                                                          
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;  
    
    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    truncate TEMP_EJECUCION_ORDINARIA_DETALLE;
    insert into TEMP_EJECUCION_ORDINARIA_DETALLE(ITER) select distinct ITER from  TEMP_EJECUCION_ORDINARIA_JERARQUIA WHERE DIA_ID = fecha;
        
    -- FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA - MODELO HIBRIDO ---------------------------------------------------------
    -- MODELO LINDORFF: TAP_ID: 1 P76_ConfirmarInterposicionDemanda (ETNJ) / TAP_ID: 10000000001200 P72_ConfirmarInterposicionDemanda (ETJ) / TAP_ID: 10000000001228 P78_ResolucionFirme
    truncate table TEMP_EJECUCION_ORDINARIA_TAREA;
    insert into TEMP_EJECUCION_ORDINARIA_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID,BPM_DIP_NOMBRE, STR_TO_DATE(BPM_DIP_VALOR, '%d/%m/%YY')
        from TEMP_EJECUCION_ORDINARIA_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.ITA_INPUTS_TAREAS ita on tex.TEX_ID = ita.TEX_ID
		join recovery_lindorff_datastage.BPM_DIP_DATOS_INPUT dip on ita.BPM_IPT_ID = dip.BPM_IPT_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        BPM_DIP_NOMBRE in ('d_fecPresentacionDemanda') and tex.tap_id in (1, 10000000001200);

    -- MODELO GENÉRICO: TAP_ID:229	P16_InterposicionDemanda (P. Ej. de Título Judicial) / TAP_ID: 270	P15_InterposicionDemandaMasBienes (P. Ej. de título no judicial)
	if((select count(0) from TEMP_EJECUCION_ORDINARIA_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE in('fechaInterposicion', 'fecha') and tex.tap_id in (229, 270))>0) then
    insert into TEMP_EJECUCION_ORDINARIA_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_EJECUCION_ORDINARIA_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE in('fechaInterposicion', 'fecha') and tex.tap_id in (229, 270);
    end if;

	update TEMP_EJECUCION_ORDINARIA_DETALLE cd set FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA = (select date(max(FECHA_FORMULARIO)) from TEMP_EJECUCION_ORDINARIA_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_INICIO_APREMIO : NO NECESITAMOS MIGRARLO --------------------------------------------------------------
	-- MODELO GENÉRICO: Fecha de inicio de la fase T. certificación de cargas y revisión (DD_TPO_ID=26)
    truncate table TEMP_EJECUCION_ORDINARIA_TAREA;
    insert into TEMP_EJECUCION_ORDINARIA_TAREA (ITER, FASE, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, date(prc.FECHACREAR)
        from TEMP_EJECUCION_ORDINARIA_JERARQUIA tpj 
        join recovery_lindorff_datastage.PRC_PROCEDIMIENTOS prc on tpj.FASE_ACTUAL = prc.PRC_ID
        where  DIA_ID = fecha and  date(prc.FECHACREAR) <= fecha and prc.DD_TPO_ID=26 and prc.BORRADO=0;
    update TEMP_EJECUCION_ORDINARIA_DETALLE cd set FECHA_INICIO_APREMIO = (select date(max(FECHA_FORMULARIO)) from TEMP_EJECUCION_ORDINARIA_TAREA ct where cd.ITER = ct.ITER);    
    
        -- Borrado de los días a insertar
    delete from H_EJECUCION_ORDINARIA where DIA_ID = fecha;

    -- Insertamos en H_EJECUCION_ORDINARIA sólo el registro que tiene la última actuación
    insert into H_EJECUCION_ORDINARIA
    (DIA_ID,                               
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA, 
     FECHA_INICIO_APREMIO,
     NUM_EJECUCION_ORDINARIAS,
     PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO
    )
    select fecha,                               
     ITER,   
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA,
     FECHA_INICIO_APREMIO,  
     1,
     datediff(FECHA_INICIO_APREMIO, FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA)  
    from TEMP_EJECUCION_ORDINARIA_DETALLE;
    end loop;
close c_fecha;


update H_EJECUCION_ORDINARIA set TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID = (case when PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO > 0 and PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO <= 30 then 0 
                                                                                                  when PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO > 30 and PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO <= 60 then 1
                                                                                                  when PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO > 60 and PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO <= 90 then 2
                                                                                                  when PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO > 90 and PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO <= 120 then 3
                                                                                                  when PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO > 120 and PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO <= 150 then 4
                                                                                                  when PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO > 150 then 5
                                                                                                  else -1 end); 
   
 -- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_EJECUCION_ORDINARIA);      
update H_EJECUCION_ORDINARIA set FECHA_CARGA_DATOS = max_dia_carga;

-- ----------------------------------------------------------------------------------------------
--                                      H_EJECUCION_ORDINARIA_MES
-- ----------------------------------------------------------------------------------------------
truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_EJECUCION_ORDINARIA where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_EJECUCION_ORDINARIA_MES where MES_ID = mes;  

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_EJECUCION_ORDINARIA_MES
    (MES_ID, 
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA, 
     FECHA_INICIO_APREMIO,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID,
     NUM_EJECUCION_ORDINARIAS,
     PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO
    )
    select mes, 
     max_dia_mes,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA, 
     FECHA_INICIO_APREMIO,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID,
     NUM_EJECUCION_ORDINARIAS,
     PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO
    from H_EJECUCION_ORDINARIA where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJECUCION_ORDINARIA_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_EJECUCION_ORDINARIA_TRIMESTRE where TRIMESTRE_ID = trimestre;  
  
    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_EJECUCION_ORDINARIA_TRIMESTRE
    (TRIMESTRE_ID, 
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA, 
     FECHA_INICIO_APREMIO,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID,
     NUM_EJECUCION_ORDINARIAS,
     PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO
    )
    select trimestre, 
     max_dia_trimestre,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA, 
     FECHA_INICIO_APREMIO,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID,
     NUM_EJECUCION_ORDINARIAS,
     PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO
    from H_EJECUCION_ORDINARIA where DIA_ID = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJECUCION_ORDINARIA_ANIO
-- ----------------------------------------------------------------------------------------------

-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_EJECUCION_ORDINARIA_ANIO where ANIO_ID = anio; 

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_EJECUCION_ORDINARIA_ANIO
    (ANIO_ID, 
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA, 
     FECHA_INICIO_APREMIO,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID,
     NUM_EJECUCION_ORDINARIAS,
     PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO
    )
    select anio,  
     max_dia_anio,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_EJECUCION_ORDINARIA, 
     FECHA_INICIO_APREMIO,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO_ID,
     NUM_EJECUCION_ORDINARIAS,
     PLAZO_INTERPOSICION_DEMANDA_ORD_A_INICIO_APREMIO
    from H_EJECUCION_ORDINARIA where DIA_ID = max_dia_anio;

end loop c_anio_loop;
close c_anio;
*/

/*
-- =========================================================================================================================================
--                  			 HIPOTECARIO (migrado a Lindorff)
-- OJO: de momento y al no existir P.Hipotecario personalizado para Lindorff seguimos con el modelo genérico
-- =========================================================================================================================================
truncate table TEMP_HIPOTECARIO_JERARQUIA;
if((select count(*) from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
                                                where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
                                                                                     join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                                                                                     where DD_TPO_DESCRIPCION = 'P. hipotecario' or DD_TPO_DESCRIPCION='T. de Subasta' or DD_TPO_DESCRIPCION='T. de adjudicación' or DD_TPO_DESCRIPCION='T. de cesión de remate' ))>0) then

insert into TEMP_HIPOTECARIO_JERARQUIA select * from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
                                                where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
                                                                                     join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                                                                                     where DD_TPO_DESCRIPCION = 'P. hipotecario' or DD_TPO_DESCRIPCION='T. de Subasta' or DD_TPO_DESCRIPCION='T. de adjudicación' or DD_TPO_DESCRIPCION='T. de cesión de remate' );
-- Bucle para las taras e inclusión en H_HIPOTECARIO                                                                          
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;  
    
    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    truncate TEMP_HIPOTECARIO_DETALLE;
    insert into TEMP_HIPOTECARIO_DETALLE(ITER, ASUNTO) select distinct ITER, ASUNTO from TEMP_HIPOTECARIO_JERARQUIA WHERE DIA_ID = fecha;
    
    -- FECHA_CREACION_ASUNTO
    update TEMP_HIPOTECARIO_DETALLE set FECHA_CREACION_ASUNTO = (select date(FECHACREAR) from recovery_lindorff_datastage.ASU_ASUNTOS where ASU_ID = ASUNTO);    
    
    -- FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO
    -- TAP_ID: 240	P01_DemandaCertificacionCargas (P. hipotecario)
    truncate table TEMP_HIPOTECARIO_TAREA;
    insert into TEMP_HIPOTECARIO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_HIPOTECARIO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE in ('fechaSolicitud') and tex.tap_id in (240) 
        and tpj.FASE_FINALIZADA is null and tpj.FASE_PARALIZADA is null and tpj.FASE_CON_RECURSO is null;
    update TEMP_HIPOTECARIO_DETALLE cd set FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO = (select date(max(FECHA_FORMULARIO)) from TEMP_HIPOTECARIO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_CESION_REMATE
    -- TAP_ID: 10000000000702	P65_RealizacionCesionRemate
    truncate table TEMP_HIPOTECARIO_TAREA;
    insert into TEMP_HIPOTECARIO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_HIPOTECARIO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fecha' and tex.tap_id in (10000000000702) 
        and tpj.FASE_FINALIZADA is null and tpj.FASE_PARALIZADA is null and tpj.FASE_CON_RECURSO is null; 
    update TEMP_HIPOTECARIO_DETALLE cd set FECHA_CESION_REMATE = (select date(max(FECHA_FORMULARIO)) from TEMP_HIPOTECARIO_TAREA ct where cd.ITER = ct.ITER);
    
    -- FECHA_SUBASTA
    -- TAP_ID: 209	P11_AnuncioSubasta / TAP_ID: 801	P11_AnuncioSubasta_new1
    truncate table TEMP_HIPOTECARIO_TAREA;
    insert into TEMP_HIPOTECARIO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_HIPOTECARIO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fechaSubasta' and tex.tap_id in (209, 801) 
        and tpj.FASE_FINALIZADA is null and tpj.FASE_PARALIZADA is null and tpj.FASE_CON_RECURSO is null; 
    update TEMP_HIPOTECARIO_DETALLE cd set FECHA_SUBASTA = (select date(max(FECHA_FORMULARIO)) from TEMP_HIPOTECARIO_TAREA ct where cd.ITER = ct.ITER);
    
    
    -- FECHA_ADJUDICACION
    -- TAP_ID: 255 P05_RegistrarAutoAdjudicacion
    truncate table TEMP_HIPOTECARIO_TAREA;
    insert into TEMP_HIPOTECARIO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_HIPOTECARIO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE='fechaRegistro' and tex.tap_id in (255) 
        and tpj.FASE_FINALIZADA is null and tpj.FASE_PARALIZADA is null and tpj.FASE_CON_RECURSO is null; 
    update TEMP_HIPOTECARIO_DETALLE cd set FECHA_ADJUDICACION = (select date(max(FECHA_FORMULARIO)) from TEMP_HIPOTECARIO_TAREA ct where cd.ITER = ct.ITER);
    
    
    -- FASE SUBASTA - 0-Pendiente Interposición, 1-Demanda Presentada, 2-Subasta Solicitada, 3-Subasta Señalada, 4-Subasta Celebrada
    truncate table TEMP_HIPOTECARIO_TAREA;
    insert into TEMP_HIPOTECARIO_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID
        from TEMP_HIPOTECARIO_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        where  DIA_ID = fecha and  date(tar.TAR_FECHA_INI) <= fecha 
        and tex.tap_id in (240,
                           241, 242, 243, 244, 245, 208, 201, 202, 203, 204, 294, 295, 296, 297,
                           209, 801,
                           212, 10000000000703,
                           10000000000700, 10000000000701, 10000000000702,
                           10000000000705,
                           213, 214, 254, 255, 10000000000102, 10000000000103,
                           643, 644, 645, 646, 647, 648, 649, 650, 651,
                           652, 653, 654)
        and tpj.FASE_FINALIZADA is null and tpj.FASE_PARALIZADA is null and tpj.FASE_CON_RECURSO is null;
        
    -- Calculamos la fase con el TAP_ID de la última tarea de cada procedimiento
    update TEMP_HIPOTECARIO_DETALLE pd set FECHA_ULTIMA_TAREA_CREADA = (select max(FECHA_INI) from TEMP_HIPOTECARIO_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha and FECHA_INI is not null);
    update TEMP_HIPOTECARIO_DETALLE pd set ULTIMA_TAREA_CREADA = (select max(TAREA) from TEMP_HIPOTECARIO_TAREA tp where pd.ITER = tp.ITER and tp.FECHA_INI = pd.FECHA_ULTIMA_TAREA_CREADA);
    update TEMP_HIPOTECARIO_DETALLE pd set TAP_ID_ULTIMA_TAREA_CREADA = (select TAP_ID from TEMP_HIPOTECARIO_TAREA tp where pd.ITER = tp.ITER and tp.TAREA = pd.ULTIMA_TAREA_CREADA);
    
    update TEMP_HIPOTECARIO_DETALLE set FASE_SUBASTA = (case when TAP_ID_ULTIMA_TAREA_CREADA = 240 then 0 
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (241, 242, 243, 244, 245, 208, 201, 202, 203, 204, 294, 295, 296, 297) then 1
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (209, 801) then 2
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (212, 10000000000703) then 3
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000700, 10000000000701, 10000000000702) then 4
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000705) then 5
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (213, 214, 254, 255, 10000000000102, 10000000000103) then 6
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (643, 644, 645, 646, 647, 648, 649, 650, 651) then 7
                                                             when TAP_ID_ULTIMA_TAREA_CREADA in (652, 653, 654) then 8
                                                             else 9 end); 
   
    -- Borrado de los días a insertar
    delete from H_HIPOTECARIO where DIA_ID = fecha;
                                                            
    -- Insertamos en H_HIPOTECARIO sólo el registro que tiene la última actuación
    insert into H_HIPOTECARIO
    (DIA_ID,                               
     PROCEDIMIENTO_ID,
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO, 
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA_HIPOTECARIO_ID,
     NUM_HIPOTECARIOS,
     PLAZO_CREACION_ASUNTO_A_SUBASTA,
     PLAZO_CREACION_ASUNTO_A_CESION_REMATE,
     PLAZO_CREACION_ASUNTO_A_ADJUDICACION,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_CESION_REMATE,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_ADJUDICACION,
     PLAZO_SUBASTA_A_ADJUDICACION  
    )
    select fecha,                               
     ITER,   
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO,
     FECHA_SUBASTA, 
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA,
     1,
     datediff(FECHA_SUBASTA, FECHA_CREACION_ASUNTO),  
     datediff(FECHA_CESION_REMATE, FECHA_CREACION_ASUNTO),
     datediff(FECHA_ADJUDICACION, FECHA_CREACION_ASUNTO),
     datediff(FECHA_SUBASTA, FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO),  
     datediff(FECHA_CESION_REMATE, FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO),  
     datediff(FECHA_ADJUDICACION, FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO),
     datediff(FECHA_ADJUDICACION, FECHA_SUBASTA)  
    from TEMP_HIPOTECARIO_DETALLE;
    end loop;
close c_fecha;


update H_HIPOTECARIO set TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID = (case when PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA > 0 and PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA <= 30 then 0 
                                                                                   when PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA > 30 and PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA <= 60 then 1
                                                                                   when PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA > 60 and PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA <= 90 then 2
                                                                                   when PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA > 90 and PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA <= 120 then 3
                                                                                   when PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA > 120 and PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA <= 150 then 4
                                                                                   when PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA > 150 then 5
                                                                                   else -1 end); 
                                                                
 -- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_HIPOTECARIO);      
update H_HIPOTECARIO set FECHA_CARGA_DATOS = max_dia_carga;

-- ----------------------------------------------------------------------------------------------
--                                      H_HIPOTECARIO_MES
-- ----------------------------------------------------------------------------------------------
truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_HIPOTECARIO where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_HIPOTECARIO_MES where MES_ID = mes; 

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_HIPOTECARIO_MES
    (MES_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO, 
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA_HIPOTECARIO_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID,
     NUM_HIPOTECARIOS,
     PLAZO_CREACION_ASUNTO_A_SUBASTA,
     PLAZO_CREACION_ASUNTO_A_CESION_REMATE,
     PLAZO_CREACION_ASUNTO_A_ADJUDICACION,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_CESION_REMATE,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_ADJUDICACION,
     PLAZO_SUBASTA_A_ADJUDICACION 
    )
    select mes,   
     max_dia_mes,
     PROCEDIMIENTO_ID,
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO, 
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA_HIPOTECARIO_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID,
     NUM_HIPOTECARIOS,
     PLAZO_CREACION_ASUNTO_A_SUBASTA,
     PLAZO_CREACION_ASUNTO_A_CESION_REMATE,
     PLAZO_CREACION_ASUNTO_A_ADJUDICACION,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_CESION_REMATE,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_ADJUDICACION,
     PLAZO_SUBASTA_A_ADJUDICACION 
    from H_HIPOTECARIO where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_HIPOTECARIO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_HIPOTECARIO_TRIMESTRE where TRIMESTRE_ID = trimestre; 

    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_HIPOTECARIO_TRIMESTRE
    (TRIMESTRE_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO, 
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA_HIPOTECARIO_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID,
     NUM_HIPOTECARIOS,
     PLAZO_CREACION_ASUNTO_A_SUBASTA,
     PLAZO_CREACION_ASUNTO_A_CESION_REMATE,
     PLAZO_CREACION_ASUNTO_A_ADJUDICACION,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_CESION_REMATE,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_ADJUDICACION,
     PLAZO_SUBASTA_A_ADJUDICACION 
    )
    select trimestre,   
     max_dia_trimestre,
     PROCEDIMIENTO_ID, 
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO, 
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA_HIPOTECARIO_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID,
     NUM_HIPOTECARIOS,
     PLAZO_CREACION_ASUNTO_A_SUBASTA,
     PLAZO_CREACION_ASUNTO_A_CESION_REMATE,
     PLAZO_CREACION_ASUNTO_A_ADJUDICACION,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_CESION_REMATE,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_ADJUDICACION,
     PLAZO_SUBASTA_A_ADJUDICACION 
    from H_HIPOTECARIO where DIA_ID = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_HIPOTECARIO_ANIO
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_HIPOTECARIO_ANIO where ANIO_ID = anio; 

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_HIPOTECARIO_ANIO
    (ANIO_ID,    
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO, 
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA_HIPOTECARIO_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID,
     NUM_HIPOTECARIOS,
     PLAZO_CREACION_ASUNTO_A_SUBASTA,
     PLAZO_CREACION_ASUNTO_A_CESION_REMATE,
     PLAZO_CREACION_ASUNTO_A_ADJUDICACION,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_CESION_REMATE,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_ADJUDICACION,
     PLAZO_SUBASTA_A_ADJUDICACION 
    )
    select anio, 
     max_dia_anio,
     PROCEDIMIENTO_ID, 
     FECHA_CREACION_ASUNTO,
     FECHA_INTERPOSICION_DEMANDA_HIPOTECARIO, 
     FECHA_SUBASTA,
     FECHA_CESION_REMATE,
     FECHA_ADJUDICACION,
     FASE_SUBASTA_HIPOTECARIO_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_HIP_A_SUBASTA_ID,
     NUM_HIPOTECARIOS,
     PLAZO_CREACION_ASUNTO_A_SUBASTA,
     PLAZO_CREACION_ASUNTO_A_CESION_REMATE,
     PLAZO_CREACION_ASUNTO_A_ADJUDICACION,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_SUBASTA,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_CESION_REMATE,
     PLAZO_INTERPOSICION_DEMANDA_HIP_A_ADJUDICACION,
     PLAZO_SUBASTA_A_ADJUDICACION 
    from H_HIPOTECARIO where DIA_ID = max_dia_anio;

end loop c_anio_loop;
close c_anio;

end if;

*/


-- =========================================================================================================================================
--                                            				MONITORIO
-- =========================================================================================================================================
truncate table TEMP_MONITORIO_JERARQUIA;
insert into TEMP_MONITORIO_JERARQUIA select * from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
                                    where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
                                                                         join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                                                                         where DD_TPO_DESCRIPCION = 'P. Monitorio');
-- Bucle para las taras e inclusiOn en H_MONITORIO                                                                          
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;  
    
    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    truncate TEMP_MONITORIO_DETALLE;
    insert into TEMP_MONITORIO_DETALLE(ITER) select distinct ITER from  TEMP_MONITORIO_JERARQUIA WHERE DIA_ID = fecha;
        
    -- FECHA_INTERPOSICION_DEMANDA_MONITORIO
    truncate table TEMP_MONITORIO_RESOLUCION;
    insert into TEMP_MONITORIO_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_MONITORIO_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecPresentacionDemanda';

    update TEMP_MONITORIO_DETALLE md set FECHA_INTERPOSICION_DEMANDA_MONITORIO = (select date(max(FECHA_FORMULARIO)) from TEMP_MONITORIO_RESOLUCION tmpr where md.ITER = tmpr.ITER);


    -- FECHA_ADMISIÓN_DEMANDA
    truncate table TEMP_MONITORIO_RESOLUCION;
    insert into TEMP_MONITORIO_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_MONITORIO_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecRecepResolDemanda';

    update TEMP_MONITORIO_DETALLE md set FECHA_CONFIRMACION_ADMISION_DEMANDA = (select date(max(FECHA_FORMULARIO)) from TEMP_MONITORIO_RESOLUCION tmpr where md.ITER = tmpr.ITER);

    
    -- FECHA_CONFIRMACION_REQUERIMIENTO
    truncate table TEMP_MONITORIO_RESOLUCION;
    insert into TEMP_MONITORIO_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_MONITORIO_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecRecepResolReqPago';

    update TEMP_MONITORIO_DETALLE md set FECHA_CONFIRMACION_REQUERIMIENTO = (select date(max(FECHA_FORMULARIO)) from TEMP_MONITORIO_RESOLUCION tmpr where md.ITER = tmpr.ITER);
        
    
    -- FECHA_DECRETO_FINALIZACIZACION
    truncate table TEMP_MONITORIO_RESOLUCION;
    insert into TEMP_MONITORIO_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_MONITORIO_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecResolucionDecretoFinMon';

    update TEMP_MONITORIO_DETALLE md set FECHA_DECRETO_FINALIZACIZACION = (select date(max(FECHA_FORMULARIO)) from TEMP_MONITORIO_RESOLUCION tmpr where md.ITER = tmpr.ITER);
                
       
    -- Borrado de los días a insertar
    delete from H_MONITORIO where DIA_ID = fecha;    
    
    -- Insertamos en H_MONITORIO sólo el registro que tiene la última actuación
    insert into H_MONITORIO
    (DIA_ID,                               
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_MONITORIO, 
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     NUM_MONITORIOS,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION,
     PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO,
     PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION 
    )
    select fecha,                               
     ITER,   
     FECHA_INTERPOSICION_DEMANDA_MONITORIO, 
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     1,
     datediff(FECHA_CONFIRMACION_ADMISION_DEMANDA, FECHA_INTERPOSICION_DEMANDA_MONITORIO),
     datediff(FECHA_CONFIRMACION_REQUERIMIENTO, FECHA_INTERPOSICION_DEMANDA_MONITORIO),
     datediff(FECHA_CONFIRMACION_REQUERIMIENTO, FECHA_CONFIRMACION_ADMISION_DEMANDA),
     datediff(FECHA_DECRETO_FINALIZACIZACION, FECHA_CONFIRMACION_REQUERIMIENTO)
    from TEMP_MONITORIO_DETALLE;
    end loop;
close c_fecha;


update H_MONITORIO set TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID = (case when PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION > 0 and PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION <= 30 then 0 
                                                                                              when PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION > 30 and PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION <= 60 then 1
                                                                                              when PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION > 60 and PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION <= 90 then 2
                                                                                              when PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION > 90 and PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION <= 120 then 3
                                                                                              when PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION > 120 and PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION <= 150 then 4
                                                                                              when PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION > 150 then 5
                                                                                              else -1 end); 
    
update H_MONITORIO set TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID = (case when PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA > 0 and PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA <= 5 then 0 
                                                                                          when PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA > 5 and PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA <= 15 then 1
                                                                                          when PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA > 15 and PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA <= 30 then 2
                                                                                          when PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA > 30 and PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA <= 60 then 3
                                                                                          when PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA > 60 then 4
                                                                                          else -1 end); 


update H_MONITORIO set TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID = (case when PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO > 0 and PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO <= 5 then 0 
                                                                                  when PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO > 5 and PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO <= 15 then 1
                                                                                  when PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO > 15 and PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO <= 30 then 2
                                                                                  when PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO > 30 and PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO <= 60 then 3
                                                                                  when PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO > 60 then 4
                                                                                  else -1 end); 

update H_MONITORIO set TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID = (case when PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION > 0 and PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION <= 5 then 0 
                                                                                          when PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION > 5 and PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION <= 15 then 1
                                                                                          when PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION > 15 and PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION <= 30 then 2
                                                                                          when PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION > 30 and PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION <= 60 then 3
                                                                                          when PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION > 60 then 4
                                                                                          else -1 end); 


 -- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_MONITORIO);      
update H_MONITORIO set FECHA_CARGA_DATOS = max_dia_carga;

-- ----------------------------------------------------------------------------------------------
--                                      H_MONITORIO_MES
-- ----------------------------------------------------------------------------------------------
truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_MONITORIO where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_MONITORIO_MES where MES_ID = mes; 

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_MONITORIO_MES
    (MES_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_MONITORIO,
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID,
     TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID,
     TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID,
     NUM_MONITORIOS,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION,
     PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO,
     PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION
    )
    select mes,  
     max_dia_mes,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_MONITORIO,
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID,
     TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID,
     TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID,
     NUM_MONITORIOS,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION,
     PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO,
     PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION
    from H_MONITORIO where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_MONITORIO_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_MONITORIO_TRIMESTRE where TRIMESTRE_ID = trimestre; 

    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_MONITORIO_TRIMESTRE
    (TRIMESTRE_ID, 
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_MONITORIO,
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID,
     TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID,
     TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID,
     NUM_MONITORIOS,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION,
     PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO,
     PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION
    )
    select trimestre, 
     max_dia_trimestre,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_MONITORIO,
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID,
     TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID,
     TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID,
     NUM_MONITORIOS,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION,
     PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO,
     PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION
    from H_MONITORIO where DIA_ID = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_MONITORIO_ANIO
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_MONITORIO_ANIO where ANIO_ID = anio; 

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_MONITORIO_ANIO
    (ANIO_ID,    
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_MONITORIO,
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID,
     TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID,
     TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID,
     NUM_MONITORIOS,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION,
     PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO,
     PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION
    )
    select anio,   
     max_dia_anio,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_MONITORIO,
     FECHA_CONFIRMACION_ADMISION_DEMANDA,
     FECHA_CONFIRMACION_REQUERIMIENTO,
     FECHA_DECRETO_FINALIZACIZACION,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA_ID,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION_ID,
     TRAMO_DIAS_ADMISION_DEMANDA_MON_A_REQUERIMIENTO_ID,
     TRAMO_DIAS_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION_ID,
     NUM_MONITORIOS,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_ADMISION_DEMANDA,
     PLAZO_INTERPOSICION_DEMANDA_MON_A_DECRETO_FINALIZACION,
     PLAZO_ADMISION_DEMANDA_MON_A_REQUERIMIENTO,
     PLAZO_REQUERIMIENTO_MON_A_DECRETO_FINALIZACIZACION
    from H_MONITORIO where DIA_ID = max_dia_anio;

end loop c_anio_loop;
close c_anio; 


-- =========================================================================================================================================
--                                            				ETJ
-- =========================================================================================================================================
truncate table TEMP_ETJ_JERARQUIA;
insert into TEMP_ETJ_JERARQUIA select * from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
                                    where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
                                                                         join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                                                                         where DD_TPO_DESCRIPCION = 'Ejecución Título Judicial');
-- Bucle para las taras e inclusiOn en H_ETJ                                                                          
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;  
    
    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    truncate TEMP_ETJ_DETALLE;
    insert into TEMP_ETJ_DETALLE(ITER) select distinct ITER from  TEMP_ETJ_JERARQUIA WHERE DIA_ID = fecha;
        
    -- FECHA_INTERPOSICION_DEMANDA_ETJ
    truncate table TEMP_ETJ_RESOLUCION;
    insert into TEMP_ETJ_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_ETJ_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecPresentacionDemanda';

    update TEMP_ETJ_DETALLE etjd set FECHA_INTERPOSICION_DEMANDA_ETJ = (select date(max(FECHA_FORMULARIO)) from TEMP_ETJ_RESOLUCION tmpr where etjd.ITER = tmpr.ITER);


    -- FECHA_AUTO_ETJ
    truncate table TEMP_ETJ_RESOLUCION;
    insert into TEMP_ETJ_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_ETJ_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecRecepResolAude';

    update TEMP_ETJ_DETALLE etjd set FECHA_AUTO_ETJ = (select date(max(FECHA_FORMULARIO)) from TEMP_ETJ_RESOLUCION tmpr where etjd.ITER = tmpr.ITER);

    
    -- FECHA_NOTIFICACION_ETJ
    truncate table TEMP_ETJ_RESOLUCION;
    insert into TEMP_ETJ_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_ETJ_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecRecepResolReqPago';

    update TEMP_ETJ_DETALLE etjd set FECHA_NOTIFICACION_ETJ = (select date(max(FECHA_FORMULARIO)) from TEMP_ETJ_RESOLUCION tmpr where etjd.ITER = tmpr.ITER);
        
    
    -- FECHA_COBRO_ETJ
    truncate table TEMP_ETJ_RESOLUCION;
    insert into TEMP_ETJ_RESOLUCION (ITER, FASE, BPM_GVA_ID, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, gva.BPM_GVA_ID, STR_TO_DATE(gva.BPM_GVA_VALOR, '%d/%m/%YY') 
        from TEMP_ETJ_JERARQUIA tpj
        join recovery_lindorff_datastage.BPM_GVA_GRUPOS_VALORES gva on tpj.FASE_ACTUAL = gva.PRC_ID
        where DIA_ID = fecha and date(gva.FECHACREAR) <= fecha and gva.BORRADO = 0 and BPM_GVA_NOMBRE_DATO = 'fecRecepResolConsignaTotal';

    update TEMP_ETJ_DETALLE etjd set FECHA_COBRO_ETJ = (select date(max(FECHA_FORMULARIO)) from TEMP_ETJ_RESOLUCION tmpr where etjd.ITER = tmpr.ITER);
                
       
    -- Borrado de los días a insertar
    delete from H_ETJ where DIA_ID = fecha;    
    
    -- Insertamos en H_ETJ sólo el registro que tiene la última actuación
    insert into H_ETJ
    (DIA_ID,                               
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ, 
     FECHA_NOTIFICACION_ETJ, 
     FECHA_COBRO_ETJ,
     NUM_ETJS,
     PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO,
     PLAZO_AUTO_ETJ_A_NOTIFICACION,
     PLAZO_NOTIFICACION_ETJ_A_COBRO  
    )
    select fecha,                               
     ITER,   
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ, 
     FECHA_NOTIFICACION_ETJ, 
     FECHA_COBRO_ETJ,
     1,
     datediff(FECHA_AUTO_ETJ, FECHA_INTERPOSICION_DEMANDA_ETJ),
     datediff(FECHA_NOTIFICACION_ETJ, FECHA_AUTO_ETJ),
     datediff(FECHA_COBRO_ETJ, FECHA_NOTIFICACION_ETJ)
    from TEMP_ETJ_DETALLE;
    end loop;
close c_fecha;




update H_ETJ set TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID = (case when PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO > 0 and PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO <= 30 then 0 
                                                                        when PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO > 30 and PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO <= 60 then 1
                                                                        when PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO > 60 and PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO <= 90 then 2
                                                                        when PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO > 90 and PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO <= 120 then 3
                                                                        when PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO > 120 and PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO <= 150 then 4
                                                                        when PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO > 150 then 5
                                                                        else -1 end); 
    
update H_ETJ set TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID = (case when PLAZO_AUTO_ETJ_A_NOTIFICACION > 0 and PLAZO_AUTO_ETJ_A_NOTIFICACION <= 5 then 0 
                                                               when PLAZO_AUTO_ETJ_A_NOTIFICACION > 5 and PLAZO_AUTO_ETJ_A_NOTIFICACION <= 15 then 1
                                                               when PLAZO_AUTO_ETJ_A_NOTIFICACION > 15 and PLAZO_AUTO_ETJ_A_NOTIFICACION <= 30 then 2
                                                               when PLAZO_AUTO_ETJ_A_NOTIFICACION > 30 and PLAZO_AUTO_ETJ_A_NOTIFICACION <= 60 then 3
                                                               when PLAZO_AUTO_ETJ_A_NOTIFICACION > 60 then 4
                                                               else -1 end); 


update H_ETJ set TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID = (case when PLAZO_NOTIFICACION_ETJ_A_COBRO > 0 and PLAZO_NOTIFICACION_ETJ_A_COBRO <= 5 then 0 
                                                                when PLAZO_NOTIFICACION_ETJ_A_COBRO > 5 and PLAZO_NOTIFICACION_ETJ_A_COBRO <= 15 then 1
                                                                when PLAZO_NOTIFICACION_ETJ_A_COBRO > 15 and PLAZO_NOTIFICACION_ETJ_A_COBRO <= 30 then 2
                                                                when PLAZO_NOTIFICACION_ETJ_A_COBRO > 30 and PLAZO_NOTIFICACION_ETJ_A_COBRO <= 60 then 3
                                                                when PLAZO_NOTIFICACION_ETJ_A_COBRO > 60 then 4
                                                                else -1 end); 

 -- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_ETJ);      
update H_ETJ set FECHA_CARGA_DATOS = max_dia_carga;

-- ----------------------------------------------------------------------------------------------
--                                      H_ETJ_MES
-- ----------------------------------------------------------------------------------------------
truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_ETJ where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_ETJ_MES where MES_ID = mes; 

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_ETJ_MES
    (MES_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ,
     FECHA_NOTIFICACION_ETJ,
     FECHA_COBRO_ETJ,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID,
     TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID,
     TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID,
     NUM_ETJS,
     PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO,
     PLAZO_AUTO_ETJ_A_NOTIFICACION,
     PLAZO_NOTIFICACION_ETJ_A_COBRO
    )
    select mes,  
     max_dia_mes,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ,
     FECHA_NOTIFICACION_ETJ,
     FECHA_COBRO_ETJ,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID,
     TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID,
     TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID,
     NUM_ETJS,
     PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO,
     PLAZO_AUTO_ETJ_A_NOTIFICACION,
     PLAZO_NOTIFICACION_ETJ_A_COBRO
    from H_ETJ where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_ETJ_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_ETJ_TRIMESTRE where TRIMESTRE_ID = trimestre; 

    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_ETJ_TRIMESTRE
    (TRIMESTRE_ID, 
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ,
     FECHA_NOTIFICACION_ETJ,
     FECHA_COBRO_ETJ,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID,
     TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID,
     TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID,
     NUM_ETJS,
     PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO,
     PLAZO_AUTO_ETJ_A_NOTIFICACION,
     PLAZO_NOTIFICACION_ETJ_A_COBRO
    )
    select trimestre, 
     max_dia_trimestre,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ,
     FECHA_NOTIFICACION_ETJ,
     FECHA_COBRO_ETJ,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID,
     TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID,
     TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID,
     NUM_ETJS,
     PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO,
     PLAZO_AUTO_ETJ_A_NOTIFICACION,
     PLAZO_NOTIFICACION_ETJ_A_COBRO
    from H_ETJ where DIA_ID = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_ETJ_ANIO
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_ETJ_ANIO where ANIO_ID = anio; 

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_ETJ_ANIO
    (ANIO_ID,    
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ,
     FECHA_NOTIFICACION_ETJ,
     FECHA_COBRO_ETJ,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID,
     TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID,
     TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID,
     NUM_ETJS,
     PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO,
     PLAZO_AUTO_ETJ_A_NOTIFICACION,
     PLAZO_NOTIFICACION_ETJ_A_COBRO
    )
    select anio,   
     max_dia_anio,
     PROCEDIMIENTO_ID, 
     FECHA_INTERPOSICION_DEMANDA_ETJ,
     FECHA_AUTO_ETJ,
     FECHA_NOTIFICACION_ETJ,
     FECHA_COBRO_ETJ,
     TRAMO_DIAS_INTERPOSICION_DEMANDA_ETJ_A_AUTO_ID,
     TRAMO_DIAS_AUTO_ETJ_A_NOTIFICACION_ID,
     TRAMO_DIAS_NOTIFICACION_ETJ_A_COBRO_ID,
     NUM_ETJS,
     PLAZO_INTERPOSICION_DEMANDA_ETJ_A_AUTO,
     PLAZO_AUTO_ETJ_A_NOTIFICACION,
     PLAZO_NOTIFICACION_ETJ_A_COBRO
    from H_ETJ where DIA_ID = max_dia_anio;

end loop c_anio_loop;
close c_anio; 

/*
-- =========================================================================================================================================
--                  			 EJECUCION_NOTARIAL (migrado a Lindorff)
-- OJO: no existe personalización para Lindorff así que se queda con el modelo genérico
-- =========================================================================================================================================
truncate table TEMP_EJECUCION_NOTARIAL_JERARQUIA;

if((select count(*) from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
		where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
											 join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
											 where DD_TPO_DESCRIPCION = 'T. de ejecución notarial'))>0) then 

insert into TEMP_EJECUCION_NOTARIAL_JERARQUIA select * from TEMP_PROCEDIMIENTO_ESPECIFICO_JERARQUIA 
                                                where TIPO_PROCEDIMIENTO_DETALLE in (select DD_TPO_ID from recovery_lindorff_datastage.DD_TPO_TIPO_PROCEDIMIENTO tp
                                                                                     join recovery_lindorff_datastage.DD_TAC_TIPO_ACTUACION ta on tp.DD_TAC_ID = ta.DD_TAC_ID
                                                                                     where DD_TPO_DESCRIPCION = 'T. de ejecución notarial');
 
-- Bucle para las taras e inclusión en H_EJECUCION_NOTARIAL                                                                          
set l_last_row = 0; 
open c_fecha;
read_loop: loop
fetch c_fecha into fecha;        
    if (l_last_row=1) then leave read_loop; 
    end if;  
    
    -- ------------------ TAREAS ASOCIADAS -----------------------------
    -- Calculo las fechas de los hitos a medir
    truncate TEMP_EJECUCION_NOTARIAL_DETALLE;
    insert into TEMP_EJECUCION_NOTARIAL_DETALLE(ITER) select distinct ITER from TEMP_EJECUCION_NOTARIAL_JERARQUIA WHERE DIA_ID = fecha;
        
    -- FECHA_SUBASTA_EJECUCION_NOTARIAL
    -- TAP_ID: 10000000000906	P95_registrarAnuncioSubasta	
    truncate table TEMP_EJECUCION_NOTARIAL_TAREA;
    insert into TEMP_EJECUCION_NOTARIAL_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID, DESCRIPCION_FORMULARIO, FECHA_FORMULARIO) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID, TEV_NOMBRE, date(TEV_VALOR)
        from TEMP_EJECUCION_NOTARIAL_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        join recovery_lindorff_datastage.TEV_TAREA_EXTERNA_VALOR tev on tex.TEX_ID = tev.TEX_ID
        where  DIA_ID = fecha and tar.TAR_FECHA_FIN is not null and date(tar.TAR_FECHA_FIN) <= fecha and -- tar.BORRADO=0 and
        tev.TEV_NOMBRE in('fechaSubasta', 'fechaSubasta2', 'fechaSubasta3') and tex.tap_id in (10000000000906) 
        and tpj.FASE_FINALIZADA is null and tpj.FASE_PARALIZADA is null and tpj.FASE_CON_RECURSO is null;
    update TEMP_EJECUCION_NOTARIAL_DETALLE cd set FECHA_SUBASTA_EJECUCION_NOTARIAL = (select date(max(FECHA_FORMULARIO)) from TEMP_EJECUCION_NOTARIAL_TAREA ct where cd.ITER = ct.ITER);

    -- FASE SUBASTA - 0	Demanda Presentada - 1 Subasta Solicitada - 2 Subasta Señalada -3 Subasta Celebrada: Pendiente Cesión de remate - 4 Subasta Celebrada: Con Cesión de Remate - 5 Subasta Celebrada: Pendiente Adjudicación - 6 Otros
    truncate table TEMP_EJECUCION_NOTARIAL_TAREA;
    insert into TEMP_EJECUCION_NOTARIAL_TAREA (ITER, FASE, TAREA, DESCRIPCION_TAREA, FECHA_INI, FECHA_FIN, TAP_ID, TAR_ID, TEX_ID) 
    select  tpj.ITER, tpj.FASE_ACTUAL, tar.TAR_ID, tar.TAR_TAREA, tar.TAR_FECHA_INI, tar.TAR_FECHA_FIN ,TAP_ID,tar.TAR_ID,tex.TEX_ID
        from TEMP_EJECUCION_NOTARIAL_JERARQUIA tpj
        join recovery_lindorff_datastage.TAR_TAREAS_NOTIFICACIONES tar on tpj.FASE_ACTUAL = tar.PRC_ID 
        join recovery_lindorff_datastage.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
        where  DIA_ID = fecha and  date(tar.TAR_FECHA_INI) <= fecha 
        and tex.tap_id in (10000000000900, 10000000000901, 10000000000902, 10000000000903, 10000000000904, 10000000000905, 
                           10000000000906, 10000000000907, 10000000000908,
                           10000000000909, 10000000000910, 10000000000911,
                           10000000000913,
                           10000000000912, 10000000000914,
                           10000000000915
                           ) and tpj.FASE_FINALIZADA is null and tpj.FASE_PARALIZADA is null and tpj.FASE_CON_RECURSO is null;
                           
    -- Calculamos la fase con el TAP_ID de la última tarea de cada procedimiento
    update TEMP_EJECUCION_NOTARIAL_DETALLE pd set FECHA_ULTIMA_TAREA_CREADA = (select max(FECHA_INI) from TEMP_EJECUCION_NOTARIAL_TAREA tp where pd.ITER = tp.ITER and date(tp.FECHA_INI) <= fecha and FECHA_INI is not null);
    update TEMP_EJECUCION_NOTARIAL_DETALLE pd set ULTIMA_TAREA_CREADA = (select max(TAREA) from TEMP_EJECUCION_NOTARIAL_TAREA tp where pd.ITER = tp.ITER and tp.FECHA_INI = pd.FECHA_ULTIMA_TAREA_CREADA);
    update TEMP_EJECUCION_NOTARIAL_DETALLE pd set TAP_ID_ULTIMA_TAREA_CREADA = (select TAP_ID from TEMP_EJECUCION_NOTARIAL_TAREA tp where pd.ITER = tp.ITER and tp.TAREA = pd.ULTIMA_TAREA_CREADA);
    
    update TEMP_EJECUCION_NOTARIAL_DETALLE set FASE_SUBASTA = (case when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000900, 10000000000901, 10000000000902, 10000000000903, 10000000000904, 10000000000905) then 0
                                                                    when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000906, 10000000000907, 10000000000908) then 1
                                                                    when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000907, 10000000000908, 10000000000909, 10000000000910, 10000000000911) then 2
                                                                    when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000913) then 3
                                                                    when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000912, 10000000000914) then 4
                                                                    when TAP_ID_ULTIMA_TAREA_CREADA in (10000000000915) then 5
                                                                    else 9 end); 
   
    -- Borrado de los días a insertar
    delete from H_EJECUCION_NOTARIAL where DIA_ID = fecha;
                                                            
    -- Insertamos en H_EJECUCION_NOTARIAL sólo el registro que tiene la última actuación
    insert into H_EJECUCION_NOTARIAL
    (DIA_ID,                               
     PROCEDIMIENTO_ID, 
     FECHA_SUBASTA_EJECUCION_NOTARIAL,
     FASE_SUBASTA_EJECUCION_NOTARIAL_ID,
     NUM_EJECUCIONES_NOTARIALES
    )
    select fecha,                               
     ITER,   
     FECHA_SUBASTA_EJECUCION_NOTARIAL, 
     FASE_SUBASTA,
     1
    from TEMP_EJECUCION_NOTARIAL_DETALLE;
    end loop;
close c_fecha;

                                                                
 -- Incluimos el último día cargado
set max_dia_carga = (select max(DIA_ID) from H_EJECUCION_NOTARIAL);      
update H_EJECUCION_NOTARIAL set FECHA_CARGA_DATOS = max_dia_carga;

-- ----------------------------------------------------------------------------------------------
--                                      H_EJECUCION_NOTARIAL_MES
-- ----------------------------------------------------------------------------------------------
truncate table TEMP_FECHA;
insert into TEMP_FECHA (DIA_H) select distinct DIA_ID from H_EJECUCION_NOTARIAL where DIA_ID between date_start and date_end;
update TEMP_FECHA set MES_H = (select MES_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set TRIMESTRE_H = (select TRIMESTRE_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);
update TEMP_FECHA set ANIO_H = (select ANIO_ID from DIM_FECHA_DIA fecha WHERE DIA_H = DIA_ID);

-- Bucle que recorre los meses
set l_last_row = 0; 
open c_meses;
c_meses_loop: loop
fetch c_meses INTO mes;        
    IF (l_last_row=1) THEN LEAVE c_meses_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_EJECUCION_NOTARIAL_MES where MES_ID = mes;

    set max_dia_mes = (select max(DIA_H) from TEMP_FECHA where MES_H = mes);
    insert into H_EJECUCION_NOTARIAL_MES
    (MES_ID,  
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_SUBASTA_EJECUCION_NOTARIAL,
     FASE_SUBASTA_EJECUCION_NOTARIAL_ID,
     NUM_EJECUCIONES_NOTARIALES
    )
    select mes,     
     max_dia_mes,
     PROCEDIMIENTO_ID, 
     FECHA_SUBASTA_EJECUCION_NOTARIAL,
     FASE_SUBASTA_EJECUCION_NOTARIAL_ID,
     NUM_EJECUCIONES_NOTARIALES
    from H_EJECUCION_NOTARIAL where DIA_ID = max_dia_mes;
    
end loop c_meses_loop;
close c_meses;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJECUCION_NOTARIAL_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los trimestres
set l_last_row = 0; 
open c_trimestre;
c_trimestre_loop: loop
fetch c_trimestre INTO trimestre;        
    IF (l_last_row=1) THEN LEAVE c_trimestre_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_EJECUCION_NOTARIAL_TRIMESTRE where TRIMESTRE_ID = trimestre; 

    set max_dia_trimestre = (select max(DIA_H) from TEMP_FECHA where TRIMESTRE_H = trimestre);
    insert into H_EJECUCION_NOTARIAL_TRIMESTRE
    (TRIMESTRE_ID,
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_SUBASTA_EJECUCION_NOTARIAL,
     FASE_SUBASTA_EJECUCION_NOTARIAL_ID,
     NUM_EJECUCIONES_NOTARIALES
    )
    select trimestre,   
     max_dia_trimestre,
     PROCEDIMIENTO_ID, 
     FECHA_SUBASTA_EJECUCION_NOTARIAL,
     FASE_SUBASTA_EJECUCION_NOTARIAL_ID,
     NUM_EJECUCIONES_NOTARIALES
     from H_EJECUCION_NOTARIAL where DIA_ID = max_dia_trimestre;

end loop c_trimestre_loop;
close c_trimestre;


-- ----------------------------------------------------------------------------------------------
--                                      H_EJECUCION_NOTARIAL_ANIO
-- ----------------------------------------------------------------------------------------------
-- Bucle que recorre los años
set l_last_row = 0; 
open c_anio;
c_anio_loop: loop
fetch c_anio INTO anio;        
    IF (l_last_row=1) THEN LEAVE c_anio_loop;        
    END IF;

    -- Borrado de los meses a insertar
    delete from H_EJECUCION_NOTARIAL_ANIO where ANIO_ID = anio; 

    set max_dia_anio = (select max(DIA_H) from TEMP_FECHA where ANIO_H = anio);
    insert into H_EJECUCION_NOTARIAL_ANIO
    (ANIO_ID,       
     FECHA_CARGA_DATOS,
     PROCEDIMIENTO_ID, 
     FECHA_SUBASTA_EJECUCION_NOTARIAL,
     FASE_SUBASTA_EJECUCION_NOTARIAL_ID,
     NUM_EJECUCIONES_NOTARIALES
    )
    select anio,   
     max_dia_anio,
     PROCEDIMIENTO_ID, 
     FECHA_SUBASTA_EJECUCION_NOTARIAL,
     FASE_SUBASTA_EJECUCION_NOTARIAL_ID,
     NUM_EJECUCIONES_NOTARIALES
    from H_EJECUCION_NOTARIAL where DIA_ID = max_dia_anio;

end loop c_anio_loop;
close c_anio;

end if;

*/
END MY_BLOCK_H_PRC_ESP