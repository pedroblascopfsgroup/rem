create or replace PROCEDURE CARGAR_H_TAREA (DATE_START in DATE, DATE_END in DATE, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Febrero 2014
-- Responsable ultima modificacion: Gonzalo Martín, PFS Group
-- Fecha ultima modificacion: 16/12/2015
-- Motivos del cambio:  EXPEDIENTE_ID
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos Tareas.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaración de variables
-- ===============================================================================================
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_SQL VARCHAR2(16000);

  max_dia_semana date;
  max_dia_mes date;
  max_dia_trimestre date;
  max_dia_anio date;
  max_dia_pre_start date;
  existe_date_start int;
  
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_rellenar date;
  max_dia_carga date;
  
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_TAREA';
  V_ROWcount NUMBER;
  nCount NUMBER;
  V_NUMBER  NUMBER(16,0);
  
  cursor c_fecha_rellenar is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_fecha is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA order by 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END order by 1; 

-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  INSERT_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(INSERT_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);

BEGIN

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';

-- ----------------------------------------------------------------------------------------------
--                                      H_TAR
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR. Empieza Carga', 3;
  
  -- Borrado indices TMP_TAR_JERARQUIA 
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_TAR_JRQ_FASE_ACT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
      
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_TAR_JERARQUIA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- Si DATE_START no existe en PRC_PROCEDIMIENTOS_JERARQUIA cogemos la última anterior que haya en PRC_PROCEDIMIENTOS_JERARQUIA
  execute immediate 'select count(1) from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO = '''||DATE_START||'''' into existe_date_start;
  
  if(existe_date_start = 0) then
    execute immediate 'select max(FECHA_PROCEDIMIENTO) from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO <= '''||DATE_START||'''' into max_dia_pre_start;

	execute immediate 'insert into TMP_TAR_JERARQUIA 
                            (DIA_ID,
                             ITER,
                             FASE_ACTUAL) 
                      select '''||DATE_START||''',
                             PJ_PADRE,
                             PRC_ID
                      from ' || V_DATASTAGE || '.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO = '''||max_dia_pre_start||'''';
  commit;
  end if;
	
  execute immediate 'insert into TMP_TAR_JERARQUIA 
                            (DIA_ID,
                             ITER,
                             FASE_ACTUAL) 
                      select FECHA_PROCEDIMIENTO,
                             PJ_PADRE,
                             PRC_ID
                      from ' || V_DATASTAGE || '.PRC_PROCEDIMIENTOS_JERARQUIA where FECHA_PROCEDIMIENTO between ''' || DATE_START || ''' and ''' || DATE_END || '''';
  commit;
  
  -- Rellenar los días que no tienen entradas de procedimientos. No ha existido ningún movimiento. La foto es la del día anterior.
  open c_fecha_rellenar;
  loop -- RELLENAR_loop
    fetch c_fecha_rellenar into fecha_rellenar;        
    exit when c_fecha_rellenar%NOTFOUND;          
      -- Si un día no ha habido movimiento copiamos dia anterior
      select count(DIA_ID) into V_NUM_ROW from TMP_TAR_JERARQUIA where DIA_ID = fecha_rellenar;
      if(V_NUM_ROW = 0) then 
        insert into TMP_TAR_JERARQUIA
            (DIA_ID,
             ITER, 
             FASE_ACTUAL)
        select DIA_ID + 1, 
               ITER, 
               FASE_ACTUAL
        from TMP_TAR_JERARQUIA where DIA_ID = fecha_rellenar - 1;
        commit; 
      end if; 
  end loop;
  close c_fecha_rellenar;    
  
  -- Crear indices TMP_TAR_JERARQUIA
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_TAR_JRQ_FASE_ACT_IX'', ''TMP_TAR_JERARQUIA (DIA_ID, FASE_ACTUAL)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;   
  
  
  open c_fecha;
  loop  -- READ_loop
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;
    
    -- Borrado indices H_TAR 
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_VENC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_FASE_ACTUAL_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    -- Borrado de los días a insertar
    delete from H_TAR where DIA_ID = fecha;
    commit; 
    
    execute immediate 'insert into H_TAR 
                              (DIA_ID,
                               FECHA_CARGA_DATOS, 
                               TAREA_ID,
                               EXPEDIENTE_ID,
                               FASE_ACTUAL_PROCEDIMIENTO,
                               ASUNTO_ID,
                               FECHA_CREACION_TAREA, 
                               FECHA_VENC_ORIGINAL_TAREA,
                               FECHA_VENCIMIENTO_TAREA,
                               FECHA_FIN_TAREA,
                               ESTADO_TAREA_ID,
                               RESPONSABLE_TAREA_ID,
                               NUM_TAREAS, 
                               NUM_DIAS_VENCIDO
                               )
                        select ''' || fecha || ''',
                               ''' || fecha || ''', 
                               tar.TAR_ID, 
                               tar.EXP_ID,
                               tar.PRC_ID,
                               tar.ASU_ID,  
                               trunc(TAR_FECHA_INI),
                               trunc(TAR_FECHA_VENC_REAL),
                               trunc(TAR_FECHA_VENC),
                               trunc(TAR_FECHA_FIN),
                               (case when TAR_FECHA_FIN is null then 0 else 1 end),
                               TAP_SUPERVISOR, 
                               1, 
                               trunc(TAR_FECHA_VENC) - trunc(TAR_FECHA_FIN)
                        from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES tar 
                        left join '||V_DATASTAGE||'.TEX_TAREA_EXTERNA tex on tar.TAR_ID = tex.TAR_ID
                        left join '||V_DATASTAGE||'.TAP_TAREA_PROCEDIMIENTO tap on tex.TAP_ID = tap.TAP_ID
                        where trunc(TAR.TAR_FECHA_INI) <= ''' || fecha || '''';
    commit; 
    
    -- Crear indices H_TAR   
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_IX'', ''H_TAR (DIA_ID, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 
  
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_VENC_IX'', ''H_TAR (DIA_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_PRC_IX'', ''H_TAR (DIA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_FASE_ACTUAL_PRC_IX'', ''H_TAR (DIA_ID, FASE_ACTUAL_PROCEDIMIENTO)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 
  
    --Update de  EXPEDIENTE_ID
    merge into H_TAR tar using (select DIA_ID, ITER, FASE_ACTUAL from TMP_TAR_JERARQUIA where DIA_ID = fecha) ttj
      on (tar.DIA_ID = fecha and tar.FASE_ACTUAL_PROCEDIMIENTO = ttj.FASE_ACTUAL)   
      when matched then update set tar.PROCEDIMIENTO_ID = ttj.ITER where tar.DIA_ID = fecha;
    commit;
    -- Borramos las tareas de procedimientos borrados (No existen en Recovery)
    execute immediate 'delete from H_TAR where DIA_ID = ''' || fecha || ''' and FASE_ACTUAL_PROCEDIMIENTO in (select PRC_ID from '||V_DATASTAGE||'.PRC_PROCEDIMIENTOS where BORRADO = 1)';
    commit;
    
    -- 0	Pendiente / 1	Finalizada
    update H_TAR set CUMPLIMIENTO_TAREA_ID = (case when (fecha - FECHA_VENCIMIENTO_TAREA) <= 0 then 0
                                                   when (fecha - FECHA_VENCIMIENTO_TAREA) > 0 then 1
                                                   when FECHA_VENCIMIENTO_TAREA is null then -2
                                                   else -1 end) where DIA_ID = fecha and ESTADO_TAREA_ID = 0;
    commit;                                                  
    update H_TAR set CUMPLIMIENTO_TAREA_ID = (case when (FECHA_FIN_TAREA - FECHA_VENCIMIENTO_TAREA) <= 0 then 0
                                                   when (FECHA_FIN_TAREA - FECHA_VENCIMIENTO_TAREA) > 0 then 1
                                                   when FECHA_VENCIMIENTO_TAREA is null then -2
                                                   else -1 end) where DIA_ID = fecha and ESTADO_TAREA_ID = 1;
    commit;           
    
    merge into H_TAR tar using (select DIA_ID, ITER, FASE_ACTUAL from TMP_TAR_JERARQUIA where DIA_ID = fecha) ttj
      on (tar.DIA_ID = fecha and tar.FASE_ACTUAL_PROCEDIMIENTO = ttj.FASE_ACTUAL)   
      when matched then update set tar.PROCEDIMIENTO_ID = ttj.ITER where tar.DIA_ID = fecha;
    commit;
    
    merge into H_TAR tar using (select DIA_ID, PROCEDIMIENTO_ID, TIPO_PROCEDIMIENTO_DET_ID, CARTERA_PROCEDIMIENTO_ID from H_PRC where DIA_ID = fecha) h
      on (tar.DIA_ID = fecha and tar.PROCEDIMIENTO_ID = h.PROCEDIMIENTO_ID)   
      when matched then update set tar.TIPO_PROCEDIMIENTO_DET_ID = h.TIPO_PROCEDIMIENTO_DET_ID,
                                   tar.CARTERA_PROCEDIMIENTO_ID = h.CARTERA_PROCEDIMIENTO_ID
      where tar.DIA_ID = fecha;
    commit;
     
    -- update H_TAR tar set GESTOR_EN_RECOVERY_PRC_ID = (select GESTOR_EN_RECOVERY_PRC_ID from D_PRC prc join D_PRC_GESTOR ges on prc.GESTOR_PRC_ID = ges.GESTOR_PRC_ID where tar.PROCEDIMIENTO_ID = prc.PROCEDIMIENTO_ID) where tar.DIA_ID = fecha;
    -- commit; 
    
  end loop;
  close c_fecha;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR. Termina Carga', 3;


  -- -------------------------- CÁLCULO DEL RESTO DE PERIODOS ----------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_TAR;
  commit;
-- ----------------------------------------------------------------------------------------------
--                                      H_TAR_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_SEMANA. Empieza Carga', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_TAR_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_TAR_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
  commit;
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;
  
  merge into TMP_FECHA dc
  using (select SEMANA_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)   
  when matched then update set dc.SEMANA_H = cf.SEMANA_ID;
  commit;
  
  delete from TMP_FECHA where SEMANA_H not in (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  commit;
  
  -- Borrado indices H_TAR_SEMANA 
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_SEMANA_VENC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_SEMANA_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  -- Bucle que recorre las semanas
  open c_semana;
  loop -- c_semana
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;      
           
    -- Borrado de las semanas a insertar
    delete from H_TAR_SEMANA where SEMANA_ID = semana;
    commit; 
    
    -- Insertado de semanas (último día de la semana disponible en H_TAR)
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    insert into H_TAR_SEMANA
            (SEMANA_ID, 
             FECHA_CARGA_DATOS,
             TAREA_ID, 
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID,
             FECHA_CREACION_TAREA,
             FECHA_VENC_ORIGINAL_TAREA,
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID, 
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID,
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS,
             NUM_DIAS_VENCIDO
             )
      select semana, 
             max_dia_semana, 
             TAREA_ID,
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID, 
             FECHA_CREACION_TAREA, 
             FECHA_VENC_ORIGINAL_TAREA, 
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID,
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID, 
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS, NUM_DIAS_VENCIDO
      from H_TAR  where DIA_ID = max_dia_semana;     
      V_ROWCOUNT := sql%rowcount;     
      commit;
  
     --Log_Proceso
     execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_TAR_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
  end loop CSEMANA;
  close c_semana;
  
  -- Crear indices H_TAR_SEMANA      
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_SEMANA_IX'', ''H_TAR_SEMANA (SEMANA_ID, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_SEMANA_VENC_IX'', ''H_TAR_SEMANA (SEMANA_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_SEMANA_PRC_IX'', ''H_TAR_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_SEMANA. Termina Carga', 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_TAR_MES
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_MES. Empieza Carga', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_TAR_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;
  
  merge into TMP_FECHA dc
  using (select MES_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)   
  when matched then update set dc.MES_H = cf.MES_ID;
  commit;
      
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  commit;
  
  -- Borrado indices H_TAR_MES 
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_MES_VENC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_MES_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  -- Bucle que recorre los meses
  open c_mes;
  loop -- C_MESES_loop
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;      
    
    -- Borrado de los meses a insertar
    delete from H_TAR_MES where MES_ID = mes;
    commit; 
    
    -- Insertado de meses (último día del mes disponible en H_TAR)
    select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
    insert into H_TAR_MES
            (MES_ID, 
             FECHA_CARGA_DATOS,
             TAREA_ID, 
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID,
             FECHA_CREACION_TAREA,
             FECHA_VENC_ORIGINAL_TAREA,
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID, 
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID,
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS,
             NUM_DIAS_VENCIDO
             )
      select mes, 
             max_dia_mes, 
             TAREA_ID,
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID, 
             FECHA_CREACION_TAREA, 
             FECHA_VENC_ORIGINAL_TAREA, 
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID,
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID, 
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS, NUM_DIAS_VENCIDO
      from H_TAR where DIA_ID = max_dia_mes;
      V_ROWCOUNT := sql%rowcount;     
      commit;
  
     --Log_Proceso
     execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_TAR_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
     
  end loop C_MESES_loop;
  close c_mes;
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_MES_IX'', ''H_TAR_MES (MES_ID, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_MES_VENC_IX'', ''H_TAR_MES (MES_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_MES_PRC_IX'', ''H_TAR_MES (MES_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_MES. Termina Carga', 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      H_TAR_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_TRIMESTRE. Empieza Carga', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_TAR_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  commit;
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;
  
  merge into TMP_FECHA dc
  using (select TRIMESTRE_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)   
  when matched then update set dc.TRIMESTRE_H = cf.TRIMESTRE_ID;
  commit;
  
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  commit;
  
    -- Borrado indices H_TAR_TRIMESTRE 
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_TRIMESTRE_VENC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_TRIMESTRE_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_loop
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;     
    
    -- Borrado de los trimestres a insertar
    delete from H_TAR_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;  
     
    -- Insertado de trimestes (último día del trimestre disponible en H_TAR)
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = TRIMESTRE;
    insert into H_TAR_TRIMESTRE
            (TRIMESTRE_ID, 
             FECHA_CARGA_DATOS,
             TAREA_ID, 
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID,
             FECHA_CREACION_TAREA,
             FECHA_VENC_ORIGINAL_TAREA,
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID, 
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID,
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS,
             NUM_DIAS_VENCIDO
             )
      select trimestre, 
             max_dia_trimestre, 
             TAREA_ID,
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID, 
             FECHA_CREACION_TAREA, 
             FECHA_VENC_ORIGINAL_TAREA, 
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID,
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID, 
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS, NUM_DIAS_VENCIDO
      from H_TAR where DIA_ID = max_dia_trimestre;
      V_ROWCOUNT := sql%rowcount;     
      commit;
  
     --Log_Proceso
     execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_TAR_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      
  end loop C_TRIMESTRE_loop;
  close c_trimestre;

  -- Crear indices H_TAR_TRIMESTRE
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_TRIMESTRE_IX'', ''H_TAR_TRIMESTRE (TRIMESTRE_ID, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_TRIMESTRE_VENC_IX'', ''H_TAR_TRIMESTRE (TRIMESTRE_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

  commit; 
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_TRIMESTRE_PRC_IX'', ''H_TAR_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_TRIMESTRE. Termina Carga', 3;
  
-- ----------------------------------------------------------------------------------------------
--                                      H_TAR_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_ANIO. Empieza Carga', 3;

	-- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_TAR_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  commit;
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_CNT) from TMP_FECHA_CNT;
  commit;
  
  merge into TMP_FECHA dc
  using (select ANIO_ID, DIA_ID from D_F_DIA) cf
  on (cf.DIA_ID = dc.DIA_H)   
  when matched then update set dc.ANIO_H = cf.ANIO_ID;
  
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  commit;
    
  -- Borrado indices H_TAR_ANIO 
  
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
	V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_ANIO_VENC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_TAR_ANIO_PRC_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  -- Bucle que recorre los años
  open c_anio;
  loop --C_ANIO_loop
  fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;          
    -- Borrado de los años a insertar
    delete from H_TAR_ANIO where ANIO_ID = anio;
    commit; 
    
    -- Insertado de años (último día del año disponible en H_TAR)
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
    insert into H_TAR_ANIO
            (ANIO_ID, 
             FECHA_CARGA_DATOS,
             TAREA_ID, 
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID,
             FECHA_CREACION_TAREA,
             FECHA_VENC_ORIGINAL_TAREA,
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID, 
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID,
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS,
             NUM_DIAS_VENCIDO
             )
      select anio, 
             max_dia_anio, 
             TAREA_ID,
             PROCEDIMIENTO_ID,
             EXPEDIENTE_ID,
             FASE_ACTUAL_PROCEDIMIENTO,
             ASUNTO_ID, 
             FECHA_CREACION_TAREA, 
             FECHA_VENC_ORIGINAL_TAREA, 
             FECHA_VENCIMIENTO_TAREA, 
             FECHA_FIN_TAREA,
             ESTADO_TAREA_ID,
             RESPONSABLE_TAREA_ID,
             TIPO_PROCEDIMIENTO_DET_ID, 
             CARTERA_PROCEDIMIENTO_ID,
             GESTOR_EN_RECOVERY_PRC_ID, 
             CUMPLIMIENTO_TAREA_ID,
             NUM_TAREAS, NUM_DIAS_VENCIDO
      from H_TAR where DIA_ID = max_dia_anio;
      commit;
  
     --Log_Proceso
     execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_TAR_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
      
  end loop C_ANIO_loop;
  close c_anio;

  -- Crear indices H_TAR_ANIO    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_ANIO_IX'', ''H_TAR_ANIO (ANIO_ID, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 
  
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_ANIO_VENC_IX'', ''H_TAR_ANIO (ANIO_ID, FECHA_VENCIMIENTO_TAREA, TAREA_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit; 
  
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_TAR_ANIO_PRC_IX'', ''H_TAR_ANIO (ANIO_ID, PROCEDIMIENTO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'H_TAR_ANIO. Termina Carga', 3;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); end;' USING in V_NOMBRE, 'Termina ' || V_NOMBRE, 2;


EXCEPTION
  when OBJECTEXISTS then
    O_ERROR_STATUS := 'La tabla ya existe';
    --ROLLBACK;
  when INSERT_NULL then
    O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    --ROLLBACK;    
  when PARAMETERS_NUMBER then
    O_ERROR_STATUS := 'Número de parámetros incorrecto';
    --ROLLBACK;    
  when OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --ROLLBACK;
end;
end CARGAR_H_TAREA;