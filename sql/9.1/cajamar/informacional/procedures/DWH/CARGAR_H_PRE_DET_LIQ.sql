create or replace PROCEDURE CARGAR_H_PRE_DET_LIQ(DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Jaime Sánchez-Cuenca Bellido, PFS Group
-- Fecha creación: Septiembre 2015
-- Responsable ultima modificacion: María Villanueva, PFS Group
-- Fecha ultima modificacion: 16/11/2015
-- Motivos del cambio: usuario propietario
-- Cliente: Recovery BI CAJAMAR
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos H_PRE_DET_LIQ.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_PRE_DET_LIQ';
  V_ROWCOUNT NUMBER;
   V_SQL VARCHAR2(16000);
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  nCount NUMBER;

  formato_fecha VARCHAR(25) := 'DD/MM/YY';

  min_dia_semana date;
  max_dia_semana date;
  min_dia_mes date;
  max_dia_mes date;
  min_dia_trimestre date;
  max_dia_trimestre date;
  min_dia_anio date;
  max_dia_anio date;
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_ant date;
  semana_ant int;
  mes_ant int;
  trimestre_ant int;
  anio_ant int;  

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA ORDER BY 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1; 
  
-- --------------------------------------------------------------------------------
-- DEFINICIÓN DE LOS HANDLER DE ERROR
-- --------------------------------------------------------------------------------
  OBJECTEXISTS EXCEPTION;
  insert_NULL EXCEPTION;
  PARAMETERS_NUMBER EXCEPTION;
  PRAGMA EXCEPTION_INIT(OBJECTEXISTS, -955);
  PRAGMA EXCEPTION_INIT(insert_NULL, -1400);
  PRAGMA EXCEPTION_INIT(PARAMETERS_NUMBER, -909);
  
  BEGIN
-- ----------------------------------------------------------------------------------------------
--                                     H_PRE_DET_LIQ
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;  
   select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE'; 
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3; 

    -- Borrando indices TMP_H_PRE_DET_LIQ
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_H_PRE_DET_LIQ_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_H_PRE_DET_LIQ'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_LIQ. Truncado de tabla y borrado de indices', 4;

    --Dia anterior
    select max(dia_id) into fecha_ant from H_PRE_DET_LIQ where dia_id < fecha;
    
    execute immediate 'insert into TMP_H_PRE_DET_LIQ
                 (DIA_ID,
                  FECHA_CARGA_DATOS,
                  PROCEDIMIENTO_ID,
                  LIQUIDACION_ID,
                  ESTADO_LIQUIDACION_ID,
                  CONTRATO_ID,
                  FECHA_SOLICITUD_LIQ,
                  FECHA_RECEP_LIQ,
                  FECHA_CONFIRMACION_LIQ,
                  FECHA_CIERRE_LIQ,
                  NUM_LIQUIDACIONES,
                  CAPITAL_VENCIDO_LIQ,
                  CAPITAL_NO_VENCIDO_LIQ,
                  INTERESES_ORDINARIOS_LIQ,
                  INTERESES_DEMORA_LIQ,
                  COMISIONES_LIQ,
                  GASTOS_LIQ,
                  TOTAL_LIQ,
                  P_LIQ_SOLICITUD_CIERRE
                  )
          select  '''||fecha||''',
                  '''||fecha||''',
                  PRC_ID,
                  PCO_LIQ_ID,
                  DD_PCO_LIQ_ID,
                  CNT_ID,
                  trunc(PCO_LIQ_FECHA_SOLICITUD),
                  trunc(PCO_LIQ_FECHA_RECEPCION),
                  trunc(PCO_LIQ_FECHA_CONFIRMACION),
                  trunc(PCO_LIQ_FECHA_CIERRE),
                  1,
                  NVL(PCO_LIQ_CAPITAL_VENCIDO, PCO_LIQ_ORI_CAPITAL_VENCIDO),
                  NVL(PCO_LIQ_CAPITAL_NO_VENCIDO, PCO_LIQ_ORI_CAPITAL_VENCIDO),
                  NVL(PCO_LIQ_INTERESES_ORDINARIOS, PCO_LIQ_ORI_INTE_ORDINARIOS),
                  NVL(PCO_LIQ_INTERESES_DEMORA, PCO_LIQ_ORI_INTE_DEMORA),
                  NVL(PCO_LIQ_COMISIONES, PCO_LIQ_ORI_COMISIONES),
                  NVL(PCO_LIQ_GASTOS, PCO_LIQ_ORI_GASTOS),
                  NVL(PCO_LIQ_TOTAL, PCO_LIQ_ORI_TOTAL),
                  trunc(PCO_LIQ_FECHA_CIERRE)- trunc(PCO_LIQ_FECHA_SOLICITUD)
          from '||V_DATASTAGE||'.PCO_LIQ_LIQUIDACIONES liq, '||V_DATASTAGE||'.PCO_PRC_PROCEDIMIENTOS pco
          where liq.PCO_PRC_ID = pco.PCO_PRC_ID and trunc(liq.FECHACREAR) <= '''||fecha||''' and liq.BORRADO = 0';

    V_ROWCOUNT := sql%rowcount;     
    commit;
     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_LIQ. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
    
    -- ESTADO_LIQ_PER_ANT_ID
    if fecha_ant is not null then
      merge into TMP_H_PRE_DET_LIQ t1
      using (select PROCEDIMIENTO_ID, LIQUIDACION_ID, ESTADO_LIQUIDACION_ID from H_PRE_DET_LIQ where DIA_ID = fecha_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.LIQUIDACION_ID = t2.LIQUIDACION_ID)
      when matched then update set t1.ESTADO_LIQ_PER_ANT_ID = t2.ESTADO_LIQUIDACION_ID;    
      
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_H_PRE_DET_LIQ. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    
    end if;    
    
    -- Crear indices TMP_H_PRE_DET_LIQ
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_H_PRE_DET_LIQ_IX'', ''TMP_H_PRE_DET_LIQ (DIA_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    

    -- Borrado del dï¿½a a insertar
    delete from H_PRE_DET_LIQ where DIA_ID = fecha;
    commit;   
    
    -- Borrando indices H_PRE_DET_LIQ
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;
    
            
    insert INTO H_PRE_DET_LIQ
        ( DIA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          LIQUIDACION_ID,
          ESTADO_LIQUIDACION_ID,
          ESTADO_LIQ_PER_ANT_ID,
          CONTRATO_ID,
          FECHA_SOLICITUD_LIQ,
          FECHA_RECEP_LIQ,
          FECHA_CONFIRMACION_LIQ,
          FECHA_CIERRE_LIQ,
          NUM_LIQUIDACIONES,
          CAPITAL_VENCIDO_LIQ,
          CAPITAL_NO_VENCIDO_LIQ,
          INTERESES_ORDINARIOS_LIQ,
          INTERESES_DEMORA_LIQ,
          COMISIONES_LIQ,
          GASTOS_LIQ,
          TOTAL_LIQ,
          P_LIQ_SOLICITUD_CIERRE
        )
     select DIA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          LIQUIDACION_ID,
          ESTADO_LIQUIDACION_ID,
          ESTADO_LIQ_PER_ANT_ID,
          CONTRATO_ID,
          FECHA_SOLICITUD_LIQ,
          FECHA_RECEP_LIQ,
          FECHA_CONFIRMACION_LIQ,
          FECHA_CIERRE_LIQ,
          NUM_LIQUIDACIONES,
          CAPITAL_VENCIDO_LIQ,
          CAPITAL_NO_VENCIDO_LIQ,
          INTERESES_ORDINARIOS_LIQ,
          INTERESES_DEMORA_LIQ,
          COMISIONES_LIQ,
          GASTOS_LIQ,
          TOTAL_LIQ,
          P_LIQ_SOLICITUD_CIERRE
     from TMP_H_PRE_DET_LIQ where DIA_ID = fecha;

    V_ROWCOUNT := sql%rowcount;     
    commit;  

     --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    commit;
    
    end loop;
  close c_fecha;  
  
  
  -- Crear indices H_PRE_DET_LIQ
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_IX'', ''H_PRE_DET_LIQ (DIA_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_LIQ_SEMANA
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
			
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_PRE_DET_LIQ_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_PRE_DET_LIQ_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  end if;
    
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_LIQ;
  update TMP_FECHA tf set tf.SEMANA_H = (select D.SEMANA_ID from D_F_DIA d  where tf.DIA_H = d.DIA_ID);
  delete from TMP_FECHA where SEMANA_H not IN (select distinct SEMANA_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set SEMANA_ANT = (select min(SEMANA_AUX) from TMP_FECHA_AUX where SEMANA_AUX > SEMANA_H);
  
  -- Borrado indices H_PRE_DET_LIQ_SEMANA
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  

  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    --Semana anterior
    select max(SEMANA_ID) into semana_ant from H_PRE_DET_LIQ_SEMANA where SEMANA_ID < semana;
    
    -- Borrado de las semanas a insertar
    delete from H_PRE_DET_LIQ_SEMANA where SEMANA_ID = semana;
    commit;

    insert INTO H_PRE_DET_LIQ_SEMANA
        (
          SEMANA_ID,
          FECHA_CARGA_DATOS,
          PROCEDIMIENTO_ID,
          LIQUIDACION_ID,
          ESTADO_LIQUIDACION_ID,
          CONTRATO_ID,
          FECHA_SOLICITUD_LIQ,
          FECHA_RECEP_LIQ,
          FECHA_CONFIRMACION_LIQ,
          FECHA_CIERRE_LIQ,
          NUM_LIQUIDACIONES,
          CAPITAL_VENCIDO_LIQ,
          CAPITAL_NO_VENCIDO_LIQ,
          INTERESES_ORDINARIOS_LIQ,
          INTERESES_DEMORA_LIQ,
          COMISIONES_LIQ,
          GASTOS_LIQ,
          TOTAL_LIQ,
          P_LIQ_SOLICITUD_CIERRE
        )
    select semana,
          max_dia_semana,
          PROCEDIMIENTO_ID,
          LIQUIDACION_ID,
          ESTADO_LIQUIDACION_ID,
          CONTRATO_ID,
          FECHA_SOLICITUD_LIQ,
          FECHA_RECEP_LIQ,
          FECHA_CONFIRMACION_LIQ,
          FECHA_CIERRE_LIQ,
          NUM_LIQUIDACIONES,
          CAPITAL_VENCIDO_LIQ,
          CAPITAL_NO_VENCIDO_LIQ,
          INTERESES_ORDINARIOS_LIQ,
          INTERESES_DEMORA_LIQ,
          COMISIONES_LIQ,
          GASTOS_LIQ,
          TOTAL_LIQ,
          P_LIQ_SOLICITUD_CIERRE
    from H_PRE_DET_LIQ where DIA_ID = max_dia_semana;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
   --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_SEMANA. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
     -- ESTADO_LIQ_PER_ANT_ID
    if semana_ant is not null then
      -- Crear indices H_PRE_DET_LIQ_SEMANA      
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_SEMANA_IX'', ''H_PRE_DET_LIQ_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;   
    
      merge into H_PRE_DET_LIQ_SEMANA t1
      using (select PROCEDIMIENTO_ID, LIQUIDACION_ID, ESTADO_LIQUIDACION_ID from H_PRE_DET_LIQ_SEMANA where SEMANA_ID = semana_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.LIQUIDACION_ID = t2.LIQUIDACION_ID)
      when matched then update set t1.ESTADO_LIQ_PER_ANT_ID = t2.ESTADO_LIQUIDACION_ID
      where SEMANA_ID = semana;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_SEMANA. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_LIQ_SEMANA
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;        
    end if;    
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_SEMANA. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    commit;

  end loop C_SEMANAS_LOOP;
close c_semana;
  --Log_Proceso

    -- Crear indices H_PRE_DET_LIQ_SEMANA      
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_SEMANA_IX'', ''H_PRE_DET_LIQ_SEMANA (SEMANA_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;   

    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_SEMANA. Termina bucle', 3;   
    
    
-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_LIQ_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_MES. Empieza bucle', 3;

  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_PRE_DET_LIQ_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_LIQ;
  update TMP_FECHA tf set tf.MES_H = (select D.MES_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where MES_H not IN (select distinct MES_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set MES_ANT = (select min(MES_AUX) from TMP_FECHA_AUX where MES_AUX > MES_H);
  

  -- Borrado indices H_PRE_DET_LIQ_MES
   V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;  
    
   -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
      select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
      
      --Mes anterior
      select max(MES_ID) into mes_ant from H_PRE_DET_LIQ_MES where MES_ID < mes;
   
    -- Borrado de los meses a insertar
    delete from H_PRE_DET_LIQ_MES where MES_ID = mes;
    commit;
    
    insert INTO H_PRE_DET_LIQ_MES
              (
                MES_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                LIQUIDACION_ID,
                ESTADO_LIQUIDACION_ID,
                CONTRATO_ID,
                FECHA_SOLICITUD_LIQ,
                FECHA_RECEP_LIQ,
                FECHA_CONFIRMACION_LIQ,
                FECHA_CIERRE_LIQ,
                NUM_LIQUIDACIONES,
                CAPITAL_VENCIDO_LIQ,
                CAPITAL_NO_VENCIDO_LIQ,
                INTERESES_ORDINARIOS_LIQ,
                INTERESES_DEMORA_LIQ,
                COMISIONES_LIQ,
                GASTOS_LIQ,
                TOTAL_LIQ,
                P_LIQ_SOLICITUD_CIERRE
            )
    select mes,
            max_dia_mes,
            PROCEDIMIENTO_ID,
            LIQUIDACION_ID,
            ESTADO_LIQUIDACION_ID,
            CONTRATO_ID,
            FECHA_SOLICITUD_LIQ,
            FECHA_RECEP_LIQ,
            FECHA_CONFIRMACION_LIQ,
            FECHA_CIERRE_LIQ,
            NUM_LIQUIDACIONES,
            CAPITAL_VENCIDO_LIQ,
            CAPITAL_NO_VENCIDO_LIQ,
            INTERESES_ORDINARIOS_LIQ,
            INTERESES_DEMORA_LIQ,
            COMISIONES_LIQ,
            GASTOS_LIQ,
            TOTAL_LIQ,
            P_LIQ_SOLICITUD_CIERRE
    from H_PRE_DET_LIQ  where DIA_ID = max_dia_mes;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
   --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_MES. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    -- ESTADO_LIQ_PER_ANT_ID
    if mes_ant is not null then
      -- Crear indices H_PRE_DET_LIQ_MES      
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_MES_IX'', ''H_PRE_DET_LIQ_MES (MES_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;   
    
      merge into H_PRE_DET_LIQ_MES t1
      using (select PROCEDIMIENTO_ID, LIQUIDACION_ID, ESTADO_LIQUIDACION_ID from H_PRE_DET_LIQ_MES where MES_ID = mes_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.LIQUIDACION_ID = t2.LIQUIDACION_ID)
      when matched then update set t1.ESTADO_LIQ_PER_ANT_ID = t2.ESTADO_LIQUIDACION_ID
      where MES_ID = mes;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_MES. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_LIQ_MES
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;        
    end if;   
 
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_MES. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    commit;

  end loop C_MESES_LOOP;
  close c_mes;

    
    -- Crear indices H_PRE_DET_LIQ_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_MES_IX'', ''H_PRE_DET_LIQ_MES (MES_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    


  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_MES. Termina bucle', 3;   
  

  -- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_LIQ_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_PRE_DET_LIQ_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_LIQ;
  update TMP_FECHA tf set tf.TRIMESTRE_H = (select D.TRIMESTRE_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where TRIMESTRE_H not IN (select distinct TRIMESTRE_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set TRIMESTRE_ANT = (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX where TRIMESTRE_AUX > TRIMESTRE_H);
  
  
    -- Borrado indices H_PRE_DET_LIQ_TRIMESTRE
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;

 -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
    
    --Trimestre anterior
    select max(TRIMESTRE_ID) into trimestre_ant from H_PRE_DET_LIQ_TRIMESTRE where TRIMESTRE_ID < trimestre;

    -- Borrado de los trimestres a insertar
    delete from H_PRE_DET_LIQ_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;  
    
    insert INTO H_PRE_DET_LIQ_TRIMESTRE
              (
                TRIMESTRE_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                LIQUIDACION_ID,
                ESTADO_LIQUIDACION_ID,
                CONTRATO_ID,
                FECHA_SOLICITUD_LIQ,
                FECHA_RECEP_LIQ,
                FECHA_CONFIRMACION_LIQ,
                FECHA_CIERRE_LIQ,
                NUM_LIQUIDACIONES,
                CAPITAL_VENCIDO_LIQ,
                CAPITAL_NO_VENCIDO_LIQ,
                INTERESES_ORDINARIOS_LIQ,
                INTERESES_DEMORA_LIQ,
                COMISIONES_LIQ,
                GASTOS_LIQ,
                TOTAL_LIQ,
                P_LIQ_SOLICITUD_CIERRE
              )
     select trimestre,
            max_dia_trimestre,
            PROCEDIMIENTO_ID,
            LIQUIDACION_ID,
            ESTADO_LIQUIDACION_ID,
            CONTRATO_ID,
            FECHA_SOLICITUD_LIQ,
            FECHA_RECEP_LIQ,
            FECHA_CONFIRMACION_LIQ,
            FECHA_CIERRE_LIQ,
            NUM_LIQUIDACIONES,
            CAPITAL_VENCIDO_LIQ,
            CAPITAL_NO_VENCIDO_LIQ,
            INTERESES_ORDINARIOS_LIQ,
            INTERESES_DEMORA_LIQ,
            COMISIONES_LIQ,
            GASTOS_LIQ,
            TOTAL_LIQ,
            P_LIQ_SOLICITUD_CIERRE
    from H_PRE_DET_LIQ  where DIA_ID = max_dia_trimestre;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_TRIMESTRE. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;
   
       -- ESTADO_LIQ_PER_ANT_ID
    if trimestre_ant is not null then
      -- Crear indices H_PRE_DET_LIQ_TRIMESTRE      
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_TRIMESTRE_IX'', ''H_PRE_DET_LIQ_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;   
    
      merge into H_PRE_DET_LIQ_TRIMESTRE t1
      using (select PROCEDIMIENTO_ID, LIQUIDACION_ID, ESTADO_LIQUIDACION_ID from H_PRE_DET_LIQ_TRIMESTRE where TRIMESTRE_ID = trimestre_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.LIQUIDACION_ID = t2.LIQUIDACION_ID)
      when matched then update set t1.ESTADO_LIQ_PER_ANT_ID = t2.ESTADO_LIQUIDACION_ID
      where TRIMESTRE_ID = trimestre;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_TRIMESTRE. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_LIQ_TRIMESTRE
     V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;        
    end if;   
    
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;

    -- Crear indices H_PRE_DET_LIQ_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_TRIMESTRE_IX'', ''H_PRE_DET_LIQ_TRIMESTRE (TRIMESTRE_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
    commit;    
    
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_TRIMESTRE. Termina bucle', 3;
  
  
-- ----------------------------------------------------------------------------------------------
--                                      H_PRE_DET_LIQ_ANIO
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max d�a anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_PRE_DET_LIQ_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
  
  insert into TMP_FECHA (DIA_H) select distinct(DIA_ID) from H_PRE_DET_LIQ;
  update TMP_FECHA tf set tf.ANIO_H = (select D.ANIO_ID from D_F_DIA D where tf.DIA_H = D.DIA_ID);
  delete from TMP_FECHA where ANIO_H not IN (select distinct ANIO_AUX from TMP_FECHA_AUX);
  update TMP_FECHA set ANIO_ANT = (select min(ANIO_AUX) from TMP_FECHA_AUX where ANIO_AUX > ANIO_H);
  
  -- Borrado indices H_PRE_DET_LIQ_ANIO
 V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
  commit;
    
  -- Bucle que recorre los aï¿½os
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
    
    --Año anterior
    select max(ANIO_ID) into anio_ant from H_PRE_DET_LIQ_ANIO where ANIO_ID < anio;
        
    -- Borrado de loa aï¿½os a insertar
    delete from H_PRE_DET_LIQ_ANIO where ANIO_ID = anio;
    commit;
  
    insert INTO H_PRE_DET_LIQ_ANIO
              (
                ANIO_ID,
                FECHA_CARGA_DATOS,
                PROCEDIMIENTO_ID,
                LIQUIDACION_ID,
                ESTADO_LIQUIDACION_ID,
                CONTRATO_ID,
                FECHA_SOLICITUD_LIQ,
                FECHA_RECEP_LIQ,
                FECHA_CONFIRMACION_LIQ,
                FECHA_CIERRE_LIQ,
                NUM_LIQUIDACIONES,
                CAPITAL_VENCIDO_LIQ,
                CAPITAL_NO_VENCIDO_LIQ,
                INTERESES_ORDINARIOS_LIQ,
                INTERESES_DEMORA_LIQ,
                COMISIONES_LIQ,
                GASTOS_LIQ,
                TOTAL_LIQ,
                P_LIQ_SOLICITUD_CIERRE
              )
     select anio,
            max_dia_anio,
            PROCEDIMIENTO_ID,
            LIQUIDACION_ID,
            ESTADO_LIQUIDACION_ID,
            CONTRATO_ID,
            FECHA_SOLICITUD_LIQ,
            FECHA_RECEP_LIQ,
            FECHA_CONFIRMACION_LIQ,
            FECHA_CIERRE_LIQ,
            NUM_LIQUIDACIONES,
            CAPITAL_VENCIDO_LIQ,
            CAPITAL_NO_VENCIDO_LIQ,
            INTERESES_ORDINARIOS_LIQ,
            INTERESES_DEMORA_LIQ,
            COMISIONES_LIQ,
            GASTOS_LIQ,
            TOTAL_LIQ,
            P_LIQ_SOLICITUD_CIERRE
    from H_PRE_DET_LIQ  where DIA_ID = max_dia_anio;

    V_ROWCOUNT := sql%rowcount;     
    commit;
    
    --Log_Proceso
    execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_ANIO. Registros insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    commit;
    
    -- ESTADO_LIQ_PER_ANT_ID
    if anio_ant is not null then
      -- Crear indices H_PRE_DET_LIQ_ANIO      
      V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_ANIO_IX'', ''H_PRE_DET_LIQ_ANIO (ANIO_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
      commit;   
    
      merge into H_PRE_DET_LIQ_ANIO t1
      using (select PROCEDIMIENTO_ID, LIQUIDACION_ID, ESTADO_LIQUIDACION_ID from H_PRE_DET_LIQ_ANIO where ANIO_ID = anio_ant) t2
      on (t1.PROCEDIMIENTO_ID = t2.PROCEDIMIENTO_ID and t1.LIQUIDACION_ID = t2.LIQUIDACION_ID)
      when matched then update set t1.ESTADO_LIQ_PER_ANT_ID = t2.ESTADO_LIQUIDACION_ID
      where ANIO_ID = anio;    
  
      V_ROWCOUNT := sql%rowcount;     
      commit;          
      
      --Log_Proceso
      execute immediate 'BEGIN insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_ANIO. Registros modificados para ESTADO_DOCUMENTO_PER_ANT_ID: ' || TO_CHAR(V_ROWCOUNT), 4;    

      -- Borrado indices H_PRE_DET_LIQ_ANIO
       V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_PRE_DET_LIQ_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
        execute immediate V_SQL USING OUT O_ERROR_STATUS;
      commit;        
    end if;   
    
  end loop C_ANIO_LOOP;
  close c_anio;

    -- Crear indices H_PRE_DET_LIQ_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_PRE_DET_LIQ_ANIO_IX'', ''H_PRE_DET_LIQ_ANIO (ANIO_ID, PROCEDIMIENTO_ID, LIQUIDACION_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
            execute immediate V_SQL USING OUT O_ERROR_STATUS;
			
    commit; 

  --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_PRE_DET_LIQ_ANIO. Termina bucle', 3;
      
   --Log_Proceso
  execute immediate 'BEGIN Insertar_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;           

end;
    
END CARGAR_H_PRE_DET_LIQ;