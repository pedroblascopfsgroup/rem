create or replace PROCEDURE CARGAR_H_CNT_DET_INCI (DATE_START IN date, DATE_END IN date, O_ERROR_STATUS OUT VARCHAR2) AS 
-- ===============================================================================================
-- Autor: Gonzalo Martín, PFS Group
-- Fecha creación: Mayo 2015
-- Responsable ultima modificacion: Diego Pérez, PFS Group
-- Fecha ultima modificacion: 11/08/2015
-- Motivos del cambio: Usuario/Propietario
-- Cliente: Recovery BI Bankia
--
-- Descripción: Procedimiento almancenado que carga las tablas hechos CARGAR_H_CNT_DET_INCI.
-- ===============================================================================================
BEGIN
DECLARE
-- ===============================================================================================
--                  									Declaracación de variables
-- ===============================================================================================
  V_NOMBRE VARCHAR2(50) := 'CARGAR_H_CONTRATO';
  V_ROWCOUNT NUMBER;
  
  V_NUM_ROW NUMBER(10);
  V_DATASTAGE VARCHAR2(100);
  V_NUMBER  NUMBER(16,0);
  nCount NUMBER;
  V_SQL VARCHAR2(16000);

  formato_fecha VARCHAR2(100);

  min_dia_semana date;
  max_dia_semana date;
  min_dia_mes date;
  max_dia_mes date;
  min_dia_trimestre date;
  max_dia_trimestre date;
  min_dia_anio date;
  max_dia_anio date;
  max_dia_carga date;
  dia_periodo_ant date;
  semana_periodo_ant int;
  mes_periodo_ant int;
  trimestre_periodo_ant int;
  anio_periodo_ant int;
  hay_datos int;
  primer_dia_mes date;
  fecha_inicio_campana_recobro date;
  fecha_recobro date;
  fecha_especializada date;
  semana int;
  mes int;
  trimestre int;
  anio int;
  fecha date;
  fecha_anterior date;
  fecha_rellenar date;
  
  max_dia_h date;
  max_dia_mov date;
  penult_dia_mov date;
  max_dia_con_contratos date;

  max_dia_enviado_agencia date;
  max_dia_enviado_cobro date;
  f_cobro date;
  max_fecha_cobro date;

  cursor c_fecha is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_fecha_rellenar is select distinct(DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  
  cursor c_fecha_en_recobro is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  cursor c_fecha_especializada is select distinct (DIA_ID) from D_F_DIA where DIA_ID between DATE_START and DATE_END;   
  
  cursor c_semana is select distinct SEMANA_H from TMP_FECHA ORDER BY 1;
  cursor c_mes is select distinct MES_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_trimestre is select distinct TRIMESTRE_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1;
  cursor c_anio is select distinct ANIO_ID from D_F_DIA  where DIA_ID between DATE_START and DATE_END ORDER BY 1; 

  cursor c_fecha_cobro is select distinct FECHA_COBRO from TMP_H_CNT_DET_COBRO order by 1;

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

-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_INCI
-- ----------------------------------------------------------------------------------------------
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Empieza ' || V_NOMBRE, 2;

  select valor into V_DATASTAGE from PARAMETROS_ENTORNO where parametro = 'ESQUEMA_DATASTAGE';
  select valor into formato_fecha from PARAMETROS_ENTORNO where parametro = 'FORMATO_FECHA_DDMMYY';
    
-- ----------------------------- Loop fechas a cargar -----------------------------
  open c_fecha;
  loop --READ_LOOP
    fetch c_fecha into fecha;        
    exit when c_fecha%NOTFOUND;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI. Empieza Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;

    -- Borrando indices TMP_CNT_DET_INCI
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''TMP_CNT_DET_INCI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_CNT_DET_INCI'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;    

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_INCI. Truncado de tabla y borrado de índices', 4;
    
    execute immediate 'insert /*+ APPEND PARALLEL(CONTRATO_ID_1, 16) PQ_DISTRIBUTE(CONTRATO_ID_1, NONE) */ into TMP_CNT_DET_INCI 
         (DIA_ID,
          FECHA_CARGA_DATOS,
          INCIDENCIA_ID,
          CONTRATO_ID,
          FECHA_INCIDENCIA,
          TIPO_INCIDENCIA_ID,
          SITUACION_INCIDENCIA_ID,
          NUM_INCIDENCIAS
        )
     select ''' || fecha || ''',
         ''' || fecha || ''',
         IEX_ID,
         NVL(CNT_ID, -1),
         TRUNC(FECHACREAR),
         NVL(DD_TII_ID,- 1),
         NVL(DD_SII_ID,- 1),
         1   
    from  ' || V_DATASTAGE || '.IEX_INCIDENCIA_EXPEDIENTE 
    where TRUNC(FECHACREAR) = ''' || fecha || ''' and BORRADO = 0';
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'TMP_CNT_DET_INCI. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;    
    
    -- Crear indices TMP_CNT_DET_INCI
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''TMP_CNT_DET_INCI_IX'', ''TMP_CNT_DET_INCI (DIA_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    merge into TMP_CNT_DET_INCI a
    using (select CONTRATO_ID, DIA_ID, ESQUEMA_CONTRATO_ID, SUBCARTERA_EXPEDIENTE_CNT_ID, AGENCIA_CONTRATO_ID, ENVIADO_AGENCIA_CNT_ID from H_CNT) b
    on (b.CONTRATO_ID = a.CONTRATO_ID and b.DIA_ID = a.FECHA_INCIDENCIA)           
    when matched then update set  a.ESQUEMA_INCIDENCIA_ID = b.ESQUEMA_CONTRATO_ID,
                                  a.SUBCARTERA_INCIDENCIA_ID = b.SUBCARTERA_EXPEDIENTE_CNT_ID,
                                  a.AGENCIA_INCIDENCIA_ID = b.AGENCIA_CONTRATO_ID,
                                  a.ENVIADO_AGENCIA_INCI_ID = b.ENVIADO_AGENCIA_CNT_ID
                      where  a.DIA_ID = fecha;
    commit;
        
    -- Borrando indices H_CNT_DET_INCI
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_INCI_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
    -- Borrado del día a insertar
    delete from H_CNT_DET_INCI where DIA_ID = fecha;
    commit;
    
    insert into H_CNT_DET_INCI
         (DIA_ID,
          FECHA_CARGA_DATOS,
          INCIDENCIA_ID,
          CONTRATO_ID,
          FECHA_INCIDENCIA,
          TIPO_INCIDENCIA_ID,
          SITUACION_INCIDENCIA_ID,
          ESQUEMA_INCIDENCIA_ID,
          SUBCARTERA_INCIDENCIA_ID,
          AGENCIA_INCIDENCIA_ID,
          ENVIADO_AGENCIA_INCI_ID,
          NUM_INCIDENCIAS
        )
    select * from TMP_CNT_DET_INCI  where DIA_ID = fecha; 
    
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
    
    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI. Termina Fecha: '||TO_CHAR(fecha, 'dd/mm/yyyy'), 3;
    
    end loop;
  close c_fecha;  
 
  -- Crear indices H_CNT_DET_INCI
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_IX'', ''H_CNT_DET_INCI (DIA_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  -- -------------------------- CÁLCULO DEL RESTO DE PERIODOS ----------------------------
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_CNT'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_CNT (DIA_CNT) select distinct(DIA_ID) from H_CNT_DET_INCI;
  commit;
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_INCI_SEMANA
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_SEMANA. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (SEMANA_AUX) select distinct SEMANA_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  select max(SEMANA_ID) into V_NUMBER from H_CNT_DET_INCI_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
  if(V_NUMBER) is not null then
    insert into TMP_FECHA_AUX (SEMANA_AUX) 
    select max(SEMANA_ID) from H_CNT_DET_INCI_SEMANA where SEMANA_ID < (select min(SEMANA_AUX) from TMP_FECHA_AUX);
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

  -- Bucle que recorre las semanas
  open c_semana;
  loop --C_SEMANAS_LOOP
    fetch c_semana into semana;        
    exit when c_semana%NOTFOUND;
 
    select max(DIA_H) into max_dia_semana from TMP_FECHA where SEMANA_H = semana;
    select min(DIA_H) into min_dia_semana from TMP_FECHA where SEMANA_H = semana;
    
    -- Borrado indices H_CNT_DET_INCI_SEMANA
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_INCI_SEMANA_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;    
    
    -- Borrado de las semanas a insertar
    delete from H_CNT_DET_INCI_SEMANA where SEMANA_ID = semana;
    commit;
    
    insert into H_CNT_DET_INCI_SEMANA
        (SEMANA_ID,
         FECHA_CARGA_DATOS,
         INCIDENCIA_ID,
         CONTRATO_ID,
         FECHA_INCIDENCIA,
         TIPO_INCIDENCIA_ID,
         SITUACION_INCIDENCIA_ID,
         ESQUEMA_INCIDENCIA_ID,
         SUBCARTERA_INCIDENCIA_ID,
         AGENCIA_INCIDENCIA_ID,
         ENVIADO_AGENCIA_INCI_ID,
         NUM_INCIDENCIAS
       )
    select semana,  
        max_dia_semana,
        INCIDENCIA_ID,
        CONTRATO_ID,
        FECHA_INCIDENCIA,
        TIPO_INCIDENCIA_ID,
        SITUACION_INCIDENCIA_ID,
        ESQUEMA_INCIDENCIA_ID,
        SUBCARTERA_INCIDENCIA_ID,
        AGENCIA_INCIDENCIA_ID,
        ENVIADO_AGENCIA_INCI_ID,
        NUM_INCIDENCIAS
    from H_CNT_DET_INCI where FECHA_INCIDENCIA between min_dia_semana and max_dia_semana;
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_SEMANA. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    -- Crear indices H_CNT_DET_INCI_SEMANA    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_SEMANA_IX'', ''H_CNT_DET_INCI_SEMANA (SEMANA_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  end loop C_SEMANAS_LOOP;
close c_semana;

    --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_SEMANA. Termina bucle', 3;
  
  */
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_INCI_MES
-- ---------------------------------------------------------------------------------------------- 
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_MES. Empieza bucle', 3;


  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  
  insert into TMP_FECHA_AUX (MES_AUX) select distinct MES_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (MES_AUX) select max(MES_ID) from H_CNT_DET_INCI_MES where MES_ID < (select min(MES_AUX) from TMP_FECHA_AUX);
  
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
  
  -- Bucle que recorre los meses
  open c_mes;
  loop --C_MESES_LOOP
    fetch c_mes into mes;        
    exit when c_mes%NOTFOUND;
  
    select max(DIA_H) into max_dia_mes from TMP_FECHA where MES_H = mes;
    select min(DIA_H) into min_dia_mes from TMP_FECHA where MES_H = mes;

    -- Borrado indices H_CNT_DET_INCI_MES
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_INCI_MES_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;    
    
    -- Borrado de las semanas a insertar
    delete from H_CNT_DET_INCI_MES where MES_ID = mes;
    commit;
    
    insert into H_CNT_DET_INCI_MES
        (MES_ID,
         FECHA_CARGA_DATOS,
         INCIDENCIA_ID,
         CONTRATO_ID,
         FECHA_INCIDENCIA,
         TIPO_INCIDENCIA_ID,
         SITUACION_INCIDENCIA_ID,
         ESQUEMA_INCIDENCIA_ID,
         SUBCARTERA_INCIDENCIA_ID,
         AGENCIA_INCIDENCIA_ID,
         ENVIADO_AGENCIA_INCI_ID,
         NUM_INCIDENCIAS
       )
    select mes,  
        max_dia_mes,
        INCIDENCIA_ID,
        CONTRATO_ID,
        FECHA_INCIDENCIA,
        TIPO_INCIDENCIA_ID,
        SITUACION_INCIDENCIA_ID,
        ESQUEMA_INCIDENCIA_ID,
        SUBCARTERA_INCIDENCIA_ID,
        AGENCIA_INCIDENCIA_ID,
        ENVIADO_AGENCIA_INCI_ID,
        NUM_INCIDENCIAS
    from H_CNT_DET_INCI where FECHA_INCIDENCIA between min_dia_mes and max_dia_mes;
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_MES. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    -- Crear indices H_CNT_DET_INCI_MES  
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_MES_IX'', ''H_CNT_DET_INCI_MES (MES_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  end loop C_MESES_LOOP;
  close c_mes;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_MES. Termina bucle', 3;
  
   
-- ----------------------------------------------------------------------------------------------
--                                     H_CNT_DET_INCI_TRIMESTRE
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_TRIMESTRE. Empieza bucle', 3;
 
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
  
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select distinct TRIMESTRE_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (TRIMESTRE_AUX) select max(TRIMESTRE_ID) from H_CNT_DET_INCI_TRIMESTRE where TRIMESTRE_ID < (select min(TRIMESTRE_AUX) from TMP_FECHA_AUX);
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
  
  -- Bucle que recorre los trimestres
  open c_trimestre;
  loop --C_TRIMESTRE_LOOP
    fetch c_trimestre into trimestre;        
    exit when c_trimestre%NOTFOUND;
  
    select max(DIA_H) into max_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;
    select min(DIA_H) into min_dia_trimestre from TMP_FECHA where TRIMESTRE_H = trimestre;

    -- Borrado indices H_CNT_DET_INCI_TRIMESTRE
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_INCI_TRIMESTRE_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;    
    
    -- Borrado de los trimestres a insertar
    delete from H_CNT_DET_INCI_TRIMESTRE where TRIMESTRE_ID = trimestre;
    commit;
    
    insert into H_CNT_DET_INCI_TRIMESTRE
        (TRIMESTRE_ID,
         FECHA_CARGA_DATOS,
         INCIDENCIA_ID,
         CONTRATO_ID,
         FECHA_INCIDENCIA,
         TIPO_INCIDENCIA_ID,
         SITUACION_INCIDENCIA_ID,
         ESQUEMA_INCIDENCIA_ID,
         SUBCARTERA_INCIDENCIA_ID,
         AGENCIA_INCIDENCIA_ID,
         ENVIADO_AGENCIA_INCI_ID,
         NUM_INCIDENCIAS
       )
    select trimestre,  
        max_dia_trimestre,
        INCIDENCIA_ID,
        CONTRATO_ID,
        FECHA_INCIDENCIA,
        TIPO_INCIDENCIA_ID,
        SITUACION_INCIDENCIA_ID,
        ESQUEMA_INCIDENCIA_ID,
        SUBCARTERA_INCIDENCIA_ID,
        AGENCIA_INCIDENCIA_ID,
        ENVIADO_AGENCIA_INCI_ID,
        NUM_INCIDENCIAS
    from H_CNT_DET_INCI where FECHA_INCIDENCIA between min_dia_trimestre and max_dia_trimestre;
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_TRIMESTRE. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    -- Crear indices H_CNT_DET_INCI_TRIMESTRE  
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_TRIMESTRE_IX'', ''H_CNT_DET_INCI_TRIMESTRE (TRIMESTRE_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
   end loop C_TRIMESTRE_LOOP;
  close c_trimestre;
  
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_TRIMESTRE. Termina bucle', 3;
*/
  
-- ----------------------------------------------------------------------------------------------
--                                      H_CNT_DET_INCI_ANIO
-- ----------------------------------------------------------------------------------------------
/*
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_ANIO. Empieza bucle', 3;
  
  -- Calculamos las Fechas h (tabla hechos) y ANT (Periodo anterior)
  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;

  V_SQL :=  'BEGIN OPERACION_DDL.DDL_TABLE(''TRUNCATE'', ''TMP_FECHA_AUX'', '''', :O_ERROR_STATUS); END;';
  execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  insert into TMP_FECHA_AUX (ANIO_AUX) select distinct ANIO_ID from D_F_DIA where DIA_ID between DATE_START and DATE_END;
  -- Insert max día anterior al periodo de carga - Periodo anterior de date_start 
  insert into TMP_FECHA_AUX (ANIO_AUX) select max(ANIO_ID) from H_CNT_DET_INCI_ANIO where ANIO_ID < (select min(ANIO_AUX) from TMP_FECHA_AUX);
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
  
  -- Bucle que recorre los años
  open c_anio;
  loop --C_ANIO_LOOP
    fetch c_anio into anio;        
    exit when c_anio%NOTFOUND;
  
    select max(DIA_H) into max_dia_anio from TMP_FECHA where ANIO_H = anio;
    select min(DIA_H) into min_dia_anio from TMP_FECHA where ANIO_H = anio;
          
    -- Borrado indices H_CNT_DET_INCI_ANIO
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''DROP'', ''H_CNT_DET_INCI_ANIO_IX'', '''', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;    
    
    -- Borrado de los años a insertar
    delete from H_CNT_DET_INCI_ANIO where ANIO_ID = anio;
    commit;
    
    insert into H_CNT_DET_INCI_ANIO
        (ANIO_ID,
         FECHA_CARGA_DATOS,
         INCIDENCIA_ID,
         CONTRATO_ID,
         FECHA_INCIDENCIA,
         TIPO_INCIDENCIA_ID,
         SITUACION_INCIDENCIA_ID,
         ESQUEMA_INCIDENCIA_ID,
         SUBCARTERA_INCIDENCIA_ID,
         AGENCIA_INCIDENCIA_ID,
         ENVIADO_AGENCIA_INCI_ID,
         NUM_INCIDENCIAS
       )
    select anio,  
        max_dia_anio,
        INCIDENCIA_ID,
        CONTRATO_ID,
        FECHA_INCIDENCIA,
        TIPO_INCIDENCIA_ID,
        SITUACION_INCIDENCIA_ID,
        ESQUEMA_INCIDENCIA_ID,
        SUBCARTERA_INCIDENCIA_ID,
        AGENCIA_INCIDENCIA_ID,
        ENVIADO_AGENCIA_INCI_ID,
        NUM_INCIDENCIAS
    from H_CNT_DET_INCI where FECHA_INCIDENCIA between min_dia_anio and max_dia_anio;
    V_ROWCOUNT := sql%rowcount;     
    commit;
  
     --Log_Proceso
    execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_ANIO. Registros Insertados: ' || TO_CHAR(V_ROWCOUNT), 4;
 
    -- Crear indices H_CNT_DET_INCI_ANIO    
    V_SQL :=  'BEGIN OPERACION_DDL.DDL_INDEX(''CREATE'', ''H_CNT_DET_INCI_ANIO_IX'', ''H_CNT_DET_INCI_ANIO (ANIO_ID, FECHA_INCIDENCIA, CONTRATO_ID)'', ''S'', '''', :O_ERROR_STATUS); END;';
    execute immediate V_SQL USING OUT O_ERROR_STATUS;
    
  end loop C_ANIO_LOOP;
  close c_anio;

  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'H_CNT_DET_INCI_ANIO. Termina bucle', 3;
  */
  --Log_Proceso
  execute immediate 'BEGIN INSERTAR_Log_Proceso(:NOMBRE_PROCESO, :DESCRIPCION, :TAB); END;' USING IN V_NOMBRE, 'Termina ' || V_NOMBRE, 2;

  
  /*
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
    */
end;

end CARGAR_H_CNT_DET_INCI;