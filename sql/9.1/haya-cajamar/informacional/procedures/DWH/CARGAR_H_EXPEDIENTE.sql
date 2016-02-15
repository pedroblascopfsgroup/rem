create or replace PROCEDURE CARGAR_H_EXPEDIENTE (DATE_START in date, DATE_END in date, O_ERROR_STATUS OUT VARCHAR2) AS 

-- ===============================================================================================
-- Autor: Fran Gutiérrez, PFS group
-- Fecha creación: Julio 2014
-- Responsable ultima modificacion: María Villanueva, PFS group
-- Fecha última modificación: 05/11/2015
-- Motivos del cambio: Usuario Propietario
-- Cliente: Recovery BI Haya
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_EXP
-- ===============================================================================================
 
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_EXPEDIENTE';
  V_ROWCOUNT NUMBER;
  
  V_NUM_ROW NUMBER(10);
  V_NUM_TABLE NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_HAYA02 VARCHAR2(100);
  V_SQL VARCHAR2(16000);
  nCount NUMBER;
  V_NUMBER NUMBER(16,0);
  
  formato_fecha VARCHAR2(100);
  
  max_dia_semana DATE;
  min_dia_semana DATE;
  max_dia_mes DATE;
  min_dia_mes DATE;
  max_dia_trimestre DATE;
  min_dia_trimestre DATE;
  max_dia_anio DATE;
  min_dia_anio DATE;
  
  max_dia_carga DATE;
  semana INT;
  mes INT;
  trimestre INT;
  anio INT;
  fecha DATE;
  fecha_anterior date;
  
  max_dia_h date;
  max_dia_mov date;
  penult_dia_mov date;
  max_dia_con_contratos date;
  max_dia_enviado_agencia date;

  l_last_row integer := 0;

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor C_FECHA_RELLENAR is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
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
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;
  
    select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';
  select valor into V_HAYA02 from PARAMETROS_ENTORNO where parametro = 'ORIGEN_01';
-- ----------------------------------------------------------------------------------------------
--                                      H_EXP
-- ----------------------------------------------------------------------------------------------
/*
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_HAYA02 || '.H_MOV_MOVIMIENTOS' into max_dia_h;  
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from '||V_DATASTAGE||'.MOV_MOVIMIENTOS' into max_dia_mov;  
  execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from '||V_DATASTAGE||'.MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) < to_date(''' || max_dia_mov || ''')' into penult_dia_mov;  
*/
  execute immediate 'select max_dia_h, max_dia_mov, penult_dia_mov from '||V_DATASTAGE||'.FECHAS_MOV' into max_dia_h, max_dia_mov, penult_dia_mov;
  
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop
    fetch c_fecha into fecha;  
    exit when c_fecha%NOTFOUND;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
    -- Borrado indices TMP_H_EXP
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_EXP_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_EXP_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Termina Borrado de Indices', 4;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_EXP'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
	
    execute immediate 'insert into TMP_H_EXP
        (DIA_ID,
        FECHA_CARGA_DATOS, 
        EXPEDIENTE_ID,         
        FECHA_CREACION_EXPEDIENTE,
        FASE_EXPEDIENTE_ID,
        ESTADO_EXPEDIENTE_ID,                
        NUM_EXPEDIENTES       
        )
    select 
        '''||fecha||''', 
        '''||fecha||''',
        EXP_ID,
        FECHACREAR,
        nvl(DD_EST_ID, -1),
        nvl(DD_EEX_ID, -1),
        1
    from '||V_DATASTAGE||'.EXP_EXPEDIENTES  
    where  trunc(FECHACREAR) <= '''||fecha||''' and BORRADO = 0';   
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
       
    -- Crear indices TMP_H_EXP
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_IX'', ''TMP_H_EXP (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
	
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_EXP_CNT_IX'', ''TMP_H_EXP (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;        

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_EXP. Termina Creación de Indices', 4;
            
    execute immediate 'merge into TMP_H_EXP a
    using (select gexp.EXP_ID, usu.USU_ID
            from '||V_DATASTAGE||'.GEH_GESTOR_ENTIDAD_HIST gent
            join '||V_DATASTAGE||'.GEH_GESTOR_EXPEDIENTE_HIST gexp on gexp.GEH_ID = gent.GEH_ID
            join '||V_DATASTAGE||'.USU_USUARIOS usu on gent.USU_ID = usu.USU_ID
            join '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR tges on tges.DD_TGE_ID = gent.DD_TGE_ID
            where tges.DD_TGE_DESCRIPCION = ''Gestor Externo'') b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.GESTOR_EXP_ID = b.USU_ID
        where DIA_ID = '''||fecha||'''';
    commit;
    
    execute immediate 'merge into TMP_H_EXP a
    using (select gexp.EXP_ID, usu.USU_ID
            from '||V_DATASTAGE||'.GEH_GESTOR_ENTIDAD_HIST gent
            join '||V_DATASTAGE||'.GEH_GESTOR_EXPEDIENTE_HIST gexp on gexp.GEH_ID = gent.GEH_ID
            join '||V_DATASTAGE||'.USU_USUARIOS usu on gent.USU_ID = usu.USU_ID
            join '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR tges on tges.DD_TGE_ID = gent.DD_TGE_ID
            where tges.DD_TGE_DESCRIPCION = ''Gestor Externo'') b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.GESTOR_COMITE_EXP_ID = b.USU_ID
        where DIA_ID = '''||fecha||'''';
    commit;
    
    execute immediate 'merge into TMP_H_EXP a
    using (select gexp.EXP_ID, usu.USU_ID
            from '||V_DATASTAGE||'.GEH_GESTOR_ENTIDAD_HIST gent
            join '||V_DATASTAGE||'.GEH_GESTOR_EXPEDIENTE_HIST gexp on gexp.GEH_ID = gent.GEH_ID
            join '||V_DATASTAGE||'.USU_USUARIOS usu on gent.USU_ID = usu.USU_ID
            join '||V_DATASTAGE||'.DD_TGE_TIPO_GESTOR tges on tges.DD_TGE_ID = gent.DD_TGE_ID
            where tges.DD_TGE_DESCRIPCION = ''Supervisor Externo'') b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.SUPERVISOR_EXP_ID = b.USU_ID
        where DIA_ID = '''||fecha||'''';
    commit;
    
    
    -- Borrado indices TMP_EXP_CNT  
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_CNT_CNT_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
		V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_EXP_CNT_CEX_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Borrado de Indices', 4;
    
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_EXP_CNT'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
	
    -- Fecha de analisis en H_MOV_MOVIMIENTOS (fecha menor que el ultimno día de H_MOV_MOVIMIENTOS o mayor que este, pero menor que el penúltimo dia de MOV_MOVIMIENTOS)
    if((fecha <= max_dia_h) or ((fecha > max_dia_h) and (fecha < penult_dia_mov))) then
      execute immediate 'select max(TRUNC(MOV_FECHA_EXTRACCION)) from ' || V_HAYA02 || '.H_MOV_MOVIMIENTOS where TRUNC(MOV_FECHA_EXTRACCION) <= to_date('''||fecha||''')' into max_dia_con_contratos;  

    execute immediate 'insert into TMP_EXP_CNT 
            (EXPEDIENTE_ID, 
             CONTRATO, 
             CEX_ID, 
             SALDO_VENCIDO, 
             SALDO_NO_VENCIDO, 
             DEUDA_IRREGULAR,
             SALDO_DUDOSO, 
             SALDO_RECLAMAR,
             INT_REMUNERATORIOS,
             INT_MORATORIOS,
             COMISIONES,
             GASTOS
             )
    select cex.EXP_ID,
             mov.CNT_ID, 
             cex.CEX_ID, 
             mov.MOV_POS_VIVA_VENCIDA, 
             mov.MOV_POS_VIVA_NO_VENCIDA,
             mov.MOV_DEUDA_IRREGULAR,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_INT_REMUNERATORIOS,
             mov.MOV_INT_MORATORIOS,
             mov.MOV_COMISIONES, 
             mov.MOV_GASTOS 
        from '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex 
        join '||V_HAYA02||'.H_MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
        where mov.MOV_FECHA_EXTRACCION = ''' || max_dia_con_contratos || ''''; 
     
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Registros Insertados (1): ' || TO_CHAR(V_ROWCOUNT), 4;
     
    -- Fecha de análisis en MOV_MOVIMIENTOS - Penúltimo o último día
    elsif(fecha = penult_dia_mov or fecha = max_dia_mov) then
    execute immediate 'insert into TMP_EXP_CNT 
            (EXPEDIENTE_ID, 
             CONTRATO, 
             CEX_ID, 
             SALDO_VENCIDO, 
             SALDO_NO_VENCIDO, 
             DEUDA_IRREGULAR,
             SALDO_DUDOSO, 
             SALDO_RECLAMAR,
             INT_REMUNERATORIOS,
             INT_MORATORIOS,
             COMISIONES,
             GASTOS
             )
    select cex.EXP_ID,
             mov.CNT_ID, 
             cex.CEX_ID, 
             mov.MOV_POS_VIVA_VENCIDA, 
             mov.MOV_POS_VIVA_NO_VENCIDA,
             mov.MOV_DEUDA_IRREGULAR,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_SALDO_DUDOSO,
             mov.MOV_INT_REMUNERATORIOS,
             mov.MOV_INT_MORATORIOS,
             mov.MOV_COMISIONES, 
             mov.MOV_GASTOS 
        from '||V_DATASTAGE||'.CEX_CONTRATOS_EXPEDIENTE cex 
        join '||V_DATASTAGE||'.MOV_MOVIMIENTOS mov on cex.CNT_ID = mov.CNT_ID
        where mov.MOV_FECHA_EXTRACCION = '''||fecha||''''; 

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Registros Insertados (2): ' || TO_CHAR(V_ROWCOUNT), 4;

    end if;   
    
    -- Crear indices TMP_EXP_CNT  
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_IX'', ''TMP_EXP_CNT (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
	
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_CNT_IX'', ''TMP_EXP_CNT (CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
	
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_EXP_CNT_CEX_IX'', ''TMP_EXP_CNT (CEX_ID, CONTRATO)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
	
    commit;  
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Creación de Indices', 4;
        
    
    execute immediate 'update TMP_H_EXP set NUM_DIAS_CREACION = NVL(FECHA_CREACION_EXPEDIENTE - to_date('''||fecha||''',''dd/MM/YY'') , 0) where DIA_ID = '''||fecha||'''';             
       
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_EXP_CNT. Termina Updates(1)', 4;

    merge into TMP_H_EXP a
    using (select EXPEDIENTE_ID, 
              sum(SALDO_VENCIDO) as SALDO_VENCIDO,
              sum(SALDO_NO_VENCIDO) as SALDO_NO_VENCIDO,
              sum(SALDO_DUDOSO) as SALDO_DUDOSO,
              sum(SALDO_RECLAMAR) as SALDO_RECLAMAR,
              sum(INT_REMUNERATORIOS) as INT_REMUNERATORIOS,
              sum(INT_MORATORIOS) as INT_MORATORIOS,
              sum(COMISIONES) as COMISIONES,
              sum(GASTOS) as GASTOS,
              sum(DEUDA_IRREGULAR) as DEUDA_IRREGULAR              
            from TMP_EXP_CNT group by EXPEDIENTE_ID) b
    on (b.EXPEDIENTE_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.SALDO_VENCIDO = b.SALDO_VENCIDO,
            a.SALDO_NO_VENCIDO = b.SALDO_NO_VENCIDO,
            a.SALDO_DUDOSO = b.SALDO_DUDOSO,
            a.SALDO_A_RECLAMAR = b.SALDO_RECLAMAR,
            a.INTERESES_REMUNERATORIOS = b.INT_REMUNERATORIOS,
            a.INTERESES_MORATORIOS = b.INT_MORATORIOS,
            a.COMISIONES = b.COMISIONES,
            a.GASTOS = b.GASTOS,
            a.SALDO_TOTAL = b.SALDO_VENCIDO + b.SALDO_NO_VENCIDO,
            a.DEUDA_IRREGULAR = b.DEUDA_IRREGULAR,
            a.RIESGO_VIVO = b.SALDO_NO_VENCIDO + b.DEUDA_IRREGULAR            
        where a.DIA_ID = fecha;   
    commit; 
    
    execute immediate 'update TMP_H_EXP set T_SALDO_TOTAL_EXP_ID = (case when SALDO_TOTAL <= 30000 then 0
                                                                         when SALDO_TOTAL > 30000 and SALDO_TOTAL <= 60000 then 1
                                                                         when SALDO_TOTAL > 60000 and SALDO_TOTAL <= 90000 then 2
                                                                         when SALDO_TOTAL > 90000 and SALDO_TOTAL <= 300000 then 3
                                                                         when SALDO_TOTAL > 300000 then 4
                                                                         else -1 end) where DIA_ID = '''||fecha||'''';  
                                                                    
    execute immediate 'update TMP_H_EXP set T_SALDO_IRREGULAR_EXP_ID = (case when SALDO_VENCIDO <= 30000 then 0
                                                                             when SALDO_VENCIDO > 30000 and SALDO_VENCIDO <= 60000 then 1
                                                                             when SALDO_VENCIDO > 60000 and SALDO_VENCIDO <= 90000 then 2
                                                                             when SALDO_VENCIDO > 90000 and SALDO_VENCIDO <= 300000 then 3
                                                                             when SALDO_VENCIDO > 300000 then 4
                                                                             else -1 end) where DIA_ID = '''||fecha||''''; 
    
    execute immediate 'update TMP_H_EXP set T_DEUDA_IRREGULAR_EXP_ID = (case when DEUDA_IRREGULAR >= 0 and DEUDA_IRREGULAR <= 25000 then 0
                                                                             when DEUDA_IRREGULAR > 25000 and DEUDA_IRREGULAR <= 50000 then 1
                                                                             when DEUDA_IRREGULAR > 50000 and DEUDA_IRREGULAR <= 75000 then 2
                                                                             when DEUDA_IRREGULAR > 75000 then 3
                                                                             else -1 end) where DIA_ID = '''||fecha||'''';   
  
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_INI) AS FECHA_INICIO_CE, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
           where DD_EST_ID = 3 AND DD_STA_ID = 2 AND DD_EIN_ID = 2
           group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_INICIO_CE = b.FECHA_INICIO_CE
        where DIA_ID = '''||fecha||'''';
    commit;
	
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_INI) AS FECHA_INICIO_RE, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
           where DD_EST_ID = 4 AND DD_STA_ID = 3 AND DD_EIN_ID = 2
           group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_INICIO_RE = b.FECHA_INICIO_RE
        where DIA_ID = '''||fecha||'''';
    commit;
	
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_INI) AS FECHA_INICIO_DC, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
           where DD_EST_ID = 4 AND DD_STA_ID = 3 AND DD_EIN_ID = 2
           group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_INICIO_DC = b.FECHA_INICIO_DC
        where DIA_ID = '''||fecha||'''';
    commit;
	
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_INI) AS FECHA_INICIO_FP, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
           where DD_EST_ID = 3 AND DD_STA_ID = 988 AND DD_EIN_ID = 2
           group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_INICIO_FP = b.FECHA_INICIO_FP
        where DIA_ID = '''||fecha||'''';
    commit;
	
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_FIN) AS FECHA_FIN_CE, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
           where DD_EST_ID = 3 AND DD_STA_ID = 2 AND DD_EIN_ID = 2
           group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_FIN_CE = b.FECHA_FIN_CE
        where DIA_ID = '''||fecha||'''';
    commit;
	
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_FIN) AS FECHA_FIN_RE, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
           where DD_EST_ID = 4 AND DD_STA_ID = 3 AND DD_EIN_ID = 2
           group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_FIN_RE = b.FECHA_FIN_RE
        where DIA_ID = '''||fecha||'''';
    commit;
	
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_FIN) AS FECHA_FIN_DC, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
    where DD_EST_ID = 4 AND DD_STA_ID = 3 AND DD_EIN_ID = 2
    group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_FIN_DC = b.FECHA_FIN_DC
        where DIA_ID = '''||fecha||'''';
    commit;
	
    execute immediate 'merge into TMP_H_EXP a
    using (select min(TAR_FECHA_FIN) AS FECHA_FIN_FP, EXP_ID from '||V_DATASTAGE||'.TAR_TAREAS_NOTIFICACIONES
    where DD_EST_ID = 3 AND DD_STA_ID = 988 AND DD_EIN_ID = 2
    group by EXP_ID) b
    on (b.EXP_ID = a.EXPEDIENTE_ID)   
    when matched then update 
        set a.FECHA_FIN_FP = b.FECHA_FIN_FP
        where DIA_ID = '''||fecha||'''';
    commit;
  
    update TMP_H_EXP set
      NUM_DIAS_COMPLETAR_A_REVISION=(FECHA_INICIO_RE - FECHA_INICIO_CE),
      NUM_DIAS_REVISION_A_DECISION=(FECHA_INICIO_DC - FECHA_INICIO_RE),
      NUM_DIAS_COMPLETAR_A_DECISION=(FECHA_FIN_DC - FECHA_INICIO_CE),
      NUM_DIAS_DECISION_A_FORMALIZAR = (FECHA_FIN_FP - FECHA_INICIO_DC),
      NUM_DIAS_ACTUAL_A_COMPLETAR=(fecha - FECHA_INICIO_CE),
      NUM_DIAS_ACTUAL_A_REVISION=(fecha - FECHA_INICIO_RE),
      NUM_DIAS_ACTUAL_A_DECISION=(fecha - FECHA_INICIO_DC),
      NUM_DIAS_ACTUAL_A_FORMALIZAR = (fecha - FECHA_INICIO_FP);
    commit;


    -- Borrado del día a insertar
    delete from H_EXP where DIA_ID = fecha;
    commit;

    -- Borrado indices H_EXP
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_EXP_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit; 

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Termina Borrado Indices', 4;
    
          
    insert into H_EXP
        ( DIA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,		
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
        )
    select DIA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,		
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
    from TMP_H_EXP where DIA_ID = fecha;
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
  end loop;
  close c_fecha;  
  

  -- Crear indices H_EXP
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_IX'', ''H_EXP (DIA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_EXP_IX'', ''H_EXP (EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  commit;

 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP. Termina Creación de Indices', 3;
  

  
-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_SEMANA
-- ----------------------------------------------------------------------------------------------
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
	
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_EXP_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_EXP_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  commit;
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  commit;

  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Empieza Semana: '||TO_CHAR(semana), 3;

    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    select min(DIA_H) into min_dia_semana from TMP_FECHA where SEMANA_H = semana;

    -- Borrado de las semanas a insertar
    delete from H_EXP_SEMANA where SEMANA_ID = semana;
    commit;
    
    -- Borrado indices H_EXP_SEMANA 
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    


   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Termina Borrado de Indices', 4;

        insert into H_EXP_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,		
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS     
        )
    select semana, 
         max_dia_semana,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,		
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS
    from H_EXP where DIA_ID = max_dia_semana;
    commit;
    V_ROWCOUNT := sql%rowcount;     
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;   

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Termina Semana: '||TO_CHAR(semana), 3;
    
  end loop;
  close c_semana;

  -- Crear indices H_EXP_SEMANA
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_SEMANA_IX'', ''H_EXP_SEMANA (SEMANA_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
  
 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_SEMANA. Termina Creación de Indices', 4;



-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_MES
-- ----------------------------------------------------------------------------------------------
   -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
	
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_EXP_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  
  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND; 

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Empieza Mes: '||TO_CHAR(mes), 3;

    select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
    select min(DIA_H) into min_dia_mes from TMP_FECHA where MES_H = mes;

    -- Borrado de los meses a insertar
    delete from H_EXP_MES where MES_ID = mes;
    commit;
    
    -- Borrado indices H_EXP_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Termina Borrado de Indices', 4;
    
    
    insert into H_EXP_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,			
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
        )
    select mes, 
         max_dia_mes,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,			
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
    from H_EXP where DIA_ID = max_dia_mes;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
  
  end loop;
  close c_mes;

  -- Crear indices H_EXP_MES
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_MES_IX'', ''H_EXP_MES (MES_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
	

  commit;
  
 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_MES. Termina Creación de Indices', 4;

  
-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_TRIMESTRE
-- ----------------------------------------------------------------------------------------------  
  --Log_Proceso
  execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
	
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_EXP_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Empieza Trimestre: '||TO_CHAR(trimestre), 3;
    
    
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
    select min(DIA_H) into min_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    -- Borrado de los trimestres a insertar
    delete from H_EXP_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;
    
    -- Borrar indices H_EXP_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Termina Borrado de Indices', 4;
    
    
    insert into H_EXP_TRIMESTRE
        (TRIMESTRE_ID,   
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,			
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
        )
    select trimestre, 
         max_dia_trimestre,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,			
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
    from H_EXP where DIA_ID = max_dia_trimestre;
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
     
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Termina Trimestre: '||TO_CHAR(trimestre), 3;
 
  end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

  -- Crear indices H_EXP_TRIMESTRE
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_TRIMESTRE_IX'', ''H_EXP_TRIMESTRE (TRIMESTRE_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_TRIMESTRE. Termina Creación de Indices', 4;
  

-- ----------------------------------------------------------------------------------------------
--                                      H_EXP_ANIO
-- ----------------------------------------------------------------------------------------------
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;	
	
V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_EXP_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_EXP;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
-- Bucle que recorre los años
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;       

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_ANIO. Empieza Año: '||TO_CHAR(anio), 3;
    
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;    
    select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;    

    -- Borrado de los años a insertar
    delete from H_EXP_ANIO where ANIO_ID = anio;    
    commit;
    
    -- Borrar indices H_CNT_ANIO
        V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_EXP_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Termina Borrado de Indices', 4;
    
    insert into H_EXP_ANIO
        (ANIO_ID,      
         FECHA_CARGA_DATOS,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
        )
    select anio,   
         max_dia_anio,
         EXPEDIENTE_ID,
         FECHA_CREACION_EXPEDIENTE,
         FECHA_INICIO_CE,
         FECHA_INICIO_RE,
         FECHA_INICIO_DC,
         FECHA_INICIO_FP,
         FECHA_FIN_CE,
         FECHA_FIN_RE,
         FECHA_FIN_DC,		
         FECHA_FIN_FP,			
         GESTOR_EXP_ID,
         GESTOR_COMITE_EXP_ID,
         SUPERVISOR_EXP_ID,
         FASE_EXPEDIENTE_ID,
         ESTADO_EXPEDIENTE_ID, 
         T_SALDO_TOTAL_EXP_ID,
         T_SALDO_IRREGULAR_EXP_ID,
         T_DEUDA_IRREGULAR_EXP_ID,
         NUM_EXPEDIENTES,
         NUM_CONTRATOS,
         NUM_DIAS_COMPLETAR_A_REVISION,
         NUM_DIAS_REVISION_A_DECISION,
         NUM_DIAS_COMPLETAR_A_DECISION,
         NUM_DIAS_DECISION_A_FORMALIZAR,
         NUM_DIAS_ACTUAL_A_COMPLETAR,
         NUM_DIAS_ACTUAL_A_REVISION,
         NUM_DIAS_ACTUAL_A_DECISION,		
         NUM_DIAS_ACTUAL_A_FORMALIZAR,
         SALDO_VENCIDO,
         SALDO_NO_VENCIDO,
         SALDO_TOTAL,
         RIESGO_VIVO,
         DEUDA_IRREGULAR,
         SALDO_DUDOSO,
         INTERESES_REMUNERATORIOS,
         INTERESES_MORATORIOS,
         COMISIONES,
         GASTOS    
    from H_EXP where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
   --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_EXP_ANIO. Termina Año: '||TO_CHAR(anio), 3;

  end loop;
  close c_anio;

  -- Crear indices H_EXP_ANIO
  
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_EXP_ANIO_IX'', ''H_EXP_ANIO (ANIO_ID, EXPEDIENTE_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;

 --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_ANIO. Termina Creación de Indices', 4;

  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;
 
 
EXCEPTION
  /*when OBJECTEXISTS then
    --O_ERROR_STATUS := 'La tabla ya existe';
    DBMS_OUTPUT.PUT_LINE('La tabla ya existe');
    --ROLLBACK;
  when INSERT_NULL then
    --O_ERROR_STATUS := 'Has intentado insertar un valor nulo';
    DBMS_OUTPUT.PUT_LINE('Has intentado insertar un valor nulo');
    --ROLLBACK;    
  when PARAMETERS_NUMBER then
    --O_ERROR_STATUS := 'Número de parámetros incorrecto';
    DBMS_OUTPUT.PUT_LINE('Número de parámetros incorrecto');
    --ROLLBACK;    */
  when OTHERS then
    O_ERROR_STATUS := 'Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM;
    --DBMS_OUTPUT.PUT_LINE('Se ha producido un error en el proceso: '||SQLCODE||' -> '||SQLERRM);
    --ROLLBACK;



end CARGAR_H_EXPEDIENTE;